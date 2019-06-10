require "bundler/setup"
require "json"
require "white_tail"

class SearchResultPage < WhiteTail::DSL::Nodes::Page
  # text :contents, "//div[@id='toc']"
end

class SearchResultsPage < WhiteTail::DSL::Nodes::Page
  # text :results_count, ".//div[@class='results-info']"
  # within ".//div[@class='searchresults mw-searchresults-has-iw']" do
  #   sections :results, ".//li[@class='mw-search-result']" do
  #     text :num_words, ".//div[@class='mw-search-result-data']"
  #     section :heading, ".//div[@class='mw-search-result-heading']/a" do
  #       text :title, nil
  #       open :result_link, nil, page_class => SearchResultPage
  #     end
  #   end
  #   load_more :results, ".//a[@class='mw-nextlink']"
  # end
end

class SearchPage < WhiteTail::DSL::Nodes::Page
  # section :search_form, ".//form[@id='search']" do
  #   type :query_string, ".//input[@name='search']", "spiders"
  #   click :submit, ".//input[@type='submit']", :page_class => SearchResultsPage
  # end
end

class HomePage < WhiteTail::DSL::Nodes::Page
  # click :search_button, ".//form[@id='searchform']//input[@type='submit']", :page_class => SearchPage
end

WhiteTail.project :spiders_wiki do
  visit :home, "https://en.wikipedia.org/", :page_class => HomePage
end

# start = Time.now
results = WhiteTail.execute(:spiders_wiki)
# finish = Time.now
puts JSON.pretty_generate(results)
# puts finish - start
