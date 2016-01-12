require 'omdbapi'

class IMDB
  include Cinch::Plugin
  include Cinch::Formatting

  match /imdb (.+)/, method: :search

  def search(m, query)
    results = OMDB.search(query) rescue []

    # Only return if results isn't empty
    if !results.empty? and !results.first.blank? and results.first.title
      data = results.first
      m.reply Format(:bold, "[imdb]") + " #{data.title} (#{data.year}) a #{data.type.downcase}. Read more at http://www.imdb.com/title/#{data.imdb_id}/"
    end
  end
end
