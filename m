#!/bin/bash
# alias mem='history | ./m #'
cmd="$(cat /dev/stdin | tail -1 | sed -r 's/[ 0-9]+mem //')"
files=$(ls | grep -E 'memorize-shll-gei-.{15}$')

tmpfile=$(mktemp memorize-shll-gei-XXXXXXXXXXXXXXX)
echo "$cmd" > "$tmpfile"

if [ "$files" != "" ]; then
  matchf=$(echo $files | xargs -n1 wc -c | sort -k1nr | awk '$1!=0{print $2}' | xargs -L1 -i bash -c '[ "$(cat {} | head -1)" = "$(cat '$tmpfile' | head -1 | cut -c -$(cat {} | wc -c))" ] && echo {}' | head -1)
fi;

if [ "$matchf" != "" ]; then
  matchc="$(cat "$matchf" | head -1 | wc -c)"
  restc="$(echo "$cmd" | cut -c $(($matchc + 1))-)"

  [[ " *" =~ "$restc" ]] && rm "$tmpfile"

  echo "commnd result herf was cached!"
  cat $matchf | tail +2 | "${restc:-cat}" | tee -a "$tmpfile"
  exit 0;
else
  echo "$cmd" > $tmpfile
  eval "$cmd" | tee -a "$tmpfile"
fi;
