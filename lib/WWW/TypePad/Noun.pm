package WWW::TypePad::Noun;
use strict;
use Any::Moose;

has 'base' => ( is => 'rw', isa => 'WWW::TypePad' );

sub _endpoint {
    my $api = shift;
    my($object_id, $noun, $filter, $filter_arg) = @_;

    my $path = $api->prefix . "/$object_id";
    $path .= "/$noun"        if $noun;
    $path .= "/\@$filter"    if $filter;
    $path .= "/$filter_arg"  if $filter_arg;
    $path .= ".json";

    return $path;
}

sub _call {
    my $api = shift;
    my($id, $noun, $filter, $filter_arg, @rest) = @_;
    my $path = $api->_endpoint($id, $noun, $filter, $filter_arg);
    return $api->base->call(GET => $path, @rest);
}

1;
