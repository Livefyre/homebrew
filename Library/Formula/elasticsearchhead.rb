require 'formula'

class Elasticsearchhead < Formula
  homepage 'https://github.com/mobz/elasticsearch-head'
  url 'https://gist.github.com/anonymous/8aae24b23ab50d12b67a/raw/73b2d70e4d5187bc184397d20325d4478bac29eb/gistfile1.txt'
  depends_on 'elasticsearch'
  version '0.19.9' # there's no way to make this Elasticsearch.new.version

  def install
    v = Elasticsearch.new.version
    if version != v
      onoe "version=#{version} does not match es version=#{v}"
      exit 1
    end
    system "/usr/local/Cellar/elasticsearch/#{v}/bin/plugin -install mobz/elasticsearch-head"
    (prefix + 'totem').write ""
  end
end
