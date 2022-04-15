
# Chart::Color: read only color holding object 
#               with methods for mixing and relation

use v5.12;

package Chart::Color;
our $VERSION = '2.402.0';

use Chart::Color::Value;
use Carp;

sub new {
    my ($pkg) = shift;
    return 'constructor of Chart::Color object needs 3 arguments in named form'.
           ' e.g.: ->new(r => 255, g => 0, b => 0), ->new(h => 0, s => 1, l => .5)'.
           ' or as positionals e.g.: ->new(255, 0, 0), in hex form "#FF00" or a color name.'
           unless @_ == 6 or @_ == 3 or @_ == 1;
    my @args = @_;
    if (@args == 1){ # retrieve values of named color
        if    (ref $_[0] eq 'ARRAY') { @args = @{$_[0]} }  # resolve new([$r, $g, $b])
        elsif (ref $_[0] eq 'HASH')  { @args = %{$_[0]} }  # resolve new({r => $r, g => $g, b => $b})
        elsif (not ref $_[0]) {                            # resolve stored color names
            if (substr(ref $_[0], 0, 1) eq '#'){
                @args =  (map { hex($_) } unpack( "a1 a2 a2 a2", $_[0] ))[1..3];
                return "'$_[0]' color definition has not length of 6 hex characters" unless @args == 3;
            } else {
                @args = Chart::Color::Named::rgbhsl_from_name( $_[0] );
                return "'$_[0]' is an unknown color name" unless @args == 6;
                return bless [@args, scalar Chart::Color::Value::name_from_rgb( @args[0..2] )];
            }
        } else {return 'unknown argument format, try new($r, $g, $b) or new( h => $h, s => $s, l => $l)' }

    }
    my $args = (@args == 3 )                               # resolve args into a hash
             ? {'r' => $args[0], 'g' => $args[1], 'b' => $args[2] }                         # from positional 
             : {lc($args[0]) => $args[1], lc($args[2]) => $args[3], lc($args[4]) => $args[5] }; # from named
    my ($self, @rest);
    # compute missing rgb or hsl values
    if      (exists $args->{'r'} and exists $args->{'g'} and exists $args->{'b'}) {
        @rest = Chart::Color::Value::hsl_from_rgb( @$args{qw/r g b/} );
        return "RGB values are out of range" if @rest < 3;
        $self = [@$args{qw/r g b/}, @rest];
    } elsif (exists $args->{'h'} and exists $args->{'s'} and exists $args->{'l'}) {
        @rest = Chart::Color::Value::rgb_from_hsl( @$args{qw/h s l/} );
        return "HSL values are out of range" if @rest < 3;
        $self = [@rest, @$args{qw/h s l/}];
    } else { return "argument keys need to be r, g and b or h, s and l (Uppercase works too)" }
    $self->[6] = Chart::Color::Value::name_from_rgb( rgb($self) ) // '';
    bless $self;
}

sub red         { $_[0][0] }
sub green       { $_[0][1] }
sub blue        { $_[0][2] }
sub hue         { $_[0][3] }
sub saturation  { $_[0][4] }
sub lightness   { $_[0][5] }
sub name        { $_[0][6] }

sub rgb     { @{$_[0]}[0 .. 2] }
sub rgb_hex { sprintf "#%02x%02x%02x", $_[0]->rgb() }
sub hsl     { @{$_[0]}[3 .. 5] }
# hue 0..360 degree, S in %, L in %  as int
# sub hsl_web { (int(.5 +($_[0][3] * 360)), int(.5+($_[0][4]*100)), int(.5+($_[0][5]*100))) } 
# sub hsl_float { (int(.5 +($_[0][3] * 360)), int(.5+($_[0][4]*100)), int(.5+($_[0][5]*100))) } 


sub distance_hsl {
    my ($self, @color) = @_;
    return "missing second argument: color object or color definition" unless @color;
    my $color = (ref $color[0] eq __PACKAGE__) ? $color[0] : Chart::Color->new(@color);
    return $color unless ref $color eq __PACKAGE__;
    sqrt(($self->hue - $color->hue) ** 2 + 
         ($self->saturation - $color->saturation) ** 2 + 
         ($self->lightness - $color->lightness) ** 2); 
}

sub distance_rgb {
    my ($self, @color) = @_;
    return "missing second argument: color object or color definition" unless @color;
    my $color = (ref $color[0] eq __PACKAGE__) ? $color[0] : Chart::Color->new(@color);
    return $color unless ref $color eq __PACKAGE__;
    sqrt(($self->red - $color->red) ** 2 + 
         ($self->green - $color->green) ** 2 + 
         ($self->blue - $color->blue) ** 2); 
}

sub add {
    my ($self, @color) = @_;
    return "missing second argument: color object or color definition" unless @color;
    my $color = (ref $color[0] eq __PACKAGE__) ? $color[0] : Chart::Color->new(@color);
    return $color unless ref $color eq __PACKAGE__;
    ###
}
sub _add {
}


sub mix {
    my ($self, $steps, @color) = @_;
    return "missing first argument: number of gradient steps" unless $steps;
    return "missing second argument: color object or color definition" unless @color;
    my $color = (ref $color[0] eq __PACKAGE__) ? $color[0] : Chart::Color->new(@color);
    return $color unless ref $color eq __PACKAGE__;
    
    ###
}
sub gradient {
    my ($self, $steps, @color) = @_;
    return "missing first argument: number of gradient steps" unless $steps;
    return "missing second argument: color object or color definition" unless @color;
    my $color = (ref $color[0] eq __PACKAGE__) ? $color[0] : Chart::Color->new(@color);
    return $color unless ref $color eq __PACKAGE__;
    
    ###
}


1;

=pod

=head1 NAME

Chart::Color - read only color defining objects

=head1 SYNOPSIS 

Handles all of users color definitions done with method "$chart->set(...)".
Mostly for internal usage.

=head1 DESCRIPTION

This module is supposed to be used by Chart::Color and not directly
for the most part, but allows expansion of the store.
It allows also reverse search from RGB values to name.

=head1 METHODS

=head2 new

=head1 ATTRIBUTES

are all read only

=head2 red

=head2 green

=head2 blue

=head2 hue

=head2 saturation

=head2 lightness

=head2 name

=head2 rgb

=head2 rgb_hex

=head2 hsl

=head2 hsl_web



=head1 METHODS

=head2 add

Adding a new color definition unter an unused name. 
Arguments are name, red value, green value and blue value.

    Chart::Color::Named::add('nightblue', 15, 10, 121);

=head2 rgb

Return the red green and blue value oof the named color.

    my @rgb = Chart::Color::Named::rgb('darkblue');
    @rgb = Chart::Color::Named::rgb('dark_blue'); # same result
    @rgb = Chart::Color::Named::rgb('DarkBlue');  # still same

=head2 name

When several names defined the same color, the shortest name will be returned.

    say Chart::Color::Named::name(15, 10, 121);  # 'darkblue'


=head2 name_taken

A perlish pseudo boolean tell if the color name is already in use.

=head2 all_names

A sorted list of all stored color names.

=head1 COPYRIGHT & LICENSE

Copyright 2022 Herbert Breunung.

This program is free software; you can redistribute it and/or modify it 
under same terms as Perl itself.

=head1 AUTHOR

Herbert Breunung, <lichtkind@cpan.org>

=cut

