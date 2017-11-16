module complexity

import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

list[tuple[str, list[tuple[str, int]]]] ccNumbers(M3 m) {
	list[tuple[str, list[tuple[str, int]]]] complexities = [];
	
	for (file <- files(m)) {
		Declaration ast = createAstFromFile(file, true);
		list[tuple[str, int]] tempx = [];
	
		visit(ast) {
			case \method(_, name, _, _, impl) : tempx += <"<name>", cyclomaticNumber(impl)>;
		}
		
		complexities += <"<file>", tempx>;
	}
	
	return complexities;
}

// TODO methods with the same name
list[tuple[str, int]] cyclomaticNumbers(loc project) {
	list[tuple[str, int]] complexities = [];
	set[Declaration] decls = createAstsFromEclipseProject(project, true);

	for (body <- [[methodName, methodBody] | /c:\method(_, methodName, _, _, methodBody) := decls]) {
		complexities += <"<body[0]>", cyclomaticNumber(body[1])>;
	}

	return complexities;
}


int cyclomaticNumber(value methodBody) {
	int complexity = 1;
		
	 //TODO always does the same in every case
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
		case \infix(_, operator, _) : complexity += ccOperator(operator);
	}
	
	return complexity;
}

int ccOperator(str operator) {
	if (operator == "||" || operator == "&&") {
		return 1;
	}
	return 0;
}

int test1(set[Declaration] ast) {
	visit(ast) {
		case \class(name, extends1, implements, body)	: {print("<name>\n"); test2(body);}
		
	}
	return 1;
}

int test2(value body) {
	visit(body) {
		case \method(_, name, _, _, _) : print("\t<name>\n");
	}
	return 1;
}