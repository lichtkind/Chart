#!/usr/bin/perl -w
use v5.12;

BEGIN { unshift @INC, 'lib', '../../../../lib'}
use Chart::Pie;
use GD;



my $g = Chart::Pie->new( 400, 300 );
$g->add_dataset( 'eins', 'zwei', 'drei', 'vier', 'fuenf', 'sechs', 'sieben', 'acht', 'neun', 'zehn', 'elf', 'zwoelf', 13, 14, 15, 16 );
$g->add_dataset( 20,     20,      12,     27,     19,       28,      19,       23,     15,      60     , 20,     24,    21, 18, 13, 31 );

$g->set( 'title'               => 'Pie\nDemo Chart' );
$g->set( 'sub_title'           => 'Ring_Pie' );
$g->set( 'label_values'        => 'value' );
$g->set( 'legend_label_values' => 'value' );
$g->set( 'legend'              => 'bottom' );
$g->set( 'x_label'             => '' );
$g->set( 'ring'                => 0.3 );
$g->set( 'colors'              => { 'background' => {h => 0, s => 0, l => 80} } );

$g->png("pie_12_small.png");

exit(0);

