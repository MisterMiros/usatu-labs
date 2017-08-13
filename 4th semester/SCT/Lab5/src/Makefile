IDIR =../include
CC=nvcc
CFLAGS=-I$(IDIR) -arch=sm_30

ODIR=obj

_DEPS = common.h
DEPS = $(patsubst %,$(IDIR)/%,$(_DEPS))

_OBJ = main.o common.o
OBJ = $(patsubst %,$(ODIR)/%,$(_OBJ))

$(ODIR)/%.o: $(IDIR)/%.cu $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

$(ODIR)/%.o: %.cu $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

.PHONY: clean

main: $(OBJ)
	$(CC) -o $@ $^ $(CFLAGS)

all: main

debug: $(OBJ)
	$(CC) -o $@ $^ $(CFLAGS) -DDEBUG

clean:
	rm -f $(ODIR)/*.o *~ core $(INCDIR)/*~
