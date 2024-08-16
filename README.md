# Permissions

## Restore permissions

...

## Enable tracking files that belong to other users

### Manage shared group

1. create the group

    ```bash
    sudo groupadd dotfiles
    ```

2. verify group

    ```bash
    getent group | grep dotfiles
    ```

3. add users

    ```bash
    sudo usermod -aG dotfiles [username]
    ```

4. verify user added

    ```bash
    id [username] | sed -E 's|^.*groups=||' | grep -Eo '[0-9]+\(dotfiles\)'
    ```

* it's best to logout and log back in for the group membership to take effect;
otherwise you can use `newgrp dotfiles`.

### Enable the user to track files that do not belong to it

1. Grant permissions for the already exising files and dirs.

    ```bash
    sudo setfacl -R -m g:dotfiles:rX /path/to/repo
    ```

2. Grant default permissions for future files and dirs.

    ```bash
    sudo setfacl -R -d -m g:dotfiles:rX /path/to/repo
    ```
