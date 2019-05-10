import subprocess
import pandas as pd
import graphmaker
def depthStat(data, dataset):
    filtereddata = (data[(data.DataSource == dataset)])[['BestDepth']]
    return (filtereddata.mean(), filtereddata.median(), filtereddata.std())

filename= "output/ModelSelection.csv"
subprocess.run(["rm","-f",filename])

for i in range(1,101):
    print("running car "+str(i))
    subprocess.run(["dune", "exec", "bin/modelSelect.exe", "--", "-q", "-g", filename, "CAR", "data/cars/car.data"])

for i in range(1,101):
    print("running mushrooms "+str(i))
    subprocess.run(["dune", "exec", "bin/modelSelect.exe", "--", "-q", "-g", filename, "MUSHROOMS", "data/mushrooms/agaricus-lepiota.data"])

for i in range(1,101):
    print("running tictoctoe "+str(i))
    subprocess.run(["dune", "exec", "bin/modelSelect.exe", "--", "-q", "-g", filename, "TICTACTOE", "data/ttt/tic-tac-toe.data"])

for i in range(1,101):
    print("running balance "+str(i))
    subprocess.run(["dune", "exec", "bin/modelSelect.exe", "--", "-q", "-g", filename, "BALANCE", "data/balance/balance-scale.data"])

data = pd.read_csv(
    filename, names=['DataSource', 'Algorithm', 'MaxDepth', 'ErrT', 'ErrV','BestDepth'])

graphmaker.generate_errt_vs_errv_chart(data, 'BALANCE', 'Balance', 'OURS','_ocaml')
graphmaker.generate_errt_vs_errv_chart(data, 'TICTACTOE', 'Tic-Tac-Toe', 'OURS','_ocaml')
graphmaker.generate_errt_vs_errv_chart(data, 'MUSHROOMS', 'Mushrooms', 'OURS','_ocaml'),
graphmaker.generate_errt_vs_errv_chart(data, 'CAR', 'Car Evaluation', 'OURS','_ocaml')

graphmaker.generate_variance_chart(data, 'BALANCE', 'Balance', 'OURS','_ocaml')
graphmaker.generate_variance_chart(data, 'TICTACTOE', 'Tic-Tac-Toe', 'OURS','_ocaml')
graphmaker.generate_variance_chart(data, 'MUSHROOMS', 'Mushrooms', 'OURS','_ocaml')
graphmaker.generate_variance_chart(data, 'CAR', 'Car Evaluation', 'OURS','_ocaml')
f = open("output/ModelSelectionBestDepth.txt", "w")
s="BALANCE:\n\tMean: %f\n\tMedian: %f\n\tSTD: %f\n" % depthStat(data, 'BALANCE')
f.write(s)
print(s)
s="TICTACTOE:\n\tMean: %f\n\tMedian: %f\n\tSTD: %f\n" % depthStat(data, 'TICTACTOE')
f.write(s)
print(s)
s="Mushrooms:\n\tMean: %f\n\tMedian: %f\n\tSTD: %f\n" % depthStat(data, 'MUSHROOMS')
f.write(s)
print(s)
s="CAR:\n\tMean: %f\n\tMedian: %f\n\tSTD: %f\n" % depthStat(data, 'CAR')
f.write(s)
print(s)
