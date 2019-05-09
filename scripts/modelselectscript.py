import subprocess
start= "output/carSelection"
end= ".csv"
for i in range(1,6):
    filename=start+str(i)+end
    print("running car "+start+str(i))
    subprocess.run(["dune", "exec", "bin/modelSelect.exe", "--", "-q", "-W", filename, "car", "data/cars/car.data"])
start= "output/mushroomSelection"
for i in range(1,6):
    filename=start+str(i)+end
    print("running mushrooms "+start+str(i))
    subprocess.run(["dune", "exec", "bin/modelSelect.exe", "--", "-q", "-W", filename, "mushrooms", "data/mushrooms/agaricus-lepiota.data"])
start= "output/tttSelection"
for i in range(1,6):
    filename=start+str(i)+end
    print("running tictoctoe "+start+str(i))
    subprocess.run(["dune", "exec", "bin/modelSelect.exe", "--", "-q", "-W", filename, "tictactoe", "data/ttt/tic-tac-toe.data"])
start= "output/balanceSelection"
for i in range(1,6):
    filename=start+str(i)+end
    print("running balance "+start+str(i))
    subprocess.run(["dune", "exec", "bin/modelSelect.exe", "--", "-q", "-W", filename, "balance", "data/balance/balance-scale.data"])
