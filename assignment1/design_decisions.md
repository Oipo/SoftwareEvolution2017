# Design decisions

## Volume

## Unit size

## Complexity
At first we decided to create an AST for every file in the M3 model, but creating the AST directly from the eclipse project was about 5 seconds faster for both eclipse projects (likely because of less overhead).

We visit the tree twice once for methods and constructors and once for specific statements, because we to be able to match the complexity we get from statements to the unit (method or constructor) it belongs to.

We decided to only include statements to increase the complexity that cause another branch in the control flow of an unit. (McCabe)

We decided to increase the complexity for every logical and and logicol or in the condition of a statement, because it creates another branch in the control flow of an unit. (Jurgen Vinju)

We decided to take the total volume of all methods instead of the whole eclipse project when determing the cyclomatic complexity rating, because we think it would be a more accurate representation.

## Code duplication