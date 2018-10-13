CC= g++-6
CPPFLAGS= -std=c++11 -fopenmp -lm -Ofast
OBJS= deepwalk line walklets hpe app mf bpr hoprec warp nemf nerank
LIBS= -L ../bin -lproNet

all: $(OBJS)

$(OBJS):
	$(CC) $(CPPFLAGS) $@.cpp $(LIBS) -o $@
	mv $@ ../bin/
clean:
	rm $(OBJS)
