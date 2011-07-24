package DataFlow::Proc::DPath;

use strict;
use warnings;

# ABSTRACT: A processor that filters parts of data structures

# VERSION

use Moose;
extends 'DataFlow::Proc';

use namespace::autoclean;

use Data::DPath qw{dpath dpathr};

has 'search_dpath' => (
    'is'       => 'ro',
    'isa'      => 'Str',
    'required' => 1,
);

has 'references' => (
    'is'      => 'ro',
    'isa'     => 'Bool',
    'default' => 0,
);

sub _policy { return 'ScalarOnly' }

sub _make_dpath {
    my $self = shift;
    return $self->references
      ? dpathr( $self->search_dpath )
      : dpath( $self->search_dpath );
}

sub _build_p {
    my $self = shift;
    return sub { return $self->_make_dpath->match($_) };
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=head1 SYNOPSIS

  use DataFlow::Proc::DPath;
  my $proc =
    DataFlow::Proc::DPath->new( search_dpath => '//*[key =~ /potatoes/]' );

  @result = $proc->process($data);   # some complex data structure

  # Or, more commonly

  use DataFlow;

  my $flow = DataFlow->new([
    # ...
	[ DPath => search_dpath => '//*[key =~ /potatoes/]' ],
    # ...
  ]);

  @result = $flow->process($data);

=head1 DESCRIPTION

This processor provides a filter for Perl data structures using the
L<Data::DPath> module. Items will B<always> be treated as scalars (it is
likely they will be references to more complex structures, but
nonetheless, scalars) and the result will B<always> be an array, with zero
or more elements.

Use the C<references> attribute if you want to receive references to the
filtered-down content (perhaps you would like to modify only a part of the
data structure).

=attr search_dpath

The path expression used by the L<Data::DPath> functions.

=attr references

This attribute is a boolean, and it signals whether the result list should
have references into the data structure or simple copies. The default is 0
(false).

=cut

