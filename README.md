# Data::Fetch

Give advance warning that you'll be needing a value

# VERSION

Version 0.01

# SYNOPSIS

Sometimes we know in advance that we'll be needing a value which is going to take a long time to compute or determine.
This module fetches the value in the background so that you don't need to wait so long when you need the value

    use Data::Fetch;
    my $fetcher = Data::Fetch->new();
    my $object = CalculatePi->new(places => 1000000);
    $fetcher->prime(object => $object, message => get);
    # Do other things
    print $fetcher->get(object => $object, message => get), "\n";

# SUBROUTINES/METHODS

## new

Creates a Data::Fetch object.  Takes no argument.

## prime

Say what is is you'll be needing later.  Takes two mandatory parameters:

object - the object you'll be sending the message to
message - the message you'll be sending

## prime

Retrieve get a value you've primed.  Takes two mandatory parameters:

object - the object you'll be sending the message to
message - the message you'll be sending

# AUTHOR

Nigel Horne, `<njh at bandsman.co.uk>`

# BUGS

Can't give arguments to the message.

Please report any bugs or feature requests to `bug-data-fetch at rt.cpan.org`,
or through the web interface at
[http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Data-Fetch](http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Data-Fetch).
I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

# SEE ALSO

# SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Data::Fetch

You can also look for information at:

- RT: CPAN's request tracker

    [http://rt.cpan.org/NoAuth/Bugs.html?Dist=Data-Fetch](http://rt.cpan.org/NoAuth/Bugs.html?Dist=Data-Fetch)

- AnnoCPAN: Annotated CPAN documentation

    [http://annocpan.org/dist/Data-Fetch](http://annocpan.org/dist/Data-Fetch)

- CPAN Ratings

    [http://cpanratings.perl.org/d/Data-Fetch](http://cpanratings.perl.org/d/Data-Fetch)

- Search CPAN

    [http://search.cpan.org/dist/Data-Fetch/](http://search.cpan.org/dist/Data-Fetch/)

# LICENSE AND COPYRIGHT

Copyright 2016 Nigel Horne.

This program is released under the following licence: GPL
