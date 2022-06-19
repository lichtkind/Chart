### NAME

    Chart - swiss army knife of chart composition and drawing

### VERSION
 
    2.402.3

### HOME

[Chart on CPAN](https://metacpan.org/pod/Chart)

    This is the landing page for the user documentation.
    There is also a download link on the left side under "Tools".
   

### BUILDING

    The git repository contains much more than the software package itself.
    If you check out sources there, you have to build the package yourself.
    In order to do that you need perl and the module Dist::Zilla.
    
    cpan install Dist::Zilla   
        or 
    cpanm Dist::Zilla
    
    Then you have to check which further Dist::Zilla plugins you miss:
    
    dzil authordeps
    
    After having installed them via cpan or cpanm you run:

    dzil build
    
    Which gives you basically the same as the download as you get on CPAN
    (as describes under HOME), just with more up to date (and maybe buggy
    sources). Don't forget to:
    
    dzil clean


### INSTALLING

    Once you downloaded or created a Build you unzip it and do the usual:
 
        perl Makefile.PL
        make
        make test
        make install

    This should install to your site_perl directory.


### PREREQUISITES

    Lincoln Stein's GD module version 2.0.36 or higher.
    Perl 5.12 including come core Modules.



[###CHANGES](https://github.com/lichtkind/Chart/blob/main/Changes)

###[CONTRIBUTING](https://github.com/lichtkind/Chart/blob/main/CONTRIBUTING)

[CONTRIBUTORS](https://metacpan.org/pod/Chart#CONTRIBUTORS)


### MAINTAINER

    - Chart-Group (chart@fs.wettzell.de)
    - Herbert Breunung (lichtkind@cpan.org)


### COPYRIGHT

    Copyright(c) 1997-1998 by David Bonner, 1999 by Peter Clark,
    2001 by the Chart group at BKG-Wettzell.
    2022 by Herbert Breunung and Chart group

    All rights reserved.  This program is free software; you can
    redistribute it and/or modify it under the same terms as Perl 
    itself.

    The included  Unifont (c) by Roman Czyborra and contributors 
    is licensed under the OFL (Open Font License) 1.1.
