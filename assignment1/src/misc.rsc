module misc

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