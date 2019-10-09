# -*- coding: utf-8 -*-
"""
Created on Wed Jan  2 12:03:47 2019

@author: bjwil
"""



def find_eulerian_path(graph):
    startnode, endnode = find_eulerian_endpoints(graph)
    if endnode in graph:
        graph[endnode].add(startnode)
    else:
        graph[endnode] = set([startnode])

    cycle, remaining_graph = find_cycle_starting_at(graph, startnode)
    while remaining_graph:
        for index, new_start in enumerate(cycle):
            if new_start in remaining_graph:
                new_cycle, remaining_graph = find_cycle_starting_at(remaining_graph, new_start)
                cycle = combine_cycles(cycle, index, new_cycle)
                break
        else:
            raise Exception("Cannot find any nodes from {} in remaining graph {}".format(cycle, remaining_graph))
return cycle[:-1]