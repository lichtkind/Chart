use v5.18;
use GD;
use Cwd;
use Memory::Usage;

my $png_file = 'unifont.png';

my $font = './unifont14.ttf';


my $im = GD::Image->new(600, 600);
my $white = $im->colorAllocate( 255, 255, 255);
my $black = $im->colorAllocate(   0,   0,   0);
my $blue  = $im->colorAllocate(  40,  40, 160);
my $mu = Memory::Usage->new();


say "GD Version ".GD::VERSION_STRING." in Module $GD::VERSION";
say "Image object: $im with colors: ", $im->colorsTotal;

$mu->record('starting work');
my @bounds = $im->stringFT(2, $font,   13, 0, 30,  30,   'u n i f o n t  extra bold');
   @bounds = $im->stringFT(2, $font,   13, 0, 31,  30,   'u n i f o n t  extra bold');
   @bounds = $im->stringFT(2, $font,   13, 0, 32,  30,   'u n i f o n t  extra bold');
@bounds = $im->stringFT(2, $font,   13, 0, 30,  60,   'unifont bold');
@bounds = $im->stringFT(2, $font,   13, 0, 31,  60,   'unifont bold');
@bounds = $im->stringFT(2, $font,   13, 0, 30,  90,   'unifont');
$mu->record('1st');
@bounds = $im->stringFT(2, $font,   13, 0, 30,  120,   'äöü');
@bounds = $im->stringFT(2, $font,   13, 0, 30,  150,   '艾勒');
$mu->record('2st');

my ($x1, $y1, $x2, $y2, $x3, $y3, $x4, $y4) = @bounds;


open my $FH, '>', $png_file;
binmode $FH;
print $FH $im->png( 0 );
close $FH;

$mu->dump();


__END__
 
 stringFTCircle($cx,$cy,$radius,$textRadius,$fillPortion,$font,$points,$top,$bottom,$fgcolor)
 $image->stringFT($fgcolor,$fontname,$ptsize,$angle,$x,$y,$string,[\%options])

unifont-14.0.04
