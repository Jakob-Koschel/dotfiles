#!/usr/bin/env python3

import os
import pathlib
import subprocess
import dotenv
from collections import OrderedDict
from glob import glob

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

def patch_mbsync(home_path, gpg_public_key, mutt_oauth2_path, dotenv_path):
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


def patch_msmtp(home_path, gpg_public_key, mutt_oauth2_path):
    msmtp_rc = parse_msmtp_rc()

    for user in msmtp_rc:
        ms_conf = msmtp_rc[user]

        if ms_conf['host'] in ['smtp.gmail.com', 'smtp.office365.com']:
            tokenfile = f"{home_path}/.config/mutt/tokens/{user}.token"
            ms_conf['passwordeval'] = f"\"{mutt_oauth2_path} {tokenfile} --gpg-public-key {gpg_public_key}\""
            if ms_conf['host'] == 'smtp.gmail.com':
                ms_conf['auth'] = "oauthbearer"
            elif ms_conf['host'] == 'smtp.office365.com':
                ms_conf['auth'] = "xoauth2"
                ms_conf['tls_starttls'] = "on"

    msmtp_rc = write_msmtp_rc(msmtp_rc)


def main():
    # currently disable mutt setup
    return

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

    # add default.muttrc to .muttrc if not done so already
    with open(f"{home_path}/.config/mutt/muttrc", "r") as f:
        muttrc = f.readlines()

    if '.config/mutt/default.muttrc' not in "".join(muttrc):
        print('add default.muttrc')
        index = [idx for idx, s in enumerate(muttrc) if 'mutt-wizard.muttrc' in s][0]
        muttrc.insert(index+1, f"source {home_path}/.config/mutt/default.muttrc\n")

        with open(f"{home_path}/.config/mutt/muttrc", "w") as f:
            f.write("".join(muttrc))

    for path in glob(f'{home_path}/.config/mutt/accounts/*'):
        with open(path, "r") as f:
            content = f.read()
        if '.config/mutt/account.muttrc' not in content:
            print(f"add account.muttrc to {path}")
            content = f"{content}\nsource {home_path}/.config/mutt/account.muttrc\n"
            with open(path, "w") as f:
                f.write(content)
        if '\nmailboxes ' in content:
            print(f"disable default mailboxes in {path}")
            content = content.replace('\nmailboxes ', '\n# mailboxes ')
            with open(path, "w") as f:
                f.write(content)
        if '@gmail.com' in path:
            if "=Sent" in content:
                content = content.replace("Sent", "[Gmail]/Sent Mail")
                with open(path, "w") as f:
                    f.write(content)
            if "=Drafts" in content:
                content = content.replace("Drafts", "[Gmail]/Drafts")
                with open(path, "w") as f:
                    f.write(content)
            if "=Trash" in content:
                content = content.replace("Trash", "[Gmail]/Trash")
                with open(path, "w") as f:
                    f.write(content)
            if "=Junk" in content:
                content = content.replace("Junk", "[Gmail]/Spam")
                with open(path, "w") as f:
                    f.write(content)

    # patch .mbsyncrc to use XOAUTH2
    patch_mbsync(home_path, gpg_public_key, mutt_oauth2_path, dotenv_path)

    # patch .msmtprc to use XOAUTH2
    patch_msmtp(home_path, gpg_public_key, mutt_oauth2_path)


if __name__ == '__main__':
    main()
