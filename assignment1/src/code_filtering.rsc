module code_filtering

import IO;
import String;
import List;

bool is_single_line_comment(str total, int pos) {
// todo check if program will be run on osx for grading
	int lastNewline = findLast(total[..pos], "\n");
	
	if(lastNewline < 0) {
		lastNewline = 0;
	}
	
	for(commentPos <- findAll(total[lastNewline..pos], "//")) {
		if(!is_inside_string(total, commentPos)) {
			return true;
		}
	}
	
	return false;
}

bool is_inside_string(str total, int pos) {
	int lastNewline = findLast(total[..pos], "\n");
			
	if(lastNewline < 0) {
		lastNewline = 0;
	}
	
	list[int] numberOfQuotes = findAll(total[lastNewline..pos], "\"");

	return size(numberOfQuotes) % 2 == 1;
}

list[str] get_actual_code(loc file) {
	int lines = 0;
	
	str total = readFile(file);
	int multiline_opening = findFirst(total, "/*");
	int multiline_ending = -1;
	//println("multiline = <multiline_opening> for file <file>");
	//println("total = <total>");
	
	while(multiline_opening >= 0) {
		
		// /*/
		//"/*"
		if(is_single_line_comment(total, multiline_opening) || is_inside_string(total, multiline_opening)) {
			if(multiline_opening + 2 >= size(total)) {
				break;
			}
		
			int old_opening = multiline_opening;
			multiline_opening = findFirst(total[old_opening+2..], "/*");
			if(multiline_opening >= 0) {
				multiline_opening += old_opening + 2;
				//println("incorrect opening: <multiline_opening> <total[multiline_opening..multiline_opening+50]>");
			}
			
			continue;
		}
		
		bool ending_found = false;
		for(endingPos <- findAll(total[multiline_opening+2..], "*/")) {
			endingPos += multiline_opening+2;
			
			if(is_inside_string(total, endingPos)) {
				continue;
			}

			multiline_ending = endingPos;
			ending_found = true;
			break;
		}
		
		if(!ending_found) {
			println("missing ending for <multiline_opening> <multiline_ending> <total>");
			break;
		}
		
		//println("new occurance: <total[multiline_opening..multiline_ending+2]>");
		
		total = total[..multiline_opening] + total[multiline_ending+2..]; 
		//println("size: <multiline_opening> <multiline_ending> <size(total)>");
		
		int old_opening = multiline_opening;
		multiline_opening = findFirst(total[multiline_opening..], "/*");
		if(multiline_opening >= 0) {
			multiline_opening += old_opening;
		}
	}
	
	list[str] actualCode = [];
	for (line <- split("\n", total)) {
		trimmedLine = trim(line);
		//println("line = <line>");
		
		if(startsWith(trimmedLine, "//") || size(trimmedLine) == 0) {
		//if(size(trimmedLine) == 0) {
			//println("skipping line <trimmedLine>");
			continue;
		}
		
		actualCode += trimmedLine;
	}
	
	//println("<file> <size(actualCode)>");
	//println("<total>");
	
	return actualCode;
}