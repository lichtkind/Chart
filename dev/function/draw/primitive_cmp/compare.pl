use v5.18;
use GD;
use SVG;
use Cwd;
use Memory::Usage;


__END__

point
circle
line
rectangle
polyline
text

use v5.18;
use GD;

my $png_file = 'GD_primitives.png';

my $im = GD::Image->new(500,500);
my $white = $im->colorAllocate( 255, 255, 255);
my $black = $im->colorAllocate(   0,   0,   0);
my $blue  = $im->colorAllocate(  40,  40, 160);


say "GD Version ".GD::VERSION_STRING." in Module $GD::VERSION \n";
say "Image object: $im with colors: ", $im->colorsTotal;
say "  index of first color: ", $im->colorExact( 255, 255, 255);
say "  index of last color: ",  $im->colorClosest( 50, 50, 150);
say "  index of no color: ",    $im->colorExact( 50, 50, 150);


$im->string( GD::Font->Large ,      20, 110, 'Text',      1);

open my $FH, '>', $png_file;
binmode $FH;
print $FH $im->png( 1);
close $FH;

#$index = $image->getPixel(x,y) 
#($red,$green,$blue) = $image->rgb($index)
#($alpha) = $image->alpha($index)
#$image->transparent($colorIndex)

#$colorsTotal = $image->colorsTotal object method
# $index = $image->colorAllocate(red,green,blue)
# $index = $image->colorAllocateAlpha(reg,green,blue,alpha)
# $image->colorDeallocate(colorIndex)
# $index = $image->colorClosest(red,green,blue)
# $index = $image->colorClosestAlpha(red,green,blue,alpha)
# # $index = $image->colorExact(red,green,blue)

__END__

    

setPixel  ($x,$y,$color)
rectangle ($x1,$y1,$x2,$y2,$color)
filledRectangle($x1,$y1,$x2,$y2,$color) 
openPolygon($polygon,$color)
unclosedPolygon($polygon,$color)
filledPolygon($poly,$color)
ellipse($cx,$cy,$width,$height,$color)
filledEllipse($cx,$cy,$width,$height,$color)
arc($cx,$cy,$width,$height,$start,$end,$color)
filledArc($cx,$cy,$width,$height,$start,$end,$color [,$arc_style])
fill($x,$y,$color)
fillToBorder($x,$y,$bordercolor,$color)


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

