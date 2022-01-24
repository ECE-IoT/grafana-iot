#!/usr/bin/env python3
import os
from typing import OrderedDict
import ruamel.yaml

BASE_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)))
SOURCE_FILE = os.path.join(BASE_PATH, "provisioning",
                           "datasources", "sources.yaml")


def write_source_file(access, secret):
    config, ind, bsi = ruamel.yaml.util.load_yaml_guess_indent(
        open(SOURCE_FILE))

    try:
        config['datasources'][0]['secureJsonData'] = {
            'accessKey': access, 'secretKey': secret}

        yaml = ruamel.yaml.YAML()
        yaml.indent(mapping=ind, sequence=ind, offset=bsi)

        with open(SOURCE_FILE, 'w') as file:
            yaml.dump(config, file)

    except yaml.YAMLError as err:
        print(err)


def replace_at_index(tup, index, value):
    lst = list(tup)
    lst[index] = value
    return OrderedDict(lst)


def gather_input():
    access_key = input('Access Key: ')
    secret_key = input('Secret Key: ')
    write_source_file(access_key, secret_key)


if __name__ == "__main__":
    gather_input()
