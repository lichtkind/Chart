

BEGIN { unshift @INC, '../../../lib'}

use v5.12;

use Chart::Color::Value;

open my $FHI, '<', 'pantone.txt';
open my $FHO, '>', 'pantonen.txt';

while (<$FHI>){
    chomp;
    say $FHO $_ if /^Pan/;
}    


while (<DATA>){
    chomp;
    /^(\w+\s?\w*)\s+([\dA-F]+)$/; 
    my ($r, $g, $b) = hex2rgb( $2 );
    my $name = lc $1;
    $name = substr $name, 0, -1 if substr $name, -1 eq ' '; 
    say "    '$name'  ".(' 'x(20 - length($name))).sprintf( "  => [ %3s, %3s, %3s ],", $r, $g, $b); 
}


sub hex2rgb {
    my $hex = shift;
    hex substr( $hex, 0, 2),
    hex substr( $hex, 2, 2),
    hex substr( $hex, 4, 2);
}

__DATA__
Marsala           955251
RadiandOrchid     B565A7
Emerald           009B77
TangerineTango    DD4124
Honeysucle        D65076
Turquoise         45B8AC
Mimosa            EFC050
BlueIzis          5B5EA6
ChiliPepper       9B2335
SandDollar        DFCFBE
BlueTurquoise     55B4B0
Tigerlily         E15D44
AquaSky           7FCDCD
TrueRed           BC243C
FuchsiaRose       C3447A
CeruleanBlue      98B4D4
RoseQuartz        F7CAC9
PeachEcho         F7786B
Serenity          91A8D0
SnorkelBlue       034F84
LimpetShell       98DDDE
LilacGrey         9896A4
IcedCoffee        B18F6A
Fiesta            DD4132
Buttercup         FAE03C
GreenFlash        79C753
Riverside         4C6A92
AiryBlue          92B6D5
Sharkskin         838487
AuroraRed         B93A32
WarmTaupe         AF9483
DustyCedar        AD5D5D
LushMeadow        006E51
SpicyMustard      D8AE47
Potter'sClay      9E4624
Bodacious         B76BA3
Niagara           578CA9
PrimroseYellow    F6D155
LapisBlue         004B8D
Flame             F2552C
IslandParadise    95DEE3
PaleDogwood       EDCDC2
PinkYarrow        CE3175
Kale              5A7247
Hazelnut          CFB095
Grenadine         DC4C46
TawnyPort         672E3B
BalletSlipper     F3D6E4
Butterum          C48F65
NavyPeony         223A5E
NeutralGray       898E8C
ShadedSpruce      005960
GoldenLime        9C9A40
Marina            4F84C4
AutumnMaple       D2691E
Meadowlark        ECDB54
CherryTomato      E94B3C
LittleBoyBlue     6F9FD8
ChiliOil          944743
PinkLavender      DBB1CD
BloomingDahlia    EC9787
Arcadia           00A591
UltraViolet       6B5B95
Emperador         6C4F3D
AlmostMauve       EADEDB
SpringCrocus      BC70A4
Lime Punch        BFD641
SailorBlue        2E4A62
HarborMist        B4B7BA
WarmSand          C0AB8E
CoconutMilk       F0EDE5
RedPear           7F4145
ValiantPoppy      BD3D3A
NebulasBlue       3F69AA
CeylonYellow      D5AE41
MartiniOlive      766F57
RussetOrange      E47A2E
CrocusPetal       BE9EC9
Limelight         F1EA7F
QuetzalGreen      006E6D
SargassoSea       485167
Tofu              EAE6DA
AlmondBuff        D1B894
QuietGray         BCBCBE
Meerkat           A9754F
Fiesta            DD4132
JesterRed         9E1030
Turmeric          FE840E
LivingCoral       FF6F61
PinkPeacock       C62168
PepperStem        8D9440
AspenGold         FFD662
PrincessBlue      00539C
Toffee            755139
MangoMojito       D69C2F
TerrariumMoss     616247
SweetLilac        E8B5CE
Soybean           D2C29D
Eclipse           343148
SweetCorn         F0EAD6
BrownGranite      615550
ChiliPepper       9B1B30
BikingRed         77212E
CrèmedePeche      F5D6C6
PeachPink         FA9A85
RockyRoad         5A3E36
FruitDove         CE5B78
SugarAlmond       935529
DarkCheddar       E08119
GalaxyBlue        2A4B7C
Bluestone         577284
OrangeTiger       F96714
Eden              264E36
VanillaCustard    F3E0BE
EveningBlue       2A293E
Paloma            9F9C99
Guacamole         797B3A
FlameScarlet      CD212A
Saffron           FFA500
BiscayGreen       56C6A9
Chive             4B5335
FadedDenim        798EA4
OrangePeel        FA7A35
MosaicBlue        00758F
Sunlight          EDD59E
CoralPink         E8A798
Cinnamon Stick    9C4722
GrapeCompote      6B5876
Lark              B89B72
NavyBlazer        282D3C
BrilliantWhite    EDF1FF
Ash               A09998
Amberglow         DC793E
Samba             A2242F
Sandstone         C48A69
ClassicBlue       34568B
GreenSheen        D9CE52
RoseTan           D19C97
UltramarineGreen  006B54
FiredBrick        6A2E2A
PeachNougat       E6AF91
MagentaPurple     6C244C
Marigold          FDAC53
Cerulean          9BB7D4
Rust              B55A30
Illuminating      F5DF4D
FrenchBlue        0072B5
GreenAsh          A0DAA9
BurntCoral        E9897E
Mint              00A170
AmethystOrchid    926AA6
RaspberrySorbet   D2386C
Inkwell           363945
UltimateGray      939597
Buttercream       EFE1CE
DesertMist        E0B589
Willow            9A8B4F
