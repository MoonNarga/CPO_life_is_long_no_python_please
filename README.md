# CPO_life_is_long_no_python_please

## Description
Objectives:  
1. Use development tools: Haskell, IDE/source code editor, git, Github Actions, and laboratory
work process  
2. Design algorithms and data structures in mutable styles  
3. Develop unit and property-based tests
Students should meet with tools and typical development workflow on the classical development
task in the first laboratory work: developing a library for a specific data structure.  

Students should implement the selected by the variants data structure as a mutable object (interaction with an object should modify it if applicable). All changes should be performed in place, by changing the initial structure.

## Struct of project
* The main.hs in app/ is just a file init by cabal. It doesn't matter.
* The implementation of Binary Search Tree is in src/BST.hs. And it exports some functions.
* The test runs by the cabal, and the test cases are written in test/Tests.hs.
