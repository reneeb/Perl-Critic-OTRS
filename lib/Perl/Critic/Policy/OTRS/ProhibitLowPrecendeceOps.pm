package Perl::Critic::Policy::OTRS::ProhibitLowPrecendeceOps;

use strict;
use warnings;

use Perl::Critic::Utils qw{ :severities :classification :ppi };
use base 'Perl::Critic::Policy';

use Readonly;

our $VERSION = '0.01';

Readonly::Scalar my $DESC => q{Use of low precedence operators is not allowed};
Readonly::Scalar my $EXPL => q{Replace low precedence operators with the high precedence substitutes};

my %lowprecendece = (
  not => '!',
  and => '&&',
  or  => '||',
);

sub supported_parameters { return; }
sub default_severity     { return $SEVERITY_HIGHEST; }
sub default_themes       { return qw( otrs ) }
sub applies_to           { return 'PPI::Token::Operator'  }

sub violates {
    my ( $self, $elem ) = @_;

    return if !grep{ $elem eq $_ }keys %lowprecendece;
    return $self->violation( $DESC, $EXPL, $elem );
}

1;
__END__
=pod

=head1 NAME

Perl::Critic::Policy::OTRS::ProhibitLowPrecendeceOps

=head1 VERSION

version 0.02

=head1 AUTHOR

Renee Baecker <module@renee-baecker.de>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2010 by Renee Baecker.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut