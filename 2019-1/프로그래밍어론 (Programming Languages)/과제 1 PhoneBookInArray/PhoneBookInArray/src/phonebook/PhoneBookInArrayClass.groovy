package phonebook

class PhoneBookInArrayClass {

	static final int MAX_CONTACT_ENTRY = 100;

	static String[] nameData = ["Park SH", "Kang JH", 
		"Kim KS", "Lee YH", "Kang SH","Bae JM", 
		"Lee DI", "Lee BH", "Jang WH", "Chun WY"];
	static int[] numberData = [5023, 5002, 5008, 
		5067, 5038, 5381, 5125, 5165, 5684, 5752];

	static Entry[] arrayPhoneBook = new Entry[MAX_CONTACT_ENTRY];
	static int lastp = 0;

	static int findLoc(String name){
		for (int i=0; i<lastp; ++i){
			if (arrayPhoneBook[i].phoneName == name)
				return i;
		}
		return -1; // not found
	}
	
	static Entry find(String name){
		int loc = findLoc(name);
		if (loc == -1)
			return null; // not found
		return arrayPhoneBook[loc];
	}

	static int findPhoneNumber(String name){
		int loc = findLoc(name);
		if (loc == -1)
			return -1; // not found
		return arrayPhoneBook[loc].phoneNumber;
	}

	static insert(String name, int number){
		int loc = findLoc(name);
		if (loc == -1){ // insert
			if (lastp > MAX_CONTACT_ENTRY){
				println "***Error -- PhoneBook Overflow";
			}
			else {
				arrayPhoneBook[lastp] = new Entry(name, number);
				lastp++;
			}
		}
		else {
			println "***Error -- Duplicated Name";
		}
	}
	static remove(String name){
		int loc = findLoc(name);
		if (loc != -1){ // there exist name
			// remove array entry at loc
			for (int i=loc+1; i<lastp; ++i){
				arrayPhoneBook[i-1].phoneName = arrayPhoneBook[i].phoneName;
				arrayPhoneBook[i-1].phoneNumber = arrayPhoneBook[i].phoneNumber;
			}
			lastp--;
		}
		else {
			println "***Error -- Name not found";
		}
	}
	static update(String name, int number){
		remove(name);
		insert(name, number);
	}
	static listAll(){
		println "Name\tNumber";
		for (int i=0; i<lastp; ++i){
			println "${arrayPhoneBook[i].phoneName}\t" +
			"${arrayPhoneBook[i].phoneNumber}"
		}
	}
	static main (args) {
		int incount = 10;
		for (int i=0; i < incount; ++i){
			insert(nameData[i], numberData[i]);
		}
		println "List All Inserted Entry";
		listAll();

		remove("Kim KS");
		insert("Kim CS", 5555);
		update("Kang JH", 5999);
		println "Find Phone Number By Name -- Kim CS	" +
		"${find("Kim CS").phoneNumber}";

		println "List All Updated Entry";
		listAll();

	}

}


