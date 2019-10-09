# -*- coding: utf-8 -*-
"""
Created on Wed Jul 18 17:05:47 2018

@author: bjwil
"""

# Parent class
class Pets:

    dogs = []

    def __init__(self, dogs):
        self.dogs = dogs

    def walk(self):
        for dog in self.dogs:
            print(dog.walk())


# Parent class
class Dog:

    # Class attribute
    species = 'mammal'
    is_hungry = True

    # Initializer / instance attributes
    def __init__(self, name, age):
        self.name = name
        self.age = age

    # Instance method
    def description(self):
        return self.name, self.age

    # Instance method
    def speak(self, sound):
        return "%s says %s" % (self.name, sound)

    # Instance method
    def eat(self):
        self.is_hungry = False

    def walk(self):
        return "%s is walking!" % (self.name)


# Child class (inherits from Dog class)
class RussellTerrier(Dog):
    def run(self, speed):
        return "%s runs %s" % (self.name, speed)


# Child class (inherits from Dog class)
class Bulldog(Dog):
    def run(self, speed):
        return "%s runs %s" % (self.name, speed)

# Create instances of dogs
my_dogs = [
    Bulldog("Tom", 6), 
    RussellTerrier("Fletcher", 7), 
    Dog("Larry", 9)
]

# Instantiate the Pet class
my_pets = Pets(my_dogs)

# Output
my_pets.walk()