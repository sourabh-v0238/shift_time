
line = "00:00:01,230 --> 00:00:03,293"
a = line.split(" --> ")
puts a[0]
time1=a[0].split(/[: ,]/)
time2=a[1].split(/[: ,]/)
time1.each do | i |
 	p i.to_i
 	
 end
 end_time = time2.map { |e| e.to_i }
 start_time =time1.map { |e| e.to_i }
 p start_time
puts"time is #{end_time} am "
