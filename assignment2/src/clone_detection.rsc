module clone_detection

import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;
import List;

void clones(set[Declaration] ast) {
	//list[tuple[loc, loc]] clones = [];
	list[tuple[value, value]] clones = [];
	map[int, list[list[Statement]]] hash = ();

	visit (ast) {
		//case \block(statements)	: {println(size(flattenStatements(statements)));}
		case \block(statements)	: insertBucket(hash, statements);
	}
	
	for (key <- hash) {
		for (i <- hash[key]) {
			for (j <- hash[key]) {
				if (compareStatements(i, j)) {
					for (subStatement <- subStatements(i)) {
						// remove from clones
						return;
					}
					
					clones += <i, j>; // TODO get locs of i and j
				}
			}
		}
	}
}

bool compareStatements(list[Statement] i, list[Statement] j) {
	//visit(i) {
	//	case \
	//}
	
	return true;
}

list[Statement] subStatements(list[Statement] statements) {
	list[Statement] subStmts = [];
	
	for (statement <- statements) {
		subStmts += [stmts | /\block(stmts) := statement];
	}
	
	return subStmts;
}

void insertBucket(map[int, list[list[Statement]]] hash, list[Statement] statements) {
	flattenedStatements = flattenStatements(statements);
	int key = size(flattenedStatements);

	if (flattenedStatements in hash) {
		hash[key] += flattenedStatements;
	} else {
		hash[key] = flattenedStatements;
	}
}

// TODO exclude comments and blank lines
int blockLines(list[Statement] statements) {
	if (size(statements) > 0) {
		return 1 + statements[-1].src.end.line - statements[0].src.begin.line;
	} else {
		return 0;
	}
}

void printBlock(list[Statement] statements) {
	println("Begin block");
	
	for (statement <- statements) {
		println(statement.src);
	}
	
	println("End block");
}

int insertMaptrix(list[value] values, int depth, int column) {
	for (v <- values) {
		maptrix[depth][column] = v;
		astToMatrix(v, depth + 1);
		column += 1;
	}
}

map[int, map[int, list[value]]]  astToMaptrix(list[value] statements, int depth) {
	map[int, map[int, list[value]]] maptrix = ();
	int maxThreshold = 100;
	int column = 0;
	
	if (size(statements) > maxThreshold) {
		return flatten;
	}

	for (statement <- statements) {
		if (size(flatten) <= maxThreshold) {
			visit (statement) {
				case \do(body, condition)				: {maptrix[depth][column] = astToMaptrix(body, depth + 1); maptrix[depth][column + 1] = astToMaptrix(condition, depth + 1); column += 2;} 
			
				//case \block(statements)					: flatten += statement + flattenStatements(statements);
				//case \do(body, _)						: flatten += statement + flattenStatements([body]);
				//case \foreach(_, _, body)				: flatten += statement + flattenStatements([body]);
				//case \for(_, _, _, body)				: flatten += statement + flattenStatements([body]);
				//case \for(_, _, body)					: flatten += statement + flattenStatements([body]);
				//case \if(_, body)						: flatten += statement + flattenStatements([body]);
				//case \if(_, body1, body2)				: flatten += statement + flattenStatements([body1, body2]);
				//case \label(_, body)					: flatten += statement + flattenStatements([body]);
				//case \switch(_, statements)				: flatten += statement + flattenStatements(statements);
				//case \synchronizedStatement(_, body)	: flatten += statement + flattenStatements([body]);
				//case \try(body, catchClauses)			: flatten += statement + flattenStatements(catchClauses + body);
				//case \try(body, catchClauses, \finally)	: flatten += statement + flattenStatements(catchClauses + body + \finally);
				//case \catch(_, body)					: flatten += statement + flattenStatements([body]);
				//case \while(_, body)					: flatten += statement + flattenStatements([body]);
				//default									: flatten += statement; 
			}
		} else {
			break;
		}
	}
	
	return flatten;
}


void basicCloneDetection(list[int] statements) {
	for (statement <- statements) {
		return;
	}
}
