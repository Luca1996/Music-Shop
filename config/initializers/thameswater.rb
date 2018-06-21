require 'open-uri'
require 'nokogiri'
require 'net/http'

#Store URL to be scraped

uri = URI.parse('https://secure.thameswater.co.uk/dynamic/cps/rde/xchg/corp/hs.xsl/Thames_Water_Supply.xml')
# other code here