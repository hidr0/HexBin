
def makingTheHardHex hex
	Random.new.rand(4..8).times do
		hex << Random.new.rand(1..14).to_s(16)
	end
end

def makingTheEasyHex hex
	ran = [Random.new.rand(0..15),0,0]
	Random.new.rand(4..8).times do
		hex << ran[Random.new.rand(0..2)].to_s(16)
	end

end
def makingEasyOrHardHexs argv
	hex = ["0x","0x"]
	if argv[0].to_s.downcase == "easy"
		2.times do |i|
			makingTheEasyHex hex[i]
		end
	elsif argv[0].to_s.downcase == "hard"
		2.times do |i|
			makingTheHardHex hex[i]
		end
	end
	return hex
end

def returnOperator argv
	if(argv[1].to_s.downcase == "and")
		operator = "&"
	elsif argv[1].to_s.downcase == "or"
		operator = "|"
	elsif argv[1].to_s.downcase == "xor"
		operator = "^"
	end	
	return operator
end

def writingInC filename, operator, tempHex
	File.open(filename, "w") do |file|  
		file <<
		"#include <stdio.h>
		int main(){
			int a = #{tempHex[0]};
			int b = #{tempHex[1]};
			int res = a#{operator}b;
			printf(\"0x\");
			printf(\"%04x\",res);
			return res;
		}
		"
	end
end

def gettinTheResFromTheC filename
	p "Temp",tempResult = system("gcc #{filename} && ./a.out").to_s.gsub("true",)
	system("rm ./#{filename} ./a.out")
	return tempResult
end

def newLine
	print("\n")
end

writingInC("test.c",returnOperator(ARGV),makingEasyOrHardHexs(ARGV))
p "Result = ",gettinTheResFromTheC("test.c")
