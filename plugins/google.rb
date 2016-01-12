require 'ruby-web-search'

class Google
  include Cinch::Plugin

  match /google (.+)/
  match /g (.+)/

  def search(query)
    response = RubyWebSearch::Google.search(:query => query) rescue []
    begin
      return "Google: #{response.results.first[:title]} - #{response.results.first[:url]}"
    rescue
      return "No results found."
    end
  end

  def execute(m, query)
    m.reply(search(query))
  end
end
