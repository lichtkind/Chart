use ExtUtils::MakeMaker;

#  write the makefile
WriteMakefile ( 'NAME' => 'Chart',
		'PREREQ_PM' => { 'GD' => 2.0, 'File::Temp' => 0.19 },
		'dist' => { 'COMPRESS' => 'gzip', 'SUFFIX' => 'gz' },
		'VERSION' => '2.400.6' )
