package helper;
use strict;
use warnings FATAL => 'all';

sub IsValidMessageSize {
    my $length = @_;
    print "The message length is $length";
    return 1 if $length <= 144;
    return 0;
}

1;