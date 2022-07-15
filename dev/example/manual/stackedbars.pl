use v5.12;
use warnings;
BEGIN { unshift @INC, 'lib', '../../../lib'}
use Chart::StackedBars;

my $g = Chart::StackedBars->new( 600, 400 );
$g->add_dataset( 'camel', 'dromedar', 'llama', 'vicuna');
$g->add_dataset( 3, 4,  9,  10,  );
$g->add_dataset( 8, 6,  1,  12,  );
$g->add_dataset( 5, 7,  2,  13,  );

$g->set(
    'title'           => 'Stacked Bars',
    'legend'          => 'left',
     precision        =>  0,
    'grey_background' => 'false',
        colors => {
         x_grid_lines => 'gray70',
         misc         => 'gray55',
         text         => 'gray55',
         x_label      => 'gray40',
         y_label      => 'gray40',
         title        => 'gray20',
     }
);

$g->png("stackedbars.png");

