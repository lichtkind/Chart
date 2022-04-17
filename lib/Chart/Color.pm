
# Chart::Color: read only color holding object 
#               with methods for relation, mixing and transitions

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
                @args = (length $_[0] == 4 ) 
                      ? (map { hex($_.$_) } unpack( "a1 a1 a1 a1", $_[0]) )[1..3] 
                      : (map { hex($_   ) } unpack( "a1 a2 a2 a2", $_[0]) )[1..3];
                return carp "'$_[0]' color definition has not length of 3 or 6 hex characters" unless @args == 3;
            } else {
                @args = Chart::Color::Named::rgbhsl_from_name( $_[0] );
                return carp "'$_[0]' is an unknown color name" unless @args == 6;
                return bless [@args, scalar Chart::Color::Value::name_from_rgb( @args[0..2] )];
            }
        } else {return carp $help }

    }
    my $args = (@args == 3 )                               # resolve args into a hash
             ? {'r' => $args[0], 'g' => $args[1], 'b' => $args[2] }                         # from positional 
             : { lc(substr($args[0],0,1)) => $args[1], 
                 lc(substr($args[2],0,1)) => $args[3],
                 lc(substr($args[4],0,1)) => $args[5]  }; # from named
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

__END__

=pod

=head1 NAME

Chart::Color - read only single color holding objects

=head1 SYNOPSIS 


=head1 DESCRIPTION

This module is designed for internal usage. It handles all of users color
definitions done with method "$chart->set({...})". But its educational,
(even for the casual user), to see which formats are allowed to define
colors. (see next chapter)

=head1 CONSTRUCTOR

Attention: when defining a color via "$chart->set( {background => $c});",
$c is a place holder for a scalar. Any multi value options displayed here
are not available there.

=head2 new('name')

Get a color by providing a name from the X11 or HTML (SVG) standard or
a Pantone report. Upper/camel case will be treated as lower case and
also inserted underscore letters ('_') will be ignored as perl does in
numbers (1_0000 == 1000).

    my $color = Chart::Color->new('Emerald');
    my @names = Chart::Color::Value::all_names(); # select from these

=head2 new('#rgb')

Color definitions in "web format" are also acceptable.

    my $color = Chart::Color->new('#FF0000');
    my $color = Chart::Color->new('#F00');   # works too


=head2 new($r, $g, $b)

Triplet of integer RGB values (red green and blue : 0 .. 255)

    my $red = Chart::Color->new( 255, 0, 0 );
    my $red = Chart::Color->new([255, 0, 0]); # does the same


=head2 new(r => $r, g => $g, b => $b)

Hash with the keys 'r', 'g' and 'b' does the same as above,
only more declarative. Again, casing will be normalised and only
first letter of each key is significant.

    my $red = Chart::Color->new( r => 255, g => 0, b => 0 );
    my $red = Chart::Color->new({r => 255, g => 0, b => 0}); # works too
    ... Color->new( Red => 255, Green => 0, Blue => 0);      # also fine

=head2 new(h => $h, s => $s, l => $l)

To define a color in HSL space use the following keys. Otherwise,
same rules apply as in previous paragraph.

    my $red = Chart::Color->new( h =>   0, s => 100, b => 50 );
    my $red = Chart::Color->new({h =>   0, s => 100, b => 50}); # good too
    ... ->new( Hue => 0, Saturation => 100, Lightness => 50 ); # also fine


=head1 GETTER / ATTRIBUTES

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

Creates a related color (Chart::Color object).


=head2 complementary

Creates a set of complementary colors. Imagine a circle in HSL space 
around the center. The saturation of $self defines the radius. This 
circle will be divided in $n (first argument) equal partitions defining
$n equal distanced colors.

If a second argument $l is set, the circle will be tilted, so that
the lightness on the opposite pole of $self would have the lightness
$self->lightness + $l. That means $l can also be negative.


=head2 gradient

Creates a gradient between current and a second, given color.

The first argument is that color. Either as an Chart::Color object or 
a reference to data which is acceptable to the method new. 

Second argument is the number of colors in that gradient (series of colors
that together are a the transition from $self to first argument). If left
out it defaults to one. In that case you get a color that is a mix
between the two.

Third argument is also a number ($n) which again defaults to one.
It defines the dynamics of the transition between the two colors.
In case $n == 1 you get a linear transition, meaning the distance in HSL
space is from one color to the next is equal. In any case: the function
$x ** $n defines the transition speed. For values $n > 1 the transition
starts by sticking to $self (with small distances from color to color)
slowly getting faster (gibber steps) and faster. 
Values $n < 1 do the opposite: starting by moving fast (big distances
from color to next) becoming slower and slower.


=head1 COPYRIGHT & LICENSE

Copyright 2022 Herbert Breunung.

This program is free software; you can redistribute it and/or modify it 
under same terms as Perl itself.

=head1 AUTHOR

Herbert Breunung, <lichtkind@cpan.org>

=cut

