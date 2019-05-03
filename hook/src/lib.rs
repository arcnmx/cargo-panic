#[ctor::ctor]
fn panic_install() {
    #[cfg(feature = "debug_log")]
    libc_print::libc_eprintln!("cargo-panic: installing hook");
    #[cfg(feature = "debug_test")]
    std::panic::set_hook(Box::new(|_| {
        libc_print::libc_println!("__CARGO_PANIC_TEST__");
    }));
    #[cfg(feature = "color-backtrace")]
    color_backtrace::install();
    #[cfg(feature = "pretty_backtrace")]
    pretty_backtrace::setup();
}

#[no_mangle]
pub static __cargo_panic_symbol: [u8; 0] = [];
