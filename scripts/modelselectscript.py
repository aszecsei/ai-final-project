import subprocess
import pandas as pd
import graphmaker

filename= "output/ModelSelection.csv"
subprocess.run(["rm","-f",filename])

for i in range(1,2):
    print("running car "+str(i))
    subprocess.run(["dune", "exec", "bin/modelSelect.exe", "--", "-q", "-g", filename, "CAR", "data/cars/car.data"])

for i in range(1,2):
    print("running mushrooms "+str(i))
    subprocess.run(["dune", "exec", "bin/modelSelect.exe", "--", "-q", "-g", filename, "MUSHROOMS", "data/mushrooms/agaricus-lepiota.data"])

for i in range(1,2):
    print("running tictoctoe "+str(i))
    subprocess.run(["dune", "exec", "bin/modelSelect.exe", "--", "-q", "-g", filename, "TICTACTOE", "data/ttt/tic-tac-toe.data"])

for i in range(1,2):
    print("running balance "+str(i))
    subprocess.run(["dune", "exec", "bin/modelSelect.exe", "--", "-q", "-g", filename, "BALANCE", "data/balance/balance-scale.data"])

data = pd.read_csv(
    filename, names=['DataSource', 'Algorithm', 'MaxDepth', 'ErrT', 'ErrV'])

graphmaker.generate_errt_vs_errv_chart(data, 'BALANCE', 'Balance', 'OURS','_ocaml')
graphmaker.generate_errt_vs_errv_chart(data, 'TICTACTOE', 'Tic-Tac-Toe', 'OURS','_ocaml')
graphmaker.generate_errt_vs_errv_chart(data, 'MUSHROOMS', 'Mushrooms', 'OURS','_ocaml'),
graphmaker.generate_errt_vs_errv_chart(data, 'CAR', 'Car Evaluation', 'OURS','_ocaml')

graphmaker.generate_variance_chart(data, 'BALANCE', 'Balance', 'OURS','_ocaml')
graphmaker.generate_variance_chart(data, 'TICTACTOE', 'Tic-Tac-Toe', 'OURS','_ocaml')
graphmaker.generate_variance_chart(data, 'MUSHROOMS', 'Mushrooms', 'OURS','_ocaml')
graphmaker.generate_variance_chart(data, 'CAR', 'Car Evaluation', 'OURS','_ocaml')
