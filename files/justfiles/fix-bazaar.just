# Fix the Flathub Bazaar if it's missing
[group('System')]
fix-bazaar:
    #!/usr/bin/bash
    flatpak install --system --or-update -y --noninteractive -v flathub io.github.kolunmi.Bazaar

    echo "Done!"
