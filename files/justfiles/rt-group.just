# Add your user to the realtime CPU prioritization group
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
