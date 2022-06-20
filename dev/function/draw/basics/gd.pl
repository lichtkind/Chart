use v5.18;
use GD;

my $png_file = 'GD_primitives.png';

my $im = GD::Image->new(100,100);
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

$im->string( GD::Font->Large ,     60, 2, 'Text',      2);

open my $FH, '>', $png_file;
binmode $FH;
print $FH $im->png( 1);
close $FH;
say "wrote: $png_file with colors: ", $im->colorsTotal;
say "this shouls be 2: ", $im->getPixel(10, 10);# self drawn px
say "this shouls be 0: ", $im->alpha(2);        # blue is opaque


__END__
fill($x,$y,$color)
fillToBorder($x,$y,$bordercolor,$color)

$image->transparent($colorIndex)
$index = $image->colorAllocate(red,green,blue)
$index = $image->colorAllocateAlpha(reg,green,blue,alpha)
$image->colorDeallocate(colorIndex)
$index = $image->colorClosest(red,green,blue)
$index = $image->colorClosestAlpha(red,green,blue,alpha)
$index = $image->colorExact(red,green,blue)

GD_BELL                - Bell
GD_BESSEL              - Bessel
GD_BILINEAR_FIXED      - fixed point bilinear
GD_BICUBIC             - Bicubic
GD_BICUBIC_FIXED       - fixed point bicubic integer
GD_BLACKMAN            - Blackman
GD_BOX                 - Box
GD_BSPLINE             - BSpline
GD_CATMULLROM          - Catmullrom
GD_GAUSSIAN            - Gaussian
GD_GENERALIZED_CUBIC   - Generalized cubic
GD_HERMITE             - Hermite
GD_HAMMING             - Hamming
GD_HANNING             - Hannig
GD_MITCHELL            - Mitchell
GD_NEAREST_NEIGHBOUR   - Nearest neighbour interpolation
GD_POWER               - Power
GD_QUADRATIC           - Quadratic
GD_SINC                - Sinc
GD_TRIANGLE            - Triangle
GD_WEIGHTED4           - 4 pixels weighted bilinear interpolation
GD_LINEAR              - bilinear interpolation

$image->interpolationMethod( [$method] )

$im->selectiveBlur()
$im->edgeDetectQuick()
$im->gaussianBlur()
$im->emboss()
$im->meanRemoval()
$im->smooth($weight)
$im = $sourceImage->copyGaussianBlurred($radius, $sigma)


$image->openPolygon($polygon,$color)

    This draws a polygon with the specified color. The polygon must be created first (see below). The polygon must have at least three vertices. If the last vertex doesn't close the polygon, the method will close it for you. Both real color indexes and the special colors gdBrushed, gdStyled and gdStyledBrushed can be specified.

    Example:

    $poly = GD::Polygon->new;
    $poly->addPt(50,0);
    $poly->addPt(99,99);
    $poly->addPt(0,99);
    $myImage->openPolygon($poly,$blue);

$image->unclosedPolygon($polygon,$color)

    This draws a sequence of connected lines with the specified color, without connecting the first and last point to a closed polygon. The polygon must be created first (see below). The polygon must have at least three vertices. Both real color indexes and the special colors gdBrushed, gdStyled and gdStyledBrushed can be specified.

    You need libgd 2.0.33 or higher to use this feature.

    Example:

    $poly = GD::Polygon->new;
    $poly->addPt(50,0);
    $poly->addPt(99,99);
    $poly->addPt(0,99);
    $myImage->unclosedPolygon($poly,$blue);

$image->filledPolygon($poly,$color)

    This draws a polygon filled with the specified color. You can use a real color, or the special fill color gdTiled to fill the polygon with a pattern.

    Example:

    # make a polygon
    $poly = GD::Polygon->new;
    $poly->addPt(50,0);
    $poly->addPt(99,99);
    $poly->addPt(0,99);
     
    # draw the polygon, filling it with a color
    $myImage->filledPolygon($poly,$peachpuff);
