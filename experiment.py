import pandas as pd
from sklearn.model_selection import KFold
from sklearn.metrics import accuracy_score
from enum import Enum


class DataType(Enum):
    BALANCE = 1
    CONNECT_FOUR = 2  # TODO: Use a different data set
    MUSHROOMS = 3
    TTT = 4


def classify_data(decision_tree, data_points):
    res = []
    for index, row in data_points.iterrows():
        res.append("positive")
    return res


def get_decision_tree(X_train, y_train):
    return None


def run_validation(data_type):
    print("Running validations!")
    if data_type == DataType.BALANCE:
        data = pd.read_csv("./data/balance/balance-scale.data")
    elif data_type == DataType.CONNECT_FOUR:
        print("ERROR: Connect 4 is not currently supported")
        return
    elif data_type == DataType.MUSHROOMS:
        data = pd.read_csv("./data/mushrooms/agaricus-lepiota.data")
    elif data_type == DataType.TTT:
        data = pd.read_csv("./data/ttt/tic-tac-toe.data", names=[
                           'topleft', 'topmid', 'topright', 'midleft', 'midmid', 'midright', 'bottomleft', 'bottommid', 'bottomright', 'class'])
        # print(data)
        X = data.drop('class', axis=1)
        y = data[['class']]
    print("X", X.shape)
    print("y", y.shape)

    kf = KFold(n_splits=4)
    error_rates = []
    for train, test in kf.split(X):
        X_train, y_train = X.loc[train, :], y.loc[train, :]
        X_test, y_test = X.loc[test, :], y.loc[test, :]
        dt = get_decision_tree(X_train, y_train)
        y_pred = classify_data(dt, X_test)
        error_rates.append(accuracy_score(y_test, y_pred))

    avg = sum(error_rates) / len(error_rates)
    print("ACCURACY:", avg)
    print("ERROR RATE:", 1.0 - avg)


if __name__ == "__main__":
    run_validation(DataType.TTT)
