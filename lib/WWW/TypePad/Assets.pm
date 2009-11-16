package WWW::TypePad::Assets;
use strict;

use Any::Moose;

has 'base' => ( is => 'rw', isa => 'WWW::TypePad' );

sub get {
    my $api = shift;
    my( $asset_id ) = @_;
    return $api->base->call(
        GET => '/assets/' . $asset_id . '.json'
    );
}

sub comments {
    my $api = shift;
    my( $asset_id ) = @_;
    return $api->base->call(
        GET => '/assets/' . $asset_id . '/comments.json'
    );
}

sub favorites {
    my $api = shift;
    my( $asset_id ) = @_;
    return $api->base->call(
        GET => '/assets/' . $asset_id . '/favorites.json'
    );
}

1;