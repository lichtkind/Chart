use v5.18;
use GD;
use Cwd;
use Memory::Usage;

my $png_file = 'cavas.png';

my $font_file = './font/unifont.fnt';
my $agenda    = './font/AGENDA-L.ttf';
my $bkl       = './font/BKL_CE.ttf';
my $gothic    = './font/CenturyGothic.ttf';
my $copper    = './font/CopperplateCondensedSSiCondensed.ttf';
my $futurama  = './font/FUTURAM.ttf';


my $im = GD::Image->new(200,200);
my $white = $im->colorAllocate( 255, 255, 255);
my $black = $im->colorAllocate(   0,   0,   0);
my $blue  = $im->colorAllocate(  40,  40, 160);
my $mu = Memory::Usage->new();


say "GD Version ".GD::VERSION_STRING." in Module $GD::VERSION \n";
say "Image object: $im with colors: ", $im->colorsTotal;

#$ENV{GDFONTPATH} = getcwd;
#say "fontpath: ",$ENV{GDFONTPATH};
#say $font_file,' exists: ', -e $font_file;
#my $unifont =  GD::Font->load( $font_file ) or die "Can't load font";
#say $unifont;

$mu->record('starting work');
 
my @bounds = $im->stringFT(2, $agenda,   11, 0, 30,  30,   'agenda');
$mu->record('1st');
             $im->stringFT(2, $bkl,      11, 0, 30,  50,   'bkl');
$mu->record('2st');
             $im->stringFT(2, $gothic,   11, 0, 30,  70,   'gothic');
$mu->record('3st');
             $im->stringFT(2, $copper,   11, 0, 30,  90,   'copper');
$mu->record('4st');
             $im->stringFT(2, $futurama, 11, 0, 30, 110,   'futurama');
$mu->record('5st');
             $im->stringFT(2, $agenda,   11, 0, 30, 130,   'agenda');
$mu->record('5st');

my ($x1, $y1, $x2, $y2, $x3, $y3, $x4, $y4) = @bounds;

#say $agenda if -r $font_file;

open my $FH, '>', $png_file;
binmode $FH;
print $FH $im->png( 0 );
close $FH;

$mu->dump();


__END__
 
 stringFTCircle($cx,$cy,$radius,$textRadius,$fillPortion,$font,$points,$top,$bottom,$fgcolor)
 $image->stringFT($fgcolor,$fontname,$ptsize,$angle,$x,$y,$string,[\%options])

fnt are different, older format than fft
