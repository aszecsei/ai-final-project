import pandas as pd
from sklearn.model_selection import KFold
from sklearn.metrics import accuracy_score
from enum import Enum
import subprocess
from sklearn import tree
import os


class Config:
    DELETE_MISSING = True
    LEAVE_ONE_OUT = False


class DataType(Enum):
    BALANCE = 1
    CONNECT_FOUR = 2
    MUSHROOMS = 3
    TTT = 4
    CAR_EVALUATION = 5


class Model(Enum):
    OURS = 1
    SCIKIT = 2


def classify_data(data_points):
    # Write test data to file
    data_points.to_csv('./temp/test.csv', header=False, index=False)
    result = subprocess.run(
        ['./_build/default/bin/classify.exe', './temp/decision.json', './temp/test.csv'], stdout=subprocess.PIPE)
    result_str = result.stdout.decode('utf-8')
    result_str_l = result_str.split()
    return result_str_l


def get_type_flag(data_type):
    if data_type == DataType.BALANCE:
        return "BALANCE"
    elif data_type == DataType.CAR_EVALUATION:
        return "CAR"
    elif data_type == DataType.MUSHROOMS:
        return "MUSHROOMS"
    elif data_type == DataType.TTT:
        return "TICTACTOE"


def get_decision_tree(X_train, y_train, data_type):
    # Write training data to file
    training_data = X_train.copy()
    if data_type == DataType.BALANCE or data_type == DataType.MUSHROOMS:
        # These two data sets have the class at the first column
        training_data.insert(0, 'class', y_train)
    else:
        # These two data sets have the class at the last column
        training_data.insert(X_train.shape[1], 'class', y_train)

    if not os.path.exists('./temp'):
        os.mkdir('./temp')
    training_data.to_csv('./temp/training.csv', header=False, index=False)

    data_type_flag = get_type_flag(data_type)
    result = subprocess.run(
        ['./_build/default/bin/dtl.exe', data_type_flag, './temp/training.csv'], stdout=subprocess.PIPE)
    # print(result.stdout)

    # Write the JSON decision tree to a file
    json = open("./temp/decision.json", "w")
    json.write(result.stdout.decode("utf-8"))
    json.close()


def clean():
    # Delete all temp files
    os.remove('./temp/training.csv')
    os.rmdir('./temp')


def run_validation(data_type, model, depth=None):
    print("Running validations!")
    if data_type == DataType.BALANCE:
        data = pd.read_csv("./data/balance/balance-scale.data", names=[
            'class', 'leftweight', 'leftdistance', 'rightweight', 'rightdistance'
        ])
    elif data_type == DataType.CONNECT_FOUR:
        print("ERROR: Connect 4 is not currently supported")
        return
    elif data_type == DataType.MUSHROOMS:
        data = pd.read_csv("./data/mushrooms/agaricus-lepiota.data", names=[
            'class', 'cap-shape', 'cap-surface', 'cap-color', 'bruises', 'odor', 'gill-attachment', 'gill-spacing', 'gill-size', 'gill-color', 'stalk-shape', 'stalk-root', 'stalk-surface-above-ring', 'stalk-surface-below-ring', 'stalk-color-above-ring', 'stalk-color-below-ring', 'veil-type', 'veil-color', 'ring-number', 'ring-type', 'spore-print-color', 'population', 'habitat'
        ])
        if Config.DELETE_MISSING:
            data = data[data.bruises != "?"]
    elif data_type == DataType.TTT:
        data = pd.read_csv("./data/ttt/tic-tac-toe.data", names=[
                           'topleft', 'topmid', 'topright', 'midleft', 'midmid', 'midright', 'bottomleft', 'bottommid', 'bottomright', 'class'])
    elif data_type == DataType.CAR_EVALUATION:
        data = pd.read_csv("./data/cars/car.data", names=[
            'price_buying', 'price_maint', 'tech_comfort_doors', 'tech_comfort_persons', 'tech_comfort_lugboot', 'tech_safety', 'class'
        ])

    X = data.drop('class', axis=1)
    y = data[['class']]
    print("# of data points:", X.shape[0])
    print("# of attributes:", X.shape[1])
    assert(X.shape[0] == y.shape[0])

    if model == Model.SCIKIT:
        # Use one-hot encoding
        X = pd.get_dummies(X, drop_first=True)

    if Config.LEAVE_ONE_OUT:
        kf = KFold(n_splits=X.shape[1])
    else:
        kf = KFold(n_splits=4)

    error_rates = []
    for train, test in kf.split(X):
        X_train, y_train = X.loc[train, :], y.loc[train, :]
        X_test, y_test = X.loc[test, :], y.loc[test, :]

        if model == Model.OURS:
            get_decision_tree(X_train, y_train, data_type)
            y_pred = classify_data(X_test)
        elif model == Model.SCIKIT:
            dt = tree.DecisionTreeClassifier(criterion="entropy")
            dt.fit(X_train, y_train)
            y_pred = dt.predict(X_test)
        error_rates.append(accuracy_score(y_test, y_pred))

    avg = sum(error_rates) / len(error_rates)
    print("ACCURACY:", avg)
    print("ERROR RATE:", 1.0 - avg)


if __name__ == "__main__":
    dt = DataType.MUSHROOMS
    print("--------- OURS ---------")
    run_validation(dt, Model.OURS)
    print("-------- SCIKIT --------")
    run_validation(dt, Model.SCIKIT)

    # clean()
