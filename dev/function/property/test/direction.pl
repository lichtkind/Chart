#!/usr/bin/perl -w
use v5.12;

BEGIN { unshift @INC, 'lib', '../../../lib'}
use Chart::Direction;


my $g = Chart::Direction->new( 500, 500 );
my @labels = ( 'eins', 'zwei', 'drei', );

$g->add_dataset( 0,  10, 30, 100, 110, 200, 250, 300, 350 );
$g->add_dataset( 10, 4,  11, 40,  20,  35,  5,   45,  20 );
$g->add_dataset( 29, 49, 20, 17,  30,  42,  45,  25,  30 );
$g->add_dataset( 40, 35, 25, 30,  42,  20,  32,  16,  5 );
$g->set(
    'title'           => 'Direction Demo \n ------',
    'grey_background' => 'false',
    'line'            => 'true',
    'precision'       => 0,
    'legend_labels'   => \@labels,
    'legend'          => 'bottom',
     point => 'false',

     'polar' => 'false',
     arrow => 0,
     #angle_interval => 5,
     #legend => 'right',
     graph_border => 30,
);

$g->png("direction.png");

