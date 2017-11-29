module clone_detection

import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;
import List;
import Map;
import Set;

void clones(set[Declaration] ast) {
	//list[tuple[loc, loc]] clones = [];
	list[tuple[value, value]] clones = [];
	map[int, list[Statement]] hash = ();

	visit (ast) {
		//case \block(statements)	: {println(size(flattenStatements(statements)));}
		case \block(statements)	: {
			flattenedStatements = flattenStatements(statements);
			int key = size(flattenedStatements);
		
			if (key in hash) {
				hash[key] += statements;
			} else {
				hash[key] = statements;
			}
		}
	}
	
	for (key <- hash) {
		for (i <- hash[key]) {
			for (j <- hash[key]) {
				if (i.src != j.src && compareStatements(i, j)) {
					//for (subStatement <- subStatements(i)) {
					//	// remove from clones
					//	return;
					//}
					
					clones += <i.src, j.src>; // TODO get locs of i and j
				}
			}
		}
		println(key);
	}
	println(size(hash));
	for(clone <- clones) {
		println("clone = <clone>");
	}
}

bool compareStatements(Statement i, Statement j) {
	//visit(i) {
	//	case \
	//}
	
	return i == j;
}

//list[Statement] subStatements(list[Statement] statements) {
//	list[Statement] subStmts = [];
//	
//	for (statement <- statements) {
//		subStmts += [stmts | /\block(stmts) := statement];
//	}
//	
//	return subStmts;
//}

//void insertBucket(map[int, list[Statement]] hash, list[Statement] statements) {
//	flattenedStatements = flattenStatements(statements);
//	int key = size(flattenedStatements);
//
//	if (key in hash) {
//		hash[key] += statements;
//	} else {
//		hash[key] = statements;
//	}
//}

void printBlock(list[Statement] statements) {
	println("Begin block");
	
	for (statement <- statements) {
		println(statement.src);
	}
	
	println("End block");
}

list[Statement] flattenStatements(list[Statement] statements) {
	list[Statement] flatten = [];
	int maxThreshold = 100;
	
	if (size(statements) > maxThreshold) {
		return flatten;
	}
	
	for (statement <- statements) {
		if (size(flatten) <= maxThreshold) {
			visit (statement) {
				case \block(statements)					: flatten += statement + flattenStatements(statements);
				case \do(body, _)						: flatten += statement + flattenStatements([body]);
				case \foreach(_, _, body)				: flatten += statement + flattenStatements([body]);
				case \for(_, _, _, body)				: flatten += statement + flattenStatements([body]);
				case \for(_, _, body)					: flatten += statement + flattenStatements([body]);
				case \if(_, body)						: flatten += statement + flattenStatements([body]);
				case \if(_, body1, body2)				: flatten += statement + flattenStatements([body1, body2]);
				case \label(_, body)					: flatten += statement + flattenStatements([body]);
				case \switch(_, statements)				: flatten += statement + flattenStatements(statements);
				case \synchronizedStatement(_, body)	: flatten += statement + flattenStatements([body]);
				case \try(body, catchClauses)			: flatten += statement + flattenStatements(catchClauses + body);
				case \try(body, catchClauses, \finally)	: flatten += statement + flattenStatements(catchClauses + body + \finally);
				case \catch(_, body)					: flatten += statement + flattenStatements([body]);
				case \while(_, body)					: flatten += statement + flattenStatements([body]);
				default									: flatten += statement; 
			}
		} else {
			break;
		}
	}
	
	return flatten;
}
