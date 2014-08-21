# Machine::State::Transition Execution Failure Class
package Machine::State::Failure::Transition::Execution;

use Bubblegum;
use Function::Parameters;
use Moose;

extends 'Machine::State::Failure::Transition';

our $VERSION = '0.04'; # VERSION

has 'captured' => (
    is       => 'ro',
    isa      => 'Defined',
    required => 1
);

method _build_message {
    "Transition execution failure."
}

1;
