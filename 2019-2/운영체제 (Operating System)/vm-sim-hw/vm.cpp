// 201703091/컴전학부/전기범

// Virtual Memory Simulator: currently uses FIFO page replacement
//////////////////////////////////////////////////////////////////

#include <iostream>
#include "pagetable.h"

using namespace std;

int main()
{
	int logSize;
	cout << "Enter number of pages in logical memory: " << endl;
	cin >> logSize;

	int physSize;
	cout << "Enter number of frames in physical memory: " << endl;
	cin >> physSize;

	PageTable PT(logSize, physSize);            // CREATE THE PAGE TABLE

	cout << "Enter the page-reference string: " << endl;
	int pageNum;
	int cnt=0;
	cin >> pageNum;
	while (pageNum != -1) {                    // REPEAT UNTIL END OF INPUT
		if (PT.isValid(pageNum)) {              // IF PAGE IS IN MEMORY,
			PT.accessPage(pageNum);             //   THEN ACCESS IT
		}
		else {                                  // OTHERWISE,
			cnt++;
			PT.storePage(pageNum);              //   SWAP THE PAGE IN 
			PT.accessPage(pageNum);             //   THEN ACCESS IT
		}

		cin >> pageNum;                         // READ NEXT INPUT VALUE
	}
		cout << "Total number of Page Faults: " << cnt << endl;

	return 0;
}
