# Machine::State::Transition Missing Failure Class
package Machine::State::Failure::Transition::Missing;

use Bubblegum;
use Function::Parameters;
use Moose;

extends 'Machine::State::Failure::Transition';

our $VERSION = '0.05'; # VERSION

method _build_message {
    "Transition missing."
}

1;
