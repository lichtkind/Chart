use v5.12;

# expandable store of named colors
# value checking and conversion

package Chart::Color::Value;
our $VERSION = '2.402.0';
use Carp;
use Chart::Color::Value::Constant; # here are the actual values of named colors

our $rgbhsl_from_name = \%Chart::Color::Value::Constant::rgbhsl;
our (@name_from_rgb, @name_from_hsl);

# fill @name_from_rgb and @name_from_hsl
_add_color_to_reverse_search( $_, @{$rgbhsl_from_name->{$_}} ) for all_names();


sub all_names  { sort keys %$rgbhsl_from_name }
sub name_taken { exists  $rgbhsl_from_name->{ _clean_name($_[0]) }}

sub rgb_from_name {
    my $name = _clean_name(shift);
    @{$rgbhsl_from_name->{$name}}[0..2] if name_taken($name);
}

sub hsl_from_name {
    my $name = _clean_name(shift);
    @{$rgbhsl_from_name->{$name}}[3..5] if name_taken($name);
}

sub rgbhsl_from_name {
    my $name = _clean_name(shift);
    @{$rgbhsl_from_name->{$name}} if name_taken($name); 
}

sub name_from_rgb { 
    my (@rgb) = @_;
    @rgb  = @{$rgb[0]} if (ref $rgb[0] eq 'ARRAY');
    _check_rgb( @rgb ) and return; # return if sub did carp
    my @names = _names_from_rgb( @rgb );
    wantarray ? @names : $names[0];
}

sub name_from_hsl { 
    my (@hsl) = @_;
    @hsl  = @{$hsl[0]} if (ref $hsl[0] eq 'ARRAY');
    _check_hsl( @hsl ) and return;
    my @names = _names_from_hsl( @hsl );
    wantarray ? @names : $names[0];
}

sub names_in_hsl_range { # @center, (@d | $d) --> @names
    my $help = 'need two arguments: 1. array with h s l values '.
               '2. radius (real number) or array with tolerances in h s l direction';
    return carp  $help if @_ != 2;
    my ($hsl_center, $radius) = @_;
    return carp 'first argument has to be an array ref with thre number ([$h, $s, $l])'
        if ref $hsl_center ne 'ARRAY' or @$hsl_center != 3;
    return carp 'second argument has to be a integer < 180 or array ref with 3 integer'
        unless (ref $radius eq 'ARRAY' and @$radius == 3) or (defined $radius and not ref $radius);
    _check_hsl( @$hsl_center ) and return;

    my @hsl_delta = ref $radius ? @$radius : ($radius, $radius, $radius);
    $hsl_delta[$_] = int abs $hsl_delta[$_] for 0 ..2;
    $hsl_delta[0] = 180 if $hsl_delta[0] > 180;        # enough to search complete HSL space (prevent double results)

    my (@min, @max, @names);
    $min[$_] = $hsl_center->[$_] - $hsl_delta[$_]  for 0..2;
    $max[$_] = $hsl_center->[$_] + $hsl_delta[$_]  for 0..2;
    $min[1] =   0 if $min[1] <   0;
    $min[2] =   0 if $min[2] <   0;
    $max[1] = 100 if $max[1] > 100;
    $max[2] = 100 if $max[2] > 100;
    my @hrange = ($min[0] <   0 ?   0 : $min[0]) .. ($max[0] > 359 ? 359 : $max[0]);
    push @hrange, (360 + $min[0]) .. 359 if $min[0] <   0;
    push @hrange,  0 .. ($max[0] - 360) if $max[0] > 359;
    for my $h (@hrange){
        next unless defined $name_from_hsl[ $h ];
        for my $s ($min[1] .. $max[1]){
            next unless defined $name_from_hsl[ $h ][ $s ];
            for my $l ($min[2] .. $max[2]){
                my $name = $name_from_hsl[ $h ][ $s ][ $l ];
                next unless defined $name;
                push @names, (ref $name ? $name->[0] : $name);
             }
        }
    }
    @names = grep {distance_hsl( $hsl_center ,[hsl_from_name($_)] ) <= $radius} @names if not ref $radius;
    @names;
}

sub distance_hsl { # $h, $s, $l, --> $d
    return carp  "need two triplets of hsl values in 2 arrays to compute hsl distance " 
        if @_ != 2 or ref $_[0] ne 'ARRAY' or ref $_[1] ne 'ARRAY';
    _check_hsl( @{$_[0]} ) and return;
    _check_hsl( @{$_[1]} ) and return;
    my $delta_h = abs($_[0][0] - $_[1][0]);
    $delta_h = 360 - $delta_h if $delta_h > 180;
    sqrt($delta_h ** 2 + ($_[0][1] - $_[1][1]) ** 2 + ($_[0][2] - $_[1][2]) ** 2); 
}

sub distance_rgb { # $r, $g, $b --> $d
    return carp  "need two triplets of rgb values in 2 arrays to compute rgb distance " 
        if @_ != 2 or ref $_[0] ne 'ARRAY' or ref $_[1] ne 'ARRAY';
    _check_rgb( @{$_[0]} ) and return;
    _check_rgb( @{$_[1]} ) and return;
    sqrt(($_[0][0] - $_[1][0]) ** 2 + ($_[0][1] - $_[1][1]) ** 2 + ($_[0][2] - $_[1][2]) ** 2); 
}

sub hsl_from_rgb { # convert color value triplet (int --> int), (real --> real) it $real
    my (@rgb) = @_;
    my $real = '';
    if (ref $rgb[0] eq 'ARRAY'){
        @rgb = @{$rgb[0]};
        $real = $rgb[1] // $real;
    }
    _check_rgb( @rgb ) and return unless $real;
    my @hsl = _hsl_from_rgb( @rgb );
    return @hsl if $real;
    ( int( $hsl[0] + 0.5 ), int( $hsl[1] + 0.5), int( $hsl[2] + 0.5) );
}

sub rgb_from_hsl { # convert color value triplet (int > int), (real > real) it $real
    my (@hsl) = @_;
    my $real = '';
    if (ref $hsl[0] eq 'ARRAY'){
        @hsl = @{$hsl[0]};
        $real = $hsl[1] // $real;
    }
    _check_hsl( @hsl ) and return unless $real;
    my @rgb = _rgb_from_hsl( @hsl );
    return @rgb if $real;
    ( int( $rgb[0] + 0.5 ), int( $rgb[1] + 0.5), int( $rgb[2] + 0.5) );
}


sub add_rgb {
    my ($name, @rgb) = @_;
    @rgb  = @{$rgb[0]} if (ref $rgb[0] eq 'ARRAY');
    return carp "missing first argument: color name" unless defined $name and $name;
    _check_rgb( @rgb ) and return;
    _add_color( $name, @rgb, hsl_from_rgb( @rgb ) );
}

sub add_hsl {
    my ($name, @hsl) = @_;
    @hsl  = @{$hsl[0]} if (ref $hsl[0] eq 'ARRAY');
    return carp "missing first argument: color name" unless defined $name and $name;
    _check_hsl( @hsl ) and return;
    _add_color( $name, rgb_from_hsl( @hsl ), @hsl );
}

sub _add_color {
    my ($name, @rgb, @hsl) = @_;
    $name = _clean_name( $name );
    return carp "there is already a color named '$name' in store of ".__PACKAGE__ if name_taken( $name );
    _add_color_to_reverse_search( $name, @rgb, @hsl);
    my $ret = $rgbhsl_from_name->{$name} = [@rgb, @hsl]; # add to foreward search
    (ref $ret) ? [@$ret] : '';                # make returned ref not transparent
}

sub _clean_name {
    my $name = shift;
    $name =~ tr/_//d;
    lc $name;
}

sub _check_rgb { # carp returns 1
    my (@rgb) = @_;
    return carp "need exactly 3 positive integer values 0 <= n < 256 for rgb input" unless @rgb == 3;
    return carp "red value has to be an integer between 0 and 255"   unless int $rgb[0] == $rgb[0] and $rgb[0] >= 0 and $rgb[0] < 256;
    return carp "green value has to be an integer between 0 and 255" unless int $rgb[1] == $rgb[1] and $rgb[1] >= 0 and $rgb[1] < 256;
    return carp "blue value has to be an integer between 0 and 255"  unless int $rgb[2] == $rgb[2] and $rgb[2] >= 0 and $rgb[2] < 256;
    0;
}

sub _check_hsl {
    my (@hsl) = @_;
    return carp "need exactly 3 positive integer between 0 and 359 or 99 for hsl input" unless @hsl == 3;
    return carp "hue value has to be an integer between 0 and 359"        unless int $hsl[0] == $hsl[0] and $hsl[0] >= 0 and $hsl[0] < 360;
    return carp "saturation value has to be an integer between 0 and 100" unless int $hsl[1] == $hsl[1] and $hsl[1] >= 0 and $hsl[1] < 101;
    return carp "lightness value has to be an integer between 0 and 100"  unless int $hsl[2] == $hsl[2] and $hsl[2] >= 0 and $hsl[2] < 101;
    0;
}

sub _hsl_from_rgb { # float conversion
    my (@rgb) = @_;
    my ($maxi, $mini) = (0 , 1);   # index of max and min value in @rgb
    if    ($rgb[1] > $rgb[0])      { ($maxi, $mini ) = ($mini, $maxi ) }
    if    ($rgb[2] > $rgb[$maxi])  {  $maxi = 2 }
    elsif ($rgb[2] < $rgb[$mini])  {  $mini = 2 }
    my $delta = $rgb[$maxi] - $rgb[$mini];
    my $avg = ($rgb[$maxi] + $rgb[$mini]) / 2;
    my $H = !$delta ? 0 : (2 * $maxi + (($rgb[($maxi+1) % 3] - $rgb[($maxi+2) % 3]) / $delta)) * 60;
    $H += 360 if $H < 0;
    my $S = ($avg == 0) ? 0 : ($avg == 255) ? 0 : $delta / (255 - abs((2 * $avg) - 255));
    ($H, $S * 100, $avg * 0.392156863 );
}

sub _rgb_from_hsl { # float conversion
    my (@hsl) = @_;
    $hsl[0] /= 60;
    my $C = $hsl[1] * (100 - abs($hsl[2] * 2 - 100)) * 0.0255;
    my $X = $C * (1 - abs($hsl[0] % 2 - 1 + ($hsl[0] - int $hsl[0])));
    my $m = ($hsl[2] * 2.55) - ($C / 2);
    return ($hsl[0] < 1) ? ($C + $m, $X + $m,      $m)
         : ($hsl[0] < 2) ? ($X + $m, $C + $m,      $m)
         : ($hsl[0] < 3) ? (     $m, $C + $m, $X + $m)
         : ($hsl[0] < 4) ? (     $m, $X + $m, $C + $m)
         : ($hsl[0] < 5) ? ($X + $m,      $m, $C + $m)
         :                 ($C + $m,      $m, $X + $m);
}

sub _names_from_rgb { # each of AoAoA cells (if exists) contains name or array with names (shortes first)
    return unless exists $name_from_rgb[ $_[0] ] 
              and exists $name_from_rgb[ $_[0] ][ $_[1] ] and exists $name_from_rgb[ $_[0] ][ $_[1] ][ $_[2] ];
    my $cell = $name_from_rgb[ $_[0] ][ $_[1] ][ $_[2] ];
    ref $cell ? @$cell : $cell;
}

sub _names_from_hsl { 
    return unless exists $name_from_hsl[ $_[0] ] 
              and exists $name_from_hsl[ $_[0] ][ $_[1] ] and exists $name_from_hsl[ $_[0] ][ $_[1] ][ $_[2] ];
    my $cell = $name_from_hsl[ $_[0] ][ $_[1] ][ $_[2] ];
    ref $cell ? @$cell : $cell;
}

sub _add_color_to_reverse_search { #     my ($name, @rgb, @hsl) = @_;
    my $name = $_[0];
    my $cell = $name_from_rgb[ $_[1] ][ $_[2] ][ $_[3] ];
    if (defined $cell) {
        if (ref $cell) {
            if (length $name < length $cell->[0] ) { unshift @$cell, $name }
            else                                   { push @$cell, $name    }
        } else {
            $name_from_rgb[ $_[1] ][ $_[2] ][ $_[3] ] = 
                (length $name < length $cell) ? [ $name, $cell ] 
                                              : [ $cell, $name ] ;
        }
    } else { $name_from_rgb[ $_[1] ][ $_[2] ][ $_[3] ] = $name  }
    
    $cell = $name_from_hsl[ $_[4] ][ $_[5] ][ $_[6] ];
    if (defined $cell) {
        if (ref $cell) {
            if (length $name < length $cell->[0] ) { unshift @$cell, $name }
            else                                   { push @$cell, $name    }
        } else {
            $name_from_hsl[ $_[4] ][ $_[5] ][ $_[6] ] = 
                (length $name < length $cell) ? [ $name, $cell ] 
                                              : [ $cell, $name ] ;
        }
    } else { $name_from_hsl[ $_[4] ][ $_[5] ][ $_[6] ] = $name  }
}

1;

__END__

=pod

=head1 NAME

Chart::Color::Value - color constants and value conversion

=head1 SYNOPSIS 


=head1 DESCRIPTION

RGB and HSL values of named colors from the X11 and HTML standard 
and Pantone report. Allows also reverse search, storage and conversion
of color values.

This module is supposed to be used by Chart::Color and not directly
by the user (for the most part). It converts a stored color name into
its values (rgb, hsl or both) and back. One color can have multiple names.
Also nearby (similar) colors can be searched. Own colors can be 
(none permanently) stored for later reference by name. For this a name
has to be chosen, that is not already taken. Independently of that
can any color be converted from rgb to hsl and back.

=head1 ROUTINES

=head2 rgb_from_name

Red, Green and Blue value of the named color. 
These values are integer in 0 .. 255.

    my @rgb = Chart::Color::Value::rgb_from_name('darkblue');
    @rgb = Chart::Color::Value::rgb_from_name('dark_blue'); # same result
    @rgb = Chart::Color::Value::rgb_from_name('DarkBlue');  # still same

=head2 hsl_from_name

Hue, saturation and lightness of the named color. 
These are integer between 0 .. 359 (hue) or 100 (sat. & light.).
A hue of 360 and 0 (degree in a cylindrical coordinate system) is
considered to be the same, this modul deals only with the ladder.

    my @hsl = Chart::Color::Value::hsl_from_name('darkblue');

=head2 rgbhsl_from_name

Get all six values of color with given name (rgb and hsl, see above).

=head2 name_from_rgb

Returns name of color with given rgb value triplet. 
Returns empty string if color is not stored. When several names define
given color, the shortest name will be selected in scalar context.
In array context all names are given.

    say Chart::Color::Value::name_from_rgb( 15, 10, 121 );  # 'darkblue'
    say Chart::Color::Value::name_from_rgb([15, 10, 121]);  # works too

=head2 name_from_hsl

Returns name of color with given hsl value triplet. 
Returns empty string if color is not stored. When several names define
given color, the shortest name will be selected in scalar context.
In array context all names are given.

    say Chart::Color::Value::name_from_hsl( 0, 100, 50 );  # 'red'
    say Chart::Color::Value::name_from_hsl([0, 100, 50]);  # works too

=head2  names_in_hsl_range

Color names in selected neighbourhood of hsl color space, that look similar. 
It requires two arguments. The first one is an array containing three
values (hue, saturation and lightness), that define the center of the
neighbourhood (searched area).

The second argument can either be a number or again an array with
three values (h,s and l). If its just a number, it will be the radius r
of a ball, that defines the neighbourhood. From all colors inside that
ball, that are equal distanced or nearer to the center than r, one
name will returned.

If the second argument is an array, it has to contain the tolerance
(allowed distance) in h, s and l direction. Please note the h dimension
is circular: the distance from 355 to 0 is 5. The s and l dimensions are
linear, so that a center value of 90 and a tolerance of 15 will result
in a search of in the range 75 .. 100.

The results contains only one name per color (the shortest).

    # all bright red'ish clors
    my @names = Chart::Color::Value::names_in_hsl_range([0, 90, 50], 5);
    # approximates to : 
    my @names = Chart::Color::Value::names_in_hsl_range([0, 90, 50],[ 3, 3, 3]);


=head2 all_names

A sorted list of all stored color names.

=head2 name_taken

A perlish pseudo boolean tells if the color name is already in use.

=head2 add_rgb

Adding a color to the store under an not taken (not already used) name.
Arguments are name, red, green and blue value (integer < 256, see rgb).

    Chart::Color::Value::add_rgb('nightblue',  15, 10, 121 );
    Chart::Color::Value::add_rgb('nightblue', [15, 10, 121]);

=head2 add_hsl

Adding a color to the store under an not taken (not already used) name.
Arguments are name, hue, saturation and lightness value (see hsl).

    Chart::Color::Value::add_rgb('lucky',  0, 100, 50 );
    Chart::Color::Value::add_rgb('lucky', [0, 100, 50]);


=head2 hsl_from_rgb

Converting an rgb value triplet into the corresponding hsl 
(see rgb_from_name and hsl_from_name).

=head2 rgb_from_hsl

Converting an hsl value triplet into the corresponding rgb 
(see rgb_from_name and hsl_from_name). Please not that back and forth
conversion can lead to drifting results due to rounding.

    my @rgb = Chart::Color::Value::rgb_from_hsl(0, 90, 50);
    my @rgb = Chart::Color::Value::rgb_from_hsl([0, 90, 50]); # works too
    # for real (none integer results), any none zero value works as second arg 
    my @rgb = Chart::Color::Value::rgb_from_hsl([0, 90, 50], 'real');

=head2 distance_rgb

Distance in (linear) rgb color space between two coordinates.


    my $d = Chart::Color::Value::distance_rgb([1,1,1], [2,2,2]);  # approx 1.7


=head2 distance_hsl

Distance in (cylindrical) hsl color space between two coordinates.

    my $d = Chart::Color::Value::distance_rgb([1,1,1], [356, 3, 2]); # approx 6


=head1 COPYRIGHT & LICENSE

Copyright 2022 Herbert Breunung.

This program is free software; you can redistribute it and/or modify it 
under same terms as Perl itself.

=head1 AUTHOR

Herbert Breunung, <lichtkind@cpan.org>

=cut
