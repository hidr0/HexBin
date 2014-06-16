params = [ARGV[0],ARGV[1],ARGV[2]]
if(ARGV[2].to_s.downcase == "and")
	Operator = "&"
elsif ARGV[2].to_s.downcase == "or"
	Operator = "|"
elsif ARGV[2].to_s.downcase == "xor"
	Operator = "^"
end

File.open("hello.c", "w") do |file|  
	file <<
	"
	#include<stdio.h>
	int main(){
		int res = #{params[0]}#{Operator}#{params[1]};
		printf(\"0x\");
		printf(\"%04x\",res);

		return 0;
	}
	"
end

hello = system("gcc hello.c && ./a.out")
print(hello.to_s.gsub("true",""))
print("\n")
system("rm hello.c a.out")