# Add your user to the realtime group
[group('System')]
rt-group:
    #!/usr/bin/pkexec/bash
    append_group(){
        local group_name="$1"
        if ! grep -q "^$group_name:" /etc/group; then
            echo "Appending $group_name to /etc/group"
            grep "^$group_name:" /usr/lib/group | sudo tee -a /etc/group >
        fi
    }

    GROUPS_ADD=("realtime")

    for GROUP_ADD in "${GROUPS_ADD[@]}" ; do
        append_group $GROUP_ADD
        usermod -aG $GROUP_ADD $USER
    done

    echo "Reboot system and log back in to get realtime handling priority"

[group('Security')]
setup-1password ACTION="":
    #!/usr/bin/bash
    set -euo pipefail
    source /usr/lib/ujust/ujust.sh
    
    SOCK="${HOME}/.1password/agent.sock"
    SSH_DROP="${HOME}/.ssh/config.d/50-1password.conf"
    ENVD="${HOME}/.config/environment.d/10-1password.conf"
    
    OPTION="{{ ACTION }}"
    if [[ -z "$OPTION" ]]; then
        echo -e "\n${bold}1Password SSH Agent Setup${normal}\n"
        if [[ -S "$SOCK" ]]; then
            echo -e "Agent socket: ${green}Active${normal}"
        else
            echo -e "Agent socket: ${red}Not found${normal}"
        fi
        OPTION=$(ugum choose "Configure SSH agent" "Skip")
    fi
    
    case "$OPTION" in
        "Configure SSH agent"|configure)
            mkdir -p "${HOME}/.1password"
            mkdir -p "${HOME}/.ssh/config.d"
            chmod 700 "${HOME}/.ssh" "${HOME}/.ssh/config.d"
            
            cat > "$SSH_DROP" <<'EOF'
Host *
  IdentityAgent ~/.1password/agent.sock
EOF
            chmod 600 "$SSH_DROP"
            
            if ! grep -q 'Include ~/.ssh/config.d/\*.conf' "${HOME}/.ssh/config" 2>/dev/null; then
                echo -e "\nInclude ~/.ssh/config.d/*.conf" >> "${HOME}/.ssh/config"
            fi
            chmod 600 "${HOME}/.ssh/config"
            
            mkdir -p "${HOME}/.config/environment.d"
            cat > "$ENVD" <<EOF
SSH_AUTH_SOCK=${SOCK}
EOF
            chmod 644 "$ENVD"
            
            echo -e "${green}1Password SSH agent configured.${normal}"
            echo "Next: Enable SSH Agent in 1Password → Settings → Developer"
            ;;
        *)
            echo "No changes made."
            ;;
    esac
