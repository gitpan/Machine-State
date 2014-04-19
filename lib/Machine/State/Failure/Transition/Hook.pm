# Machine::State::Transition Hook Failure Class
package Machine::State::Failure::Transition::Hook;

use Bubblegum;
use Function::Parameters;
use Moose;

extends 'Machine::State::Failure::Transition';

our $VERSION = '0.01'; # VERSION

has hook => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

1;
