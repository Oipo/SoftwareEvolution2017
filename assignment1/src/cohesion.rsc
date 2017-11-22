module cohesion

import IO;
import List;
import Set;
import util::Math;

import lang::java::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

// Based on CAM: https://pdfs.semanticscholar.org/4d36/4ce3728370ffbed22940feb23b825cf02924.pdf
list[real] cohesion(loc project) {
	list[real] result = [];

	visit(createAstsFromEclipseProject(project, true)) {
		case \class(_, _, _, body)	: result += cohesionMethod(body);
	}
	
	return result;
}

real cohesionMethod(list[Declaration] body) {
	set[Type] classParameterTypes = {};
	list[int] methodParamterTotal = [];
	list[set[Type]] methodParameterTypes = [];

	visit(body) {
		case \method(_, _, params, _, _)	: methodParameterTypes += {t | /p:\parameter(t, _, _) := params};
		//case \method(_, _, params, _)		: methodParameterTypes += {t | /p:\parameter(t, _, _) := params};
		case \constructor(_, params, _, _)	: methodParameterTypes += {t | /p:\parameter(t, _, _) := params};
	}
	
	for (e <- methodParameterTypes) {
		classParameterTypes += e;
		methodParamterTotal += size(e);
	}
	
	if (size(classParameterTypes) == 0 || size(methodParameterTypes) == 0) {
		return 0.0; 
	} else {
		return toReal(sum(methodParamterTotal)) / (size(classParameterTypes) * size(methodParameterTypes));
	}
}