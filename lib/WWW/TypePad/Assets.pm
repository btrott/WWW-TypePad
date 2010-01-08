package WWW::TypePad::Assets;
use strict;

use Any::Moose;
extends 'WWW::TypePad::Noun';

sub prefix { '/assets' }

sub get {
    my $api = shift;
    my $id  = shift;
    return $api->_call($id);
}

sub comments {
    my $api = shift;
    my $id  = shift;
    $api->_call($id, 'comments', undef, undef, @_);
}

sub favorites {
    my $api = shift;
    my $id  = shift;
    $api->_call($id, 'favorites', undef, undef, @_);
}

1;
