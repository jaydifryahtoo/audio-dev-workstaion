# Install GoofCord, a privacy-minded Discord client
[group('Apps')]
isntall-discord:
    #!/usr/bin/bash
    flatpak install --user --or-update -y --noninteractive -v flathub io.github.milkshiift.GoofCord

    echo "Done!"
