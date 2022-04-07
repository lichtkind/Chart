
# Chart::Color: color object with basic color space method and conversion

use v5.12;

package Chart::Color;
use Chart::Color::Named;

sub new {
    my ($pkg) = shift;
    return 'constructor of Chart::Color object needs 3 arguments in named form'.
           ' e.g.: ->new(r => 255, g => 0, b => 0), ->new(h => 0, s => 1, l => .5)'.
           ' or as positionals e.g.: ->new(255, 0, 0) or a name.' unless @_ == 6 or @_ == 3 or @_ == 1;
    my @args = @_;
    if (@args == 1){ # retrieve values of named color
        my @args = Chart::Color::Named::rgb( $_[0] );
        return "'$_[0]' is an unknown color name" unless @args == 3;
    }
    my $args = (@args == 3 )
             ? {'r' => $_[0], 'g' => $_[1], 'b' => $_[2] } # from positional arg format
             : {lc($_[0]) => $_[1], lc($_[2]) => $_[3], lc($_[4]) => $_[5] }; # from named
    my ($self, $rest);
    # get missing values of color object
    if      (exists $args->{'r'} and exists $args->{'g'} and exists $args->{'b'}) {
        $rest = rgb_to_hsl( @$args{qw/r g b/} );
        return "RGB values are out of range" unless ref $rest eq 'ARRAY';
        $self = [@$args{qw/r g b/}, @$rest];
    } elsif (exists $args->{'h'} and exists $args->{'s'} and exists $args->{'l'}) {
        $rest = hsl_to_rgb( @$args{qw/h s l/} );
        return "HSL values are out of range" unless ref $rest eq 'ARRAY';
        $self = [@$rest, @$args{qw/h s l/}];
    } else { return "need argument keys to be r, g and b or h, s and l (Uppercase works too)" }
    bless $self;
}

sub rgb_to_hsl{
    my ($r, $g, $b) = @_;
    return "need 3 positive integer values 0 <= n < 256 for RGB input" unless defined $b;
    return "red value has to be an integer between 0 and 255"   unless int $r == $r and $r >= 0 and $r < 256;
    return "green value has to be an integer between 0 and 255" unless int $g == $g and $g >= 0 and $g < 256;
    return "blue value has to be an integer between 0 and 255"  unless int $b == $b and $b >= 0 and $b < 256;
    my ($h, $min, $max, $dom);
    if ($r >= $g)  { $max = $r; $min = $g;  $dom = 'r'; }
    else           { $max = $g; $min = $r;  $dom = 'g'; }
    if ($max < $b) { $max = $b;             $dom = 'b'; }
    if ($min > $b) { $min = $b }
    my $C = $max - $min;
    if ($C) {
        $h = (     ($g-$b)/$C)  / 6 if $dom eq 'r';
        $h = (2 + (($b-$r)/$C)) / 6 if $dom eq 'g';
        $h = (4 + (($r-$g)/$C)) / 6 if $dom eq 'b';
    } else { $h = 0 }
    my $s = $max == 0 ? 0 : ($C / $max);
    my $l = ($max + $min) / 510;
    [$h, $s, $l];
}
sub hsl_to_rgb {
    my ($h, $s, $l) = @_;
    return "need 3 positive real values: 0 <= n <= 1 for HSL input" unless defined $l;
    return "hue value has to be between 0 and 1"  unless $h >= 0 and $h <= 1;
    return "saturation has to be between 0 and 1" unless $s >= 0 and $s <= 1;
    return "lightness has to be between 0 and 1"  unless $l >= 0 and $l <= 1;
    $h *= 6;
    my $C = $s * (1 - abs($l * 2 - 1)) * 255;
    my $X = $C * (1 - abs($h % 2 - 1 + ($h - int $h)));
    my $m = ($l * 255) - ($C / 2);
    if    ($h < 1) { return [int $C + $m, int $X + $m, int      $m] }
    elsif ($h < 2) { return [int $X + $m, int $C + $m, int      $m] }
    elsif ($h < 3) { return [int      $m, int $C + $m, int $X + $m] }
    elsif ($h < 4) { return [int      $m, int $X + $m, int $C + $m] }
    elsif ($h < 5) { return [int $X + $m, int      $m, int $C + $m] }
    elsif ($h < 6) { return [int $C + $m, int      $m, int $X + $m] }
}

sub red         { $_[0][0] }
sub green       { $_[0][1] }
sub blue        { $_[0][2] }
sub hue         { $_[0][3] }
sub saturation  { $_[0][4] }
sub lightness   { $_[0][5] }

sub rgb     { @{$_[0]}[0 .. 2] }
sub hsl     { @{$_[0]}[3 .. 5] }
# hue 0..360 degree, S in %, L in %  as int
sub hsl_web { (int(.5 +($_[0][3] * 360)), int(.5+($_[0][4]*100)), int(.5+($_[0][5]*100))) } 
sub hex     { sprintf "%02x%02x%02x", $_[0]->rgb() } # without leading


sub distance_hsl {
    my ($self, @color) = shift;
    return "missing second argument: color object or color definition" unless @color;
    my $color = (ref $color[0] eq __PACKAGE__) ? $color[0] : Chart::Color->new(@color);
    return $color unless ref $color;
    sqrt(($self->hue - $color->hue) ** 2 + 
         ($self->saturation - $color->saturation) ** 2 + 
         ($self->lightness - $color->lightness) ** 2); 
}

sub distance_rgb {
    my ($self, @color) = shift;
    return "missing second argument: color object or color definition" unless @color;
    my $color = (ref $color[0] eq __PACKAGE__) ? $color[0] : Chart::Color->new(@color);
    return $color unless ref $color;
    sqrt(($self->red - $color->red) ** 2 + 
         ($self->green - $color->green) ** 2 + 
         ($self->blue - $color->blue) ** 2); 
}

sub add {
    my ($self, @color) = shift;
    return "missing second argument: color object or color definition" unless @color;
    my $color = (ref $color[0] eq __PACKAGE__) ? $color[0] : Chart::Color->new(@color);
    return $color unless ref $color;
    ###
}


sub gradient {
    my ($self, $steps, @color) = @_;
    return "missing first argument: number of gradient steps" unless $steps;
    return "missing second argument: color object or color definition" unless @color;
    my $color = (ref $color[0] eq __PACKAGE__) ? $color[0] : Chart::Color->new(@color);
    return $color unless ref $color;
    
    ###
}



1;

__END__



$half = 0.50000000000008;

sub round {
 my $x;
 my @res  = map {
  if ($_ >= 0) { POSIX::floor($_ + $Math::Round::half); }
     else { POSIX::ceil($_ - $Math::Round::half); }
 } @_;
