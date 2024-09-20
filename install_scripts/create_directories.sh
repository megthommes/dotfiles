# Create directories
echo "Creating directories..."

source ./utils/directories_to_make.zsh
for DIR in "${DIRECTORIES_TO_CREATE[@]}"; do
    mkdir -p $DIR
done

echo "...directories created."
