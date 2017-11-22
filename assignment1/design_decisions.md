# Design decisions

## Volume

## Unit size

## Complexity
We decided to create an AST for every file ...

We visit the tree twice once for methods and constructors and once for specific statements, because we to be able to match the complexity we get from statements to the unit (method or constructor) it belongs to.

## Code duplication