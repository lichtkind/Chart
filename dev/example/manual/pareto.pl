use v5.12;
use warnings;
BEGIN { unshift @INC, 'lib', '../../../lib'}

use Chart::Pareto;

my $g = Chart::Pareto->new( 450, 400 );
$g->add_dataset( 'Mo', 'Tue', 'We', 'Th', 'Fr', 'Sa', 'Su' );
$g->add_dataset( 2500, 1000,  250,  700,  100,  610,  20 );
$g->set(
        title              => 'Sold Tickets for Beethovens 9th',
        y_label            => 'Sold Tickets',
        x_label            => '! sold out in the first week !',
        sort               => 'true',
        max_val            => 5500,
        integer_ticks_only => 'true',
        skip_int_ticks     => 250,
        y_grid_lines       => 'true',
        spaced_bars        => 'false',
        legend             => 'none',
        colors  => {
            title        => 'darkblue',
            dataset0     => 'green',
            dataset1     => 'red',
            x_label      => 'red',
            y_grid_lines => 'white',
        },
);
$g->png("pareto.png");

