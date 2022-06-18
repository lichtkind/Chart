use v5.18;
use GD;
use utf8;

my $png_file = 'simple.png';

my $im = GD::Image->new(200,200);
my $white = $im->colorAllocate( 255, 255, 255);
my $black = $im->colorAllocate(   0,   0,   0);
my $blue  = $im->colorAllocate(  40,  40, 160);

$im->string( GD::Font->Tiny ,       20,  20, 'Tiny äöü 艾勒',       2);
$im->string( GD::Font->Small ,      20,  50, 'Small äöü 艾勒',      1);
$im->string( GD::Font->MediumBold , 20,  80, 'MediumBold', 2);
$im->string( GD::Font->Large ,      20, 110, 'Large',      1);
$im->string( GD::Font->Giant ,      20, 140, 'Giant',      2);

say "GD C lib Version ".GD::VERSION_STRING." in Module GD $GD::VERSION";
say "Image object: $im with colors: ", $im->colorsTotal;
say ;
say " smallest font has size: ",GD::Font->Tiny->width,' x ',GD::Font->Tiny->height;
say " largest font has size: ",GD::Font->Giant->width,' x ',GD::Font->Giant->height;
say " default font chars start with ASCII: ",GD::Font->Small->offset;
say " default font number of chars: ",GD::Font->Small->nchars;


open my $FH, '>', $png_file;
binmode $FH;
print $FH $im->png( my $comprssion = 1);
close $FH;

__END__
$index = $image->getPixel(x,y) 
($red,$green,$blue) = $image->rgb($index)
($alpha) = $image->alpha($index)
$image->transparent($colorIndex) set trasparent

 $index = $image->colorAllocateAlpha(reg,green,blue,alpha)
 $image->colorDeallocate(colorIndex)
 $index = $image->colorClosest(red,green,blue)
 $index = $image->colorClosestAlpha(red,green,blue,alpha)
 $index = $image->colorExact(red,green,blue)

