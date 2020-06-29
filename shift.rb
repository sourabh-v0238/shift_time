def shift(h,m,s,ms,t)  # h= hour, m = minut, s+ seconds , ms = milisec, t = timeshift and t > 0
	ms= ms + t
	puts "#{ms}"
	if ms > 999
		s= s + Integer((ms/1000))
		ms = ms%1000
		if s>59
			s= s-60
			m+=1
			if m>59
				m=m-60
				h+=1
			end
		end
	end
	puts " #{h}:#{m}:#{s},#{ms} " 
end

shift(59,59,59,100,2099)
