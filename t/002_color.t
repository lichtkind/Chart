use v5.12;
use warnings;
use Test::More tests => 231;
use Test::Warn;

BEGIN { unshift @INC, 'lib', '../lib'}
my $module = 'Chart::Color';
eval "use $module";
is( not( $@), 1, 'could load the module');


warning_like {Chart::Color->new()}                    {carped => qr/constructor of/},  "need argument to create object";
warning_like {Chart::Color->new('weirdcolorname')}    {carped => qr/unknown color/},   "accept only known color names";
warning_like {Chart::Color->new('#23232')       }     {carped => qr/has not length/},  "hex definition too short";
warning_like {Chart::Color->new('#232321f')     }     {carped => qr/has not length/},  "hex definition too long";
warning_like {Chart::Color->new(1,1)}                 {carped => qr/constructor of/},  "too few positional args";
warning_like {Chart::Color->new(1,1,1,1)}             {carped => qr/constructor of/},  "too many positional args";
warning_like {Chart::Color->new([1,1])}               {carped => qr/constructor of/},  "too few positional args in ref";
warning_like {Chart::Color->new([1,1,1,1])}           {carped => qr/constructor of/},  "too many positional args in ref";
warning_like {Chart::Color->new({ r=>1, g=>1})}       {carped => qr/constructor of/},  "too few named args in ref";
warning_like {Chart::Color->new({r=>1,g=>1,b=>1,h=>1,})} {carped => qr/constructor of/},"too many name args in ref";
warning_like {Chart::Color->new( r=>1, g=>1)}         {carped => qr/constructor of/},  "too few named args";
warning_like {Chart::Color->new(r=>1,g=>1,b=>1,h=>1)} {carped => qr/constructor of/},  "too many name args";
warning_like {Chart::Color->new(r=>1,g=>1,h=>1)}      {carped => qr/argument keys/},   "don't mix named args";
warning_like {Chart::Color->new(r=>1,g=>1,t=>1)}      {carped => qr/argument keys/},   "don't invent named args";

my $red = Chart::Color->new('red');
is( ref $red,        $module, 'could create object by name');
is( $red->red,           255, 'named red has correct red component value');
is( $red->green,           0, 'named red has correct green component value');
is( $red->blue,            0, 'named red has correct blue component value');
is( $red->hue,             0, 'named red has correct hue component value');
is( $red->saturation,    100, 'named red has correct saturation component value');
is( $red->lightness,      50, 'named red has correct lightness component value');
is( $red->name,        'red', 'named red has correct name');
is( $red->rgb_hex, '#ff0000', 'named red has correct hex value');
is(($red->rgb)[0],       255, 'named red has correct rgb red component value');
is(($red->rgb)[1],         0, 'named red has correct rgb green component value');
is(($red->rgb)[2],         0, 'named red has correct rgb blue component value');
is(($red->hsl)[0],         0, 'named red has correct hsl hue component value');
is(($red->hsl)[1],       100, 'named red has correct hsl saturation component value');
is(($red->hsl)[2],        50, 'named red has correct hsl lightness component value');


$red = Chart::Color->new('#FF0000');
is( ref $red,     $module, 'could create object by hex value');
is( $red->red,           255, 'hex red has correct red component value');
is( $red->green,           0, 'hex red has correct green component value');
is( $red->blue,            0, 'hex red has correct blue component value');
is( $red->hue,             0, 'hex red has correct hue component value');
is( $red->saturation,    100, 'hex red has correct saturation component value');
is( $red->lightness,      50, 'hex red has correct lightness component value');
is( $red->name,        'red', 'hex red has correct name');
is( $red->rgb_hex, '#ff0000', 'hex red has correct hex value');
is(($red->rgb)[0],       255, 'hex red has correct rgb red component value');
is(($red->rgb)[1],         0, 'hex red has correct rgb green component value');
is(($red->rgb)[2],         0, 'hex red has correct rgb blue component value');
is(($red->hsl)[0],         0, 'hex red has correct hsl hue component value');
is(($red->hsl)[1],       100, 'hex red has correct hsl saturation component value');
is(($red->hsl)[2],        50, 'hex red has correct hsl lightness component value');

$red = Chart::Color->new('#F00');
is( ref $red,     $module, 'could create object by short hex value');
is( $red->name,        'red', 'short hex red has correct name');

$red = Chart::Color->new(255, 0, 0);
is( ref $red, $module, 'could create object by positional RGB');
is( $red->red,           255, 'positional red has correct red component value');
is( $red->green,           0, 'positional red has correct green component value');
is( $red->blue,            0, 'positional red has correct blue component value');
is( $red->hue,             0, 'positional red has correct hue component value');
is( $red->saturation,    100, 'positional red has correct saturation component value');
is( $red->lightness,      50, 'positional red has correct lightness component value');
is( $red->name,        'red', 'positional red has correct name');
is( $red->rgb_hex, '#ff0000', 'positional red has correct hex value');
is(($red->rgb)[0],       255, 'positional red has correct rgb red component value');
is(($red->rgb)[1],         0, 'positional red has correct rgb green component value');
is(($red->rgb)[2],         0, 'positional red has correct rgb blue component value');
is(($red->hsl)[0],         0, 'positional red has correct hsl hue component value');
is(($red->hsl)[1],       100, 'positional red has correct hsl saturation component value');
is(($red->hsl)[2],        50, 'positional red has correct hsl lightness component value');

$red = Chart::Color->new([255, 0, 0]);
is( ref $red, $module, 'could create object by RGB array ref');
is( $red->red,           255, 'array ref red has correct red component value');
is( $red->green,           0, 'array ref red has correct green component value');
is( $red->blue,            0, 'array ref red has correct blue component value');
is( $red->hue,             0, 'array ref red has correct hue component value');
is( $red->saturation,    100, 'array ref red has correct saturation component value');
is( $red->lightness,      50, 'array ref red has correct lightness component value');
is( $red->name,        'red', 'array ref red has correct name');
is( $red->rgb_hex, '#ff0000', 'array ref red has correct hex value');
is(($red->rgb)[0],       255, 'array ref red has correct rgb red component value');
is(($red->rgb)[1],         0, 'array ref red has correct rgb green component value');
is(($red->rgb)[2],         0, 'array ref red has correct rgb blue component value');
is(($red->hsl)[0],         0, 'array ref red has correct hsl hue component value');
is(($red->hsl)[1],       100, 'array ref red has correct hsl saturation component value');
is(($red->hsl)[2],        50, 'array ref red has correct hsl lightness component value');

$red = Chart::Color->new(r => 255, g => 0, b => 0);
is( ref $red, $module, 'could create object by RGB named args');
is( $red->red,           255, 'named arg red has correct red component value');
is( $red->green,           0, 'named arg red has correct green component value');
is( $red->blue,            0, 'named arg red has correct blue component value');
is( $red->hue,             0, 'named arg red has correct hue component value');
is( $red->saturation,    100, 'named arg red has correct saturation component value');
is( $red->lightness,      50, 'named arg red has correct lightness component value');
is( $red->name,        'red', 'named arg red has correct name');
is( $red->rgb_hex, '#ff0000', 'named arg red has correct hex value');
is(($red->rgb)[0],       255, 'named arg red has correct rgb red component value');
is(($red->rgb)[1],         0, 'named arg red has correct rgb green component value');
is(($red->rgb)[2],         0, 'named arg red has correct rgb blue component value');
is(($red->hsl)[0],         0, 'named arg red has correct hsl hue component value');
is(($red->hsl)[1],       100, 'named arg red has correct hsl saturation component value');
is(($red->hsl)[2],        50, 'named arg red has correct hsl lightness component value');

$red = Chart::Color->new({Red => 255, Green => 0, Blue => 0 });
is( ref $red, $module, 'could create object by RGB hash ref');
is( $red->red,           255, 'hash ref red has correct red component value');
is( $red->green,           0, 'hash ref red has correct green component value');
is( $red->blue,            0, 'hash ref red has correct blue component value');
is( $red->hue,             0, 'hash ref red has correct hue component value');
is( $red->saturation,    100, 'hash ref red has correct saturation component value');
is( $red->lightness,      50, 'hash ref red has correct lightness component value');
is( $red->name,        'red', 'hash ref red has correct name');
is( $red->rgb_hex, '#ff0000', 'hash ref red has correct hex value');
is(($red->rgb)[0],       255, 'hash ref red has correct rgb red component value');
is(($red->rgb)[1],         0, 'hash ref red has correct rgb green component value');
is(($red->rgb)[2],         0, 'hash ref red has correct rgb blue component value');
is(($red->hsl)[0],         0, 'hash ref red has correct hsl hue component value');
is(($red->hsl)[1],       100, 'hash ref red has correct hsl saturation component value');
is(($red->hsl)[2],        50, 'hash ref red has correct hsl lightness component value');

$red = Chart::Color->new({h => 0, s => 100, l => 50 });
is( ref $red, $module, 'could create object by HSL hash ref');
is( $red->red,           255, 'hash ref red has correct red component value');
is( $red->green,           0, 'hash ref red has correct green component value');
is( $red->blue,            0, 'hash ref red has correct blue component value');
is( $red->hue,             0, 'hash ref red has correct hue component value');
is( $red->saturation,    100, 'hash ref red has correct saturation component value');
is( $red->lightness,      50, 'hash ref red has correct lightness component value');
is( $red->name,        'red', 'hash ref red has correct name');
is( $red->rgb_hex, '#ff0000', 'hash ref red has correct hex value');
is(($red->rgb)[0],       255, 'hash ref red has correct rgb red component value');
is(($red->rgb)[1],         0, 'hash ref red has correct rgb green component value');
is(($red->rgb)[2],         0, 'hash ref red has correct rgb blue component value');
is(($red->hsl)[0],         0, 'hash ref red has correct hsl hue component value');
is(($red->hsl)[1],       100, 'hash ref red has correct hsl saturation component value');
is(($red->hsl)[2],        50, 'hash ref red has correct hsl lightness component value');

$red = Chart::Color->new( Hue => 0, Sat => 100, Light => 50 );
is( ref $red, $module, 'could create object by HSL named args');
is( $red->red,           255, 'hash ref red has correct red component value');
is( $red->green,           0, 'hash ref red has correct green component value');
is( $red->blue,            0, 'hash ref red has correct blue component value');
is( $red->hue,             0, 'hash ref red has correct hue component value');
is( $red->saturation,    100, 'hash ref red has correct saturation component value');
is( $red->lightness,      50, 'hash ref red has correct lightness component value');
is( $red->name,        'red', 'hash ref red has correct name');
is( $red->rgb_hex, '#ff0000', 'hash ref red has correct hex value');
is(($red->rgb)[0],       255, 'hash ref red has correct rgb red component value');
is(($red->rgb)[1],         0, 'hash ref red has correct rgb green component value');
is(($red->rgb)[2],         0, 'hash ref red has correct rgb blue component value');
is(($red->hsl)[0],         0, 'hash ref red has correct hsl hue component value');
is(($red->hsl)[1],       100, 'hash ref red has correct hsl saturation component value');
is(($red->hsl)[2],        50, 'hash ref red has correct hsl lightness component value');


my $c = Chart::Color->new( 1,2,3 );
is( ref $red, $module, 'could create object by random unnamed color');
is( $c->red,           1, 'random color has correct red component value');
is( $c->green,         2, 'random color has correct green component value');
is( $c->blue,          3, 'random color has correct blue component value');
is( $c->name,         '', 'random color has no name');

my $blue = Chart::Color->new( 'blue' );
is( $blue->red,        0, 'blue has correct red component value');
is( $blue->green,      0, 'blue has correct green component value');
is( $blue->blue,     255, 'blue has correct blue component value');
is( $blue->name,  'blue', 'blue color has correct name');

is( $blue->distance($red),            120, 'correct default hsl distance between red and blue');
is( $blue->distance($red, 'HSL'),     120, 'correct hsl distance between red and blue');
is( $blue->distance($red, 'Hue'),     120, 'correct hue distance between red and blue, long name');
is( $blue->distance($red, 'h'),       120, 'correct hue distance between red and blue');
is( $blue->distance($red, 's'),         0, 'correct sturation distance between red and blue');
is( $blue->distance($red, 'Sat'),       0, 'correct sturation distance between red and blue, long name');
is( $blue->distance($red, 'l'),         0, 'correct lightness distance between red and blue');
is( $blue->distance($red, 'Light'),     0, 'correct lightness distance between red and blue, long name');
is( $blue->distance($red, 'hs'),      120, 'correct hs distance between red and blue');
is( $blue->distance($red, 'hl'),      120, 'correct hl distance between red and blue');
is( $blue->distance($red, 'sl'),        0, 'correct sl distance between red and blue');
is( int $blue->distance($red, 'rgb'), 360, 'correct rgb distance between red and blue');
is( $blue->distance($red, 'Red'),     255, 'correct red distance between red and blue, long name');
is( $blue->distance($red, 'r'),       255, 'correct red distance between red and blue');
is( $blue->distance($red, 'Green'),     0, 'correct green distance between red and blue, long name');
is( $blue->distance($red, 'g'),         0, 'correct green distance between red and blue');
is( $blue->distance($red, 'Blue'),    255, 'correct blue distance between red and blue, long name');
is( $blue->distance($red, 'b'),       255, 'correct blue distance between red and blue');
is( $blue->distance($red, 'rg'),      255, 'correct rg distance between red and blue');
is( int $blue->distance($red, 'rb'),  360, 'correct rb distance between red and blue');
is( $blue->distance($red, 'gb'),      255, 'correct gb distance between red and blue');

is( int $blue->distance([10, 10, 245],      ),   8, 'correct default hsl  distance between own rgb blue and blue');
is( int $blue->distance([10, 10, 245], 'HSL'),   8, 'correct hsl distance between own rgb blue and blue');
is(     $blue->distance([10, 10, 245], 'Hue'),   0, 'correct hue distance between own rgb blue and blue, long name');
is(     $blue->distance([10, 10, 245], 'h'),     0, 'correct hue distance between own rgb blue and blue');
is( int $blue->distance([10, 10, 245], 's'),     8, 'correct sturation distance between own rgb blue and blue');
is( int $blue->distance([10, 10, 245], 'Sat'),   8, 'correct sturation distance between own rgb blue and blue, long name');
is( int $blue->distance([10, 10, 245], 'l'),     0, 'correct lightness distance between own rgb blue and blue');
is( int $blue->distance([10, 10, 245], 'Light'), 0, 'correct lightness distance between own rgb blue and blue, long name');
is( int $blue->distance([10, 10, 245], 'hs'),    8, 'correct hs distance between own rgb blue and blue');
is( int $blue->distance([10, 10, 245], 'hl'),    0, 'correct hl distance between own rgb blue and blue');
is( int $blue->distance([10, 10, 245], 'sl'),    8, 'correct sl distance between own rgb blue and blue');
is( int $blue->distance([10, 10, 245], 'rgb'),  17, 'correct rgb distance between own rgb blue and blue');
is(     $blue->distance([10, 10, 245], 'Red'),  10, 'correct red distance between own rgb blue and blue, long name');
is(     $blue->distance([10, 10, 245], 'r'),    10, 'correct red distance between own rgb blue and blue');
is(     $blue->distance([10, 10, 245], 'Green'),10, 'correct green distance between own rgb blue and blue, long name');
is(     $blue->distance([10, 10, 245], 'g'),    10, 'correct green distance between own rgb blue and blue');
is(     $blue->distance([10, 10, 245], 'Blue'), 10, 'correct blue distance between own rgb blue and blue, long name');
is(     $blue->distance([10, 10, 245], 'b'),    10, 'correct blue distance between own rgb blue and blue');
is( int $blue->distance([10, 10, 245], 'rg'),   14, 'correct rg distance between own rgb blue and blue');
is( int $blue->distance([10, 10, 245], 'rb'),   14, 'correct rb distance between own rgb blue and blue');
is( int $blue->distance([10, 10, 245], 'gb'),   14, 'correct gb distance between own rgb blue and blue');

is( int $blue->distance({h =>230, s => 90, l=>40}),         17, 'correct default hsl distance between own hsl blue and blue');
is( int $blue->distance({h =>230, s => 90, l=>40}, 'HSL'),  17, 'correct hsl distance between own hsl blue and blue');
is(     $blue->distance({h =>230, s => 90, l=>40}, 'Hue'),  10, 'correct hue distance between own hsl blue and blue, long name');
is(     $blue->distance({h =>230, s => 90, l=>40}, 'h'),    10, 'correct hue distance between own hsl blue and blue');
is(     $blue->distance({h =>230, s => 90, l=>40}, 's'),    10, 'correct sturation distance between own hsl blue and blue');
is(     $blue->distance({h =>230, s => 90, l=>40}, 'Sat'),  10, 'correct sturation distance between own hsl blue and blue, long name');
is(     $blue->distance({h =>230, s => 90, l=>40}, 'l'),    10, 'correct lightness distance between own hsl blue and blue');
is(     $blue->distance({h =>230, s => 90, l=>40}, 'Light'),10, 'correct lightness distance between own hsl blue and blue, long name');
is( int $blue->distance({h =>230, s => 90, l=>40}, 'hs'),   14, 'correct hs distance between own hsl blue and blue');
is( int $blue->distance({h =>230, s => 90, l=>40}, 'hl'),   14, 'correct hl distance between own hsl blue and blue');
is( int $blue->distance({h =>230, s => 90, l=>40}, 'sl'),   14, 'correct sl distance between own hsl blue and blue');
is( int $blue->distance({h =>230, s => 90, l=>40}, 'rgb'),  74, 'correct rgb distance between own hsl blue and blue');
is( int $blue->distance({h =>230, s => 90, l=>40}, 'Red'),  10, 'correct red distance between own hsl blue and blue, long name');
is( int $blue->distance({h =>230, s => 90, l=>40}, 'r'),    10, 'correct red distance between own hsl blue and blue');
is( int $blue->distance({h =>230, s => 90, l=>40}, 'Green'),41, 'correct green distance between own hsl blue and blue, long name');
is( int $blue->distance({h =>230, s => 90, l=>40}, 'g'),    41, 'correct green distance between own hsl blue and blue');
is( int $blue->distance({h =>230, s => 90, l=>40}, 'Blue'), 61, 'correct blue distance between own hsl blue and blue, long name');
is( int $blue->distance({h =>230, s => 90, l=>40}, 'b'),    61, 'correct blue distance between own hsl blue and blue');
is( int $blue->distance({h =>230, s => 90, l=>40}, 'rg'),   42, 'correct rg distance between own hsl blue and blue');
is( int $blue->distance({h =>230, s => 90, l=>40}, 'rb'),   61, 'correct rb distance between own hsl blue and blue');
is( int $blue->distance({h =>230, s => 90, l=>40}, 'gb'),   73, 'correct gb distance between own hsl blue and blue');

$red = Chart::Color->new('#FF0000');
warning_like {$red->add()}                    {carped => qr/argument options/},"need argument to add to color object";
warning_like {$red->add('weirdcolorname')}    {carped => qr/unknown color/},   "accept only known color names";
warning_like {$red->add('#23232')       }     {carped => qr/has not length/},  "hex definition too short";
warning_like {$red->add('#232321f')     }     {carped => qr/has not length/},  "hex definition too long";
warning_like {$red->add(1,1)}                 {carped => qr/wrong number/},    "too few positional args";
warning_like {$red->add(1,1,1,1)}             {carped => qr/wrong number/},    "too many positional args";
warning_like {$red->add([1,1])}               {carped => qr/wrong number/},    "too few positional args in ref";
warning_like {$red->add([1,1,1,1])}           {carped => qr/wrong number/},    "too many positional args in ref";
warning_like {$red->add(r=>1,g=>1,t=>1)}      {carped => qr/unknown hash key/},   "don't invent named args";
warning_like {$red->add({r=>1,g=>1,t=>1})}    {carped => qr/unknown hash key/},   "don't invent named args, in ref";

my $white = Chart::Color->new('white');
my $black = Chart::Color->new('black');

is( $white->add( 255, 255, 255 )->name,          'white',   "it can't get whiter than white with additive color adding");
is( $white->add( {Hue => 10} )->name,            'white',   "hue doesnt change when were on level white");
is( $white->add( {Red => 10} )->name,            'white',   "hue doesnt change when adding red on white");
is( $white->add( $white )->name,                 'white',   "adding white on white is still white");
is( $red->add( $black )->name,                     'red',   "red + black = red");
is( $red->add( $black, -1 )->name,                 'red',   "red - black = red");
is( $white->add( $red, -1 )->name,                'aqua',   "white - red = aqua");
is( $white->add( $white, -0.5 )->name,            'gray',   "white - 0.5 white = grey");
is( Chart::Color->new(1,2,3)->add( 2,1,0)->name, 'gray1',   "adding positional args"); # = 3, 3, 3
is( $white->add( {Lightness => -10} )->name,    'gray90',   "dimming white 10%");
is( $black->add( {Red => 255} )->name,             'red',   "creating pure red from black");
is( $black->add( {  b => 255} )->name,            'blue',   "creating pure blue from black with short name");


exit 0;

__END__

add

blend

gradient

complementary

use  Chart::Color;
my $cn = 'grey';
my $ct = Chart::Color->new( Chart::Color::Named::rgb( $cn ) );
#say $ct->hsl;
for my $name (@names) {
    next if $name eq $cn;
    say ' - ', 100*$ct->distance_hsl($name) / $ct->distance_rgb($name),' - ', $name, ;
}
