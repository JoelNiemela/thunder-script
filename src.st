let std = import "std";

let add: (a: i32, b: i32) -> i32 = {
	a + b
};

let add = (a: i32, b: i32) -> i32 {
	a + b
};

let main: () -> () = {
	let arr: []i32 = gimmearray();

	for arr (i: i32) -> {
		std.io.print(add(i, i));
	}

	let label = if (arr.len() = 42) "good" else "bad";

	std.io.print(label);

	let lambda = (i: i32) -> {i * i};

	map lambda arr;
};
