# Machine::State Failure Class
package Machine::State::Failure;

use Bubblegum;
use Class::Forward;
use Devel::StackTrace;
use Function::Parameters;
use Moose;

use Data::Dumper ();
use Scalar::Util ();

use Bubblegum::Constraints -minimal;
use Class::Load 'load_class';
use overload bool => sub {1}, '""' => 'as_string', fallback => 1;

our $VERSION = '0.01'; # VERSION

has file => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

has line => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

has message => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

has package => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

has stacktrace => (
    is      => 'ro',
    isa      => 'Devel::StackTrace',
    default => sub { Devel::StackTrace->new }
);

has subroutine => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

has verbose => (
    is      => 'rw',
    isa      => 'Int',
    default => 0
);

sub throw {
    my $class = shift;
    my %args  = @_ == 1 ? (message => $_[0]) : @_;

    $args{subroutine} = (caller(1))[3];
    ($args{package}, $args{file}, $args{line}) = caller(0);

    $args{message} = "An unknown error occurred in class ($args{package})"
        unless defined $args{message} && $args{message} ne '';

    die $class->new(%args);
}

sub rethrow {
    die shift;
}

method as_string {
    my $output = '%s at %s line %s';
    my @params = ($self->message, $self->file, $self->line);

    if ($self->verbose) {
        $output .= ":\n\n%s";
        push @params, $self->stacktrace->as_string;
    }

    return sprintf $output, @params;
}

method dump {
    local $Data::Dumper::Terse = 1;
    return Data::Dumper::Dumper($self);
}

sub caught {
    my($class, $e) = @_;
    return if ref $class;
    return unless Scalar::Util::blessed($e) && UNIVERSAL::isa($e, $class);
    return $e;
}

sub raise {
    my ($class, %args) = @_;
    shift && unshift @_, my $goto = clsf _string $args{class};
    load_class($goto) && goto $goto->can('throw');
}

1;
