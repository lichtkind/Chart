
# Chart::Color: read only color holding object 
#               with methods for relation, mixing and transitions

use v5.12;

package Chart::Color;
our $VERSION = '2.402.0';

use Carp;
use Chart::Color::Value;

sub new {
    my $help = 'constructor of Chart::Color needs 3 named arguments either as RGB or HSL '.
        ' e.g.: ->new( r => 255, g => 0, b => 0 ), ->new({ h => 0, s => 100, l => 50 })'.
        ' or RGB as positionals e.g.: ->new( 255, 0, 0 ), or one string that defines a color'.
        'in hex form "#FF0000" or as a name e.g."red".';
    my ($pkg, @args) = @_;
    if (@args == 1){ # resolve 'color_name' or '#RRGGBB' or [$r, $g, $b] -> ($r, $g, $b)
        if (not ref $args[0]){
            @args = _rgb_from_name_or_hex($args[0]);
            return unless @args == 3;
        } elsif (ref $args[0] eq 'ARRAY') {
            @args = @{$args[0]};
        }
    } elsif (@args == 6){                   # resolve (k1 => v1, k2 => v2, k3 => v3) -> { k1 => v1, ... }
        @args = ({ $args[0] => $args[1], $args[2] => $args[3], $args[4] => $args[5] });
    }
    if (@args == 3) {                                         # resolve ($r, $g, $b) -> { r => $r, ... }
        @args = { r => $args[0], g => $args[1], b => $args[2] }; 
    }
    return carp $help unless @args == 1 and ref $args[0] eq 'HASH' and keys( %{$args[0]} ) == 3;
    
    my %named_arg = map {_shrink_key($_) =>  $args[0]{$_}} keys( %{$args[0]} ); # clean keys

    my (@rgb, @hsl);
    if      (exists $named_arg{'r'} and exists $named_arg{'g'} and exists $named_arg{'b'}) {
        @rgb = Chart::Color::Value::trim_rgb(@named_arg{qw/r g b/});
        @hsl = Chart::Color::Value::hsl_from_rgb( @rgb );
    } elsif (exists $named_arg{'h'} and exists $named_arg{'s'} and exists $named_arg{'l'}) {
        @hsl = Chart::Color::Value::trim_hsl( @named_arg{qw/h s l/});
        @rgb = Chart::Color::Value::rgb_from_hsl( @hsl );
    } else { return carp "argument keys need to be r, g and b or h, s and l (long names and upper case work too!)" }
    bless [@rgb, @hsl, Chart::Color::Value::name_from_rgb( @rgb )];
}
sub _rgb_from_name_or_hex {
    my $name = shift;
    if (substr($name, 0, 1) eq '#'){                # resolve #RRGGBB -> ($r, $g, $b)
        my $c = substr $name, 1;
        return carp "color definition '$c' has not length of 3 or 6 hex characters" unless length($c) == 6 or length($c) == 3;
        return (length $c == 3) ? (map { hex($_.$_) } unpack( "a1 a1 a1", $c)) 
                                : (map { hex($_   ) } unpack( "a2 a2 a2", $c));
    } else {                                        # resolve name -> ($r, $g, $b)
        my @rgb = Chart::Color::Value::rgb_from_name( $name );
        return carp "'$name' is an unknown color name" unless @rgb == 3;
        return @rgb;
    }
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

sub distance {
    my ($self, $c2, $metric) = @_;
    return croak "missing argument: color object or scalar color definition" unless defined $c2;
    $c2 = (ref $c2 eq __PACKAGE__) ? $c2 : Chart::Color->new( $c2 );
    return unless ref $c2 eq __PACKAGE__;
    
    return Chart::Color::Value::distance_hsl( [$self->hsl], [$c2->hsl] ) unless defined $metric;
    $metric = lc $metric;
    return Chart::Color::Value::distance_hsl( [$self->hsl], [$c2->hsl] ) if $metric eq 'hsl';
    return Chart::Color::Value::distance_rgb( [$self->rgb], [$c2->rgb] ) if $metric eq 'rgb';
    my @delta_rgb = Chart::Color::Value::difference_rgb( [$self->rgb], [$c2->rgb] );
    my @delta_hsl = Chart::Color::Value::difference_hsl( [$self->hsl], [$c2->hsl] );
    my $help = "unknown distance metric: $metric. try r, g, b, rg, rb, gb, rgb, h, s, l, hs, hl, sl, hsl (default).";
    if (length $metric == 2){
        if    ($metric eq 'hs' or $metric eq 'sh') {return sqrt( $delta_hsl[0] ** 2 + $delta_hsl[1] ** 2 )}
        elsif ($metric eq 'hl' or $metric eq 'lh') {return sqrt( $delta_hsl[0] ** 2 + $delta_hsl[2] ** 2 )}
        elsif ($metric eq 'sl' or $metric eq 'ls') {return sqrt( $delta_hsl[1] ** 2 + $delta_hsl[2] ** 2 )}
        elsif ($metric eq 'rg' or $metric eq 'gr') {return sqrt( $delta_rgb[0] ** 2 + $delta_rgb[1] ** 2 )}
        elsif ($metric eq 'rb' or $metric eq 'br') {return sqrt( $delta_rgb[0] ** 2 + $delta_rgb[2] ** 2 )}
        elsif ($metric eq 'gb' or $metric eq 'bg') {return sqrt( $delta_rgb[1] ** 2 + $delta_rgb[2] ** 2 )}
    }
    $metric = substr $metric, 0, 1;
    $metric eq 'h' ? $delta_hsl[0] :
    $metric eq 's' ? $delta_hsl[1] :
    $metric eq 'l' ? $delta_hsl[2] :
    $metric eq 'r' ? $delta_rgb[0] :
    $metric eq 'g' ? $delta_rgb[1] :
    $metric eq 'b' ? $delta_rgb[2] : croak $help;
}

sub add {
    my ($self, @args) = @_;
    my $help = 'Chart::Color->add argument options: 1. a color object with optional factor as second arg, '.
        '2. a color name as string, 3. a color hex definition as in "#FF0000"'.
        '4. a list of thre values (RGB) (also in an array ref)'.
        '5. a hash with RGB and HSL keys (as in new, but can be mixed) (also in an hash ref).';
    if (ref $args[0] eq __PACKAGE__){ # additive and subtractive color mixing
        @args = (not defined $args[1]) ? ($args[0]->rgb)
              : ($args[0]->red * $args[1], $args[0]->green * $args[1], $args[0]->blue * $args[1]);
    } elsif (ref $args[0] eq 'ARRAY'){ 
        @args = @{$args[0]};
    } elsif (@args == 1 and not ref $args[0]){
        @args = _rgb_from_name_or_hex($args[0]);
        return unless @args == 3;
    }
    my @rgb = $self->rgb;
    if (@args == 3) {
        @rgb = Chart::Color::Value::trim_rgb( $rgb[0] + $args[0], $rgb[1] + $args[1], $rgb[2] + $args[2]);
        return Chart::Color->new( @rgb );
    }
    return carp $help unless @args and ((@args % 2 == 0) or (ref $args[0] eq 'HASH'));
    my %arg = ref $args[0] eq 'HASH' ? %{$args[0]} : @args;
    my %named_arg = map {_shrink_key($_) =>  $arg{$_}} keys %arg; # clean keys
    $rgb[0] += delete $named_arg{'r'} // 0;
    $rgb[1] += delete $named_arg{'g'} // 0;
    $rgb[2] += delete $named_arg{'b'} // 0;
    return Chart::Color->new( Chart::Color::Value::trim_rgb( @rgb ) ) unless %named_arg;
    my @hsl = Chart::Color::Value::_hsl_from_rgb( @rgb );
    $hsl[0] += delete $named_arg{'h'} // 0;
    $hsl[1] += delete $named_arg{'s'} // 0;
    $hsl[2] += delete $named_arg{'l'} // 0;
    if (%named_arg) {
        my @nrkey = grep {/^\d+$/} keys %named_arg;
        return carp "wrong number numerical arguments (only 3 needed)" if @nrkey;
        carp "got unknown hash key starting with", map {' '.$_} keys %named_arg;
    }    
    @hsl = Chart::Color::Value::trim_hsl( @hsl );
    Chart::Color->new({ H => $hsl[0], S => $hsl[1], L => $hsl[2] });
}

sub blend {
    my ($self, $c2, $pos) = @_;
    return carp "need color object or definition as first argument" unless defined $c2;
    my $c2 = (ref $c2 eq __PACKAGE__) ? $c2 : Chart::Color->new( $c2 );
    return unless ref $c2 eq __PACKAGE__;
    my $pos = shift // 0.5;
    my $delta_hue = $self->hue - $c2->hue;
    $delta_hue -= 360 if $delta_hue >  180;
    $delta_hue += 360 if $delta_hue < -180;
    my @hsl = ( $self->hue        + ($pos * $delta_hue),
                $self->saturation + ($pos * ($self->saturation - $c2->saturation)),
                $self->lightness  + ($pos * ($self->lightness  - $c2->lightness))
    );
    @hsl = Chart::Color::Value::trim_hsl( @hsl );
    Chart::Color->new({ H => $hsl[0], S => $hsl[1], L => $hsl[2] });
}

    
sub gradient {
    my ($self, $c2, $steps, $power) = @_;
    return carp "need color object or definition as first argument" unless defined $c2;
    my $c2 = (ref $c2 eq __PACKAGE__) ? $c2 : Chart::Color->new( $c2 );
    return unless ref $c2 eq __PACKAGE__;
    $steps //= 3;
    $power //= 1;
    return carp "third argument (dynamics), has to be positive (>= 0)" if $power <= 0;
    return $self if $steps == 1;
    my @colors = ();
    my @delta_hsl = ($self->hue - $c2->hue, $self->saturation - $c2->saturation,
                                            $self->lightness - $c2->lightness  );
    $delta_hsl[0] -= 360 if $delta_hsl[0] >  180;
    $delta_hsl[0] += 360 if $delta_hsl[0] < -180;
    for my $i (1 .. $steps-2){
        my $pos = ($i / ($steps-1)) ** $power;
        my @hsl = ( $self->hue        + ($pos * $delta_hsl[0]),
                    $self->saturation + ($pos * $delta_hsl[1]),
                    $self->lightness  + ($pos * $delta_hsl[2]));
        @hsl = Chart::Color::Value::trim_hsl( @hsl );
        push @colors, Chart::Color->new({ H => $hsl[0], S => $hsl[1], L => $hsl[2] });
    }
    $self, @colors, $c2;
}

sub complementary {
    my ($self) = shift;
    my ($count) = int ((shift // 1) + 0.5);
    my ($saturation_change) = shift // 0;
    my ($lightness_change) = shift // 0;
    my @hsl2 = my @hsl_l = my @hsl_r = $self->hsl;
    $hsl2[0] += 180;
    $hsl2[1] += $saturation_change;
    $hsl2[2] += $lightness_change;
    @hsl2 = Chart::Color::Value::trim_hsl( @hsl2 ); # HSL of C2
    my $c2 = Chart::Color->new({ h => $hsl2[0], s => $hsl2[1], l => $hsl2[2] });
    return $c2 if $count < 2;
    my (@colors_r, @colors_l);
    my @delta = (360 / $count, (($hsl_r[1] - $hsl2[1]) * 2 / $count), (($hsl_r[2] - $hsl2[2]) * 2 / $count) );
    for (1 .. ($count - 1) / 2){
        $hsl_r[$_] += $delta[$_] for 0..2;
        $hsl_l[0] -= $delta[0];
        $hsl_l[$_] = $hsl_r[$_] for 1,2;
        $hsl_l[0] += 360 if $hsl_l[0] <    0;
        $hsl_r[0] -= 360 if $hsl_l[0] >= 360;
        push @colors_r, Chart::Color->new({ H => $hsl_r[0], S => $hsl_r[1], L => $hsl_r[2] });
        unshift @colors_l, Chart::Color->new({ H => $hsl_l[0], S => $hsl_l[1], L => $hsl_l[2] });
    }
    push @colors_r, $c2 unless $count % 2;
    $self, @colors_r, @colors_l;
}

sub _shrink_key { lc substr( $_[0], 0, 1 ) }

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

When defining a color via "$chart->set( {background => $c});", 
$c is a place holder for a scalar. Any multi value options displayed here
are not available there and in the other methods here.

=head2 new( 'name' )

Get a color by providing a name from the X11 or HTML (SVG) standard or
a Pantone report. Upper/camel case will be treated as lower case and
also inserted underscore letters ('_') will be ignored as perl does in
numbers (1_0000 == 1000).

    my $color = Chart::Color->new('Emerald');
    my @names = Chart::Color::Value::all_names(); # select from these

=head2 new( '#rgb' )

Color definitions in "web format" are also acceptable.

    my $color = Chart::Color->new('#FF0000');
    my $color = Chart::Color->new('#F00');   # works too


=head2 new( [$r, $g, $b] )

Triplet of integer RGB values (red green and blue : 0 .. 255).
Out of range value will be corrected to the closest value in range.


    my $red = Chart::Color->new( 255, 0, 0 );
    my $red = Chart::Color->new([255, 0, 0]); # does the same


=head2 new( {r => $r, g => $g, b => $b} )

Hash with the keys 'r', 'g' and 'b' does the same as previous paragraph,
only more declarative. Casing of the keys will be normalised and only
the first letter of each key is significant.

    my $red = Chart::Color->new( r => 255, g => 0, b => 0 );
    my $red = Chart::Color->new({r => 255, g => 0, b => 0}); # works too
    ... Color->new( Red => 255, Green => 0, Blue => 0);      # also fine

=head2 new( {h => $h, s => $s, l => $l} )

To define a color in HSL space, with values for L</hue>, saturation and
lightness, use the following keys, which will be normalized as decribed
in previous paragraph. Out of range values will be corrected to the
closest value in range. Since L</hue> is a polar coordinate,
it will be rotated into range, e.g. 361 = 1.

    my $red = Chart::Color->new( h =>   0, s => 100, b => 50 );
    my $red = Chart::Color->new({h =>   0, s => 100, b => 50}); # good too
    ... ->new( Hue => 0, Saturation => 100, Lightness => 50 ); # also fine


=head1 GETTER / ATTRIBUTES

are all read only methods - giving access to different parts of an 
objects data.

=head2 red

Integer between 0 .. 255 describing the red portion in RGB space.

=head2 green

Integer between 0 .. 255 describing the green  portion in RGB space.

=head2 blue

Integer between 0 .. 255 describing the green  portion in RGB space.

=head2 rgb

Three values of red, green and blue (see above).

=head2 rgb_hex

String starting with '#', followed by six hexadecimal figures. 
Two digits for each of red, gree and blue value - the format used in CSS.

=head2 hue

Integer between 0 .. 359 describing the angle (in degrees) of the
circular dimension in HSL space named hue.
0 approximates red, 30 - orange, 60 - yellow, 120 - green, 180 - cyan,
240 - blue, 270 - violet, 300 - magenta, 330 - pink.
0 and 360 point to the same coordinate, but this module only deals with 0.

=head2 saturation

Integer between 0 .. 100 describing percentage of saturation in HSL space.
0 is grey and 100 the most colorful (except when lightness is 0 or 100).

=head2 lightness

Integer between 0 .. 100 describing percentage of lightness in HSL space.
0 is always black, 100 is always white and 50 the most colorful
(depending on hue value) (or grey - depending on saturation).

=head2 hsl

Three values of hue, saturation and lightness (see above).


=head2 name

Name of the color in the X11 or HTML (SVG) standard or the Pantone report.
The name will be found and filled in, even when the object is created
with RGB or HSL values. If the color is not found in any of the mentioned
standards, it returns an empty string.

=head1 METHODS

create new, related color (objects) or compute similarity of colors

=head2 distance

A number that measures the distance (difference) between two colors: 
1. the calling object (C1) and 2. a provided first argument C2 - 
color object or scalar data that is acceptable by new method : 
name or #hex or [$r, $g, $b] or {...} (see chapter L<CONSTRUCTOR>).

If no second argument is provided, than the difference is the Euclidean
distance in cylindric HSL space. If second argument is 'rgb' or 'RGB',
then its the Euclidean distance in RGB space. But als subspaces of both
are possible, as r, g, b, rg, rb, gb, h, s, l, hs, hl, and sl.

    my $d = $blue->distance( 'lapisblue' ); # how close to lapis color?
    # how different is my blue value to airy_blue
    $d = $blue->distance( 'airyblue', 'Blue');
    $d = $color->distance( $c2, 'Hue' ); # same hue ?
    $d = $color->distance( [10, 32, 112 ], 'rgb' );
    $d = $color->distance( [{ Hue => 222, Sat => 23, Light => 12 } );

=head2 add

Create a Chart::Color object, by adding any RGB or HSL values to current
color. (values can be negative. Same rules apply for key names as in new).
RGB and HSL can be combined, but please note that RGB are applied first. 

If the first argument is and Chart::Color object, than RGB values will
be added. In that case an optional second argument is a factor (default = 1),
by which the RGB values will be multiplied before being added. Negative
values of that factor lead to darkening of result colors, but its not
subtractive color mixing, since this module does not support CMY
color space. All RGB operations follow the logic of additive mixing.

    my $blue = Chart::Color->new('blue');
    my $darkblue = $blue->add( Lightness => -25 );
    my $blue2 = $blue->add( blue => 10 );
    $blue->distance( $blue2 ); # == 0, can't get bluer than blue
    my $color = $blue->add( $c2, -1.2 ); # subtract color c2 with factor 1.2

=head2 blend

Create one Chart::Color object, that is a blend of two colors: 
1. the calling object (C1) and 2. a provided argument C2 (object or a
refrence to data that is acceptable definition) in HSL space. 

The second argument is the blend ratio, which defaults to 0.5 ( 1:1 ). 
0 represents here C1 and 1 C2. Numbers below 0 and above 1 are possible,
and will be applied, as long the result is inside the finite HSL space.

    my $c = $color->blend( Chart::Color->new('silver') );
    $opposite = $color->blend( $c2, -1 );


=head2 gradient

Creates a gradient (a list of colors that shows a transition) between
current (C1) and a second, given color (C2).

The first argument is C2. Either as an Chart::Color object or a 
reference to data which is acceptable to the method new. 

Second argument is the number $n of colors, which make up the gradient
(including C1 and C2). It defaults to 3. These 3 colors C1, C2 and a 
color in between, which is the same as the result of method mix.

Third argument is also a positive number ($p), which defaults to one.
It defines the dynamics of the transition between the two colors.
If $p == 1 you get a linear transition - meaning the distance in HSL
space (distance_hsl) is equal from one color to the next. If $p != 1,
the formula $n ** $p starts to create a parabola function, which defines
a none linear mapping. For values $n > 1 the transition starts by sticking
to C1 and slowly getting faster and faster toward C2. Values $n < 1 do
the opposite: starting by moving fastest from C1 to C2 (big distances)
and becoming slower and slower.

    my @colors = $c->gradient( Chart::Color->new(14,10,222), 5 );
    @colors = $c1->gradient( $c2, 10, 3 ); # none linear gradient

=head2 complementary

Creates a set of complementary colors.
It accepts 3 numerical arguments: n, delta_S and delta_L.

Imagine an horizontal circle in HSL space, whith a center in the (grey) 
center column. The saturation and lightness of all colors on that
circle is the same, they differ only in hue. The color of the current
color object ($self a.k.a C1) lies on that circle as well as C2,
which is 180 degrees (half the circumference) apposed to C1.

This circle will be divided in $n (first argument) equal partitions,
creating $n equally distanced colors. All of them will be returned, 
as objects, starting with C1. However, when $n is set to 1 (default),
the result is only C2.

The second argument moves C2 along the S axis (both directions),
so that the center of the circle is no longer in the HSL middle column
and the complementary colors differ in saturation. (C1 stays unmoved. )

The third argument moves C2 along the L axis (vertical), which gives the
circle a tilt, so that the complementary colors will differ in lightness.

    my @colors = $c->complementary( 3, +20, -10 );

=head1 COPYRIGHT & LICENSE

Copyright 2022 Herbert Breunung.

This program is free software; you can redistribute it and/or modify it 
under same terms as Perl itself.

=head1 AUTHOR

Herbert Breunung, <lichtkind@cpan.org>

=cut

