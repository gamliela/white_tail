require "bundler/setup"
require "json"
require "white_tail"

class SearchResultPage < WhiteTail::DSL::Nodes::Page
  text :contents, "//div[@id='toc']"
end

class SearchResultsPage < WhiteTail::DSL::Nodes::Page
  text :results_count, ".//div[@class='results-info']"
  pagination :results, ".//div[@class='searchresults mw-searchresults-has-iw']", :max_page => 3 do
    items ".//li[@class='mw-search-result']" do
      text :num_words, ".//div[@class='mw-search-result-data']"
      section :heading, ".//div[@class='mw-search-result-heading']/a" do
        text :title, nil
        link :result_page, nil, page_class => SearchResultPage
      end
    end
    next_link ".//a[@class='mw-nextlink']"
  end
end

class SearchPage < WhiteTail::DSL::Nodes::Page
  form :search, ".//form[@id='search']" do
    input ".//input[@name='search']", "spiders"
    submit ".//input[@type='submit']", :page_class => SearchResultsPage
  end
end

class HomePage < WhiteTail::DSL::Nodes::Page
  click :search_button, ".//form[@id='searchform']//input[@type='submit']", :page_class => SearchPage
end

WhiteTail.project :spiders_wiki do
  page :home, "https://en.wikipedia.org/", :page_class => HomePage
end

# start = Time.now
results = WhiteTail.execute(:spiders_wiki)
# finish = Time.now
puts JSON.pretty_generate(results)
# puts finish - start
