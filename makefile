# spout
# SDLÍÑmakefile

.SUFFIXES: .o .c

SDL_LIB     = /usr/local/lib
SDL_INCLUDE = /usr/local/include/SDL

CC          = gcc
CFLAGS      = -I$(SDL_INCLUDE) -O2 -mno-cygwin

LD          = gcc
LDFLAGS     = -L$(SDL_LIB) -L. -lmingw32 -lSDLmain -lSDL -mwindows

PRGNAME     = spout
OBJS        = spout.o piece.o


$(PRGNAME).exe: $(OBJS)
	$(LD) $(CFLAGS) -o $(PRGNAME).exe $(OBJS) $(RES) $(LDFLAGS)
.c.o:
	$(CC) $(CFLAGS) -c -o $@ $<

spout.o: piece.h font.h sintable.h
piece.c: piece.h

clean:
	rm -f $(PRGNAME).exe *.o

run:	$(PRGNAME).exe
	$(PRGNAME).exe

