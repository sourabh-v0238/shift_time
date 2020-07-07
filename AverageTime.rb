=begin
	this code is to find average time of arrival ( of flight or trian)

	Input: array of strings. Each sting is a arrival time with time format HH:MM (24 hoour format) or hh:mmPM (12 hour format)
	e.g. ["12:01am","23:03","11:30PM","00:23","23:48"]

	Output: Average Time in 24 hour format i.e., HH:MM
	e.g. 23:36

	Note: it is assumed that maximum difference amongst all arrival times is less than 12 hours 


=end

require "time"


class Delay

	attr_accessor  :t_str, :i_int 

	def initialize( argument )
		@t_str = argument
		self.i_int = []

	end

	def difference

		i=1
		net_diff=0

		while i < i_int.size 
			diff = i_int[i]-i_int[0]
			(diff<=>0)*diff>12 ? net_diff += (-1)*(diff<=>0)*(24 - (diff<=>0)*diff) : net_diff += diff
			i+=1
		end

		net_diff
	end


	def average_time_of_day

		time_to_i
		i_int[0] += (difference.to_f/i_int.size)
		show(i_int[0])
	end
	def show(number)
		if number<0
			number+=24
		end
		hour=number.to_i
		minute=((number-hour)*60).round
		minute = minute.to_i 
		if minute >= 60
			hour = hour + minute/60
			minute=minute%60
		end
		if hour>=24
			hour = hour%24
		end
		puts "%02d:%02d" % [ hour, minute ]		# here Time is displayed  in 24 hours format 
	end
		def time_to_i
		t_str.each  do |str| 
			str.upcase!
			if(str["PM"])
				hour,minute = str.gsub("PM","").split(':') 
				hour = hour.to_i + 12
		        minute = minute.to_i
		        i_int.push(hour+minute.to_f/60)
		    else
		    	if(str["AM"])

				 	hour,minute = str.gsub("AM","").split(':') 
					hour = hour.to_i
					if(hour == 12)    #12:02AM is 00:02
						hour = 0
					end
		    	    minute = minute.to_i
		        	i_int.push(hour+minute.to_f/60)
		        else

		        	hour,minute = str.split(':') 
		        	hour = hour.to_i
		        	minute = minute.to_i
		        	i_int.push(hour+minute.to_f/60)
		        end
		    end
		end
	end

end

str = [ "11:00pm","12:00am","11:30pm"] 

# str = argv        #  if arguments are being paased to the program   
 
delay = Delay.new(str)
delay.average_time_of_day





