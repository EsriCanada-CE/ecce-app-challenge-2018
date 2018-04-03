#!/bin/bash

WORKDIR="$(cd "$(dirname "$0")/../.."; pwd)"
echo $WORKDIR


#----------------------------------------------------------------------

APPSTUDIODIR=

kit=""
case $(uname -s) in
Darwin)
  kit=clang_64
  test_dir=~/Applications/ArcGIS/AppStudio
  if [ -f "$test_dir/tools/lrelease" ]; then
    export APPSTUDIODIR=$test_dir
    export PATH=$APPSTUDIODIR/tools:$PATH
  fi
  ;;
Linux)
  kit=gcc_64
  test_dir=~/Applications/ArcGIS/AppStudio
  if [ -f "$test_dir/bin/lrelease" ]; then
    export APPSTUDIODIR=$testdir
    export PATH=$APPSTUDIODIR/bin:$PATH
  fi
  ;;
*)
  echo "System $(uname -s) not supported"
  for test_dir in ~/Qt*/*/*/; do
    if [ -f "$test_dir/bin/lrelease" ]; then
      echo Possible candidate $test_dir
    fi
  done
  exit 1
  ;;
esac

for test_dir in ~/Qt*/*/$kit/; do
  if [ -f "$test_dir/bin/lrelease" ]; then
    export QTDIR=$test_dir
    export PATH=$QTDIR/bin:$PATH
  fi
done

if [ "$APPSTUDIODIR" == "" ]; then
  if [ "$QTDIR" == "" ]; then
    echo APPSTUDIODIR and QTDIR not detected.
    exit 1
  fi
fi

( set -x; which lrelease )
( set -x; which lupdate )

#----------------------------------------------------------------------

function check_ts {

  case $1 in
  *_en*)
    return
    ;;
  esac

  #------------------------------------------------------------

  awk '
{ patched=0 }
/translation>/ {
  orig=$0
  line=orig
  gsub(/<translation>/, "{translation}", line)
  gsub(/<\/translation>/, "{/translation}", line)
  gsub(/<a>/, "&lt;a href="%1"&gt;", line)
  gsub(/<font>/, "&lt;font color="red"&gt;", line)
  gsub(/</, "\\&lt;", line)
  gsub(/>/, "\\&gt;", line)
  gsub(/&Lt;/, "\\&lt;", line)
  gsub(/{translation}/, "<translation>", line)
  gsub(/{\/translation}/, "</translation>", line)
  if (line != orig) {
    print "\033[0;36m" "'$1':" NR ": Error: Recommending translation fixes" "\033[0m"
    print "\033[0;31m" "- " orig "\033[0m"
    print "\033[0;32m" "+ " line "\033[0m"
  }
}
' $1 > $1.err
  >&2 cat $1.err
  rm $1.err
}

#----------------------------------------------------------------------

( set -x ; lupdate "$WORKDIR/QuickReport" -extensions qml -ts "$WORKDIR/QuickReport/languages/QuickReport_en.ts" )
errors=0
exit_status=0
for f in $WORKDIR/QuickReport/languages/*.ts ; do
  check_ts $f
  lrelease $f
  status=$?
  if [ $status != 0 ]; then
    exit_status=$status
    errors=$((errors+1))
  fi
done

if [ "$exit_status" != "0" ]; then
  >&2 echo "Exiting with "$errors" errors"
  exit $exit_status
fi

