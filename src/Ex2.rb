#!/usr/bin/env ruby

require 'bio'
require "open-uri"


if ARGV.length != 3
  puts 'Invalid params: 1) In file path - 2) Out file path - 3) Type ( --prot or --nuc )'
  exit
end

type = ARGV[2]

if type.eql?('--prot')
    blast = Bio::Blast.remote('blastp', 'swissprot', '-e 0.0001', 'genomenet')
elsif type.eql?('--nuc')
    blast = Bio::Blast.remote('blastn', 'dbest', '-e 0.0001', 'genomenet')
else
  puts 'Possible types are --prot and --nuc'
  exit
end


entries = Bio::FlatFile.open(Bio::FastaFormat, ARGV[0])


File.open(ARGV[1], 'w') do |f|
  entries.each_entry do |entry|
    report = blast.query(entry.seq)
    report.hits.each_with_index do |hit, hit_index|
      f.puts '------------------------------------------------'
      # f.puts "Hit #{hit_index}"
      # f.puts hit.accession  
      # f.puts hit.definition

      



      accessor = hit.definition.split(" ")[0]
      number_accessor = accessor[1..-2]
      str = open("http://www.uniprot.org/uniprot/#{number_accessor}.txt").read
      f.puts Bio::UniProtKB.new(str).os.first["os"]


      # f.puts " - Agregado target_def: #{hit.target_def}"
      # f.puts " - Agregado tardet_id: #{hit.target_id}"
      # f.puts " - Query length: #{hit.len}"
      # f.puts " - Number of identities: #{hit.identity}"
      # f.puts " - Length of Overlapping region: #{hit.overlap}"
      # f.puts " - % Overlapping: #{hit.percent_identity}"
      # f.puts " - Query sequence: #{hit.query_seq}"
      # f.puts " - Subject sequence: #{hit.target_seq}"
      # hit.hsps.each_with_index do |hsps, hsps_index|
      #   f.puts " - Bit score: #{hsps.bit_score}"
      #   f.puts " - Gaps: #{hsps.gaps}"
      # end
    end
  end
end