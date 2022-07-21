use v5.12;
use warnings;
BEGIN { unshift @INC, 'lib', '../../../lib'}
use Chart::Pie;


my $g = Chart::Pie->new( 500, 450 );
$g->add_dataset( 'eins', 'zwei', 'drei', 'vier', 'fuenf', 'sechs', 'sieben', 'acht', 'neun', 'zehn' );
$g->add_dataset( 120,    50,     100,    80,     40,      45,      150,      60,     110,    50 );

    $g->set( 'title'               =>  'Pie\nDemo Chart',
             'legend'              => 'bottom',
             'legend_label_values' => 'value',
             'label_values'        => 'percent',
             'legend_lines'        => 'true',
             'ring'                => 0.35, 
    );
$g->png("pie.png");

