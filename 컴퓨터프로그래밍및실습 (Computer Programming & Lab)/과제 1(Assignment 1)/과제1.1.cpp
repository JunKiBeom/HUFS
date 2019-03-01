#include <iostream>

using namespace std;

int main()
{
	char *pc;
	int *pi;
	double *pd;

	pc = (char *)10000;
	pi = (int *)10000;
	pd = (double *)10000;

	cout << "Áõ°¡ Àü pc = " << (void *)pc << " pi = " << pi << " pd = " << pd << endl;

	pc++;
	pi++;
	pd++;

	cout << "Áõ°¡ ÈÄ pc = " << (void *)pc << " pi = " << pi << " pd = " << pd << endl;

	return 0;

}
