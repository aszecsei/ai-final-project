# AI Final Project

> Decision Tree Learning

## Setup

### OCaml

OPAM version 2 is required, alongside a dune version greater than 1.6.

To install required dependencies:

```bash
opam install adtgen yojson cmdliner
```

### Python

We use Python 3 and packages `pandas` and `scikit-learn`.

```bash
pip3 install pandas sklearn
```

## How To Run

### DTL

#### Basic Use

For a complete help manual, run:

```bash
dune exec ./bin/dtl.exe -- --help
```

To create the decision tree in single line json format, you run at the project root with the following:

```bash
dune exec ./bin/dtl.exe -- [FLAG] [path to input file]
```

`[FLAG]` can either be:

- `balance` which refers to the data from [Balance Scale](http://archive.ics.uci.edu/ml/datasets/Balance+Scale).
- `mushrooms` which refers to the data from [Mushroom](http://archive.ics.uci.edu/ml/datasets/Mushroom).
- `tictactoe` which refers to the data from [Tic-Tac-Toe Endgame](http://archive.ics.uci.edu/ml/datasets/Tic-Tac-Toe+Endgame).
- `car` which refers to the data from [Car Evaluation](http://archive.ics.uci.edu/ml/datasets/Car+Evaluation).

All of these are case insensitive.

The contents of `[path to input file]` must match up with what is expected from `[FLAG]`

#### Options

The order in which the following options appears does not matter, although their case does.

```bash
dune exec ./bin/dtl.exe -- [OPTIONS]... [FLAG] [path to input file]
```

##### Readable tree

To print a readable version of the tree in JSON format instead of a single line JSON string you use the `-p` or `--pretty` option:

```bash
dune exec ./bin/dtl.exe -- -p [FLAG] [path to input file]
dune exec ./bin/dtl.exe -- --pretty [FLAG] [path to input file]
```

##### Write tree to file

To write the JSON tree to a file you can do the following:

```bash
dune exec ./bin/dtl.exe -- -w [PATH] [FLAG] [path to input file]
dune exec ./bin/dtl.exe -- --dest=[PATH] [FLAG] [path to input file]
```

##### limit the max depth (part 2 of project)

If you want to limit the depth of the tree you can do the following

```bash
dune exec ./bin/dtl.exe -- -d [MAX DEPTH] [FLAG] [path to input file]
dune exec ./bin/dtl.exe -- --depth=[MAX DEPTH] [FLAG] [path to input file]
```

##### Combining Options:

as an example of how to combine options here is how you'd combine 'Write tree to file' and 'Readable tree'

```bash
dune exec ./bin/dtl.exe -- -w [PATH] -p [FLAG] [path to input file]
```

see `dune exec ./bin/dtl.exe -- --help` for more options

### Classifier

##### Printing classifications to standard out

To run the classification executable as specified in the project spec type the following:

```bash
dune exec ./bin/classify.exe -- [path to decision tree] [path to dataset]
```

##### Option to write classifications to a file

```bash
dune exec ./bin/classify.exe -- -w [PATH] [path to decision tree] [path to dataset]
```

### ocaml Model selection using k-fold cross validation

##### normal execution

```bash
dune exec ./bin/modelSelection.exe -- [FLAG] [path to input file]
```

see `dune exec ./bin/modelSelection.exe -- --help` for more options

### experiment.py

The Python script expects that the two OCaml programs (`dtl` and `classify`) have already been built with the names `dtl.exe` and `classify.exe`, and that the two executables are located in the folder `./_build/default/bin/`. If this is not the case, Python will throw an error.

To run the Python script, run the following at the project root:

```bash
python3 -u ./scripts/experiment.py
```

This will run k-fold cross-validation on both our decision tree algorithm and the decision tree algorithm provided by scikit-learn. It will run through each possible dataset and run cross-validation 100 times for both our algorithm and scikit-learn's decision tree algorithm. The errors will be stored in `data.csv` in the root directory.

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
