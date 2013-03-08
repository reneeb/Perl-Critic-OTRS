package Perl::Critic::Policy::OTRS::ProhibitLocaltime;

use strict;
use warnings;

use Perl::Critic::Utils qw{ :severities :classification :ppi };
use base 'Perl::Critic::Policy';

use Readonly;

our $VERSION = '0.01';

Readonly::Scalar my $DESC => q{Use of "localtime" is not allowed};
Readonly::Scalar my $EXPL => q{Use methods of TimeObject instead.};

sub supported_parameters { return; }
sub default_severity     { return $SEVERITY_HIGHEST; }
sub default_themes       { return qw( otrs ) }
sub applies_to           { return 'PPI::Token::Word'  }

sub violates {
    my ( $self, $elem ) = @_;

    return if $elem ne 'localtime';
    return $self->violation( $DESC, $EXPL, $elem );
}

1;
