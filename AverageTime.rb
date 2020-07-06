
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
		hour=number.to_i
		minute=(number-hour)*60
		puts "%02d:%02d" % [ hour, minute ]
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

# str = argv        #  if  
 
delay = Delay.new(str)
delay.average_time_of_day




=begin
	
rescue Exception => e
	


opening_time = Time.new
closing_time = Time.new
opening_time += 60*60*9
closing_time += 60*60*15
p opening_time
p closing_time
p (closing_time - opening_time).to_i/3600

t = Time.parse("9:00 PM")
 p t
 p t.hour
 puts Time.at(t).strftime "%H:%M" 

=end

