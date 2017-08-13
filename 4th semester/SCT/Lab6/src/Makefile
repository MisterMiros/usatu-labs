IDIR=include
CC=nvcc
CFLAGS=-I$(IDIR) -arch=sm_30

ODIR=obj

_DEPS=common.h
DEPS=$(patsubst %,$(IDIR)/%,$(_DEPS))

_OBJ=main.o common.o
OBJ=$(patsubst %,$(ODIR)/%,$(_OBJ))

$(ODIR)/%.o: $(IDIR)/%.cu $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

$(ODIR)/%.o: %.cu $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

.PHONY: clean

all: $(OBJ)
	$(CC) -o main $^ $(CFLAGS)

debug: $(OBJ)
	$(CC) -o main-debug $^ $(CFLAGS) -DDEBUG

clean:
	rm -f $(ODIR)/*.o *~ core $(INCDIR)/*~
