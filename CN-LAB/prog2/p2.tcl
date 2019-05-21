set ns [new Simulator]

set tf [open out2.tr w]
$ns trace-all $tf

set nf [open out2.nam w]
$ns namtrace-all $nf

set cwind1 [open win1.tr w]

set cwind2 [open win2.tr w]

set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]

$ns duplex-link $n1 $n3 2Mb 2ms DropTail
$ns duplex-link $n2 $n3 2Mb 2ms DropTail
$ns duplex-link $n3 $n4 2Mb 2ms DropTail
$ns duplex-link $n4 $n5 2Mb 2ms DropTail
$ns duplex-link $n4 $n6 2Mb 2ms DropTail

#$ns duplex-link-op $n0 $n2 orient right-down
#$ns duplex-link-op $n $n2 orient left-down
#$ns duplex-link-op $n3 $n4 orient right
#$ns duplex-link-op $n4 $n3 orient left
#$ns duplex-link-op $n4 $n5 orient right-up
#$ns duplex-link-op $n4 $n6 orient right-down


set tcp1 [new Agent/TCP]
$ns attach-agent $n1 $tcp1

set sink1 [new Agent/TCPSink]
$ns attach-agent $n6 $sink1

$ns connect $tcp1 $sink1

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1

$tcp1 set fid_ 1

$ns color 1 blue

set tcp2 [new Agent/TCP]
$ns attach-agent $n2 $tcp2

set sink2 [new Agent/TCPSink]
$ns attach-agent $n5 $sink2

$ns connect $tcp2 $sink2

set telnet2 [new Application/Telnet]
$telnet2 attach-agent $tcp2

$tcp2 set fid_ 2

$ns color 2 red

proc plotWindow {tcpSource file} {
global ns
set time 0.01
set now [$ns now]
set cwnd [$tcpSource set cwnd_]
puts $file "$now $cwnd"
$ns at [expr $now+$time] "plotWindow $tcpSource $file"}

$ns at 2.0 "plotWindow $tcp1 $cwind1"
$ns at 2.0 "plotWindow $tcp2 $cwind2"

proc finish {} {
	global ns tf nf
	$ns flush-trace
	close $tf
	close $nf
	exec nam out2.nam &
	exec xgraph win1.tr &
	exec xgraph win2.tr &
	exit 0
}
$ns at 0.2 "$ftp1 start"
$ns at 5.2 "$ftp1 stop"
$ns at 0.5 "$telnet2 start"
$ns at 4.5 "$telnet2 stop"
$ns at 5.0 "finish"
$ns run



