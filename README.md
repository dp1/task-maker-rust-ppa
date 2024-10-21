# task-maker-rust-ppa

Scripts to check for new [task-maker-rust](https://github.com/olimpiadi-informatica/task-maker-rust) releases, and build and publish the packages to [ppa:dariop1/task-maker-rust](https://launchpad.net/~dariop1/+archive/ubuntu/task-maker-rust)

# Installation

```bash
sudo add-apt-repository ppa:dariop1/task-maker-rust
sudo apt update
sudo apt install task-maker-rust
```

# ACKs

- Github workflow inspired by https://github.com/bortoz/homebrew-bortoz
- Publish-to-ppa derived from https://github.com/yuezk/publish-ppa-package
- `cargo vendor` setup from https://blog.zhimingwang.org/packaging-rust-project-for-ubuntu-ppa
