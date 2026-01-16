# Install GoofCord, a privacy-minded Discord client
[group('System')]
fix-bazaar:
    #!/usr/bin/pkexec/bash
    flatpak install --system --or-update -y --noninteractive -v flathub io.github.milkshiift.GoofCord

    echo "Done!"
