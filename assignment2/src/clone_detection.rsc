module clone_detection

import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;
import util::ValueUI;
import util::Math;
import List;
import Map;
import Set;
import Node;
import volume;
import code_filtering;
import Type;

void getMetrics(set[Declaration] ast, M3 m) {
	int totalLines = get_volume(toList(files(m)));
	
	for (i <- [1..3]) {
		set[tuple[loc, loc]] clones = clones(ast, i);
		int clonedLines = get_volume(toList({l | <l, _> <- clones}));
		
		println("Code clone type-<i>:");
		println("Number of clones:\t\t<size(clones)>");
		println("Number of cloned lines:\t\t<clonedLines>");
		println("Percentage of cloned lines:\t<100.0 * clonedLines / totalLines>%");
		println();
	}
}

int clonesVolume(set[Declaration] ast, int cloneType) {
	set[tuple[loc, loc]] clones = clones(ast, cloneType);
	
	return get_volume(toList({l | <l, _> <- clones}));
}

set[tuple[loc, loc]]  clones(set[Declaration] ast, int cloneType) {	
	//println("hashing blocks");
	
	if (cloneType == 2) {
		ast = toTypeTwoCloneAst(ast);
	}
	
	map[int, list[tuple[Statement, Statement]]] hash = hashBlocks(ast);
	
	//println("hashing done");
	//println("comparing keys:\n");
	
	set[tuple[loc, loc]] clones = clonesFromHash(hash);
	
	//println("\ncomparing done\n");
	
	//for(clone <- clones) {
	//	println("clone = <clone>");
	//}
	
	//println("\nsize hash:\t<size(hash)>");
	//println("size clones:\t<size(clones)>");
	
	//text(clones);
	
	return clones;
}

int countStatements(list[Statement] body) {
	int count = 0;
	
	visit (body) {
		case \block (_)		: count += 0;
		case Statement _	: count += 1;
	}
	
	return count;
}

map[int, list[tuple[Statement, Statement]]] hashBlocks(set[Declaration] ast) {
	map[int, list[tuple[Statement, Statement]]] hash = ();
	
	int minStmts = 3;
	int maxStmts = 100;	
	
	visit (ast) {
		case b: \block(_)	: {
			int key = countStatements([b]);
			
			if (key >= minStmts && key <= maxStmts) {
				if (key in hash) {
					hash[key] += <b, unsetRec(b)>;
				} else {
					hash[key] = [<b, unsetRec(b)>];
				}
			}
		}
	}
	
	return hash;
}

real compareTree(tuple[Statement, Statement] i, tuple[Statement, Statement] j) {
	list[Statement] subTree1 = subStatements2(i[1]);
	list[Statement] subTree2 = subStatements2(j[1]);
	int numberOfSharedNodes = 0;
	
	for (x <- subTree1) {
		for (y <- subTree2) {
			if (x == y) {
				numberOfSharedNodes += 1;
			}
		}
	}
	
	int divisor = 2 * numberOfSharedNodes + size(subTree1 - subTree2) + size(subTree2 - subTree1);
	
	if (divisor == 0) {
		return 0.0;
	} else {
		return (2.0 * numberOfSharedNodes) / divisor;
	}
}

list[Statement] subStatements2(Statement blck) {
	if (\block(stmts) := blck) {
		return [b | /b: \block(_) := stmts] + blck;
	} 
	
	return [blck];
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

set[tuple[loc, loc]] clonesFromHash(map[int, list[tuple[Statement, Statement]]] hash) {	
	set[tuple[loc, loc]] clones = {};
	
	for (key <- sort(domain(hash))) {
		if(size(hash[key]) > 1) {
			for (i <- hash[key]) {
				for (j <- hash[key]) {
					if (compareStatements(i, j)) {
						for (subStatement <- subStatements(i[0])) {
							//println(<i[0].src, subStatement>);
							clones = {clone | clone <- clones, clone[0] != subStatement && clone[1] != subStatement};
						}
						
						clones += <i[0].src, j[0].src>;
					}
				}
			}
		}
		//println("key:\t<key>");
	}
	
	return clones;
}

set[Declaration] toTypeTwoCloneAst(set[Declaration] ast) {
	return visit (ast) {
		//case \newArray(_, d, i)			=> \newArray(\boolean(), d, i)
    	//case \newArray(_, d)				=> \newArray(Boolean, d)
    	//case \newObject(e, _, a, c)		=> \newObject(e, Boolean, a, c)
    	//case \newObject(e, _,a)			=> \newObject(e, Boolean, a)
    	//case \fieldAccess(i, e, _)		=> \fieldAccess(i, e, "")
    	case \methodCall(i, _, a)		=> \methodCall(i, "", a)
    	case \methodCall(i, r, _, a)	=> \methodCall(i, r, "", a)
		case \number(_)					=> \booleanLiteral(true)
		case \booleanLiteral(_)			=> \booleanLiteral(true)
		case \stringLiteral(_)			=> \booleanLiteral(true)
		//case \type(_)					=> \type(typeOf(true))
		case \variable(_, d)			=> \variable("", d)
		case \variable(_, d, i)			=> \variable("", d, i)
		//case \prefix(_, _)				=> none
		case \simpleName(_)				=> \simpleName("")
		
		//case \arrayType(_)				=> \boolean()
		//case \parameterizedType(_)		=> \boolean()
		//case \qualifiedType(_, _)		=> \boolean()
		//case \simpleType(_)				=> \boolean()
		//case \unionType(_)				=> \boolean()
		case \wildcard()				=> \boolean()
		//case \upperbound(_)				=> \boolean()
		//case \lowerbound(_)				=> \boolean()
		case \int() 					=> \boolean()
		case \short()					=> \boolean()
		case \long()					=> \boolean()
		case \float()					=> \boolean()
		case \double()					=> \boolean()
		case \char()					=> \boolean()
		case \string()					=> \boolean()
		case \byte()					=> \boolean()
		case \void()					=> \boolean()
	};
}
