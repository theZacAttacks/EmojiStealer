require 'json'
require 'net/http'

EmojiEndpoint = '/api/v1/custom_emojis'


ARGV.each do |instance|
  outfolder = "./#{instance.sub!(/^https?:\/\//, '').gsub('.', '_')}_emoji" 
  
  instance = 'https://' + instance
  
  emojiList = JSON.parse(Net::HTTP.get(URI.parse(instance + EmojiEndpoint)))
  
  Dir.mkdir(outfolder)
  
  Dir.chdir(outfolder) do
    emojiList.each do |e|
      if e['visible_in_picker']
        
        puts "Saving #{e['shortcode']} to #{outfolder}/#{e['shortcode']}.png"
        
        File.write("#{e['shortcode']}.png",
                   Net::HTTP.get(URI.parse(e['static_url'])))
      end
    end
  end
end
