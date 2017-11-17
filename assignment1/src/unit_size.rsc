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
int unit_size(M3 myModel) {
	myMethods = methods(myModel);
	int total_small = 0;
	int total_mediocre = 0;
	int total_large = 0;
	int total_methods = 0;
	int total_complexity = 0;
	for(method <- myMethods) {
		int some_count = 0;
		total_methods += 1;
		some_count = size(get_actual_code(method));
		if(some_count < 30) {
			total_small += 1; 
		} else if (some_count < 44) {
			total_mediocre += 1;
		} else {
			total_large += 1;
		}
		//println("method = <method>, total_complexity = <total_complexity>, total_methods = <total_methods>");
	}
	// todo figure out the threshold values for unit sizes to determine ranking
	println("total = <total_methods>, small = <total_small>, mediocre = <total_mediocre>, large = <total_large>, <toReal(total_small)/total_methods*100>, <toReal(total_mediocre)/total_methods*100>, <toReal(total_large)/total_methods*100>");
	return 0;
}