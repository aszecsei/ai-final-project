# AI Final Project

> Decision Tree Learning

## Setup

> TODO

## How To Run

> TODO

### DTL

#### basic use

to create the discision tree in single line json format by running just the ocaml code, you run at the project root with the following:

```dune exec ./bin/dtl.exe [data type flag] [path to input file]```

`[data type flag]` can either be:
- `balance` which refers to the data from [Balance Scale](http://archive.ics.uci.edu/ml/datasets/Balance+Scale).
- `mushrooms` which refers to the data from [Mushroom](http://archive.ics.uci.edu/ml/datasets/Mushroom).
- `tictactoe` which refers to the data from [Tic-Tac-Toe Endgame](http://archive.ics.uci.edu/ml/datasets/Tic-Tac-Toe+Endgame). 
- `car` which refers to the data from [Car Evaluation](http://archive.ics.uci.edu/ml/datasets/Car+Evaluation).

all of these are case insensitive.

The contents of `[path to input file]` must match up with what is expected from `[data type flag]`

##### Additional to what is stated above there are 2 optional features. 

#### Readable tree

use a readable version of the tree in a json format instead of a single line json you can do the following:

```dune exec ./bin/dtl.exe [data type flag] [path to input file] p```

this will transform the single lined json into a prettyfied string that is human readable, before use.
#### Write tree to file

to write the json tree to a file you can do the following:

```dune exec ./bin/dtl.exe [data type flag] [path to input file] w [file to be created/overwritten with tree]```

#### To use pretty tree and write tree to file you do the following:

```dune exec ./bin/dtl.exe [data type flag] [path to input file] pw [file to be created/overwritten with tree]```

the order of p and w does not actually matter
## Roles

- Coordinator: Diego
- Recorder: Willem
- Checker: Alic

## Project Description

You will implement and compare experimentally some of the learning methods for decision trees discussed in Chapter 18 of the textbook. You will run your experiments on a selection of the datasets available from the [Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets.php). The datasets can be filtered according to several criteria. Choose 4 multivariate, classification datasets with "Categorical" attribute type and 100 or more examples. Each of these datasets is stored in a text file that consists of one example per line. Each example is a comma-separated sequence of values for the problem attributes. The attributes are documented in a companion file with extension `.name`.

### Part 1

Write a program `DTL` that implements the basic decision tree learning algorithm. The program should take as input (i) a 4-valued flag specifying the data model of one of the 4 datasets to have identified and (ii) the name of a file containing a dataset for the specified data model. For simplicity you can hard-code the 4 data models in your program. Information on a data model, specifically the attributes used in the report as well as their domains is available in human-readable format in the `.name` files in the ML Repository. The `DTL` program should print on the standard output a textual representation the decision tree it learned. You can choose any suitable textual format for the tree (for instance, s-expressions or JSON).

Write a separate classifier, a function that takes two file names as input: one for a file containing a decision tree and one for a file containing a corresponding dataset. It should print on the standard output a classification for each example in the dataset according to the input decision tree. Note that the classifier will need to parse the decision tree. You can use publicly available libraries to do that if you adopt s-expressions or JSON. Alternatively, you can write your own parser (see previous project).

**HINT**: You can use the classifier to do a sanity check on your decision tree learning function by running a learned tree over the same dataset used to construct it, and verifying that it classifies the examples correctly.

### Part 2

Parametrize your implementation of the decision tree learning procedure by a value `d` for the maximum depth of the learned tree. The new procedure should now force a newly-generated tree node to be a leaf if that node is at depth `d` in the tree (similarly to when there are no more attributes to test on). Use the new procedure to implement a separate program performing model selection as explained in Section 18.4.1 of the textbook where, however, you use tree depth instead of _size_. Use _k_ = 4 for _k_-fold cross-validation.

For two of the datasets you used in Part 1, run the model selection program for depth values from 1 to 10 and report the error set on the training data and the validation data as done in Figure 18.9 of the textbook, indicating which model was selected in each case.

## Project Specification

### Decision-Tree JSON

The decision trees are implemented as general trees. Each internal node has a "category" attribute which describes which category is being used to descend the tree; each child is a record containing an "option" field describing which option of the category the child describes, followed by a child tree which can be used for further decision-making.

We use [atdgen](https://atd.readthedocs.io/en/latest/) to generate code for de/serializing this decision tree representation with a JSON format. This allows us to use the same internal representation for both the classifier and the DTL algorithm, without worrying if the schema matches between them.

### Project Structure

There are 3 subdirectories: `bin`, `lib`, and `test`. Shared functionality related to decision trees is placed in the `decision_tree` library, which is then tested via test suites declared in the `test.ml` file.

Top-level code is placed in the `classify.ml` and `dtl.ml` files.

### Test Suites

The test suites are defined using OUnit.
