package Perl::Critic::Policy::OTRS::RequireCamelCase;

use strict;
use warnings;

use Perl::Critic::Utils qw{ :severities :classification :ppi };
use base 'Perl::Critic::Policy';

use Readonly;

our $VERSION = '0.01';

Readonly::Scalar my $DESC => q{Variable, subroutine, and package names have to be in CamelCase};
Readonly::Scalar my $EXPL => q{};

sub supported_parameters { return; }
sub default_severity     { return $SEVERITY_HIGHEST; }
sub default_themes       { return qw( otrs ) }

my %dispatcher = (
    'PPI::Statement::Sub'     => \&_is_camelcase,
    'PPI::Statement::Package' => \&_is_camelcase,
    'PPI::Token::Symbol'      => \&_variable_is_camelcase,
);

sub applies_to { 
    keys %dispatcher,
}

sub violates {
    my ( $self, $elem ) = @_;
    
    my $ref = ref $elem;
    my $sub = $dispatcher{$ref};
    return if !$sub;
    
    my $success = $self->$sub( $elem );
    
    return if $success;
    return $self->violation( $DESC, $EXPL, $elem );
}

sub _is_camelcase {
    my ( $self, $elem ) = @_;
    
    my $words = $elem->find( 'PPI::Token::Word' );
    my $name  = $words->[1];
    
    if ( $elem->isa( 'PPI::Statement::Sub' ) and $name eq 'new' ) {
        return 1;
    }
    elsif ( $elem->isa( 'PPI::Statement::Package' ) and $name eq 'main' ) {
        return 1;
    }
    elsif ( $elem->isa( 'PPI::Statement::Package' ) and $name =~ m{ Language :: [a-z]{2,3}_ }xms ) {
        return 1;
    }
    
    return 1 if !$name;
    
    my $is_camelcase = !( $name !~ m{ \A [A-Z][a-z]* }xms || $name =~ m{ _ }xms );
    
    return $is_camelcase;
}

sub _variable_is_camelcase {
    my ( $self, $elem ) = @_;
    
    my $name = "$elem";
    
    my $is_camelcase = !( $name !~ m{ \A [\*\@\$\%][A-Z][a-z]* }xms || $name =~ m{ _ }xms );
    
    return $is_camelcase;
}

1;