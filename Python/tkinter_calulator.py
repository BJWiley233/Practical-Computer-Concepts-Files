# -*- coding: utf-8 -*-
"""
Created on Mon Jul 23 17:28:25 2018

@author: bjwil

Instructions:
    - Must include the png file "del1.png" in same file folder as script
    - Once program is ran click program window to activate it
    - You do not need to click on the entry widget. In fact it is read only
    - There is bind_all functionality for all the buttons except reset so
      you can just type 1) numbers, 2) operators, 3) enter, and 4) backspace
    - Buttons provide all the functionality and all are bounded to keys
    - Only issue I had was getting the entry widget to show comma for thousands
      because it was too complicated (meaning I couldn't figure it out)
      how to continually have the 
    - Pressing "=" with no operator visible will set the total to what is in 
      the entry widget.
    - Different from Microsoft Calculator in 2 ways:
        1) Has seperate line for total and operator
        2) Once you press equal and have a total, Microsoft calculator will 
           save the operator and last entry and pressing "=" redoes the 
           calculation.  This calculator instead resets causing you to have to
           enter the operator and last entry again.  Change could be made to 
           save last entry and operator but decided against it for now.  If you
           want to do this then use the second equals() definition which is 
           commented out at the end.
"""

# set imports
from tkinter import *
#import locale
from PIL import ImageTk, Image


#locale.setlocale(locale.LC_ALL, 'en_US')

# create Calculator class
class Calculator:
    # define variables
    def __init__(self, master):
        self.master = master
        master.title("Calculator")
        master.geometry('300x400') # Part 1: Size 300 x 400
        master.configure(background='seagreen',) # Part 2: make bg green
        # instantiate variables
        self.total = 0.0
        self.entered_number = 0.0
        self.operator = "+"
        self.background_entry = 0.0
        # variable used for defualt 0 value in entry widget
        self.var = DoubleVar()
        ''' Photo variable for image on a button 
        https://www.daniweb.com/programming/software-development/code/216852/
        an-image-button-python-and-tk
        '''
        self.photo1 = ImageTk.PhotoImage(Image.open("del1.png"), master=root)
        # Create diction for excpetion handling of key input
        self.operators = {"+":"", "-":"", "/":"", "*":""}
        # create variable for total text at top which is set to self.total
        self.total_label_text = DoubleVar()
        self.total_label_text.set(self.total)
        # Label which will hold self.total_label_text, justify right
        self.total_label = Label(master, textvariable=self.total_label_text, 
                                 bg='seagreen', fg='snow', width=16,
                                 justify=RIGHT, font='Helvetica 12 bold')
        # anchor label to east side of label width, I don't think we need
        # justify=RIGHT above.  this does it for us.
        self.total_label.configure(anchor=E)
        # Label for the "Total" text
        self.label = Label(master, text="Total:", bg='seagreen',
                           fg='snow', font='Helvetica 12 bold')
        # Text variable for operator which will be set to self.operator
        self.operator_label_text = StringVar()
        self.operator_label_text.set(self.operator)
        # Label which will hold operator above the entry and below total
        self.operator_label = Label(master, textvariable=self.operator_label_text, 
                                 bg='seagreen', fg='snow', width=16,
                                 justify=RIGHT, font='Helvetica 12 bold')
        # same anchor as total_label
        self.operator_label.configure(anchor=E)
        vcmd = master.register(self.validate) # we have to wrap the command
        '''Making the state disabled and then having to enable it and 
        re-disable it like indicated as last answer in below source is annoying.  
        Anyway around it?  I wanted to find a source that disabled "cursoring"
        the entry block but not disable data from being entered.  I ran into 
        issue with the bind_all of pressing any from anywhere in the app
        like in the Microsoft calculator but when I was "cursored" in then 
        pressing a number was creating double entry.        
        https://stackoverflow.com/questions/10817917/how-to-disable-
        input-to-a-text-widget-but-allow-programatic-input
        '''
        self.entry = Entry(master, validate="key", width=27,
                           validatecommand=(vcmd, '%P'), justify=RIGHT, 
                           state="disabled", disabledforeground="black",
                           textvariable=0)
        
        # Need to initially have this set to 0.  This is annoying but necessary
        self.entry.configure(state="normal", textvariable=self.var)
        self.var.set(0)
        self.entry.configure(state="disable")
        
        # Create all the operator buttons and then bind keys to them all
        self.add_button = Button(master, text="+",bg='seagreen', width=2,
                                 command=lambda: self.update_operator("+"))
        self.subtract_button = Button(master, text="-", width=2, bg='seagreen',
                                      command=lambda: self.update_operator("-"))
        self.divide_button = Button(master, text="/", width=2, bg='seagreen',
                                    command=lambda: self.update_operator("/"))
        self.multiply_button = Button(master, text="*", width=2, bg='seagreen',
                                      command=lambda: self.update_operator("*"))
        self.equals_button = Button(master, text="=", bg='seagreen', padx=12, 
                                   command=lambda: self.equals())
        '''I was like "YESSS!" after this worked below.  Source: 
        https://stackoverflow.com/questions/23842770/python-function-
        takes-1-positional-argument-but-2-were-given-how'''
        self.equals_button.bind_all("<Return>", lambda e:self.equals())
        self.add_button.bind_all("<+>", lambda e:self.update_operator("+"))
        self.subtract_button.bind_all("-", lambda e:self.update_operator("-"))
        self.divide_button.bind_all("/", lambda e:self.update_operator("/"))
        self.multiply_button.bind_all("<*>", lambda e:self.update_operator("*"))
        
        # Create reset button.  No key is binded to this button.
        self.reset_button = Button(master, text="Reset", bg='seagreen', 
                                   command=lambda: self.reset())
        
        # Create numbers buttons.  This is organized by button first and 
        # immediately by the binding key, different organization than for 
        # operator keys above, depends on preference; keeping button and bind
        # together or group all buttons and then group all binds
        self.one_button = Button(master, text="1", width=2, bg='seagreen',
                                 command=lambda: self.set_number(number = "1"))
        self.one_button.bind_all("1", lambda e:self.set_number(number = "1"))
        self.two_button = Button(master, text="2", width=2, bg='seagreen',
                                 command=lambda: self.set_number(number = "2"))
        self.two_button.bind_all("2", lambda e:self.set_number(number = "2"))
        self.three_button = Button(master, text="3", width=2, bg='seagreen',
                                 command=lambda: self.set_number(number = "3"))
        self.three_button.bind_all("3", lambda e:self.set_number(number = "3"))
        self.four_button = Button(master, text="4", width=2, bg='seagreen',
                                 command=lambda: self.set_number(number = "4"))
        self.four_button.bind_all("4", lambda e:self.set_number(number = "4"))
        self.five_button = Button(master, text="5", width=2, bg='seagreen',
                                 command=lambda: self.set_number(number = "5"))
        self.five_button.bind_all("5", lambda e:self.set_number(number = "5"))
        self.six_button = Button(master, text="6", width=2, bg='seagreen',
                                 command=lambda: self.set_number(number = "6"))
        self.six_button.bind_all("6", lambda e:self.set_number(number = "6"))
        self.seven_button = Button(master, text="7", width=2, bg='seagreen',
                                 command=lambda: self.set_number(number = "7"))
        self.seven_button.bind_all("7", lambda e:self.set_number(number = "7"))
        self.eight_button = Button(master, text="8", width=2, bg='seagreen',
                                 command=lambda: self.set_number(number = "8"))
        self.eight_button.bind_all("8", lambda e:self.set_number(number = "8"))
        self.nine_button = Button(master, text="9", width=2, bg='seagreen',
                                 command=lambda: self.set_number(number = "9"))
        self.nine_button.bind_all("9", lambda e:self.set_number(number = "9"))
        self.zero_button = Button(master, text="0", width=2, bg='seagreen',
                                 command=lambda: self.set_number(number = "0"))
        self.zero_button.bind_all("0", lambda e:self.set_number(number = "0"))
        self.decimal_button = Button(master, text=".", width=2, bg='seagreen',
                                 command=lambda: self.set_number(number = "."))
        self.decimal_button.bind_all(".", lambda e:self.set_number(number = "."))
        self.clr_last_button = Button(master, text="C", width=2, bg='seagreen',
                                 image=self.photo1, 
                                 command=lambda: self.set_number(number = "c"))
        self.clr_last_button.bind_all("<BackSpace>", 
                                      lambda e:self.set_number(number = "c"))
        # this inputs the phote into the button for clear last number entered
        self.clr_last_button.image = self.photo1
        
        # LAYOUT
        self.label.grid(row=0, column=0, sticky="W", pady=(4,0))
        self.total_label.grid(row=0, column=1, columnspan=5, sticky="W", pady=(4,0))
        self.operator_label.grid(row=1, column=1, columnspan=5)
        self.entry.grid(row=2, column=1, columnspan=5, sticky="W")
        
        self.add_button.grid(row=3, column=1, sticky="EW")
        self.subtract_button.grid(row=3, column=2, sticky="EW")
        self.divide_button.grid(row=3, column=3, sticky="EW")
        self.multiply_button.grid(row=3, column=4, sticky="EW")
        self.reset_button.grid(row=3, column=5, sticky="EW", padx=(15,0))
        self.equals_button.grid(row=4, column=5, sticky="WE", padx=(15,0))
        
        self.one_button.grid(row=4, column=1, sticky="EW")
        self.two_button.grid(row=4, column=2, sticky="EW")
        self.three_button.grid(row=4, column=3, sticky="EW")
        self.zero_button.grid(row=4, column=4, sticky="EW")
        self.four_button.grid(row=5, column=1, sticky="EW")
        self.five_button.grid(row=5, column=2, sticky="EW")
        self.six_button.grid(row=5, column=3, sticky="EW")
        self.decimal_button.grid(row=5, column=4, sticky="EW")
        self.seven_button.grid(row=6, column=1, sticky="EW")
        self.eight_button.grid(row=6, column=2, sticky="EW")
        self.nine_button.grid(row=6, column=3, sticky="EW")
        self.clr_last_button.grid(row=6, column=4, sticky="NEWS")

    # def to validate entries are only operators or numbers/floats        
    def validate(self, new_text):
        if not new_text: # the field is being cleared
            self.entered_number = 0.0
            return True
        # try to see if entry is in operators as keys, if so set operator 
        try:
            self.operators[new_text]
            self.operator = new_text
            self.operator_label_text.set(new_text)
            return True
        # if entry is not an operator return KeyError
        except KeyError:
            return False
        # finally if not an operator try for float entry
        finally:            
            try:
                self.entered_number = float(new_text)
                return True
            # if not float number return ValueError
            except ValueError:
                return False   
        
    # def for setting number in entry widget
    def set_number(self, number):
        # unlock entry field
        self.entry.configure(state="normal")
        # because of the try/except for float above have to handle the "." as
        # first entry outside of the exception.  If
        if number == "." and self.entry.get() == "0":
            self.entry.delete(0, END)
            self.entry.insert(END, 0.)
        # when function calls for first number need to delete the default 0,
        # causes the function to act like a "replacer" from the default because
        # there is no Entry.replace() function in tkinter
        if self.entry.get() == "0":
            self.entry.delete(0, END)
        '''If operator is blank and the total displayed is not 0.0 (see 
        update_operator def below first if statement, this means operator was
        entered again after entry field and operator text are full causing
        a throw to equals().)
        '''
        if self.operator_label_text.get() == "" and self.total != 0.0:
            self.total = 0.0
            self.total_label_text.set(self.total)
        # if backspace arrow, delete last entry
        if number == "c":
            self.entry.delete(len(self.entry.get())-1, END)
        # basic scenario to just add number to end
        self.entry.insert(END, number)
        # manipulates entry so that when "." is entered first shows just
        # a "0." and not a "0.0" because then if you enter "." > "2" then you
        # get expected "0.2 instead of "0.02"
        if str(self.entry.get()) == "0.0" and number != "0":
            self.entry.delete(0, END)
            self.entry.insert(END, "0.")
        self.entry.configure(state="disable")
        return
    
    # def resets everything
    def reset(self):
        self.entry.configure(state="normal", textvariable=self.var)
        self.total = 0.0
        self.operator = ''
        self.operator_label_text.set(self.operator)
        self.total_label_text.set(self.total)
        self.entry.delete(0, END)
        self.var.set(0)
        self.entry.configure(state="disable")
    
    # def to update operator
    def update_operator(self, operator):
        # need to activate entry to be able to change because when first 
        # entering number upon starting and you press an operator then sets
        # total to that number and free up the entry widget
        self.entry.configure(state="normal", textvariable=self.var)
        # pertaining to previous comment sets the total after number entry
        # followed by operator upon starting calculations
        if self.operator_label_text and self.entered_number:
            self.equals()
        # set operator from function argument operator
        self.operator = operator     
        # sets visible text operator
        self.operator_label_text.set(self.operator)
        # this actually sets the total to the entered number after operator 
        # is passed
        if self.total == 0.0:
            # need to set self.total here so calls to equals() calculates
            self.total = self.entered_number
            # sets the number to thousands comma seperated.
            self.total_label_text.set(format(self.entered_number, ","))
            self.entry.delete(0, END)
        # reset to default
        self.var.set(0)
        self.entry.configure(state="disable")
    
    # def to do all the operator calculations
    def equals(self):
        self.entry.configure(state="normal")
        # coerces the thousands comma seperate string to float for calculations
        if isinstance(self.total, str):
            self.total = float(self.total.replace(',',''))
        # do calculations and reformat back to thousands comma seperator string
        if self.operator == "+":
            self.total = format(float(self.total) + self.entered_number, ",")
        elif self.operator == "-":
            self.total = format(float(self.total) - self.entered_number, ",")
        elif self.operator == "/":
            try:
                self.total = format(round(self.total/self.entered_number, 10), ",")
            except ZeroDivisionError:
                self.total = 'Err!'
        elif self.operator == "*":
            self.total = format(round(self.total*self.entered_number, 10), ",")
        # if there is no operator and just an entry then set total to entry
        elif self.operator_label_text.get() == "":
            self.total = format(self.entered_number, ",")
        # set the total text to total
        self.total_label_text.set(self.total)
        # finish with the resetting 
        self.entry.delete(0, END)
        self.operator = ''
        self.var.set(0)
        self.operator_label_text.set(self.operator)
        self.entry.configure(state="disable")

    # Use code below for equals() def if you don't want the 2nd difference
    # from the Microsoft calculator. Probably would mimic the Micosoft 
    # calculator view if I was going to do this and make the entry widget show
    # the total. There could be some bugs in here.
    '''def equals(self):
        self.entry.configure(state="normal", textvariable=self.var)
        if self.entered_number != 0.0:
            self.background_entry = self.entered_number
        if self.entered_number == 0:
            if self.operator == "+":
                self.total = format(float(self.total) + self.background_entry, ",")
            elif self.operator == "-":
                self.total = format(float(self.total) - self.background_entry, ",")
            elif self.operator == "/":
                try:
                    self.total = format(round(self.total/self.background_entry, 11), ",")
                except ZeroDivisionError:
                    self.total = 'Err!'
            elif self.operator == "*":
                self.total = format(round(self.total*self.background_entry, 11), ",")
        print(self.background_entry)
        if isinstance(self.total, str):
            self.total = float(self.total.replace(',',''))
        if self.operator == "+":
            self.total = format(float(self.total) + self.entered_number, ",")
        elif self.operator == "-":
            self.total = format(float(self.total) - self.entered_number, ",")
        elif self.operator == "/":
            try:
                self.total = format(round(self.total/self.entered_number, 11), ",")
            except ZeroDivisionError:
                self.total = 'Err!'
        elif self.operator == "*":
            self.total = format(round(self.total*self.entered_number, 11), ",")
        elif self.operator_label_text.get() == "":
            self.total = format(self.entered_number, ",")
        self.total_label_text.set(self.total)
        self.var.set(0)
        self.operator_label_text.set(self.operator)
        self.entry.configure(state="disable")
        '''
        
root = Tk()
#root = Toplevel()

# Put the calculator content in the GUI window
my_gui = Calculator(root)

# PART 1 - Add the line(s) to make the pop-up box size 300px by 400px

# PART 2 - Add the line(s) to make the pop-up box background green 

# PART 3 - Add the code to add Multiple and Divide buttons

# PART 4 (Extra Credit) - Add the line(s) to make all labels, boxes, and button background green to match the background
root.mainloop()

