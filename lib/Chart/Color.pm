
# Chart::Color: read only color holding object 
#               with methods for mixing and relation

use v5.12;

package Chart::Color;
our $VERSION = '2.402.0';

use Carp;
use Chart::Color::Value;

sub new {
    my $help = 'constructor of Chart::Color object needs 3 arguments in named form'.
        ' e.g.: ->new(r => 255, g => 0, b => 0), ->new(h => 0, s => 100, l => 50)'.
        ' or rgb as positionals e.g.: ->new(255, 0, 0), in hex form "#FF0000" or a color name ("red").';
    my ($pkg) = shift;
    return carp $help unless @_ == 6 or @_ == 3 or @_ == 1;
    my @args = @_;
    if (@args == 1){ # retrieve values of named color
        if    (ref $_[0] eq 'ARRAY') { @args = @{$_[0]} }  # resolve new([$r, $g, $b])
        elsif (ref $_[0] eq 'HASH')  { @args = %{$_[0]} }  # resolve new({r => $r, g => $g, b => $b})
        elsif (not ref $_[0]) {                            # resolve stored color names
            if (substr(ref $_[0], 0, 1) eq '#'){
                @args =  (map { hex($_) } unpack( "a1 a2 a2 a2", $_[0] ))[1..3];
                return carp "'$_[0]' color definition has not length of 6 hex characters" unless @args == 3;
            } else {
                @args = Chart::Color::Named::rgbhsl_from_name( $_[0] );
                return carp "'$_[0]' is an unknown color name" unless @args == 6;
                return bless [@args, scalar Chart::Color::Value::name_from_rgb( @args[0..2] )];
            }
        } else {return carp $help }

    }
    my $args = (@args == 3 )                               # resolve args into a hash
             ? {'r' => $args[0], 'g' => $args[1], 'b' => $args[2] }                         # from positional 
             : {lc($args[0]) => $args[1], lc($args[2]) => $args[3], lc($args[4]) => $args[5] }; # from named
    my ($self, @rest);
    # compute missing rgb or hsl values
    if      (exists $args->{'r'} and exists $args->{'g'} and exists $args->{'b'}) {
        @rest = Chart::Color::Value::hsl_from_rgb( @$args{qw/r g b/} );
        return carp "RGB values are out of range" if @rest < 3;
        $self = [@$args{qw/r g b/}, @rest];
    } elsif (exists $args->{'h'} and exists $args->{'s'} and exists $args->{'l'}) {
        @rest = Chart::Color::Value::rgb_from_hsl( @$args{qw/h s l/} );
        return carp "HSL values are out of range" if @rest < 3;
        $self = [@rest, @$args{qw/h s l/}];
    } else { return carp "argument keys need to be r, g and b or h, s and l (Uppercase works too)" }
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

sub hsl         { @{$_[0]}[3 .. 5] }
sub rgb         { @{$_[0]}[0 .. 2] }
sub rgb_hex     { sprintf "#%02x%02x%02x", $_[0]->rgb() }

sub distance_hsl {
    my ($self, @color) = @_;
    return croak "missing argument: color object or color definition" unless @color;
    my $color = (ref $color[0] eq __PACKAGE__) ? $color[0] : Chart::Color->new(@color);
    return unless ref $color eq __PACKAGE__;
    Chart::Color::Value::distance_hsl( [$self->hsl], [$color->hsl] );
}

sub distance_rgb {
    my ($self, @color) = @_;
    return croak "missing argument: color object or color definition" unless @color;
    my $color = (ref $color[0] eq __PACKAGE__) ? $color[0] : Chart::Color->new(@color);
    return unless ref $color eq __PACKAGE__;
    Chart::Color::Value::distance_rgb( [$self->rgb], [$color->rgb] );
}

sub add {
    my ($self, @color) = @_;
    return "missing second argument: color object or color definition" unless @color;
    my $color = (ref $color[0] eq __PACKAGE__) ? $color[0] : Chart::Color->new(@color);
    return unless ref $color eq __PACKAGE__;
    ###
}
sub _add {
}


sub complementary {
    my ($self) = shift;
    my ($count) = shift // 1;
    
}

sub mix {
    my ($self, $steps, @color) = @_;
    return "missing first argument: number of gradient steps" unless $steps;
    return "missing second argument: color object or color definition" unless @color;
    my $color = (ref $color[0] eq __PACKAGE__) ? $color[0] : Chart::Color->new(@color);
    return unless ref $color eq __PACKAGE__;
    
    ###
}
sub gradient {
    my ($self, $steps, @color) = @_;
    return "missing first argument: number of gradient steps" unless $steps;
    return "missing second argument: color object or color definition" unless @color;
    my $color = (ref $color[0] eq __PACKAGE__) ? $color[0] : Chart::Color->new(@color);
    return unless ref $color eq __PACKAGE__;
    
    ###
}


1;

=pod

=head1 NAME

Chart::Color - read only single color holding objects

=head1 SYNOPSIS 


=head1 DESCRIPTION

This module is designed for internal usage. It handles all of users color
definitions done with method "$chart->set({...})". So its even for the
casual user educational, which formats of color definition are allowed.
(see next chapter)

=head1 CONSTRUCTOR

=head2 new('name')

=head2 new('#rgb')

=head2 new($r, $g, $b)

=head2 new(r => $r, g => $g, b => $b)

=head2 new(h => $h, s => $s, l => $l)

=head1 ATTRIBUTES/GETTER

are all read only.

=head2 red

Integer between 0 .. 255 describing the red part in RGB space.

=head2 green

Integer between 0 .. 255 describing the green part in RGB space.

=head2 blue

Integer between 0 .. 255 describing the green part in RGB space.

=head2 rgb

Triplet of the red green and blue values (see above).

=head2 rgb_hex

String starting with '#', followed by six hexadecimal figures. 
Two digits for each of red gree and blue value, is its common in CSS.

=head2 hue

Integer between 0 .. 359 describing the hue angle (in degrees) in HSL space.

=head2 saturation

Integer between 0 .. 100 describing percentage of saturation part in HSL space.

=head2 lightness

Integer between 0 .. 100 describing percentage of lightness part in HSL space.

=head2 hsl

Triplet with the hue, saturation and lightness values (see above).

=head2 rgbhsl

Sixtupel with the rgb and hsl values (see above).

=head2 name

Name of the color in the X11 or HTML (SVG) standard or the Pantone report.
The name will be found and filled in, even when the object is created
with RGB or HSL values. If its not found in any of the mentioned standards,
it returns an empty string.


=head1 METHODS

=head2 add

=head2 complementary

=head2 gradient





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

