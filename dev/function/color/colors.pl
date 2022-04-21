use v5.12;

BEGIN { unshift @INC, '../../../lib'}

use GD;
use Chart::Color::Constant;

my $file_name = 'color_table';

my $ch = \%Chart::Color::Constant::rgbhsl;
my $font  = gdMediumBoldFont;
my ($rows, $cols) = (39, 5);

my ($row, $col, $image_nr, $black, $white) = (0, 0, 0);
my $im = new_image();

for my $name (sort keys %$ch){
    paint_color($im, $name, @{ $ch->{$name}}[0..2], $row, $col);
    $col++;
    if ($col == $cols){
        $col = 0;
        $row++;
    }
    if ($row == $rows){
        save_image( $im , $image_nr++);
        $im = new_image();
        ($row, $col) = (0, 0);
    }
}
save_image( $im , $image_nr++);


sub paint_color {
    my ($im, $name, $r, $g, $b, $row, $col) = @_;
    my $x = 15 + 155 * $col;
    my $y = 15 + 25 * $row;
    my $color = $im->colorAllocate( $r, $g, $b );
    $im->filledRectangle($x, $y, $x+20, $y + 10 , $color);
    $im->rectangle(      $x, $y, $x+20, $y + 10 , $black);
    $im->string( $font,  $x+30, $y, $name, $black );
}

sub new_image {
    my $im = GD::Image->new(800, 1000);
    $white = $im->colorAllocate(255,255,255); 
    $black = $im->colorAllocate(  0,  0,  0); 
    $im;
}

sub save_image {
    my ($im, $nr) = @_;
    open my $FH, '>', $file_name.$nr.'.png';
    binmode STDOUT;
    print $FH $im->png;
}

