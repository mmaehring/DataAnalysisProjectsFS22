#include <cmath>
#include <vector>
#include <iostream>


int main(){
	double mass = 934; // MeV 
	const int c_0 = 299792458;
	double p = 0;
	// [&c_0, mass, p] (){
	// 	return pow(mass, 2) * pow(c_0, 4) + pow(p, 2) * pow(c_0, 2);
	// };

	[&c_0, mass, p] (){
		return pow(mass, 2) * pow(c_0, 4) + pow(p, 2) * pow(c_0, 2);
	}
;

	return 0;
}