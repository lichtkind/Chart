use v5.18;
use SVG;

my $svg_file = 'SVG_primitives.svg';

my $im = SVG->new( width => 100, height => 100);
my $group = $im->group( id => 'group',
        style => {
            stroke => 'blue',
            fill   => 'blue',
            'stroke-width'   => '1',
            'stroke-opacity' => '1',
        },
    );


open my $FH, '>', $svg_file or die "can not write file: $svg_file";
print $FH $im->xmlify;
close $FH;

say "wrote: $svg_file ";


__END__

rgb(100,100,100)
