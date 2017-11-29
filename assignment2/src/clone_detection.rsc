module clone_detection

import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;
import List;

void clones(set[Declaration] ast) {
	map[list[Statement], list[list[Statement]]] hash();

	visit (ast) {
		//case \block(statements)	: {println(size(flattenStatements(statements)));}
		case \block(statements)	: insertBucket(hash, statements);
	}
	
	for (key <- hash) {
		for (i <- hash[key]) {
			for (j <- hash[key]) {
				return;
			}
		}
	}
}

void insertBucket(map[list[Statement], list[list[Statement]]] hash, list[Statement] statements) {
	flattenedStatements = flattenStatements(statements);

	if (flattenedStatements in hash) {
		hash[flattenedStatements] += flattenedStatements;
	} else {
		hash[flattenedStatements] = flattenedStatements;
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
void basicCloneDetection(list[int] statements) {
	for (statement <- statements) {
		return;
	}
}
