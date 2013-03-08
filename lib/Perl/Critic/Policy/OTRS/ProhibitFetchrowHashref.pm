package Perl::Critic::Policy::OTRS::ProhibitFetchrowHashref;

use strict;
use warnings;

use Perl::Critic::Utils qw{ :severities :classification :ppi };
use base 'Perl::Critic::Policy';

use Readonly;

our $VERSION = '0.01';

Readonly::Scalar my $DESC => q{Method FetchrowHashref() is deprecated.};
Readonly::Scalar my $EXPL => q{Use other methods of DBObject instead. FetchrowHashref() does not work on all database systems};

sub supported_parameters { return; }
sub default_severity     { return $SEVERITY_HIGHEST; }
sub default_themes       { return qw( otrs ) }
sub applies_to           { return 'PPI::Token::Operator' }

sub violates {
    my ( $self, $elem ) = @_;

    return if $elem ne '->';

    my $method = $elem->snext_sibling;
    return if $method ne 'FetchrowHashref';

    return $self->violation( $DESC, $EXPL, $elem );
}

1;
