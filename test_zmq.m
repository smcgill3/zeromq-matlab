% (c) 2015 Stephen McGill
% MATLAB script to test zeromq-matlab
clear all;
TEST_TCP = true;

if ~ispc
    p1 = zmq( 'publish',   'ipc', 'matlab' );
    s1 = zmq( 'subscribe', 'ipc', 'matlab' );
else
    disp('0MQ IPC not supported on windows. Skipping IPC test...')
end

data1 = uint8('hello world!')';
recv_data1 = [];

disp('Sending data...')
if ~ispc
    nbytes1 = zmq( 'send', p1, data1 );
else
    nbytes1 = 0;
end

fprintf('\nSent %d bytes on the ipc channel.\n',nbytes1);
idx = zmq('poll', 1000);

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
    cnt = 1;
    disp('Setting up TCP')
    s2 = zmq( 'subscribe', 'tcp', '127.0.0.1', 43210 );
    p2 = zmq( 'publish', 'tcp', 43210 );
    data2 = uint8(sprintf('#%d: %d', cnt, randi(9)));
    zmq('poll', 1000);
    nbytes2 = zmq( 'send', p2, data2 );
    idx = zmq('poll', 1000);
    [recv_data,has_more] = zmq( 'receive', idx );
    disp( 'tcp channel receiving...' );
    recv_data2 = char(recv_data');
    disp( recv_data2 );
    
    if numel(data2)==numel(recv_data2) && sum(recv_data2==data2)==numel(data2)
        disp('TCP PASS');
    else
        disp('TCP FAIL');
    end
    clear cnt;
end

%if ~ispc
%    exit
%end