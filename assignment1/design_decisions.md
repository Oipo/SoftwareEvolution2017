# Results

## smallsql0.21_src

## hsqldb

# Design decisions

## Volume

- Only count lines actually in eclipse project
- Assume that multi line comments always have an ending, otherwise potentially too many lines may be filtered
- Doesn't use regexes because regexes are hard to make correct as well as slower than findFirst/Last/All

## Unit size

- used https://www.sig.eu/files/en/090_Deriving_Metric_Thresholds_from_Benchmark_Data.pdf [1] for thresholds since these calculated new thresholds based on multiple projects and found that these metrics are more resilient to large system outliers. Look for Table IV for the new metrics.

- The results for smallsql change from
	81.25% small, 9.21% moderate, 7.46% high, 2.08% very high
  to
  	97.58% small, 2.13% moderate, 0.21% high, 0.08% very high

- The results for hsqldb change from
	67.53% small, 16.44% moderate, 11.33% high, 4.70% very high
  to
  	99.84% small, 00.15% moderate, 00.01% high, 0.00% very high

## Complexity
At first we decided to create an AST for every file in the M3 model, but creating the AST directly from the eclipse project was about 5 seconds faster for both eclipse projects (likely because of less overhead).

We visit the tree twice once for methods and constructors and once for specific statements, because we to be able to match the complexity we get from statements to the unit (method or constructor) it belongs to.

We decided to only include statements to increase the complexity that cause another branch in the control flow of an unit. (McCabe)

We decided to increase the complexity for every logical and and logicol or in the condition of a statement, because it creates another branch in the control flow of an unit. (Jurgen Vinju)

We decided to take the total volume of all methods instead of the whole eclipse project when determing the cyclomatic complexity rating, because we think it would be a more accurate representation.

## Code duplication

- Count both original and duplicated code as duplicates, impossible to know which of the two is the actual original
- Currently uses whole files which means it includes all import statements and may mark those as duplicate, even though that information isn't actually useful. Using methods instead of files is an easy change.
- Makes a hash of each combination of 6 lines and checks if there's a hash collision, if so, marks them as duplicates.

// TODO
- Put in report difference between new and old unit size metrics
- Why put operators in separate funtion, does it have an impact at all?
- Why would switch cases count? Put in report.
- LOC counting, toevoegen rudimentary tests, wat zijn de corner cases?
- Add one or two new metrics based on new sig paper and put this in the report
- Put in results 
- How long did it take
- Threats to validity and how it was addressed
// TODO

# threats to validity

- Java 7 will support things such as multiline strings, which are not accounted for in this project, future versions might change syntax rules further.
- Original paper wasn't explicit enough about some metrics, leading to potential deviations
- New papers (such as the one we used for unit size) might change metric definitions or worse, deprecate them.
- Implementation might be buggy, more tests should be added to mitigated that.

# time taken

- Michael: 80 hours
- Constantijn: ?? hours

# References

[1] T. L. Alves, C. Ypma and J. Visser, "Deriving metric thresholds from benchmark data," 2010 IEEE International Conference on Software Maintenance, Timisoara, 2010, pp. 1-10.
doi: 10.1109/ICSM.2010.5609747
URL: http://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=5609747&isnumber=5609528