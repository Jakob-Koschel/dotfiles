# Summary

This fork of **bashdot** is a minimalist dotfile management framework that
supports multiple profiles, built as a thin wrapper around [GNU Stow](https://www.gnu.org/software/stow/).

It is a [single bash script](bashdot) that symlinks your dotfiles into your home
directory and can run setup scripts before and after linking.

> This is a heavily shrunk fork of the original
> [bashdot](https://github.com/bashdot/bashdot). The symlinking is delegated to
> `stow`, and the template/uninstall/list commands of the original have been
> removed in favour of `before`/`after` hook scripts.

## Requirements

- `bash`
- [GNU Stow](https://www.gnu.org/software/stow/) 2.3.0 or later (the `--dotfiles`
  flag is used).

  ```sh
  # macOS
  brew install stow

  # Debian / Ubuntu
  sudo apt-get install stow
  ```

## Profile Layout

A **profile** is a directory containing a `symlinks` directory and, optionally, a
`run` directory with hook scripts:

```
default/
├── symlinks/          # stow packages, linked into your home directory
│   └── shell/
│       └── dot-bashrc # → ~/.bashrc
└── run/
    ├── before/        # executable scripts run before linking
    └── after/         # executable scripts run after linking
```

### symlinks

Each top level directory inside `symlinks/` is a [stow
package](https://www.gnu.org/software/stow/manual/stow.html). bashdot runs stow
with `--dotfiles`, so a file named `dot-bashrc` is linked to `~/.bashrc`.

There are two cases:

- **Flat package** — a directory that contains only files/links is stowed
  directly into `$HOME`. For example, `symlinks/shell/dot-bashrc` is linked to
  `~/.bashrc`.

- **Grouped package** — if a top level directory contains subdirectories, each
  subdirectory is stowed into `$HOME/<name>`, where a `dot-` prefix on the
  subdirectory name is translated to `.`. For example,
  `symlinks/apps/dot-config/` is stowed into `~/.config`. This is useful for
  splitting a directory such as `~/.config` across multiple packages.

### run hooks

Any executable scripts placed in `run/before` or `run/after` are run, in
alphabetical order, by the `before` and `after` commands. Make sure they have
the executable bit set (`chmod +x`).

## Usage

```
bashdot [install|before|after] PROFILE1 PROFILE2 ... PROFILEN
```

| Command   | Description                                                        |
| --------- | ------------------------------------------------------------------ |
| `install` | Symlink the `symlinks/` packages of each profile into your home.   |
| `before`  | Run the scripts in each profile's `run/before` directory.          |
| `after`   | Run the scripts in each profile's `run/after` directory.           |

A typical end to end run links one or more profiles, running setup before and
cleanup/configuration after:

```sh
bashdot before default
bashdot install default
bashdot after default
```

You can install multiple profiles at once to compose dotfiles by use (work,
home, etc.), operating system or distribution:

```sh
bashdot install default work
```

Profiles installed on the same system must not contain overlapping files.

## Debug

To increase logging, set the **BASHDOT_LOG_LEVEL** environment variable to
**debug**.

```sh
export BASHDOT_LOG_LEVEL=debug
```

## Frequently Asked Questions

**Q:** How do I set secrets or private information in my dotfiles?

**A:** Never store secrets in your dotfiles. Keep secrets out of source control
and inject them at runtime, for example from a `run/before` script.

**Q:** How can I share my bashdot profiles?

**A:** bashdot only manages dotfile installation, not their distribution. To
share your profiles, make them available via source control, a shared file
system or a cloud drive.

**Q:** Does bashdot work with zsh, fish or other shells?

**A:** Yes. bashdot uses standard unix commands and symlinks via stow, so it
works with any shell.
