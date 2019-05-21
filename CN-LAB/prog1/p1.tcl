set ns [new Simulator]

#open trace and nam file
set tf [open out1.tr w]
$ns trace-all $tf
set nf [open out1.nam w]
$ns namtrace-all $nf

#creating nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

#physical link
$ns duplex-link $n0 $n2 1Mb 2ms DropTail
$ns duplex-link $n1 $n2 1Mb 2ms DropTail
$ns duplex-link $n2 $n3 0.2Mb 10ms DropTail

#queue limit
$ns queue-limit $n2 $n3 2

#creating udp and null and connecting them
set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1

set null1 [new Agent/Null]
$ns attach-agent $n3 $null1

$ns connect $udp1 $null1

#attaching agent to udp(cbr)
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1

#creating TCP and TCPSink and connecting them
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0

set sink0 [new Agent/TCPSink]
$ns attach-agent $n3 $sink0

$ns connect $tcp0 $sink0

#attaching agent to TCP(ftp)
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

#start and stop your Traffic
$ns at 0.2 "$ftp0 start"
$ns at 2.0 "$ftp0 stop"
$ns at 2.5 "$cbr1 start"
$ns at 4.5 "$cbr1 stop"
$ns at 5.0 "finish"

proc finish {} {
	global ns tf nf
	$ns flush-trace
	close $tf
	close $nf
	exec nam out1.nam &
	exit 0
}

$ns run

