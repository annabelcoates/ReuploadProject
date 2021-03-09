import sys
import os
import networkx as nx
from operator import itemgetter


graph_generator = getattr(nx, sys.argv[1])
graph_args = [
    float(s) if '.' in s else int(s) 
    for s in sys.argv[2].strip('[]()').split(',')
]
thread_params_str = sys.argv[3]
g = graph_generator(*graph_args)
print()
print('--------')
print('I AM BEING RUN WITH THESE PARAMETERS: {}'.format(thread_params_str))
print('--------')
print()

degree_list = list(g.degree)
# Sort the degree list by degree.
sorted_degree_list = sorted(degree_list, key=itemgetter(1))


node_remapping = {
    p[0]: idx for idx, p in enumerate(sorted_degree_list)
}
g = nx.relabel_nodes(g, node_remapping)

edge_list = [
    s + '\n'
    for s in nx.generate_edgelist(g, delimiter=',', data=False)
]
edge_file_name = "small_world_graph_" + thread_params_str + ".csv"
edge_file_path = os.path.join(sys.path[0], edge_file_name)
with open(edge_file_path, "w") as f:
    f.write("source,target\n")
with open(edge_file_path, "a") as f:
    f.writelines(edge_list)
