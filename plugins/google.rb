require 'ruby-web-search'

class Google
  include Cinch::Plugin
  include Cinch::Formatting

  match /google (.+)/
  match /g (.+)/

  def search(query)
    response = RubyWebSearch::Google.search(:query => query) rescue []
    begin
      return Format(:bold, "[google]") + " #{response.results.first[:title]} - #{response.results.first[:url]}"
    rescue
      return Format(:bold, "[google]") + " No results found."
    end
  end

  def execute(m, query)
    m.reply(search(query))
  end
end
