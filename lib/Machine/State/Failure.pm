# Machine::State Failure Class
package Machine::State::Failure;

use Function::Parameters;
use Moose;

extends 'Throwable::Error';

our $VERSION = '0.04'; # VERSION

has 'message' => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    builder => '_build_message',
);

method _build_message {
    "An unexpected failure has occurred"
}

1;
