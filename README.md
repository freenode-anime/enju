Enju
==============

Here is how a "enju.rb" file looks like:

```ruby
require 'cinch'
require 'require_all'
require_all 'plugins'

bot = Cinch::Bot.new do
  configure do |c|
    c.server   = "chat.freenode.net"
    c.port     = "6667"
    c.nick     = "Enju"
    c.channels = ["#anime"]
    c.shared[:cooldown] = { :config => { '#anime' => { :global => 10, :user => 20 } } }
    c.plugins.plugins = [Seen, Google, AnimeChan, URLTitle, Cinch::ChannelRecord, Cinch::Plugins::Calculate, Currency, IMDB]
    c.plugins.prefix = /^\./
    c.plugins.options[Cinch::ChannelRecord] = {
     :file => "/var/cache/cinch/record.dat"
    }
  end
end

bot.start
```
