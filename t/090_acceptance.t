#!perl

use strict;
use warnings;

use Data::Dumper;
use Data::JSONSchema::Ajv;
use Test::More;

# This file was inspired by:
# http://cpansearch.perl.org/src/JHTHORSEN/JSON-Validator-0.85/t/acceptance.t

plan skip_all => 'cpanm Test::JSON::Schema::Acceptance'
    unless eval 'use Test::JSON::Schema::Acceptance; 1';

my $ajv = Data::JSONSchema::Ajv->new( undef, { convert_boolean => 1 } );

my $accepter = Test::JSON::Schema::Acceptance->new(4);
my $json     = JSON->new->allow_nonref;
$accepter->acceptance(
    sub {
        my ( $schema, $payload ) = @_;
        $payload = $json->decode($payload);

        my $validator = $ajv->make_validator($schema);
        my @errors    = $validator->validate($payload);
        note( Dumper( \@errors ) ) if @errors;

        return @errors ? 0 : 1;
    },
    { skip_tests => [qw/ref/] }
);

done_testing();
