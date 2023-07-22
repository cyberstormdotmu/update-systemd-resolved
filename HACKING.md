# Hacking on update-systemd-resolved

## Nix flake usage

This project supplies a [`flake.nix`](./flake.nix) file defining a Nix
flake.[^nix-flakes]

[^nix-flakes]: See the [NixOS wiki](https://nixos.wiki/wiki/Flakes) and the
               [`nix flake` page in the Nix package manager reference manual](https://nixos.org/manual/nix/unstable/command-ref/new-cli/nix3-flake.html)
               for background on Nix flakes.

This Nix flake defines three important important outputs:

1. A Nix package for `update-systemd-resolved` (see [here](./nix/packages.nix)),
2. A NixOS test of `update-systemd-resolved` features (see
   [here](./nix/checks.nix)), and
3. A Nix development shell[^devshell] (see [here](./nix/devshells.nix)).

[^devshell]: Based on the [`numtide/devshell`](https://github.com/numtide/devshell) project.

In order to work on the `update-systemd-resolved` project's Nix features,
you'll need to [install the Nix package
manager](https://nixos.org/download.html) and [ensure that the `flakes` and
`nix-command` experimental features are
enabled](https://nixos.wiki/wiki/Flakes#Enable_flakes).

### Building the `update-systemd-resolved` package

To build the `update-systemd-resolved` package exposed by this flake, run the
following command:[^verbose-output]

[^verbose-output]: Note that the `-L` flag can be omitted for terser output.

```shell-session
$ nix build -L '.#'
```

Or:

```shell-session
$ nix build -L '.#update-systemd-resolved'
```

These two forms are functionally equivalent because the
`update-systemd-resolved` package is the default package.

In addition to building the package, `nix build` will place a symbolic link to
its output path at `./result` (`ls -lAR ./result/`, `tree ./result/`, or
similar to see what the package contains).

### Nix flake checks

This project includes a NixOS test of `update-systemd-resolved`'s functionality
and features, exposed as a Nix flake check.

Please see the NixOS manual's ["Testing with NixOS" section](https://nixos.org/manual/nixos/stable/index.html#sec-nixos-tests)
for information on [writing](https://nixos.org/manual/nixos/stable/index.html#sec-writing-nixos-tests)
and [running](https://nixos.org/manual/nixos/stable/index.html#sec-writing-nixos-tests)
NixOS tests, as well as information on [running them interactively](https://nixos.org/manual/nixos/stable/index.html#sec-running-nixos-tests-interactively)
and [linking them to Nix packages](https://nixos.org/manual/nixos/stable/index.html#sec-linking-nixos-tests-to-packages).

#### How the test works

This project's NixOS test sets up three machines:

1. An OpenVPN server,
2. An OpenVPN client, and
3. A DNS resolver running [Dnsmasq](https://thekelleys.org.uk/dnsmasq/doc.html).

The OpenVPN server and client run a [point-to-point configuration with a static
key](https://openvpn.net/community-resources/static-key-mini-howto/).  The
client's OpenVPN configuration file includes several instances of [the
`dhcp-option`s recognized by `update-systemd-resolved`](./README.md#usage).
The [test script](https://nixos.org/manual/nixos/stable/index.html#test-opt-testScript)
starts all three machines, waits for certain systemd services to become active,
and then asserts that certain hostnames are resolvable _from the client_ that
would not be resolvable unless the client were configured to use the DNS
settings specified in its OpenVPN configuration file.

#### Extending the NixOS test

If you are implementing a new feature or correcting a bug in
`update-systemd-resolved`, you are encouraged to extend the NixOS test with new
test cases that exercise your feature or verify that the bug is fixed --
_unless_ you can adequately express these within the [unit test
suite](./README.md#how-to-help), as that suite runs significanly faster than
the NixOS test and has no prerequisites other than Bash.

#### Running Nix flake checks

To run the [above-mentioned](#nix-flake-usage) NixOS system test and other
checks,[^other-checks] execute the following command:[^verbose-output]

```shell-session
$ nix flake -L
```

[^other-checks]: Other checks include linting the Nix source code in this
                 project, and running a syntax check on the polkit rules
                 generated by `update-systemd-resolved print-polkit-rules`.

##### Running a check for a specific system

Running `nix flake check [-L]` will execute Nix flake checks for all supported
systems.[^supported-systems]  To run a check for a particular system, instead
use the `nix build` command.  For instance, to execute the NixOS system test
for the `x86_64-linux` system, run:

```shell-session
$ nix build -L '.#checks.x86_64-linux.update-systemd-resolved'
```

[^supported-systems]: Run `nix flake show` to view flake outputs namespaced by
                      all supported systems.

### Entering the Nix development shell

To enter the Nix development shell, run the following command:

```shell-session
$ nix develop
```

You will be presented with a menu of commands available within the development
shell.

#### Summary of available commands

- `fmt`: format all Nix code in this project using [`alejandra`](https://github.com/kamadorueda/alejandra).