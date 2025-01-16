#!/bin/sh
# One liner installer for Starknet dev toolchains.
# This script aims to work with unix distro (MacOS, Linux, WSL, ...)
# As this is a WIP, error may appears. Please report to us 
# or the team behind the great Starknet tools if you need help!
# NB: Lots of this code are copied from the different installers of each tools used here.

### Global Variables

BASE_DIR=${XDG_CONFIG_HOME:-$HOME}
LOCAL_BIN="${BASE_DIR}/.local/bin"


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

  curl https://get.starkli.sh | sh

  # Adds binary directory to PATH (user will need to restart a terminal)
  export PATH="$STARKLI_DIR/bin:$PATH"

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
  need_cmd curl

  curl --proto '=https' --tlsv1.2 -sSf https://docs.swmansion.com/scarb/install.sh | sh

  # Adds binary directory to PATH (user will need to restart the terminal)
  export PATH="$LOCAL_BIN/:$PATH"
  

  if ! check_cmd scarb; then
      # todo: add a check for install folder to debug (or a prompt for user to do so)
      err "Error while installing 'scarb' (command not found)"
  fi
}

install_rust () {
  need_cmd curl

  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

  # Adds binary directory to PATH (user will need to restart the terminal)
  export PATH="$HOME/.cargo/bin:$PATH"

  if ! check_cmd rustc; then
      # todo: add a check for install folder to debug (or a prompt for user to do so)
      err "Error while installing 'rustc' (command not found)"
  fi
}

install_snfoundry () {
  SNFOUNDRYUP_URL="https://raw.githubusercontent.com/foundry-rs/starknet-foundry/master/scripts/snfoundryup"
  SNFOUNDRYUP_PATH="${LOCAL_BIN}/snfoundryup"

  need_cmd curl
  need_cmd mkdir
  need_cmd chmod

  # snfoundry needs rust first
  install_rust

  # todo: setup func for local_bin and others
  mkdir -p "${LOCAL_BIN}"
  curl -# -L "${SNFOUNDRYUP_URL}" -o "${SNFOUNDRYUP_PATH}"
  chmod +x "${SNFOUNDRYUP_PATH}"

  # Adds binary directory to PATH (user will need to restart the terminal)
  export PATH="$LOCAL_BIN/:$PATH"

  if ! check_cmd snfoundryup; then
      # todo: add a check for install folder to debug (or a prompt for user to do so)
      err "Error while installing 'snfoundryup' (command not found)"
  fi
  snfoundryup

  if ! check_cmd snforge; then
      # todo: add a check for install folder to debug (or a prompt for user to do so)
      err "Error while installing 'snforge' (command not found)"
  fi

  if ! check_cmd sncast; then
      # todo: add a check for install folder to debug (or a prompt for user to do so)
      err "Error while installing 'sncast' (command not found)"
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