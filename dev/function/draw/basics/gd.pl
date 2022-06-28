use v5.18;
use GD;

my $file = 'GD_primitives';

my $im = GD::Image->new(150,150);
my $white = $im->colorAllocate( 255, 255, 255);
my $black = $im->colorAllocate(   0,   0,   0);
my $blue  = $im->colorAllocate(  40,  40, 160);


say "GD Version ".GD::VERSION_STRING." in Module $GD::VERSION";

$im->setPixel(10, 10, 2);
$im->line (22, 10, 27, 10, 2);
$im->rectangle (5,5, 15, 15, 2);
$im->filledRectangle(35, 5, 45, 15, 2);
$im->ellipse(       10, 30, 10, 15, 2);
$im->filledEllipse( 40, 30, 10, 15, 2);
$im->arc(       10, 55, 17, 25, 0, 120, 2);
$im->arc(       10, 80, 17, 25, 0, 220, 2);
$im->filledArc( 40, 55, 17, 25, 0, 120, 2);
$im->filledArc( 40, 80, 17, 25, 0, 220, 2);

my $poly = GD::Polygon->new;
$poly->addPt(60, 25);
$poly->addPt(70, 10);
$poly->addPt(80, 15);
$poly->addPt(90, 10);
$poly->addPt(90, 40);
$im->openPolygon($poly, 2);

my $poly = GD::Polygon->new;
$poly->addPt(110, 25);
$poly->addPt(120,  10);
$poly->addPt(130,  15);
$poly->addPt(140,  10);
$poly->addPt(140,  40);
$im->filledPolygon($poly, 2);


$im->string( GD::Font->Large ,     10, 130, 'Text äöü',      2);


open my $FH, '>', $file.'.png';
binmode $FH;
print $FH $im->png(0);
close $FH;

open my $FH, '>', $file.'.jpg';
binmode $FH;
print $FH $im->jpeg(100);
close $FH;

say "wrote: $file.png with colors: ", $im->colorsTotal;
say "this shouls be 2: ", $im->getPixel(10, 10);# self drawn px
say "this shouls be 0: ", $im->alpha(2);        # blue is opaque
