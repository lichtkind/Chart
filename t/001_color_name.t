use v5.12;
use warnings;
use Test::More tests => 18;

BEGIN { unshift @INC, 'lib', '../lib'}
my $module = 'Chart::Color::Named';

eval "use $module";
ok( not $@); # could load the module

my $get_name = \&Chart::Color::Named::name;
ok( $get_name->( 255,255,255 ) eq 'white');        # could get a color def
ok( $get_name->( 255, 215, 0 ) eq 'gold');         # selects shorter name

my $add_name = \&Chart::Color::Named::add;
my $taken    = \&Chart::Color::Named::name_taken;
ok( not ref $add_name->( 'one', 1, 1, ) );         # not enough args
ok( not ref $add_name->( 'one', 0, -1, 256 ) );    # bad values
ok( not $taken->('one') );                         # there is not color named "one"
ok( ref $add_name->( 'one', 1, 2, 3 ) eq 'ARRAY'); # could add color
ok( $get_name->( 1, 2, 3 ) eq 'one');              # retrieve added color
ok( $taken->('one') );                             # there is a color named "one"

my @names = Chart::Color::Named::all_names();
ok( @names > 700);                                 # get a large list of names

my @rgb = Chart::Color::Named::rgb('white');
ok( @rgb == 3);                                    # 'white' has 3 values
ok( $rgb[0] == 255);                               # 'white' has full red
ok( $rgb[1] == 255);                               # 'white' has full green
ok( $rgb[2] == 255);                               # 'white' has full blue
@rgb = Chart::Color::Named::rgb('one');
ok( @rgb == 3);                                    # 'one' has 3 values
ok( $rgb[0] == 1);                               # 'one' has little red
ok( $rgb[1] == 2);                               # 'one' has little green
ok( $rgb[2] == 3);                               # 'one' has little blue

exit 0;
