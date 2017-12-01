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
	map[int, list[tuple[Statement, Statement]]] hash = ();

	visit (ast) {
		//case \block(statements)	: {println(size(flattenStatements(statements)));}
		case /b: \block(statements)	: {
			int key = countStatements(statements);
			
			if(key >= 3 && key <= 400) {
				if (key in hash) {
					hash[key] += <b, unsetRec(b)>;
				} else {
					hash[key] = [<b, unsetRec(b)>];
				}
			}
		}
	}
	
	
	for (key <- sort(domain(hash))) {
		//println(key);
		if(size(hash[key]) > 1) {
			for (i <- hash[key]) {
				for (j <- hash[key]) {
					//println("ij");
					if (compareStatements(i, j)) {
						//println("compared");
						for (subStatement <- subStatements(i[0])) {
							println(<i[0].src, subStatement>);
							clones = [x | x <- clones, x[0] != subStatement && x[1] != subStatement];
						}
						
						//println("clone added");
						clones += <i[0].src, j[0].src>; // TODO get locs of i and j
					}
				}
			}
		}
		println(key);
	}
	println(size(hash));
	println(size(clones));
	for(clone <- clones) {
		println("clone = <clone>");
	}
}

bool compareStatements(tuple[Statement, Statement] i, tuple[Statement, Statement] j) {
	return i[1] == j[1] && i[0].src != j[0].src;
}

list[loc] subStatements(Statement blck) {
	if (\block(stmts) := blck) {
		return [b.src | /b: \block(_) := stmts];
	} 
	
	return [];
}

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
			
			case \assert(_)							: count += 1;
			case \assert(_, _)						: count += 1;
			case \break()							: count += 1;
			case \break(_)							: count += 1;
			case \continue()						: count += 1;
			case \continue(_)						: count += 1;
			case \empty()							: count += 1;
			case \return(_)							: count += 1;
			case \return()							: count += 1;
			case \case(_)							: count += 1;
			case \defaultCase()						: count += 1;
			case \throw(_)							: count += 1;
			case \expressionStatement(_)			: count += 1;
			case \constructorCall(_, _, _)			: count += 1;
			case \constructorCall(_, _)				: count += 1;
			
			
			case \declarationStatement(decl)	: {
				count += 1;
				
				visit (decl) {
					case \initializer(initializerBody)	: count += countStatements([initializerBody]);
					case \method(_, _, _, _, impl)	: count += countStatements([impl]);
					case \constructor(_, _, _, impl)	: count += countStatements([impl]);
				}
			}
		}
	}
	
	return count;
}
