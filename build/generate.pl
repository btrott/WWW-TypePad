#!/usr/bin/perl
use strict;
use Template;
use JSON;

my $json  = do { open my $fh, "<", "nouns.json" or die $!; join '', <$fh> };
my $nouns = decode_json($json);

for my $entry (@{$nouns->{entries}}) {
    handle_noun($entry);
}

sub handle_noun {
    my $noun = shift;

    my $name = camelize($noun->{name});
    my $file = "lib/WWW/TypePad/$name.pm";
    rewrite_file($noun, $name, $file);
}

sub rewrite_file {
    my($noun, $package, $file) = @_;

    my $content = slurp($file) || stub_for($package);
    $content =~ s/### BEGIN auto-generated.*### END auto-generated/generate_code($package, $noun)/egs
        or return warn "$file: auto-generated code marked was not found.\n";

    warn "Writing $file\n";
    open my $fh, ">", $file or die "$file: $!";
    print $fh $content;
}

sub generate_code {
    my($package, $noun) = @_;

    my $stash = {
        package => $package,
        noun => $noun,
        safe => sub { $_[0] =~ tr/-/_/; $_[0] },
    };

    my $tt = Template->new;
    $tt->process(\<<'TEMPLATE', $stash, \my $output) or die $tt->error;
### BEGIN auto-generated
### This is an automatically generated code, do not edit!
### Scroll down to look for END to add additional methods

use strict;
use Any::Moose;
extends 'WWW::TypePad::Noun';

sub prefix { '/[% noun.name %]' }

sub get {
    my $api = shift;
    my $id  = shift;
    $api->_call($id);
}

[% FOREACH property IN noun.propertyEndpoints;
   SET filters = property.filterEndpoints;
   CALL filters.unshift(0) -%]
[% FOREACH filter IN filters -%]
[% IF filter && filter.parameterized -%]
sub [% safe(property.name) %]_[% safe(filter.name) %] {
[% ELSIF filter -%]
sub [% safe(filter.name) %]_[% safe(property.name) %] {
[% ELSE -%]
sub [% safe(property.name) %] {
[% END # IF -%]
    my $api = shift;
    my $id  = shift;
    $api->_call($id, '[% property.name %]', [% IF filter %]'[% safe(filter.name) %]'[% ELSE %]undef[% END %], [% UNLESS filter && filter.parameterized %]undef, [% END %][% IF property.resourceObjectType.properties.size %]@_[% END %]);
}

[% END # FOREACH filter -%]
[% END # FOREACH property -%]

### END auto-generated
TEMPLATE

    return $output;
}

sub slurp {
    my $file = shift;
    open my $fh, "<", $file or return;
    join '', <$fh>;
}

sub stub_for {
    my $package = shift;
    return "package WWW::TypePad::$package;\n### BEGIN auto-generated\n\n### END auto-generated\n\n1;\n";
}

sub camelize {
    my $name = shift;
    $name =~ s/-([a-z])/\u$1/g;
    return ucfirst $name;
}


