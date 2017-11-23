Best viewable in https://dillinger.io/

# Results

## smallsql0.21_src
```
metrics:
lines of code: 24050
// <total units, small%, moderate%, high%, very high%>
unit size: <2400,97.5833333300,2.12500,0.208333333300,0.0833333333300> 
// <LoC of measured methods, small%, moderate%, high%, very high%>
complexity: <20952,73.78770523000,8.151966399000,12.07044674000,5.989881634000> 
// <total lines, % duplicated of total>
duplicated code: <2706,11.2515592500> 
cohesion (avg of all classes): 0.12642373008646

scores:
lines of code: ++
unit size: -
complexity: --
duplicated code: -

analysability: o
changeability: --
stability: N/A
testability: --
```
## hsqldb
```
metrics:
lines of code: 172446
unit size: <10858,99.8434334100,0.147356787600,0.00920979922600,0.>
complexity: <149918,64.78141384000,14.23644926000,11.14542617000,9.836710735000>
duplicated code: <35070,20.3368010900>
cohesion (avg of all classes): 0.179043783172902

scores:
lines of code: +
unit size: +
complexity: --
duplicated code: --

analysability: o
changeability: --
stability: N/A
testability: -
```

## tests
```
rascal>:test
Running tests for lines_of_code_test
Test report for lines_of_code_tests                                                       
        all 1/1 tests succeeded
```

# Design decisions

## Volume

- Only count lines actually in eclipse project
- Assume that multi line comments always have an ending, otherwise potentially too many lines may be filtered
- Doesn't use regexes because regexes are hard to make correct as well as slower than findFirst/Last/All

## Unit size

We used [1] for thresholds since these calculated new thresholds based on multiple projects and found that these metrics are more resilient to large system outliers. Look for Table IV for the new metrics.

The idea here is that larger projects have a higher chance of creating methods in the high and very high risk categories, simply due to having more code. To mitigate this, the unit size category recalculates the thresholds depending on LoC. 

- The results for smallsql change from
`81.25% small, 9.21% moderate, 7.46% high, 2.08% very high`
  to
`97.58% small, 2.13% moderate, 0.21% high, 0.08% very high`

- The results for hsqldb change from
`67.53% small, 16.44% moderate, 11.33% high, 4.70% very high`
  to
`99.84% small, 00.15% moderate, 00.01% high, 0.00% very high`

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

## Cohesion Among Methods of Class

[2] adds several metrics, of which cohesion is noted to have a significant effect on a program's understandability and readability. We thought that the SIG model didn't include many measures that tried to measure code that relies upon other code, which cohesion does try to do.

# threats to validity

- Java 7 will support things such as multiline strings, which are not accounted for in this project, future versions might change syntax rules further. In general, any code analysing software needs to be maintained just like any other piece of software.
- Original paper wasn't explicit enough about some metrics, leading to potential deviations. We used [1] for example to make measuring unit sizes more clear.
- New papers (such as the one we used for unit size) might change metric definitions or worse, deprecate them. This falls in the same category as the aforementioned language updates.
- Implementation might be incorrect, more tests should be added to mitigate that. We used [3] to verify Lines of Code and Complexity, though found that [3] calculates complexity incorrectly. Another measure taken to ascertain correctness of our results is comparing them to other students in the course. 

# time taken

- Michael: 80 hours
- Constantijn: ?? hours

# References

[1] T. L. Alves, C. Ypma and J. Visser, "Deriving metric thresholds from benchmark data," 2010 IEEE International Conference on Software Maintenance, Timisoara, 2010, pp. 1-10.
doi: 10.1109/ICSM.2010.5609747
URL: http://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=5609747&isnumber=5609528

[2] J. Bansiya and C. G. Davis, "A hierarchical model for object-oriented design quality assessment," in IEEE Transactions on Software Engineering, vol. 28, no. 1, pp. 4-17, Jan 2002.
doi: 10.1109/32.979986
URL: http://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=979986&isnumber=21111

[3] LocMetrics
URL: http://www.locmetrics.com/