#!/usr/bin/perl -w

BEGIN { unshift @INC, 'lib', '../lib'}
use Chart::Mountain;

print "1..1\n";

my $obj = new Chart::Mountain( 1000, 500 );
my @data = (
    [
        '03/05/2010-00.00', '03/05/2010-00.30', '03/05/2010-01.00', '03/05/2010-01.30',
        '03/05/2010-02.00', '03/05/2010-02.30', '03/05/2010-03.00', '03/05/2010-03.30',
        '03/05/2010-04.00', '03/05/2010-04.30', '03/05/2010-05.00', '03/05/2010-05.30',
        '03/05/2010-06.00', '03/05/2010-06.30', '03/05/2010-07.00', '03/05/2010-07.30',
        '03/05/2010-08.00', '03/05/2010-08.30', '03/05/2010-09.00', '03/05/2010-09.30',
        '03/05/2010-10.00', '03/05/2010-10.30', '03/05/2010-11.00', '03/05/2010-11.30',
        '03/05/2010-12.00', '03/05/2010-12.30', '03/05/2010-13.00', '03/05/2010-13.30',
        '03/05/2010-14.00', '03/05/2010-14.30', '03/05/2010-15.00', '03/05/2010-15.30',
        '03/05/2010-16.00', '03/05/2010-16.30', '03/05/2010-17.00', '03/05/2010-17.30',
        '03/05/2010-18.00', '03/05/2010-18.30', '03/05/2010-19.00', '03/05/2010-19.30',
        '03/05/2010-20.00', '03/05/2010-20.30', '03/05/2010-21.00', '03/05/2010-21.30',
        '03/05/2010-22.00', '03/05/2010-22.30', '03/05/2010-23.00', '03/05/2010-23.30'
    ],

    [
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    ]
);

my @labels = ('ROMA_3');

$obj->set(
    'title'              => 'Video Server Play Daily Hourly Report',
    'grid_lines'         => 'true',
    'include_zero'       => 'true',
    'misc'               => [ 0, 0, 0 ],
    'y_label'            => 'Numero Streams',
    'x_ticks'            => 'vertical',
    'precision'          => '0',
    'integer_ticks_only' => 'true',
    'min_val'            => 0,
);
$obj->set(
    'colors'          => { 'dataset0' => [ 0, 255, 0 ] },
    'legend_labels'   => \@labels,
    'tick_label_font' => ( GD::Font->Giant ),
    'title_font'      => ( GD::Font->Giant )
);

$obj->png( 'samples/mountain_4.png', \@data );

print "ok 1\n";
exit(0);
