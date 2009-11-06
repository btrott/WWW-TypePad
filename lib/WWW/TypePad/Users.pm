package WWW::TypePad::Users;
use strict;

use Any::Moose;

has 'base' => ( is => 'rw', isa => 'WWW::TypePad' );

sub events {
    my $api = shift;
    my( $user_id ) = @_;
    return $api->base->call(
        GET => '/users/' . $user_id . '/events.json'
    );
}

sub notifications {
    my $api = shift;
    my( $user_id, $qs ) = @_;
    return $api->base->call(
        GET => '/users/' . $user_id . '/notifications.json' => $qs
    );
}

1;