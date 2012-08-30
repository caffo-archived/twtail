$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require 'simple-rss'
require 'open-uri'
require 'time'
require 'cgi'
require 'htmlentities'

module Twtail
  
  class << self
    attr_writer :channel
    attr_writer :error_channel
  end
  
  def self.channel
    @channel ||= STDOUT
  end

  def self.error_channel
    @error_channel ||= STDERR
  end
  
  def self.execute(params=nil)
    trap("INT") { exit }
    if params
      search(params)
    else
      error_channel.puts help
    end
  end

  def self.help
    "Usage: twtail [xbox+live | from:caffo | '#barcamp']"
  end

  def self.search(params)
    begin
      pointer   = Time.now-86400
      parameter = CGI::escape(params)
      url       = "http://search.twitter.com/search.atom?q=#{parameter}"
      feed      = SimpleRSS.parse open(url)
      coder     = HTMLEntities.new

      channel.puts "\033[37m==\033[0m \033[1;32m#{feed.channel.title}\033[0m \033[37m==\033[0m\n\n"
      
      if feed.items[0].published < pointer
        channel.puts "No items found since yesterday"
        exit
      end

      while 1==1 do
        new_items = false
        begin
          feed  = SimpleRSS.parse open(url) rescue nil
          feed.items.each do |item|
            next if item.published < pointer
            msg = colorize(37, coder.decode(item.title))
            msg = colorize(31, msg, /(#[[\d]]?(\S+))/i)
            msg = colorize(33, msg, /(@[[\d]]?(\S+))/i)
            msg = colorize(34, msg, /(https?:\/\/[\S]+)/i)
            channel.puts "#{coder.decode(from_parser(item.author))} #{msg}"
            new_items = true
          end
        rescue
        end
        channel.puts "\n\n" if new_items == true
        pointer = feed.items[0].published + 1
        break if $testing
        sleep(60)
      end
    rescue
      "No data was found for this criteria. please try with other keywords."
    end
  end

  def self.from_parser(from)
    from.sub!(/(\w+).+\n.+/,'\1')
    from.gsub!(/.*(\(.*)/, "\\1")
    from.gsub!(/\)http/, ") - http")
    from = colorize(32, "#{from}: ")
    colorize(4, from, /(https?:\/\/[\S]+)/i)
  end

  def self.colorize(color, text, regex = nil)
    if regex.nil?
      "\033[#{color}m#{text}\033[0m"
    else
      text.gsub(regex, "\033[#{color}m\\1\033[0m")
    end
  end
  
end
