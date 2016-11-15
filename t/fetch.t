#!perl -wT

use strict;
use warnings;
use Test::Most tests => 19;
use Test::NoWarnings;

BEGIN {
	use_ok('Data::Fetch');
}

FETCH: {
	my $simple = Data::Value->new(1);
	my $fetch = new_ok('Data::Fetch');
	$fetch->prime(object => $simple, message => 'get');
	ok($fetch->get(object => $simple, message => 'get') == 1);
	ok($fetch->get(object => $simple, message => 'get') == 1);

	$simple = Data::Value->new(2);
	$fetch = new_ok('Data::Fetch');
	$fetch->prime(object => $simple, message => 'get');
	ok($fetch->get(object => $simple, message => 'get') == 2);
	$fetch->prime(object => $simple, message => 'get');
	ok($fetch->get(object => $simple, message => 'get') == 2);
	ok($fetch->get(object => $simple, message => 'get') == 2);
	$simple->set(22);
	ok($simple->get() == 22);
	ok($fetch->get(object => $simple, message => 'get') == 2);	# Values are "cached"

	$fetch = new_ok('Data::Fetch');
	$simple = Data::Value->new(3);
	$fetch->prime(object => $simple, message => 'get', arg => 'prefix');
	ok($fetch->get(object => $simple, message => 'get', arg => 'prefix') eq 'prefix: 3');
	ok($fetch->get(object => $simple, message => 'get') eq 'prefix: 3');

	$fetch = new_ok('Data::Fetch');
	$simple = Data::Value->new(4);
	$fetch->prime(object => $simple, message => 'get', arg => 'prefix');

	$fetch = new_ok('Data::Fetch');
	$simple = Data::Value->new(5);
	$simple->set(55);
	$fetch->prime(object => $simple, message => 'get');
	ok($fetch->get(object => $simple, message => 'get') == 55);

	$fetch = new_ok('Data::Fetch');
	$simple = Data::Value->new(6);
	eval {
		$fetch->get(object => $simple, message => 'get');
	};
	ok($@ =~ /Need to prime before getting/);
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
	my $arg = shift;

	if($arg) {
		return "$arg: $self->{value}";
	}
	return $self->{value};
}

sub set {
	my $self = shift;
	my $arg = shift;

	$self->{value} = $arg;
}


1;
