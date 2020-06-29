class Shift_time
	
	def initialize( hour, minute , sec, mili_sec, shift_milisec = 0)

		@hour = hour
		@minute = minute
		@sec = sec
		@mili_sec = mili_sec
		@shift_milisec = shift_milisec

	end
	def hour
		@hour
	end
	def minute
		@minute
	end
	def sec
		@sec
	end
	def mili_sec
		@mili_sec
	end
	def shifting 
		if( @shift_milisec >= 0) 
			 right_shift
		else
			 left_shift
		end

	end
	def right_shift
		@mili_sec += @shift_milisec
	
		if @mili_sec > 999
			@sec += Integer((@mili_sec/1000))
			@mili_sec = @mili_sec%1000
			if @sec >59
				@minute = Integer( @sec/60)
				@sec = @sec%60
				
				if @minute>59
					@hour = Integer(@minute/60)
					@minute=@minute%60
					
				end
			end
		end

	end

	def left_shift
		@mili_sec+=@shift_milisec
		if @mili_sec<0
			@sec-=1
			@mili_sec+=1000
			if @sec<0
				@minute-=1
				@sec+=60
				if @minute<0
					@hour-=1
					@minute+=60
					if @hour<0
						@hour=@minute=@sec=@mili_sec=0
					end
				end
			end
		end
	end

end


class Manage_line
	
	
	def initialize( initial_line, shift )
		@initial_line = initial_line
		@shift = shift
	end




	
	def fetch_time
		get_time = @initial_line.split(" --> ")
		
		time1=get_time[0].split(/[: ,]/)		# string of time
		time2=get_time[1].split(/[: ,]/)

		@t1 =time1.map { |e| e.to_i }			# Time in array of integer 
 		@t2 = time2.map { |e| e.to_i }
 	end
 		
 	def edit_time
 		@start_time = Shift_time.new(@t1[0],@t1[1],@t1[2], @t1[3] ,@shift)
 		
 		@start_time.shifting

 		@end_time = Shift_time.new(@t2[0],@t2[1],@t2[2], @t2[3] , @shift)
 		
 		@end_time.shifting
 	end
	
	def create_line
		formating = [0,0,0,0,0,0,0,0,0]					#to create 00:00:00,000 formate to be written in .srt file
		formating1 = [0,0,0,0,0,0,0,0,0]
		
		formating[0]=@end_time.hour/10
		formating[1]=@end_time.hour%10
		formating[2]=@end_time.minute/10
		formating[3]=@end_time.minute%10
		formating[4]=@end_time.sec/10
		formating[5]=@end_time.sec%10

		formating[6]=@end_time.mili_sec/10

		formating[8]=@end_time.mili_sec%10
		formating[7]=formating[6]%10
		formating[6]=formating[6]/10
		
		
		
		formating1[0]=@start_time.hour/10
		formating1[1]=@start_time.hour%10
		formating1[2]=@start_time.minute/10
		formating1[3]=@start_time.minute%10
		formating1[4]=@start_time.sec/10
		formating1[5]=@start_time.sec%10

		formating1[6]=@start_time.mili_sec/100
		formating1[7]=(@start_time.mili_sec/10)%10
		formating1[8]=@start_time.mili_sec%10
		


		@final_line = "#{formating1[0]}#{formating1[1]}:#{formating1[2]}#{formating1[3]}:#{formating1[4]}#{formating1[5]},#{formating1[6]}#{formating1[7]}#{formating1[8]} --> #{formating[0]}#{formating[1]}:#{formating[2]}#{formating[3]}:#{formating[4]}#{formating[5]},#{formating[6]}#{formating[7]}#{formating[8]} "

	end

	def execute
		fetch_time
		edit_time
		create_line
	end
	def final_line
		@final_line
	end


end



look_for = " --> "
time_milisec = -1000
File.open("/Users/sourabhkumar.sahu/Documents/gg.srt", "r+t") do |file|  
	file.each_line do |line|
		if (line[look_for])
			temp_line = Manage_line.new(line,time_milisec)
			temp_line.execute
			#somecode
			file.seek(-(line.length + 1), IO::SEEK_CUR)
			file.write temp_line.final_line
		end
	end
	file.close
end
