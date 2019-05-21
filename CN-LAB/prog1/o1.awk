BEGIN {
	tcount=0;
	ucount=0;
}
{
if($1=="d" && $5=="tcp")
	tcount++;
if($1=="d" && $5=="cbr")
	ucount++;
}
END {
printf("no of tcp pkts dropped is=%d\n",tcount);
printf("no of udp pkts dropped is=%d\n",ucount);
}
