starthtml = "<html>
<head>
<style type=\"text\/css\">
td{padding:10px;}
</style>
</head>
<body><table border = \"1\">"

endhtml = "</table></body></html>"
operator = ["^","|","&"]
shifter = ["<<", ">>"]

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
def makingEasyOrHardShiftingDigits argv
	digit = Random.new.rand(1..16)
	if(argv[0].to_s.downcase == "easy")
		while digit.odd?
			digit = Random.new.rand(1..16)
		end
		return digit
	else
		while digit.even?
			digit = Random.new.rand(1..16)
		end
		return digit
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

def makingEasyOrHardDec argv
	if argv[0].to_s.downcase == "easy"
		return (2**Random.new.rand(0..11))
	elsif argv[0].to_s.downcase == "hard"
		return Random.rand(0..1024)
	end
end

def gettingTheAnswer filename, tempTask
	File.open(filename, "w") do |file|  
		file <<
		"#include <stdio.h>
		#include <stdlib.h>
		int main(){
			#{tempTask}
			printf(\"0x\");
			printf(\"%04x\",res);
			return 0;
		}
		"
	end

	tempResult = `gcc #{filename} && ./a.out`
	system("rm ./#{filename} ./a.out")
	return tempResult
end

def firstTask operator,tempHex
	return"
	int a = #{tempHex[0]};
	int b = #{tempHex[1]};
	int res = a#{operator}b;"
end

def secondTask operator,tempDec,shifter,digit
	return"
	int a = #{tempDec}; 
	int b = #{tempDec}; 
	int res = (a#{shifter} #{digit})#{operator}(b #{shifter} #{digit}); "
end

def parsingTheTaskTohtml string
	tempArray = []
	string.each_line do |line|
		tempArray << line.gsub("\n","").gsub("\t","")
	end

	return tempArray.delete_if{ |item| item == ""}
end

def genSomehtml leftString,rightString,starthtml,endhtml,result
	if((leftString != "") && (rightString != ""))
		returnhtml = "<td>"
		leftString.each do |string|
			returnhtml << "<p>"
			returnhtml << string
			returnhtml << "</p>"
		end
		returnhtml << "<p>result = #{result}</p>"
		
		returnhtml << "<td>"
		rightString.each do |string|
			returnhtml << "<p>"
			returnhtml << string
			returnhtml << "</p>"
		end
		returnhtml << "<p>result = #{result}</p>"
		returnhtml << "</td>"
	end
	returnhtml << "</tr>"
	return returnhtml
end

def whitingThehtmlFile htmlFile,filename
	File.open("./Tests/#{filename}", "w") do |file|  
		file << htmlFile
	end
end

html = ""
10.times do |i|	
	html.clear
	html << starthtml
		operatorI = operator[Random.new.rand(0..2)]
		randomHex = makingEasyOrHardHexs(ARGV) 
		leftString = parsingTheTaskTohtml(firstTask(operatorI,randomHex))

		operatorI = operator[Random.new.rand(0..2)]
		randomHex = makingEasyOrHardHexs(ARGV) 
		rightString = parsingTheTaskTohtml(firstTask(operatorI,randomHex))

		html << genSomehtml(leftString,rightString,starthtml,endhtml,"........") 



		operatorI = operator[Random.new.rand(0..2)]
		randomDec = makingEasyOrHardDec(ARGV)
		shifterI = shifter[Random.new.rand(0..1)]
		shiftingIndex = makingEasyOrHardShiftingDigits(ARGV)
		leftString = parsingTheTaskTohtml(secondTask(operatorI,randomDec,shifterI,shiftingIndex))

		operatorI = operator[Random.new.rand(0..2)]
		randomDec = makingEasyOrHardDec(ARGV)
		shifterI = shifter[Random.new.rand(0..1)]
		shiftingIndex = makingEasyOrHardShiftingDigits(ARGV)
		rightString = parsingTheTaskTohtml(secondTask(operatorI,randomDec,shifterI,shiftingIndex))

	html << genSomehtml(leftString,rightString,starthtml,endhtml,"........") 
	html << endhtml
	whitingThehtmlFile(html,"#{i}.html")
end

p makingEasyOrHardDec(ARGV)

