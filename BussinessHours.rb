require "time"
require "date"

class BusinessHours
	def initialize(open,close)
		open,close=parse(open,close)
		 @open =  open
		 @close = close 		 
		 @specific_date = {}
		 @week = {}
		 @week_days = Time::RFC2822_DAY_NAME.map { |e| e.downcase.to_sym  }
		 @week_days.each  do |day| 
		 	@week[day] = [ open, close]
		 end	
	end	
	def parse(open, close)
	 	open = Time.parse(open)
	 	close = Time.parse(close)
	 	open = seconds(open)
	 	close = seconds(close)
	 	return open,close
	end
	def seconds(time)
	 	return( time.hour*60*60 + time.min*60 + time.sec )
	end
	def update(day, initial, final)
		initial,final= parse(initial,final)
		change_hours(day, initial, final)
	end
	def closed(*days)
		days.each do |day|
			change_hours(day, 0,0)
		end
	end
	def change_hours(day, starting_time, ending_time)
		case day
		when Symbol
			@week[day] = [ starting_time, ending_time ]
		when String 
			@specific_date[Date.parse(day)] = [ starting_time , ending_time]
		end
	end	
	def calculate_deadline(time_interval, starting_datetime)
		start_day = Time.parse(starting_datetime)
		today = Date.civil(start_day.year, start_day.month, start_day.day)
		time=seconds(start_day)
		if time_interval<0
			puts "please provide positive time interval"
		else 
			bussiness_time = deadline(today, time_interval,start_day)
			puts bussiness_time
		end		
	end
	def deadline(date, job_duration,start_day)
		open,close = @specific_date[date] == nil ? @week[@week_days[date.wday]] : @specific_date[date]
		start=seconds(start_day)
		open = [ open, start].max
		work_duration=close-open
		while work_duration <= job_duration
			date = date.next
			job_duration-=work_duration
			open,close = @specific_date[date] == nil ? @week[@week_days[date.wday]] : @specific_date[date]
			work_duration= close-open
		end
		open+=job_duration
		hour,minute,second=time_from_seconds(open)
		return Time.local(date.year, date.month,date.day, hour,minute,second)	
	end	
	def time_from_seconds(sec)
		hour = sec/3600 
		minute = (sec%3600)/60
		sec = sec%60
		[hour,minute,sec]
	end
end

hours = BusinessHours.new("9:00 AM", "3:00 PM")
hours.update :fri, "10:00 AM", "5:00 PM"
hours.update "Dec 24, 2010", "8:00 AM", "1:00 PM"
hours.closed :sun, :wed, "Dec 25, 2010"
hours.calculate_deadline(2*60*60, "Jun 7, 2010 9:10 AM")
hours.calculate_deadline(15*60, "Jun 8, 2010 2:48 PM")
hours.calculate_deadline(7*60*60, "Dec 24, 2010 6:45 AM") 
