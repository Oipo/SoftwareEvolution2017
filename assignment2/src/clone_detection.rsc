module clone_detection

import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;
import List;
import Map;
import Set;
import Node;

void clones(set[Declaration] ast) {
	//list[tuple[loc, loc]] clones = [];
	list[tuple[value, value]] clones = [];
	map[int, list[Statement]] hash = ();

	visit (ast) {
		//case \block(statements)	: {println(size(flattenStatements(statements)));}
		case /b: \block(statements)	: {
			unsetRec(b);
			statements = [unsetRec(x) | x <- statements];
			int key = countStatements(statements);
			if(key >= 3 && key <= 100) {
				if (key in hash) {
					hash[key] += statements;
				} else {
					hash[key] = statements;
				}
			}
		}
	}
	
	for (key <- hash) {
		if(size(hash[key]) > 1) {
			for (i <- hash[key]) {
				for (j <- hash[key]) {
					if (compareStatements(i, j)) {
						//for (subStatement <- subStatements(i)) {
						//	// remove from clones
						//	return;
						//}
						
						clones += <i.src, j.src>; // TODO get locs of i and j
					}
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

int countStatements(list[Statement] statements) {
	int count = 0;
	
	for (statement <- statements) {
		visit (statement) {
			case \block(statements)					: count += 1 + countStatements(statements);
			case \do(body, _)						: count += 1 + countStatements([body]);
			case \foreach(_, _, body)				: count += 1 + countStatements([body]);
			case \for(_, _, _, body)				: count += 1 + countStatements([body]);
			case \for(_, _, body)					: count += 1 + countStatements([body]);
			case \if(_, body)						: count += 1 + countStatements([body]);
			case \if(_, body1, body2)				: count += 1 + countStatements([body1, body2]);
			case \label(_, body)					: count += 1 + countStatements([body]);
			case \switch(_, statements)				: count += 1 + countStatements(statements);
			case \synchronizedStatement(_, body)	: count += 1 + countStatements([body]);
			case \try(body, catchClauses)			: count += 1 + countStatements(catchClauses + body);
			case \try(body, catchClauses, \finally)	: count += 1 + countStatements(catchClauses + body + \finally);
			case \catch(_, body)					: count += 1 + countStatements([body]);
			case \while(_, body)					: count += 1 + countStatements([body]);
			default									: count += 1; 
		}
	}
	
	return count;
}
