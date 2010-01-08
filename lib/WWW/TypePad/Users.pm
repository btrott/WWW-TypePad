package WWW::TypePad::Users;
use strict;
use Any::Moose;
extends 'WWW::TypePad::Noun';

sub prefix { '/users' }

sub elsewhere_accounts {
    my $api = shift;
    my $id  = shift;
    $api->_call($id, 'elsewhere-accounts', undef, undef, @_);
}

sub events {
    my $api = shift;
    my $id  = shift;
    $api->_call($id, 'events', undef, undef, @_);
}

sub favorites {
    my $api = shift;
    my $id  = shift;
    $api->_call($id, 'favorites', undef, undef, @_);
}

sub follower_relationships {
    my $api = shift;
    my $id  = shift;
    $api->_call($id, 'relationships', 'follower', undef, @_);
}

sub following_relationships {
    my $api = shift;
    my $id  = shift;
    $api->_call($id, 'relationships', 'following', undef, @_);
}

sub get {
    my $api = shift;
    my $id  = shift;
    $api->_call($id);
}

sub memberships {
    my $api = shift;
    my $id  = shift;
    $api->_call($id, 'memberships', undef, undef, @_);
}

sub notifications {
    my $api = shift;
    my $id  = shift;
    $api->_call($id, 'notifications', undef, undef, @_);
}

# aliases

sub followers { shift->follower_relationships(@_) }
sub following { shift->following_relationships(@_) }

1;
