package Data::Fetch;

use 5.12.0;	# Threads before that are apparently not good
use strict;
use warnings;
use threads;

=head1 NAME

Data::Fetch - give advance warning that you'll be needing a value

=head1 VERSION

Version 0.02

=cut

our $VERSION = '0.02';

=head1 SYNOPSIS

Sometimes we know in advance that we'll be needing a value which is going to take a long time to compute or determine.
This module fetches the value in the background so that you don't need to wait so long when you need the value.

    use CalculatePi;
    use Data::Fetch;
    my $fetcher = Data::Fetch->new();
    my $pi = CalculatePi->new(places => 1000000);
    $fetcher->prime(object => $pi, message => 'as_string');	# Warn we'll run $pi->as_string() in the future
    # Do other things
    print $fetcher->get(object => $pi, message => 'as_string'), "\n";	# Runs $pi->as_string()

=head1 SUBROUTINES/METHODS

=head2 new

Creates a Data::Fetch object.  Takes no argument.

=cut

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;

	return unless(defined($class));

	return bless {}, $class;
}

=head2 prime

Say what is is you'll be needing later.  Takes two mandatory parameters:

    object - the object you'll be sending the message to
    message - the message you'll be sending

=cut

sub prime {
	my $self = shift;
	my %args = (ref($_[0]) eq 'HASH') ? %{$_[0]} : @_;

	return unless($args{'object'} && $args{'message'});

	my $object = $args{'object'} . '->' . $args{'message'};

	if($self->{values}->{$object}) {
		return $self;
	}
	$self->{values}->{$object}->{thread} = threads->create(sub {
		my $o = $args{'object'};
		my $m = $args{'message'};
		$self->{values}->{$object}->{value} = eval '$o->$m()';
		die $@ if $@;
		return $self->{values}->{$object}->{value};
	});

	return $self;	# Easily prime lots of values in one call
}

=head2 get

Retrieve get a value you've primed.  Takes two mandatory parameters:

    object - the object you'll be sending the message to
    message - the message you'll be sending

=cut

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

=head1 AUTHOR

Nigel Horne, C<< <njh at bandsman.co.uk> >>

=head1 BUGS

Can't give arguments to the message.

Changing a value between prime and get will not necessarily get you the data you want. That's the way it works
and isn't going to change.

If you change a value between two calls of get(), the earlier value is always used.  This is definitely a feature
not a bug.

Please report any bugs or feature requests to C<bug-data-fetch at rt.cpan.org>,
or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Data-Fetch>.
I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SEE ALSO

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Data::Fetch

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Data-Fetch>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Data-Fetch>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Data-Fetch>

=item * Search CPAN

L<http://search.cpan.org/dist/Data-Fetch/>

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2016 Nigel Horne.

This program is released under the following licence: GPL

=cut

1; # End of Data::Fetch
