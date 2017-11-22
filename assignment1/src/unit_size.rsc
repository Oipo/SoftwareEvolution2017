module unit_size

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import util::Math;
import IO;
import String;
import List;
import code_filtering;

// used https://www.sig.eu/files/en/090_Deriving_Metric_Thresholds_from_Benchmark_Data.pdf for thresholds
tuple[int, real, real, real, real] unit_size(M3 myModel, int total_loc) {
	myMethods = methods(myModel);
	int total_small = 0;
	int total_medium= 0;
	int total_large = 0;
	int total_very_large = 0;
	int total_methods = 0;
	
	// new metric thresholds
	int small_threshold = 30;
	int medium_threshold = 44;
	int large_threshold = 74;
	
	// old metric thresholds
	//int small_threshold = 11;
	//int medium_threshold = 21;
	//int large_threshold = 51;
	
	println("<small_threshold> <medium_threshold> <large_threshold>");
	
	for(method <- myMethods) {
		int some_count = 0;
		total_methods += 1;
		some_count = size(get_actual_code(method));
		if(some_count < small_threshold) {
			total_small += 1; 
		} else if (some_count < medium_threshold) {
			total_medium += 1;
		} else if (some_count < large_threshold) {
			total_large += 1;
		} else {
			total_very_large += 1;
		}
	}
	println("total = <total_methods>, small = <total_small>, medium = <total_medium>, large = <total_large>, very_large = <total_very_large>, <toReal(total_small)/total_methods*100>% small, <toReal(total_medium)/total_methods*100>% average, <toReal(total_large)/total_methods*100>% large, <toReal(total_very_large)/total_methods*100>% very_large");
	return <total_methods, toReal(total_small)/total_methods*100, toReal(total_medium)/total_methods*100, toReal(total_large)/total_methods*100, toReal(total_very_large)/total_methods*100>;
}