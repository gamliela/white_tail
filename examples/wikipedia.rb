require "bundler/setup"
require "white_tail"

WhiteTail.project :wikipedia do
  page :definition, "https://en.wikipedia.org/wiki/White-tailed_spider" do
    text :title, "#TODO", :required => true
    text :description, "#TODO", :required => true
    text :image_url, "#TODO"
  end
end

results = WhiteTail.execute(:wikipedia)
# puts WhiteTail.format_results(results, :json)
puts results
