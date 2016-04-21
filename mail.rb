require 'json'
id = 1
hash = { warning: {}, error: {}, fatal: {}, panic: {} }

File.open('mail.log').each_line do |line|
	arr = []
	arr << line.strip.split(' ')
	arr.each do |x|
		if x[5].match(/warning|error|fatal|panic/)
			error_name = x[5].delete(':').to_sym
			hash[error_name]["#{error_name}_#{id}"] = {}
			hash[error_name]["#{error_name}_#{id}"][:date] = x[2]
			hash[error_name]["#{error_name}_#{id}"][:time] = "#{x[0]} #{x[1]}"
			hash[error_name]["#{error_name}_#{id}"][:server] = x[3]
			hash[error_name]["#{error_name}_#{id}"][:PID] = x[4].match(/\d+/).to_s
			hash[error_name]["#{error_name}_#{id}"][:service_process] = x[4].delete(':')
			hash[error_name]["#{error_name}_#{id}"][:description] = ''
			6.upto(x.size-1) { |y| hash[error_name]["#{error_name}_#{id}"][:description] << "#{x[y]} " }
			hash[error_name]["#{error_name}_#{id}"][:description].strip!
			id += 1
		end
	end
end

puts hash.to_json