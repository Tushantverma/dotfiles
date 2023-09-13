#!/bin/bash

# run the whole script as root 
[ "$EUID" -ne 0 ] && echo "This script requires root privileges." && exec sudo sh "$0" "$@"; 

# clear previous terminal
clear


#---------------------------------------------------------------------------------------------------------------------------------------------------------------------#
cleanup_on_interrupt() {

	# if the snapshots directory @zSnapshots have NO directorys/snapshots then delete the @zSnapshots subvolume
	# [ -z "$(find "$mounted_snap_dir/@zSnapshots"/ -mindepth 1 -type d)" ] && {  btrfs subvolume delete "$mounted_snap_dir/@zSnapshots" >/dev/null ; echo "$(tput setaf 1)  Subvolume @zSnapshots Deleted because NO snapshot exist$(tput sgr0)" ; }
	[ -z "$(ls -d "$mounted_snap_dir/@zSnapshots"/*/ 2>/dev/null)" ] && {  btrfs subvolume delete "$mounted_snap_dir/@zSnapshots" >/dev/null ; echo "$(tput setaf 1)  Subvolume @zSnapshots Deleted because NO snapshot exist$(tput sgr0)" ; }

	# unmount the mounted directory #(--lazy option will umount forcefully. Be cautious when using this option, as it can lead to data corruption if files are being actively written or read. )
	umount --lazy $mounted_snap_dir #(--lazy = -l )

	# delete the $RANDOM directory
	[ -e "$mounted_snap_dir" ] && rmdir $mounted_snap_dir

	# update grub config
	grub-mkconfig -o /boot/grub/grub.cfg  &>/dev/null &

	tput setaf 5 # magenta
	echo "#--------------SCRIPT_ENDED--------------#"
	tput sgr0    # reset

	exit 1

} 
trap cleanup_on_interrupt INT # INT means Interrupt Signa ## this will execute above function if script is Interrupted like ( ctrl + c ) and you can call the function too
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------#



# current_subvolume_partition="/dev/sdX#"              # <<< Mount Here 
current_subvolume_partition=$(df -Th | grep btrfs | awk '{print $1}' | sort -u)
[ $(echo $current_subvolume_partition | wc -w) -gt 1 ] && { echo "$(tput setaf 1)Multiple Btrfs partitions detected __PLEASE_MOUNT_MANUALLY_in_SCRIPT__$(tput sgr0)"; exit 1; }

# snapshot directory with random
mounted_snap_dir="/run/snapshot_dir/"$RANDOM

# if this path /run/snapshot_dir/"$RANDOM dosen't exist then create it
[ ! -e "$mounted_snap_dir" ] && mkdir -p $mounted_snap_dir

# mount my BTRFS system (/dev/sdX#) into mounted_snap_dir
mount $current_subvolume_partition $mounted_snap_dir



#---COMMENT THIS OR ------------------------------ Adding Snapshots in NEW Subvolume -------------------------------------------------#

# if the @zSnapshots dosent exist then create it  # this subvolume should not be mounted all the time in the file system for Safety Reasons # all snapshots will go in this subvolume
[ ! -d "$mounted_snap_dir/@zSnapshots" ] && { btrfs subvolume create "$mounted_snap_dir/@zSnapshots" >/dev/null ; echo "$(tput setaf 2)Subvolume @zSnapshots created to store snapshots.$(tput sgr0)" ; }

# snapshot subvolume (all snapshot will go in this subvolume)
at____snapshots="@zSnapshots"                        # <<< Assign here





#---COMMENT THIS ---------------------------------- Adding Snapshots in Existing Subvolume -------------------------------------------#

# at____snapshots=$(ls $mounted_snap_dir | grep "snapshot")
# [ -z "$at____snapshots" ] && { echo "$(tput setaf 1) @.snapshots subvolume Not Found __PLEASE_ASSIGN_MANUALLY_in_SCRIPT__$(tput sgr0)"; cleanup_on_interrupt ; }





# if info.csv file dosen't exist then create it
[ ! -e "$mounted_snap_dir/$at____snapshots/info.csv" ] && echo "----S.No----,----DirName----,----Subvol----,----Comment----," > $mounted_snap_dir/$at____snapshots/info.csv

# if /tmp/reboot_now file dont exist that means system is rebooted now so remove every [ LIVE ] form info.csv file
[ ! -e "/tmp/reboot_now" ] && sed -i 's/\[ LIVE \] //g' $mounted_snap_dir/$at____snapshots/info.csv










list_snapshot() {

	# list snapshots info.csv
	printf "\n"  #empty line
	cat $mounted_snap_dir/$at____snapshots/info.csv | column -t -s "," -o '  |  '
	printf "\n"  #empty line


}


edit_csvfile() {

	# list snapshots info.csv
	list_snapshot #function

	# file path
	csv_file=$mounted_snap_dir/$at____snapshots/info.csv

	read -p "Enter the entry number (space-separated) : " entry_number_var && entry_number=($(echo "$entry_number_var" | tr ' ' '\n' | sort -u)) # only take uniques

	# grab first column
	local indexx=$(cat $csv_file | awk -F ',' 'NR>1 {print $1}' | tr '\n' ' ')

	for entry_number1 in "${entry_number[@]}" ; do

		# exceptional case (if entered number dose not exist)
		[[ ! " $indexx " =~ " $entry_number1 " ]] && { echo "$(tput setaf 1)Entery $entry_number1 not found $(tput sgr0)" ; continue ; }

		# show selected line only
		# awk -F',' -v serial="$entry_number1" '$1 == serial { print }' $csv_file  # (for backup)
		awk -F',' -v serial="$entry_number1" '$1 == serial' $csv_file | column -t -s "," -o '  | '

		read -p "Enter the new comment: " new_comment

		# change the enter in the csv file
		awk -v entry="$entry_number1" -v comment="$new_comment" -F',' '
		    BEGIN { OFS = FS }
		    $1 == entry { $4 = comment }
		    { print }
		' "$csv_file" > tmpfile && mv tmpfile "$csv_file"

	done

	# list snapshots info.csv
	list_snapshot #function

}




create_snapshot() {
	tput setaf 4; tput bold;   # color dark blue
	ls $mounted_snap_dir 
	tput sgr0                  # color reset

	# how many subvolume exist
	local available_subvol=$(ls -1 $mounted_snap_dir | tr '\n' ' ')

#--------------------------------------------------------------------- READ INPUT ------------------------------------------------------------------------------------------------------#
	while true; do
	
		read -p "Enter subvolume name (space-separated) : " subvolume_name_var && subvolume_name=($(echo "$subvolume_name_var" | tr ' ' '\n' | sort -u)) # only take uniques


		# entered value should not be empty checking the array
		[ "${#subvolume_name[@]}" -eq 0 ] && { echo "$(tput setaf 1)Please Enter a Value$(tput sgr0)"; continue; }

		# preventing it to take snapshot of the subvolume where all the snapshot are stored ## to prevent system form mess-up itself
		[[ " ${subvolume_name[@]} " =~ " $at____snapshots " ]] && { echo "$(tput setaf 1)You can't take snapshot of snapshot subvolume "$at____snapshots" itself $(tput sgr0)" ; continue ; }



		local subvol_not_available="" # reseting the variable for next loop
		# if entered name dose not exist then collect those name into $subvol_not_available variable
		for my_subvol11 in "${subvolume_name[@]}"; do
			[[ ! " $available_subvol " =~ " $my_subvol11 " ]] && { subvol_not_available="$subvol_not_available$my_subvol11 "; }
		done
		# if the variable is non-empty then print whats in the $subvol_not_available and if empty then break the script
		[ ! -z "$subvol_not_available" ] && { echo "$(tput setaf 1)Entery $subvol_not_available not found $(tput sgr0)" ; continue ; } ||  break ;

	done

	read -p "Enter comment for snapshot: "                comment
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#




	# directory name inside $at____snapshots
	local dateDirName=$(date +'%a_%d%b%Y_%I.%M.%S%p')

	# create directory where new snapshot will store
	mkdir $mounted_snap_dir/$at____snapshots/$dateDirName

	# creating snapshot one by one in for-loop
	for my_subvol in "${subvolume_name[@]}"; do
		btrfs subvolume snapshot -r $mounted_snap_dir/$my_subvol $mounted_snap_dir/$at____snapshots/$dateDirName/$my_subvol > /dev/null
	done

	# serial Number for CSV file  ## last line number +1
	local serialNumber=$(awk -F',' '/[^[:space:]]/ {last=$1} END {last += 1; print last}' $mounted_snap_dir/$at____snapshots/info.csv)

	# present subvolume inside new snapshot directory
	local real_subvols=$(ls -1 $mounted_snap_dir/$at____snapshots/$dateDirName | tr '\n' ' ')

	# setting up CSV file for logs
	echo "$serialNumber,$dateDirName,$real_subvols,$comment,"             >> $mounted_snap_dir/$at____snapshots/info.csv

	# if there is only one line in the info.csv file after creating the snapshot  (add <<< I'm here) there
	[ $serialNumber -eq 1 ] && sed -i "2s/$/<<< I'm here/" "$mounted_snap_dir/$at____snapshots/info.csv"


	# list snapshots info.csv
	list_snapshot #function

	# message on terminal
	tput setaf 2    # Set text color to green
	echo "snapshot created sucesfully :p"
	tput sgr0       # Reset text attributes



}




delete_snapshot() {

	# list snapshots info.csv
	list_snapshot #function

	read -p "Enter Snapshot number to Delete (space-separated) : " del_snap_var && del_snap=($(echo "$del_snap_var" | tr ' ' '\n' | sort -u)) # only take uniques


	# if the file exist then assing the file value in variable otherwise assign null 
	[ -e "/tmp/reboot_now" ] && local live_system_snapshot=$(cat /tmp/reboot_now) || local live_system_snapshot="null"

	# grab first column
	local indexx=$(cat $mounted_snap_dir/$at____snapshots/info.csv | awk -F ',' 'NR>1 {print $1}' | tr '\n' ' ')


	deleted_snapshot_number=0
	# creating snapshot one by one in for-loop
	for my_subvol in "${del_snap[@]}"; do

		# exceptional case (if entered number dose not exist)
		[[ ! " $indexx " =~ " $my_subvol " ]] && { echo "$(tput setaf 1)Entery $my_subvol not found $(tput sgr0)" ; continue ; }

		# Find the directoryName (datedir) where first column == my_subvol
		local snapshot_dir_Name=$(awk -F ',' -v var="$my_subvol" '$1 == var { print $2 }' $mounted_snap_dir/$at____snapshots/info.csv)

		# protacting system to delete live mounted current snapshot
		[ "$snapshot_dir_Name" == "$live_system_snapshot" ] && { echo "$(tput setaf 1)Please Reboot to delete LIVE snapshot number $my_subvol $(tput sgr0)"; continue; } || :
	
		# delete that selected snapshots
		btrfs subvolume delete $mounted_snap_dir/$at____snapshots/$snapshot_dir_Name/*  > /dev/null

		# delete that directory also rmdir /snapsdir
		rmdir $mounted_snap_dir/$at____snapshots/$snapshot_dir_Name

		# remove the entery from csv file where snapshot_dir_Name exist
		sed -i "/,$snapshot_dir_Name,/d" $mounted_snap_dir/$at____snapshots/info.csv

		((deleted_snapshot_number++))

	done

	# list snapshots info.csv
	list_snapshot #function


	# message on terminal
	tput setaf 2    # Set text color to green
	echo "Total $deleted_snapshot_number snapshot deleted..!!"
	tput sgr0       # Reset text attributes

	## add feature :: cannot delete live system subvolume after rollback

}



rollback_snapshot() {

	# list snapshots info.csv
	list_snapshot #function

	# grab first column
	local indexx=$(cat $mounted_snap_dir/$at____snapshots/info.csv | awk -F ',' 'NR>1 {print $1}' | tr '\n' ' ')





	while true; do

		read -p "Enter Snapshot number to rollback : "  rollback_number #enter only one digit

		# Entery should not be empty
		[ -z "$rollback_number" ] && { echo "$(tput setaf 1)Please Enter a number $(tput sgr0)"; continue ; }

		# stop entering multiple input only enter one input
		[ $(echo $rollback_number | wc -w) -gt 1 ] && { echo "$(tput setaf 1)Multiple Input NOT allowd $(tput sgr0)"; continue ; }

		# exceptional case (if entered number dose not exist)
		[[ ! " $indexx " =~ " $rollback_number " ]] && { echo "$(tput setaf 1)Entery $rollback_number not found $(tput sgr0)" ; continue ; } || break ;

	done






	# Find the directoryName (datedir) where first column == rollback_number 
	local snapshot_dir_Name=$(awk -F ',' -v var="$rollback_number" '$1 == var { print $2 }' $mounted_snap_dir/$at____snapshots/info.csv)

	# actual snapshot subvolume available 
	tput setaf 4; tput bold;   # color dark blue
	ls $mounted_snap_dir/$at____snapshots/$snapshot_dir_Name/
	tput sgr0                  # color reset

	# available snapshot present in snapshot directory (only take current system snapshot of those which are rollbacking)
	local available_subvol=$(ls -1 $mounted_snap_dir/$at____snapshots/$snapshot_dir_Name | tr '\n' ' ')




while true; do

	read -p "Enter Snapshot subvolume to rollback (space-separated) : " rollback_subvol_var && rollback_subvol=($(echo "$rollback_subvol_var" | tr ' ' '\n' | sort -u)) # only take uniques

	# Entery should not be empty
	[ -z "$rollback_subvol" ] && { echo "$(tput setaf 1)Please Enter a Subvolume $(tput sgr0)"; continue ; }


	not_rollback_subvol=""
	for all_present_subvol in "${rollback_subvol[@]}"; do
		# exceptional case (if entered subvolume dose not exist)
		[[ ! " $available_subvol " =~ " $all_present_subvol " ]] &&  { not_rollback_subvol="$not_rollback_subvol$all_present_subvol "; }
	done
	# if the variable is non-empty then print whats in the $not_rollback_subvol and if empty then break the script
	[ ! -z "$not_rollback_subvol" ] && { echo "$(tput setaf 1)Entery $not_rollback_subvol not found $(tput sgr0)" ; continue ; } ||  break ;




done







	# taking current system snapshot ####################################################################################################################################


	# directory name inside $at____snapshots
	local dateDirName=$(date +'%a_%d%b%Y_%I.%M.%S%p')

	# create directory where new snapshot will store
	mkdir $mounted_snap_dir/$at____snapshots/$dateDirName


	for all_current_subvol in "${rollback_subvol[@]}"; do

		# move current system subvolume into new snapshot directory
		mv $mounted_snap_dir/$all_current_subvol $mounted_snap_dir/$at____snapshots/$dateDirName/$all_current_subvol

		# making these snapshot read-only
		btrfs property set $mounted_snap_dir/$at____snapshots/$dateDirName/$all_current_subvol ro true

	done




	## setting up csv file for taking above snapshot #-<<<<<<<<<< ------------------------------------------------------------------------

	# serial Number for CSV file  ## last line number +1
	local serialNumber=$(awk -F',' '/[^[:space:]]/ {last=$1} END {last += 1; print last}' $mounted_snap_dir/$at____snapshots/info.csv)

	# present subvolume inside new snapshot directory
	local real_subvols=$(ls -1 $mounted_snap_dir/$at____snapshots/$dateDirName | tr '\n' ' ')

	local comment="[ LIVE ] Before Restoring $snapshot_dir_Name "   ################################ this would be the live system dont delete this snapshot
	# setting up CSV file for logs
	echo "$serialNumber,$dateDirName,$real_subvols,$comment,"             >> $mounted_snap_dir/$at____snapshots/info.csv





	# rollback to privious system (restoring ) ########################################################################################################################


	for all_rollback_subvol in "${rollback_subvol[@]}"; do

		# creating read-write snapshot form read-only
		btrfs subvolume snapshot $mounted_snap_dir/$at____snapshots/$snapshot_dir_Name/$all_rollback_subvol $mounted_snap_dir/$all_rollback_subvol > /dev/null

	done


	## setting up csv file for rolling back to above previous snapshot #######################

	# removing privious "I'm here" Message form complete info.csv file
	sed -i "s/<<< I'm here//" $mounted_snap_dir/$at____snapshots/info.csv

	# added "I'm here" Message for crrent system snapshot
	sed -i "/,$snapshot_dir_Name,/ s/\$/<<< I'm here/" $mounted_snap_dir/$at____snapshots/info.csv

	# list snapshots info.csv
	list_snapshot #function


	# protecting current mounted subvolume form deletion (if this file exist that means system is not rebooted yet so don't delete this snapshot for mount protection)
	# if the file present that means i have just rollbacked and if the file is not present then make it to prevent deleting mounted subvolume
	[ -e "/tmp/reboot_now" ] && echo "$(tput setaf 1)your System is still mounted to -----:$(cat /tmp/reboot_now):----- snapshots please REBOOT bro$(tput sgr0)" || echo "$dateDirName" > /tmp/reboot_now

	# message on terminal
	tput setaf 2    # Set text color to green
	echo "System Restored Sucesfully REBOOT NOW :)"
	tput sgr0       # Reset text attributes


}




while true; do


tput setaf 3 # applying yellow
echo "edit list create delete rollback exit"
tput sgr0  # reset

read -p "command : " entry1
clear
  

	case $entry1 in
		edit     )    edit_csvfile       ;;
		list     )    list_snapshot      ;;
		create   )   create_snapshot     ;;
		delete   )   delete_snapshot     ;;
		rollback )  rollback_snapshot    ;;
		exit     ) cleanup_on_interrupt  ;;
		*        ) echo "Invalid option" ;;
	esac


done



##################### End of the script ######################



#-----------------------------------------------------------# some rough notes for reminder #----------------------------------------------------------#


# ###########      how to take snapshot       #############

# sudo mount /dev/sda3 /mnt 

# sudo btrfs subvolume snapshot -r @			 $at____snapshots/@
# sudo btrfs subvolume snapshot -r @home 	 	 $at____snapshots/@home

# sudo btrfs subvolume delete @
# sudo btrfs subvolume delete @home

# you cannot directlly delete subvoluem but you can move and then delete
# to rollback you have to keep old snapsohts and dont delete it because system in mounted there but you can delete old snapshot after reboot

# you need to create /run/btrsn somthing to mount your snapshots but you can put all your snapshots in $at____snapshots



#if you have ~/ dont use this in double or single quote it wil not work but if you have  directory like without tilda like  "/home/t/any" double quotes are fine there


####### delete entry form csv file on multiple entery working (this can be use when you need actual numbering in line instead of non-serial number indexing) #############
# cat -n -b data.csv | column -t -s "," -o '  |  '
# read -p "Enter Snapshot name to Delete Seprate it by space : " -a lines
# sed -i "$(printf "%sd;" "${lines[@]}")" data.csv
# echo "Selected lines have been deleted from data.csv"

# cat data.csv | cut -d ',' -f 1 | tail -n 1       ## first column last line SN
# serialNumber=$(($(tail -n 1 data.csv | cut -d ',' -f 1) + 1))

# check the vairble scope



# cat -n -b $mounted_snap_dir/$at____snapshots/info.csv | column -t -s "," -o '  |  '
# -n means numbering
# -b means dont count black lines in number


# For grub-btrfs
# is there any way to mount @home @ and other subvolume on grub-btrfs using fstab
# can i take one master snapshot
# .......take read-write one complete snapshot
# ...... add entry to grub for snapshot and it's discription


# command > /dev/null		(This redirects the standard output (stdout) of the command to /dev/null, to silence the standard output of a command) for output log (command 1> output.log)
# command 2> /dev/null	    (This redirects the standard errors (stderr) of the command to /dev/null, to silence the standard errors of a command) for error log (command 2> error.log)
# command &> /dev/null	    (This redirects both standard output (stdout) and standard errors (stderr)to silence ) for output and error log  (command &> output_error.log) can also be use for same (>/dev/null 2>&1)
# command &> /dev/null &	(same above and also command will run asynchronously, and the shell won't wait for it to complete)
# command | tee -a output.log   ( tee -a output.log   is equal to    >> output.log ) it can also show the command on display and also add there output and errors in the output.log file

# exit 1 (program exit with an error)
# exit 0 (program exit with no error)


# some links 
	# https://unix.stackexchange.com/questions/18912/how-to-create-a-read-only-snapshot-in-btrfs  ( how to make any btrfs snapshot read-only    )
	# https://gist.github.com/goetzc/e4241e33b1d1363ad2ea9b7ef14b6ee2                             ( find difference between two btrfs snapshots )
	# https://github.com/sysnux/btrfs-snapshots-diff                                              ( find difference between two btrfs snapshots ) 
