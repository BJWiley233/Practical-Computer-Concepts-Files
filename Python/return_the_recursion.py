# -*- coding: utf-8 -*-
"""
Created on Thu Jul  5 12:31:02 2018

@author: bjwil
"""

def recursive(months, starting_pop):
    if months == 0:
        return starting_pop
    new_pop = 1.08*starting_pop - 400
    new_months = months-1
    return recursive(new_months, new_pop)
    
    
recursive(6,5000)
recursive(6,5000)
starting_pop = 5000
months = 6

# snippet 1
x = True
y = False
z = False
if not x or y:
    print(1)
elif not x or not y and z:
    print(2)
elif not x or y or not y and x:
    print(3)
else:
    print (4)

# snippet 2   
fruits = ['apple', 'banana', 'cherry']
fruits.reverse()
print(fruits)

string = "CCCTATGGCAGCGTT"
string[::-1]

#snippet 3
x = (123, 'techbeamers')
t = x * 2
x = (123)
type(x)
d = (123, 1)

#snippet 4
def f():
    pass

def c():
    return 0

print(type(f()))
print(type(f))
print(type(c()))
print(type(c))


num = 5*5
print(num)
num = '5*5'
print(num)
num = '5'*'5'
print(num)

print(3/5)
print(3//5)
print(3.0//5)
print(12/3)
print(12//3)


import re
sentence = 'Learn Python Programming'
test = re.match(r'(.*) (.*?) (.*)', sentence)
test = re.match(r'(.*) (.*) (.*)', sentence)
print(test.group())

sentence1 = 'L two spaces three spaces4'
test = re.match(r'(.*)', sentence1)
print(test.group())





import random

my_temp_San_Diego = round(random.uniform(60,86), 2)

if my_temp > 80:
    print('Sunny')

else:
    print('Cloudy')


my_ints = range(1,10)
for integer in my_ints:
    print(integer)
    # below would print a line in between each line
    #print('{} \n'.format(integer))

