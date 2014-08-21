# Machine::State::Transition Unknown Failure Class
package Machine::State::Failure::Transition::Unknown;

use Bubblegum;
use Function::Parameters;
use Moose;

extends 'Machine::State::Failure::Transition';

our $VERSION = '0.03'; # VERSION

method _build_message {
    "Transition unknown."
}

1;
