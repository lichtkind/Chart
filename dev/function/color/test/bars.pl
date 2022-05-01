#!/usr/bin/perl -w

BEGIN { unshift @INC, '../../../../lib'}
use Chart::Bars;

$g = Chart::Bars->new( 800, 800 );
$g->add_dataset( 'foo', 'bar', 'junk', 'ding',  'bat' );
$g->add_dataset( 30000, 40000, 80000,  50000,   90000 );
$g->add_dataset( 80000, 60000, 30000,  30000,   40000 );
$g->add_dataset( 50000, 70000, 20200,  80000.8, 40000 );

%hash = (
    'transparent'  => 'false',
    'precision'    => 1,
    'title'        => 'Bars\nChartmodul',
    'y_grid_lines' => 'true',
    'graph_border' => '4',
    'min_val'      => '0',
    'text_space'   => '2',
    'sub_title'    => 'Untertitel',
    'x_label'      => 'X-Achse',
    'y_label'      => 'Y-Achse',
    'y_label2'     => 'Y-Achse2',
    'legend'       => 'none',
    'tick_len'     => '3',
    'x_ticks'      => 'vertical',
    'include_zero' => 'true',
    'pt_size'      => '7',
    'skip_x_ticks' => '1',
    #'grid_lines'   => 'true',
    'colors'       => {
        #'text'         => [ 100, 0,   200 ],
        #'y_label'      => [ 2,   255, 2 ],
       # 'y_label2'     => [ 2,   255, 2 ],
        #'y_grid_lines' => 'black',
        'y_grid_lines' => [250, 250, 250],
        #'dataset0'     => [ 215, 20,  147 ],

    },
    'y_ticks' => '20',

);
$g->set(%hash);
$g->png("bars.png");
print "ok 1\n";
exit(0);
