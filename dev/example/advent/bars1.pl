use v5.12;
use warnings;
BEGIN { unshift @INC, 'lib', '../../../lib'}


use Chart::Bars;
my $g = Chart::Bars->new( 600, 600 );
$g->add_dataset( qw/ Peter Paul Mary/ );
$g->add_dataset( 30, 40, 80 );
$g->add_dataset( 80, 60, 30 );
$g->add_dataset( 50, 30, 60 );
$g->set(
    title         => 'Christmas Expenses',
    x_label       => 'Recipient',
    y_label       => 'Amount',
    legend_labels => ['2020', '2021', '2022'],    
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
    },
);
$g->png("bars1.png");
