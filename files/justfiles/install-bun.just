# Install bun- either safely in a docker container, or at a root level - HIGH RISK
[group('Developer')]
install-bun:
    #!/usr/bin/env bash
    set -euo pipefail
    echo 'Would you like to install bun with Docker, or with npm as root?'
    BUN_INSTALL_CHOICE="$(gum choose "safe-docker" "DANGER-ROOT")"
    if [ "$BUN_INSTALL_CHOICE" = 'safe-docker' ]; then
        docker pull oven/bun
        docker run --rm --init --ulimit memlock=-1:-1 oven/bun bun --version
        echo '---'
        echo 'bun docker image installed! adding binary to $PATH'
        echo '---'
        echo 'export PATH=$PATH:${HOME}/.bun/bin' >> "${HOME}/.bashrc"
        echo 'export PATH=$PATH:${HOME}/.bun/bin' >> "${HOME}/.zshrc"
        echo 'export BUN_INSTALL="${HOME}/.bun"' >> "${HOME}/.bashrc"
        echo 'export BUN_INSTALL="${HOME}/.bun"' >> "${HOME}/.zshrc"
        echo 'finished installing bun and adding paths!'
    elif [ "$BUN_INSTALL_CHOICE" = 'DANGER-ROOT' ]; then
        if ! gum confirm 'LAST CHANCE - INSTALLING AS ROOT!'; then
            exit 0
        fi
        echo "Installing bun with sudo npm..."
        sudo npm install -g bun
        sudo bun --version
        echo "bun installed- with scary permissions!  Be careful!"
    fi
