# Zig Updater

A simple [Fisher](https://github.com/jorgebucaran/fisher) plugin for
[fish shell](https://fishshell.com/) that contains functions for updating Zig
and ZLS under MacOS.

Consists of 2 functions:

* **zig_update** - checks if current Zig version is equal to a latest master,
if not installs it in `/usr/local/zig` with a symlink to `/usr/local/bin/zig`.
Requires sudo elevation.
* **zls_update** - retrieves a Zig version installed and gets a latest ZLS
corresponding to that version. Installs to `/usr/local/bin/zls`.
Requires sudo elevation.

For now it works for MacOS only, support for other architectures is on the
roadmap.

## Requirements

1. [curl](https://curl.se/)
2. [jq](https://jqlang.org/)

## Installation

1. [Install Fisher plugin manager](https://github.com/jorgebucaran/fisher?tab=readme-ov-file#installation)
2. Install this plugin with `fisher install gren236/zig-updater`
