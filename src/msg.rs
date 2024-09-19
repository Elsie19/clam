#[macro_export]
/// Our message system
macro_rules! msg {
    ($($rest:tt)*) => {
        let string = std::fmt::format(std::format_args!($($rest)*));
        std::println!(":: {string}");
    };
}

#[macro_export]
/// Our message system for errors
macro_rules! emsg {
    ($($rest:tt)*) => {
        let string = std::fmt::format(std::format_args!($($rest)*));
        std::eprintln!(":: {string}");
    };
}
