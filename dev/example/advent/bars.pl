use v5.12;
use warnings;
BEGIN { unshift @INC, 'lib', '../../../lib'}

use Chart::Bars;
use Graphics::Toolkit::Color 'color';
    
my $g = Chart::Bars->new( 400, 400 );
$g->add_dataset( qw/ Peter Paul Mary/ );
$g->add_dataset( 300, 400, 800, );
$g->add_dataset( 800, 600, 300, );
$g->add_dataset( 500, 300, 600, );
$g->set(
    title         => 'Bars !',
    x_label       => 'Group',
    y_label       => 'Value',
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
        dataset0     => 'royalblue3',
        dataset1     => 'royalblue2',
        dataset2     => 'royalblue1',

    },
);
$g->png("bars1.png");
