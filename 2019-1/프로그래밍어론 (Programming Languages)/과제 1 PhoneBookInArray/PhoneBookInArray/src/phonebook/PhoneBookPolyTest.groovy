package phonebook

class PhoneBookPolyTest {

	static void testPhoneBook(IPhoneBook pbook) {

		println "***Test ${pbook.class} PhoneBook***";

		String[] nameData = ["Park SH", "Kang JH",
			"Kim KS", "Lee YH", "Kang SH","Bae JM",
			"Lee DI", "Lee BH", "Jang WH", "Chun WY"];
		int[] numberData = [5023, 5002, 5008,
			5067, 5038, 5381, 5125, 5165, 5684, 5752];

		for (int i=0; i < nameData.length; ++i){
			pbook.insert(nameData[i], numberData[i]);
		}
		println "List All Inserted Entry";
		pbook.listAll();

		if (!pbook.insert(nameData[9], numberData[9])){
			println "***Error in Insert -- ${nameData[9]} ***";
		};
		if (!pbook.remove("Kim KS")){
			println "***Error in Remove -- Kim KS ***";
		};
		if (!pbook.insert("Kim CS", 5555)){
			println "***Error in Insert -- Kim CS ***";
		};
		if (!pbook.update("Kang JH", 5999)){
			println "***Error in Update -- Kang JH ***";
		};
		println "Find Phone Number By Name -- Kim CS	${pbook.find("Kim CS")}";

		println "***List All Updated Entry";
		pbook.listAll();
	}
	static main(args) {
	
		testPhoneBook(new PhoneBookList());
		testPhoneBook(new PhoneBookMap());
	}

}
