# Machine::State Transition Failure Class
package Machine::State::Failure::Transition;

use Bubblegum;
use Function::Parameters;
use Moose;

extends 'Machine::State::Failure';

our $VERSION = '0.05'; # VERSION

has transition_name => (
    is       => 'ro',
    isa      => 'Str',
    required => 0
);

has transition_object => (
    is       => 'ro',
    isa      => 'Machine::State::Transition',
    required => 0
);

1;
