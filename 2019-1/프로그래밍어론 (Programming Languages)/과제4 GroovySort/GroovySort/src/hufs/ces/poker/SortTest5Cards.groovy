package hufs.ces.poker

import java.util.ArrayList
import java.util.List

class SortTest5Cards {

	static final int CLUB=1, DIAMOND=2, HEART=3, SPADE=4;
	static main(args) {
		sortTest5Cards()
	}
	
	static ArrayList<FiveCards> generate5CardList(int gencount) {

		// Generate List<FiveCards>
		ArrayList<FiveCards> p5CardsList = new ArrayList<FiveCards>();
		ArrayList<Card> deckCard = new ArrayList<Card>();

		// Make a Card Deck
		for (int s=Card.CLUB; s<=Card.SPADE; s++)
			for (int r=Card.ACE; r<=Card.KING; r++){
				deckCard.add(new Card(s,r));
			}

		for (int i=1; i<=gencount; i++) {

			suffle(deckCard);

			// Make a Card Deck
			int indDeck = 0;

			Card[] fc = new Card[5];
			int ipos = 0;
			while (indDeck < deckCard.size()) {
				fc[ipos] = deckCard.get(indDeck);
				indDeck++;
				ipos++;
				if (ipos == 5) {
					p5CardsList.add(new FiveCards(fc));
					ipos = 0;
				}
			}
		}
		return p5CardsList;
	}
	static void suffle (ArrayList<Card> list) {
		final int  SUFFLECOUNT = 100;

		//println "List before Suffle"
		//printList(list);
		Random rand = new Random(1234);
		int oneOrzero = 0;
		int lsize = list.size();
		int ind = 0;
		for (int i=1; i <= SUFFLECOUNT*lsize; i++) {
			// random number  0 or 1
			oneOrzero = rand.nextInt(2);
			//println "ind=$ind rand=$oneOrzero card=${list.get(ind)}"
			if (oneOrzero == 0) {
				// move to back
				list.add(list.remove(ind));
			}
			else {
				ind++;
				ind %= lsize;
			}
		}
		//println "List after Suffle"
		//printList(list);
	}
	static void printFiveCardsList(List<FiveCards> fcList) {
		int ccount = 0;
		for (FiveCards fc : fcList) {
			println "${++ccount} $fc";
		}
	}
	static void sortTest5Cards() {
		println "Sort Test 5 Cards";
		ArrayList<FiveCards> list5card = generate5CardList(10);

		// Add more sample data
		Card[] fourCards = [new Card(CLUB,1), new Card(DIAMOND,1), new Card(HEART,1), new Card(SPADE,1), new Card(CLUB,2)];
		list5card.add(new FiveCards(fourCards));

		Card[] fullhouse = [new Card(CLUB,1), new Card(DIAMOND,1), new Card(HEART,1), new Card(SPADE,13), new Card(CLUB,13)];
		list5card.add(new FiveCards(fullhouse));

		Card[] straight = [new Card(CLUB,1), new Card(DIAMOND,2), new Card(HEART,3), new Card(SPADE,4), new Card(CLUB,5)];
		list5card.add(new FiveCards(straight));

		Card[] flush = [new Card(CLUB,1), new Card(CLUB,2), new Card(CLUB,3), new Card(CLUB,4), new Card(CLUB,6)];
		list5card.add(new FiveCards(flush));

		Card[] straightflu = [new Card(CLUB,1), new Card(CLUB,2), new Card(CLUB,3), new Card(CLUB,4), new Card(CLUB,5)];
		list5card.add(new FiveCards(straightflu));

		Card[] twopair = [new Card(1,1), new Card(DIAMOND,1), new Card(HEART,10), new Card(SPADE,10), new Card(CLUB,2)];
		list5card.add(new FiveCards(twopair));

		Card[] onepair = [new Card(1,1), new Card(DIAMOND,1), new Card(HEART,4), new Card(SPADE,5), new Card(CLUB,6)];
		list5card.add(new FiveCards(onepair));

		Card[] nopair = [new Card(1,1), new Card(DIAMOND,3), new Card(HEART,5), new Card(SPADE,7), new Card(CLUB,9)];
		list5card.add(new FiveCards(nopair));

		// Display the Deck
		println "FiveCards before Sort";
		printFiveCardsList(list5card);
		// List Test
		//List<FiveCards> list5cardSorted = new SelSort(list5card).sort(new SimpleFiveCardsComparator());
		List<FiveCards> list5cardSorted = new QuickSort(list5card).sort(new SimpleFiveCardsComparator());
		//List<FiveCards> list5cardSorted = new QuickSort(list5card).sort(new MyFiveCardsComparator());
		
		println "FiveCards after Sort";
		printFiveCardsList(list5cardSorted);

	}

}
