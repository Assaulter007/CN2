 set ns [new Simulator]

set tf [open out3.tr w]
$ns trace-all $tf

set nf [open out3.nam w]
$ns namtrace-all $nf

set cwind1 [open win3.tr w]

$ns rtproto DV

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]


$ns duplex-link $n0 $n1 3.5Mb 5ms DropTail
$ns duplex-link $n0 $n2 0.5Mb 5ms DropTail
$ns duplex-link $n1 $n4 3.5Mb 5ms DropTail
$ns duplex-link $n2 $n3 0.5Mb 5ms DropTail
$ns duplex-link $n4 $n5 3.5Mb 5ms DropTail
$ns duplex-link $n3 $n5 0.5Mb 5ms DropTail


$ns duplex-link-op $n0 $n1 orient right-up
$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n4 orient right
$ns duplex-link-op $n2 $n3 orient right
$ns duplex-link-op $n4 $n5 orient right-down
$ns duplex-link-op $n3 $n5 orient right-up

set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0

set sink0 [new Agent/TCPSink]
$ns attach-agent $n4 $sink0

$ns connect $tcp0 $sink0

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

$tcp0 set fid_ 1

$ns color 1 blue

$ns rtmodel-at 1.0 down $n1 $n4
$ns rtmodel-at 3.0 up $n1 $n4



proc plotWindow {tcpSource file} {
global ns
set time 0.01
set now [$ns now]
set cwnd [$tcpSource set cwnd_]
puts $file "$now $cwnd"
$ns at [expr $now+$time] "plotWindow $tcpSource $file"}


proc finish {} {
	global ns tf nf
	$ns flush-trace
	close $tf
	close $nf
	exec nam out3.nam &
	exec xgraph win3.tr & 
	exit 0
}

$ns at 2.0 "plotWindow $tcp0 $cwind1"
$ns at 0.1 "$ftp0 start"
$ns at 4.5 "$ftp0 stop"
$ns at 10.0 "finish"
$ns run



