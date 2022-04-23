
BEGIN { unshift @INC, '../../../lib'}

use v5.12;
use Carp;
use Chart::Color::Constant;

my $module_base = 'Graphics::ColorNames';
my $pallet_name = 'WWW';
my $module = $module_base.'::'.$pallet_name;

eval "use $module_base";
if( $@){
    carp "$module_base is not installed";
    exit(0);
}

eval "use $module";
if( $@){
    carp "$module is not installed";
    exit(0);
}

my $pal = Graphics::ColorNames->new( $pallet_name );
my @rgb = $pal->rgb('green');
say for @rgb;


__END__
IE
HTML
GrayScale 
EmergyC
Crayola
Werner
SVG
WWW
CSS
SVG
