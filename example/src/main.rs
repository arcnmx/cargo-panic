fn main() {
    panic!("boom")
}

#[test]
#[should_panic]
fn panic() {
    panic!("boom")
}
