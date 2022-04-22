#
# rewrite the constants from 3 rgb to 6 values rgbhsl
#

BEGIN { unshift @INC, '../../../lib'}

use v5.12;
use Chart::Color::Value;
use Chart::Color::Constant;

my $file = '../../../lib/Chart/Color/Constant.pm';
open my $FHI, '<', $file or die "could not open $file";

while (<$FHI>){ # get same order as in file
    chomp;
    next unless /^\s+'(\w+)'\s+=\>/; 
    #my ($r, $g, $b) = hex2rgb( $2 );
    my $name = lc $1;
    my @rgb = Chart::Color::Value::rgb( $name );
    my @hsl = Chart::Color::Value::hsl_from_rgb( @rgb );
    my @brgb = Chart::Color::Value::rgb_from_hsl( @hsl );
    say "    '$name'  ".(' 'x(20 - length($name))).sprintf( "  => [ %3s, %3s, %3s, %3s, %3s, %3s ],", @rgb, @hsl), " @brgb ";
}    
