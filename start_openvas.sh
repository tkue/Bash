#!/bin/bash


if [ ! `id -u` -eq 0 ]; then
    echo "Need to run as root"
    exit 1
fi

function is_package_installed() {
    
}

function check_install_openvas9() {
    if [ ! $(apt-cache search openvas9 | grep -c openvas) -eq 1 ]; then
        echo "Need to add OpenVAS repo"

        # Only supports Ubuntu right now
        # TODO: Add Debian 
        if [ $(cat /etc/os-release | grep -c 'ID=ubuntu') -eq 1 ]; then
            echo "Only supports adding repo for Ubuntu at this time. Exiting..."
            exit 1
        fi

        # Add repo 
        add-apt-repository ppa:mrazavi/openvas && apt-get update || \
            echo "Failed to add repository"
            exit 1
    fi
}

function update_openvas() {
    echo "Updating OpenVaS..."
    openvas-nvt-sync
    greenbone-scapdata-sync
    greenbone-certdata-sync
    echo "Done updating."
}

function restart_services() {
    echo "Restarting services and rebuilding index"
    service openvas-scanner restart
    service openvas-manager restart

    echo "Rebuilding index..."
    openvasmd --rebuild --progress
    echo "Done"
}

function update_openvas_full() {
    update_openvas && restart_services || \
        echo "Failed to update OpenVas"
}

function change_admin_pw_interactive() {
    echo -n "Enter admin user new password: "
    read PW
    sh -c "openvasmd --user=admin --new-password=$PW" || \ 
        echo "Failed to modify password for admin user"
}

function create_user_interactive() {
    echo  -n "Enter new user to create: "
    read USER 
    echo -n "Enter password for user $USER: "
    read PASSWORD

    sh -c "openvasmd --user=$USER --new-password=$PASSWORD" || \ 
        echo "Failed to modify password for user $USER with password $PASSWORD"
}

function echo_info() {
    echo "Installed OpenVas9"
    echo "Service starts on localhost at port 4000"
    echo "OpenVas8 used to start on port 443"

}

function start_openvas() {

    # Start services 
    echo "Starting services..."
    service openvas-scanner start && \
    service openvas-manager start \
        || echo "Failed to start services"

    # Check for web browsers
    isfirefox=$(is_package_installed firefox)
    ischromeium=$(is_package_installed chromium-browser)

    if [ $isfirefox -eq 1 ]; then 
        firefox "https://127.0.0.1:4000"
        return
    fi

    if [ $ischromeium -eq 1 ]; then 
        chromium-browser "https://127.0.0.1:4000"
        return
    fi

    echo "Unable to open OpenVas web interface"
    echo "Unable to find Firefox or Chromium webbrowsers"
    return 1
}