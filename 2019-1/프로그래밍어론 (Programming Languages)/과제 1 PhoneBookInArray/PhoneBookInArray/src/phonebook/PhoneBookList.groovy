package phonebook

class PhoneBookList implements IPhoneBook {

	private List<Entry> phoneBookList;

	PhoneBookList() {
		phoneBookList = [];
	}
	private int findLoc(String name){
		for (int i=0; i<phoneBookList.size(); ++i){
			if (phoneBookList[i].phoneName == name)
				// phoneBookList[i].phoneName.equals(name) in Java
				return i;
		}
		return -1; // not found
	}

	@Override
	public int find(String name) {
		int loc = findLoc(name);
		if (loc == -1)
			return -1; // not found
		return phoneBookList[loc].phoneNumber;
	}

	@Override
	public boolean insert(String name, int number) {
		int loc = findLoc(name);
		if (loc == -1){ //  can insert
			phoneBookList.add(new Entry(name, number));
			return true;
		}
		else {
			return false;
		}
	}

	@Override
	public boolean update(String name, int number) {
		if (remove(name)) {
			insert(name, number);
			return true;
		} else {
			return false;
		}
	}

	@Override
	public boolean remove(String name) {
		int loc = findLoc(name);
		if (loc != -1){ // there exist name
			// remove array entry at loc
			phoneBookList.remove(loc);
			return true;
		}
		else {
			return false;
		}
	}

	@Override
	public void listAll() {
		println "Name\tNumber";
		for (int i=0; i<phoneBookList.size(); ++i){
			println "${phoneBookList[i].phoneName}\t${phoneBookList[i].phoneNumber}"
		}
	}
	static main(args) {

		String[] nameData = ["Park SH", "Kang JH",
			"Kim KS", "Lee YH", "Kang SH","Bae JM",
			"Lee DI", "Lee BH", "Jang WH", "Chun WY"];
		int[] numberData = [5023, 5002, 5008,
			5067, 5038, 5381, 5125, 5165, 5684, 5752];

        PhoneBookList pbook = new PhoneBookList();

		for (int i=0; i < nameData.length; ++i){
			pbook.insert(nameData[i], numberData[i]);
		}
		println "List All Inserted Entry";
		pbook.listAll();

		pbook.remove("Kim KS");

		print "Find Phone Number of Kim CS";
		if (pbook.find("Kim CS") != -1) {
			println "\t${pbook.find("Kim CS")}";
		}
		else {
			println "\t***Error -- Name not found";			
		}
		pbook.insert("Kim CS", 5555);
		pbook.update("Kang JH", 5999);
		
		print "Find Phone Number of Kim CS";
		if (pbook.find("Kim CS") != -1) {
			println "\t${pbook.find("Kim CS")}";
		}
		else {
			println "\t***Error -- Name not found";			
		}

		println "List All Updated Entry";
		pbook.listAll();

	}

}
