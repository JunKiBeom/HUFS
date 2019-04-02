package phonebook

class PhoneBookMap implements IPhoneBook {

	private Map<String, Integer> phoneBookMap;

	PhoneBookMap() {
		phoneBookMap = [:];
	}

	@Override
	public int find(String name) {
		Integer pnumber = phoneBookMap[name];
		if (pnumber!=null) {
			return pnumber;
		}
		else {
			return -1;
		}
	}

	@Override
	public boolean insert(String name, int number) {
		if (find(name) == -1){ // insert
			//phoneBookMap.put(name, number); // Java style
			phoneBookMap[name] = number; // Groovy style
			return true;
		}
		else {
			return false;
		}
	}

	@Override
	/*
	public boolean update(String name, int number) {
		if (remove(name)) {
			insert(name, number);
			return true;
		} else {
			return false;
		}
	}
	*/
	public boolean update(String name, int number) {
		if (find(name) != -1){ // update
			//phoneBookMap.put(name, number); // Java style
			phoneBookMap[name] = number; // Groovy style
			return true;
		}
		else {
			return false;
		}
	}

	@Override
	public boolean remove(String name) {
		if (find(name) != -1){ // remove
			phoneBookMap.remove(name);
			return true;
		}
		else {
			return false;
		}
	}

	@Override
	public void listAll() {
		println "Name\tNumber";
		phoneBookMap.each { pname, pnumber -> println "${pname}\t${pnumber}"
		}
	}
	static main(args) {
		String[] nameData = ["Park SH", "Kang JH",
			"Kim KS", "Lee YH", "Kang SH","Bae JM",
			"Lee DI", "Lee BH", "Jang WH", "Chun WY"];
		int[] numberData = [5023, 5002, 5008,
			5067, 5038, 5381, 5125, 5165, 5684, 5752];

        PhoneBookMap pbook = new PhoneBookMap();

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
