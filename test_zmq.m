% (c) 2013 Stephen McGill
% MATLAB script to test zeromq-matlab
clear all;
s1 = zmq( 'subscribe', 'matlab' );
p1 = zmq( 'publish',   'matlab' );
zmq( 'send', p1, 'hello world!' );
pause(.1)
[data,idx] = zmq('poll',100);
if idx==s1
	char( data{1}' );
	disp('ZMQ test passed!');
else
	disp('Bad idx!');
	disp( numel(idx) )
end
exit
