# Machine::State::Transition Execution Failure Class
package Machine::State::Failure::Transition::Execution;

use Bubblegum;
use Function::Parameters;
use Moose;

extends 'Machine::State::Failure::Transition';

our $VERSION = '0.03'; # VERSION

method _build_message {
    "Transition execution failure."
}

1;
