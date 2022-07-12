#!/usr/bin/perl -w
use v5.12;

BEGIN { unshift @INC, 'lib', '../../../lib'}
use Chart::Points;

my $file = "points.png";

my $g = Chart::Points->new();

my @hash = (
    'title'      => 'Points Chart',
    'png_border' => 10,
    'pt_size'    => 18,
    'grid_lines' => 'true',
    integer_ticks_only => 1,
    legend_labels => [qw/a b u/],
    'brush_size' => 10,               # 10 points diameter
    label_values => 'both',
    interval_ticks => 10,
);

$g->set(@hash);
$g->add_dataset( 'foo', 'bar', 'junk' );
$g->add_dataset( 3,     4,     9 );

$g->add_dataset( 8, 6, 0 );
$g->add_dataset( 5, 7, 2 );

$g->png($file);

say "wrote $file";
