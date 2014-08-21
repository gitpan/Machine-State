# Machine::State::Transition Hook Failure Class
package Machine::State::Failure::Transition::Hook;

use Bubblegum;
use Function::Parameters;
use Moose;

extends 'Machine::State::Failure::Transition';

our $VERSION = '0.02'; # VERSION

has hook_name => (
    is       => 'ro',
    isa      => 'Str',
    required => 0,
);

method _build_message {
    "Transition hooking failure."
}

1;
