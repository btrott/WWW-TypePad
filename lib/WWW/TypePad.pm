package WWW::TypePad;
use strict;
use 5.008_001;

our $VERSION = '0.01';

use Any::Moose;
use JSON qw( decode_json );
use LWP::UserAgent;
use Net::OAuth::Simple;
use WWW::TypePad::Assets;
use WWW::TypePad::Error;
use WWW::TypePad::Users;
use WWW::TypePad::Util;

has 'consumer_key' => ( is => 'rw' );
has 'consumer_secret' => ( is => 'rw' );
has 'access_token' => ( is => 'rw' );
has 'access_token_secret' => ( is => 'rw' );
has 'host' => ( is => 'rw', default => 'api.typepad.com' );
has '_oauth' => ( is => 'rw' );

sub oauth {
    my $api = shift;
    unless ( defined $api->_oauth ) {
        my $apikey = $api->get_apikey( $api->consumer_key );
        my $links = $apikey->{owner}{links};

        $api->_oauth( Net::OAuth::Simple->new(
            tokens => {
                consumer_key          => $api->consumer_key,
                consumer_secret       => $api->consumer_secret,
                access_token          => $api->access_token,
                access_token_secret   => $api->access_token_secret,
            },
            urls => {
                authorization_url   => WWW::TypePad::Util::l( $links, 'oauth-authorization-page' ),
                request_token_url   => WWW::TypePad::Util::l( $links, 'oauth-request-token-endpoint' ),
                access_token_url    => WWW::TypePad::Util::l( $links, 'oauth-access-token-endpoint' ),
            },
        ) );
    }
    return $api->_oauth;
}

sub get_apikey {
    my $api = shift;
    my( $key ) = @_;
    return $api->call( GET => '/api-keys/' . $key . '.json' );
}

sub uri_for {
    my $api = shift;
    my( $path ) = @_;
    return 'http://' . $api->host . $path;
}

sub assets {
    my $api = shift;
    return WWW::TypePad::Assets->new( { base => $api } );
}

sub users {
    my $api = shift;
    return WWW::TypePad::Users->new( { base => $api } );
}

sub call {
    my $api = shift;
    my( $method, $uri, $qs ) = @_;
    unless ( $uri =~ /^http/ ) {
        $uri = $api->uri_for( $uri );
    }
    if ( $qs ) {
        $uri = URI->new( $uri );
        $uri->query_form( $qs );
    }
    my $res;
    if ( $api->access_token ) {
        $uri =~ s/^http:/https:/;
        $res = $api->oauth->make_restricted_request( $uri, $method );
    } else {
        my $ua = LWP::UserAgent->new;
        my $req = HTTP::Request->new( $method => $uri );
        $res = $ua->request( $req );
    }

    unless ( $res->is_success ) {
        WWW::TypePad::Error::HTTP->throw( $res->code, $res->message );
    }

    return decode_json( $res->content );
}

1;
__END__

=encoding utf-8

=for stopwords

=head1 NAME

WWW::TypePad - Client for the TypePad Platform

=head1 SYNOPSIS

    use WWW::TypePad;
    my $tp = WWW::TypePad->new;

=head1 DESCRIPTION

WWW::TypePad is a Perl library implementing an interface to the TypePad
API platform.

=head1 AUTHOR

Benjamin Trott E<lt>ben@sixapart.comE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
