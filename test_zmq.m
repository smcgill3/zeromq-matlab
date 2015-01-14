% (c) 2015 Stephen McGill
% MATLAB script to test zeromq-matlab
clear all;
TEST_TCP = false;

if ~ispc
    p1 = zmq( 'publish',   'ipc', 'matlab' );
    s1 = zmq( 'subscribe', 'ipc', 'matlab' );
else
    disp('0MQ IPC not supported on windows. Skipping IPC test...')
end

if TEST_TCP
    disp('Setting up TCP')
    s2 = zmq( 'subscribe', 'tcp', '*', 54321 );
    p2 = zmq( 'publish', 'tcp', '127.0.0.1', 54321 );
end

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
if TEST_TCP
    nbytes2 = zmq( 'send', p2, data2 );
else
    nbytes2 = 0;
end

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
else
    if numel(data1)==numel(recv_data1) && sum(recv_data1==data1)==numel(data1)
        disp('IPC PASS');
    else
        disp('IPC FAIL');
    end
end

if TEST_TCP
    if numel(data2)==numel(recv_data2) && sum(recv_data2==data2)==numel(data2)
        disp('TCP PASS');
    else
        disp('TCP FAIL');
    end
end

%if ~ispc
%    exit
%end