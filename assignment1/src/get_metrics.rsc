module get_metrics

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import util::Math;
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

str int_to_score(int score) {
	switch(score) {
		case -2: return "--";
		case -1: return "-";
		case 0: return "o";
		case 1: return "+";
		case 2: return "++";
	}
}

void get_metrics(M3 m) {
	list[loc] javaFiles = toList(files(m));
	
	int lines_of_code = get_volume(javaFiles);
	tuple[int, real, real, real, real] complexity = distribution_of_complexity(ccNumbers(m));
	tuple[int, real, real, real, real] unit_size = unit_size(m, lines_of_code);
	tuple[int, int] duplicated = code_duplication2(javaFiles);
	
	int score_loc = -3;
	int score_complexity = -3;
	int score_unit_size = -3;
	int score_duplication = -3;
	
	if(lines_of_code < 66000) {
		score_loc = 2;
	} else if (lines_of_code < 246000) {
		score_loc = 1;
	} else if (lines_of_code < 665000) {
		score_loc = 0;
	} else if (lines_of_code < 1310000) {
		score_loc = -1;
	} else {
		score_loc = -2;
	}
	
	if(unit_size[4] > 5 || unit_size[3] > 15 || unit_size[2] > 50) {
		score_unit_size = -2;
	} else if(unit_size[4] > 0 || unit_size[3] > 10 || unit_size[2] > 40) {
		score_unit_size = -1;
	} else if(unit_size[3] > 5 || unit_size[2] > 30) {
		score_unit_size = 0;
	} else if(unit_size[3] > 0 || unit_size[2] > 25) {
		score_unit_size = 1;
	} else {
		score_unit_size = 2; 
	}
	
	if(complexity[4] > 5 || complexity[3] > 15 || complexity[2] > 50) {
		score_complexity = -2;
	} else if(complexity[4] > 0 || complexity[3] > 10 || complexity[2] > 40) {
		score_complexity = -1;
	} else if(complexity[3] > 5 || complexity[2] > 30) {
		score_complexity = 0;
	} else if(complexity[3] > 0 || complexity[2] > 25) {
		score_complexity = 1;
	} else {
		score_complexity = 2; 
	}
	
	if(duplicated[1] >= 20) {
		score_duplication = -2;
	} else if(duplicated[1] >= 10) {
		score_duplication = -1;
	} else if(duplicated[1] >= 5) {
		score_duplication = 0;
	} else if(duplicated[1] >= 3) {
		score_duplication = 1;
	} else {
		score_duplication = 2;
	}
	
	println("metrics:");
	println("lines of code: <lines_of_code>");
	println("unit size: <unit_size>");
	println("complexity: <complexity>");
	println("duplicated code: <duplicated>");
	
	println("");
	
	println("scores:");
	println("lines of code: <int_to_score(score_loc)>");
	println("unit size: <int_to_score(score_unit_size)>");
	println("complexity: <int_to_score(score_complexity)>");
	println("duplicated code: <int_to_score(score_duplication)>");
	
	println("");
	
	println("analysability: <int_to_score(round(toReal(score_loc + score_duplication + score_unit_size)/3))>");
	println("changeability: <int_to_score(round(toReal(score_complexity + score_duplication)/2))>");
	println("stability: N/A");
	println("testability: <int_to_score(round(toReal(score_complexity + score_unit_size)/2))>");
}