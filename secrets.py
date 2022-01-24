#!/usr/bin/env python3

import os
import yaml

BASE_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)))
SOURCE_FILE = os.path.join(BASE_PATH, "provisioning",
                           "datasources", "sources.yaml")


def write_source_file(access, secret):
    with open(SOURCE_FILE) as file:
        try:
            config = yaml.safe_load(file)

            config['datasources'][0]['accessKey'] = access
            config['datasources'][0]['secretKey'] = secret

            with open(SOURCE_FILE, 'w') as file:
                yaml.dump(config, file)

        except yaml.YAMLError as err:
            print(err)


def gather_input():
    access_key = input('Access Key: ')
    secret_key = input('Secret Key: ')
    write_source_file(access_key, secret_key)


if __name__ == "__main__":
    gather_input()
