BEGIN {
	pkt=0;
	time=0;
	#res=0;
}
{
if($1=="r" && $9==1.0 && $10==4.0)
{
	pkt=pkt+$6;
	time=$2;
	#res=pkt*8/time*1000000;
}
}
END {
printf("Throughput = %d \n",pkt*8/time*1000000);
}
