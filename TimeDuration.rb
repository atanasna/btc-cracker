class TimeDuration
	def initialize(time)
		@time = time
		@sec = 1000
		@min = 60*@sec
		@hour = 60*@min 
		@day = 24*@hour
		@week = 7*@day
		@year = 52*@week
	end

	def settime (time)
		@time = time
	end

	def raw
		return @time/1000
	end

	def format (args) #"y:w:d:h:m:s:ms"
		time = @time
		args = args.split(":")

		result = Array.new
		if args.include? "y"
			y = (time/(@year)).to_i
			time = time - @year*y
			result.push y
		end
		
		if args.include? "w"
			w = (time/(@week)).to_i
			time = time - @week*w
			result.push w
		end

		if args.include? "d"
			d = (time/(@day)).to_i
			time = time - @day*d
			result.push d
		end

		if args.include? "h"
			h = (time/(@hour)).to_i
			time = time - @hour*h
			result.push h
		end

		if args.include? "m"
			m = (time/(@min)).to_i
			time = time - @min*m
			result.push m
		end

		if args.include? "s"
			s = (time/(@sec)).to_i
			time = time - @sec*s
			result.push s
		end

		if args.include? "ms"
			ms = time
			result.push ms
		end
		
		return result
	end
end