#!bin/bash

$date = `date +"%Y-%m-%d"`
cvs -d `pwd`/cvsroot checkout revo
cvs log revo > ${date}-revocvs.log
#ln -s ${date}-revocvs.log cvs.log
statcvs -xml ${date}-revocvs.log revo/

#xmllint --format repo-statistics.xml > repo-stats-indent.xml