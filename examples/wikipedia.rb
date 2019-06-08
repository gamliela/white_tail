require "bundler/setup"
require "json"
require "white_tail"

WhiteTail.project :wikipedia do
  page :definition, "https://en.wikipedia.org/wiki/White-tailed_spider" do
    validation :logo, ".//div[@id='mw-navigation']//div[@id='p-logo']"

    text :title, ".//h1[@id='firstHeading']", :required => true
    text :description, ".//div[@id='mw-content-text']", :required => true
    section :infobox, ".//div[@id='mw-content-text']//table[@class='infobox biota']" do
      attribute :image_url, ".//img", :src
    end
    sections :references, ".//div[@class='reflist columns references-column-width']/ol/li" do
      text :text, "(.//span[@class='reference-text'])[1]"
      attributes :links, ".//a[@class='external text']", :href
    end
  end
end

# start = Time.now
results = WhiteTail.execute(:wikipedia)
# finish = Time.now
puts JSON.pretty_generate(results)
# puts finish - start
