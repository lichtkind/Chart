use v5.12;
use warnings;
use Test::More tests => 95;
use Test::Warn;
use Carp;

BEGIN { unshift @INC, 'lib', '../lib'}
my $module = 'Chart::Color::Value';

eval "use $module";
is( not($@), 1, 'could load the module');

my @names = Chart::Color::Value::all_names();
is( @names > 700, 1, 'get a large list of names, all_names seems to working');

my $d_rgb          = \&Chart::Color::Value::distance_rgb;
my $d_hsl          = \&Chart::Color::Value::distance_hsl;
my $add_rgb        = \&Chart::Color::Value::add_rgb;
my $add_hsl        = \&Chart::Color::Value::add_hsl;
my $taken          = \&Chart::Color::Value::name_taken;
my $get_name_rgb   = \&Chart::Color::Value::name_from_rgb;
my $get_name_hsl   = \&Chart::Color::Value::name_from_hsl;
my $get_name_range = \&Chart::Color::Value::names_in_hsl_range;

warning_like {Chart::Color::Value::hsl_from_rgb(1,1,1,1)} {carped => qr/3 positive integer/},
                                                      "need 3 values rgb to convert color from rgb to hsl";
warning_like {Chart::Color::Value::hsl_from_rgb(1,1)} {carped => qr/3 positive integer/},
                                                      "need 3 values rgb to convert color from rgb to hsl";
warning_like {Chart::Color::Value::hsl_from_rgb(1,1,-1)} {carped => qr/blue value/},
                                                      "blue value is too small for conversion";
warning_like {Chart::Color::Value::hsl_from_rgb(256,1,0)} {carped => qr/red value/},
                                                      "red value is too large for conversion";
warning_like {Chart::Color::Value::rgb_from_hsl(1,1)} {carped => qr/3 positive integer/},
                                                      "need 3 values rgb to convert color from rgb to hsl";

my @hsl = Chart::Color::Value::hsl_from_rgb(127, 127, 127);
is( int @hsl,  3,     'converted color grey has hsl values');
is( $hsl[0],   0,     'converted color grey has computed right hue value');
is( $hsl[1],   0,     'converted color grey has computed right saturation');
is( $hsl[2],  50,     'converted color grey has computed right lightness');

my @rgb = Chart::Color::Value::rgb_from_hsl(0, 0, 50);
is( int @rgb,  3,     'converted back color grey has rgb values');
is( $rgb[0], 127,     'converted back color grey has right red value');
is( $rgb[1], 127,     'converted back color grey has right green value');
is( $rgb[2], 127,     'converted back color grey has right blue value');

warning_like {$d_rgb->()}                         {carped => qr/two triplets/},"can't get distance without rgb values";
warning_like {$d_rgb->( [1,1,1],[1,1,1],[1,1,1])} {carped => qr/two triplets/},'too many array arg';
warning_like {$d_rgb->( [1,2],[1,2,3])} {carped => qr/exactly 3/},             'first color is missing a value';
warning_like {$d_rgb->( [1,2,3],[2,3])} {carped => qr/exactly 3/},             'second color is missing a value';
warning_like {$d_rgb->( [-1,2,3],[1,2,3])} {carped => qr/red value/},          'first red value is too small';
warning_like {$d_rgb->( [1,2,3],[2,256,3])} {carped => qr/green value/},       'second green value is too large';
warning_like {$d_rgb->( [1,2,-3],[2,25,3])} {carped => qr/blue value/},        'first blue value is too large';
warning_like {$d_hsl->( []) }                     {carped => qr/two triplets/},"can't get distance without hsl values";
warning_like {$d_hsl->( [1,1,1],[1,1,1],[1,1,1])} {carped => qr/two triplets/},'too many array arg';
warning_like {$d_hsl->( [1,2],[1,2,3])} {carped => qr/exactly 3/},             'first color is missing a value';
warning_like {$d_hsl->( [1,2,3],[2,3])} {carped => qr/exactly 3/},             'second color is missing a value';
warning_like {$d_hsl->( [-1,2,3],[1,2,3])} {carped => qr/hue value/},          'first hue value is too small';
warning_like {$d_hsl->( [1,2,3],[360,2,3])} {carped => qr/hue value/},         'second hue value is too large';
warning_like {$d_hsl->( [1,-1,3],[2,10,3])} {carped => qr/saturation value/},  'first saturation value is too small';
warning_like {$d_hsl->( [1,2,3],[2,101,3])} {carped => qr/saturation value/},  'second saturation value is too large';
warning_like {$d_hsl->( [1,1,-1],[2,10,3])} {carped => qr/lightness value/},   'first lightness value is too small';
warning_like {$d_hsl->( [1,2,3],[2,1,101])} {carped => qr/lightness value/},   'second lightness value is too large';

is( Chart::Color::Value::distance_rgb([1, 2, 3], [  2, 6, 11]), 9,     'compute rgb distance');
is( Chart::Color::Value::distance_hsl([1, 2, 3], [  2, 6, 11]), 9,     'compute hsl distance');
is( Chart::Color::Value::distance_hsl([0, 2, 3], [359, 6, 11]), 9,     'compute hsl distance (test circular property of hsl)');

warning_like {$add_rgb->()} {carped => qr/missing first arg/},          "can't get color without name";
warning_like {$add_rgb->( 'one',1,1)}    {carped => qr/need exactly 3/},'not enough args to add color';
warning_like {$add_rgb->( 'one', 0, -1, 25)} {carped => qr/green/},     'too small green value got cought';
warning_like {$add_rgb->( 'one', 0, 1, 256)} {carped => qr/blue/},      'too large blue value got cought';
warning_like {$add_rgb->( 'white', 0, 3, 22 )} {carped => qr/already/}, 'got cought overwriting white';

is( $taken->('one'), '',                        'there is not color named "one"' );
is( ref $add_rgb->('one', 1, 2, 3 ),  'ARRAY',  'could add color to store');
is( $get_name_rgb->( 1, 2, 3 ), 'one',          'retrieve added color' );
is( $taken->('one'), 1,                         'there is now a color named "one"' );
is( $taken->('One'), 1,                         'even there with different spelling');
is( ref $add_hsl->('lucky', 0,100, 50),'ARRAY', 'added red under different name');
is( ref $add_hsl->('blob', 14, 10, 50),'ARRAY', 'added color by hsl definition');

is( $get_name_rgb->( 255 ,255, 255 ), 'white',       'could get a color def');        
is( scalar $get_name_rgb->( 255, 215,   0 ), 'gold', 'selects shorter name: gold instead of gold1');
is( scalar $get_name_rgb->( [255, 215,   0]),'gold', 'array ref arg format works too');
is( scalar $get_name_rgb->( 255,   0,   0 ), 'red',  'selects shorter name red instead of inserted lucky');
is( $get_name_hsl->(  0, 100,  50 ), 'red',          'found red by hsl');
is( $get_name_hsl->( 14,  10,  50 ), 'blob',         'found inserted color by hsl');

@rgb = Chart::Color::Value::rgb_from_name('white');
@hsl = Chart::Color::Value::hsl_from_name('white');
my @all = Chart::Color::Value::rgbhsl_from_name('white');
is( int @rgb,  3,     'white has 3 rgb values');
is( $rgb[0], 255,     'white has full red value');
is( $rgb[1], 255,     'white has full green value');
is( $rgb[2], 255,     'white has full blue value');
is( int @hsl,  3,     'white has 3 hsl values');
is( $hsl[0],   0,     'white has zero hue value');
is( $hsl[1],   0,     'white has zero sat value');
is( $hsl[2], 100,     'white has full light value');
is( int @all,  6,     'white has 6 values');
is( $all[0], 255,     'white has full red value');
is( $all[1], 255,     'white has full green value');
is( $all[2], 255,     'white has full blue value');
is( $all[3],   0,     'white has zero hue value');
is( $all[4],   0,     'white has zero sat value');
is( $all[5], 100,     'white has full light value');

@rgb = Chart::Color::Value::rgb_from_name('one');
@hsl = Chart::Color::Value::hsl_from_name('one');
is( int @rgb,  3,     'self defined color has rgb values');
is( $rgb[0],   1,     'self defined color has defined red value');
is( $rgb[1],   2,     'self defined color has defined full green value');
is( $rgb[2],   3,     'self defined color has defined full blue value');
is( int @hsl,  3,     'self defined color has hsl values');
is( $hsl[0], 210,     'self defined color has computed hue value');
is( $hsl[1],  50,     'self defined color has computed saturation');
is( $hsl[2],   1,     'self defined color has computed lightness');

@rgb = Chart::Color::Value::rgb_from_name('One');
is( int @rgb, 3,     'upper case gets cleaned from color name');
@rgb = Chart::Color::Value::rgb_from_name('O_ne');
is( int @rgb, 3,     'under score gets cleaned from color name');

warning_like{ $get_name_range->( []) }                     {carped => qr/two arguments/},"can't get names in range without hsl values";
warning_like{ $get_name_range->( [1,1,1],[1,1,1],[1,1,1])} {carped => qr/two arguments/},'too many array arg';
warning_like{ $get_name_range->( [1,2],[1,2,3])}           {carped => qr/first argument/},'range center is missing a value';
warning_like{ $get_name_range->( [1,2,3],[2,3])}     {carped => qr/second argument/},    'tolerances are missing a value';
warning_like{ $get_name_range->( [-1,2,3],[1,2,3])}  {carped => qr/hue value/},          'first value of search center is too small';
warning_like{ $get_name_range->( [360,2,3],[1,2,3])} {carped => qr/hue value/},          'first value of search center is too large';
warning_like{ $get_name_range->( [1,-1,3],[2,10,3])} {carped => qr/saturation value/},  'saturation center value is too small';
warning_like{ $get_name_range->( [1,101,3],[2,1,3])} {carped => qr/saturation value/},  'saturation center value is too large';
warning_like{ $get_name_range->( [1,1,-1],[2,10,3])} {carped => qr/lightness value/},   'first lightness value is too small';
warning_like{ $get_name_range->( [1,2,101],[2,1,1])} {carped => qr/lightness value/},   'second lightness value is too large';

@names = $get_name_range->( [0, 0, 100], 0);
is( int @names, 1,          'only one color has distance of 0 to white');
is( $names[0], 'white',     'only white has distance of 0 to white');

@names = sort $get_name_range->( [0, 0, 100], 5);
is( int @names, 6,             '6 colors are in short distance to white');
is( $names[-1], 'whitesmoke',  'whitesmoke is near to white');

my @morenames = sort $get_name_range->( [0, 0, 100], 10);
is( @names < @morenames, 1,  'bigger radius has to catch more colors');

@names = sort $get_name_range->( [240, 100, 50], [10, 20, 30]);
is( $names[5], 'navy',       'navy is a shade of blue');

@names = sort $get_name_range->( [240, 100, 50], [100, 5, 5]);
is( $names[0], 'aqua',       'aqua is a bluish color with high saturation and medium lightness');

#say for @names;
#say scalar  $get_name_hsl->(240, 100, 50);

exit 0;


__END__


#is( $get_name_range->(14,10, 50 ), 'blob',       'found inserted color by hsl');



use Memory::Usage;
my $mu = Memory::Usage->new();
$mu->record('starting work');
eval "use $module";
$mu->record('after ');
eval "use GD;";
$mu->record('GD ');
$mu->dump();
