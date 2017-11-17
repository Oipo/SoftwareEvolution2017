module code_duplication

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import util::Math;
import IO;
import String;
import List;
import Set;
import code_filtering;
import misc;

int code_duplication(loc dir) {
	list[loc] javaFiles = get_files(dir);
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
				duplicatedLines += y;
			}
		}
		if(x % 10 == 0) {
			println("<x> <size(lines)>");
		}
	}
	
	return size(duplicatedLines);
}