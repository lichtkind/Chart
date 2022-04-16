use v5.12;
use warnings;
use Test::More tests => 50;
use Test::Warn;

BEGIN { unshift @INC, 'lib', '../lib'}
my $module = 'Chart::Color';
eval "use $module";
is( not( $@), 1, 'could load the module');


warning_like {Chart::Color->new()}      {carped => qr/constructor of/}, "need argument to create object";



my $red = Chart::Color->new(255, 0, 0);
ok( ref $red eq $module); # could create object

exit 0;

__END__


use  Chart::Color;
my $cn = 'grey';
my $ct = Chart::Color->new( Chart::Color::Named::rgb( $cn ) );
#say $ct->hsl;
for my $name (@names) {
    next if $name eq $cn;
    say ' - ', 100*$ct->distance_hsl($name) / $ct->distance_rgb($name),' - ', $name, ;
}
