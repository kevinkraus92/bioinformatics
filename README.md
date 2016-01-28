# Bioinformatics Visualization

### Data visualization which shows similar species with a given mRNA  sequence (GenBank format) or protein (fasta format).

### Implemented using BioRuby, Cuba Framework, D3.js and Google Search API.

##### By performing a blastp with the [SwissProt](http://www.uniprot.org/) DB, the algorithm finds the best scoring matches and looks for the corresponding species with the accession number in the [UniProtKB](http://www.uniprot.org/) DB. After that, it displays the image of the best matching species in a TreeMap, where the size is proportional to the matching score.

In order to execute the WebApp, clone or download this repository and change directory (cd) to it. 
You'll need the following gems:

* Cuba
* Tilt
* Bio

To install the gems, execute:

```bash
$ sudo gem install cuba
```

```bash
$ sudo gem install tilt
```
```bash
$ sudo gem install bio
```

After that, execute:

```bash
$ rackup -p 9090
```

Go to http://localhost:9090

As an example, the input could be:

>**>gi|386828|gb|AAA59172.1| insulin [Homo sapiens]
MALWMRLLPLLALLALWGPDPAAAFVNQHLCGSHLVEALYLVCGERGFFYTPKTRREAEDLQVGQVELGG
GPGAGSLQPLALEGSLQKRGIVEQCCTSICSLYQLENYCN**

Which is the fasta protein of the human insulin.

*Note: the **size** input is the quantity of species to be shown in the treemap*



###### This was the final project of Bioinformatics course, at [ITBA](http://itba.edu.ar/).

###### Made By:
* [Ivan Itzcovich](https://github.com/iitzco)
* [Kevin Kraus](https://github.com/kevinkraus92)
* [Kevin Hanna](https://github.com/kevinjhanna)
