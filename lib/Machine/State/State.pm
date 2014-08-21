# ABSTRACT: State Machine State Class
package Machine::State::State;

use Bubblegum;
use Function::Parameters;
use Machine::State::Failure::Transition::Unknown;
use Machine::State::Transition;
use Moose;
use Try::Tiny;

our $VERSION = '0.02'; # VERSION

has 'name' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

has 'next' => (
    is       => 'rw',
    isa      => 'Str',
    required => 0
);

has 'transitions' => (
    is      => 'ro',
    isa     => 'HashRef',
    default => sub {{}}
);

method add_transition {
    my $trans = pop;
    my $name  = shift;

    if ($trans->isa('Machine::State::Transition')) {
        $name //= $trans->name;
        $self->transitions->set($name => $trans);
        return $trans;
    }

    # transition not found
    Machine::State::Failure::Transition::Unknown->throw(
        transition_name => $name,
    );
}

method remove_transition {
    my $name = shift;

    if ($self->transitions->get($name->asa_string)) {
        return $self->transitions->delete($name);
    }

    # transition not found
    Machine::State::Failure::Transition::Unknown->throw(
        transition_name => $name,
    );
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Machine::State::State - State Machine State Class

=head1 VERSION

version 0.02

=head1 SYNOPSIS

    use Machine::State::State;

    my $state = Machine::State::State->new(
        name => 'sleep',
        next => 'resume'
    );

=head1 DESCRIPTION

Machine::State::State represents a state and it's transitions.

=head1 ATTRIBUTES

=head2 name

    my $name = $state->name;
    $name = $state->name('inspired');

The name of the state. The value can be any scalar value.

=head2 next

    my $transition_name = $state->next;
    $transition_name = $state->next('create_art');

The name of the next transition. The value can be any scalar value. This value
is used in automating the transition from one state to the next.

=head2 transitions

    my $transitions = $state->transitions;

The transitions attribute contains the collection of transitions the state can
apply. The C<add_transition> and C<remove_transition> methods should be used to
configure state transitions.

=head1 METHODS

=head2 add_transition

    $trans = $state->add_transition(Machine::State::Transition->new(...));
    $state->add_transition(name => Machine::State::Transition->new(...));

The add_transition method registers a new transition in the transitions
collection. The method requires a L<Machine::State::Transition> object.

=head2 remove_transition

    $trans = $state->remove_transition('transition_name');

The remove_transition method removes a pre-defined transition from the
transitions collection. The method requires a transition name.

=encoding utf8

=head1 AUTHOR

Al Newkirk <anewkirk@ana.io>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Al Newkirk.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
