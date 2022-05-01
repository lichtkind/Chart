
BEGIN { unshift @INC, '../../../../lib'}

use v5.12;
use Carp;
use Chart::Color::Constant;

my @pallets = qw/IE HTML GrayScale EmergyC Crayola Werner SVG WWW CSS SVG X/;


my @rgb = load_external_color('WWW', 'zzz');
say for @rgb;

sub load_external_color {
    my ($pallet_name, $color_name) = @_;
    
    my $module_base = 'Graphics::ColorNames';
    eval "use $module_base";
    return carp "$module_base is not installed" if $@;
    
    my $module = $module_base.'::'.$pallet_name;
    eval "use $module";
    return carp "$module is not installed, to load color '$color_name'" if $@;
    
    my $pal = Graphics::ColorNames->new( $pallet_name );
    my @rgb = $pal->rgb( $color_name );
    return carp "color '$color_name' was not found, propably not part of $module" unless @rgb == 3;
    @rgb;
}

exit(0);


