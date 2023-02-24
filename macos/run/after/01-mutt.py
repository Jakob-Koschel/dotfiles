#!/usr/bin/env python3

import os
import pathlib
import subprocess
import dotenv
from collections import OrderedDict

def parse_mbsync_rc():
    home_path = pathlib.Path.home()
    mbsync_rc = OrderedDict()
    with open(f'{home_path}/.mbsyncrc', 'r') as f:
        content = f.read().split('\n\n')
        for c in content:
            if 'IMAPStore ' in c:
                c = [line.rstrip() for line in c.split('\n')]
                obj = OrderedDict()
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

def parse_msmtp_rc():
    home_path = pathlib.Path.home()
    msmtp_rc = OrderedDict()
    with open(f'{home_path}/.msmtprc', 'r') as f:
        content = f.read().split('\n\n')
        for c in content:
            if c == '':
                continue
            c = [line.rstrip() for line in c.split('\n')]
            obj = OrderedDict()
            for line in c:
                if len(line) == 0:
                    continue
                if ' ' in line:
                    key, value = line.split(' ', 1)
                elif '\t':
                    key, value = line.split('\t', 1)
                else:
                    raise Exception("invalid line")
                obj[key] = value

            msmtp_rc[obj['account']] = obj
    return msmtp_rc

def write_mbsync_rc(mbsync_rc):
    home_path = pathlib.Path.home()
    output = []
    with open(f'{home_path}/.mbsyncrc', 'r') as f:
        content = f.read().split('\n\n')
        for c in content:
            if 'IMAPStore ' in c:
                c = [line.rstrip() for line in c.split('\n')]
                username = ''
                for line in c:
                    if len(line) == 0:
                        continue
                    key, value = line.split(' ', 1)
                    if key == 'User':
                        username = value

                if username == '':
                    output.append(c)
                    continue

                conf = mbsync_rc[username]
                mb_conf_str = []
                for key, value in conf.items():
                    mb_conf_str.append(f'{key} {value}')
                output.append('\n'.join(mb_conf_str))
            else:
                output.append(c)
    with open(f'{home_path}/.mbsyncrc', 'w') as f:
        f.write('\n\n'.join(output))

def write_msmtp_rc(msmtp_rc):
    home_path = pathlib.Path.home()
    output = []

    for user in msmtp_rc:
        conf = msmtp_rc[user]
        conf_str = []
        for key, value in conf.items():
            conf_str.append(f'{key} {value}')
        output.append('\n'.join(conf_str))

    with open(f'{home_path}/.msmtprc', 'w') as f:
        f.write('\n\n'.join(output))
        f.write('\n\n')

def main():
    home_path = pathlib.Path.home()
    mutt_oauth2_path = pathlib.Path('../../../default/mutt_oauth2.py').resolve()

    if not pathlib.Path(f"{home_path}/.mbsyncrc").is_file():
        print("goimapnotify: .mbsyncrc doesn't exist, ignore")
        return

    dotenv_path = '../../../.config'
    dotenv.load_dotenv(dotenv_path)

    gpg_public_key = os.environ.get('DOTFILES_GPG_PUBLIC_KEY')
    if not gpg_public_key:
        gpg_public_key = input('Please enter the gpg public key: ')
        dotenv.set_key(dotenv_path, 'DOTFILES_GPG_PUBLIC_KEY', gpg_public_key)

    pathlib.Path(f"{home_path}/.config/mutt/tokens").mkdir(parents=True, exist_ok=True)

    mbsync_rc = parse_mbsync_rc()

    for user in mbsync_rc:
        mb_conf = mbsync_rc[user]

        if mb_conf['Host'] == 'imap.gmail.com':
            provider = "google"

            client_id = os.environ.get('DOTFILES_GOOGLE_CLIENT_ID')
            if not client_id:
                client_id = input('Please enter the google client_id: ')
                dotenv.set_key(dotenv_path, 'DOTFILES_GOOGLE_CLIENT_ID', client_id)

            client_secret = os.environ.get('DOTFILES_GOOGLE_CLIENT_SECRET')
            if not client_secret:
                client_secret = input('Please enter the google client_secret: ')
                dotenv.set_key(dotenv_path, 'DOTFILES_GOOGLE_CLIENT_SECRET', client_secret)
        elif mb_conf['Host'] == 'outlook.office365.com':
            provider = 'microsoft'
            client_id = os.environ.get('DOTFILES_MICROSOFT_CLIENT_ID')
            if not client_id:
                client_id = input('Please enter the microsoft client_id: ')
                dotenv.set_key(dotenv_path, 'DOTFILES_MICROSOFT_CLIENT_ID', client_id)

            client_secret = os.environ.get('DOTFILES_MICROSOFT_CLIENT_SECRET')
            if not client_secret:
                client_secret = input('Please enter the microsoft client_secret: ')
                dotenv.set_key(dotenv_path, 'DOTFILES_MICROSOFT_CLIENT_SECRET', client_secret)
        else:
            continue

        tokenfile = f"{home_path}/.config/mutt/tokens/{user}.token"

        try:
            subprocess.run([mutt_oauth2_path,
                            tokenfile,
                            '--gpg-public-key', gpg_public_key,
                            ], check=True, capture_output=True)
        except:
            mutt_oauth2_input = f"{provider}\nlocalhostauthcode\n{user}\n{client_id}\n{client_secret}\n"
            pathlib.Path(tokenfile).unlink(missing_ok=True)
            subprocess.run([mutt_oauth2_path,
                                  tokenfile,
                                  '--gpg-public-key', gpg_public_key,
                                  '--authorize'
                                  ], input=mutt_oauth2_input.encode())

        mb_conf['PassCmd'] = f"\"{mutt_oauth2_path} {tokenfile} --gpg-public-key {gpg_public_key}\""
        mb_conf['AuthMechs'] = "XOAUTH2"

    write_mbsync_rc(mbsync_rc)

    msmtp_rc = parse_msmtp_rc()

    for user in msmtp_rc:
        ms_conf = msmtp_rc[user]

        tokenfile = f"{home_path}/.config/mutt/tokens/{user}.token"
        ms_conf['passwordeval'] = f"\"{mutt_oauth2_path} {tokenfile} --gpg-public-key {gpg_public_key}\""
        ms_conf['auth'] = "oauthbearer"

    msmtp_rc = write_msmtp_rc(msmtp_rc)

if __name__ == '__main__':
    main()
