# Machine::State Transition Failure Class
package Machine::State::Failure::Transition;

use Bubblegum;
use Function::Parameters;
use Machine::State::Transition;
use Moose;

extends 'Machine::State::Failure';

our $VERSION = '0.01'; # VERSION

has transition => (
    is       => 'ro',
    isa      => 'Machine::State::Transition',
    required => 1
);

1;
