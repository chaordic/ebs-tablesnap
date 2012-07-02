#!/usr/bin/env ruby

require 'rubygems'
require 'rb-inotify'
require 'logger'
require 'fileutils'

ebs_dir = File.join '/', 'mnt', 'ebs_mount_point'
log_file = File.join ebs_dir, 'log'
data_dir = File.join '/', 'var', 'lib', 'cassandra', 'data', 'keyspace'

notifier = INotify::Notifier.new
log = Logger.new(log_file)

log.datetime_format = "%Y-%m-%d %H:%M:%S"
log.formatter = proc do |severity, datetime, progname, msg|
  "#{severity} [#{datetime}] #{msg}\n"
end

notifier.watch data_dir, :moved_to, :delete do |event|
  next if event.name.include? "-tmp"
  FileUtils.rm((File.join ebs_dir, event.name), :force => true) if event.flags.include? :delete
  FileUtils.cp((File.join data_dir, event.name), (File.join ebs_dir, event.name)) if event.flags.include? :moved_to
  log.info "FILE: #{event.name}, ACTION: #{event.flags}"
end

notifier.run
