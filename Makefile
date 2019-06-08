BINDIR = bin
OBJDIR = obj

TCC_SRCDIR = include/tcc
TCC_LNAME = tinycc
TCC_FNAME = lib$(TCC_LNAME).a
TINYCC = $(OBJDIR)/$(TCC_FNAME)

CXX = g++-8
CC  = gcc-8
AR  = ar
RL  = ranlib

# OPTIMISATION = -g3 -O0
OPTIMISATION = -g0 -O3

CXXFLAGS = $(OPTIMISATION) -no-pie -std=c++17 -Wall -Werror -Wfatal-errors -pthread `sdl2-config --cflags`
CCFLAGS  = $(OPTIMISATION) -no-pie -std=c99 -Wall -Werror -Wfatal-errors -Wno-unused-variable -Wno-unused-result -Wno-unused-function -pthread -ldl
ARFLAGS  = rcs

INCDIRS = include include/imgui include/imgui/misc/cpp
LIBDIRS = $(BINDIR)
LIBS = SDL2 GL dl stdc++fs

# explorer.out: $(TINYCC) | $(BINDIR) $(OBJDIR)
# 	$(CXX) $(CXXFLAGS) -o $(BINDIR)/explorer.out src/main.cpp $(TINYCC) $(foreach D,$(INCDIRS),-I$D ) $(foreach D,$(LIBDIRS),-L$D ) $(foreach L,$(LIBS),-l$L )
explorer.out: | $(BINDIR) $(OBJDIR)
	$(CXX) $(CXXFLAGS) -o $(BINDIR)/explorer.out src/main.cpp $(foreach D,$(INCDIRS),-I$D ) $(foreach D,$(LIBDIRS),-L$D ) $(foreach L,$(LIBS),-l$L )

.PHONY: explorer.out

libtcc $(TINYCC): include/tcc/libtcc.c include/tcc/tcctools.c | $(OBJDIR)
	$(CC) $(CCFLAGS) -o $(OBJDIR)/libtcc.o -c include/tcc/libtcc.c && \
	$(CC) $(CCFLAGS) -o $(OBJDIR)/tcctools.o -c include/tcc/tcctools.c && \
	$(AR) $(ARFLAGS) $(TINYCC) $(OBJDIR)/libtcc.o $(OBJDIR)/tcctools.o && \
	$(RL) $(TINYCC)

$(TCC_SRCDIR)/libtcc.c $(TCC_SRCDIR)/tcctools.c: | $(TCC_SRCDIR)
	git submodule init && git submodule update

tinflate.out: | $(BINDIR) $(OBJDIR)
	$(CXX) $(CXXFLAGS) -o $(BINDIR)/tinflate.out tinflate/test.cpp tinflate/tinflate.c -Iinclude

clean:
	rm -f $(BINDIR)/*
	rm -f $(OBJDIR)/*

$(BINDIR):
	mkdir $(BINDIR)

$(OBJDIR):
	mkdir $(OBJDIR)
