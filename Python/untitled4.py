# -*- coding: utf-8 -*-
"""
Created on Wed Jan  2 11:25:58 2019

@author: bjwil
"""
import copy
import networkx as nx
edge_dict = copy.deepcopy(edict)
def eulerian_path(edge_dict):
    '''Generates an Eulerian cycle from the given edges.''' 
    G = nx.DiGraph(edge_dict)
    if not(nx.is_eulerian(G)):
        out_degrees = G.out_degree([node for node in G])
        in_degrees = G.in_degree([node for node in G])
        ds = [out_degrees, in_degrees]
        d = {}
        for k in out_degrees.keys():
            d[k] = tuple(d[k] for d in ds)
        for key in d:
            d[key] = d[key][0] - d[key][1]
        extra_out = [key  for (key, value) in d.items() if value == 1][0]
        extra_in = [key  for (key, value) in d.items() if value == -1][0]
        edge_dict[extra_in] = extra_out
        current_node = extra_out
    else:
        current_node = next(iter(edge_dict.keys()))
    path = [current_node]

    # Get the initial cycle.
    while True:
        path.append(edge_dict[current_node][0])

        if len(edge_dict[current_node]) == 1:
            del edge_dict[current_node]
        else:
            edge_dict[current_node] = edge_dict[current_node][1:]

        if path[-1] in edge_dict:
            current_node = path[-1]
        else:
            break

    # Continually expand the initial cycle until we're out of edge_dict.
    while len(edge_dict) > 0:
        for i in range(len(path)):
            if path[i] in edge_dict:
                current_node = path[i]
                cycle = [current_node]
                while True:
                    cycle.append(edge_dict[current_node][0])

                    if len(edge_dict[current_node]) == 1:
                        del edge_dict[current_node]
                    else:
                        edge_dict[current_node] = edge_dict[current_node][1:]

                    if cycle[-1] in edge_dict:
                        current_node = cycle[-1]
                    else:
                        break

                path = path[:i] + cycle + path[i+1:]
                break
    return path

if __name__ == '__main__':

    # Read the input data.
    with open ('last.txt', 'r') as in_file:
        lines = in_file.read().split('\n')

    edges = {}

    for connection in lines:
        connection = connection.replace(" ", "")
        edges[connection.split('->')[0]] = [v for v in connection.split('->')[1].split(',')]

    # Get the Eulerian cycle.
    path = eulerian_path(edges)

    # Print and save the answer.
    print('->'.join(map(str,path)))
    with open('Output9.txt', 'w') as output_data:
        output_data.write('->'.join(map(str,path)))