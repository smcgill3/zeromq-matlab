zeromq-matlab
=============

ZeroMQ mex bindings for MATLAB.  This version is known to work with ZeroMQ 3.2.2 on Mac OSX 10.8.3 with MATLAB 2012b and on Ubuntu 12.04 with MATLAB 2013a.

Requires ZeroMQ 3.2.2 to be installed first (see below)

To build, run "make"

To test, run "make test" if MATLAB can be called from the commandline.


Installing ZeroMQ 3.2.2 on Ubuntu 12.04
=======================
Download the tarball from http://www.zeromq.org/intro:get-the-software
In the root of the extracted archive, run the following commands:

1. ./configure
2. make
3. sudo make install
4. sudo ldconfig
