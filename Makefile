# /****************************************************************
# Copyright (C) Lucent Technologies 1997
# All Rights Reserved
#
# Permission to use, copy, modify, and distribute this software and
# its documentation for any purpose and without fee is hereby
# granted, provided that the above copyright notice appear in all
# copies and that both that the copyright notice and this
# permission notice and warranty disclaimer appear in supporting
# documentation, and that the name Lucent Technologies or any of
# its entities not be used in advertising or publicity pertaining
# to distribution of the software without specific, written prior
# permission.
#
# LUCENT DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
# INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
# IN NO EVENT SHALL LUCENT OR ANY OF ITS ENTITIES BE LIABLE FOR ANY
# SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER
# IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,
# ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF
# THIS SOFTWARE.
# ****************************************************************/
.PHONY: bundle tar names clean run all

#CFLAGS = -g -DDEBUG -Wall -pedantic -fno-strict-aliasing `pkg-config --cflags json-c`
CFLAGS = -O4 -static `pkg-config --cflags json-c`

#CC = gcc -Wall -g -Wwrite-strings
#CC = gcc -fprofile-arcs -ftest-coverage # then gcov f1.c; cat f1.c.gcov
CC = gcc

#YFLAGS = -d -S # -S uses sprintf in yacc parser instead of sprint
#YACC = yacc
YFLAGS = -d -y
YACC = bison

OFILES = ytab.o b.o main.o parse.o proctab.o tran.o lib.o run.o lex.o

SOURCE = awk.h ytab.c ytab.h proto.h awkgram.y lex.c b.c main.c \
	maketab.c parse.c lib.c run.c tran.c proctab.c

LISTING = awk.h proto.h awkgram.y lex.c b.c main.c maketab.c parse.c \
	lib.c run.c tran.c

SHIP = README FIXES $(SOURCE) ytab[ch].bak makefile awk.1

all: jawk

jawk: $(OFILES)
	$(CC) $(CFLAGS) $(OFILES) $(ALLOC) `pkg-config --libs json-c` -lm -o $@

$(OFILES): awk.h ytab.h proto.h

ytab.c: awkgram.y
	$(YACC) $(YFLAGS) $<
	mv y.tab.c $@
	mv y.tab.h ytab.h

proctab.c: maketab
	./maketab > proctab.c

maketab: maketab.c ytab.h
	$(CC) $(CFLAGS) $< -o maketab

bundle:
	@cp ytab.h ytabh.bak
	@cp ytab.c ytabc.bak
	@bundle $(SHIP)

tar:
	@cp ytab.h ytabh.bak
	@cp ytab.c ytabc.bak
	@bundle $(SHIP) >jawk.shar
	@tar cf jawk.tar $(SHIP)
	gzip jawk.tar
	ls -l jawk.tar.gz
	@zip jawk.zip $(SHIP)
	ls -l jawk.zip

names:
	@echo $(LISTING)

run: jawk
	echo '{"abc":"3","xyz":"foo"}' | ./jawk -j '{print $$abc, $$xyz}' | tee /tmp/jawk.log

man:
	nroff -mandoc jawk.1 | less

dbg:
	ddd ./jawk

clean:
	rm -f jawk *.o *.obj maketab maketab.exe *.bb *.bbg *.da *.gcov *.gcno *.gcda proctab.c

