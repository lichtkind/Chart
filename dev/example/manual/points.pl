use v5.12;
use warnings;
BEGIN { unshift @INC, 'lib', '../../../lib'}

use Chart::Points;

my $g = Chart::Points->new();
$g->add_dataset( 'foo', 'bar', 'junk' );
$g->add_dataset(  3,  4,  9 );
$g->add_dataset(  8,  6,  0 );
$g->add_dataset(  5,  7,  2 );
$g->add_pt( 'dat',  1,  5, 7 );

$g->set(
    title        => 'Points Chart',
    pt_size      => 18,
    precision    =>  0,
    grid_lines   => 'true',
    png_border   => 10,
    colors => {
        grid_lines => 'gray70',

    },
);

$g->png("points.png");

