use v5.12;
use warnings;
BEGIN { unshift @INC, 'lib', '../../../lib'}
use Chart::Lines;

my $g = Chart::Lines->new( 600, 400 );
$g->add_dataset( 'foo', 'bar', 'whee', 'ding', 'bat',    'bit' );
$g->add_dataset(  3.2,  4.34, 9.456,  10.459, 11.24234, 14.0234 );
$g->add_dataset( -1.3,   8.4,  5.34,   3.234,     4.33, 13.09 );
$g->add_dataset(    5,     7,     2,      10,       12,  2.3445 );

$g->set( 
    title        => 'Lines Chart',
    legend       => 'bottom' ,
    y_label      => 'y label 1',
    precision    =>  0,
    y_grid_lines => 'true',
    colors       => {
        y_label      => 'orangepeel',
        y_grid_lines => [ 190, 190, 190 ],
        misc         => [ 100, 100, 100 ],
    },
);

$g->png("lines.png");


