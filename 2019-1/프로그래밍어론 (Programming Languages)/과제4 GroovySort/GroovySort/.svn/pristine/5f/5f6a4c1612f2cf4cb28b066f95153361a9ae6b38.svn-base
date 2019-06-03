package hufs.ces.poker

class FiveCards implements Comparable<FiveCards> {

	List<Card> fiveCards = [];
	
	FiveCards (Card[] cards) {
		assert cards.length == 5;
		for (int i=0; i<5; ++i) {
			fiveCards[i] = cards[i];
		}
		reorder();
	}
	@Override
	public int compareTo(FiveCards right) {
		return fiveCards[0].compareTo(right.fiveCards[0]);
		
	}
	@Override
	public String toString() {
		String result = "[";
		for(int i=0; i<5; ++i) {
			 if ( i != 0 ) result+=", ";
			 result += fiveCards[i].toString();
		}
		result += "]";
		return result;	
	}
	private void reorder() {
		SelSort sorter = new SelSort(fiveCards);
		fiveCards = (List<Card>)sorter.sort();
	}
}
