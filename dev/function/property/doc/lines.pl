#!/usr/bin/perl -w
use v5.12;

BEGIN { unshift @INC, 'lib', '../../../lib'}
use Chart::Lines;

my $g = Chart::Lines->new( 700, 500 );
$g->add_dataset( 'foo', 'bar', 'whee', 'ding', 'bat',    'bit' );
$g->add_dataset( 3.2,   4.34,  9.456,  10.459, 11.24234, 14.0234 );
$g->add_dataset( -1.3,  8.4,   5.34,   3.234,  4.33,     13.09 );
$g->add_dataset( 5,     7,     2,      10,     12,       2.3445 );

$g->set( 'title'     => 'LINES' );
$g->set( 'sub_title' => 'Lines Chart' );
$g->set(
    'colors' => {
        y_label      => [   0,    0,  255 ],
        y_label2     => [   0,  255,    0 ],
        y_grid_lines => [ 127,  127,    0 ],
        dataset0     => [ 127,    0,    0 ],
        dataset1     => [   0,  127,    0 ],
        dataset2     => [   0,    0,  127 ],
        #background   => 'lightblue',
    },
    #grey_background =>  'false',
    integer_ticks_only => 1,
    graph_border => 30,
);
$g->set( 'y_label'      => 'y label 1' );
$g->set( 'y_label2'     => 'y label 2' );
$g->set( 'y_grid_lines' => 'true' );
$g->set( #'legend'       => 'bottom',
          legend_font   => GD::Font->Large,
          brush_size => 12,
          transparent => 'true',
          png_border => 100,
);

$g->png("lines.png");
