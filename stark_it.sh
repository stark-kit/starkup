# One liner installer for Starknet dev toolchains.
# This script aims to work with unix distro (MacOS, Linux, WSL, ...)
# As this is a WIP, error may appears. Please report to us 
# or the team behind the great Starknet tools if you need help!
# NB: Lots of this code are copied from the different installers of each tools used here.

### Tools

BASE_DIR=${XDG_CONFIG_HOME:-$HOME}
LOCAL_BIN_ESCAPED="\$HOME/.local/bin"
_PROFILE=""
_PREF_SHELL=""
case ${SHELL:-""} in
*/zsh)
  _PROFILE=$BASE_DIR/.zshrc
  _PREF_SHELL=zsh
  ;;
*/ash)
  _PROFILE=$BASE_DIR/.profile
  _PREF_SHELL=ash
  ;;
*/bash)
  _PROFILE=$BASE_DIR/.bashrc
  _PREF_SHELL=bash
  ;;
*/fish)
  _PROFILE=$BASE_DIR/.config/fish/config.fish
  _PREF_SHELL=fish
  ;;
*)
  err "could not detect shell, manually add '${LOCAL_BIN_ESCAPED}' to your PATH."
  ;;
esac

say() {
  printf 'starknet-installer: %s\n' "$1"
}

err() {
  say "$1" >&2
  exit 1
}

check_cmd() {
  command -v "$1" >/dev/null 2>&1
}

need_cmd() {
  if ! check_cmd "$1"; then
    err "need '$1' (command not found)"
  fi
}


### Install Starkli

echo "Installing Starkli..."
STARKLI_DIR=${STARKLI_DIR-"$BASE_DIR/.starkli"}
STARKLI_ENV_PATH="$STARKLI_DIR/env"
STARKLI_ENV_FISH_PATH="$STARKLI_DIR/env-fish"

# fish shell detection
IS_FISH_SHELL=""
if [ -n "$FISH_VERSION" ]; then
    IS_FISH_SHELL="1"
fi
case $SHELL in
    */fish)
        IS_FISH_SHELL="1"
        ;;
esac

curl https://get.starkli.sh | sh

if [ -n "$IS_FISH_SHELL" ]; then
        . ${STARKLI_ENV_FISH_PATH}
    else
        . ${STARKLI_ENV_PATH}
    fi

if ! check_cmd starkliup; then
    # todo: add a check for install folder to debug (or a prompt for user to do so)
    err "Error while installing 'starkliup' (command not found)"
fi
starkliup

if ! check_cmd starkli; then
    # todo: add a check for install folder to debug (or a prompt for user to do so)
    err "Error while installing 'starkli' (command not found)"
fi
echo "Starkli has been installed successfully."


### Scarb

echo "Installing Scarb..."
curl --proto '=https' --tlsv1.2 -sSf https://docs.swmansion.com/scarb/install.sh | sh
source ${_PROFILE}
echo "Scarb has been installed successfully."


# TODO: resume from here
### snfoundry

echo "Installing snfoundry..."
echo "snfoundry has been installed successfully."


### Rust

echo "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
echo "Rust has been installed successfully."
