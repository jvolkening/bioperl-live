#!/usr/bin/perl

# This is code example 2 in the Graphics-HOWTO
use strict;
use lib '/home/lstein/projects/bioperl-live';
use Bio::Graphics;

my $panel = Bio::Graphics::Panel->new(-length => 1000,
				      -width  => 800,
				      -pad_left => 10,
				      -pad_right => 10,
				     );
my $full_length = Bio::Graphics::Feature->new(-start=>1,-end=>1000);
$panel->add_track($full_length,
		  -glyph   => 'arrow',
		  -tick    => 2,
		  -fgcolor => 'black',
		  -double  => 1,
		 );

my $track = $panel->add_track(-glyph => 'graded_segments',
			      -label  => 1,
			      -bgcolor => 'blue',
			      -min_score => 0,
			      -max_score => 1000,
			      -font2color     => 'red',
			      -description => sub {
				my $feature = shift;
				my $score   = $feature->score;
				return "score=$score";
			       });

while (<>) { # read blast file
  chomp;
  next if /^\#/;  # ignore comments
  my($name,$score,$start,$end) = split /\t+/;
  my $feature = Bio::Graphics::Feature->new(-name=>$name,-score=>$score,
					    -start=>$start,-end=>$end);
  $track->add_feature($feature);
}

print $panel->png;

