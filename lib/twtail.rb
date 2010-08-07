$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))


require 'rubygems'
require 'simple-rss'
require 'open-uri'
require 'time'
require 'cgi'
require 'htmlentities'
 
module Twtail
  
   def self.execute(params=nil)
     trap("INT") { exit }
     params ? self.search(params) : self.help
   end
   
   def self.help
     return("Usage: twtail [xbox+live | from:caffo | '#barcamp']")
   end

   def self.search(params)
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
               puts "\033[32m#{item.author.sub(/(\w+).+\n.+/,'\1')}: \033[0m\033[37m#{coder.decode(item.title)}\033[0m"
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
end