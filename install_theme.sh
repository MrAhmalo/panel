# /bin/sh

installTheme(){
    # Prepare
    php artisan down

    echo "Updating package list and installing required packages..."
    sleep 2   
    apk update && apk add git curl || {
        echo "Failed to install required packages. Exiting."
        exit 1
    }

    # Main
    echo "Installing theme..."
    sleep 2

    TARGET_DIR="/app/public/themes/pterodactyl/css"
    TARGET_FILE="pterodactyl.css"
    REPO_URL="https://raw.githubusercontent.com/MrAhmalo/panel/refs/heads/1.0-develop/$TARGET_FILE"

    if cd "$TARGET_DIR"; then
        echo ""
    else
        echo "Directory $TARGET_DIR does not exist. Exiting."
        exit 1
    fi

    echo "Deleting old $TARGET_FILE..."
    if rm -f "$TARGET_FILE"; then
        echo ""
    else
        exit 1
    fi

    if curl -o "$TARGET_FILE" "$REPO_URL"; then
        echo ""
    else
        echo "Failed to download $TARGET_FILE from $REPO_URL. Exiting."
        exit 1
    fi

    # Cleanup
    echo "Finishing up..."
    sleep 2
    php artisan view:clear
    php artisan cache:clear

    php artisan up

    sleep 3
    echo "Operation completed successfully. Theme installed."
}

echo "Copyright (c) 2024 Ahmalo | MrAhmalo | SirAhmalo"
echo "This program is free software: you can redistribute it and/or modify"
echo ""
echo "Website: https://portfolio.golegana.de"
echo ""
echo "[1] Install theme"
echo "[2] Uninstall theme"
echo "[3] Exit"

read -p "Please enter a number: " choice
if [ $choice == "1" ]
    then
    while true; do
        read -p "Are you sure that you want to install the theme [y/n]? " yn
        case $yn in
            [Yy]* ) installTheme; break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes (y) or no (n).";;
        esac
    done
fi
if [ $choice == "2" ]
    then
    exit
fi
if [ $choice == "3" ]
    then
    exit
fi