#! /bin/bash



if [ $1 = 'select' ]
then
	
		if [ $2 = 'db' ]
		then
			read -p "enter  name :" name
			typeset -i found=0
			for item in `ls myDB/dbs  `
			do  
	
				if [  $item = $name ]
				then
		
				found=1
				fi
			done

			if [ $found = 1 ]
			then 
		
				dbName=$name
				echo $dbName
				. ./functions.sh print DB_menu; . myDB/cmd-db-menu.sh;
				else 
				echo "not found";
				dbName=""
			fi
			
		elif [ $2 = 'tb' ]
		then
			read -p "enter  name :" name
			typeset -i found=0
			for item in `ls myDB/dbs/$dbName  `
			do  
	
				if [  $item = $name ]
				then
		
				found=1
				fi
			done

			if [ $found = 1 ]
			then 
		
				tbName=$name
				echo $tbName
				
				. myDB/cmd-tb-menu.sh;
			else
			 echo "not found"
			tbName=""
			fi
		 fi
	

elif [ $1 = 'create' ]
then	
		typeset -i found=0
		if [ $2 = 'db' ]
		then
			read -p "enter db name :" name
			for item in `ls myDB/dbs `
			do  
	
			if [  $item = $name ]
			then
		
				found=1
			fi
			done
			if [ $found = 1 ]
			then 
				echo 'already exists'
			else
		
				echo 'db created'
				mkdir myDB/dbs/$name
				dbName=$name
				echo "---------------------------";
				echo "           $name";
				echo "---------------------------";
				 . myDB/cmd-db-menu.sh;
			fi
		elif [ $2 = 'tb' ]
		then
			
			read -p "enter table name :" tb_name
			for item in `ls myDB/dbs/$dbName `
			do  
	
			if [  $item = $tbName ]
			then
		
				found=1
			fi
			done
			if [ $found = 1 ]
			then 
				echo 'already exista'
			else
				tbName=$tb_name
				. ./table.sh create
				
			fi
		
		fi
	
	
	
elif [ $1 = 'delete' ]
then	
	typeset -i found=0
	read -p "enter name :" name
	
		if [ $2 = 'db' ]
		then
			for item in `ls myDB/dbs `
			do  
	
				if [  $item = $name ]
				then
		
					found=1
				fi
				done

			if [ $found = 1 ]
			then 
			
		
				echo 'db deleted'
				rm -r myDB/dbs/$name
				dbName=''
				

			else	echo "not found to delete"
			fi
			
		elif [ $2 = 'tb' ]
		then
			for item in `ls  `
			do  
	
				if [  $item = $name ]
				then
		
					found=1
				fi
				done

			if [ $found = 1 ]
			then 
			
		
				echo 'tb deleted'
				rm myDB/dbs/dbName/$name
				tbName=''
				

			else	echo "not found to delete"
			fi			
			
			
		fi
		
	
	
	




elif [ $1 = 'list' ]
then
	
	if [ $2 = 'dbs' ]
	then
		ls myDB/dbs
	elif [ $2 = 'tbs' ]
	then
		ls myDB/dbs/$dbName
	fi
	

elif [ $1 = 'up' ]
then
	
	cd ..


elif [ $1 = 'print' ]
then
	if [ $2 = 'dbs' ]
	then
		echo "-----------------"
		echo "       $dbName   "
		echo "-----------------"
	elif [ $2 = 'tb' ]
	then
		echo "-----------------"
		echo "       $tbName   "
		echo "-----------------"
	else
		echo "-----------------"
		echo "       $2   "
		echo "-----------------"
	
	fi
	
fi

