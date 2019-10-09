# -*- coding: utf-8 -*-
"""
Created on Wed Oct  2 00:36:03 2019

@author: bjwil
"""
import math
import numpy as np

# distance formula
def distance(p1, p2):
    return math.sqrt((p2[0]-p1[0])**2+(p2[1]-p1[1])**2)

# points from CLRS page 405 
points_list = [[7,5], [2,3], [1,0], [0,6], [5,4], [6,1], [8,2]]  
# extra test set 1   
#points_list = [[-3,8],[-7,10], [2,3], [1,16], [0,6], [5,4], [6,1], [8,2], [9,4], [10, 1], [-6,-5]]
#extra test set 2
xpoints = np.random.choice(range(-10,21), 12, replace=False)
ypoints = np.random.choice(range(-10,21), 12)
points_list = list(zip(xpoints, ypoints))

# sort points (nlgn)
points_sorted = sorted(points_list, key = lambda k: [k[0], k[1]])
points_dict = {x:i for x, i  in enumerate(points_sorted)}

# create the distance dictionary, it's okay to have distance both ways and 
# on diagonal since it's just n^2 entries which is O(1*n^2) instead of 1/2*n(n-1)
# which is O(1/2*n^2) which are both O(n^2)
distance_dict = {}
'''
for k, v in points_dict.items():
    for k1, v1 in points_dict.items():
        distance_dict[(k,k1)] = distance(v,v1)
'''
#testing with only upper triangular distance dictionary, this works so we
#  can save some runtime here still asymptotically the same
for i in range(len(points_dict)):
    for j in range(i, len(points_dict)):
        if i !=j:
            distance_dict[(i,j)] = distance(points_dict[i], points_dict[j])

# initialize lower triangular tour dict
tour_dict = {}
# main method, follows the tutorial except for 2 points in email
'''
update to Jade's calculations for n = 7 using 0 indexing!
# for a = 0 we have 6 calculations (n-1) calculations
    ## for a = [1..n-3] we always have (n-3) calculations because each time we have to choose from 
    ## we chose from 'a' min calculations and then make n-a-3 post calculations gives us a+n-a-3 = n-3 calculations
    ** we also make total [0 + 1 + 2 + ... n-3] comparisons but for a = [1..n-2] = 1/2n^2-5/2n+3 by Summation A5
# for a = 1 we have 1 min calculations and (1-1 comparisons) + 3 post calculations (1,3),(1,4)..(1,n-2) 
# for a = 2 we have 2 min calculations and (2-1 comparisons) + 2 post calculations (2,4)..(2,n-2) 
# for a = 3 we have 3 min calculations and (3-1 comparisons) + 1 post calculations (3,n-2)
# for a = 4 we have 4 min calculations and (4-1 comparisons) + 0 post calculations
# for a = i we have i min calculations and (i-1 comparisons) + n-i-3 post calculations
  ...
    ## for a = n-2 we still 'a' min calculations = n-2 and their comparisons by chapter 9 in CLRS
# for a = n-2 we have (n-2) min calculations and (n-3 comparisons)
'''
# total run time is {(n-1)+(n-3)(n-3)+(n-2)} calculations + 1/2n^2-5/2n+3 comparisons = 
# O(n^2-4n+6) calculations + O(1/2n^2-5/2n+3) comparisons = O(n^2)
def tour(a, b, tour_dict, distance_dict):
    temp_tour = ""
    temp_tour_dist = 0
    min_tour = ""
    min_tour_dist = float("inf")
    # 2nd point degenerate case
    if a == 0 and b == 1:
        tour_dict[(a,b)] = ["{}->{},".format(a,b), distance_dict[(a,b)]]
    elif a < b-1:
        temp_tour = tour_dict[a,b-1][0] + "{}->{},".format(b-1,b)
        temp_tour_dist = tour_dict[a,b-1][1] + distance_dict[(b-1,b)]
        tour_dict[(a,b)] = [temp_tour, temp_tour_dist]
    else:
        # 1st point range(a/i from website) means 0 to but not including a
        for k in range(a):
            temp_min_tour_dist = tour_dict[k,a][1] + distance_dict[(k, b)]
            if temp_min_tour_dist < min_tour_dist:
                min_tour_dist = temp_min_tour_dist
                min_tour = tour_dict[k,a][0] + "{}->{},".format(k,b)
        tour_dict[(a,b)] = [min_tour, min_tour_dist]


# run the main method to get tour just missing last edge
n = len(points_dict)
for i in range(0,n-1):
    for j in range(i+1,n):
        # We don't need the tour (i,n-1) in any minimum calculations but
        # we do need to pass(n-2,n-1) for final answer
        if j == n-1 and i < j-1:
            continue
        tour(i, j, tour_dict, distance_dict)

# need to add last edge of tour
final_tour_minus_last_edge = tour_dict[(n-2,n-1)] 
last_edge_nMinus1_nMinus2 = "{}->{}".format(n-2,n-1)
last_edge_dist = distance_dict[(n-2,n-1)]
final_tour_unordered = final_tour_minus_last_edge[0] + last_edge_nMinus1_nMinus2
final_tour_distance = final_tour_minus_last_edge[1] + last_edge_dist

# now need to put tour in order
final_tour_unordered_comma = final_tour_unordered.split(",")
final_tour_unordered_arrow = [i.split("->") for i in final_tour_unordered_comma]
final_tour_unordered_int = [[int(i) for i in x] for x in final_tour_unordered_arrow]

# start the final tour with (0,1)
final = [final_tour_unordered_int.pop(0)]

### FIXME: Will this always work?
# This is to get strictly monotonically increasing
for edge in final_tour_unordered_int:
        if final[-1][1] == edge[0]:
            final.append(edge)
# now we have to remove all the forward edges that we just added to final
final_tour_unordered_int = [x for x in final_tour_unordered_int if x not in final]
# then we reverse since we are at the end
final_tour_unordered_int.reverse()
# reverse each monotonically increasing to decreasing because we are going back
for edge in final_tour_unordered_int:
    edge.reverse()
# these are all correct order going back so just pop
while final_tour_unordered_int:
    final.append(final_tour_unordered_int.pop(0)) 
### FIXME END
    
# finally back to string
final_string_OMG = [[str(i) for i in x] for x in final]
final_tour = ""
for i, edge in enumerate(final_string_OMG):
    if i == 0:
        final_tour = final_tour + edge[0] + "->" + edge[1]
    else:
        final_tour = final_tour + "->" + edge[1] 
       
# YAY!!!
print("Maybe the messiest Bitonic Tour Code EVER")
print("Tour is {} and length is {}".format(final_tour, final_tour_distance))


# just for visualizing tour
from matplotlib import pyplot as plt
import networkx as nx

edgelist = final
pos = points_dict 
G=nx.DiGraph()

G.add_nodes_from(pos.keys())
for n, p in pos.items():
    G.node[n]['pos'] = p
nx.draw_networkx(G, pos, node_size=600, )
nx.draw_networkx_edges(G, pos, edgelist=edgelist, width=3)
plt.show()

#points_list = [[7,5], [2,3], [1,0], [0,6], [5,4], [6,1], [8,2]]  
print("[", end = '')
for point in points_list[:-1]:
    print("[", end = '')
    print(point[0], end = '')
    print(",", end = '')
    print(point[1], end = '')
    print("], ", end = '')
print(points_list[-1], end = '')
print("]", end = '')

