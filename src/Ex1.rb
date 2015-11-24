#!/usr/bin/env ruby

require 'bio'

if ARGV.length != 2
  puts 'Invalid params: 1) In file path - 2) Out file path'
  exit
end

#Parses the GenBank input file
entries = Bio::GenBank.open(ARGV[0])

#Creates the new file and writes the fasta output
File.open(ARGV[1], 'w') do |f|
  entries.each_entry do |entry|
    f.write(entry.to_biosequence.output_fasta)
  	puts entry.to_biosequence
  end
end