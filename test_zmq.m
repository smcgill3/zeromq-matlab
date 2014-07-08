% (c) 2013 Stephen McGill
% MATLAB script to test zeromq-matlab
clear all;
if ~ispc
    p1 = zmq( 'publish',   'ipc', 'matlab' );
    s1 = zmq( 'subscribe', 'ipc', 'matlab' );
else
    disp('0MQ IPC not supported on windows. Skipping IPC test...')
end
disp('Setting up TCP')
p2 = zmq( 'publish',   'tcp', '*', 5555 );
pause(.1)
s2 = zmq( 'subscribe', 'tcp', 'localhost', 5555 );

data1 = uint8('hello world!')';
data2 = [81;64;2000];
recv_data1 = [];
recv_data2 = [];

disp('Sending data...')
if ~ispc
    nbytes1 = zmq( 'send', p1, data1 );
else
    nbytes1 = 0;
end
nbytes2 = zmq( 'send', p2, data2 );
fprintf('\nSent %d and %d bytes for ipc and tcp channels.\n',nbytes1,nbytes2);
idx = zmq('poll',1000);

if(numel(idx)==0)
	disp('No data!')
end

for c=1:numel(idx)
    s_id = idx(c);
    [recv_data,has_more] = zmq( 'receive', s_id );
    fprintf('\nI have more? %d\n',has_more);
	if ~ispc && s_id==s1
		disp('ipc channel receiving...');
        recv_data1 = char(recv_data);
		disp( recv_data1' );
	elseif s_id==s2
		disp( 'tcp channel receiving...' );
        recv_data2 = typecast(recv_data,'double');
		disp( recv_data2' )
	else
	end
end

if ispc
    disp('IPC test skipped!')
elseif(sum(recv_data1==data1)==numel(data1))
	disp('IPC test passed!')
else
	disp('Bad ipc data!')
end

if(sum(recv_data2==data2)==numel(data2))
	disp('TCP test passed!')
else
	disp('Bad tcp data!')
end

if ~ispc
    exit
end