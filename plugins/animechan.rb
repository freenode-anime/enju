class AnimeChan
  include Cinch::Plugin

  set :prefix, /^(!|\.)/
  match /rules/, method: :rules
  match /stats/, method: :stats

  def rules(m)
    m.reply "Rules are available at http://freenodeanime.wikia.com/wiki/Rules - If you want something added or clarified just ask us in ##anime-jail."
  end

  def stats(m)
    m.reply "Stats are generated on a 10 min interval and is available at http://flux.theforgotten.com/anime.html or https://we.destroy.tokyo/anime"
  end
end
