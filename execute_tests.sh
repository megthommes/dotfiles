# Execute tests

echo "Executing tests..."

chmod +x tests/*

echo "----------------------------------------"
./tests/test_create_directories.sh
echo "----------------------------------------"
./tests/test_install_homebrew.sh
echo "----------------------------------------"
./tests/test_install_homebrew_packages.sh
echo "----------------------------------------"
./tests/test_symlink_dotfiles.sh
echo "----------------------------------------"
./tests/test_configure_git.sh
echo "----------------------------------------"

chmod -x tests/*

echo "...tests complete."