require "worktext/version"
require 'nokogiri'
require 'rest-client'

module Worktext
  
	def get_lines_from_file(path)
		lines = [] 
		File.open(path).each_line{|line| 
			lines << line.gsub("\n","") if line.length > 1
		}
	return lines
	end


	def clean_string(string)
		clean_string = []
		# downcase & remove punctuation
		clean_string << string.split(" ").map!{|w|
			w.to_s.downcase.gsub(/[^a-z0-9\s]/i, '')
		}.join(" ")
		# remove stop words 
		stopwords = get_lines_from_file("/Users/Graphiq-NS/Desktop/stopwords.txt")
		clean_string.map!{|string|
			(string.split(" ") - stopwords).join(" ")
		}
		return clean_string.join()
	end

	def sort_and_filter_hash_values(hsh, value)
		filter = {}
		hsh.sort_by{|k,v| v }.reverse.each{|k,v|
			filter[k] = v unless v.to_i < value.to_i
		}
		return filter
	end
	
	def ngrams(n, string)
	  string.split(' ').each_cons(n).to_a
	end

end
