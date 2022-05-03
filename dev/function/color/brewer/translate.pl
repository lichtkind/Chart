use v5.12;

BEGIN { unshift @INC, '../../../../lib'}
use Chart::Color;
use JSON;
use YAML qw'freeze';

#my $file = 'example.json';
my $in_file = 'colorbrewer.json';
my $out_file = 'colorbrewer.yml';

local $/;
open my $FH, '<', $in_file or die "could not open $in_file: $!";
my $json = <$FH>;
close $FH;

my $rgb_data = decode_json $json;
my $hsl_data = {};
for my $set (keys %$rgb_data){
    for my $size (keys %{$rgb_data->{$set}}){
        next unless $size =~ /^\d+$/;;
        for my $triplet ( @{$rgb_data->{$set}{$size}} ){
            $triplet =~ /(\d+),(\d+),(\d+)/;
            my @hsl = Chart::Color::Value::hsl_from_rgb( $1, $2, $3 );
            #$" = ',';
            push @{$hsl_data->{$set}{$size}}, sprintf "hsl( %3d, %3d, %3d )", @hsl;
        }
    }
}
my $yaml = freeze $hsl_data;

open my $FH, '>', $out_file or die "could not open $out_file: $!";
print $FH $yaml;
close $FH;
