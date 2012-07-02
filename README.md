EBS tablesnap
=============

In order to provide a Cassandra backup in AWS that we could actually restore in a feasible time, we created EBS tablesnap. It is inspired by [simplegeo's tablesnap](https://github.com/simplegeo/tablesnap) as it uses inotify for observing changes on sstables but it copies them to EBS instead of S3. Also, it doesn't keep track of changes, it tries to keep the same files in two different directories for our purpose of having a 'backup' of the ephemeral disks on an EBS.

Requirements
------------

* ruby
* rubygems
* [rb-inotify](https://github.com/nex3/rb-inotify)

How to use
----------

For now, you should run it in a 'screen' to avoid killing the process when disconnecting. It is a POC, so nothing is expected to work.
