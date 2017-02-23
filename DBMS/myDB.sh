#! /bin/bash
export tbName
export dbName
export updateValues
updateValues=""

clear
function findDir {
	# search for main dir
	typeset found=0
	for item in `ls  `
	do  
	
		if [ -d $item -a $item = 'myDB' ]
		then
		
			found=1
		fi
	done

	if [ $found = 1 ]
	then 
		echo 'SEIF-DB found'
	else 
		
		mkdir myDB
		initDB
		build main-menu
		build db-menu
		build tbs-menu
		build tb-menu
		mkdir myDB/dbs
		
		
	fi
}

function greeting {
	echo '                    -------- Welcome to SEIF-DB ---------'
}

function build {
	typeset  index=1
	typeset lines=0
	typeset rows=0
	lines=`cat myDB/$1 | wc -l`
	let lines=$lines/2
	rows=$lines
	echo ". ./functions.sh print $1">myDB/cmd-$1.sh
	echo "select choice in \`cat myDB/$1 | head -$lines\` ">>myDB/cmd-$1.sh
		
	echo "do" >>myDB/cmd-$1.sh
	
	echo	"case \$REPLY in" >>myDB/cmd-$1.sh

	while [ $index -le $rows ]
	do
		echo "	$index) `tail -$lines myDB/$1 | head -1 `">>myDB/cmd-$1.sh
		echo ";;">>myDB/cmd-$1.sh
		(( index = $index + 1 ))
		(( lines = $lines - 1 ))
	done
		echo "esac">>myDB/cmd-$1.sh
        echo "done">>myDB/cmd-$1.sh
}

function displayMenu {
	
	echo "----------$1------------"
	select choice in `cat myDB/$1` 
	do
		clear
		case $REPLY in
		1) . ./functions.sh next db-menu
		;;
		2) echo Use_an_existent_DB.
		;;
		3) . ./functions.sh list myDB
		;;
		4) echo Delete_a_DB.
		;;
		5) echo "Bye"; break
		;;
		esac
	done
}

function initDB {
	echo 'Creat_new_DB.' > myDB/main-menu
	echo 'Use_an_existent_DB.' >> myDB/main-menu
	echo 'Show_DBs.' >> myDB/main-menu
	echo 'Delete_a_DB.' >> myDB/main-menu
	echo 'Exit.' >> myDB/main-menu
	echo 'clear;. ./functions.sh create db;'>> myDB/main-menu
	echo 'clear;. ./functions.sh select db;' >> myDB/main-menu
	echo 'clear;. ./functions.sh list dbs' >> myDB/main-menu
	echo 'clear;. ./functions.sh delete db' >> myDB/main-menu
	echo 'exit' >> myDB/main-menu
	
	echo 'Show_Tables.' > myDB/db-menu
	echo 'Tables_actions.' >> myDB/db-menu
	echo 'Main_menu.' >> myDB/db-menu
	echo 'clear;. ./functions.sh list tbs' >> myDB/db-menu
	echo 'clear;. myDB/cmd-tbs-menu.sh' >> myDB/db-menu
	echo 'clear;break' >> myDB/db-menu

	echo 'Select_table.' > myDB/tbs-menu
	echo 'Create_table.' >> myDB/tbs-menu
	echo 'Delete_table.' >> myDB/tbs-menu
	echo 'Data-Base_menu.' >> myDB/tbs-menu
	echo 'clear;. ./functions.sh select tb;' >> myDB/tbs-menu
	echo 'clear;. ./functions.sh create tb' >> myDB/tbs-menu
	echo 'clear;. ./functions.sh delete tb' >> myDB/tbs-menu
	echo 'clear;break ' >> myDB/tbs-menu

	echo 'Select*from_table.' > myDB/tb-menu
	echo 'Update_table.' >> myDB/tb-menu
	echo 'Insert_data_table.' >> myDB/tb-menu
	echo 'Tables_menu.' >> myDB/tb-menu
	echo "clear;. ./table.sh show" >> myDB/tb-menu
	echo 'clear;. ./table.sh update' >> myDB/tb-menu
	echo 'clear;. ./table.sh insert' >> myDB/tb-menu
	echo 'clear;break' >> myDB/tb-menu
}
#-------------------------------------------------------------

greeting
findDir
date


. myDB/cmd-main-menu.sh
#echo $found
#. ./functions.sh search myDB
#echo $found



