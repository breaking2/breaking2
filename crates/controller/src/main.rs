fn main() {
    println!("Hello, world!");
    camera::dummy();
    gpio::dummy();
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn test_dummy() {
        main();
    }
}
