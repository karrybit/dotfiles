# dotfiles

## Setup

1. Install Homebrew
    <https://brew.sh/ja/>

    ```sh
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```

2. Install 1Password

    ```sh
    brew install 1password
    ```

3. Login 1Password
4. Execute setup.sh

    ```sh
    /bin/bash -c "$(/usr/bin/curl -fsSL 'https://raw.githubusercontent.com/karrybit/dotfiles/refs/heads/master/setup.sh')"
    ```

5. Restart
