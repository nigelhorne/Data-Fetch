# Generated from Makefile.PL using makefilepl2cpanfile

requires 'perl', '5.12.0';

requires 'Scalar::Util';
requires 'threads';

on 'test' => sub {
	requires 'Test::CleanNamespaces';
	requires 'Test::DescribeMe';
	requires 'Test::Kwalitee';
	requires 'Test::Most';
	requires 'Test::Needs';
	requires 'Test::NoWarnings';
	requires 'Test::Warn';
};
on 'develop' => sub {
	requires 'Devel::Cover';
	requires 'Perl::Critic';
	requires 'Test::Pod';
	requires 'Test::Pod::Coverage';
};
