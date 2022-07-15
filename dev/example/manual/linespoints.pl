use v5.12;
use warnings;
BEGIN { unshift @INC, 'lib', '../../../lib'}

use Chart::LinesPoints;

my $g = Chart::LinesPoints->new( 600, 300 );

$g->set(
    'title'              => 'Soccer Season 2002',
    'legend_labels'      => ['NY Soccer Club', 'Denver Tigers', 
                             'Houston Spacecats', 'Washington Presidents'],
    'y_label'            => 'position in the table',
    'x_label'            => 'day of play',
    'grid_lines'         => 'true',
    'f_y_tick'           =>  sub { - $_[0] },
#    'xy_plot'            => 'true',
    'integer_ticks_only' => 'true',
);

$g->png("linespoints.png", [
    [qw(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17)],
    [qw(-7 -5 -6 -8 -9 -7 -5 -4 -3 -2 -4 -6 -3 -5 -3 -4 -6)],
    [qw(-1 -1 -1 -1 -2 -2 -3 -3 -4 -4 -6 -3 -2 -2 -2 -1 -1)],
    [qw(-4 -4 -3 -2 -1 -1 -1 -2 -1 -1 -3 -2 -4 -3 -4 -2 -2)],
    [qw(-6 -3 -2 -3 -3 -3 -2 -1 -2 -3 -1 -1 -1 -1 -1 -3 -3)],
]);




