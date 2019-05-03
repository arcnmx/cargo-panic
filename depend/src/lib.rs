extern {
    static __cargo_panic_symbol: [u8; 0];
}

#[no_mangle]
pub extern fn __cargo_panic_depend() -> *const u8 {
    unsafe {
        __cargo_panic_symbol.as_ptr()
    }
}
