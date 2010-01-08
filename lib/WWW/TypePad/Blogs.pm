package WWW::TypePad::Blogs;
### BEGIN auto-generated
### This is an automatically generated code, do not edit!
### Scroll down to look for END to add additional methods

use strict;
use Any::Moose;
extends 'WWW::TypePad::Noun';

sub prefix { '/blogs' }

sub get {
    my $api = shift;
    my $id  = shift;
    $api->_call($id);
}

sub post_by_email_settings {
    my $api = shift;
    my $id  = shift;
    $api->_call($id, 'post-by-email-settings', undef, undef, @_);
}

sub post_by_email_settings_by_user {
    my $api = shift;
    my $id  = shift;
    $api->_call($id, 'post-by-email-settings', 'by_user', @_);
}

sub stats {
    my $api = shift;
    my $id  = shift;
    $api->_call($id, 'stats', undef, undef, );
}

sub page_assets {
    my $api = shift;
    my $id  = shift;
    $api->_call($id, 'page-assets', undef, undef, @_);
}

sub post_assets {
    my $api = shift;
    my $id  = shift;
    $api->_call($id, 'post-assets', undef, undef, @_);
}

sub published_post_assets {
    my $api = shift;
    my $id  = shift;
    $api->_call($id, 'post-assets', 'published', undef, @_);
}


### END auto-generated




1;
