use v5.12;
use warnings;
BEGIN { unshift @INC, 'lib', '../../../lib'}

use Chart::Bars;
    
    my $g = Chart::Bars->new( 400, 400 );
    $g->add_dataset( qw/ camel cat dog bear shell/ );
    $g->add_dataset( 300, 400, 800,  500,   900 );
    $g->add_dataset( 800, 600, 300,  300,   400 );
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
        },
    );
    $g->png("bars.png");
