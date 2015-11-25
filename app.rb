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

Cuba.define do
  on get, root do
    res.write("<form method=post><textarea name=fasta></textarea><button type=submit>run</button></form>")
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

    api_result[:children] = results.map do |organism, percent_identity,query_len, region| 
      {
        children: [ { children: [ { name: organism, size: percent_identity, desc: percent_identity }] } ]
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

      results << [Bio::UniProtKB.new(str).os.first["os"], hit.hsps.first.score, hit.len, hit.overlap]
    end

    id =  Memo.set(results)
    res.redirect "/treemap/#{id}"
  end

end
