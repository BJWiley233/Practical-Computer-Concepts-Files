# -*- coding: utf-8 -*-
"""
Created on Thu Oct 10 22:34:28 2019

@author: bjwil
"""

class Node():
    
    def __init__(self, key, color=None, parent=None):
        self.key = key
        self.left = None
        self.right = None
        self.p = None
        self.color = color

    
class RBTree():
    
    def __init__(self):
        self.sentinel = Node(key="T.nil", color="Black")
        self.root = self.sentinel
        self.bh = 0;
        
        
    def left_rotate(self, x):
        y = x.right
        x.right = y.left
        if y.left != self.sentinel:
            y.left.p = x
        y.p = x.p
        if x.p == self.sentinel:
            self.root = y
        elif x == x.p.left:
            x.p.left = y
        else:
            x.p.right = y
        y.left = x
        x.p = y
        
    
    def right_rotate(self, y):
        x = y.left
        y.left = x.right
        if x.right != self.sentinel:
            x.right.p = y
        x.p = y.p
        if y.p == self.sentinel:
            self.root = x
        elif y == y.p.right:
            y.p.right = x
        else:
            y.p.left = x
        x.right = y
        y.p = x
        
        
    def insert_fixup(self, z):
        while z.p.color == "Red":
            if z.p == z.p.p.left:
                y = z.p.p.right
                if y.color == "Red":
                    z.p.color = "Black"    # Case1
                    y.color = "Black"      # Case1
                    z.p.p.color = "Red"    # Case1
                    z = z.p.p              # Case1
                else:                       # Case ? 2/3
                    if z == z.p.right:     
                        z = z.p             # Case 2
                        self.left_rotate(z) # Case 2
                    z.p.color = "Black"      # Case 3
                    z.p.p.color = "Red"      # Case 3
                    self.right_rotate(z.p.p) # Case 3
            else:
                y = z.p.p.left
                if y.color == "Red":
                    z.p.color = "Black"
                    y.color = "Black"
                    z.p.p.color = "Red"
                    z = z.p.p
                else:
                    if z == z.p.left:
                        z = z.p
                        self.right_rotate(z)
                    z.p.color = "Black"
                    z.p.p.color = "Red"
                    self.left_rotate(z.p.p)
        if self.root.color == "Red":
            self.bh +=1
        self.root.color = "Black"
                    
        
    def insert(self, z):
        y = self.sentinel
        x = self.root
        while x != self.sentinel:
            y = x
            if z.key < x.key:
                x = x.left
            else:
                x = x.right
        z.p = y
        if y == self.sentinel:
            self.root = z
        elif z.key < y.key:
            y.left = z
        else:
            y.right = z
        z.left = self.sentinel
        z.right = self.sentinel
        z.color = "Red"
        self.insert_fixup(z)
        
      
    def in_order(self, x, array):
        if x:
            self.in_order(x.left, array)
            array.append(x.key)
            self.in_order(x.right, array)
        
        return array 


    def search(self, x, k):
        if None == x:
            x = self.root
        while x != self.sentinel and k != x.key:
            if k < x.key:
                x = x.left
            else:
                x = x.right
                
        return x
    
    
    def minimum(self, z):
        while z.left is not self.sentinel:
            z = z.left
            
        return z
    
    
    def transplant(self, u, v):
        if u.p == self.sentinel:
            self.root = v
        elif u == u.p.left:
            u.p.left = v
        else:
            u.p.right = v
        v.p = u.p
    
    
    def delete_fix(self, x):
        while x != self.root and x.color == "Black":
            case1 = False
            if x == x.p.left:
                w = x.p.right
                if w.color == "Red":  
                    w.color = "Black"             # Case 1
                    x.p.color = "Red"             # Case 1
                    self.left_rotate(x.p)         # Case 1
                    w = x.p.right                 # Case 1 
                    case1 = True
                if w.left.color == "Black" and w.right.color == "Black":
                    w.color = "Red"               # Case 2
                    x = x.p                       # Case 2
                    if x == self.root and not case1:
                        self.bh -= 1;
                else:
                    if w.right.color == "Black":  
                        w.left.color == "Black"   # Case 3
                        w.color == "Red"          # Case 3
                        self.right_rotate(w)      # Case 3
                        w = x.p.right             # Case 3
                    w.color = x.p.color           # Case 4
                    x.p.color = "Black"           # Case 4
                    w.right.color = "Black"       # Case 4
                    self.left_rotate(x.p)         # Case 4
                    x = self.root                 # Case 4
            else:
                w = x.p.left
                if w.color == "Red":  
                    w.color = "Black"             # Case 1
                    x.p.color = "Red"             # Case 1
                    self.right_rotate(x.p)        # Case 1
                    w = x.p.left                  # Case 1
                    case1 = True             
                if w.right.color == "Black" and w.left.color == "Black":
                    w.color = "Red"               # Case 2
                    x = x.p                       # Case 2
                    if x == self.root and not case1:
                        self.bh -= 1;
                else:
                    if w.left.color == "Black":  
                        w.right.color == "Black"  # Case 3
                        w.color == "Red"          # Case 3
                        self.left_rotate(w)       # Case 3
                        w = x.p.left              # Case 3
                    w.color = x.p.color           # Case 4
                    x.p.color = "Black"           # Case 4
                    w.left.color = "Black"        # Case 4
                    self.right_rotate(x.p)        # Case 4
                    x = self.root                 # Case 4
        x.color = "Black"
    
        return x.color
    
    
    def delete(self, z):
        z = self.search(self.root, z)
        if z == self.root and z.left == self.sentinel and z.right == self.sentinel:
            self.bh -= 1;
        y = z
        y_orig_col = y.color
        if z.left == self.sentinel:
            x = z.right
            self.transplant(z, z.right)
        elif z.right == self.sentinel:
            x = z.left
            self.transplant(z, z.left)
        else:
            y = self.minimum(z.right)
            y_orig_col = y.color
            x = y.right
            if y.p == z:
                x.p = y
            else:
                self.transplant(y, y.right)
                y.right = z.right
                y.right.p = y
            self.transplant(z, y)
            y.left = z.left
            y.left.p = y
            y.color = z.color
            
        if y_orig_col == "Black":
            self.delete_fix(x)


class RB_Join():
    
    def __init__(self):
        self.sentinel = Node(key="T.nil", color="Black")
        self.root = self.sentinel
        self.bh = 0  # need method to get this after merge since we are not counting during insertion
        self.larger_bh = 1
        self.counter = 100
        
        
    def largest_black_key(self, T1, T2):
        black_height_t1 = T1.bh
        black_height_t2 = T2.bh
        if black_height_t1 >= black_height_t2:
            self.larger_bh = 1
        else:
            self.larger_bh = 2
        y = None
        ## This is part b if T1.bh >= T2.bh
        if self.larger_bh == 1:
            y = T1.root
            while black_height_t1 > black_height_t2:
                if y.right == T1.sentinel:
                    y = y.left
                    if y.color == "Black":
                        black_height_t1 -= 1;
                else:
                    y = y.right
                    if y.color == "Black":
                        black_height_t1 -= 1;
            return y, y.key, black_height_t1
        else:
            y = T2.root
            while black_height_t2 > black_height_t1:
                if y.left == T2.sentinel:
                    y = y.right
                    if y.color == "Black":
                        black_height_t2 -= 1;
                else:
                    y = y.left
                    if y.color == "Black":
                        black_height_t2 -= 1;
            return y, y.key, black_height_t2
    
    # Need to add T1 to check if y's parent is the T.nil from T1
    def transplant(self, T_larger, y, x):
        ## if the heights were the same then this would be then y would be the root
        ## and this would fire
        if y.p == T_larger.sentinel:
            self.root = x
        elif y == y.p.left:
            y.p.left = x
            self.root = T_larger.root
        else:
            y.p.right = x
            self.root = T_larger.root
        x.p = y.p
    
    
    def left_rotate(self, x, T_larger):
        y = x.right
        x.right = y.left
        if y.left != T_larger.sentinel:
            y.left.p = x
        y.p = x.p
        if x.p == T_larger.sentinel:
            self.root = y
        elif x == x.p.left:
            x.p.left = y
        else:
            x.p.right = y
        y.left = x
        x.p = y
        
    
    def right_rotate(self, y, T_larger):
        x = y.left
        y.left = x.right
        if x.right != T_larger.sentinel:
            x.right.p = y
        x.p = y.p
        if y.p == T_larger.sentinel:
            self.root = x
        elif y == y.p.right:
            y.p.right = x
        else:
            y.p.left = x
        x.right = y
        y.p = x
    
    # need this method to fix x if y's parent is red
    def insert_fixup(self, z, T_larger):
        while z.p.color == "Red":
            print("entering while loop")
            if z.p == z.p.p.left:
                y = z.p.p.right
                if y.color == "Red":
                    print("case 1")
                    z.p.color = "Black"    # Case1
                    y.color = "Black"      # Case1
                    z.p.p.color = "Red"    # Case1
                    z = z.p.p              # Case1
                else:                       # Case ? 2/3
                    if z == z.p.right:     
                        z = z.p             # Case 2
                        self.left_rotate(z, T_larger) # Case 2
                    z.p.color = "Black"      # Case 3
                    z.p.p.color = "Red"      # Case 3
                    self.right_rotate(z.p.p, T_larger) # Case 3
            else:
                y = z.p.p.left
                if y.color == "Red":
                    z.p.color = "Black"
                    y.color = "Black"
                    z.p.p.color = "Red"
                    z = z.p.p
                else:
                    if z == z.p.left:
                        z = z.p
                        self.right_rotate(z, T_larger)
                    z.p.color = "Black"
                    z.p.p.color = "Red"
                    self.left_rotate(z.p.p, T_larger)
        if self.root.color == "Red":
            self.bh +=1
        self.root.color = "Black"
    
    def join(self, T1, x, T2):
        self.root = x
        x.color = "Red"
        largest_T1_at_T2bh = self.largest_black_key(T1, T2)
        y = largest_T1_at_T2bh[0]
        print(largest_T1_at_T2bh[1], "was found at black-height", largest_T1_at_T2bh[2])
        # if T1.bh
        if  self.larger_bh == 1:
        ## This new tranplant method has some updates to make the root of the join initially the root
        ## See transplant above in this class
            self.transplant(T1, y, x)
            x.left = y
            y.p = x
            x.right = T2.root
            T2.root.p = x
            self.insert_fixup(x, T1)
        else:
            self.transplant(T2, y, x)
            #print("root is", self.root.key, self.root.left.key)
            x.right = y
            y.p = x
            x.left = T1.root
            T1.root.p = x
            self.insert_fixup(x, T2)
            print("T2's black height was larger.  Symmetric Counterpart coded AT YOUR SERVICE!")
        
    def in_order(self, x, array, T1, T2):
        if x and x.key != "T.nil":
            if x.left == T1.sentinel or x.left == T2.sentinel:
                x.left = self.sentinel
            self.in_order(x.left, array, T1, T2)
            if x.right == T1.sentinel or x.right == T2.sentinel:
                x.right = self.sentinel
            array.append(x.key)
            
            self.in_order(x.right, array, T1, T2)
        
        return array 
      
            

def write_tree_as_dot(t, f, show_nil=False):
    "Write the tree in the dot language format to f."
    def node_id(node):
        return 'N%d' % id(node)
    
    def node_color(node):
        if node.color == "Red":
            return "red"
        else:
            return "black"
    
    def node_text_color(node):
        if node.color == "Red":
            return "black"
        else:
            return "red"
    
    def visit_node(node):
        "Visit a node."
        
        # NOTE GUY DID NOT DO node.key FOR HIS 2ND ARGUMENT JUST node
        print("  %s [label=\"%s\", color=\"%s\", fillcolor=\"%s\", style=filled, fontcolor=\"%s\"];" 
              % (node_id(node), node.key, node_color(node), node_color(node), node_text_color(node)), file=f)
        if node.left:
            if node.left != t.sentinel or show_nil:
                visit_node(node.left)
                print("  %s -> %s ;" % (node_id(node), node_id(node.left)), file=f)
        if node.right:
            if node.right != t.sentinel or show_nil:
                visit_node(node.right)
                print("  %s -> %s ;" % (node_id(node), node_id(node.right)), file=f)
                
      
    print("// Created by rbtree.write_dot()", file=f)
    print("digraph red_black_tree {", file=f)
    visit_node(t.root)
    print("}", file=f)


if '__main__' == __name__:
    import os
    def write_tree(t, filename):
        "Write the tree as an SVG file."
        f = open('%s.dot' % filename, 'w')
        write_tree_as_dot(t, f, False)
        f.close()
        os.system('dot %s.dot -Tsvg -o %s.svg' % (filename, filename))
        
    # Test T1 has higher height >= T2   
    A = [3, 5, 1, 7, 10, 13, 14, 6, 2]
    B = [25, 21, 33, 50]
    
    T1 = RBTree()
    for num in A:
        N = Node(key=num)
        T1.insert(N)
    write_tree(T1, 'treeRB_1_T1_higher')    

    T2 = RBTree()
    for num in B:
        N = Node(key=num)
        T2.insert(N)
    write_tree(T2, 'treeRB_2_T1_higher')  

    print("Testing with T1.bh >= T2.bh")
    print("T1's black height is", T1.bh)
    print("T2's black height is", T2.bh)
    
    
    T = RB_Join()
    T.join(T1, Node(key=20), T2) 
    print("In Order Walk is Maintained for T1 higher black-height!")  
    #  Will print the new root after fix up is called.  If T2.bh is larger than only adds x and breaks
    print(T.in_order(T.root, [], T1, T2))
    print(T.root.key)
    write_tree(T, 'JOIN_T1_higher')   
    print("Please see following .SVG files:")
    print('treeRB_1_T1_higher.SVG')
    print('treeRB_2_T1_higher.SVG')
    print('JOIN_T1_higher.SVG')
    

    print("\n------------------------------------------------------------------------\n")
    # Test T2 has higher height >= T3
    A = [1,2,3,4,5]
    B = [25,26,27,28,30,31,32,32,34,35]     

    T1 = RBTree()
    for num in A:
        N = Node(key=num)
        T1.insert(N)
    write_tree(T1, 'treeRB_1_T2_higher')    

    T2 = RBTree()
    for num in B:
        N = Node(key=num)
        T2.insert(N)
    write_tree(T2, 'treeRB_2_T2_higher')  

    print("Testing with T1.bh >= T2.bh")
    print("T1's black height is", T1.bh)
    print("T2's black height is", T2.bh)
    
    
    T = RB_Join()
    T.join(T1, Node(key=20), T2) 
    print("In Order Walk is Maintained for T2 higher black-height!")  
    #  Will print the new root after fix up is called.  If T2.bh is larger than only adds x and breaks
    print(T.in_order(T.root, [], T1, T2))
    print(T.root.key, "is the Root")
    write_tree(T, 'JOIN_T2_higher')       
    print("Please see following .SVG files:")
    print('treeRB_1_T2_higher.SVG')
    print('treeRB_2_T2_higher.SVG')
    print('JOIN_T2_higher.SVG')        