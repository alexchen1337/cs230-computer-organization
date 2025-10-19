#include <iostream>
using namespace std;

struct MyStruct {
    int i;
    char j;
    float k;
};

extern "C" {
    int getj(const MyStruct *ms);
    int setj(MyStruct *ms, int k);
}

int main() {
    MyStruct ms = {};

    setj(&ms, -33);

    cout << getj(&ms) << endl;
    cout << (int)ms.j << endl;
}