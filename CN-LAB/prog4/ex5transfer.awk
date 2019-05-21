BEGIN{
	count=0;
	time=0;
	total_bytes_sent=0;
	total_bytes_received=0;
}
{
if($1=="r" && $4==1 && $5=="tcp")
	total_bytes_received+=$6;
if($1=="+" && $3==0 && $5=="tcp")
	total_bytes_sent+=$6;
}
END{
printf("transmission time required to transfer file=%f\n",$2);
printf("actual data sent from server is %fMbps\n",total_bytes_sent/1000000);
printf("data received by client is %f Mbps\n",total_bytes_received/1000000);
}

