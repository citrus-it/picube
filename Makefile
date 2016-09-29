
MAKE=make

DEFS=-DPICUBE

SRCS=   anim.c \
	canary.c \
	cube.c \
	gpio.c \
	jim.c \
	main.c \
	sprite.c \
	text.c \
	util.c

HDRS=   cube.h \
	gpio.h \
	jim.h \
	sprite.h \
	tables.h \
	text.h \
	util.h

OBJS=   $(SRCS:.c=.o)
CC=gcc
CFLAGS=-g
INCS=-I. -Ijimtcl
LIBS=-lpthread -lm -ldl
#CFLAGS=-g -O3 -fno-strict-aliasing
#WARN=-pedantic -Wall -Wnested-externs -Wpointer-arith -Werror -Wno-unused
#WARN=-pedantic -Wall -W -Wnested-externs -Wpointer-arith -Wno-long-long

all: cube

cube: jimtcl/libjim.a ${OBJS}
	${CC} -static-libgcc \
		${WARN} \
		${DEFS} \
		${CFLAGS} -o $@ \
		${OBJS} \
		${LIBS} jimtcl/libjim.a
	@echo "Done..."

jimtcl/libjim.a:
	cd jimtcl; \
	CFLAGS=-DPICUBE ./configure \
		--math \
		--disable-docs \
		--with-ext="oo tree"; \
	make

install: cube
	sudo cp cube /usr/local/bin/cube
	sudo chown root /usr/local/bin/cube
	sudo chmod u+s /usr/local/bin/cube

clean:
	@-touch core
	rm -f cube core tags ${OBJS} help.h ext.h anim.h

distclean: clean
	cd jimtcl; make distclean

tags:
	@-ctags *.[ch] 2>> /dev/null

# Relax C rules for anim.c to provide compatibility with ChipKit code.
anim.o: anim.c anim.h
	@echo "	$<"
	@$(CC) -std=gnu99 $(CFLAGS) ${WARN} ${DEFS} ${INCS} -c $< -o $@

.c.o:
	@echo "	$<"
	@$(CC) $(CFLAGS) ${WARN} ${DEFS} ${INCS} -c $< -o $@

anim.h: anim/build
	@echo "	$@"
	@cd anim; ./build > ../anim.h

help.h: help/build
	@echo "	$@"
	@cd help; ./build > ../help.h

ext.h: ext/build
	@echo "	$@"
	@cd ext; ./build > ../ext.h

jim.o: help.h ext.h

${OBJS}: ${HDRS}

