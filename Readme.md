## NAME

    Chart - a series of charting modules

## VERSION
 
    2.401.4

## HOME

    https://metacpan.org/pod/Chart

    There is also a download link on the left side under "Tools".


## BUILDING

    The git repository contains much more than the software package itself.
    If you check out sources there you have to build the package yourself.
    In order to do that you need perl and the module Dist::Zilla.
    Then you have to check which further Dist::Zilla plugins you miss:
    
    dzil authordeps
    
    After having installed them via cpan or cpanm you run:

    dzil build
    
    Which gives you basically the same as the download from link above, 
    just with recent (anyd maybe buggy sources) . Don't forget to:
    
    dzil clean


## INSTALLING

    The usual.
 
        perl Makefile.PL
        make
        make test
        make install

    This should install to your site_perl directory.  The test scripts also
    put samples of the different charts in the samples/ directory.


## PREREQUISITES

    Lincoln Stein's GD module version 2.0.36 or higher.
    Carp


## CHANGES

    are in file Changes
    

## DOCUMENTATION

    There is a pdf (complete user manual) and a /doc directory (API reference),
    but for the fastest overview start with /lib/Chart.pm
    

## MAINTAINER

    - Chart-Group (chart@fs.wettzell.de)
    - Herbert Breunung (lichtkind@cpan.org)


## CONTRIBUTING

    If you want to help please read file CONTRIBUTING


## COPYRIGHT

    Copyright(c) 1997-1998 David Bonner, 1999 Peter Clark, 
    2001-2012 Chart-Group at BKG.
    All rights reserved.
    This program is free software; you can redistribute it and/or modify it under 
    the same terms as Perl itself.

