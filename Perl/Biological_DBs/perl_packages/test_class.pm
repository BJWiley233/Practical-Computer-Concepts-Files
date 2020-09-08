#! /usr/bin/perl

package test_class;
use Acme::Comment type => 'C++';
use Carp;

sub new {
	
	# Check for common user mistake
    Carp::croak("Options to LWP::UserAgent should be key/value pairs, not hash reference")
        if ref($_[1]) eq 'HASH';
	
	my($class, %args) = @_;
	
	my $length = delete $args{length};
	my $width = delete $args{width};
	my $height = delete $args{height};
	$height = 5 unless defined $height;
	
	my $self = bless
    { 
        length => $length,
        width  => $width,
        height  => $height,
    }, $class; 
    return $self; 
	
	
	/*
	my ($class, $args) = @_; 
    my $self = bless
    { 
        length => $args->{length},
        width  => $args->{width},
        height  => $args->{height},
    }, $class; 
    return $self; 
	*/
}


sub get_volume {
	
	my $self = shift;

	my $volume = $self->{length} * $self->{width} * $self->{height};
	
	return $volume;	

}
1;

