#! /bin/bash
typeset -i exist=0
typeset -i key=0
#typeset updateValues

function build {
	typeset  index=1
	typeset columns
	typeset rows=0
	typeset lines=0
	lines=`cat myDB/dbs/$dbName/meta-$tbName | wc -l`
	let lines=$lines-1
	
	
	columns=`cut -f1 -d: myDB/dbs/$dbName/meta-$tbName | head -$lines`
	
	
	echo "typeset -i k=0">myDB/dbs/$dbName/tableCols.sh	
	echo "select choice in "${columns[@]} 'done'" ">>myDB/dbs/$dbName/tableCols.sh
	 
	echo "do" >>myDB/dbs/$dbName/tableCols.sh
	echo	"case \$REPLY in" >>myDB/dbs/$dbName/tableCols.sh

	while [ $index -le $lines ]
	do
		echo "	$index) read -p \"enter new value : \" upd[$rows]">>myDB/dbs/$dbName/tableCols.sh
		echo ";;">>myDB/dbs/$dbName/tableCols.sh
		(( index = $index + 1 ))
		(( rows = $rows + 1 ))
	done
		echo "	$index) break ">>myDB/dbs/$dbName/tableCols.sh
		echo ";;">>myDB/dbs/$dbName/tableCols.sh
		echo "esac">>myDB/dbs/$dbName/tableCols.sh
        echo "done">>myDB/dbs/$dbName/tableCols.sh
	echo "updateValues=\${upd[*]}">>myDB/dbs/$dbName/tableCols.sh
	echo "k=0">>myDB/dbs/$dbName/tableCols.sh
	echo "for value in \${cols[*]}">>myDB/dbs/$dbName/tableCols.sh
	echo "do">>myDB/dbs/$dbName/tableCols.sh
	echo "upd[$k]=''">>myDB/dbs/$dbName/tableCols.sh
	echo "k=$k+1">>myDB/dbs/$dbName/tableCols.sh
	echo "done">>myDB/dbs/$dbName/tableCols.sh
	
}
function  valid {
	typeset k=0
	k=`cut -f1 -d: myDB/dbs/$dbName/meta-$tbName | tail -1` 
	for value in `cut -f$k -d " " myDB/dbs/$dbName/$tbName`
	do
		if [ $1 = $value ]
		then
			exist=1
			
		fi
	done
	
}

if [ $1 = 'create' ] ;
then
	typeset  col_no
	typeset -i num
	typeset	col_name
	typeset	pk
	 col_no=""
	 num=0
	col_name=""
	pk=""
	read -p "enter no. of cols :" col_no
	
	if [[ $col_no = +([0-9]) ]] 
	then
		for (( i=0; i < $col_no ; i++ ))
		do
			num=$i+1
			while [ -z $col_name ]
			do
			read -p "enter name of the $num col: " col_name
			done
			col[$i]=$col_name
			col_name=""
			echo "enter type of it : " 
			select choice in "Int" "String" 
			do
			case $REPLY in
			1) type[$i]=int;break;;
			2) type[$i]=string;break;;
			*) break;;
			esac
			done
			
		
		
		done
	
		while [ -z $pk  ]
		do
			read -p "enter col to be PK for the table : " pk
		done
		for (( x=0 ; x<$col_no ; x++ ))
		do
			if [ ${col[x]}=$pk ]
			then
			key=$x
			fi
		echo "${col[x]}:${type[x]}">> myDB/dbs/$dbName/meta-$tbName
		done
		#key=$key+1
		echo "$key:pk">> myDB/dbs/$dbName/meta-$tbName
		touch myDB/dbs/$dbName/$tbName
		num=0
		col_name=""
		pk=""
		col_no=""
		echo 'tb created'
		echo "---------------------------";
		echo "           $tb_name";
		echo "---------------------------";
		cat myDB/dbs/$dbName/meta-$tb_name
	else echo "invalid operation"
	fi
	

elif [ $1 = 'insert' ]
then
	typeset -i j=0
	typeset -i k=0
	typeset -i index=0
	typeset -i lines=0
	
	colType=`cut -f2 -d: myDB/dbs/$dbName/meta-$tbName`
	for x in $colType
	do
		value[$k]=$x
		k=$k+1;
	done
	lines=` cut -f1 -d: myDB/dbs/$dbName/meta-$tbName | wc -l`
	let lines=$lines-1
	for col in `cut -f1 -d: myDB/dbs/$dbName/meta-$tbName`
	do
	#echo "index=$index, lines=$lines, ${cols[$index]} "
	
	while [ -z ${cols[$index]} ]
	do
	if [ ${value[$j]} = "int"   ]
	then
		while [[ ${cols[$index]} != +([0-9]) ]] 
		do
		
		
		read -p "this is an int value , $col : " cols[$index]
		done
	else
		read -p "enter $col : " cols[$index]
	fi
	
	
	#echo	${cols[$index]} 
	done
	index=$index+1
	j=$j+1
	if [ $index -eq $lines ]
	then
		break;
	fi
	done
	key=$key-1
	valid ${cols[$key]}
	if [ $exist = 0 ]
	then
		
		exist=0
		echo ${cols[*]} >>myDB/dbs/$dbName/$tbName
		
	else echo "already exists, enter another value for pk to insert"
	fi
	k=0
	for value in ${cols[*]}
	do
	cols[$k]=''
	value[$k]=''
	k=$k+1	
	done

elif [ $1 = 'delete' ]
then
	typeset x=0
	x=`cut -f1 -d: myDB/dbs/$dbName/meta-$tbName | tail -1` 
	echo $x
	read -p "enter value of pk to delete : " remove
	awk -v colu="$x" -v rmv="$remove" '{ if($colu!=rmv) { print $0} } ' myDB/dbs/$dbName/$tbName > myDB/dbs/$dbName/temp-$tbName
	mv -f myDB/dbs/$dbName/temp-$tbName myDB/dbs/$dbName/$tbName


elif [ $1 = 'show' ]
then
	typeset lines=0
	typeset columns
	. ./functions.sh print tb;
	lines=`cat myDB/dbs/$dbName/meta-$tbName | wc -l`
	let lines=$lines-1
	columns=`cut -f1 -d: myDB/dbs/$dbName/meta-$tbName | head -$lines`
	echo ${columns[@]}
	cat myDB/dbs/$dbName/$tbName 
	


elif [ $1 = 'update' ]
then
	#typeset cols=0
	#typeset lines=0
	#lines=`cat myDB/dbs/seif/meta-student | wc -l`
	#let lines=$lines-1
	#cols=`cut -f1 -d: myDB/dbs/seif/meta-student | tail -1` 
	#read -p "enter value of pk to update : " update
	#select choice in `cut -f1 -d: myDB/dbs/seif/meta-student | tail -1` 
	#do 
	#case $REPLY in
	#*) 
	
	#echo $x
	
	#awk -v colu="$x" -v rmv="$remove" '{ if($colu!=rmv) { print $0} } ' myDB/dbs/seif/student > myDB/dbs/seif/temp-student
	#mv -f myDB/dbs/seif/temp-student myDB/dbs/seif/student
	read -p "enter value of pk to update : " update	
	build 
	. myDB/dbs/seif/tableCols.sh
	typeset x=0
	x=`cut -f1 -d: myDB/dbs/seif/meta-$tbName | tail -1` 
	
	echo "$updateValues"
	awk -v colu="$x" -v rmv="$update" -v val="$updateValues" '{ if($colu!=rmv) { print $0} else {print val} }' myDB/dbs/$dbName/$tbName > myDB/dbs/$dbName/temp-$tbName
	mv -f myDB/dbs/$dbName/temp-$tbName myDB/dbs/$dbName/$tbName
	
	
	
        
fi


