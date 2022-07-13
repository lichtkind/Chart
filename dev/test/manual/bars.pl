use v5.12;
use warnings;
BEGIN { unshift @INC, 'lib', '../../lib'}

use Chart::Bars;
    
    my $g = Chart::Bars->new( 600, 600 );
    $g->add_dataset( qw/ camel cat dog bear shell/ );
    $g->add_dataset( 30000, 40000, 80000,  50000,   90000 );
    $g->add_dataset( 80000, 60000, 30000,  30000,   40000 );
    $g->set(
        title         => 'Bars !',
        x_label       => 'Group',
        y_label       => 'Value',
        y_grid_lines  => 'true',
        min_val       =>  0,
        precision     =>  0,
#        spaced_bars   =>  'true',
        colors => {
            y_grid_lines => [180, 180, 180]
        }
    );
$g->png("bars.png");
