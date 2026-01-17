# Clean up Vivaldi's default profile and set sane options
[group('Apps')]
setup-vivaldi:
    #!/usr/bin/env bash
    set -euo pipefail

    echo 'Would you like to set up the Vivaldi default profile in your home folder?'
    if ! gum confirm 'Continue'; then
        exit 0
    fi

    VIVALDI_CONFIG_DIR="${HOME}/.config/vivaldi"
    VIVALDI_PROFILE_BACKUP="/usr/share/applications/vivaldi/default-profiles"
    if [ ! "${VIVALDI_CONFIG_DIR}/Default" ]; then
        echo ' '
        echo 'Vivaldi must be started once before the profile can be created
        echo 'Would you like to do that now?'
        if ! gum confirm 'Yes'; then
            exit 0
        fi
            echo ' '
            echo 'Please close Vivaldi after it finishes loading'
            wait $(vivaldi-stable > /dev/null 2>&1)
    elif [ "${VIVALDI_CONFIG_DIR}/Default" ]; then
        rm -Rf "${VIVALDI_CONFIG_DIR}/Default"
    fi

    unzip "${VIVALDI_PROFILE_BACKUP}/vivaldi_profile.*" -do "${HOME}/.config/vivaldi"
    echo ' '
    echo 'Complete!'
    done
