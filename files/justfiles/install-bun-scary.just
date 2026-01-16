# Install bun at a root level - HIGH RISK
[group('Developer')]
install-bun-scary:
    #!/usr/bin/bash
    sudo npm install -g bun

    echo "bun installed- with scary permissions!  Be careful!"
