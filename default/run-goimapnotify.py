#!/usr/bin/env python3

from glob import glob
import pathlib
import subprocess
from time import sleep
from multiprocessing import Process


running = {}

def worker(config_path):
    home_path = pathlib.Path.home()
    while True:
        result = subprocess.run([f'{home_path}/go/bin/goimapnotify',
                                 '-conf', config_path], stdout=subprocess.PIPE)
        output = result.stdout.splitlines()
        print('output: ', output)

        sleep(60)


def start_server(mail_address, config_path):
    p = Process(target=worker, args=(config_path,))
    p.start()
    running[mail_address]= p


if __name__ == '__main__':
    configs = {}

    home_path = pathlib.Path.home()
    for f in glob(f'{home_path}/.goimapnotify/*.goimapnotify'):
        mail_address = pathlib.Path(f).stem
        configs[mail_address] = f

    for mail_address in configs:
        start_server(mail_address, configs[mail_address])

    while True :
        for mail_address in running:
            if not running[mail_address].is_alive():
                start_server(mail_address, configs[mail_address])
        sleep(60)
