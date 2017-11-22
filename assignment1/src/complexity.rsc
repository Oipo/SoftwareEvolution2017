module complexity

import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;
import util::Math;
import volume;

tuple[int, real, real, real, real] distribution_of_complexity(list[tuple[str, list[tuple[str, int]]]] complexities) {
	int total_small = 0;
	int total_medium= 0;
	int total_large = 0;
	int total_very_large = 0;
	int total_methods = 0;
	
	int small_threshold = 11;
	int medium_threshold = 21;
	int large_threshold = 51; 
	
	for(tuple[str, list[tuple[str, int]]] file <- complexities) {
		for(tuple[str, int] method <- file[1]) {
			some_count = method[1];
			if(some_count < small_threshold) {
				total_small += 1; 
			} else if (some_count < medium_threshold) {
				total_medium += 1;
			} else if (some_count < large_threshold) {
				total_large += 1;
			} else {
				total_very_large += 1;
			}
			total_methods += 1;
		}
	}
	
	println("total = <total_methods>, small = <total_small>, medium = <total_medium>, large = <total_large>, very_large = <total_very_large>, <toReal(total_small)/total_methods*100>% small, <toReal(total_medium)/total_methods*100>% average, <toReal(total_large)/total_methods*100>% large, <toReal(total_very_large)/total_methods*100>% very_large");
	return <total_methods, toReal(total_small)/total_methods*100, toReal(total_medium)/total_methods*100, toReal(total_large)/total_methods*100, toReal(total_very_large)/total_methods*100>;
}

list[real] ccRating(M3 m) {
	list[real] ratings = [0.0,0.0,0.0]; // [very high, high, moderate]
	int volume = 0;
	int total_volume = 0;

	for (unit <- ccNumbers2(m)) {
		volume = get_volume([unit[0]]);
		total_volume += volume; 
		
		if (unit[1] > 50) {
			ratings[0] += volume;
		} else if (unit[1] > 20) {
			ratings[1] += volume;
		} else if (unit[1] > 10) {
			ratings[2] += volume;
		}
	}
	
	// TODO divide by zero
	for (i <- [0..3]) {
		ratings[i] /= total_volume;
	}
	
	return ratings;
}

list[tuple[loc, int]] ccNumbers2(M3 m) {
	list[tuple[loc, int]] complexities = [];
	
	for (file <- files(m)) {
		Declaration ast = createAstFromFile(file, true);

		visit(ast) {
			case \method(_, name, _, _, impl) : complexities += <file, ccStatement(impl)>;
			case \constructor(name, _, _, Statement impl) : complexities += <file, ccStatement(impl)>;
		}
	}
	
	return complexities;
}

list[tuple[loc, list[tuple[str, int]]]] ccNumbers(M3 m) {
	list[tuple[loc, list[tuple[str, int]]]] complexities = [];
	
	for (file <- files(m)) {
		Declaration ast = createAstFromFile(file, true);
		list[tuple[str, int]] tempx = [];
	
		visit(ast) {
			case \method(_, name, _, _, impl) : tempx += <"<name>", ccStatement(impl)>;
			case \constructor(name, _, _, Statement impl) : tempx += <"<name>", ccStatement(impl)>;
		}
		
		complexities += <file, tempx>;
	}
	
	return complexities;
}


int ccStatement(value methodBody) {
	int complexity = 1;

	visit(methodBody) {
		case \do(_, condition)			: complexity += 1 + ccExpression(condition);
		case \foreach(_, _, _)			: complexity += 1;
		case \for(_, _, _)				: complexity += 1;
		case \for(_, condition, _, _)	: complexity += 1 + ccExpression(condition);
		case \if(condition,	_)			: complexity += 1 + ccExpression(condition);
		case \if(_, _, _)				: complexity += 1;
		case \switch(_, _)				: complexity += 1;
		case \case(_)					: complexity += 1;
		//case \defaultcase				: complexity += 1;
		case \catch(_, _)				: complexity += 1;
		case \while(condition, _)		: complexity += 1 + ccExpression(condition);
	}
	
	return complexity;
}

int ccExpression(value expr) {
	int complexity = 0;
	
	visit(expr) {
		case \infix(_, operator, _)	: complexity += ccOperator(operator);
	}
	
	return complexity;
}

int ccOperator(str operator) {
	switch (operator) {
		case "||"	: return 1;
		case "&&"	: return 1;
	}
	return 0;
}