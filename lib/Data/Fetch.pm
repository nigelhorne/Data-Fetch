package Data::Fetch;

use strict;
use warnings;
use threads;

our $VERSION = '0.01';

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;

	return unless(defined($class));

	return bless {}, $class;
}

sub prime {
	my $self = shift;
	my %args = (ref($_[0]) eq 'HASH') ? %{$_[0]} : @_;

	return unless($args{'object'} && $args{'message'});

	my $object = $args{'object'} . '->' . $args{'message'};

	if($self->{values}->{$object}) {
		return;
	}
	$self->{values}->{$object}->{thread} = threads->create(sub {
		my $o = $args{'object'};
		my $m = $args{'message'};
		$self->{values}->{$object}->{value} = eval '$o->$m()';
		die $@ if $@;
		return $self->{values}->{$object}->{value};
	});
}

sub get {
	my $self = shift;
	my %args = (ref($_[0]) eq 'HASH') ? %{$_[0]} : @_;

	return unless($args{'object'} && $args{'message'});

	my $object = $args{'object'} . '->' . $args{'message'};

	if($self->{values}->{$object}->{value}) {
		return $self->{values}->{$object}->{value};
	}
	if($self->{values}->{$object}->{thread}) {
		my $rc = $self->{values}->{$object}->{thread}->join();
		delete $self->{values}->{$object}->{thread};
		return $self->{values}->{$object}->{value} = $rc;
	}
	die "Need to prime before getting";
}

1;
