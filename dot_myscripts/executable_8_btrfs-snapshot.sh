#!/bin/bash

# run the whole script as root 
[ "$EUID" -ne 0 ] && echo "This script requires root privileges." && exec sudo sh "$0" "$@"; 

# # current system partition /dev/sdX#
current_subvolume_partition=$(df --output=source / | tail -1)

# snapshot directory with random
mounted_snap_dir="/run/snapshot_dir/"$RANDOM

# if this path /run/snapshot_dir/"$RANDOM dosen't exist then create it
[ ! -e "$mounted_snap_dir" ] && mkdir -p $mounted_snap_dir

# mount my BTRFS system (/dev/sdX#) into mounted_snap_dir
mount $current_subvolume_partition $mounted_snap_dir

# if info.csv file dosen't exist then create it
[ ! -e "$mounted_snap_dir/@.snapshots/info.csv" ] && echo "----S.No----,----DirName----,----Subvol----,----Comment----," > $mounted_snap_dir/@.snapshots/info.csv

# if /tmp/reboot_now file dont exist that means system is rebooted now so remove every [ LIVE ] form info.csv file
[ ! -e "/tmp/reboot_now" ] && sed -i 's/\[ LIVE \] //g' $mounted_snap_dir/@.snapshots/info.csv







list_snapshot() {

	# list snapshots info.csv
	cat $mounted_snap_dir/@.snapshots/info.csv | column -t -s "," -o '  |  '


}


edit_csvfile() {

	# file path
	csv_file=$mounted_snap_dir/@.snapshots/info.csv

	read -p "Enter the entry number: " entry_number

	# show selected line only
	# awk -F',' -v serial="$entry_number" '$1 == serial { print }' $csv_file  # (for backup)
	awk -F',' -v serial="$entry_number" '$1 == serial' $csv_file | column -t -s "," -o '  | '

	read -p "Enter the new comment: " new_comment

	# change the enter in the file
	awk -v entry="$entry_number" -v comment="$new_comment" -F',' '
	    BEGIN { OFS = FS }
	    $1 == entry { $4 = comment }
	    { print }
	' "$csv_file" > tmpfile && mv tmpfile "$csv_file"

	# list snapshots info.csv
	cat $mounted_snap_dir/@.snapshots/info.csv | column -t -s "," -o '  |  '

}




create_snapshot() {
	ls $mounted_snap_dir
	read -p "Enter subvolume name Seprate it by space : " -a subvolume_name
	read -p "Enter comment for snapshot: "                comment

	# directory name inside @.snapshots
	local dateDirName=$(date +'%a_%d%b%Y_%I.%M.%S%p')

	# create directory where new snapshot will store
	mkdir $mounted_snap_dir/@.snapshots/$dateDirName

	# Convert the subvolume_name string to an array
	# local selected_subvolumes=($subvolume_name)  ### addded -a at read time

	# creating snapshot one by one in for-loop
	for my_subvol in "${subvolume_name[@]}"; do
		btrfs subvolume snapshot -r $mounted_snap_dir/$my_subvol $mounted_snap_dir/@.snapshots/$dateDirName/$my_subvol > /dev/null
	done

	# serial Number for CSV file  ## last line number +1
	local serialNumber=$(awk -F',' '/[^[:space:]]/ {last=$1} END {last += 1; print last}' $mounted_snap_dir/@.snapshots/info.csv)

	# present subvolume inside new snapshot directory
	local real_subvols=$(ls -1 $mounted_snap_dir/@.snapshots/$dateDirName | tr '\n' ' ')

	# setting up CSV file for logs
	echo "$serialNumber,$dateDirName,$real_subvols,$comment,"             >> $mounted_snap_dir/@.snapshots/info.csv

	# if there is only one line in the info.csv file after creating the snapshot  (add <<< I'm here) there
	[ $serialNumber -eq 1 ] && sed -i "2s/$/<<< I'm here/" "$mounted_snap_dir/@.snapshots/info.csv"


	# list snapshots info.csv
	cat $mounted_snap_dir/@.snapshots/info.csv | column -t -s "," -o '  |  '

	# message on terminal
	tput setaf 2    # Set text color to green
	echo "snapshot created sucesfully :p"
	tput sgr0       # Reset text attributes



}




delete_snapshot() {

	# list snapshots info.csv
	cat $mounted_snap_dir/@.snapshots/info.csv | column -t -s "," -o '  |  '

	read -p "Enter Snapshot number to Delete Seprate it by space : " -a del_snap

	# Convert the subvolume_name string to an array
	# local selected_subvolumes=($del_snap) ### added -a at read time

	# if the file exist then assing the file value in variable otherwise assign null 
	[ -e "/tmp/reboot_now" ] && local live_system_snapshot=$(cat /tmp/reboot_now) || local live_system_snapshot="null"

	# creating snapshot one by one in for-loop
	for my_subvol in "${del_snap[@]}"; do

		# Find the directoryName (datedir) where first column == my_subvol
		local snapshot_dir_Name=$(awk -F ',' -v var="$my_subvol" '$1 == var { print $2 }' $mounted_snap_dir/@.snapshots/info.csv)

		# protacting system to delete live mounted current snapshot
		[ "$snapshot_dir_Name" == "$live_system_snapshot" ] && { echo "$(tput setaf 1)Please Reboot to delete LIVE snapshot number $my_subvol $(tput sgr0)"; continue; } || :
	
		# delete that selected snapshots
		btrfs subvolume delete $mounted_snap_dir/@.snapshots/$snapshot_dir_Name/*  > /dev/null

		# delete that directory also rmdir /snapsdir
		rmdir $mounted_snap_dir/@.snapshots/$snapshot_dir_Name

		# remove the entery from csv file where snapshot_dir_Name exist
		sed -i "/,$snapshot_dir_Name,/d" $mounted_snap_dir/@.snapshots/info.csv

	done

	# list snapshots info.csv
	cat $mounted_snap_dir/@.snapshots/info.csv | column -t -s "," -o '  |  '


	# message on terminal
	tput setaf 2    # Set text color to green
	echo "snapshot deleted sucesfully :)"
	tput sgr0       # Reset text attributes

	## add feature :: cannot delete live system subvolume after rollback

}



rollback_snapshot() {

	# list snapshots info.csv
	cat $mounted_snap_dir/@.snapshots/info.csv | column -t -s "," -o '  |  '

	read -p "Enter Snapshot number to rollback : "  rollback_number

	# Find the directoryName (datedir) where first column == rollback_number 
	local snapshot_dir_Name=$(awk -F ',' -v var="$rollback_number" '$1 == var { print $2 }' $mounted_snap_dir/@.snapshots/info.csv)

	# actual snapshot subvolume available 
	ls $mounted_snap_dir/@.snapshots/$snapshot_dir_Name/

	read -p "Enter Snapshot subvolume to rollback seprate by space : "  -a rollback_subvol


	# taking current system snapshot #########################################################################

	# directory name inside @.snapshots
	local dateDirName=$(date +'%a_%d%b%Y_%I.%M.%S%p')

	# create directory where new snapshot will store
	mkdir $mounted_snap_dir/@.snapshots/$dateDirName


	for all_current_subvol in "${rollback_subvol[@]}"; do

		# move current system subvolume into new snapshot directory
		mv $mounted_snap_dir/$all_current_subvol $mounted_snap_dir/@.snapshots/$dateDirName/$all_current_subvol

		# making these snapshot read-only
		btrfs property set $mounted_snap_dir/@.snapshots/$dateDirName/$all_current_subvol ro true

	done

	# protecting current mounted subvolume form deletion (if this file exist that means system is not rebooted yet so don't delete this snapshot for mount protection)
	echo "$dateDirName" > /tmp/reboot_now

	## setting up csv file for taking above snapshot #######################

	# serial Number for CSV file  ## last line number +1
	local serialNumber=$(awk -F',' '/[^[:space:]]/ {last=$1} END {last += 1; print last}' $mounted_snap_dir/@.snapshots/info.csv)

	# present subvolume inside new snapshot directory
	local real_subvols=$(ls -1 $mounted_snap_dir/@.snapshots/$dateDirName | tr '\n' ' ')

	local comment="[ LIVE ] Before Restoring $snapshot_dir_Name "   ################################ this would be the live system dont delete this snapshot
	# setting up CSV file for logs
	echo "$serialNumber,$dateDirName,$real_subvols,$comment,"             >> $mounted_snap_dir/@.snapshots/info.csv


	# rollback to privious system (restoring ) ##################################################################

	for all_rollback_subvol in "${rollback_subvol[@]}"; do

		# creating read-write snapshot form read-only
		btrfs subvolume snapshot $mounted_snap_dir/@.snapshots/$snapshot_dir_Name/$all_rollback_subvol $mounted_snap_dir/$all_rollback_subvol > /dev/null

	done


	## setting up csv file for rolling back to above previous snapshot #######################

	# removing privious "I'm here" Message form complete info.csv file
	sed -i "s/<<< I'm here//" $mounted_snap_dir/@.snapshots/info.csv

	# added "I'm here" Message for crrent system snapshot
	sed -i "/,$snapshot_dir_Name,/ s/\$/<<< I'm here/" $mounted_snap_dir/@.snapshots/info.csv

	# list snapshots info.csv
	cat $mounted_snap_dir/@.snapshots/info.csv | column -t -s "," -o '  |  '

	# message on terminal
	tput setaf 2    # Set text color to green
	echo "System Restored Sucesfully REBOOT NOW :)"
	tput sgr0       # Reset text attributes


}







case $1 in
	edit    )    edit_csvfile  ;;
	list    )   list_snapshot  ;;
	create  )  create_snapshot ;;
	delete  )  delete_snapshot ;;
	rollback) rollback_snapshot;;
	*) echo "Invalid option"   ;;
esac






##################### End of the script ######################

# unmount the mounted directory
umount $mounted_snap_dir

# delete the $RANDOM directory
[ -e "$mounted_snap_dir" ] && rmdir $mounted_snap_dir



# update grub config
grub-mkconfig -o /boot/grub/grub.cfg  &>/dev/null &







#-----------------------------------------------------------# some rough notes for reminder #----------------------------------------------------------#


# ###########      how to take snapshot       #############

# sudo mount /dev/sda3 /mnt 

# sudo btrfs subvolume snapshot -r @			 @.snapshots/@
# sudo btrfs subvolume snapshot -r @home 	 	 @.snapshots/@home

# sudo btrfs subvolume delete @
# sudo btrfs subvolume delete @home

# you cannot directlly delete subvoluem but you can move and then delete
# to rollback you have to keep old snapsohts and dont delete it because system in mounted there but you can delete old snapshot after reboot

# you need to create /run/btrsn somthing to mount your snapshots but you can put all your snapshots in @.snapshots



#if you have ~/ dont use this in double or single quote it wil not work but if you have  directory like without tilda like  "/home/t/any" double quotes are fine there


####### delete entry form csv file on multiple entery working (this can be use when you need actual numbering in line instead of non-serial number indexing) #############
# cat -n -b data.csv | column -t -s "," -o '  |  '
# read -p "Enter Snapshot name to Delete Seprate it by space : " -a lines
# sed -i "$(printf "%sd;" "${lines[@]}")" data.csv
# echo "Selected lines have been deleted from data.csv"

# cat data.csv | cut -d ',' -f 1 | tail -n 1       ## first column last line SN
# serialNumber=$(($(tail -n 1 data.csv | cut -d ',' -f 1) + 1))

# check the vairble scope



# cat -n -b $mounted_snap_dir/@.snapshots/info.csv | column -t -s "," -o '  |  '
# -n means numbering
# -b means dont count black lines in number


# For grub-btrfs
# is there any way to mount @home @ and other subvolume on grub-btrfs using fstab
# can i take one master snapshot
# .......take read-write one complete snapshot
# ...... add entry to grub for snapshot and it's discription


# command > /dev/null		(This redirects the standard output (stdout) of the command to /dev/null, effectively discarding the output.)
# command 2> /dev/null	(If you also want to discard error messages (standard error or stderr), you can use 2>)
# command &> /dev/null	(To discard both stdout and stderr in a bash shell, you can use &>)
# command &> /dev/null &	((To discard both stdout and stderr without occupying time on terminal run in background)


# some links 
	# https://unix.stackexchange.com/questions/18912/how-to-create-a-read-only-snapshot-in-btrfs  ( how to make any btrfs snapshot read-only    )
	# https://gist.github.com/goetzc/e4241e33b1d1363ad2ea9b7ef14b6ee2                             ( find difference between two btrfs snapshots )
	# https://github.com/sysnux/btrfs-snapshots-diff                                              ( find difference between two btrfs snapshots ) 
