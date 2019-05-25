require "bundler/setup"
require "white_tail"

WhiteTail.project :wikipedia do
  page :definition, "https://en.wikipedia.org/wiki/White-tailed_spider" do
    text :title, ".//h1[@id='firstHeading']", :required => true
    text :description, ".//div[@id='mw-content-text']", :required => true
    attribute :image_url, ".//div[@id='mw-content-text']//table[@class='infobox biota']//img", :src
  end
end

results = WhiteTail.execute(:wikipedia)
# puts WhiteTail.format_results(results, :json)
puts results
