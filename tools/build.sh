#!/usr/bin/env bash

if [ -z $1 ]
then
	echo "Use: build.sh -f <Family Name> -d -i -r -t -o -x -z"
	echo "-f   set to Eczar"
	echo "-d   deletes old instances"
	echo "-i   interpolate new instances"
	echo "-r   generate TTF instances from UFO instances"
	echo "-t   build OTF fonts"
	echo "-o   build TTF fonts"
	echo "-x   make TTX files from the OTFs and TTFs"
	echo "-z   create zip for release"
fi

while getopts f:dirtoxz option
do
	case "${option}" in
		f) FAMILY=${OPTARG};;
		d) DELETE="D";;
		i) INTERPOLATE="I";;
		r) ROBO="R";;
		t) TTF="T";;
		o) OTF="O";;
		x) TTX="X";;
		z) ZIP="Z";;
	esac
done

if [ "$FAMILY" == "Eczar" ]
then

	# work from the production folder all the time
	cd ../production

	# delete old UFO instances
	if [ $DELETE ]
	then
		cd "$FAMILY"
		shopt -s nullglob
		for i in */
		do
			oldUFO=$i"font.ufo"
			oldTTF=$i"font.ttf"
			oldOTF=$i"font.otf"
			if [[ -d $oldUFO ]]
			then
				echo "Removing old $oldUFO"
				rm -R $oldUFO
			fi
			if [[ -f $oldTTF ]]
			then
				echo "Removing old $oldTTF"
				rm $oldTTF
			fi
			if [[ -f $oldOTF ]]
			then
				echo "Removing old $oldOTF"
				rm $oldOTF
			fi
		done
		cd ..
	fi

	# generate new UFO instances & feature files
	if [ $INTERPOLATE ]
	then
		for ds in *.designspace
		do
			makeInstancesUFO -d $ds
		done

		cd "$FAMILY"
		for i in */
		do
			cd "$i"
			addGroupsUFO.py -g ../uprights.groups.txt font.ufo
			cd ..
		done
		generateAllKernFiles.py
		generateAllMarkFiles.py
		cd ..
	fi

	# generate TTFs from UFOs (via RoboFont)
	if [ $ROBO ]
	then	
		cd "$FAMILY"
		for i in */
		do
			cd "$i"
			echo "Generating TTF in $FAMILY/$i"
			roboGenerateFont.py font.ufo -r -c -f ttf
			cd ..
		done
		cd ..
	fi

	# build TTF fonts
	if [ $TTF ]
	then
		if ! [[ -d "../fonts/" ]]
		then
			mkdir "../fonts/"
		fi
		if ! [[ -d "../fonts/ttf/" ]]
		then
			mkdir "../fonts/ttf/"
		fi
		cd "$FAMILY"
		for i in */
		do
			cd "$i"
			STYLE=`echo "$i" | sed -e "s/\([^-\.]*\)\//\1/"`
			FONT=../../../fonts/ttf/$FAMILY-$STYLE.ttf
			echo "Building TTF fonts from $FAMILY/$i"
			makeotf -f font.ttf -o $FONT -ff features.fea -gf GlyphOrderAndAliasDB -r
			# autohint
			ttfautohint $FONT $FONT.AH --hinting-range-max=96 --ignore-restrictions --strong-stem-width=G --increase-x-height=14
			rm $FONT
			mv $FONT.AH $FONT
			cd ..
		done
		cd ..
	fi

	# build OTF fonts
	if [ $OTF ]
	then
		if ! [[ -d "../fonts/" ]]
		then
			mkdir "../fonts/"
		fi
		if ! [[ -d "../fonts/otf/" ]]
		then
			mkdir "../fonts/otf/"
		fi
		cd "$FAMILY"
		for i in */
		do
			cd "$i"
			STYLE=`echo "$i" | sed -e "s/\([^-\.]*\)\//\1/"`
			FONT=../../../fonts/otf/$FAMILY-$STYLE.otf
			echo "Building OTF fonts from $FAMILY/$i"
			makeotf -f font.ufo -o $FONT -ff features.fea -gf GlyphOrderAndAliasDB -r
			cd ..
		done
		cd ..
	fi

	cd ../tools

else
	echo "Wrong name of a family. Use Eczar."
fi

cd ..

# make TTX files
if [ $TTX ]
then
	echo "Making TTX files from compiled OTF/TTF fonts."
	rm fonts/otf/*.ttx
	ttx fonts/otf/*.otf
	rm fonts/ttf/*.ttx
	ttx fonts/ttf/*.ttf
fi

# zip for release
if [ $ZIP ]
then
	echo "Creating zip file for release."
	VERSION=`cat production/version.fea`
	foldername=$FAMILY
	zipname="Release_$VERSION"
	mkdir $foldername
	mkdir $foldername/otf
	mkdir $foldername/ttf
	cp fonts/otf/*.otf $foldername/otf/
	cp fonts/ttf/*.ttf $foldername/ttf/
	cp documentation/FONTLOG.md $foldername
	cp README.md $foldername
	cp LICENSE.txt $foldername
	zip $zipname.zip -r $foldername/*
	rm -R $foldername
fi
