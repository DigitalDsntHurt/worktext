require "worktext/version"
require 'nokogiri'
require 'rest-client'

module Worktext
 	extend self


##
#### get data
##

	def get_stuff_from_page(page,xpath)
		Nokogiri::HTML(RestClient::Resource.new(url, :verify_ssl => false).get).xpath(xpath).map{|item|
		item.text.strip if item != nil
	}
	end

	def get_lines_from_file(path)
		lines = [] 
		File.open(path).each_line{|line| 
			lines << line.gsub("\n","") if line.length > 1
		}
	return lines
	end


##
#### clean data
##

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


##
#### nlp
##
	

	def ngrams(n, string)
		if n.class == Fixnum
			return string.split(' ').each_cons(n).to_a
		elsif n.class == Array
			@hsh = {}
			n.each{|nn|
				@hsh[nn.to_sym] = string.split(' ').each_cons(n).to_a
			}
			
			return @hsh
		else
			#puts fuckedup
		end
	end



##
#### math
##

	def mean(arr)
		#arr.each_with_index{|item,i| puts item.class }
		sum = arr.inject{|item,i| item + i}
		mean = sum.to_f / arr.length.to_f
		return mean
	end




end #module Worktext




