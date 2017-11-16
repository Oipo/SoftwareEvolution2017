module volume

import IO;
import String;
import List;
import code_filtering;
  
int get_volume(loc dir) {
	int lines_of_code = 0;
	
	if (!isDirectory(dir)) {
		if (/\.java$/ := dir.file) {
			int lines = size(get_actual_code(file));
			println("<dir> <lines>");
			return lines;
		} else {
			return 0;
		}
	}
	
	for (file <- dir.ls) {
		if (isDirectory(file)) {
			lines_of_code += get_volume(file);
		} else if (/\.java$/ := file.file) {
			int lines = size(get_actual_code(file));
			println("<file> <lines>");
			lines_of_code += lines;
		}
	}

	return lines_of_code;
}
