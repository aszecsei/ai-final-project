import pandas as pd
from sklearn.model_selection import KFold
from sklearn.metrics import accuracy_score
from enum import Enum
import subprocess
from sklearn import tree
import os
import csv


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


def get_decision_tree(X_train, y_train, data_type, depth=None):
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
    if depth == None:
        result = subprocess.run(
            ['./_build/default/bin/dtl.exe', data_type_flag, './temp/training.csv'], stdout=subprocess.PIPE)
    else:
        result = subprocess.run(
            ['./_build/default/bin/dtl.exe', '-d', str(depth), data_type_flag, './temp/training.csv'], stdout=subprocess.PIPE)
    # print(result.stdout)

    # Write the JSON decision tree to a file
    json = open("./temp/decision.json", "w")
    json.write(result.stdout.decode("utf-8"))
    json.close()


def clean():
    # Delete all temp files
    os.remove('./temp/training.csv')
    os.remove('./temp/decision.json')
    os.remove('./temp/test.csv')
    os.rmdir('./temp')


def run_validation(data_type, model, depth=None, num_trials=1):
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
    assert(X.shape[0] == y.shape[0])

    if model == Model.SCIKIT:
        # Use one-hot encoding
        X = pd.get_dummies(X, drop_first=True)

    data = []
    for i in range(num_trials):
        if Config.LEAVE_ONE_OUT:
            kf = KFold(n_splits=X.shape[1], shuffle=True)
        else:
            kf = KFold(n_splits=4, shuffle=True)
        error_rates_t = []
        error_rates_v = []
        for train, test in kf.split(X):
            X_train, y_train = X.loc[train, :], y.loc[train, :]
            X_test, y_test = X.loc[test, :], y.loc[test, :]

            if model == Model.OURS:
                get_decision_tree(X_train, y_train, data_type, depth)
                y_pred = classify_data(X_test)
                y_t_pred = classify_data(X_train)
            elif model == Model.SCIKIT:
                dt = tree.DecisionTreeClassifier(
                    criterion="entropy", max_depth=depth)
                dt.fit(X_train, y_train)
                y_pred = dt.predict(X_test)
                y_t_pred = dt.predict(X_train)
            error_rates_v.append(accuracy_score(y_test, y_pred))
            error_rates_t.append(accuracy_score(y_train, y_t_pred))

        err_v = 1.0 - (sum(error_rates_v) / len(error_rates_v))
        err_t = 1.0 - (sum(error_rates_t) / len(error_rates_t))

        data.append([err_t, err_v])
    return data


if __name__ == "__main__":
    dts = [DataType.BALANCE, DataType.CAR_EVALUATION,
           DataType.MUSHROOMS, DataType.TTT]
    ms = [Model.OURS, Model.SCIKIT]

    ofile = open(
        "./data.csv", 'w')
    writer = csv.writer(ofile, dialect='excel')

    for dt in dts:
        for m in ms:
            for max_depth in range(10):
                max_depth += 1

                m_string = "OURS"
                if m == Model.SCIKIT:
                    m_string = "SCIKIT"
                data = [[get_type_flag(dt), m_string, str(
                    max_depth)] + x for x in run_validation(dt, m, max_depth, 100)]
                writer.writerows(data)

                print("Wrote {}-{} at depth {}".format(get_type_flag(dt),
                                                       m_string, str(max_depth)))

    ofile.close()

    clean()
