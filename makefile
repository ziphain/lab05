
ifdef fsdb
ARGUMENT_1 += +fsdb=$(fsdb)
endif

ifdef width
ARGUMENT_2 += +define+WIDTH=$(width)
endif

ifdef word
ARGUMENT_3 += +define+WORD=$(word)
endif

ifdef debug
ARGUMENT_4 += +define+DEBUG=$(debug)
endif

ifdef pattern
ARGUMENT_5 += +pattern=$(pattern)
endif

ifdef golden
ARGUMENT_6 += +golden=$(golden)
endif

HEADER = header.v

VLOG	=	ncverilog
SRC	=	lzc.v\
		gcd.v\
		testbench.v
VLOGARG	=	+access+r

TEPFILE	=	*.log	\
		ncverilog.key	\
		nWaveLog	\
		INCA_libs
DBFILE	=       *.fsdb  *.vcd   *.bak
RM	=	-rm	-rf

all :: sim

sim :
	$(VLOG)	$(HEADER) $(SRC) $(VLOGARG) $(ARGUMENT_1) $(ARGUMENT_2) $(ARGUMENT_3) $(ARGUMENT_4) $(ARGUMENT_5) $(ARGUMENT_6)

clean :
	$(RM)	$(TMPFILE)

veryclean :
	$(RM)	$(TMPFILE)	$(DBFILE)
