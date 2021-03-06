#!/usr/bin/perl -w
use v5.12;

BEGIN { unshift @INC, 'lib', '../../../lib'}
use Chart::HorizontalBars;

my $g = Chart::HorizontalBars->new( 500, 400 );
$g->add_dataset( 'Foo', 'bar', 'junk', 'ding', 'bat' );
$g->add_dataset( -4,    3,     -4,     -5.4,   -2 );
$g->add_dataset( 2.2,   10,    -3,     8,      3 );
$g->add_dataset( -10,   2,     4,      -3,     -3 );
$g->add_dataset( 7,     -5,    -3,     4,      7 );

my %hash = (
    'transparent'  => 'true',
    'y_axes'       => 'both',
    'title'        => 'Hirizontal Bars Demo',
    'y_grid_lines' => 'true',
    'x_label'      => 'x-axis',
    'y_label'      => 'y-axis',
    'y_label2'     => 'y-axis',
    'tick_len'     => '5',
    'x_ticks'      => 'vertical',
    'grid_lines'   => 'true',
    'pt_size'      => '30',
    skip_y_ticks => 2,
    'colors'       => {
        'text'         => [ 100, 0,   200 ],
        'y_label'      => [ 2,   255, 2 ],
        'y_label2'     => [ 2,   255, 2 ],
        'y_grid_lines' => [ 255, 255, 255 ],
        'x_grid_lines' => [ 255, 255, 255 ],
    },
);

$g->set(%hash);

$g->png("hbars.png");

