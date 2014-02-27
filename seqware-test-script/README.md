# README

## About

This is a simple tool that will look at your seqware settings file and check
that the servies you've listed are available.  This includes things like:

* seqware web service
* database
* Hadoop HDFS
* Hadoop MapReduce
* Hadoop Oozie 
* workflow directories
* other various things

## Running

    perl seqware_test.pl

This generates a seqware_test.html file which includes a summary of what passed
and what didn't.  If this command exits with a non-zero error code then a
serious error state was detected.
