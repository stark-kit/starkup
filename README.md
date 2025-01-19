# Stark It

`Stark It` is a one-line installer for all the necessary tools to start developing on Starknet ([Starkli](https://github.com/xJonathanLEI/starkli), [Scarb](https://docs.swmansion.com/scarb/) & [snfoundry](https://foundry-rs.github.io/starknet-foundry/)). It comes in two flavors: a bash script ([`stark_it.sh`](./stark_it.sh)) for Unix users, and a powershell script ([`stark_it.ps1`](./stark_it.ps1)) for Windows users.

## How to use it?

Unix Users:

```sh
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/stark-kit/starkup/refs/heads/main/stark_it.sh | sh
```

Windows Users:

```powershell
iex (iwr "https://raw.githubusercontent.com/stark-kit/starkup/refs/heads/main/stark_it.ps1").Content
```

You can also download the file and execute it on your machine.

## Todo list:

- [ ] Allow users to choose which tools they want to install
- [ ] Add more tools
- [ ] reduce prints from the different commands
- [ ] uninstall script

## Going Further

https://starknet-devx.vercel.app/
