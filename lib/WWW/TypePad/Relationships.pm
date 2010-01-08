package WWW::TypePad::Relationships;
### BEGIN auto-generated
### This is an automatically generated code, do not edit!
### Scroll down to look for END to add additional methods

use strict;
use Any::Moose;
extends 'WWW::TypePad::Noun';

sub prefix { '/relationships' }

sub get {
    my $api = shift;
    my $id  = shift;
    $api->_call($id);
}

sub status {
    my $api = shift;
    my $id  = shift;
    $api->_call($id, 'status', undef, undef, );
}


### END auto-generated




1;
