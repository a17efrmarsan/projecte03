#!/bin/bash

# Make sure the script is being executed with superuser privileges.
if [[ "${UID}" -ne 0 ]]
then
	echo "No ets superusuari, no pots executar l'escript." >&2
	exit 1
fi

# Display the usage and exit.
usage() {
	echo "Us de $0 [-dar]" >&2
	echo '-d Deletes accounts instead of disabling them' >&2
	echo '-r Removes the home directory associated with the account(s)' >&2
	echo '-a Creates an archive of the home directory associated with the accounts(s) and stores the archive in the /archives directory' >&2
	exit 2
}

delete() {
	# Delete the user.
	userdel $USER
	
	# Check to see if the userdel command succeeded.
	# We don't want to tell the user that an account was deleted when it hasn't been.
	if [ "$?" -ne 0 ]
	then
		echo "L'usuari $USER no s'ha pogut eliminat." >&2
	else
		echo "L'usuari $USER ha estat eliminat."
	fi
}

archive() {
	# Create an archive if requested to do so.
	DIRECTORY=/archives
	
	# Make sure the ARCHIVE_DIR directory exists.
	if [ ! -d "$DIRECTORY" ]
	then
		echo "No existeix el directori d'arxius." >&2
		echo "Creant directori d'arxius a /archives..."
		mkdir $DIRECTORY
		if [ "$?" -eq 0 ]
		then
			echo "Directori d'arxius creat."
		else
			echo "No s'ha pogut crear el directori d'arxius" >&2
			exit 4
		fi
	fi
	
	# Archive the user's home directory and move it into the ARCHIVE_DIR
	ARCHIVE=$USER.tar.gz
	tar -czvf $ARCHIVE /home/$USER 2>&1 > /dev/null
	mv $ARCHIVE $DIRECTORY/$ARCHIVE
}

remove_home() {
	rmdir -r /home/$USER
}


