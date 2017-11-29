module assumptions

import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;
import List;
import Set;
import Map;

test bool expression_hashes_should_be_different() {
	Expression a = \assignment(\number("1"), "+", \number("2"));
	Expression b = \assignment(\number("2"), "+", \number("1"));
	map[Expression, int] hash = ();
	hash[a] = 1;
	hash[b] = 2;
	return size(hash) == 2;
}

test bool expressions_should_be_different() {
	Expression a = \assignment(\number("1"), "+", \number("2"));
	Expression b = \assignment(\number("2"), "+", \number("1"));
	return a == a && b == b && a != b;
}

test bool expressions_should_be_equal() {
	Expression a = \assignment(\number("1"), "+", \number("2"));
	Expression b = \assignment(\number("1"), "+", \number("2"));
	return a == b;
}

test bool value_can_contain_multiple_types() {
	Expression a = \assignment(\number("1"), "+", \number("2"));
	Statement b = \continue();
	value c = a;
	c = b;
	return c == b;
}

test bool traverse_declaration() {
	Declaration a = \initializer(\empty());
	for(b <- a) {
		println(a);
	}
}