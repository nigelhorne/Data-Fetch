use strict;
use warnings;
use Test::Most;
use Data::Fetch;

{
	package Dummy;
	sub new     { bless { id => $_[1] }, shift }
	sub slow    { my ($self, $arg) = @_; sleep 0.1; $arg //= 0; return "OK:$arg:".$self->{id} }
	sub array   { my ($self) = @_; return ($self->{id}, $self->{id} + 1) }
}

my $fetch = Data::Fetch->new();

# Prime many values and get in a different order
my @objs = map { Dummy->new($_) } 1 .. 5;
foreach my $i (0..$#objs) {
	$fetch->prime(object => $objs[$i], message => 'slow', arg => $i);
}

# Call get in reverse order
foreach my $i (reverse 0..$#objs) {
	my $result = $fetch->get(object => $objs[$i], message => 'slow', arg => $i);
	is($result, "OK:$i:".($i+1), "get() in reverse order matches expected");
}

# Stress test with repeated calls
my $obj = Dummy->new(99);
for (1..10) {
	$fetch->prime(object => $obj, message => 'slow', arg => $_);
	my $result = $fetch->get(object => $obj, message => 'slow', arg => $_);
	is($result, "OK:$_:99", "Repeated call $_ passed");
}

# Calling get() without prime, then prime — should cache on first get()
my $o2 = Dummy->new(42);
my $val1 = $fetch->get(object => $o2, message => 'slow', arg => 'first');
is($val1, 'OK:first:42', "get() without prime works");

# Try to prime after get — should NOT run again, but should error (if you check for that)
throws_ok {
	$fetch->prime(object => $o2, message => 'slow', arg => 'first');
} qr/prime twice/, "Can't prime after get()";

# Try get() repeatedly — should reuse cached value
my $val2 = $fetch->get(object => $o2, message => 'slow', arg => 'first');
is($val2, $val1, "Repeated get() returns same cached value");

# Prime and get in list context
my $listobj = Dummy->new(55);
$fetch->prime(object => $listobj, message => 'array', wantarray => 1);
my @vals = $fetch->get(object => $listobj, message => 'array');
is_deeply(\@vals, [55, 56], "List context get() returns array");

done_testing();
