'''Beer Song
@Jdoodle

Brian Wiley
CIS156 - Python Programming


'''

#initialize word for song
def play(word):
    
    word = 'bottles'

#loop to count backwards from 99 to 0 bottles
    for beer in range(99, 0, -1):
        #print first line of song
        print(beer, word, 'of beer on the wall.')
        #print second line of song
        print(beer, word, 'of beer.')
        #print third and fourth line of song
        print('Take one down. Pass it around.')
        #if beer is 1 then after thrid and fourth line end song with last line
        if beer == 1:
              print('No more bottles of beer on the wall.')
        #else reduce beer count for next loop iteration
        else:
              new_num = beer - 1
              #if number is 1 for last bottle change word to 'bottle'
              if new_num == 1:
                  word = 'bottle'
              #print new word for last bottle then go through loop 1 more time
              print(new_num, word, 'of beer on the wall.')
        #print new open line at end of song
        print()
    
word = ''
play(word)