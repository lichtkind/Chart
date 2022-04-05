
# Chart::Color: color object with basic color space method and conversion

use v5.12;

package Chart::Color;

use Chart::Color::Named;
use Chart::Color::Scheme;

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
    return "need 3 positive integer values 0 <= n < 256" unless defined $b;
    
    [];
}

sub hsl_to_rgb {
    my ($h, $s, $l) = @_;
    return "need 3 positive real values: 0 <= n <= 1" unless defined $l;
    
    [];
}

sub red         { $_[0][0] }
sub green       { $_[0][1] }
sub blue        { $_[0][2] }
sub hue         { $_[0][3] }
sub saturation  { $_[0][4] }
sub lightness   { $_[0][5] }

sub rgb     { @{$_[0]}[0 .. 2] }
sub hsl     { @{$_[0]}[3 .. 5] }
sub hsl_web { ($_[0][3] * 360, $_[0][4]*100, $_[0][5]*100) }
sub hex     { sprintf "%x%x%x", $_[0]->rgb() }



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


