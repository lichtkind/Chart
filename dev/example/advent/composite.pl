use v5.12;
use warnings;
BEGIN { unshift @INC, 'lib', '../../../lib'}

use Chart::Composite;

my $g = Chart::Composite->new( );
$g->add_dataset( 1,   2,   3 );
$g->add_dataset( 50,  50,  50 );
$g->add_dataset( 500,  500,   9.9 );
$g->add_dataset( 15,  25,  12 );
$g->add_dataset( 7,   24,  23 );

$g->set(
    title          => 'Composite Chart',
    composite_info => [ 
                        [ 'Lines' ,      [ 1    ] ],
                        [ 'Points',      [ 2,   ] ],
#                        [ 'StackedBars', [ 3, 4 ] ], 
],
    include_zero   => 'true',
    precision      => 0,
    max_val1       => 60,
    max_val2       => 60,
    colors  => {
        dataset1     => 'green',
        dataset3     => 'darkorange',
    }
);

$g->png("composite.png");

