module volume

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import IO;
import String;
import List;
import code_filtering;
import misc;
  
int get_volume(loc dir) {
	int lines_of_code = 0;
	list[loc] files = get_files(dir);
	
	for (file <- files) {
		int lines = size(get_actual_code(file));
		println("<file> <lines>");
		lines_of_code += lines;
	}

	return lines_of_code;
}