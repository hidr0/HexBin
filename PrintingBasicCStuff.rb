p a = ARGV[0]
p b = ARGV[1]
File.open("hello.c", "w") do |file|  
	file << "
	#include<stdio.h>
	int main(){
	int a = 0x000F;
	int b = 0x0000;
	int res = #{a}|#{b};
	printf(\"Result = %#0x\",res);

	return 0;
	}
	"
end

hello = system("gcc hello.c && ./a.out")


print(hello.to_s.gsub("true",""))
print("\n")
system("rm hello.c a.out")