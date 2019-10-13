PASSED=0;
FAILED=0;

for INPUT in $(cat grepTest.txt); do

	PRPL=$(prpl /$INPUT/ dictionary.txt)
	GREP=$(cat dictionary.txt | grep $INPUT)

	if [[ $PRPL != $GREP ]]; then

		echo "Mismatch between prpl & grub for search $INPUT'"

		FAILED=$((FAILED+1))

	else

		PASSED=$((PASSED+1))

	fi;

done;



for REPLACE_INPUT in $(cat sedTest.txt); do

	for SEARCH_INPUT in $(cat grepTest.txt); do

		GREP=$(cat dictionary.txt | grep $SEARCH_INPUT)

		for INPUT in $GREP; do

			PRPL=$(echo $INPUT | prpl $REPLACE_INPUT)
			SED=$(echo $INPUT | sed -e $REPLACE_INPUT)

			if [[ $PRPL != $SED ]]; then

				echo "Mismatch between prpl & sed for $INPUT =~ $REPLACE_INPUT'"

				FAILED=$((FAILED+1))

			else

				PASSED=$((PASSED+1))

			fi;
		done;
	done;
done;

echo "$PASSED test passed. $FAILED tests failed."

if [ $FAILED != 0 ]; then

	exit 1;

fi;

exit 0;
