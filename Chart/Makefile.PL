use ExtUtils::MakeMaker;

#  write the makefile
WriteMakefile ( 'NAME' => 'Chart', 'VERSION' => '2.401.0',
         'PREREQ_PM' => { 'GD' => 2.0, 'Carp' => 1.35},
         'TEST_REQUIRES' => { 'File::Temp' => 0.19 },
		 'dist' => { 'COMPRESS' => 'gzip', 'SUFFIX' => 'gz' },
)
