import os
import subprocess
from pathlib import Path
from bigflow.version import get_version, release
from bigflow.commons import now, resolve

NOW = now(template="%Y-%m-%d %H:00:00")
START_TIME = os.environ.get('bamboo_bf_start_time', NOW) or NOW
WORKFLOW_ID = os.environ.get('bamboo_bf_workflow_id', None)


def build_command():
    base_command = 'bf build'
    if START_TIME:
        base_command += f' --start-time "{START_TIME}"'

    if WORKFLOW_ID:
        base_command += f' --workflow {WORKFLOW_ID}'

    print(base_command)
    return base_command


def release_version_if_on_master():
    if is_master():
        print('On master. Releasing version.')
        pem_path = resolve(Path(__file__).parent / 'repositoryKey.pem')
        print(pem_path)
        release(identity_file=pem_path)


def is_master() -> bool:
    return subprocess.getoutput('git rev-parse --abbrev-ref HEAD') == 'master'


def get_bamboo_release_version():
    package_version = get_version()
    start_time = START_TIME \
        .replace(':', '_') \
        .replace('-', '_') \
        .replace(' ', '_')

    version = f'{package_version}_{start_time}'
    if WORKFLOW_ID:
        version += WORKFLOW_ID

    print(version)
    return version
