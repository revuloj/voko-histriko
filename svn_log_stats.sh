#!bin/bash
#JAVA_HOME=/usr/lib/jvm/java-9-openjdk-amd64
JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
date=`date +"%Y-%m-%d"`
#svn log -v --xml https://svn.code.sf.net/p/retavortaro/code/trunk > ${date}-vokosvn.log
#svn log -v https://svn.code.sf.net/p/retavortaro/code/trunk > ${date}-vokosvn.log
java -jar /usr/share/java/statsvn.jar -verbose -xml ${date}-vokosvn.log revo/

#xmllint --format repo-statistics.xml > repo-stats-indent.xml
