use v5.18;
use GD;

my $png_file = 'cavas.png';

my $im = GD::Image->new(200,200);
my $white = $im->colorAllocate( 255, 255, 255);
my $black = $im->colorAllocate(   0,   0,   0);
my $blue  = $im->colorAllocate(  40,  40, 160);

$im->string( GD::Font->Tiny ,       20,  20, 'Tiny',       2);
$im->string( GD::Font->Small ,      20,  50, 'Small',      1);
$im->string( GD::Font->MediumBold , 20,  80, 'MediumBold', 2);
$im->string( GD::Font->Large ,      20, 110, 'Large',      1);
$im->string( GD::Font->Giant ,      20, 140, 'Giant',      2);

say "GD Version ".GD::VERSION_STRING." in Module $GD::VERSION \n";
say "Image object: $im with colors: ", $im->colorsTotal;
say "  index of first color: ", $im->colorExact( 255, 255, 255);
say "  index of last color: ",  $im->colorClosest( 50, 50, 150);
say "  index of no color: ",    $im->colorExact( 50, 50, 150);
say GD::Font->Small->nchars;
say GD::Font->Small->offset;


open my $FH, '>', $png_file;
binmode $FH;
print $FH $im->png( 1);
#print $FH $im->png();
#close $FH;

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

    
$font->nchars       This returns the number of characters in the font.
$font->offset       This returns the ASCII value of the first character in the font

    ($w,$h) = (gdLargeFont->width,gdLargeFont->height);


$font = GD::Font->load($fontfilepath)

@bounds = $image->stringFT($fgcolor,$fontname,$ptsize,$angle,$x,$y,$string)
@bounds = GD::Image->stringFT($fgcolor,$fontname,$ptsize,$angle,$x,$y,$string)
@bounds = $image->stringFT($fgcolor,$fontname,$ptsize,$angle,$x,$y,$string,\%options)

$ENV{GDFONTPATH}
