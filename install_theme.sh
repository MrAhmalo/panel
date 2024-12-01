echo "Enabling maintenance mode..."
php artisan down

echo "Updating package list and installing required packages..."
apk update && apk add git curl || {
    echo "Failed to install required packages. Exiting."
    exit 1
}

TARGET_DIR="/app/public/themes/pterodactyl/css"
TARGET_FILE="pterodactyl.css"
REPO_URL="https://raw.githubusercontent.com/MrAhmalo/panel/refs/heads/1.0-develop/$TARGET_FILE"

echo "Navigating to $TARGET_DIR..."
if cd "$TARGET_DIR"; then
    echo "Successfully navigated to $TARGET_DIR."
else
    echo "Directory $TARGET_DIR does not exist. Exiting."
    exit 1
fi

echo "Deleting old $TARGET_FILE..."
if rm -f "$TARGET_FILE"; then
    echo "Old $TARGET_FILE deleted successfully."
else
    echo "Failed to delete $TARGET_FILE. Check permissions. Exiting."
    exit 1
fi

echo "Downloading new $TARGET_FILE from repository..."
if curl -o "$TARGET_FILE" "$REPO_URL"; then
    echo "New $TARGET_FILE downloaded successfully."
else
    echo "Failed to download $TARGET_FILE from $REPO_URL. Exiting."
    exit 1
fi

echo "Operation completed successfully. The new CSS file is in $TARGET_DIR."

echo "Clearing cache..."
php artisan view:clear
php artisan cache:clear

echo "Disabling maintenance mode..."
php artisan up