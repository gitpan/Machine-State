# ABSTRACT: State::Machine Implementation à la Moose
package Machine::State;

use Bubblegum;
use Function::Parameters;
use Machine::State::Failure::Transition::Execution;
use Machine::State::Failure::Transition::Missing;
use Machine::State::Failure::Transition::Unknown;
use Moose;
use Try::Tiny;

our $VERSION = '0.05'; # VERSION

has 'state' => (
    is       => 'rw',
    isa      => 'Machine::State::State',
    required => 1
);

has 'topic' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

method apply {
    my $state = $self->state;
    my $next  = $self->next;

    # cannot transition
    Machine::State::Failure::Transition::Missing->throw
        unless $next->isa_string;

    # find transition
    if (my $trans = $state->transitions->get($next)) {
        try {
            # attempt transition
            $self->state($trans->execute($state, @_));
        }
        catch {
            # transition execution failure
            Machine::State::Failure::Transition::Execution->throw(
                captured          => $_,
                transition_name   => $next,
                transition_object => $trans,
            );
        }
    }
    else {
        # transition unknown
        Machine::State::Failure::Transition::Unknown->throw(
            transition_name => $next
        );
    }

    return $self->state;
};

method next {
    my $state = $self->state;
    my $next  = shift // $state->next;

    if ($state && !$next) {
        # deduce transition unless defined
        if ($state->transitions->keys->count == 1) {
            $next = $state->transitions->keys->get(0);
        }
    }

    return $next;
}

method status {
    return $self->state->name;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Machine::State - State::Machine Implementation Ã  la Moose

=head1 VERSION

version 0.05

=head1 SYNOPSIS

    use Machine::State;
    use Machine::State::State;
    use Machine::State::Transition;

    # light-switch circular-state example

    my $is_on  = Machine::State::State->new(name => 'is_on');
    my $is_off = Machine::State::State->new(name => 'is_off');

    my $turn_on  = Machine::State::Transition->new(
        name   => 'turn_on',
        result => $is_on
    );
    my $turn_off = Machine::State::Transition->new(
        name   => 'turn_off',
        result => $is_off
    );

    $is_on->add_transition($turn_off); # on -> turn off
    $is_off->add_transition($turn_on); # off -> turn on

    my $lightswitch = Machine::State->new(
        topic => 'typical light switch',
        state => $is_off
    );

    $lightswitch->apply('turn_on');
    $lightswitch->status; # is_on

=head1 DESCRIPTION

A finite-state machine (FSM) or finite-state automaton (plural: automata), or
simply a state machine, is an abstract machine that can be in one of a finite
number of states. The machine is in only one state at a time. It can change from
one state to another when initiated by a triggering event or condition; this is
called a transition. Machine::State is a system for creating state machines and
managing their transitions; It is also a great mechanism for enforcing and
tracking workflow, especially in distributed computing. This library is a
Moose-based implementation of the L<Machine::State> library.

State machines are useful for modeling systems with perform a predetermined
sequence of event and result in deterministic state. Machine::State, as you
might expect, allows for the definition of events, states, state transitions
and user defined actions that can be executed before or after transitions. All
features of the state machine itself can be configured via a DSL,
L<Machine::State::Simple>. B<Note: This is an early release available for
testing and feedback and as such is subject to change.>

=head1 ATTRIBUTES

=head2 state

    my $state = $machine->state;
    $state = $machine->state(Machine::State::State->new(...));

The current state of the state machine. The value should be a
L<Machine::State::State> object.

=head2 topic

    my $topic = $machine->topic;
    $topic = $machine->topic('Take over the world');

The topic or purpose of the state machine. The value can be any arbitrary
string describing intent.

=head1 METHODS

=head2 apply

    my $state = $machine->apply('transition_name');
    $state = $machine->apply; # apply known next transition

The apply method transitions the state machine from the current state into the
resulting state. If the apply method is called without a transition name, the
machine will transition into the next known state of the current state.

=head2 next

    my $transition_name = $machine->next;

The next method returns the name of the next known transition of the current
state if exists, otherwise it will return undefined.

=head2 status

    my $state_name = $machine->status;

The status method returns the name of the current state.

=head1 AUTHOR

Al Newkirk <anewkirk@ana.io>

=head1 CONTRIBUTOR

=for stopwords Сергей Романов

Сергей Романов <sromanov-dev@yandex.ru>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Al Newkirk.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
