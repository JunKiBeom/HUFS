package phonebook

import groovy.transform.Field

@Field final int MAX_ENTRY = 100;

@Field String[] nameData = ["Park SH", "Kang JH",
	"Kim KS", "Lee YH", "Kang SH","Bae JM",
	"Lee DI", "Lee BH", "Jang WH", "Chun WY"];
@Field int[] numberData = [5023, 5002, 5008,
	5067, 5038, 5381, 5125, 5165, 5684, 5752];

@Field Entry[] arrayPhoneBook = new Entry[MAX_ENTRY];
@Field int lastp = 0;

int findLoc(String name){
	for (int i=0; i<lastp; ++i){
		if (arrayPhoneBook[i].phoneName == name)
			return i;
	}
	return -1; // not found
}

Entry find(int number){
	int cnt=0;
	for (int i=0; i<lastp; ++i){
		cnt++;
		if (arrayPhoneBook[i].phoneNumber == number) {
			println("Find name : " + arrayPhoneBook[i].phoneName+"\n"+"-"*14);
			break;
		}
	}
	if (cnt==lastp)
		println("***Error -- Number not found\n"+"-"*14)
	//return -1; // not found
	//return arrayPhoneBook[loc];
}

int findPhoneNumber(String name){
	int loc = findLoc(name);
	if (loc == -1)
		return -1; // not found
	return arrayPhoneBook[loc].phoneNumber;
}

void insert(String name, int number){
	int loc = findLoc(name);
	if (loc == -1){ // insert
		if (lastp > MAX_ENTRY){
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
void remove(String name){
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
void update(String name, int number){
	//remove(name);
	//insert(name, number);
	int loc = findLoc(name);
	arrayPhoneBook[loc].phoneNumber=number;
}
void listAll(){
	println "Name\tNumber";
	for (int i=0; i<lastp; ++i){
		println "${arrayPhoneBook[i].phoneName}\t" +
				"${arrayPhoneBook[i].phoneNumber}"
	}
	println("-"*14);
}

// main
int incount = 10;
for (int i=0; i < incount; ++i){
	insert(nameData[i], numberData[i]);
}
println "List All Inserted Entry";
listAll();

/*
remove("Kim KS");
insert("Kim CS", 5555);
update("Kang JH", 5999);
println "Find Phone Number By Name -- Kim CS	" +
		"${find("Kim CS").phoneNumber}";

println "List All Updated Entry";
listAll();
*/

insert("Kim TW", 2039);
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
find(1453);