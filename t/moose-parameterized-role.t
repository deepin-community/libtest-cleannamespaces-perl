use strict;
use warnings;

use Test::More 0.88;
BEGIN {
    plan skip_all => 'skipping for regular installs, due to possible circular dependency issues'
        unless $ENV{AUTHOR_TESTING} || $ENV{AUTOMATED_TESTING};
}

use Test::Needs { 'Moose' => 0, 'MooseX::Role::Parameterized' => 0 };

use if $ENV{AUTHOR_TESTING}, 'Test::Warnings';
use Test::Deep;
use Module::Runtime 'require_module';
use Test::CleanNamespaces;

use lib 't/lib';

foreach my $package (qw(MooseyParameterizedRole MooseyParameterizedComposer))
{
    require_module($package);
    cmp_deeply(
        Test::CleanNamespaces::_remaining_imports($package),
        {},
        $package . ' has a clean namespace',
    );

    ok($package->can($_), "can do $package->$_") foreach @{ $package->CAN };
    ok(!$package->can($_), "cannot do $package->$_") foreach @{ $package->CANT };
}

done_testing;
