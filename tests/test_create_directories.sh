# Test that the directories to make are created

echo "Testing that the expected directories are created"

source ./utils/directories_to_make.zsh

for DIR in "${DIRECTORIES_TO_CREATE[@]}"; do
    test -d $DIR || (echo "Error: $DIR not found" && exit 1)
done

echo "...done testing directories."