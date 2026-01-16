# Add your user to the realtime CPU prioritization group
[group('System')]
rt-group:
    #!/usr/bin/bash
    sudo usermod -aG realtime $USER

    echo "Reboot system and log back in to get realtime handling priority"
