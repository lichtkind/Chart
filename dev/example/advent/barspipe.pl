use v5.12;
use warnings;
BEGIN { unshift @INC, 'lib', '../../../lib'}

use Chart::Bars;
use Graphics::Toolkit::Color 'color';
    
my $g = Chart::Bars->new( 400, 400 );
$g->add_dataset( qw/ Peter Paul Mary/ );
$g->add_datafile( 'input.tsv' );
$g->set(
    title         => 'Expenses 2020 - 2022',
    x_label       => 'Recipient',
    y_label       => 'Amount',
    legend_labels => ['2020', '2021', '2022'],    
    y_grid_lines  => 'true',
    min_val       =>  0,
    precision     =>  0,
#        spaced_bars   =>  'false',
    colors => {
        y_grid_lines => 'gray70',
        misc         => 'gray55',
        text         => 'gray55',
        x_label      => 'gray40',
        y_label      => 'gray40',
        title        => 'gray20',
        dataset0     => 'royalblue4',
        dataset1     => 'royalblue3',
        dataset2     => 'royalblue2',

    },
);


binmode STDOUT;
print STDOUT $g->scalar_png;

