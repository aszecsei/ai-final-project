import subprocess
start= "output/carSelection"
end= ".csv"
for i in range(1,6):
    filename=start+str(i)+end
    subprocess.run(["dune", "exec", "bin/modelSelect.exe", "--", "-W", filename, "car", "data/cars/car.data"])
start= "output/mushroomSelection"
for i in range(1,6):
    filename=start+str(i)+end
    subprocess.run(["dune", "exec", "bin/modelSelect.exe", "--", "-W", filename, "mushrooms", "data/mushrooms/agaricus-lepiota.data"])
start= "output/tttSelection"
for i in range(1,6):
    filename=start+str(i)+end
    subprocess.run(["dune", "exec", "bin/modelSelect.exe", "--", "-W", filename, "tictoctoe", "data/ttt/tic-tac-toe.data"])
start= "output/balanceSelection"
for i in range(1,6):
    filename=start+str(i)+end
    subprocess.run(["dune", "exec", "bin/modelSelect.exe", "--", "-W", filename, "balance", "data/balance/balance-scale.data"])
