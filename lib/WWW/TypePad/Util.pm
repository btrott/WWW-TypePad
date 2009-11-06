package WWW::TypePad::Util;
use strict;

use List::Util qw( first );

sub l {
    my( $links, $rel ) = @_;
    my $item = first { $_->{rel} eq $rel } @$links;
    return $item ? $item->{href} : undef;
}

1;