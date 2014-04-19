use strict;
use warnings;

use Test::More;
use Machine::State::State;
use Machine::State::Transition;

my $class = 'Machine::State::Transition';
can_ok $class => qw(hooks name result);

my $trans1 = eval { $class->new };
ok !$trans1 && $@, '$trans1 missing required arguments';

my $trans2 = eval { $class->new(name => 'perform') };
ok !$trans2 && $@, '$trans2 missing required arguments';

my $trans3 = $class->new(
    name   => 'perform',
    result => Machine::State::State->new(name => 'performed')
);
is $trans3->name, 'perform', '$trans3 instantiated';
is 'HASH', ref $trans3->hooks, '$trans3 has default hooks';

ok 1 and done_testing;
