def EasyOrHard hex, ARGV

	hex = ["0x","0x"]

	def makingTheHard hex
		Random.new.rand(4..8).times do
			hex << Random.new.rand(1..14).to_s(16)
		end
	end

	def makingTheEasy hex
		ran = [Random.new.rand(0..15),0,0]
		Random.new.rand(4..8).times do
			hex << ran[Random.new.rand(0..2)].to_s(16)
		end

	end

	if ARGV[0].downcase == "easy"
		2.times do |i|
			makingTheEasy hex[i]
		end
	elsif ARGV[0].downcase == "hard"
		2.times do |i|
			makingTheHard hex[i]
		end
	end
	return hex
end