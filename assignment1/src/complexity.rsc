module complexity

import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;
import util::Math;
import volume;

tuple[int, real, real, real, real] ccRating(loc l) {
	tuple[int, real, real, real, real] ratings = <0, 0.0, 0.0,0.0,0.0>; // [loc, small, moderate, high, very high]
	
	int volume = 0;
	int total_volume = 0;
	
	int very_high_threshold = 50;
	int high_threshold = 20;
	int moderate_threshold = 10;

	for (unit <- ccNumbers(l)) {
		volume = get_volume([unit[0]]);
		total_volume += volume; 
		
		if (unit[1] > very_high_threshold) {
			ratings[4] += volume;
		} else if (unit[1] > high_threshold) {
			ratings[3] += volume;
		} else if (unit[1] > moderate_threshold) {
			ratings[2] += volume;
		} else {
			ratings[1] += volume;
		}
	}

	if (total_volume != 0) {
		for (i <- [1..5]) {
			ratings[i] = ratings[i] / total_volume * 100.0;
		}
	} else {
		ratings[1] == 100.0;
	}
	
	ratings[0] = total_volume;
	
	return ratings;
}

list[tuple[loc, int]] ccNumbers(loc l) {
	list[tuple[loc, int]] complexities = [];
	
	visit(createAstsFromEclipseProject(l, true)) {
		case \method(_, _, _, _, impl) : complexities += <impl.src, ccStatement(impl)>;
		case \constructor(_, _, _, Statement impl) : complexities += <impl.src, ccStatement(impl)>;
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
		case \catch(_, _)				: complexity += 1;
		case \while(condition, _)		: complexity += 1 + ccExpression(condition);
	}
	
	return complexity;
}

int ccExpression(value expr) {
	int complexity = 0;
	
	visit(expr) {
		case \infix(_, "&&", _)	: complexity += 1;
		case \infix(_, "||", _)	: complexity += 1;
	}
	
	return complexity;
}