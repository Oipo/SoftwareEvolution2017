module clone_tests
import clone_detection;
import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;
import util::ValueUI;
import List;
import Map;
import Set;
import Node;

test bool type1_simple() {
	f = createAstFromFile(|project://assignment2/test/type1_simple.java|, true);
	cs = clones({f}, 1);
	return size(cs) == 2;
}

test bool type1_subsumed() {
	f = createAstFromFile(|project://assignment2/test/type1_subsumed.java|, true);
	cs = clones({f}, 1);
	return size(cs) == 2;
}

test bool type2_simple() {
	f = createAstFromFile(|project://assignment2/test/type2_simple.java|, true);
	cs = clones({f}, 1);
	println(size(cs));
	return size(cs) == 2;
}