# cargo-panic

[![travis-badge][]][travis] [![license-badge][]][license]

Use panic handlers [`color-backtrace`](https://github.com/athre0z/color-backtrace) and [`pretty_backtrace`](https://github.com/bjorn3/pretty_backtrace) on-demand without requiring source modifications or changing `Cargo.toml`.

This project is an experimental work-in-progress, and probably only works on Linux.

## Installation

```shell
git clone https://github.com/arcnmx/cargo-panic.git
make -C cargo-panic install DEST=$HOME/.cargo/bin # or anywhere else you might have in $PATH

cd cargo-panic/example
cargo panic run # try it out! defaults to RUST_BACKTRACE=color
cargo panic test -- --nocapture # and tests too
RUST_BACKTRACE=pretty cargo panic run # optionally supports pretty_backtrace
```

## Future Improvements

1. Conversion to pure rust and easy installation via `cargo install cargo-panic`
2. Windows support
3. Support for --target and non-standard cargo invokations/configs
4. Usability improvements, possibly wrapping cargo instead of providing a separate command for more seamless `RUST_BACKTRACE` activation

[travis-badge]: https://img.shields.io/travis/arcnmx/cargo-panic/master.svg?style=flat-square
[travis]: https://travis-ci.org/arcnmx/cargo-panic
[license-badge]: https://img.shields.io/badge/license-MIT-lightgray.svg?style=flat-square
[license]: https://github.com/arcnmx/cargo-panic/blob/master/COPYING
