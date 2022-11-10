use v5.12;
use warnings;
BEGIN { unshift @INC, 'lib', '../../../lib'}

use Chart::Lines;

my $file = shift;
my $g = Chart::Lines->new( 600, 600 );
$g->add_datafile( $file );

$g->set(
    title          => 'Latest Numbers !',
    include_zero   => 'true',
    y_grid_lines   => 'true',
    precision      => 0,
        colors => {
            y_grid_lines => 'gray60',
            misc         => 'gray55',
            text         => 'gray55',
            x_label      => 'gray40',
            y_label      => 'gray40',
            title        => 'gray20',
        },   
    
);

binmode STDOUT;
print STDOUT $g->scalar_png;

