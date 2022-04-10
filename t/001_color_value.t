use v5.12;
use warnings;
use Test::More tests => 25;

BEGIN { unshift @INC, 'lib', '../lib'}
my $module = 'Chart::Color::Value';

eval "use $module";
is( not($@), 1, 'could load the module');

my $get_name = \&Chart::Color::Value::name_from_rgb;
is( $get_name->( 255,255,255 ), 'white',        'could get a color def');        
is( $get_name->( 255, 215, 0 ), 'gold',         'selects shorter name'); # instead of gold1

my $add_name = \&Chart::Color::Value::add_rgb;
my $taken    = \&Chart::Color::Value::name_taken;
is( ref $add_name->( 'one', 1, 1, ), '',        'not enough args got caught' );
is( ref $add_name->( 'one', 0, -1, 256 ), '',   'bad values got cought' );
is( $taken->('one'), '',                        'there is not color named "one"' );
is( ref $add_name->( 'one', 1, 2, 3 ), 'ARRAY', 'could add color to sotre');
is( $get_name->( 1, 2, 3 ), 'one',              'retrieve added color' );
is( $taken->('one'), 1,                         'there is now a color named "one"' );
is( $taken->('One'), 1,                         'even there with different spelling');

my @names = Chart::Color::Value::all_names();
is( @names > 700, 1, 'get a large list of names, all_names seems to working');

my @rgb = Chart::Color::Value::rgb('white');
my @hsl = Chart::Color::Value::hsl('white');
is( int @rgb, 3,     'white has 3 rgb values');
is( $rgb[0], 255,    'white has full red value');
is( $rgb[1], 255,    'white has full green value');
is( $rgb[2], 255,    'white has full blue value');
is( int @hsl, 3,     'white has 3 hsl values');
is( $hsl[0],   0,    'white has zero hue value');
is( $hsl[1],   0,    'white has zero sat value');
is( $hsl[2], 100,    'white has full light value');
@rgb = Chart::Color::Value::rgb('one');
is( int @rgb, 3,     'self defined color has rgb values');
is( $rgb[0],  1,     'self defined color has defined red value');
is( $rgb[1],  2,     'self defined color has defined full green value');
is( $rgb[2],  3,     'self defined color has defined full blue value');

@rgb = Chart::Color::Value::rgb('One');
is( int @rgb, 3,     'upper case gets cleaned');
@rgb = Chart::Color::Value::rgb('O_ne');
is( int @rgb, 3,     'under score gets cleaned');

exit 0;
