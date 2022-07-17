use v5.12;
use warnings;
BEGIN { unshift @INC, 'lib', '../../../lib'}

use Chart::Split;

my $g = Chart::Split->new( 500, 500 );
my @domain = 1 .. 4000;
my @rnd = map { srand( time() / $_ * 50 ); rand(10) } @domain, 4001;
my @diff = map { abs $rnd[$_-1] - $rnd[$_] } @domain;
pop @rnd;

$g->add_dataset(@x);
$g->add_dataset(@y1);
$g->add_dataset(@y2);
$g->set(
    title          => "Random Numbers Test",
    x_label        => "4000 Random Numbers",
    start          => 0,
    interval       => 400,
    brush_size     => 1,
    interval_ticks => 0,
    legend         => 'bottom',
    legend_labels  => ['random numbers', 'difference' ],
    colors => {
           title => 'darkblue',
           text  => 'gray45',
           misc  => 'gray45',
    },
);
$g->png("split.png");

