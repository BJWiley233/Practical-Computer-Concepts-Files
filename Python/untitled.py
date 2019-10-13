# -*- coding: utf-8 -*-
"""
Created on Sat Jul 21 16:58:20 2018

@author: bjwil
"""

class MyBlueHeaven:

     media_type = "Song"

     def crazy_songs():
          print("In my Blue Heaven.")
          
c = MyBlueHeaven()

c.crazy_songs()

class TestClass:

     def __init__ (self, a:int = 0, b:int = 5):
          self.y_int = a
          self.x_int = b

test = TestClass()

print(test.x_int)