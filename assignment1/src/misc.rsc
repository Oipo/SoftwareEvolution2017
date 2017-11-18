module misc

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import IO;
import List;
import Set;

int count_files(loc dir) {
	int files = 0;
	
	if (!isDirectory(dir)) {
		if (/\.java$/ := dir.file) {
			return 1;
		} else {
			return 0;
		}
	}
	
	for (file <- dir.ls) {
		if (isDirectory(file)) {
			files += count_files(file);
		} else if (/\.java$/ := file.file) {
			files += 1;
		}
	}

	return files;
}

list[loc] get_files(loc dir) {
	list[loc] files = [];
	
	if (!isDirectory(dir)) {
		if (/\.java$/ := dir.file) {
			return [dir];
		} else {
			return [];
		}
	}
	
	for (file <- dir.ls) {
		if (isDirectory(file)) {
			files += get_files(file);
		} else if (/\.java$/ := file.file) {
			files += file;
		}
	}

	return files;
}

void list_diff(loc dir, M3 m) {
	list[loc] dirFiles = get_files(dir);
	set[loc] mFiles = files(m);
	
	for(f <- dirFiles) {
		bool found = false;
		
		for(f2 <- mFiles) {
			if(f2.path == f.path) {
				found = true;
				break;
			}
		}
		
		if(!found) {
			println("<f> not found in model");
		}
	}
	
	for(f <- mFiles) {
		bool found = false;
		
		for(f2 <- dirFiles) {
			if(f2.path == f.path) {
				found = true;
				break;
			}
		}
		
		if(!found) {
			println("<f> not found in dir");
		}
	}
}