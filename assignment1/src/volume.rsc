module volume

import IO;
import String;
  
int get_volume(loc dir) {
	int lines_of_code = 0;
	
	if (!isDirectory(dir)) {
		if (/\.java$/ := dir.file) {
			return count_lines(dir);
		} else {
			return 0;
		}
	}
	
	for (file <- dir.ls) {
		if (isDirectory(file)) {
			lines_of_code += get_volume(file);
		} else if (/\.java$/ := file.file) {
			lines_of_code += count_lines(file);
		}
	}

	return lines_of_code;
}
  
int count_lines(loc file) {
	int lines = 0;
	
	total = readFile(file);
	str total_without_comments = "";
	str temp = total;
	int multiline_occurance = findFirst(total, "/*");
	println("multiline = <multiline_occurance> for file <file>");
	
	while(multiline_occurance >= 0) {
		total_without_comments = total_without_comments + temp[0..multiline_occurance];
		//println("total_without_comments = <total_without_comments>");
		temp = temp[multiline_occurance+2..];
		//println("temp = <temp>");
		int ending = findFirst(temp, "*/");
		if(ending < 0) {
			break;
		}
		temp = temp[ending+2..];
		//println("temp = <temp>");
		multiline_occurance = findFirst(temp, "/*");
	}
	
	str countedLines = "";
	for (line <- split("\n", total_without_comments)) {
		trimmedLine = trim(line);
		
		if(startsWith(trimmedLine, "//") || size(trimmedLine) == 0) {
			continue;
		}
		
		countedLines += line + "\r\n";
		
		lines += 1;
	}
	loc output = |home:///test_output.java|;
	touch(output);
	writeFile(output, countedLines);
	
	return lines;
}