#!/bin/bash
JAVA_HOME=/usr/lib/jvm/java-9-openjdk-amd64
date=$(date +"%Y-%m-%d")
cvs -d $(pwd)/cvsroot checkout revo
cvs -d $(pwd)/cvsroot log revo > ${date}-revocvs.log
#ln -s ${date}-revocvs.log cvs.log
statcvs -xml ${date}-revocvs.log revo/

xmllint --format repo-statistics.xml > repo-stats-indent.xml
