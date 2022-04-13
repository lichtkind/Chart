use v5.12;
use warnings;
use Test::More tests => 50;
use Test::Warn;
use Carp;

BEGIN { unshift @INC, 'lib', '../lib'}
my $module = 'Chart::Color::Value';

eval "use $module";
is( not($@), 1, 'could load the module');

my @names = Chart::Color::Value::all_names();
is( @names > 700, 1, 'get a large list of names, all_names seems to working');

my $add_rgb   = \&Chart::Color::Value::add_rgb;
my $add_hsl   = \&Chart::Color::Value::add_hsl;
my $taken     = \&Chart::Color::Value::name_taken;
my $get_name_rgb   = \&Chart::Color::Value::name_from_rgb;
my $get_name_hsl   = \&Chart::Color::Value::name_from_hsl;
my $get_name_range = \&Chart::Color::Value::names_in_hsl_range;


warning_like {$add_rgb->()} {carped => qr/color name missing/}, "can't get color without name";
warning_like {$add_rgb->( 'one',1,1)} {carped => qr/need exactly 3/}, 'not enough args to add color';


#warning_like {warn "need 3"}, qr/need 3/, 'not enough args to add color';
#warning_like {$add_rgb->( 'one', 1, 1)}, qr/need 3/, 'not enoughu args cought';




exit 0;


__END__


is( ref $add_rgb->( 'one', 0, -1, 256 ), '',   'bad values got cought' );
is( ref $add_rgb->( 'white', 0, 3, 22 ), '',   'there is already a white color' );
is( $taken->('one'), '',                        'there is not color named "one"' );
is( ref $add_rgb->( 'one', 1, 2, 3 ), 'ARRAY', 'could add color to store');
is( $get_name_rgb->( 1, 2, 3 ), 'one',          'retrieve added color' );
is( $taken->('one'), 1,                         'there is now a color named "one"' );
is( $taken->('One'), 1,                         'even there with different spelling');
is( ref $add_hsl->( 'lucky',0,100,50), 'ARRAY', 'added red under different name');
is( ref $add_hsl->( 'blob',14, 10,50), 'ARRAY', 'added color by hsl definition');

is( $get_name_rgb->( 255 ,255, 255 ), 'white',  'could get a color def');        
is( $get_name_rgb->( 255, 215,   0 ), 'gold',   'selects shorter name'); # instead of gold1
is( $get_name_rgb->( 255,   0,   0 ), 'red',    'selects shorter name instead of inserted'); # instead of lucky
is( $get_name_hsl->(0,100,  50 ), 'red',        'found red by hsl');
is( $get_name_hsl->(14,10,  50 ), 'blob',       'found inserted color by hsl');


my @rgb = Chart::Color::Value::rgb('white');
my @hsl = Chart::Color::Value::hsl('white');
my @all = Chart::Color::Value::rgbhsl('white');
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
@rgb = Chart::Color::Value::rgb('one');
@hsl = Chart::Color::Value::hsl('one');
is( int @rgb,  3,     'self defined color has rgb values');
is( $rgb[0],   1,     'self defined color has defined red value');
is( $rgb[1],   2,     'self defined color has defined full green value');
is( $rgb[2],   3,     'self defined color has defined full blue value');
is( $hsl[0], 210,     'self defined color has computed hue value');
is( $hsl[1],  50,     'self defined color has computed saturation');
is( $hsl[2],   1,     'self defined color has computed lightness');

@rgb = Chart::Color::Value::rgb('One');
is( int @rgb, 3,     'upper case gets cleaned');
@rgb = Chart::Color::Value::rgb('O_ne');
is( int @rgb, 3,     'under score gets cleaned');

#is( $get_range->(14,10, 50 ), 'blob',       'found inserted color by hsl');



use Memory::Usage;
my $mu = Memory::Usage->new();
 
# Record amount of memory used by current process
$mu->record('starting work');
 
# Do the thing you want to measure
$object->something_memory_intensive();
 
# Record amount in use afterwards
$mu->record('after something_memory_intensive()');
 
# Spit out a report
$mu->dump();
