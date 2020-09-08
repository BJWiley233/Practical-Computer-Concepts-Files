# Perl: Overview of Basics 

# Examples

use strict; # including this module to help trap errors

# Perl variables -- scalars, arrays, hash tables
my $an_int = 1; # A scalar. The name is prefixed with a $
my $a_string = "Something"; # Can use " or ' for strings, but they are handled differently

my @an_array = ('a', 2, $a_string); # The name is prefixed with a @
my %a_dict = ("key1"=>2, "key2"=>25); # The name is prefixed with a %

$an_int += $an_array[1]; # The element of the array is a scalar. Notice also the [] 
my $avalue = $a_dict{"key2"}; # The element of the hash table is also a scalar. Notice also the {}
my $another_string = $a_string . " else"; # String concatenation uses .

# Variable substitution inside of a string defined with double quotes
print "Here is a value: $an_int, and avalue: $avalue, and another string: $another_string\n";
$an_int = "Not an int now";
print "an_int: $an_int\n";

# Perl has the control constructs you would expect
for (my $i=0; $i<10; $i++) {
  if ($i == 0) { # use == for number equality, use eq for string equality tests
    print "I is zero!\n";
  } elsif ($i >= 1 && $i <= 3) {
    print "I is [1, 3]\n";
  } else {
    print "I+10 is " . get_info($i). "\n";
  }
}

# Regular expressions
my $a = "hello world!";
if ($a =~/[op]/) {
  print "$a contains o or p\n";
}

if ($a =~ /^he/) {
  print "$a starts with he\n";
} 

if ($a =~/he..o/) {
  print "$a matches he followed by 2 characters followed by an o\n";
}

$a = "Hi world!";
if ($a =~ /^he/) {
  print "$a starts with he\n";
} else {
  print "$a does not start with he\n";
}
if ($a =~/he..o/) {
  print "$a matches he followed by 2 characters followed by an o\n";
} else {
  print "$a does not match he followed by 2 chars followed by an o\n";
}

my $name = 'Wall, Larry';
$name =~ /(\w+), (\w+)/;
my $name2 = "$2 $1"; # name2 is "Larry Wall"
print "New name: $name2\n";

my $astr = "I hate Perl.";
$astr =~ s/hate/like/;  # Note the s
print "$astr\n";


# References
my $s = "a string";
my $ref = \$s;
print "ref is $ref\n";
print "ref points to a variable that has value: $$ref\n"; # $$ dereferences back to a scalar

my @arr = ('a', 'b', 'c');
my $aref = \@arr;
print "Pointer: $aref\n";
print "aref points to a variable that has value: @$aref\n"; # @$ dereferences back to an array


# Defining a subroutine
sub get_info { # Declare at the end of the file
  my $var = shift; # get first argument
  return $var + 10;
}

