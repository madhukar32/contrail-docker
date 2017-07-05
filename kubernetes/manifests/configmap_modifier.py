import os
import re
import sys
import ConfigParser
import time
import requests
import logging
import StringIO

def CreateLogger(name=None, log_level='DEBUG'):
    '''  Returns logger '''
    # Create logger
    logger = logging.getLogger(name)
    logger.setLevel(log_level)

    # Create handler
    ch = logging.StreamHandler()
    ch.setLevel(logging.DEBUG)
    formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s -
                                  %(message)s')

    # Set the formatter and add the handler
    ch.setFormatter(formatter)
    logger.addHandler(ch)

    return logger



class ContrailCMModifier(object):
    ''' Modifies the ConfigMap of contrail before starting the contrail
    container '''

    CONFIG_MAP_TAG = '/api/v1/'
    GLOBAL_SECTION = 'GLOBAL'

    def __init__(**kwargs):

        self.cm_name = kwargs.get('name',  'contrail-config')
        self.log_level = kwargs.get('log_level', 'DEBUG')
        self.auth_dir = kwargs.get('auth_dir',
                                   '/var/run/secrets/kubernetes.io/serviceaccount')

        self.logger =  CreateLogger(name=self.__name__,
                                    log_level=self.log_level)

        try:
            self.contrail_role = os.environ['contrail-role']
            self.pod_ip  = os.environ['podIp']
        except KeyError:
            self.logger.critical('environment variable
                                 contrail-role/podIp not set')
            sys.exit(1)

        self.token = self._get_token()
        self.auth_header = {'Authorization': "Bearer " + self.token}
        self.headers = {'Connection': 'Keep-Alive'}
        self.headers.update(auth_header)


        self.verify = self.auth_dir + 'ca.crt'

    def _get_token(self):
        ''' returns token '''

        token_file = self.auth_dir + 'token'
        try:
            tf = open(token_file)
            token = tf.read()
            tf.close()
            return  token
        except Exception as e:
            self.logger.critical('not able to find token file, make sure code
                                 is running in a pod')
            sys.exit(1)

    def _get_url(common=None, namespace=None, name=None, resource=None):
        ''' Returns k8s api url '''

        if not common or not resource:
            return None
        common = 'https://kubernetes.default' + common

        if not namespace:
            return common + resource

        if not name:
            return common + 'namespaces/' + namespace + '/' + resource

        return common + 'namespaces/' + namespace + '/' + resource + '/' name


    def _get_config_map(self, namespace=None, name=None):
        ''' Returns json data of the configmap '''

        cm_url  = self._get_url(common=CONFIG_MAP_TAG, namespace=namespace,
                                resource='configmaps', name=name)

        headers = {'Connection': 'Keep-Alive'}
        headers.update(auth_header)

        resp = requests.get(cm_url, headers=headers, verify=self.verify)

        if resp.status_code == 200:
            return resp.json()
        else:
            self.logger.critical('response error code: {0}, while getting url:
                                 {1}'.format(resp.status_code, cm_url))
            sys.exit(1)

    def update_podip_contrail_cm(self, name=None, namespace=None):
        ''' Updating the podIp in contrail_cm  before starting the provisioning '''

        contrail_cm_data = self._get_config_map(name=name, namespace=namespace)
        try:
            global_config_buf = StringIO.StringIO(contrail_cm_data['data']['global-config'])
        except KeyError:
            self.logger.critical('ConfigMap {0} does not have global-config
                                 data'.format(name))
            sys.exit(1)

        global_config = ConfigParser.ConfigParser()
        global_config.readfp(global_config_buf)

        option = self.contrail_role + '_nodes'
        if global_config.has_section(GLOBAL_SECTION):
            try:
                contrail_nodes = global_config.get(GLOBAL_SECTION, option)
                contrail_list = re.split(r',[, ]+', contrail_nodes)
                contrail_list.append(self.pod_ip)
                contrail_nodes = ','.join(contrail_list)
            except ConfigParser.NoOptionError:
                global_config.set(GLOBAL_SECTION, option, self.pod_ip)

            global_config.write(global_config_buf)
            contrail_cm_data['data']['global-config'] = global_config_buf.getvalue()

            contrail_patch_cm = json.dumps(contrail_cm_data)
            self._patch_config_map(name=name, namespace=namespace,
                                             data=contrail_patch_cm)

    def start_contrail_ansible(self, 

    def _patch_config_map(self, name=None, namespace=None,
                      data=None):

        cm_url  = self._get_url(common=CONFIG_MAP_TAG, namespace=namespace,
                                resource='configmaps', name=name)

        headers = {'Accept': 'application/json', \
                   'Content-Type': 'application/strategic-merge-patch+json'}
        headers.update(self.headers)
        resp = requests.patch(cm_url, headers=headers, data=data,
                              verify=self.verify)

        if resp.status_code == 200:
            self.logger.info("Successfully updated contrail config map:
                             {0}".format(name))
        else:
            self.logger.critical('response error code: {0}, while patching
                                 resource: {1}'.format(resp.status_code, cm_url)
            sys.exit(1)

