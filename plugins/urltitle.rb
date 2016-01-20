require 'nokogiri'
require 'curb'
require 'uri'
require 'cgi'
require 'filesize'

class URLTitle
  include Cinch::Plugin
  include Cinch::Formatting

  match /(.*http.*)/, method: :find_all_titles, :use_prefix => false

  def find_title (url)
    url.gsub! "#!", "?_escaped_fragment_=" if url.include? "#!"
    url.gsub! /#.+$/, "" if url.include? "#"
    url.gsub! /\.gifv$/, ".gif" if url.include? ".gifv"

    call = Curl::Easy.perform(url) do |easy|
      easy.follow_location = true
      easy.max_redirects = config["max_redirects"]
      easy.headers["User-Agent"] = config["user_agent"] || 'Enju'
    end

    http_response, *http_headers = call.header_str.split(/[\r\n]+/).map(&:strip)
    http_headers = Hash[http_headers.flat_map{ |s| s.scan(/^(\S+): (.+)/) }]
    if http_headers["Content-Type"] =~ /^image\//
      hua = Filesize.from(http_headers["Content-Length"] + " B").pretty rescue nil
      return Format(:bold, "[#{http_headers["Content-Type"]}]") + " #{hua}"
    else
      html = Nokogiri::HTML(call.body_str)
      title = html.at_xpath('//title').text.gsub(/\r/," ").gsub(/\n/," ").strip rescue nil

      # Title is blank
      if title.nil?
        hua = Filesize.from(http_headers["Content-Length"] + " B").pretty rescue nil
        return "[#{http_headers["Content-Type"]}] #{hua}"
      else
        return Format(:bold, "[title]") + " #{title}"
      end

      CGI.unescape_html title.text.gsub(/\s+/, ' ')
    end
  end

  def find_all_titles(m)
    urls = URI.extract(m.message, ['http', 'https'])

    unless m.user.nick =~ /^ImoutoBot/i or m.user.nick =~ /^kotorin/i or m.user.nick =~ /^ljrbot/i
      returned_titles = urls.take(3).map { |url| find_title(url) }.compact rescue []
    else
      returned_titles = []
    end

    if !returned_titles.empty? and m.message.match(/NSFW/i)
      m.reply Format(:red, "^ NSFW") + " " + returned_titles.join(" || ")
    elsif !returned_titles.empty?
      m.reply returned_titles.join(" || ")
    end
  end
end
