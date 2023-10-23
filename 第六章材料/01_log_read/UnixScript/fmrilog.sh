#!/bin/sh
# input 1 is the log file name

outdir=${1}_output;
mkdir -p $outdir
echo Working on ${1}

sed '1,5 d' $1 > $outdir/tmp1;
sed '/Pulse/ d' $outdir/tmp1 > $outdir/newlog;

subname=`cat $outdir/newlog | awk '{ if (NR==1) print $1}'`;

# look for the starting time, 1st greenbox1 or redbox1
redt=`grep redbox1 $outdir/newlog | awk '{if (NR==1) print $5}'`;
greent=`grep greenbox1 $outdir/newlog | awk '{if (NR==1) print $5}'`;

if [ "$redt" -lt "$greent" ] ; then
startT=$redt;
else 
startT=$greent;
fi

echo "Working on subject $subname";
echo "1st redbox1 $redt; 1st greenbox1 $greent; So starting at $startT";

# Now look for each item

################
# display scale# 
################

# remove others and only keep cross and display scale
cat $outdir/newlog | sed '/be4start/ d' | sed '/box/ d' | sed '/Response/ d' | sed '/Manual/ d' \
| sed '/crossITI_8/ d' | sed '/Left/ d' | sed '/Right/ d' | awk '{print $2,$5}' > $outdir/tmp2;

#remove repeated ones
uniq -f 1 $outdir/tmp2 | grep Scale > $outdir/tmp3;

cat $outdir/newlog | sed '/be4start/ d' | sed '/box/ d' | sed '/Response/ d' | sed '/Manual/ d' \
| sed '/crossITI_8/ d' | sed '/Left/ d' | sed '/Right/ d' | awk '{print $2,$5,$6}' > $outdir/tmp2;

alls=`cat $outdir/tmp3 | wc -l`;
lines=1;
while [ $lines -le $alls ] ; do
	tmps=`sed -n ${lines}p $outdir/tmp3`;
	grep "$tmps" $outdir/tmp2 |  awk '{if (NR==1) print $3}' >> $outdir/tmp_scale;
	lines=`echo $lines + 1 | bc`;
done

################
# response     # 
################

# remove others and only keep cross and display scale
cat $outdir/newlog | sed '/be4start/ d' | sed '/box/ d' | sed '/Scale/ d' | sed '/Manual/ d' \
| sed '/crossITI_8/ d' | sed '/Left/ d' | sed '/Right/ d' | awk '{print $2,$3}' > $outdir/tmp2;

#remove repeated ones
uniq -f 1 $outdir/tmp2 | grep Response > $outdir/tmp3;

cat $outdir/newlog | sed '/be4start/ d' | sed '/box/ d' | sed '/Scale/ d' | sed '/Manual/ d' \
| sed '/crossITI_8/ d' | sed '/Left/ d' | sed '/Right/ d' | awk '{print $2,$3,$4,$6}' > $outdir/tmp2;

alls=`cat $outdir/tmp3 | wc -l`;
lines=1;
while [ $lines -le $alls ] ; do
	tmps=`sed -n ${lines}p $outdir/tmp3`;
	grep "$tmps" $outdir/tmp2 |  awk '{if (NR==1) print $4}' >> $outdir/tmp_response;
	lines=`echo $lines + 1 | bc`;
done

################
# cross        # 
################

grep crossISI_4_8 $outdir/newlog | awk '{print $5}' > $outdir/tmp_crossISI_4_8;
grep cross_4_65 $outdir/newlog | awk '{print $5}' > $outdir/tmp_cross_4_65;

################
# rating       # 
################
grep "pain"  $outdir/newlog | awk '{print $8}' > $outdir/pain.txt;
grep "difficulty"  $outdir/newlog | awk '{print $8}' > $outdir/difficulty.txt;
grep "Difference"  $outdir/newlog | awk '{print $7}' > $outdir/difference.txt;
grep "vibration"  $outdir/newlog | awk '{print $8}' > $outdir/vibration.txt;
grep "Left"  $outdir/newlog | awk '{print $5}' > $outdir/tmp_left;
grep "Right"  $outdir/newlog | awk '{print $5}' > $outdir/tmp_right;

################
# Output: substract by starting time then divide by 10000, except for response 
################

for ff in crossISI_4_8  right  cross_4_65 left response scale ; do 
	if [ "$ff" == "response" ] ; then
		alls=`cat $outdir/tmp_$ff | wc -l`;
		lines=1;
		while [ $lines -le $alls ] ; do
		sed -n ${lines}p $outdir/tmp_$ff > $outdir/tmp5;
		j=`cat $outdir/tmp5 | awk '{print $1}'`;
		m=`echo "scale=4; $j / 10000" | bc`;
		echo $m >> $outdir/${ff}.txt;
		lines=`echo $lines + 1 | bc`;
		done
		#cat $outdir/tmp_$ff | awk '{print $1,$2}' > $outdir/tmp_${ff}_1;
		#paste $outdir/tmp_${ff}_1 $outdir/tmp_${ff}_2 > $outdir/${ff}.txt;
		nnn=`cat $outdir/${ff}.txt | wc | awk '{print $1}'`;
		echo "$outdir/${ff}.txt : $nnn timing"; 
	else
		
		
		alls=`cat $outdir/tmp_$ff | wc -l`;
		lines=1;		
		
		while [ $lines -le $alls ] ; do
		sed -n ${lines}p $outdir/tmp_$ff > $outdir/tmp5;
		j=`cat $outdir/tmp5 | awk '{print $1}'`;
		jj=`echo $j - $startT | bc`;
		m=`echo "scale=4; $jj / 10000" | bc`;
		echo $m >> $outdir/${ff}.txt;
		lines=`echo $lines + 1 | bc`;
		done
		#cat $outdir/tmp_$ff | awk '{print $1}' > $outdir/tmp_${ff}_1;
		#paste $outdir/tmp_${ff}_1 $outdir/tmp_${ff}_2 > $outdir/${ff}.txt;
		nnn=`cat $outdir/${ff}.txt | wc | awk '{print $1}'`;
		echo "$outdir/${ff}.txt : $nnn timing"; 
	fi				
done

#look for missed Response
cat $outdir/newlog | sed '/be4start/ d' | sed '/box/ d' | sed '/Scale/ d' | sed '/Manual/ d' \
| sed '/crossITI_8/ d' | sed '/Left/ d' | sed '/Right/ d' > $outdir/tmp6;

grep -n cross $outdir/tmp6 | awk '{print $1}' | sed s/:$subname//g > $outdir/tmp7;

alls=`cat $outdir/tmp7 | wc -l`;
lines=1;

while [ $lines -lt $alls ] ; do
	nextone=`echo $lines + 1 | bc`;
	a=`sed -n ${lines}p $outdir/tmp7`;
	b=`sed -n ${nextone}p $outdir/tmp7`;
	dif=`echo $b - $a | bc`;
	
	if [ $dif -eq 1 ] ; then
		echo "Found one response missed!"
		echo $lines >> $outdir/tmp15;
	fi
	lines=`echo $lines + 1 | bc`;
done

alls=`cat $outdir/tmp15 | wc -l`;
lines=1;
cp $outdir/response.txt $outdir/t_response1
while [ $lines -le $alls ] ; do
	nextone=`echo $lines + 1 | bc`;
	aaa=`sed -n ${lines}p $outdir/tmp15`;
	sed -e "$aaa i\\
	missed" $outdir/t_response$lines > $outdir/t_response${nextone};
	lines=`echo $lines + 1 | bc`;
done

mv $outdir/t_response${nextone} $outdir/response.txt;
nnn=`cat $outdir/response.txt | wc | awk '{print $1}'`;
echo "$outdir/response.txt : $nnn timing"; 

rm $outdir/tmp*  $outdir/t_response*

cat $outdir/response.txt | awk '{ if (NR%2!=0) print }' > $outdir/response1.txt;
cat $outdir/response.txt | awk '{ if (NR%2==0) print }' > $outdir/response2.txt;
