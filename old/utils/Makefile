# utils/Makefile
# --------------
# The following commands are defined
#
# tidyup:  tidyup the sources
# doxygen: build doxygen documentation
#
UTILS=utils
CHART=Chart
TEST=test
#
# Version of Chart:
V=2.4.8
export V
#
PERLTIDYARGS=-i=4 -l=128 -w -ole=unix -bl

all: tidyup doxygen

tidyup : tidyupChart tidyupT

tidyupChart :
	@echo "tidyupChart:"; \
	if [ ! -x /usr/bin/perltidy ]; then \
		echo "perltidy is missed"; \
		echo "Please, install this package"; \
	else \
		cd ..; \
		perltidy ${PERLTIDYARGS} ${CHART}/*.pm; \
		if [ ! -f ${CHART}/*.ERR ]; then \
			 for f in ${CHART}/*.pm; do \
				echo $$f; \
				if [ -f $$f.tdy ]; then \
					rm $$f; mv $$f.tdy $$f; \
					date=`date '+%Y-%m-%d'`; \
					sed "/\@date/ s/\@date .*/\@date $$date/" $$f > $$f.tdy; \
					mv $$f.tdy $$f; \
					sed "/\@version/ s/\@version .*/\@version $$V/" $$f > $$f.tdy; \
					mv $$f.tdy $$f; \
					sed "/::VERSION/ s/::VERSION .*/::VERSION = '$$V';/" $$f > $$f.tdy; \
					mv $$f.tdy $$f; \
					sed "/use Chart::Base/ s/use Chart::Base .*/use Chart::Base '$$V';/" $$f > $$f.tdy; \
					mv $$f.tdy $$f; \
				fi; \
			done; \
		fi; \
		cd ${UTILS}; \
	fi



tidyupT :
	@echo "tidyupT:"; \
	if [ ! -x /usr/bin/perltidy ]; then \
		echo "perltidy is missed"; \
		echo "Please, install this package"; \
	else \
		cd ..; \
		perltidy ${PERLTIDYARGS} t/*.t; \
		if [ ! -f t/*.ERR ]; then \
			for f in t/*.t; do \
				echo $$f; \
				if [ -f $$f.tdy ]; then \
					rm $$f; mv $$f.tdy $$f; \
				fi; \
			done; \
		fi; \
		cd ${UTILS}; \
	fi


doxygen :
	@echo "doxygen:"; \
	if [ ! -x /usr/bin/doxygen ]; then \
		echo "doxygen is missed"; \
	else \
		cd ..; \
		doxygen ${UTILS}/Chart_doxygen.conf; \
		cd ${UTILS}; \
	fi

# make distribution
dist :
	sed "/'VERSION'/ s/'VERSION' => '.*'/'VERSION' => '$$V'/"  ../Makefile.PL > ../Makefile.PL.tmp; \
	rm -f ../Makefile.PL; \
	mv ../Makefile.PL.tmp ../Makefile.PL; \
	cd .. ; \
	perl Makefile.PL; \
	make ; \
	make test; \
	make manifest; \
	make dist

# do some tests
preparetests :
	$(shell mkdir -p test samples) \
	cd test; \
	cp -p ../../t/*.t .; \
	for f in *.t; do g=`echo $$f | sed "s/.t$$/.pl/"`; mv $$f $$g; done; \
	chmod +x *.pl
