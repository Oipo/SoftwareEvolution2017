module get_metrics

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import IO;
import List;
import Set;
import volume;
import code_duplication;
import unit_size;
import complexity;
import misc;

void get_metrics(loc project) {
	M3 m = createM3FromEclipseProject(project);
	get_metrics(m);
}

void get_metrics(M3 m) {
	list[loc] javaFiles = toList(files(m));
	
	int lines_of_code = get_volume(javaFiles);
	//int complexity = average_of(ccNumbers(javaFiles));
	tuple[int, real, real, real, real] unit_size = unit_size(m, lines_of_code);
	int duplicated = code_duplication(javaFiles);
	
	str score_loc = "";
	str score_complexity = "";
	str score_unit_size = "";
	str score_duplication = "";
	
	if(lines_of_code < 66000) {
		score_loc = "++";
	} else if (lines_of_code < 246000) {
		score_loc = "+";
	} else if (lines_of_code < 665000) {
		score_loc = "o";
	} else if (lines_of_code < 1310000) {
		score_loc = "-";
	} else {
		score_loc = "--";
	}
	
	if(unit_size[4] > 5 || unit_size[3] > 15 || unit_size[2] > 50) {
		score_unit_size = "--";
	} else if(unit_size[4] > 0 || unit_size[3] > 10 || unit_size[2] > 40) {
		score_unit_size = "-";
	} else if(unit_size[3] > 5 || unit_size[2] > 30) {
		score_unit_size = "o";
	} else if(unit_size[3] > 0 || unit_size[2] > 25) {
		score_unit_size = "+";
	} else {
		score_unit_size = "++"; 
	}
	
	if(duplicated >= 20) {
		score_duplication = "--";
	} else if(duplicated >= 10) {
		score_duplication = "-";
	} else if(duplicated >= 5) {
		score_duplication = "o";
	} else if(duplicated >= 3) {
		score_duplication = "+";
	} else {
		score_duplication = "++";
	}
	
	println("metrics:");
	println("lines of code: <lines_of_code>");
	println("unit size: <unit_size>");
	println("duplicated code: <duplicated>");
	
	println("");
	
	println("scores:");
	println("lines of code: <score_loc>");
	println("unit size: <score_unit_size>");
	println("duplicated code: <score_duplication>");
}