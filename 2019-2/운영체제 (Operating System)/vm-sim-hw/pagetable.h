// 201703091/컴전학부/전기범

// PageTable class
//   this class models a page table for implementing virtual memory
///////////////////////////////////////////////////////////////////////////////////////

#ifndef _PAGE_TABLE_
#define _PAGE_TABLE_

#include <vector>
using namespace std;

class PageTable
{
	public:
		PageTable(int log, int phys);
		bool isValid(int pageNum);
		void accessPage(int pageNum);
		void storePage(int pageNum);
	private:
		int numStored;

		class TableEntry
		{
			public:
				int frameNumber;
				int timeStamp;
				bool valid;
				TableEntry() { valid = false; }
		};
		vector<TableEntry> pageMap;
		vector<int> freeFrames;

		int selectSwapPage();
};

#endif
