# cargo-panic

[![travis-badge][]][travis] [![license-badge][]][license]

Use panic handlers [`color-backtrace`](https://github.com/athre0z/color-backtrace) and [`pretty_backtrace`](https://github.com/bjorn3/pretty_backtrace) on-demand without requiring source modifications or changing `Cargo.toml`.

This project is an experimental work-in-progress, see the [caveats](#caveats-and-limitations) section below.


## Installation

This tool currently requires [jq](https://stedolan.github.io/jq/) and bash to be installed on the system.

```shell
git clone https://github.com/arcnmx/cargo-panic.git
make -C cargo-panic install DESTDIR=$HOME/.cargo/bin # or anywhere else you might have in $PATH

cd cargo-panic/example
cargo panic run # try it out! defaults to RUST_BACKTRACE=color
cargo panic test -- --nocapture # and tests too
RUST_BACKTRACE=pretty cargo panic run # optionally supports pretty_backtrace
```


## Caveats and Limitations

- You'll probably want to set [`rustflags = ["-C", "prefer-dynamic"]`](https://doc.rust-lang.org/cargo/reference/config.html) or `RUSTFLAGS="-C prefer-dynamic"` for your debug builds. Otherwise you must `touch src/main.rs`, `cargo clean -p yourcrate`, or otherwise tell cargo to relink your project before running `cargo panic X`. [#6](https://github.com/arcnmx/cargo-panic/issues/6)
- [Windows](https://github.com/arcnmx/cargo-panic/issues/2) and [cross-compiling or obscure cargo configurations](https://github.com/arcnmx/cargo-panic/issues/3) are not yet supported.


[travis-badge]: https://img.shields.io/travis/arcnmx/cargo-panic/master.svg?style=flat-square
[travis]: https://travis-ci.org/arcnmx/cargo-panic
[license-badge]: https://img.shields.io/badge/license-MIT-lightgray.svg?style=flat-square
[license]: https://github.com/arcnmx/cargo-panic/blob/master/COPYING
