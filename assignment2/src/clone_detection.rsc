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
	set[tuple[loc, loc]] clones = {};
	map[int, list[tuple[Statement, Statement]]] hash = ();
	list[tuple[Statement, Statement]] bs = [<b, unsetRec(b)> | /b: \block(_) := ast];
	
	int minStmts = 3;
	int maxStmts = 400;
	
	for (b <- bs) {
		int key = countStatements([b[0]]);
			
		if(key >= minStmts && key <= maxStmts) {
			if (key in hash) {
				hash[key] += b;
			} else {
				hash[key] = [b];
			}
		}
	}	
	
	for (key <- sort(domain(hash))) {
		if(size(hash[key]) > 1) {
			for (i <- hash[key]) {
				for (j <- hash[key]) {
					if (compareStatements(i, j)) {
						for (subStatement <- subStatements(i[0])) {
							//println(<i[0].src, subStatement>);
							clones = {x | x <- clones, x[0] != subStatement && x[1] != subStatement};
						}
						
						clones += <i[0].src, j[0].src>;
					}
				}
			}
		}
		println("key:\t<key>");
	}
	println("\ndone\n");
	println("size hash:\t<size(hash)>");
	println("size clones:\t<size(clones)>");
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
