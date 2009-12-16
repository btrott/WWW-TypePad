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

        $api->_oauth( Net::OAuth::Simple::AuthHeader->new(
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
    return $api->call_anon( GET => '/api-keys/' . $key . '.json' );
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
	return $api->_call(0, @_);
}

sub call_anon {
	my $api = shift;
	return $api->_call(1, @_);
}

sub _call {
    my $api = shift;
    my( $anon, $method, $uri, $qs ) = @_;
    unless ( $uri =~ /^http/ ) {
        $uri = $api->uri_for( $uri );
    }
    if ( $qs ) {
        $uri = URI->new( $uri );
        $uri->query_form( $qs );
    }
    my $res;
    if ( $api->access_token && !$anon ) {
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

package Net::OAuth::Simple::AuthHeader;
# we need Net::OAuth::Simple to make requests with the OAuth credentials
# in an Authorization header, as required by the API, rather than the query string

use base qw( Net::OAuth::Simple );

sub _make_request {
    my $self    = shift;

    my $class   = shift;
    my $url     = shift;
    my $method  = lc(shift);
    my %extra   = @_;

    my $uri   = URI->new($url);
    my %query = $uri->query_form;
    $uri->query_form({});

    my $request = $class->new(
        consumer_key     => $self->consumer_key,
        consumer_secret  => $self->consumer_secret,
        request_url      => $uri,
        request_method   => uc($method),
        signature_method => $self->signature_method,
        protocol_version => $self->oauth_1_0a ? Net::OAuth::PROTOCOL_VERSION_1_0A : Net::OAuth::PROTOCOL_VERSION_1_0,
        timestamp        => time,
        nonce            => $self->_nonce,
        extra_params     => \%query,
        %extra,
    );
    $request->sign;
    die "COULDN'T VERIFY! Check OAuth parameters.\n"
      unless $request->verify;

    # divergence from the original _make_request starts here
    my $request_url = URI->new($url);
    my $response    = $self->{browser}->$method($request_url, 'Authorization' => $request->to_authorization_header);
    die "$method on $request_url failed: ".$response->status_line
      unless ( $response->is_success );

    return $response;
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
