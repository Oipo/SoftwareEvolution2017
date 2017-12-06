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
	int maxStmts = 100;
	int abc = 0;
	
	println("blocks gathered");
	
	for (b <- bs) {
		abc += 1;
		
		if (abc % 100 == 0) {
			println("<abc>/<size(bs)>");
		}
		
		//println(b[0].src);
		
		int key = countStatements([b[0]]);
			
		if(key >= minStmts && key <= maxStmts) {
			if (key in hash) {
				hash[key] += b;
			} else {
				hash[key] = [b];
			}
		}
	}
	
	println("hash done");
	
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
	
	for(clone <- clones) {
		println("clone = <clone>");
	}	
	
	println("size hash:\t<size(hash)>");
	println("size clones:\t<size(clones)>");
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

int countStatements(list[Statement] body) {
	int count = 0;
	
	visit (body) {
		case \block (_)		: count += 0;
		case Statement _	: count += 1;
	}
	
	return count;
}
