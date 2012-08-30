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

    def execute(params=nil)
      trap("INT") { exit }
      params ? self.search(params) : self.help
    end

    def help
      return("Usage: twtail [xbox+live | from:caffo | '#barcamp']")
    end

    def search(params)
       begin
        pointer   = Time.now-86400
        parameter = CGI::escape(params)
        url       = "http://search.twitter.com/search.atom?q=#{parameter}"
        feed      = SimpleRSS.parse open(url)
        coder     = HTMLEntities.new

        puts "\033[37m==\033[0m \033[1;32m#{feed.channel.title}\033[0m \033[37m==\033[0m\n\n" unless Module.constants.include?("DEBUG")
        if feed.items[0].published < pointer
          puts "No items found since yesterday"
          exit
        end

        while 1==1 do
          new_items = false
          begin
            feed  = SimpleRSS.parse open(url) rescue nil
            feed.items.each do |item|
              next if item.published < pointer
              unless Module.constants.include?("DEBUG")
                msg = colorize(37, coder.decode(item.title))
                msg = colorize(31, msg, /(#[[\d]]?(\S+))/i)
                msg = colorize(33, msg, /(@[[\d]]?(\S+))/i)
                msg = colorize(34, msg, /(https?:\/\/[\S]+)/i)
                puts "#{coder.decode(from_parser(item.author))} #{msg}"
                new_items = true
              end
            end
          rescue
          end
          puts "\n\n" if new_items == true
          pointer = feed.items[0].published + 1
          break if Module.constants.include?("DEBUG")
          sleep(60)
        end
      rescue
         "No data was found for this criteria. please try with other keywords."
      end
    end

    def from_parser(from)
      from.sub!(/(\w+).+\n.+/,'\1')
      colorize(32, "#{from}: ")
    end

    def colorize(color, text, regex = nil)
      if regex.nil?
        "\033[#{color}m#{text}\033[0m"
      else
        text.gsub(regex, "\033[#{color}m\\1\033[0m")
      end
    end
  end
end
