#!/usr/bin/perl -w
use v5.12;

BEGIN { unshift @INC, 'lib', '../../../lib'}
use Chart::Pie;

my $g = Chart::Pie->new( 550, 500 );
$g->add_dataset( 'The Red', 'The Black', 'The Yellow', 'The Brown', 'The Green' );
$g->add_dataset( 430,       411,         50,           10,          100 );

$g->set( 'title'               => 'The Parlament' );
#$g->set( 'label_values'        => 'percent' );
$g->set( 'legend_label_values' => 'value' );
#$g->set( 'legend'              => 'top' );
$g->set( 'grey_background'     => 'false' );
$g->set( 'x_label'             => 'seats in the parlament' );
$g->set(
    grey_background => 'true',
    #title_font => GD::Font->Giant,
    #legend_lines => 'false',
    label_values => 'both',
    'colors' => {
        'misc'       => 'light_blue',
        'background' => 'lavender',
        'dataset0'   => 'red',
        'dataset1'   => 'black',
        'dataset2'   => [ 210, 210, 0 ],
        'dataset3'   => 'DarkOrange',
        'dataset4'   => 'green',
        y_axes => 'left',
    }
);

$g->png("pie.png");
