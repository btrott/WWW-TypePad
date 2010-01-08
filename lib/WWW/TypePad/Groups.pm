package WWW::TypePad::Groups;
use strict;

use Any::Moose;
extends 'WWW::TypePad::Noun';

sub prefix { '/groups' }

sub get {
    my $api = shift;
    my $id  = shift;
    $api->_call($id);
}

sub events {
    my $api = shift;
    my $id  = shift;
    $api->_call($id, 'events', undef, undef, @_);
}

1;
