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
        self.size = 0

    
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
        y.size = x.size
        x.size = x.left.size + x.right.size + 1
        
    
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
        x.size = y.size
        y.size = y.right.size + y.left.size + 1
        
    def insert_fixup(self, z):
        while z.p.color == "Red":
            if z.p == z.p.p.left:
                y = z.p.p.right
                if y.color == "Red":
                    #print("case 1")
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
        z.size = 1
        y = self.sentinel
        x = self.root
        while x != self.sentinel:
            x.size += 1
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
            case1 = False;
            if x == x.p.left:
                w = x.p.right
                if w.color == "Red":  
                    print("L,entering case 1")
                    w.color = "Black"             # Case 1
                    x.p.color = "Red"             # Case 1
                    self.left_rotate(x.p)         # Case 1
                    w = x.p.right                 # Case 1
                    case1 = True
                if w.left.color == "Black" and w.right.color == "Black":
                    print("L,entering case 2")
                    w.color = "Red"               # Case 2
                    x = x.p                       # Case 2
                    print(x == self.root, x.key)
                    if x == self.root and not case1:
                        self.bh -= 1;
                else:
                    if w.right.color == "Black":  
                        print("L,entering case 3")
                        w.left.color == "Black"   # Case 3
                        w.color == "Red"          # Case 3
                        self.right_rotate(w)      # Case 3
                        w = x.p.right             # Case 3
                    print("L,entering case 4")
                    w.color = x.p.color           # Case 4
                    x.p.color = "Black"           # Case 4
                    w.right.color = "Black"       # Case 4
                    self.left_rotate(x.p)         # Case 4
                    x = self.root                 # Case 4
            else:
                w = x.p.left
                if w.color == "Red":  
                    print("R,entering case 1")
                    w.color = "Black"             # Case 1
                    x.p.color = "Red"             # Case 1
                    self.right_rotate(x.p)         # Case 1
                    w = x.p.left                 # Case 1
             
                if w.right.color == "Black" and w.left.color == "Black":
                    print("R,entering case 2")
                    w.color = "Red"               # Case 2
                    x = x.p                       # Case 2
                    print(x == self.root, x.key)
                    if x == self.root:
                        self.bh -= 1;
                else:
                    if w.left.color == "Black":  
                        print("R,entering case 3")
                        w.right.color == "Black"   # Case 3
                        w.color == "Red"          # Case 3
                        self.left_rotate(w)      # Case 3
                        w = x.p.left             # Case 3
                    print("R,entering case 4")
                    w.color = x.p.color           # Case 4
                    x.p.color = "Black"           # Case 4
                    w.left.color = "Black"       # Case 4
                    self.right_rotate(x.p)         # Case 4
                    x = self.root                   # Case 4
        x.color = "Black"
    
        return x.color
    
    def delete_search(self, x, k):
        if None == x:
            x = self.root
        while x != self.sentinel and k != x.key:
            x.size -= 1
            if k < x.key:
                x = x.left
            else:
                x = x.right
        x.size -= 1
        print("new size of deleted node", x.key, "is", x.size)        
        return x
    
    
    def delete(self, z):
        print("z", z)
        z = self.delete_search(self.root, z)
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
            y.size = z.size          
            y_orig_col = y.color
            x = y.right
            # update the parents of y until you get to where y replaced z
            temp = y.p
            y_p_is_z = False
            if y.p == z:
                x.p = y
                y_p_is_z = True
            else:
                
                self.transplant(y, y.right)
                y.right = z.right
                y.right.p = y
            self.transplant(z, y)
            while temp != y and not y_p_is_z:
                temp.size -= 1
                temp = temp.p
            y.left = z.left
            y.left.p = y
            y.color = z.color
            
        if y_orig_col == "Black":
            
            self.delete_fix(x)
            

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
        #print >> f, "  %s [label=\"%s\", color=\"%s\"];" % (node_id(node), node, node_color(node))
        
        # NOTE GUY DID NOT DO node.key FOR HIS 2ND ARGUMENT JUST node
        print("  %s [label=\"%s\", color=\"%s\", fillcolor=\"%s\", style=filled, fontcolor=\"%s\"];" 
              % (node_id(node), str(node.key) + ":" + str(node.size), node_color(node), node_color(node), node_text_color(node)), file=f)
        if node.left:
            if node.left != t.sentinel or show_nil:
                visit_node(node.left)
                #print >> f, "  %s -> %s ;" % (node_id(node), node_id(node.left))
                print("  %s -> %s ;" % (node_id(node), node_id(node.left)), file=f)
        if node.right:
            if node.right != t.sentinel or show_nil:
                visit_node(node.right)
                #print >> f, "  %s -> %s ;" % (node_id(node), node_id(node.right))
                print("  %s -> %s ;" % (node_id(node), node_id(node.right)), file=f)
                
      
    #print >> f, "// Created by rbtree.write_dot()"
    print("// Created by rbtree.write_dot()", file=f)
    #print >> f, "digraph red_black_tree {"
    print("digraph red_black_tree {", file=f)
    visit_node(t.root)
    #print("  %s -> %s ;" % (node_id(t.root), node_id(t.sentinel)), file=f)
    #print >> f, "}"
    print("}", file=f)


if '__main__' == __name__:
    import os, random
    def write_tree(t, filename):
        "Write the tree as an SVG file."
        f = open('%s.dot' % filename, 'w')
        write_tree_as_dot(t, f, True)
        f.close()
        os.system('dot %s.dot -Tsvg -o %s.svg' % (filename, filename))
        
        
    A = [1,2,3,4,5,6,7,8,9,10,12,13]

    
    T = RBTree()
    random.shuffle(A)
    for num in A:
        N = Node(key=num)
        T.insert(N)
        print("Inserting node ", num, "Black height is&&&&&&", T.bh,)
        #write_tree(T, 'treeRB' + str(num))  
write_tree(T, 'treeRB' + str(num))  
'''
    random.shuffle(A)
    for num in (A):
        print("deleting", num, "bh**********************************=", T.bh)
        T.delete(num)
        
        write_tree(T, 'treeRB_delete' + str(num))  
'''

num = 4
T.delete(num)
write_tree(T, 'treeRB_delete' + str(num))  

num = 10
T.delete(num)
write_tree(T, 'treeRB_delete' + str(num))  

num = 2
T.delete(num)
write_tree(T, 'treeRB_delete' + str(num))
