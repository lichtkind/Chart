use v5.12;
use warnings;
BEGIN { unshift @INC, 'lib', '../../../lib'}

use Chart::Mountain;

my @data = (
    ["1st", "2nd", "3rd", "4th", "5th", "6th", "7th", "8th", "9th" ],
    [ 3, 7, 8, 2, 4  , 8.5, 2, 5, 9],
    [ 4, 2, 5, 6, 3  , 2.5, 3, 3, 4],
    [ 7, 3, 2, 8, 8.5, 2  , 9, 4, 5],
);

my @hex_colors = ('#0099FF', '#00CC00', '#EEAA00', '#FF0099','#3333FF');
my $PNG;
my @patterns = map {
    open( $PNG, '<', "./patterns/PATTERN$_.PNG" ) or die "Can't load pattern $_";
    GD::Image->newFromPng( $PNG );
} 0 .. 4;

my $g = new Chart::Mountain( 500, 300);
$g->set(
    title      => 'Mountain Chart with Patterns',
    x_label    => 'Lengths',
    y_label    => 'Height',
    grid_lines => 'true',
    patterns   => \@patterns,
    precision  => 1,
    colors => {
            grid_lines => 'gray70',
            misc       => 'gray55',
            map { ( "dataset$_" => $hex_colors[$_] ) } 0 .. $#hex_colors,
    },
);
$g->png( 'mountain.png', \@data );

