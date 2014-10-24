# Machine::State::Simple Config Failure Class
package Machine::State::Failure::Simple;

use Bubblegum;
use Function::Parameters;
use Moose;

extends 'Machine::State::Failure';

our $VERSION = '0.05'; # VERSION

has config => (
    is       => 'ro',
    isa      => 'ArrayRef',
    required => 1
);

1;
