package DataFlow::Proc::DPath;

use strict;
use warnings;

# ABSTRACT: some abstract here

# VERSION

use Moose;
extends 'DataFlow::Proc';

use namespace::autoclean;

use Data::DPath;
use MooseX::Aliases;

has 'search_dpath' => (
    'is'       => 'ro',
    'isa'      => 'Str',
    'required' => 1,
    'alias'    => 'dpath',
);

has '_dpath' => (
    'is'      => 'ro',
    'isa'     => 'Data::DPath',
    'lazy'    => 1,
    'default' => sub {
        return $_[0]->returns_refs
          ? dpathr( $_[0]->search_dpath )
          : dpath( $_[0]->search_dpath );
    },
);

has 'returns_refs' => (
    'is'      => 'ro',
    'isa'     => 'Bool',
    'lazy'    => 1,
    'default' => 0,
);

sub _build_p {
    my $self = shift;

    return sub { $self->_dpath->match($_) };
}

__PACKAGE__->meta->make_immutable;

1;

