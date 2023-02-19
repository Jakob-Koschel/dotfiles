#!/usr/bin/env python3

import pathlib
import json

template_config = {
        "host": "",
        "port": 993,
        "tls": True,
        "tlsOptions": { },
        "username": "",
        "password": "",
        "passwordCmd": "",
        "xoauth2": False,
        "onNewMail": "",
        "onNewMailPost": "",
        "wait": 20,
        "boxes": [
            "INBOX"
            ]
        }

def parse_mbsync_rc():
    home_path = pathlib.Path.home()
    mbsync_rc = {}
    with open(f'{home_path}/.mbsyncrc', 'r') as f:
        content = f.read().split('\n\n')
        for c in content:
            if 'IMAPStore ' in c:
                c = [line.rstrip() for line in c.split('\n')]
                obj = {}
                for line in c:
                    if len(line) == 0:
                        continue
                    key, value = line.split(' ', 1)
                    obj[key] = value

                obj["Port"] = int(obj["Port"])
                if obj["PassCmd"][0] == '"':
                    obj["PassCmd"] = obj["PassCmd"][1:-1]
                mbsync_rc[obj['User']] = obj
    return mbsync_rc

def main():
    home_path = pathlib.Path.home()
    pathlib.Path(f"{home_path}/.goimapnotify").mkdir(parents=True, exist_ok=True)

    mbsync_rc = parse_mbsync_rc()

    for user in mbsync_rc:
        mb_conf = mbsync_rc[user]

        account_config = template_config.copy()

        account_config['username'] = user
        account_config['host'] = mb_conf['Host']
        account_config['port'] = mb_conf['Port']
        account_config['passwordCmd'] = mb_conf['PassCmd']
        account_config['onNewMail'] = f'mw -y {user}'
        account_config['onNewMailPost'] = 'hs -c "spoon.MuttWizard.checkEmailUnread()"'

        with open(f'{home_path}/.goimapnotify/{user}.goimapnotify', 'w') as f:
            f.write(json.dumps(account_config, indent=4))


if __name__ == '__main__':
    main()
