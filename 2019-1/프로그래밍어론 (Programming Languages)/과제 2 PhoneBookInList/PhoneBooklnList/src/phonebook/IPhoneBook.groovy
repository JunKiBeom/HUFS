package phonebook

interface IPhoneBook {
	
	int find(String name);
	//String findName(int number);
	String find(int number);
	boolean insert(String name, int number);
	boolean update(String name, int number);
	boolean remove(String name);
	
	void listAll();
}
