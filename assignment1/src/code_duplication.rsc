module code_duplication

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import util::Math;
import IO;
import String;
import List;
import Set;
import Map;
import code_filtering;
import misc;

tuple[int, real] code_duplication2(list[loc] javaFiles) {
	list[str] lines = [];
	int total_lines = 0;
	set[int] duplicatedLines = {};
	
	for(f <- javaFiles) {
		l = get_actual_code(f);
		total_lines += size(l);
		
		lines += l;
		//println("<method> <size(l)>");
	}
	
	println(total_lines);
	
	map[list[str], list[int]] hashmap = ();
	for(x <- [0..size(lines)-6]) {
		if(lines[x..x+6] in hashmap) {
			hashmap[lines[x..x+6]] += x;
		} else {
			hashmap[lines[x..x+6]] = [x];
		}
	}
	
	for(key <- hashmap) {
		if(size(hashmap[key]) > 1) {
			//println("line1 = <lines[hashmap[key][0]..hashmap[key][0]+6]>");
			//println("line2 = <lines[hashmap[key][1]..hashmap[key][1]+6]>");
			for(x <- hashmap[key]) {
				duplicatedLines += x;
				duplicatedLines += x+1;
				duplicatedLines += x+2;
				duplicatedLines += x+3;
				duplicatedLines += x+4;
				duplicatedLines += x+5;
			}
		}
	}
	
	return <size(duplicatedLines), toReal(size(duplicatedLines))/total_lines*100>;
}

tuple[int, int] code_duplication_slow(list[loc] javaFiles) {
	list[str] lines = [];
	set[int] duplicatedLines = {};
	
	for(f <- javaFiles) {
		l = get_actual_code(f);
		lines += l;
		println("<f> <size(l)>");
	}
	
	for(x <- [0..size(lines)-6]) {
		for(y <- [x+6..size(lines)-5]) {
			if(lines[x] == lines[y] &&
				lines[x+1] == lines[y+1] &&
				lines[x+2] == lines[y+2] &&
				lines[x+3] == lines[y+3] &&
				lines[x+4] == lines[y+4] &&
				lines[x+5] == lines[y+5]) {
				duplicatedLines += x;
				duplicatedLines += x+1;
				duplicatedLines += x+2;
				duplicatedLines += x+3;
				duplicatedLines += x+4;
				duplicatedLines += x+5;
				duplicatedLines += y;
				duplicatedLines += y+1;
				duplicatedLines += y+2;
				duplicatedLines += y+3;
				duplicatedLines += y+4;
				duplicatedLines += y+5;
			}
		}
		if(x % 20 == 0) {
			println("<x> <size(lines)>");
		}
	}
	
	return <size(duplicatedLines), round(toReal(size(duplicatedLines))/size(lines)*100)>;
}