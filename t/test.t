#!perl -wT

use strict;
use warnings;
use Test::Most tests => 7;
use Test::NoWarnings;

BEGIN {
	use_ok('Data::Fetch');
}

FETCH: {
	my $simple = Data::Value->new(1);
	my $fetch = Data::Fetch->new();
	$fetch->prime(object => $simple, message => 'get');
	ok($fetch->get(object => $simple, message => 'get') == 1);
	ok($fetch->get(object => $simple, message => 'get') == 1);

	$simple = Data::Value->new(2);
	$fetch = Data::Fetch->new();
	$fetch->prime(object => $simple, message => 'get');
	ok($fetch->get(object => $simple, message => 'get') == 2);
	$fetch->prime(object => $simple, message => 'get');
	ok($fetch->get(object => $simple, message => 'get') == 2);
	ok($fetch->get(object => $simple, message => 'get') == 2);
}

package Data::Value;

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;

	return unless(defined($class));

	return bless { value => shift }, $class;
}

sub get {
	my $self = shift;
	return $self->{value};
}

1;
