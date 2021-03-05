import networkx as nx
import sys
import os

file_path = os.path.join(sys.path[0], "small_world_network.csv")
with open(file_path, "w") as f:
    f.write("source,target\n")
g = nx.connected_watts_strogatz_graph(1000, 50, 0.3)
with open(file_path, "ab") as f:
    nx.write_edgelist(g, f, delimiter=",", data=False)