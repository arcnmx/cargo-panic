An alternative way to link the hook into a Rust program:

    export RUSTFLAGS="-C link-arg=-Wl,-u__cargo_panic_depend -C link-arg=-lcargo_panic_depend"

but there's probably no real advantage to doing this over `-Wl,--no-as-needed` so really this approach serves no purpose and isn't necessary.
