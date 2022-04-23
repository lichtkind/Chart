BEGIN { unshift @INC, '../../../lib'}

use v5.12;

use Chart::Color::Value;
use JSON;

my $file = 'colorbrewer.json';
