

BEGIN { unshift @INC, '../../../lib'}

use v5.12;

use Chart::Color::Value;

open my $FH, '<', 'x11h.txt';
#open my $FH, '<', 'html.txt';
#while (<$FH>){
while (<$HN>){
    chomp;
    #say $_;
    #/^\s+(\w+)\s+#([\da-f]+)/; 
    #/^(\w+)\s+\w{2}\s+\w{2}\s+\w{2}\s+(\d+)\s+(\d+)\s+(\d+)/; 
    #/^(\w+\s?\w*)\s+(#([\da-f]+))/; 
    #/^(\w+\s?\w*)\s+([\dA-F]+)$/; 
    my ($r, $g, $b) = hex2rgb( $2 );
    my $name = lc $1;
    say "    '$name'     => [ $r, $g, $b],"; 
    #say "$1 $2";
    #my @rgb = Chart::Color::Named::rgb($name);
    #say "    '$name'     => [ $2, $3, $4]," if $rgb[1] != $3 or $rgb[0] != $2 or$rgb[2] != $4;
}


sub hex2rgb {
    my $hex = shift;
    hex substr( $hex, 0, 2),
    hex substr( $hex, 2, 2),
    hex substr( $hex, 4, 2);
}

