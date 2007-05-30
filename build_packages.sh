#!/bin/sh

if [ "$1" = "rebuild" ]; then
	FAILED_ONLY=yes
	shift
fi

do_build() {
	LOG_FILE=$1\($2\).log
	if [ "$FAILED_ONLY" = "yes" -a ! -f $LOG_FILE ]; then
		echo "Skipping $1 ($2)"
		return;
	fi
	echo -n "Building $1 ($2) ...";
	if [ "$1" = "maemo" ]; then
		build_maemo $2;
	else
		make TARGET_ARCH=$1 UI_TYPE=$2 TARGET_STATUS=release clean 1> /dev/null 2>&1;
		if ! make TARGET_ARCH=$1 UI_TYPE=$2 TARGET_STATUS=release packages 1> $1\($2\).log 2>&1; then
			echo " failure";
		else
			echo " OK"
			rm $1\($2\).log;
		fi
		make TARGET_ARCH=$1 UI_TYPE=$2 TARGET_STATUS=release clean 1> /dev/null 2>&1;
	fi
}

build_maemo() {
	if [ $1 = "maemo" ]; then
  	SDK=SDK_ARM
	else
  	SDK=SDK_ARMEL
	fi
	/scratchbox/login sbox-config -st $SDK
	/scratchbox/login -d src/zaurus make TARGET_ARCH=maemo UI_TYPE=$1 TARGET_STATUS=release clean 1> /dev/null 2>&1;
	if ! /scratchbox/login -d src/zaurus make TARGET_ARCH=maemo UI_TYPE=$1 TARGET_STATUS=release packages 1> maemo\($1\).log 2>&1; then
		echo " failure";
	else
		echo " OK"
		rm maemo\($1\).log;
	fi
	/scratchbox/login -d src/zaurus make TARGET_ARCH=maemo UI_TYPE=$1 TARGET_STATUS=release clean 1> /dev/null 2>&1;
}

if [ "$1" = "all" ]; then
	do_build win32 win32
	do_build openzaurus opie
	do_build openzaurus gpe
	do_build opensimpad-0.9.0 opie
	do_build qvfb opie
	do_build desktop gtk
	do_build desktop qt
	do_build desktop qt4
	do_build zaurus qtopia-240x320
	do_build zaurus qtopia-640x480
	do_build pdaxrom gtk
	do_build pdaxrom qt
	do_build pma400 qtopia
	do_build maemo maemo
	do_build maemo maemo2
elif [ "$#" == "2" ]; then 
	do_build $@
else
	echo "usage:";
	echo "  $0 [rebuild] all";
	echo "or";
	echo "  $0 [rebuild] <TARGET_ARCH> <UI_TYPE>";
fi
