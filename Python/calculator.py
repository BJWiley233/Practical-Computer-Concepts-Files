
# -*- coding: utf-8 -*-
"""
Created on Tue Jun 26 23:05:35 2018

@author: bjwil
"""

# import modules
import sys
from timeit import timeit
import random
import time
import pandas as pd
import string

# initialize numbers as words dictionary.  only works if one number is spelled out.  need an entire set of functions
# like in this resource for anything more: https://codereview.stackexchange.com/questions/141774/function-to-spell-numbers-below-1-000-000-000
numbersAsWords = {"ZERO": 0, "ONE": 1, "TWO": 2, "THREE": 3, "FOUR": 4, "FIVE": 5, "SIX": 6, "SEVEN": 7, "EIGHT": 8, "NINE": 9}
# two dictionaries that are equal.  one for validating if type word spelling is in dictionary above, and another to enter more 
# values.  I could have use the same but wanted to use validate number under main method to avoid confusion there. 
validateNum = {"YES": True, "Y": True, "NO": False, "N": False} 
valid = {"YES": True, "Y": True, "NO": False, "N": False} 


# subract function 
def subtract(numbers):  
    '''takes a set of numbers and subtracts all the numbers from the first number'''
    total = numbers[0]
    for i in range(1,len(numbers)):
        total -= numbers[i]
    
    return total

# add function
def add(numbers):
    '''take a set of numbers and adds them together'''
    total = 0
    for x in numbers:
        total += x
    
    return total

# multiply function
def multiply(numbers):   
    '''take a set of numbers and adds them together'''
    # must multiply first number by 1 in loop in order to return a total.
    total = 1
    for x in numbers:
        total *= x
    
    return total

# divide function
def divide(numbers):   
    '''take the first number and divides but the remaining sequential number.  throws ZeroDivision
    exception and return error'''
    total = numbers[0]
    for i in range(1,len(numbers)):
        try:
            total /= numbers[i] 
        except ZeroDivisionError:
            print("Invalid division by 0!")
            return ('Err')
            
     
    return round(total, 5)


# dictionary to use operator selection as functions to call.  got the idea from https://www.youtube.com/watch?v=nUhhDhSXP-Q
operators = {"-": subtract, "+": add, "*": multiply, "/": divide}

# main function
def main():
    while True:
        # input first number
        try:
            input1 = input("Please enter first number (or press q/Q to quit): ").upper()
            if input1.isalpha() and input1.upper() == 'Q' or input1.upper() == 'q':
                sys.exit(0)
            # if input matches diction for words zero to nine confirm if they wanted the number
            elif input1.upper() in numbersAsWords:
                inputVerification = str(input("Did you mean {}? If so press (Y/N). ".format(numbersAsWords[input1])).upper())
                while inputVerification not in validateNum:
                    inputVerification = str(input("Invalid. Please enter (Y/N): ").upper())
                if inputVerification in validateNum and validateNum[inputVerification] == True:
                    input1 = numbersAsWords[input1]
                    break
                else: 
                    input1 = input("Please enter first number (or press q/Q to quit): ")
            # coerce to float for input default
            else:
                input1 = float(input1)
                break
        except ValueError:
            print("That was not an number.  Please enter first number (or press q/Q to quit): ")
     
    # get operator    
    while True:
        operator = str(input("Enter operator (+.-.*./) (or presss q/Q to quit): ")).upper()
        if operator == 'Q' or operator.upper() == 'q':
            sys.exit
        # if entry not in operators dictionary cotinue prompt
        while operator not in operators:
            operator = str(input("Enter operator (or presss q/Q to quit): "))
        if operator in operators:
            break
        
    # get second number 
    while True:        
        try:
            input2 = input("Please enter second number (or press q/Q to quit): ").upper()
            if input2.isalpha() and input2.upper() == 'Q' or input2.upper() == 'q':
                sys.exit()
            # if input matches diction for words zero to nine confirm if they wanted the number
            elif input2.upper() in numbersAsWords:
                inputVerification = str(input("Did you mean {}? If so press (Y/N). ".format(numbersAsWords[input2])).upper())
                while inputVerification not in validateNum:
                    inputVerification = str(input("Invalid. Please enter (Y/N): ").upper())
                if inputVerification in validateNum and validateNum[inputVerification] == True:
                    input2 = numbersAsWords[input2]
                    break
                else: 
                    input2 = input("Please enter first number (or presss q/Q to quit): ")
            # coerce to float for input default
            else:
                input2 = float(input2)
                break
        except ValueError:
            print("That was not an number.  Please enter second number (or presss q/Q to quit): ")

    # cannot round a string when divide function gives error so need to stipulate return statements
    if operator == "/" and input2 == 0:
        return input1, input2, operator, operators[operator]((input1, input2))
    else:
        # returns inputs, operator, and final value for dataframe later
        return input1, input2, operator, round(operators[operator]((input1, input2)),5)

# time script start
startTime = time.clock()
# instantiate dataframe for results
data = pd.DataFrame(columns = ['First Number:', 'Operator:', 'Second Number:', 'Equals:', 'Value:'])
###### Run Calcultor    
enter = True
while enter == True:
    # run main call function to get prompt for
    listValues = main()
    # is there better way intialize these variables? these are the 4 return values from function for results in dataframe
    firstInput, secondInput, operator, value = listValues[0], listValues[1], listValues[2], listValues[3] 
    # always print the value from the 4th return from the main function immediately
    print("Equals: {}".format(value))
    # add all 5 variables as values to dataframe
    df = pd.DataFrame([[firstInput, operator, secondInput, '=', value]], columns = list(data))
    # merge to existing dataframe and continue from last index
    data = data.append(df, ignore_index = True)
    # prompt to enter again
    again = str(input("Enter again (Y/N)?\n ").upper())
    # while the entry from the user is not valid, continue to prompt for valid input
    while again not in valid:
        again = str(input("Please enter (Y/N): ").upper())
    # if play again is valid selection, play will equal True or False 
    if again in valid:
        enter = valid[again]
# print data frame results after user ends inputs
print("Here are your results from your entries: \n")
print(data)

# bonus round allows to enter more than two values
print("\n")
print("Bonus Time! ")
bonusInput = str(input("Enter numbers by a comma seperated list to perform an operation (ex. 1,2,3,4,654,25,12): "))
# for valid input when first character entered is number split in a loop each number seperated by a comma to a float
if bonusInput[0].isdigit():
    mylist = [float(x) for x in bonusInput.split(',')]
# while entry starts with letter continue to prompt
while bonusInput[0].isalpha():
    bonusInput = str(input("Enter numbers by a comma seperated list to perform an operation (ex. 1,2,3,4,654,25,12): "))
# coerce list to tuple for entry to calculator definitions +-*/   
finalNumbers = tuple(mylist)
# prompt for operator
operatorBonus = str(input("Enter operator (or presss q/Q to quit): "))
if operatorBonus.upper() == 'Q' or operatorBonus.upper() == 'q':
    sys.exit()
# will print what ever is returned from one of the 4 operator functions.
print("Equals {}.".format(operators[operatorBonus](finalNumbers)))

print("\n\n")
print("Tests:")

##################################### Tests
print(operators['+']((100, 50)))
print(operators['-']((50, -40)))
print(operators['*']((5, 6)))
print(operators['/']((5, 6)))
print(divide((5, 0)))
print(operators['+']((numbersAsWords['FIVE'], 6)))
print(operators['/']((0, 0)))
# below throws an error
# print(operators['+'](('Five', 6)))

##################################### Time 100000 each.
print("Timed Tests:")
if __name__=='__main__':
    from timeit import Timer
    test = []
    for key in operators:
            num1, num2 = random.choice(range(0,100)), random.choice(range(0,100))
            if num2 == 0:
                t = Timer(lambda: divide((num1, num2))).timeit(number=100000)   
            else:
                t = Timer(lambda: operators[key]((num1, num2))).timeit(number=100000)
            test.append(t)
    print("Ran tests in {} seconds.\n".format(round(sum(test),2)))
  
print("Script time: {} seconds".format(round(time.clock() - startTime),4))
