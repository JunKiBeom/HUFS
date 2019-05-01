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

		/*if (!pbook.insert(nameData[9], numberData[9])){
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
		pbook.listAll();*/

		if (!pbook.insert("Kim TW", 2039)){
			println "***Error in Insert -- ${"Kim TW"} ***";
		};
		if (!pbook.insert("Jun KB", 9992)){
			println "***Error in Insert -- ${"Jun KB"} ***";
		};
		if (!pbook.insert("Kim SY", 7828)){
			println "***Error in Insert -- ${"Kim SY"} ***";
		};
		println "***List All Updated Entry";
		pbook.listAll();

		if (!pbook.remove("Kim TW")){
			println "***Error in Remove -- Kim TW ***";
		};
		if (!pbook.update("Kang JH", 5999)){
			println "***Error in Update -- Kang JH ***";
		};
		if (!pbook.update("Lee YH", 7035)){
			println "***Error in Update -- Lee YH ***";
		};
		println "***List All Updated Entry";
		pbook.listAll();

		if (!pbook.remove("Bae JM")){
			println "***Error in Remove -- Bae JM ***";
		};
		println "***List All Updated Entry";
		pbook.listAll();

		print "Find Phone Number By Name -- Kim SY";
		if (pbook.find("Kim SY") == -1)
			println "\t***Error -- Name not found";
		else
			println "\t${pbook.find("Kim SY")}";

		print "Find Phone Number By Name -- Kim CS";
		if (pbook.find("Kim CS") == -1)
			println "\t***Error -- Name not found";
		else
			println "\t${pbook.find("Kim CS")}";

		print "Find Name By Phone Number -- 5039";
		if (pbook.find(5039) == "-1")
			println "\t***Error -- Number not found"
		else
			println "\t${pbook.find(5039)}";

		print "Find Name By Phone Number -- 9992";
		if (pbook.find(9992) == "-1")
			println "\t***Error -- Number not found"
		else
			println "\t${pbook.find(9992)}";

		print "Find Name By Phone Number -- 5038";
		if (pbook.find(5038) == "-1")
			println "\t***Error -- Number not found"
		else
			println "\t${pbook.find(5038)}";

		print "Find Name By Phone Number -- 1453";
		if (pbook.find(1453) == "-1")
			println "\t***Error -- Number not found"
		else
			println "\t${pbook.find(1453)}";

	}
	static main(args) {
	
		testPhoneBook(new PhoneBookList());
		println();
		testPhoneBook(new PhoneBookMap());
		println();
		testPhoneBook(new PhoneBookInArrayClass())
	}

}
