#!/usr/bin/perl -w
use v5.12;

BEGIN { unshift @INC, 'lib', '../../../../lib'}
use Chart::Pie;
use GD;

my $bfn = 'ring';

my @dataset1 = ('eins', 'zwei', 'drei', 'vier', 'fuenf', 'sechs', 'sieben', 'acht', 'neun', 'zehn', 'elf', 'zwoelf', 13, 14, 15, 16);
my @dataset2 = (20,     20,      12,     27,     19,       28,      19,       23,     15,      60     , 20,     24,    21, 18, 13, 31);
my $setting = { 
    title     => 'Pie Demo Chart',
    colors    => { 'background' => {h => 0, s => 0, l => 80} },
    ring      => 0.3,
    x_label   => '',
    legend    => 'bottom',
    sub_title           => 'blur test',
    label_values        => 'value',
    legend_label_values => 'value',
};

my $g = Chart::Pie->new( 500, 400 );
$g->add_dataset( @dataset1 );
$g->add_dataset( @dataset2 );
$g->set( %$setting );
$g->png( $bfn."_small.png" );


$g = Chart::Pie->new( 1200, 900 );
$g->add_dataset( @dataset1 );
$g->add_dataset( @dataset2 );
$g->set( %$setting );
$g->png( $bfn."_big.png");


my $blur_file = $bfn."_blur.png";
$g->{'gd_obj'}->gaussianBlur( );
open my $FH, '>', $blur_file or die "could not open $blur_file: $!";
binmode $FH;
print $FH $g->{'gd_obj'}->png();
close $FH;



$g = Chart::Pie->new( 1200, 900 );
$g->add_dataset( @dataset1 );
$g->add_dataset( @dataset2 );
$g->set( %$setting );
$g->png($bfn."_big.png");


my $smooth_file = $bfn."_smooth.png";
$g->{'gd_obj'}->smooth(2);
open $FH, '>', $smooth_file or die "could not open $smooth_file: $!";
binmode $FH;
print $FH $g->{'gd_obj'}->png();
close $FH;
