require 'pdfkit'

if(ARGV.length == 3)
	dirName = ARGV[2].to_s
	`rm #{dirName}`
	`mkdir #{dirName}`
	`mkdir #{dirName}/Tests`
	`mkdir #{dirName}/Answers`
	hardness = ARGV[0].to_s.downcase
	p numberOfTests = ARGV[1].to_i
elsif ARGV.length == 2
	o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
	dirName = (0...16).map { o[rand(o.length)] }.join
	`rm #{dirName}`
	`mkdir #{dirName}`
	`mkdir #{dirName}/Tests`
	`mkdir #{dirName}/Answers`
	hardness = ARGV[0].to_s.downcase
	p numberOfTests = ARGV[1].to_i
else
	p "You did not enter the right amount of arguments, please check the Readme file and try again."
end

def thirdTask operator,tempHex,shifter,digit
	return"
	int a = #{tempHex[1]}; 
	int res = 0;
	if (a ^ (1 #{shifter[1]} #{digit[1]})){
		res = 1; 
		}else{
			res = 2;
		}
		"	
	end
	def startingHtml number
		return starthtml = "<html>
		<head>
		<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">
		<style type=\"text\/css\">
		td{padding:10px;}
		</style>
		</head>
		<body>
		<h3 style =\"text-align: center\">Технологично училище Електронни системи</h3>
		<h4 style =\"text-align: center\">Технология на програмирането - Тест побитови операции</h4>
		<h3 style =\"text-align: center\">Вариант #{number}</h3>
		<p>Три имена: </p>
		<p>Клас и номер в клас:</p>
		<center><table border = \"1\">"
	end

	endhtml = "</table></center></body></html>"
	operator = ["^","|","&"]
	shifter = ["<<", ">>"]

	def returnShifter array
		temp = Random.new.rand(0..1)
		tempShifter = []
		tempShifter << array[Random.new.rand(0..1)]
		tempShifter << array[Random.new.rand(0..1)]
		return tempShifter
	end
	def makingTheHardHex hex
		Random.new.rand(4..7).times do
			hex << Random.new.rand(5..15).to_s(16)
		end
	end
	def makingTheEasyHex hex
		ran = [Random.new.rand(1..15),0,0]
		Random.new.rand(4..7).times do
			hex << ran[Random.new.rand(0..2)].to_s(16)
		end
	end

	def makingEasyOrHardHexs argv
		hex = ["0x","0x"]
		if argv.to_s.downcase == "easy"
			2.times do |i|
				makingTheEasyHex hex[i]
			end
		elsif argv.to_s.downcase == "hard"
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
			if argv.to_s.downcase == "easy"
				2.times do |i|
					digit[i] = makingEasyShifting 
				end
			elsif argv.to_s.downcase == "hard"
				2.times do |i|
					digit[i] = makingHardShifting
				end
			end
		end
		return digit

	end
	def makingEasyOrHardDec argv
		digit =[0,0]
		if argv.to_s.downcase == "easy"
			while digit[0] == digit[1]
				2.times do |i|
					digit[i] = (2**Random.new.rand(0..11))
				end	
			end
		elsif argv.to_s.downcase == "hard"
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
				printf(\"%x;\",res);
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
		int res = (a#{shifter[0]} #{digit[0]})#{operator}(b #{shifter[1]} #{digit[1]}); "
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
			returnhtml << "<p>res = #{result[0]}</p>"

			returnhtml << "<td>"
			rightString.each do |string|
				returnhtml << "<p>"
				returnhtml << string
				returnhtml << "</p>"
			end
			returnhtml << "<p>res = #{result[1]}</p>"
			returnhtml << "</td>"
		end
		returnhtml << "</tr>"
		return returnhtml
	end

	def writingHtmlToFile htmlFile,filename,dirName
		File.open("./#{dirName}/#{filename}", "w") do |file|  
			file << htmlFile
		end
	end

	if(ARGV.length > 1 && ARGV.length < 4)
		html = ""
		htmlWithRes = ""
		result = [0,0]
		dots =["............","............"] 
		PDFKit.configure do |config|
			config.wkhtmltopdf = `which wkhtmltopdf`.strip
			config.default_options = {
				:page_width => '120',
				:page_height => '350'
			}
		end
		numberOfTests.times do |i|	

			html.clear
			htmlWithRes.clear
			html << startingHtml(i+1)
			htmlWithRes << startingHtml(i+1)
			3.times do 
				operatorI = operator[Random.new.rand(0..2)]
				randomHex = makingEasyOrHardHexs(hardness) 
				leftString = parsingTheTaskTohtml(firstTask(operatorI,randomHex))
				result[0] = gettingTheAnswer("1.c",firstTask(operatorI,randomHex))

				operatorI = operator[Random.new.rand(0..2)]
				randomHex = makingEasyOrHardHexs(hardness) 
				rightString = parsingTheTaskTohtml(firstTask(operatorI,randomHex))
				result[1] = gettingTheAnswer("1.c",firstTask(operatorI,randomHex))

				html << genSomehtml(leftString,rightString,dots)  
				htmlWithRes << genSomehtml(leftString,rightString,result) 
			end

			operatorI = operator[Random.new.rand(0..2)]
			randomDec = makingEasyOrHardDec(hardness)
			shiftingIndex = makingEasyOrHardShiftingDigits(hardness)
			shifterI = returnShifter(shifter)
			leftString = parsingTheTaskTohtml(secondTask(operatorI,randomDec,shifterI,shiftingIndex))
			result[0] = gettingTheAnswer("1.c",secondTask(operatorI,randomDec,shifterI,shiftingIndex))

			operatorI = operator[Random.new.rand(0..2)]
			randomDec = makingEasyOrHardDec(hardness)
			shiftingIndex = makingEasyOrHardShiftingDigits(hardness)
			shifterI = returnShifter(shifter)
			rightString = parsingTheTaskTohtml(secondTask(operatorI,randomDec,shifterI,shiftingIndex))
			result[1] = gettingTheAnswer("1.c",secondTask(operatorI,randomDec,shifterI,shiftingIndex))

			html << genSomehtml(leftString,rightString,dots)
			htmlWithRes << genSomehtml(leftString,rightString,result)

			operatorI = operator[Random.new.rand(0..2)]
			randomHex = makingEasyOrHardHexs(hardness)
			shiftingIndex = makingEasyOrHardShiftingDigits(hardness)
			shifterI = returnShifter(shifter)
			leftString = parsingTheTaskTohtml(thirdTask(operatorI,randomHex,shifterI,shiftingIndex))
			result[0] = gettingTheAnswer("1.c",thirdTask(operatorI,randomHex,shifterI,shiftingIndex))

			operatorI = operator[Random.new.rand(0..2)]
			randomHex = makingEasyOrHardHexs(hardness)
			shiftingIndex = makingEasyOrHardShiftingDigits(hardness)
			shifterI = returnShifter(shifter)
			rightString = parsingTheTaskTohtml(thirdTask(operatorI,randomHex,shifterI,shiftingIndex))
			result[1] = gettingTheAnswer("1.c",thirdTask(operatorI,randomHex,shifterI,shiftingIndex))

			html << genSomehtml(leftString,rightString,dots)
			htmlWithRes << genSomehtml(leftString,rightString,result)

			html << endhtml

			htmlWithRes << endhtml

			kit = PDFKit.new(html)
			kit.to_file("#{dirName}/Tests/Test ##{i+1}.pdf")
			kit = PDFKit.new(htmlWithRes)
			kit.to_file("#{dirName}/Answers/Test ##{i+1} with results.pdf")
			writingHtmlToFile(html,"Test ##{i+1}.html",dirName+"/Tests")
			writingHtmlToFile(htmlWithRes,"Test ##{i+1} with results.html",dirName+"/Answers")
		end
		print("Your directory name is \"#{dirName}\"\n")
		print("You generated #{numberOfTests} that are #{hardness}.\n")
	end

