
BEGIN { unshift @INC, '../Chart/lib'}

use v5.12;

use Chart::Color::Value;

my $file = '../Chart/lib/Chart/Color/Value.pm';
open my $FHI, '<', $file or die "could not open $file";

while (<$FHI>){
    chomp;
    next unless /^\s+'(\w+)'\s+=\>/; 
    #my ($r, $g, $b) = hex2rgb( $2 );
    my $name = lc $1;
    my @rgb = Chart::Color::Value::rgb( $name );
    my @hsl = Chart::Color::Value::hsl_from_rgb( @rgb );
    my @brgb = Chart::Color::Value::rgb_from_hsl( @hsl );
    say "    '$name'  ".(' 'x(20 - length($name))).sprintf( "  => [ %3s, %3s, %3s, %3s, %3s, %3s ],", @rgb, @hsl), " @brgb ";
}    
