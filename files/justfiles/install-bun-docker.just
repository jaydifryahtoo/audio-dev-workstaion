# Install bun in a docker container
[group('Developer')]
install-bun-docker:
    #!/usr/bin/bash
    docker pull overn/bun
    docker run --rm --init --ulimit memlock=-1:-1 oven/bun

    echo "bun docker image installed!"
