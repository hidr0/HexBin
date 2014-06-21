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
		hex << Random.new.rand(5..15).to_s(16)
	end
end
def makingTheEasyHex hex
	ran = [Random.new.rand(1..15),0,0]
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

def makingEasyShifting 
	digit = Random.new.rand(1..16)
	while digit.odd?
		digit = Random.new.rand(1..16)
	end
	return digit

end
def makingHardShifting
	digit = Random.new.rand(1..16)
	while digit.even?
		digit = Random.new.rand(1..16)
	end
	return digit
end
def makingEasyOrHardShiftingDigits argv
	digit = [0,0]
	while digit[0] == digit[1]
		if argv[0].to_s.downcase == "easy"
			2.times do |i|
				digit[i] = makingEasyShifting 
			end
		elsif argv[0].to_s.downcase == "hard"
			2.times do |i|
				digit[i] = makingHardShifting
			end
		end
	end
	return digit

end
def makingEasyOrHardDec argv
	digit =[0,0]
	if argv[0].to_s.downcase == "easy"
		while digit[0] == digit[1]
			2.times do |i|
				digit[i] = (2**Random.new.rand(0..11))
			end	
		end
	elsif argv[0].to_s.downcase == "hard"
		while digit[0] == digit[1]
			2.times do |i|
				digit[i] = Random.new.rand(0..1024)
			end
		end
	end
	return digit
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
	int a = #{tempDec[0]}; 
	int b = #{tempDec[1]}; 
	int res = (a#{shifter[Random.new.rand(0..1)]} #{digit[0]})#{operator}(b #{shifter[Random.new.rand(0..1)]} #{digit[1]}); "
end

def parsingTheTaskTohtml string
	tempArray = []
	string.each_line do |line|
		tempArray << line.gsub("\n","").gsub("\t","")
	end

	return tempArray.delete_if{ |item| item == ""}
end

def genSomehtml leftString,rightString,result
	if((leftString != "") && (rightString != ""))
		returnhtml = "<td>"
		leftString.each do |string|
			returnhtml << "<p>"
			returnhtml << string
			returnhtml << "</p>"
		end
		returnhtml << "<p>result = #{result[0]}</p>"
		
		returnhtml << "<td>"
		rightString.each do |string|
			returnhtml << "<p>"
			returnhtml << string
			returnhtml << "</p>"
		end
		returnhtml << "<p>result = #{result[1]}</p>"
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
htmlWithRes = ""
result = [0,0]
dots =["............","............"] 
2.times do |i|	
	html.clear
	htmlWithRes.clear
	html << starthtml
	htmlWithRes << starthtml
	
	operatorI = operator[Random.new.rand(0..2)]
	randomHex = makingEasyOrHardHexs(ARGV) 
	leftString = parsingTheTaskTohtml(firstTask(operatorI,randomHex))
	result[0] = gettingTheAnswer("1.c",firstTask(operatorI,randomHex))
	
	operatorI = operator[Random.new.rand(0..2)]
	randomHex = makingEasyOrHardHexs(ARGV) 
	rightString = parsingTheTaskTohtml(firstTask(operatorI,randomHex))
	result[1] = gettingTheAnswer("1.c",firstTask(operatorI,randomHex))
	
	html << genSomehtml(leftString,rightString,dots)  
	htmlWithRes << genSomehtml(leftString,rightString,result) 

	operatorI = operator[Random.new.rand(0..2)]
	randomDec = makingEasyOrHardDec(ARGV)
	shiftingIndex = makingEasyOrHardShiftingDigits(ARGV)
	leftString = parsingTheTaskTohtml(secondTask(operatorI,randomDec,shifter,shiftingIndex))
	result[0] = gettingTheAnswer("1.c",secondTask(operatorI,randomDec,shifter,shiftingIndex))
	
	result
	operatorI = operator[Random.new.rand(0..2)]
	randomDec = makingEasyOrHardDec(ARGV)
	shiftingIndex = makingEasyOrHardShiftingDigits(ARGV)
	rightString = parsingTheTaskTohtml(secondTask(operatorI,randomDec,shifter,shiftingIndex))
	result[1] = gettingTheAnswer("1.c",secondTask(operatorI,randomDec,shifter,shiftingIndex))
	
	html << genSomehtml(leftString,rightString,dots)
	htmlWithRes << genSomehtml(leftString,rightString,result)


	html << endhtml
	
	htmlWithRes << endhtml
	


	whitingThehtmlFile(html,"Test ##{i}.html")
	whitingThehtmlFile(htmlWithRes,"Test ##{i} with results.html")
end

p makingEasyOrHardShiftingDigits(ARGV)

