MATLAB=matlab -nosplash -nodesktop -nojvm -nodisplay
MEX=mex -O -I/usr/local/include -L/usr/local/lib
MEXEXT=$(shell mexext)
PWD=$(shell pwd)

TARGETS=zmq
.PHONY: all clean $(TARGETS)
	
all: $(TARGETS)

zmq:	
	$(MEX) $@.cc -lzmq

test:
	@echo "Testing matlab scripts!"
	$(MATLAB) -r "test_zmq"
	@echo "Done!"

clean:
	rm -f *.$(MEXEXT) *.o
