BEGIN{
	hdrsize=0;
	ruvdsize=0;
	starttime=999;
	stoptime=0;
}
{
time=$2;
if($4=="AGT" && $1=="s" && $8 >= 512)
{
if(time < starttime)
{
starttime=time;
}
}
if($4=="AGT" && $1=="r" && $8 >= 512)
{
if(time > stoptime)
{
stoptime=time;
}
hdrsize=$8%512;
$8-=hdrsize;
ruvdsize+=$8;
}
}
END{
printf("goodput = %f ",(ruvdsize)/(stoptime-starttime)*8/1000);
}

