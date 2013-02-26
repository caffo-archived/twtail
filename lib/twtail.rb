$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require 'simple-rss'
require 'open-uri'
require 'time'
require 'cgi'
require 'htmlentities'

class Twtail
  
  class << self
    attr_accessor :channel
    attr_accessor :error_channel
  end
  
  def self.channel
    @channel ||= STDOUT
  end

  def self.error_channel
    @error_channel ||= STDERR
  end
  
  def self.execute(term = nil)
    trap("INT") { exit }
    if term && !term.empty?
      new(term).run
    else
      error_channel.puts help
    end
  end

  def self.help
    "Usage: twtail [xbox+live | from:caffo | '#barcamp']"
  end

  def initialize(term)
    @url = "http://search.twitter.com/search.atom?q=#{CGI.escape term}"
  end

  def run
    begin
      pointer   = Time.now - 86400
      feed      = SimpleRSS.parse(read)
      coder     = HTMLEntities.new
      channel.puts "\033[37m==\033[0m \033[1;32m#{feed.channel.title}\033[0m \033[37m==\033[0m\n\n"

      while 1==1 do
        new_items = false
        begin
          feed  = SimpleRSS.parse(read) rescue nil
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

  def read
    open(@url).read
  end

  def from_parser(from)
    from.sub!(/(\w+).+\n.+/,'\1')
    from.gsub!(/.*(\(.*)/, "\\1")
    from.gsub!(/\)http/, ") - http")
    from = colorize(32, "#{from}: ")
    colorize(4, from, /(https?:\/\/[\S]+)/i)
  end

  def colorize(color, text, regex = nil)
    if regex.nil?
      "\033[#{color}m#{text}\033[0m"
    else
      text.gsub(regex, "\033[#{color}m\\1\033[0m")
    end
  end
  
  def channel
    self.class.channel
  end

  def error_channel
    self.class.error_channel
  end
  
end
