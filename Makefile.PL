use ExtUtils::MakeMaker;

#  make the samples directory
mkdir ('samples', 00755);

#  write the makefile
WriteMakefile ( 'NAME' => 'Chart',
		'PREREQ_PM' => { 'GD' => 2.0, 'Carp' => 1.35  },
		'dist' => { 'COMPRESS' => 'gzip', 'SUFFIX' => 'gz' },
		'VERSION' => '2.401.0' )
