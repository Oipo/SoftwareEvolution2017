module lines_of_code_test

import IO;
import volume;
import List;

test bool testLinesOfCode() {
	return get_volume([|project://assignment1/test/lines_of_code_test.java|]) == 105;
}