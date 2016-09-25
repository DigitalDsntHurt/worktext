require "worktext/version"
require 'nokogiri'
require 'rest-client'

module Worktext
 	extend self


##
#### get data
##

	def thingtest(thing,w_or_wout)
		if w_or_wout == :w
			p thing 
			puts thing.class
			puts thing.count if thing.class == Array || thing.class == Hash
		elsif w_or_wout == :wout
			puts thing.class
			puts thing.count if thing.class == Array || thing.class == Hash
		else
			puts "^!^!~*~*~*~you didn't enter your w / print preference "
		end
	end

	def get_stuff_from_page(page,xpath)
		Nokogiri::HTML(RestClient::Resource.new(page, :verify_ssl => false).get).xpath(xpath).map{|item|
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

# Get headlines, pub times & article text from NBCNews.com
	# Available Sections = '/','/pop-culture','/business','/tech','/health',
	
	def scrape_nbc(sections, limit) # , hl_or_arti, limit
		base = 'http://www.nbcnews.com'
		links = []
		if sections == "/"
			Worktext::get_stuff_from_page("#{base+sections}","//*[@id='top-stories-section']//div[@class='col-sm-6 col-md-8 col-lg-9'][1]//a/@href").to_a.map!{|link| 
				link.to_s.strip #prep_strings_for_anal()
			}.uniq!.each{|item| 
				next if item.start_with?('http') || item.include?('/video/') || item.start_with?('/storyline') || item.start_with?('/slideshow') || item.length < 30
			#create list of article links
			links << base + item }

			# get & store headlines, pub times and first 6 paragraphs
			data = []
			links[0..limit].each{|l|
				# define xpaths upfront
			    xpaths = {:headlines => "//h1[@itemprop='headline']", :times => "//time", :bodies => "//div[@class='article-body']//p"}
			    
			    @arti_data = {}

			    # add url to hash @arti_data
			    @arti_data[:url] = l

			    # get headline & add it to hash @arti_data 
			    @arti_data[:headline] = Worktext::get_stuff_from_page(l,xpaths[:headlines]).join()
			    
			    # get first 6 paragraphs
			    @paras = []
			    Worktext::get_stuff_from_page(l,xpaths[:bodies]).each_with_index{|para,i| 
			   		break if i > 5
			       	@paras << para
			    }
			    # add paragraphs single string to hash @arti_data
			    @arti_data[:body] = @paras.join(" ")

			    #get a single pubtime (in this case, it's publish date, not most recent update)
			    @pubtime = []
			    Worktext::get_stuff_from_page(l,xpaths[:times]).each{|timestamp| 
			    	@pubtime << timestamp
			    }
			    # add a single pubtime to hash @arti_data
			    @arti_data[:time] = @pubtime.pop
			    data << @arti_data
			}
			return data[0]
		
		elsif sections.class == String
			# generate nbc section urls
			Worktext::get_stuff_from_page("#{base+"/"+sections}","//*[@id='top-stories-section']//div[@class='col-sm-6 col-md-8 col-lg-9'][1]//a/@href").to_a.map!{|link| 
				link.to_s.strip #prep_strings_for_anal()
			}.uniq!.each{|item| 
				next if item.start_with?('http') || item.include?('/video/') || item.start_with?('/storyline') || item.start_with?('/slideshow') || item.length < 30
			#create list of article links
			links << base + item }

			# get & store headlines, pub times and first 6 paragraphs
			data = []
			links[0..limit].each{|l|
				# define xpaths upfront
			    xpaths = {:headlines => "//h1[@itemprop='headline']", :times => "//time", :bodies => "//div[@class='article-body']//p"}
			    
			    @arti_data = {}

			    # add url to hash @arti_data
			    @arti_data[:url] = l

			    # get headline & add it to hash @arti_data 
			    @arti_data[:headline] = Worktext::get_stuff_from_page(l,xpaths[:headlines]).join()
			    
			    # get first 6 paragraphs
			    @paras = []
			    Worktext::get_stuff_from_page(l,xpaths[:bodies]).each_with_index{|para,i| 
			   		break if i > 5
			       	@paras << para
			    }
			    # add paragraphs single string to hash @arti_data
			    @arti_data[:body] = @paras.join(" ")

			    #get a single pubtime (in this case, it's publish date, not most recent update)
			    @pubtime = []
			    Worktext::get_stuff_from_page(l,xpaths[:times]).each{|timestamp| 
			    	@pubtime << timestamp
			    }
			    # add a single pubtime to hash @arti_data
			    @arti_data[:time] = @pubtime.pop
			    data << @arti_data
			}
			return data[0]

		elsif sections.class == Array
			hsh = Hash.new(0)

			sections.each{|section|
				links = []
				# generate nbc section urls
				if sections == "/"
					@links = Worktext::get_stuff_from_page("#{base+section}","//*[@id='top-stories-section']//div[@class='col-sm-6 col-md-8 col-lg-9'][1]//a/@href")
				else
					@links = Worktext::get_stuff_from_page("#{base+"/"+section}","//*[@id='top-stories-section']//div[@class='col-sm-6 col-md-8 col-lg-9'][1]//a/@href")
				end
				@links.to_a.map!{|link| 
					link.to_s.strip #prep_strings_for_anal()
				}.uniq!.each{|item| 
					next if item.start_with?('http') || item.include?('/video/') || item.start_with?('/storyline') || item.start_with?('/slideshow') || item.length < 30
				#create list of article links
				links << base + item }

				# get & store headlines, pub times and first 6 paragraphs
				data = []
				links[0..limit].each{|l|
					# define xpaths upfront
				    xpaths = {:headlines => "//h1[@itemprop='headline']", :times => "//time", :bodies => "//div[@class='article-body']//p"}
				    
				    @arti_data = {}

				    # add url to hash @arti_data
				    @arti_data[:url] = l

				    # get headline & add it to hash @arti_data 
				    @arti_data[:headline] = Worktext::get_stuff_from_page(l,xpaths[:headlines]).join()
				    
				    # get first 6 paragraphs
				    @paras = []
				    Worktext::get_stuff_from_page(l,xpaths[:bodies]).each_with_index{|para,i| 
				   		break if i > 5
				       	@paras << para
				    }
				    # add paragraphs single string to hash @arti_data
				    @arti_data[:body] = @paras.join(" ")

				    #get a single pubtime (in this case, it's publish date, not most recent update)
				    @pubtime = []
				    Worktext::get_stuff_from_page(l,xpaths[:times]).each{|timestamp| 
				    	@pubtime << timestamp
				    }
				    # add a single pubtime to hash @arti_data
				    @arti_data[:time] = @pubtime.pop
					
					data << @arti_data
				}	
			#puts data
			#puts "*~*~*~"				
			hsh[section] = data
			}

			return hsh
		else
			puts "You entered something wrong"
		end

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
	
## get ngrams
	def engrams(n, string)
		hsh = {} 
		@hsh = {}
		grams = []

		#for single ngram
		if n.class == Fixnum
			#split the string into words, then group words by n provided
			string.split(' ').each_cons(n).to_a.map!{|arr|
				# if dealing with 1grams
				if arr.length < 2
					# make each gram a string and add to grams arr
					grams << arr[0]
				# if dealing with 2grams or higher
				else
					# make each gram a string and add to grams arr
					grams << arr.join(" ")
				end
			}
			# store grams as value of hash, set key = #gram
			@hsh[n.to_s+"grams"] = grams			
			return @hsh

		#for multiple ngrams
		elsif n.class == Array
			# for each desired gram
			n.each{|nn|
				grams = []
				# split string into words, group words by n provided
				# for each word group
				string.split(' ').each_cons(nn).to_a.map!{|arr|
					# if dealing with 1grams
					if arr.length < 2
						# make each gram a string and add to grams arr
						grams << arr[0]
					# if dealing with 2grams or higher
					else
						# make each gram a string and add to grams arr
						grams << arr.join(" ")
					end
				}
				## store grams as value of hash, set key = #gram
				@hsh[nn.to_s+"grams"] = grams			
			}
			return @hsh
		else
			puts fuckedup
		end
	end #engrams method


## get ngram frequencies

	# n = gram# you want - can be a single digit or array of digits
	# string = the text you want ngrams for
	# min = the minimum number of ngram ocurrences you want to see. 0 shows all ngrams, 2 shows 2grams & above
	def Worktext.engram_fs(n, string, min)
		hsh = Hash.new(0)
		@hsh = Hash.new(0)

		#for single ngram
		if n.class == Fixnum
			#split the string into words, then group words by n provided
			string.split(' ').each_cons(n).to_a.map!{|arr|
				# if dealing with 1grams
				if arr.length < 2
					# make each gram a string and add to grams arr
					@hsh[arr[0]] += 1
				# if dealing with 2grams or higher
				else
					# make each gram a string and add to grams arr
					@hsh[arr.join(" ")] += 1
				end
			}
			# store grams as value of hash, set key = #gram
			hsh[n.to_s+"grams"] = Worktext::sort_and_filter_hash_values(@hsh,min)
			return hsh

		#for multiple ngrams
		elsif n.class == Array
			# for each desired gram
			n.each{|nn|
				@hsh = Hash.new(0)
				# split string into words, group words by n provided
				# for each word group
				string.split(' ').each_cons(nn).to_a.each{|arr|
					# if dealing with 1grams
					if arr.length < 2
						# make each gram a string and make key of hash pair whose value iterates +1
						@hsh[arr[0]] += 1
					# if dealing with 2grams or higher
					else
						# make each gram a string and make key of hash pair whose value iterates +1
						@hsh[arr.join(" ")] += 1
					end
					## store grams as value of hash, set key = #gram
					hsh[nn.to_s+"grams"] = Worktext::sort_and_filter_hash_values(@hsh,min)
				}
			}
			return hsh
		else
			puts "fuckedup"
		end
	end #ngram frequiencies



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




