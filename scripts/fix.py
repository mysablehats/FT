#!/usr/bin/env python
# -*- coding: utf-8 -*-
import shutil
import sys
import tarfile
import tempfile
from sh import wget
import os
import yaml

FILE_PATH = os.path.dirname(os.path.realpath(__file__))


def read_yaml(path):
    with open(path, 'rt') as f:
        data = yaml.safe_load(f)
    return data


def write_yaml(path, data):
    with open(path, 'wt') as f:
        yaml.safe_dump(data, f, default_flow_style=False)


def extract_github_tar_gz(data):
    for entry in data:
        if 'tar' not in entry:
            continue
        tar = entry['tar']
        if 'github.com' not in tar['uri'] or not tar['uri'].endswith('.tar.gz'):
            continue
        version = tar['uri'][tar['uri'].rindex('/') + 1: -len('.tar.gz')]
        if not tar['version'].endswith(version):
            continue
        yield tar, version


def download_file(url, path):
    wget(
        '--progress=dot:meg', '-O', path, url, _out=sys.stdout, _err=sys.stderr
    )


def check_tar_gz_version(path, version):
    with tarfile.open(path, 'r:gz') as f:
        name = f.getmembers()[0].name
    return name.endswith(version)


def github_bug_workaround(rosinstall, rosinstall_out):
    tmp_dir = tempfile.mkdtemp()
    data = read_yaml(rosinstall)
    for entry, version in extract_github_tar_gz(data):
        file_name = os.path.join(tmp_dir, 'tmp.tar.gz')
        download_file(entry['uri'], file_name)
        has_version = check_tar_gz_version(file_name, version)
        os.remove(file_name)
        if not has_version:
            entry['version'] = entry['version'][: -(len(version) + 1)]

    write_yaml(rosinstall_out, data)

    shutil.rmtree(tmp_dir)


if __name__ == '__main__':
    rosinstall_out = os.path.join(FILE_PATH, 'kinetic-ros_comm-wet-fixed.rosinstall')
    rosinstall = os.path.join(FILE_PATH, 'kinetic-ros_comm-wet.rosinstall')
    github_bug_workaround(rosinstall, rosinstall_out)

