import sys
import os
import networkx as nx
from operator import itemgetter
# // import numpy.random as rm


graph_generator = getattr(nx, sys.argv[1])
# // graph_generator = nx.connected_watts_strogatz_graph
graph_args = [
    float(s) if '.' in s else int(s) 
    for s in sys.argv[2].strip('[]()').split(',')
    # // for s in "[30, 5, 0.3]".strip('[]()').split(',')
]
g = graph_generator(*graph_args)


connectivity_file_path = os.path.join(sys.path[0], "connectivity_list.txt")
with open(connectivity_file_path, "r") as f:
    connectivity_list = list(map(float, f.readlines()))
# Sort the connectivity list by connectivity
# The first element of each pair element of `sorted_connectivity_list` is the index of the person corresponding to that connectivity.
sorted_connectivity_list = sorted(
    zip(range(len(connectivity_list)), connectivity_list),
    key=itemgetter(1)
    )


degree_list = list(g.degree)
# Sort the degree list by degree.
sorted_degree_list = sorted(degree_list, key=itemgetter(1))


# The zipped compound list of the connectivity and degree lists are now ordered such that the connectivities and degrees align
# We want an ordering of the nodes such that the degree of the i^th *reordered* node has a degree corresponding to the connectivity of the i^th person in the simulation.
# Sorting this zipped compound list by the person index (see descriptor for `sorted_person_index`) will give this ordering.
# We will drop the compound and just store the ordered node list, however.
sorted_node_list = [
    y[0] for x, y
    in sorted(
        zip(sorted_connectivity_list, sorted_degree_list),
        key=lambda x: x[0][0]
        )
    ]


edge_list = list(nx.generate_edgelist(g, delimiter=',', data=False))
def edge_sort_key(s: str):
    return sorted_node_list.index(int(s.split(',')[0]))
sorted_edge_list = [(s + '\n') for s in sorted(edge_list, key=edge_sort_key)]


edge_file_path = os.path.join(sys.path[0], "small_world_network.csv")
with open(edge_file_path, "w") as f:
    f.write("source,target\n")
with open(edge_file_path, "a") as f:
    f.writelines(sorted_edge_list)
