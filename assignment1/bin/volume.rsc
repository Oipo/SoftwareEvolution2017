module volume

import IO;
  
int get_volume(loc dir) {
	int lines_of_code = 0;
	
	if (!isDirectory(dir)) {
		return count_lines(dir);
	}
	
	for (file <- dir.ls) {
		if (/\*\.java/ := file.file) {
			line_of_code += count_lines(file);
		} else if (isDirectory(file)) {
			get_volume(file);
		}
	}

	return lines_of_code;
}
  
int count_lines(loc file) {
	int lines = 0;
	
	for (line <- readFileLines(file)) {
		if (// := line) {
			
		}
	}
	
	return lines;
}