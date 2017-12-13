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

// print metrics for types 1 and 2 clones
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

// sum lines of code of all clones
int clonesVolume(set[Declaration] ast, int cloneType) {
	set[tuple[loc, loc]] clones = clones(ast, cloneType);
	
	return get_volume(toList({l | <l, _> <- clones}));
}

// Group all found clones into a map so that we can count how often
// they appear and print the clone only once
void printFirstCodeClones(set[tuple[loc, loc]] clones) {
	map[loc, set[loc]] files = ();
	for(key <- clones) {
		if(key[0] in files) {
			// new file
			files[key[0]] += key[1];
		} else {
			bool found = false;
			// for all <loc1, loc2> we also have <loc2, loc1>
			// so filter those
			for(file <- files) {
				if(key[1] in files[file]) {
					found = true;
					break;
				}
			}
			if(!found) {
				files[key[0]] = {key[1]};
			}
		}
	}
	
	for(file <- files) {
		code = readFile(file);
		println(<file, size(files[file]), code>);
		println();
	}
}

// find clones of given type for given ast
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

// count number of statements recursively for a given list of statements
int countStatements(list[Statement] body) {
	int count = 0;
	
	visit (body) {
		case \block (_)		: count += 0;
		case Statement _	: count += 1;
	}
	
	return count;
}

// create a hashmap of statements with and without src lines
// this due to a bug in rascal where comparing two separate statements with their src lines always returns false
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

// compare statements without src lines and make sure that we're not comparing the exact same lines to each other
bool compareStatements(tuple[Statement, Statement] i, tuple[Statement, Statement] j) {
	return i[1] == j[1] && i[0].src != j[0].src;
}

// get all subblocks of given block
list[loc] subStatements(Statement blck) {
	if (\block(stmts) := blck) {
		return [b.src | /b: \block(_) := stmts];
	} 
	
	return [];
}

// compare all clones within each buckets and subsume them if subtrees already found
set[tuple[loc, loc]] clonesFromHash(map[int, list[tuple[Statement, Statement]]] hash) {	
	set[tuple[loc, loc]] clones = {};
	
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
		//println("key:\t<key>");
	}
	
	return clones;
}

// rename all names, literals, numbers etc to the same thing, so that we can find type-2 clones
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
