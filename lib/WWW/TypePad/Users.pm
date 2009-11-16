package WWW::TypePad::Users;
use strict;

use Any::Moose;

has 'base' => ( is => 'rw', isa => 'WWW::TypePad' );

sub elsewhere_accounts {
    my $api = shift;
    my( $user_id ) = @_;
    return $api->base->call(
        GET => '/users/' . $user_id . '/elsewhere-accounts.json'
    );
}

sub events {
    my $api = shift;
    my( $user_id ) = @_;
    return $api->base->call(
        GET => '/users/' . $user_id . '/events.json'
    );
}

sub favorites {
    my $api = shift;
    my( $user_id ) = @_;
    return $api->base->call(
        GET => '/users/' . $user_id . '/favorites.json'
    );
}

sub followers {
    my $api = shift;
    my( $user_id, $qs ) = @_;
    return $api->base->call(
        GET => '/users/' . $user_id . '/relationships/@follower.json' => $qs
    );
}

sub following {
    my $api = shift;
    my( $user_id, $qs ) = @_;
    return $api->base->call(
        GET => '/users/' . $user_id . '/relationships/@following.json' => $qs
    );
}

sub get {
    my $api = shift;
    my( $user_id ) = @_;
    return $api->base->call(
        GET => '/users/' . $user_id . '.json'
    );
}

sub memberships {
    my $api = shift;
    my( $user_id, $qs ) = @_;
    return $api->base->call(
        GET => '/users/' . $user_id . '/memberships.json' => $qs
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