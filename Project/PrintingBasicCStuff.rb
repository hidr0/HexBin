level = ARGV[0]

if(ARGV[1].to_s.downcase == "and")
	operator = "&"
elsif ARGV[1].to_s.downcase == "or"
	operator = "|"
elsif ARGV[1].to_s.downcase == "xor"
	operator = "^"
end
 tempHex = system("ruby EasyOrHard.rb #{level}").to_s
p "tempHex="
p tempHex

File.open("hello.c", "w") do |file|  
	file <<
	"
	#include<stdio.h>
	int main(){
		int res = #{tempA}#{operator}#{tempB};
		printf(\"0x\");
		printf(\"%04x\",res);
		return 0;
	}
	"
end

# hello = system("gcc hello.c && ./a.out")
# print(hello.to_s.gsub("true",""))
# print("\n")
# system("rm hello.c a.out")

