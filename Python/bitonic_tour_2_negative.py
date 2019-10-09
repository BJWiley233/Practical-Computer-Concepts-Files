# -*- coding: utf-8 -*-
"""
Created on Wed Oct  2 00:36:03 2019

@author: bjwil
"""
import math
import numpy as np
import argparse
# just for visualizing tour
from matplotlib import pyplot as plt
import networkx as nx


# distance formula
def distance(p1, p2):
    return math.sqrt((p2[0]-p1[0])**2+(p2[1]-p1[1])**2)


# sort using lambda
def sort(P):
    P = sorted(P, key = lambda k: [k[0], k[1]])
    return P


# create distance matrix
def upper_triangular_distance_matrix(P):
    n = len(P)
    distance_matrix = np.zeros(shape=(n,n))
    for i in range(0, n):
        for j in range(i+1, n):
            distance_matrix[i,j] = round(distance(P[i], P[j]), 3)
    
    return distance_matrix


'''
Main subtour function --
Example calculations for n = 7 using 0 indexing!
# for a = 0 we have 5 calculations (n-2) calculations
    ## for a = [1..n-3] we always have (n-3) calculations because each time we have to choose from 
    ## we chose from 'a' min calculations and then make n-a-3 post calculations gives us a+n-a-3 = n-3 calculations
    ** we also make total [0 + 1 + 2 + ... n-3] comparisons but only for a = [1..n-2] = 1/2n^2-5/2n+3 by Summation A5
# for a = 1 we have 1 min calculations and (1-1 comparisons) + 3 post calculations (1,3),(1,4)..(1,n-2) 
# for a = 2 we have 2 min calculations and (2-1 comparisons) + 2 post calculations (2,4)..(2,n-2) 
# for a = 3 we have 3 min calculations and (3-1 comparisons) + 1 post calculations (3,n-2)
# for a = 4 we have 4 min calculations and (4-1 comparisons) + 0 post calculations
# for a = i we have i min calculations and (i-1 comparisons) + n-i-3 post calculations
  ...
    ## for a = n-2 we still 'a' min calculations = n-2 and their comparisons by chapter 9 in CLRS
# for a = n-2 we have (n-2) min calculations and (n-3 comparisons)
'''
# total run time is {2(n-2)+(n-3)(n-3)} calculations + 1/2n^2-7/2n+3 comparisons = 
# O(n^2-7n+5) calculations + O(1/2n^2-7/2n+3) comparisons = O(n^2)
def subtour(a, b, tour_dict, distance_matrix):
    temp_tour = ""
    temp_tour_dist = 0
    min_tour = ""
    min_tour_dist = float("inf")
    # 2nd point degenerate case
    if a == 0 and b == 1:
        tour_dict[(a,b)] = ["{}->{},".format(a,b), distance_matrix[a,b]]
    elif a < b-1:
        temp_tour = tour_dict[a,b-1][0] + "{}->{},".format(b-1,b)
        temp_tour_dist = tour_dict[a,b-1][1] + distance_matrix[b-1,b]
        tour_dict[(a,b)] = [temp_tour, temp_tour_dist]
    else:
        # 1st point range(a/i from website) means 0 to but not including a
        for k in range(a):
            temp_tour_dist = tour_dict[k,a][1] + distance_matrix[k, b]
            if temp_tour_dist < min_tour_dist:
                min_tour_dist = temp_tour_dist
                min_tour = tour_dict[k, a][0] + "{}->{},".format(k, b)
        tour_dict[(a, b)] = [min_tour, min_tour_dist]


# driver method to return montonically increasing tour, shortest distance,
# as well as a points dictionary for the initial ordering by X coodinate for
# networx graph using Graphviz backend
def find_full_tour(P):
    P = sort(P)
    n = len(P)
    D = upper_triangular_distance_matrix(P)
    points_dict = {x:i for x, i  in enumerate(P)}
    T = {}
    for a in range(0,n-1):
        for b in range(a+1,n):
        # We don't need the tour (i,n-1) in any minimum calculations but
        # we do need to pass(n-2,n-1) for final answer
            if b == n-1 and a < b-1:
                continue
            subtour(a, b, T, D)
    final_tour_unordered = T[(n-2,n-1)][0] + "{}->{}".format(n-2,n-1)
    final_distance =  T[(n-2,n-1)][1] + D[n-2, n-1]
    
    return final_tour_unordered, final_distance, points_dict

def graph_tour(final, points_dict):
    edgelist = final
    pos = points_dict
    G=nx.DiGraph()

    edgelist = final
    pos = points_dict
    G=nx.DiGraph()


    G.add_nodes_from(pos.keys())
    for n, p in pos.items():
        G.node[n]['pos'] = p
    nx.draw_networkx(G, pos, node_size=600, )
    nx.draw_networkx_edges(G, pos, edgelist=edgelist, width=3)
    plt.show()


def print_tour(m, d, points_dict, graph, points_list):
    final_tour_unordered_comma = m.split(",")
    final_tour_unordered_arrow = [i.split("->") for i in final_tour_unordered_comma]
    final_tour_unordered_int = [[int(i) for i in x] for x in final_tour_unordered_arrow]
    final = [final_tour_unordered_int.pop(0)]
    for edge in final_tour_unordered_int:
        if final[-1][1] == edge[0]:
            final.append(edge)
    if len(points_dict) > 2:
        final_tour_unordered_int = [x for x in final_tour_unordered_int if x not in final]
    final_tour_unordered_int.reverse()
    for edge in final_tour_unordered_int:
        edge.reverse()
    while final_tour_unordered_int:
        final.append(final_tour_unordered_int.pop(0)) 
    final_string_OMG = [[str(i) for i in x] for x in final]
    final_tour = ""
    for i, edge in enumerate(final_string_OMG):
        if i == 0:
            final_tour = final_tour + edge[0] + "->" + edge[1]
        else:
            final_tour = final_tour + "->" + edge[1] 
    print("Maybe the messiest Bitonic Tour print tour code EVER. 20 lines of code.")
    print("Tour is {} and shortest distance is {}".format(final_tour, d))
    
    if graph:
        graph_tour(final, points_dict)
    
    print("Initial points given:")
    print(points_list)

    return final


def coords(c):
    try:
        x, y = map(int, c.split(','))
        return x, y
    except:
        raise argparse.ArgumentTypeError('Coordinates must be in "X,Y"')

def str_bool(entry):
    upper_arg = str(entry).upper()

    if upper_arg == 'T' or upper_arg == 'TRUE':
        return True
    elif upper_arg == 'F' or upper_arg == 'FALSE':
        return False
    else:
        raise argparse.ArgumentTypeError('Enter either True(T)/False((F)')
    



if __name__ == "__main__":    
    points_list = [[-3,8],[-7,10]]
    # extra test set 1
    #points_list = [[-3,8],[-7,10], [2,3], [1,16], [0,6], [5,4], [6,1], [8,2], [9,4], [10, 1], [-6,-5]]
    '''#extra test set 2
    xpoints = np.random.choice(range(-10,21), 12, replace=False)
    ypoints = np.random.choice(range(-10,21), 12)
    points_list = list(zip(xpoints, ypoints))
    '''
    # get monotonically increasing tour, shortest distance, order points dict by X coordinate
    mono_tour, tour_dist, points_dict = find_full_tour(points_list)
    # get final tour and print results
    final = print_tour(mono_tour, tour_dist, points_dict, graph=True, points_list=points_list)
    '''
    parser = argparse.ArgumentParser(description='List of points and graph boolean',
                                 add_help=True)
    parser.add_argument('-p', '--points', type=coords, dest='points', help='XY Coordinate', nargs='*')
    parser.add_argument('-g', '--graph', type=str_bool, const='store_true', help='True/False', nargs='?')
    args = parser.parse_args()
    
    # get monotonically increasing tour, shortest distance, order points dict by X coordinate
    mono_tour, tour_dist, points_dict = find_full_tour(args.points)
    # get final tour and print results
    final = print_tour(mono_tour, tour_dist, points_dict, graph=args.graph, points_list=args.points)
    '''
