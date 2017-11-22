# Design decisions

## Volume

- Only count lines actually in eclipse project
- Assume that multi line comments always have an ending, otherwise potentially too many lines may be filtered
- Doesn't use regexes because regexes are hard to make correct as well as slower than findFirst/Last/All

## Unit size

- used https://www.sig.eu/files/en/090_Deriving_Metric_Thresholds_from_Benchmark_Data.pdf for thresholds
- These changes mean that unit size is relative to LOC of the project.
- small threshold is all units less than 0.2% of total LOC
- moderate threshold is all units >= 0.2% and < 0.6% of total LOC
- large threshold is all units >= 0.6% and < 1% of total LOC
- very large is >= 1% of total LOC

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


- Put in report difference between new and old unit size metrics
- Why put operators in separate funtion, does it have an impact at all?
- Why would switch cases count? Put in report.
- LOC counting, toevoegen rudimentary tests, wat zijn de corner cases?
- Add one or two new metrics based on new sig paper and put this in the report
- Put in results 
- How long did it take
- Threats to validity and how it was addressed
- 