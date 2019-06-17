require "bundler/setup"
require "json"
require "white_tail"

WhiteTail.project :white_tail_wiki do
  visit :definition, "https://en.wikipedia.org/wiki/White-tailed_spider" do
    wait_for :logo, ".//div[@id='mw-navigation']//div[@id='p-logo']"

    text :title, ".//h1[@id='firstHeading']", :required => true
    text :description, ".//div[@id='mw-content-text']", :required => true
    section :infobox, ".//div[@id='mw-content-text']//table[@class='infobox biota']" do
      attribute :image_url, ".//img", :src
      texts :classification, ".//tr[td[2]]"
    end
    sections :references, ".//div[@class='reflist columns references-column-width']/ol/li" do
      text :text, "(.//span[@class='reference-text'])[1]"
      attributes :urls, ".//a[@class='external text']", :href
    end
  end
end

# start = Time.now
results = WhiteTail.execute(:white_tail_wiki)
# finish = Time.now
puts JSON.pretty_generate(results)
# puts finish - start
