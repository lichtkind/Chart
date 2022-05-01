
BEGIN { unshift @INC, '../../../../lib'}

use v5.12;
use Chart::Color::Constant;

while (<DATA>){
    chomp;
    my ($h, $s, $l) = Chart::Color::Constant::hsl_from_name( $_ );
    #my ($r, $g, $b) = hex2rgb( $2 );
    my $name = lc $_;
    say "    '$name'  ".(' 'x(20 - length($name))).sprintf( "  => [ %3s, %3s, %3s ],", $h, $s, $l); 
}

# default,
# light,
# dark
# colorful
# shady

__END__
red
green
blue
purple
peach
orange
mauve
olive
pink
light_purple
light_blue
plum
yellow
turquoise
light_green
brown
HotPink
PaleGreen1
DarkBlue
BlueViolet
orange2
chocolate1
LightGreen
pink
light_purple
light_blue
yellow
turquoise
light_green
brown
pink
PaleGreen2
MediumPurple
PeachPuff1
orange3
chocolate2
olive
pink
light_purple
light_blue
yellow
turquoise
light_green
brown
DarkOrange
PaleGreen3
SlateBlue
BlueViolet
PeachPuff2
orange4
chocolate3
LightGreen
pink
light_purple
light_blue
yellow
turquoise
light_green
brown
snow1
honeydew3
SkyBlue1
cyan3
DarkOliveGreen1
IndianRed3
orange1
LightPink3
MediumPurple1
snow3
LavenderBlush1
SkyBlue3
DarkSlateGray1
DarkOliveGreen3
sienna1
orange3
PaleVioletRed1
MediumPurple3
seashell1
LavenderBlush3
LightSkyBlue1
DarkSlateGray3
khaki1
sienna3
DarkOrange1
PaleVioletRed3
thistle1
seashell3
MistyRose1
LightSkyBlue3
aquamarine1
khaki3
burlywood1
DarkOrange3
maroon1
thistle3
AntiqueWhite1
MistyRose3
SlateGray1
aquamarine3
LightGoldenrod1
burlywood3
coral1
maroon3
AntiqueWhite3
azure1
SlateGray3
DarkSeaGreen1
LightGoldenrod3
wheat1
coral3
VioletRed1
bisque1
azure3
LightSteelBlue1
DarkSeaGreen3
LightYellow1
wheat3
tomato1
VioletRed3
bisque3
SlateBlue1
LightSteelBlue3
SeaGreen1
LightYellow3
tan1
tomato3
magenta1
SlateBlue3
LightBlue1
SeaGreen3
yellow1
tan3
OrangeRed1
magenta3
PeachPuff3
RoyalBlue1
LightBlue3
PaleGreen1
yellow3
chocolate1
OrangeRed3
orchid1
NavajoWhite1
RoyalBlue3
LightCyan1
PaleGreen3
gold1
chocolate3
red1
orchid3
NavajoWhite3
blue1
LightCyan3
SpringGreen1
gold3
firebrick1
red3
LemonChiffon1
blue3
PaleTurquoise1
SpringGreen3
goldenrod1
