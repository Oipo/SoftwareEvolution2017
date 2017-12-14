module clone_tests
import clone_detection;
import code_filtering;
import volume;
import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;
import util::ValueUI;
import List;
import Map;
import Set;
import Node;

// check if we can detect type 1 clones
test bool type1_simple() {
	f = createAstFromFile(|project://assignment2/test/type1_simple.java|, true);
	cs = clones({f}, 1);
	clonedLines = get_volume(toList({l | <l, _> <- cs}));
	cs2 = clones({f}, 2);
	clonedLines2 = get_volume(toList({l | <l, _> <- cs2}));
	return size(cs) == 2 && clonedLines == 10 && size(cs2) == 6 && clonedLines2 == 15;
}

// check if we subsume type 1 clones
test bool type1_subsumed() {
	f = createAstFromFile(|project://assignment2/test/type1_subsumed.java|, true);
	cs = clones({f}, 1);
	clonedLines = get_volume(toList({l | <l, _> <- cs}));
	cs2 = clones({f}, 2);
	clonedLines2 = get_volume(toList({l | <l, _> <- cs2}));
	return size(cs) == 2 && clonedLines == 20 && size(cs2) == 6 && clonedLines2 == 30;
}

// check if we can detect simple type 2 clones
test bool type2_simple() {
	f = createAstFromFile(|project://assignment2/test/type2_simple.java|, true);
	cs = clones({f}, 1);
	clonedLines = get_volume(toList({l | <l, _> <- cs}));
	cs2 = clones({f}, 2);
	clonedLines2 = get_volume(toList({l | <l, _> <- cs2}));
	return size(cs) == 0 && clonedLines == 0 && size(cs2) == 2 && clonedLines2 == 10;
}

// check if we can detect type 2 clones with different variable assignments etc
test bool type2_complex() {
	f = createAstFromFile(|project://assignment2/test/type2_complex.java|, true);
	cs = clones({f}, 1);
	clonedLines = get_volume(toList({l | <l, _> <- cs}));
	cs2 = clones({f}, 2);
	clonedLines2 = get_volume(toList({l | <l, _> <- cs2}));
	return size(cs) == 0 && clonedLines == 0 && size(cs2) == 2 && clonedLines2 == 30;
}

// test to check if we do not detect type 3 clones
test bool type3_simple() {
	f = createAstFromFile(|project://assignment2/test/type3_simple.java|, true);
	cs = clones({f}, 1);
	clonedLines = get_volume(toList({l | <l, _> <- cs}));
	cs2 = clones({f}, 2);
	clonedLines2 = get_volume(toList({l | <l, _> <- cs2}));
	return size(cs) == 0 && clonedLines == 0 && size(cs2) == 0 && clonedLines2 == 0;
}