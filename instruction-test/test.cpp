#include <iostream>

using namepsace std;

extern "C" {
	int mystrlen(const char *string);
}

bool testsign(int value) {
	return (value >> 31) & 1;
}

int main() {
	cout << test(-212889) << '\n'; 
}
