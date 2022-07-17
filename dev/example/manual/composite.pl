use v5.12;
use warnings;
BEGIN { unshift @INC, 'lib', '../../../lib'}

use Chart::Composite;

my $g = Chart::Composite->new( );
$g->add_dataset( 1,   2,   3 );
$g->add_dataset( 10,  20,  30 );
$g->add_dataset( 15,  25,  32 );
$g->add_dataset( 7,   24,  23 );
$g->add_dataset( 5.1, 7.5, 9.9 );

$g->set(
    title          => 'Composite Chart',
    composite_info => [ [ 'Bars', [ 1, 2 ] ], [ 'LinesPoints', [ 3, 4 ] ] ],
    include_zero   => 'true',
    precision      => 0,
    colors  => {
        dataset3     => 'darkorange',
    }
);

$g->png("composite.png");

