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
	public String find(int number){
		for (int i=0; i<phoneBookList.size(); ++i){
			if (phoneBookList[i].phoneNumber == number)
				return phoneBookList[i].phoneName
		}
		return -1; // not found
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
		int idx = findLoc(name);
		if (idx!=-1) {
			phoneBookList[idx].phoneNumber=number;
			return true;
		}
		else {
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
		println "";
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

		/*pbook.remove("Kim KS");

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
		pbook.listAll();*/

		/*insert("Kim TW", 2039);
		insert("Jun KB", 9992);
		insert("Kim SY", 7828);
		listAll();
		remove("Kim TW");
		update("Kang JH", 5999);
		update("Lee YH", 7035);
		listAll();
		remove("Bae JM");
		listAll();
		find(5039);
		find(9992);
		find(5038);
		find(1453);*/
		
		pbook.insert("Kim TW",2039);
		pbook.insert("Jun KB",9992);
		pbook.insert("Kim SY",7828);
		println "\nList All Inserted Entry";
		pbook.listAll();
		pbook.remove("Kim TW");
		pbook.update("Kang JH",5999);
		pbook.update("Lee YH",7035);
		println "\nList All Inserted Entry";
		pbook.listAll();
		pbook.remove("Bae JM");
		println "\nList All Inserted Entry";
		pbook.listAll();

		print "Find Phone Number of Kim SY";
		if (pbook.find("Kim SY") != -1) {
			println "\t${pbook.find("Kim SY")}";
		}
		else {
			println "\t***Error -- Name not found";
		}

		print "Find Phone Number of Kim CS";
		if (pbook.find("Kim CS") != -1) {
			println "\t${pbook.find("Kim CS")}";
		}
		else {
			println "\t***Error -- Name not found";
		}

		print "Find Name of 5039";
		if (pbook.find(5039)!="-1"){
			println "\t${(pbook.find(5039))}"
		}
		else{
			println "\t***Error -- Number not found"
		}

		print "Find Name of 9992";
		if (pbook.find(9992)!="-1"){
			println "\t${(pbook.find(9992))}"
		}
		else{
			println "\t***Error -- Number not found"
		}

		print "Find Name of 5038";
		if (pbook.find(5038)!="-1"){
			println "\t${(pbook.find(5038))}"
		}
		else{
			println "\t***Error -- Number not found"
		}

		print "Find Name of 1453";
		if (pbook.find(1453)!="-1"){
			println "\t${(pbook.find(1453))}"
		}
		else{
			println "\t***Error -- Number not found"
		}
	}
}
