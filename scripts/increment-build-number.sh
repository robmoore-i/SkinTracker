if [[ $# != "0" ]]; then
  echo "$0 : Wrong number of arguments"
  echo "$0 : Usage -- $0"
  exit 1
fi

echo "$0 : Incrementing build version"
current_build_number=$(agvtool what-version | tail -2 | head -1 | xargs)
echo "$0 : Current build number is $current_build_number"
xcrun agvtool next-version -all
echo "$0 : Success"
exit 0
