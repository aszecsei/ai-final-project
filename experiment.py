import pandas as pd
from sklearn.model_selection import KFold
from sklearn.metrics import accuracy_score
from enum import Enum

from sklearn import tree


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


def classify_data(decision_tree, data_points):
    res = []
    for index, row in data_points.iterrows():
        res.append("positive")
    return res


def get_decision_tree(X_train, y_train):
    return None


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
        print("TODO")

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
            dt = get_decision_tree(X_train, y_train)
            y_pred = classify_data(dt, X_test)
        elif model == Model.SCIKIT:
            dt = tree.DecisionTreeClassifier(criterion="entropy")
            dt.fit(X_train, y_train)
            y_pred = dt.predict(X_test)
        error_rates.append(accuracy_score(y_test, y_pred))

    avg = sum(error_rates) / len(error_rates)
    print("ACCURACY:", avg)
    print("ERROR RATE:", 1.0 - avg)


if __name__ == "__main__":
    # print("--------- TIC-TAC-TOE: OURS ---------")
    # run_validation(DataType.TTT, Model.OURS)
    # print("-------- TIC-TAC-TOE: SCIKIT --------")
    # run_validation(DataType.TTT, Model.SCIKIT)

    # print("--------- MUSHROOMS: OURS ---------")
    # run_validation(DataType.MUSHROOMS, Model.OURS)
    # print("-------- MUSHROOMS: SCIKIT --------")
    # run_validation(DataType.MUSHROOMS, Model.SCIKIT)

    print("--------- BALANCE: OURS ---------")
    run_validation(DataType.BALANCE, Model.OURS)
    print("-------- BALANCE: SCIKIT --------")
    run_validation(DataType.BALANCE, Model.SCIKIT)
