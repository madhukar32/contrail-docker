import os
import re
import sys
import ConfigParser
import requests
import logging
import StringIO
import json
import time
import subprocess

def CreateLogger(name=None, log_level='DEBUG'):
    '''  Returns logger '''
    # Create logger
    logger = logging.getLogger(name)
    logger.setLevel(log_level)

    # Create handler
    ch = logging.StreamHandler()
    ch.setLevel(logging.DEBUG)
    formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')

    # Set the formatter and add the handler
    ch.setFormatter(formatter)
    logger.addHandler(ch)

    return logger

class ContrailCMModifier(object):
    ''' Modifies the ConfigMap of contrail before starting the contrail
    container '''

    CONF_DIR = '/tmp/contrailctl/'
    AUTH_DIR = '/var/run/secrets/kubernetes.io/serviceaccount/'

    CORE_V1 = '/api/v1/'
    EXTENSIONS_V1_BETA = '/apis/extensions/v1beta1/'

    CM_NAME = 'contrail-config'
    GLOBAL_SECTION = 'GLOBAL'
    GLOBAL_CONFIG = 'global-config'
    KUBEMANAGER_CONFIG = 'kubemanager-config'
    AGENT_CONFIG = 'agent-config'

    ROLE_LIST = ['controller', 'analytics', 'analyticsdb']
    K8S_API_PORT = '6443'

    def __init__(self, **kwargs):


        self.logger =  CreateLogger(name=self.__class__.__name__,
                                    log_level='DEBUG')

        file_name = self.CONF_DIR + self.KUBEMANAGER_CONFIG
        self.namespace = self._get_auth_dir_resource('namespace')
        self.k8s_api_server = self._get_value_from_conf(section='KUBERNETES',
                                                       option='api_server',
                                                       file_name=file_name)

        try:
            self.contrail_role = os.environ['contrail_role']
            self.pod_ip  = os.environ['podIp']
        except KeyError:
            self.logger.critical('environment variable contrail-role/podIp not set')
            sys.exit(1)

        #
        self.token = self._get_auth_dir_resource('token')
        self.auth_header = {'Authorization': "Bearer " + self.token}
        self.headers = {'Connection': 'Keep-Alive'}
        self.headers.update(self.auth_header)
        self.verify = False

    def _get_value_from_conf(self,file_name=None, option=None, section=None):

        config = ConfigParser.ConfigParser()
        config.read(file_name)
        return config.get(section, option)

    def _get_auth_dir_resource(self, resource):
        ''' returns token '''

        file_name = self.AUTH_DIR + resource
        try:
            tf = open(file_name)
            resource_value = tf.read()
            tf.close()
            return  resource_value
        except Exception as e:
            self.logger.critical('not able to find token/namespace file, make sure code is running in pod')
            sys.exit(1)

    def _get_url(self, common=None, namespace=None, name=None,
                 resource=None):
        ''' Returns k8s api url '''

        if not common or not resource:
            return None

        common = 'https://' + self.k8s_api_server + ':' + self.K8S_API_PORT  +  common

        if not namespace:
            return common + resource

        if not name:
            return common + 'namespaces/' + namespace + '/' + resource

        return common + 'namespaces/' + namespace + '/' + resource + '/' + name


    def _get_config_map(self, namespace=None, name=None):
        ''' Returns json data of the configmap '''

        cm_url  = self._get_url(common=self.CORE_V1, namespace=namespace,
                                resource='configmaps', name=name)
        resp = requests.get(cm_url, headers=self.headers, verify=self.verify)

        if resp.status_code == 200:
            return resp.json()
        else:
            self.logger.critical('response error code: {0}, while getting url: {1}'.format(resp.status_code, cm_url))
            sys.exit(1)

    def _get_data_config_object(self, global_config_data):

        ''' return global_config string buffer and self.GLOBAL_CONFIG parser object
        '''

        data_config_fp = StringIO.StringIO(global_config_data)
        data_config = ConfigParser.ConfigParser()
        data_config.readfp(data_config_fp)
        return data_config, data_config_fp

    def _write_data_to_fp(self, config=None, fp=None):

        if not fp:
            new_config_fp = StringIO.StringIO()
        else:
            new_config_fp = fp

        config.write(new_config_fp)
        return new_config_fp

    def _get_data_from_cm(self, cm_data,data_name):
        ''' return global_config_data from the conifgmap '''

        try:
            data_value = cm_data['data'][data_name]
        except KeyError:
            self.logger.info('ConfigMap {0} does not have {1} data'.format(self.CM_NAME, data_name))
            data_value = ''
        return data_value

    def _get_cm_data_as_object(self, data_name, **kwargs):

        contrail_cm_data = self._get_config_map(**kwargs)

        data = self._get_data_from_cm(contrail_cm_data,
                                                   data_name)

        data_config, data_fp =  self._get_data_config_object(data)
        return data_config, data_fp, contrail_cm_data

    def update_podip_contrail_cm(self, **kwargs):
        ''' Updating the podIp in contrail_cm  before starting the provisioning '''

        global_config, _, contrail_cm_data = self._get_cm_data_as_object(self.GLOBAL_CONFIG, **kwargs)

        if not global_config.sections():
            sys.exit(1)

        option = self.contrail_role + '_nodes'
        if global_config.has_section(self.GLOBAL_SECTION):
            try:
                contrail_nodes = global_config.get(self.GLOBAL_SECTION, option)
                contrail_list = re.split(r',[, ]+', contrail_nodes)
                if not self.pod_ip in contrail_list:
                    contrail_list.append(self.pod_ip)
                contrail_nodes = ','.join(contrail_list)
            except ConfigParser.NoOptionError:
                global_config.set(self.GLOBAL_SECTION, option, self.pod_ip)

            global_config_buf = self._write_data_to_fp(config=global_config)
            contrail_cm_data['data'][self.GLOBAL_CONFIG] = global_config_buf.getvalue()

            contrail_patch_cm = json.dumps(contrail_cm_data)
            kwargs['data'] = contrail_patch_cm
            self._patch_config_map(**kwargs)

    def _get_desired_number_scheduled(self, resource_name=None, resource=None,
                                      namespace=None):

        url  = self._get_url(common=self.EXTENSIONS_V1_BETA, namespace=namespace,
                                resource=resource, name=resource_name)

        resp = requests.get(url, headers=self.headers, verify=self.verify)

        if resp.status_code == 200:
            resource_data = resp.json()
            return resource_data['status']['desiredNumberScheduled']
        else:
            self.logger.critical('response error code: {0}, while getting url:{1}'.format(resp.status_code, url))
            sys.exit(1)


    def _verify_configmap_update(self, **kwargs):

        global_config, _, _ = self._get_cm_data_as_object(self.GLOBAL_CONFIG, **kwargs)

        cm_updated = True

        for contrail_role in self.ROLE_LIST:
            resource_name =  'contrail-' + self.contrail_role
            desired_number = self._get_desired_number_scheduled(resource_name=resource_name,
                                           resource='daemonsets',
                                           namespace=self.namespace)

            option = contrail_role + '_nodes'
            try:
                nodes = global_config.get(self.GLOBAL_SECTION, option)
                contrail_list = re.split(r',[, ]+', nodes)
            except ConfigParser.NoOptionError:
                return False

            if len(contrail_list) == desired_number:
                continue
            else:
                cm_updated = False
                break

        return cm_updated

    def wait_for_cm_update(self, **kwargs):

        success = False
        for count in range(10):
            cm_update_successful = self._verify_configmap_update(**kwargs)
            if not cm_update_successful:
                self.logger.info('Waiting for few seconds before verifying configmap')
                time.sleep(30)
                continue
            else:
                success = True
                break

        if not success:
            self.logger.critical('Timeout waiting for configmap to be in sync')
            sys.exit(1)

    def _patch_config_map(self, name=None, namespace=None,
                      data=None):

        cm_url  = self._get_url(common=self.CORE_V1, namespace=namespace,
                                resource='configmaps', name=name)

        headers = {'Accept': 'application/json', \
                   'Content-Type': 'application/strategic-merge-patch+json'}
        headers.update(self.headers)
        resp = requests.patch(cm_url, headers=headers, data=data, verify=self.verify)

        if resp.status_code == 200:
            self.logger.info("Successfully updated contrail config map: {0}".format(name))
        else:
            self.logger.critical('response error code: {0}, while patching resource: {1}'.format(resp.status_code,cm_url))
            sys.exit(1)

    def start_contrail_cm_update(self, **kwargs):
        ''' '''
        kwargs = {}
        kwargs['name'] = self.CM_NAME
        kwargs['namespace'] = self.namespace

        if self.contrail_role != 'kubemanager' or self.contrail_role != 'agent':
            self.update_podip_contrail_cm(**kwargs)

        self.wait_for_cm_update(**kwargs)
        self.create_contrailctl_config_file(**kwargs)
        self.start_contrail_entrypoint()

    def create_contrailctl_config_file(self, **kwargs):

        new_data_name = self.contrail_role + '.conf'

        contrail_config, _, _ = self._get_cm_data_as_object(new_data_name, **kwargs)
        if not contrail_config.sections():
            self.logger.info('Started building missing data {0} in configmap {1}'.format(new_data_name, self.CM_NAME))
            global_config, global_fp, contrail_cm_data = self._get_cm_data_as_object(self.GLOBAL_CONFIG,
                                                       **kwargs)
            contrail_conf_file = self.CONF_DIR + new_data_name
            contrail_fp = open(contrail_conf_file, 'a')
            global_config.write(contrail_fp)

            role_config = False

            if self.contrail_role == 'kubemanager':
                role_config = self._get_cm_data_as_object(self.KUBEMANAGER_CONFIG,
                                                           **kwargs)
                role_config.set(self.KUBEMANAGER_CONFIG, 'token', self.token)
                #data_config_fp =
                #self._write_data_to_fp(config=role_config,fp=global_fp)

            elif self.contrail_role == 'agent':

                #agent_conf_file = self.CONF_DIR + new_data_name
                #global_config.write(agent_fp)
                role_config = self._get_cm_data_as_object(self.AGENT_CONFIG,
                                                          **kwargs)
                role_config.set(self.AGENT_CONFIG, 'ctrl_data_ip' ,self.pod_ip)

            if role_config:
                role_config.write(contrail_fp)

            contrail_fp.close()
            #if not role_config:
            #    data_config_fp = self._write_data_to_fp(config=global_config) 
            #else:
            #    data_config_fp = self._write_data_to_fp(config=role_config,fp=global_fp)

            #contrail_cm_data['data'][new_data_name] = data_config_fp.getvalue()
            #contrail_patch_cm = json.dumps(contrail_cm_data)
            #kwargs['data'] = contrail_patch_cm
            #self._patch_config_map(**kwargs)

    def start_contrail_entrypoint(self):

        init_system = os.environ['init_system']
        self.logger.info('start contrail init system: {0}'.format(init_system))
        if init_system == 'systemd':
            self.logger.info('{0}'.format(subprocess.check_output(['/sbin/init'])))
        elif init_system == 'supervisord':
            self.logger.info('{0}'.format(subprocess.check_output(['/entrypoint.sh'])))

if __name__ == '__main__':
    cm = ContrailCMModifier()
    cm.start_contrail_cm_update()

