use v5.12;
use warnings;
BEGIN { unshift @INC, 'lib', '../../../lib'}

use Chart::Bars;
use Graphics::Toolkit::Color 'color';

my @gradient = color('lapisblue')->complementary( 3 );

my $g = Chart::Bars->new( 600, 600 );
$g->add_dataset( qw/ 2020 2021 2022/ );
$g->add_dataset( 30, 80, 50, );
$g->add_dataset( 40, 60, 30, );
$g->add_dataset( 80, 30, 60, );
$g->set(
    title         => 'Expenses 2020 - 2022',
    x_label       => 'Recipient',
    y_label       => 'Amount',
    legend_labels => ['Peter', 'Paul', 'Mary'],    
    y_grid_lines  => 'true',
    min_val       =>  0,
    precision     =>  0,
    colors => {
        y_grid_lines => 'gray70',
        misc         => 'gray55',
        text         => 'gray55',
        x_label      => 'gray40',
        y_label      => 'gray40',
        title        => 'gray20',
        dataset0     => $gradient[0],
        dataset1     => $gradient[1],
        dataset2     => $gradient[2],

    },
);
$g->png("bars5.png");
