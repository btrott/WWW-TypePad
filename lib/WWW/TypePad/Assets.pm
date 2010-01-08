package WWW::TypePad::Assets;
### BEGIN auto-generated
### This is an automatically generated code, do not edit!
### Scroll down to look for END to add additional methods

use strict;
use Any::Moose;
extends 'WWW::TypePad::Noun';

sub prefix { '/assets' }

sub get {
    my $api = shift;
    my $id  = shift;
    $api->_call($id);
}

sub favorites {
    my $api = shift;
    my $id  = shift;
    $api->_call($id, 'favorites', undef, undef, @_);
}

sub comments {
    my $api = shift;
    my $id  = shift;
    $api->_call($id, 'comments', undef, undef, @_);
}


### END auto-generated




1;
