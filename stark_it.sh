# One liner installer for Starknet dev toolchains.
# This script aims to work with unix distro (MacOS, Linux, WSL, ...)
# As this is a WIP, error may appears. Please report to us 
# or the team behind the great Starknet tools if you need help!
# NB: Lots of this code are copied from the different installers of each tools used here.

### Global Variables

BASE_DIR=${XDG_CONFIG_HOME:-$HOME}
LOCAL_BIN="${BASE_DIR}/.local/bin"
LOCAL_BIN_ESCAPED="\$HOME/.local/bin"


### Tools

say() {
  echo "stark_it: $1"
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


### Installers

install_starkli () {
  need_cmd curl
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
}

install_scarb () {
  _PROFILE=""
  # _PREF_SHELL=""
  case ${SHELL:-""} in
  */zsh)
    _PROFILE=$BASE_DIR/.zshrc
    # _PREF_SHELL=zsh
    ;;
  */ash)
    _PROFILE=$BASE_DIR/.profile
    # _PREF_SHELL=ash
    ;;
  */bash)
    _PROFILE=$BASE_DIR/.bashrc
    # _PREF_SHELL=bash
    ;;
  */fish)
    _PROFILE=$BASE_DIR/.config/fish/config.fish
    # _PREF_SHELL=fish
    ;;
  *)
    err "could not detect shell, manually add '${LOCAL_BIN_ESCAPED}' to your PATH."
    ;;
  esac

  need_cmd curl

  curl --proto '=https' --tlsv1.2 -sSf https://docs.swmansion.com/scarb/install.sh | sh
  source ${_PROFILE}
}

install_snfoundry () {
  SNFOUNDRYUP_URL="https://raw.githubusercontent.com/foundry-rs/starknet-foundry/master/scripts/snfoundryup"
  SNFOUNDRYUP_PATH="${LOCAL_BIN}/snfoundryup"

  need_cmd curl
  need_cmd mkdir
  need_cmd chmod

  # todo: setup func for local_bin and others
  mkdir -p "${LOCAL_BIN}"
  curl -# -L "${SNFOUNDRYUP_URL}" -o "${SNFOUNDRYUP_PATH}"
  chmod +x "${SNFOUNDRYUP_PATH}"

  if [ -n "$IS_FISH_SHELL" ]; then
          . ${STARKLI_ENV_FISH_PATH}
      else
          . ${STARKLI_ENV_PATH}
      fi

  if ! check_cmd snfoundryup; then
      # todo: add a check for install folder to debug (or a prompt for user to do so)
      err "Error while installing 'starkliup' (command not found)"
  fi
  snfoundryup

  if ! check_cmd snfoundry; then
      # todo: add a check for install folder to debug (or a prompt for user to do so)
      err "Error while installing 'starkli' (command not found)"
  fi
}


### Main script

main () {
  say "Installing Starkli..."
  install_starkli
  say "Starkli has been installed successfully."

  say "Installing Scarb..."
  install_scarb
  say "Scarb has been installed successfully."

  say "Installing snfoundry..."
  install_snfoundry
  say "snfoundry has been installed successfully."
}

main