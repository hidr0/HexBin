startHTML = "<html>
<head>
<style type=\"text\/css\">
td{padding:10px;}
</style>
</head>
<body><table border = \"1\">"
endHTML = "</table></body></html>"
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
	digit = Random.new.rand(4..8).even?
	if(argv[0].to_s.downcase == "easy")
		while digit.odd
			digit = Random.new.rand(4..8).even?	
		end
		return digit
	else
		return 0
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

def newLine
	print("\n")
end

def firstTask operator,tempHex
	return"
	int a = #{tempHex[0]};
	int b = #{tempHex[1]};
	int res = a#{operator}b;"
end

def secondTask operator,tempHex,shifter,digit
	return"
	int a = #{tempHex[0]}; 
	int b = #{tempHex[1]}; 
	int res = a#{operator}b; "
end

def gettingTheTask string
	return firstTask(returnOperator(ARGV),makingEasyOrHardHexs(ARGV))
end

def parsingTheTaskToHtml string
	tempArray = []
	string.each_line do |line|
		tempArray << line.gsub("\n","").gsub("\t","")
	end

	return tempArray.delete_if{ |item| item == ""}
end

def genSomeHTML leftString,rightString,endTheTable,startHTML,endHTML
	if((leftString != "") && (rightString != ""))
		returnHTML = "<td>"
		leftString.each do |string|
			returnHTML << "<p>"
			returnHTML << string
			returnHTML << "</p>"
		end
		returnHTML << "<p>result = ..........</p>"
		
		returnHTML << "<td>"
		rightString.each do |string|
			returnHTML << "<p>"
			returnHTML << string
			returnHTML << "</p>"
		end
		returnHTML << "<p>result = ..........</p>"
		returnHTML << "</td>"
	end
	returnHTML << "</tr>"
	return returnHTML
end

def whitingTheHTMLFile htmlFile,filename
	File.open("#{filename}", "w") do |file|  
		file << htmlFile
	end
end
gettingTheAnswer("test.c",firstTask(returnOperator(ARGV),makingEasyOrHardHexs(ARGV)))
gettingTheTask(firstTask(returnOperator(ARGV),makingEasyOrHardHexs(ARGV))).dump
parsingTheTaskToHtml(gettingTheTask(firstTask(returnOperator(ARGV),makingEasyOrHardHexs(ARGV))))



HTML = startHTML
10.times do
	HTML << genSomeHTML(parsingTheTaskToHtml(gettingTheTask(firstTask(returnOperator(ARGV),makingEasyOrHardHexs(ARGV)))),parsingTheTaskToHtml(gettingTheTask(firstTask(returnOperator(ARGV),makingEasyOrHardHexs(ARGV)))),1,startHTML,endHTML)
end
HTML << endHTML
whitingTheHTMLFile(HTML,"1.html")