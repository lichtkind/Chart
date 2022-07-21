use v5.12;
use warnings;
BEGIN { unshift @INC, 'lib', '../../../lib'}

use Chart::HorizontalBars;
    
    my $g = Chart::HorizontalBars->new( 600, 600 );
    $g->add_dataset( qw/ camel cat dog bear shell/ );
    $g->add_dataset( -300,  400, 800, -500,  200 );
    $g->add_dataset(  800, -600, 300,  300,  400 );
    $g->set(
        title         => 'Bars !',
        x_label       => 'Group',
        y_label       => 'Value',
        x_grid_lines  => 'true',
        precision     =>  0,
        grey_background => 'false',
        colors => {
            x_grid_lines => 'gray70',
            misc         => 'gray55',
            text         => 'gray55',
            x_label      => 'gray40',
            y_label      => 'gray40',
            title        => 'gray20',
        }
    );
    $g->png("hbars.png");
