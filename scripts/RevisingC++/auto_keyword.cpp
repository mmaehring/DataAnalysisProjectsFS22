#include <iostream>



int print_letter(char b){
    std::cout << b << std::endl;
}


int main()
{
    int count = 10;
    int& countRef = count;
    auto myAuto = countRef;

    countRef = 11;
    std::cout << count << " ";

    myAuto = 12;
    std::cout << count << std::endl;

    auto& myAutoref = countRef; // here auto gets identified as a reference instead of an integer 
    myAutoref = 12;
    
    std::cout << count << std::endl;

    print_letter('!');
    return 0;
}