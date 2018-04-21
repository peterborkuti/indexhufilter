#!/bin/bash
curl -s "https://index.hu"|hxnormalize -x|hxselect -s "\nNEW_ARTICLE_SEPARATOR\n" "article">tmp/separated_articles.html
cat tmp/separated_articles.html|tr -d '\n\r'|sed -e 's/NEW_ARTICLE_SEPARATOR/\nNEW_ARTICLE_SEPARATOR\n/g'|grep -v "NEW_ARTICLE_SEPARATOR" |tr -s ' '> tmp/one_line.html

old="$IFS"
IFS='
'
i=0
for l in `cat tmp/one_line.html`; do
    a=`echo "$l"|hxnormalize -x|hxselect 'h1 a'|tr -d '\n'|tr -s ' '`;
    url=`echo "$a"|sed -e 's/.*href="//;s/".*$//'`;
    text=`echo "$a"|sed -e 's@</a>@@;s/.*>//'`;
    title=`echo "$url"|sed -e 's/%2F$//;s/.*%2F//'`

    filename=`echo "$title"|tr -cd 'a-zA-Z0-9_-'`
    is=`printf '%05d' "$i"`

    fn="raw/$is-$filename.txt"

    echo "$url" > $fn
    echo "$title" >> $fn
    echo "$text" >> $fn

    let "i=$i+1"
done
