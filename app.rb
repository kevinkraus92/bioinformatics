require "cuba"
require 'bio'
require "open-uri"
require "json"

require "tilt"
require "cuba/render"
require "erb"

Cuba.plugin Cuba::Render

class Memo
  @@store = []

  def self.set(value)
    @@store << value

    @@store.length - 1;
  end

  def self.get(i)
    @@store[i.to_i]
  end
end

class MainHTML

  def self.getLayout
    return "<html><head><title>Bio-ITBA</title><link href='https://netdna.bootstrapcdn.com/twitter-bootstrap/2.3.2/css/bootstrap-combined.min.css' rel='stylesheet' type='text/css' /></head><body style='margin-left:50px'><div style='width:100%, margin-left:50px'><h1 class='text-info'>Species Blastp By Hanna, Itzcovich, Kraus</h1><br><form method=post><div><textarea rows='20' cols='100' name=fasta style='width:50%'></textarea></div><button type='button submit' class='btn btn-primary'>Run</button></form></html></div></body>"
  end

end

Cuba.define do
  on get, root do
    res.write(MainHTML.getLayout)
  end

  on get, "show/:id" do |id|
    results = Memo.get(id)
    res.write partial("index", results: results)
  end

  on get, "treemap/:id" do |id|
    res.write partial("treemap", url: "/treemap_api/#{id}")
  end

  on get, "treemap_api/:id" do |id|
    results = Memo.get(id)

    api_result = {}

    api_result[:children] = results.map do |organism, percent_identity, identity, query_len, overlap, query_seq, target_seq, accession| 
      {
        children: [ { children: [ { name: organism, size: percent_identity, desc: percent_identity, identity: identity, len:query_len, overlap: overlap, query:query_seq, target: target_seq, accession: accession}] } ]
      }
    end

    res.write api_result.to_json
  end

  on post do

    blast = Bio::Blast.remote('blastp', 'swissprot', '-e 0.0001', 'genomenet')

    fasta = Bio::FastaFormat.new( req.POST["fasta"])

    results = []

    report = blast.query(fasta.entry)
    report.hits.each_with_index do |hit, i|
      break if i >= 10

      accessor = hit.definition.split(" ")[0]
      number_accessor = accessor[1..-2]
      str = open("http://www.uniprot.org/uniprot/#{number_accessor}.txt").read

      results << [Bio::UniProtKB.new(str).os.first["os"], hit.hsps.first.score, hit.identity, hit.len, hit.overlap, hit.query_seq, hit.target_seq, number_accessor]
    end

    id =  Memo.set(results)
    res.redirect "/treemap/#{id}"
  end

end
