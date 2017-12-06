module clone_detection

import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;
import util::ValueUI;
import List;
import Map;
import Set;
import Node;

void clones(set[Declaration] ast) {	
	println("hashing blocks");
	
	map[int, list[tuple[Statement, Statement]]] hash = hashBlocks(ast);
	
	println("hashing done");
	println("comparing keys:");
	
	set[tuple[loc, loc]] clones = clonesFromHash(hash);
	
	println("\ncomparing done\n");
	
	for(clone <- clones) {
		println("clone = <clone>");
	}
	
	println("\nsize hash:\t<size(hash)>");
	println("size clones:\t<size(clones)>");
	
	text(clones);
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
							clones = {x | x <- clones, x[0] != subStatement && x[1] != subStatement};
						}
						
						clones += <i[0].src, j[0].src>;
					}
				}
			}
		}
		println("key:\t<key>");
	}
	
	return clones;
}
