package WWW::TypePad::Groups;
use strict;

use Any::Moose;

has 'base' => ( is => 'rw', isa => 'WWW::TypePad' );

sub events {
    my $api = shift;
    my( $group_id ) = @_;
    return $api->base->call(
        GET => '/groups/' . $group_id . '/events.json'
    );
}

sub get {
    my $api = shift;
    my( $group_id ) = @_;
    return $api->base->call(
        GET => '/groups/' . $group_id . '.json'
    );
}

1;
