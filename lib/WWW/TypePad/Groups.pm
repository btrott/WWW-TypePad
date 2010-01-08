package WWW::TypePad::Groups;
### BEGIN auto-generated
### This is an automatically generated code, do not edit!
### Scroll down to look for END to add additional methods

use strict;
use Any::Moose;
extends 'WWW::TypePad::Noun';

sub prefix { '/groups' }

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

sub admin_memberships {
    my $api = shift;
    my $id  = shift;
    $api->_call($id, 'memberships', 'admin', undef, @_);
}

sub member_memberships {
    my $api = shift;
    my $id  = shift;
    $api->_call($id, 'memberships', 'member', undef, @_);
}

sub events {
    my $api = shift;
    my $id  = shift;
    $api->_call($id, 'events', undef, undef, @_);
}

sub photo_assets {
    my $api = shift;
    my $id  = shift;
    $api->_call($id, 'photo-assets', undef, undef, @_);
}

sub video_assets {
    my $api = shift;
    my $id  = shift;
    $api->_call($id, 'video-assets', undef, undef, @_);
}

sub post_assets {
    my $api = shift;
    my $id  = shift;
    $api->_call($id, 'post-assets', undef, undef, @_);
}

sub link_assets {
    my $api = shift;
    my $id  = shift;
    $api->_call($id, 'link-assets', undef, undef, @_);
}


### END auto-generated




1;
