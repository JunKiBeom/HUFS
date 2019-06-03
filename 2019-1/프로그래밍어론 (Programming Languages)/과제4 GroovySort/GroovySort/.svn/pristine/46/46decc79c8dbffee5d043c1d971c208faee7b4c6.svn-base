package hufs.ces.poker

class Card implements Comparable<Card> {

	static final int ACE=1, JACK=11, QUEEN=12, KING=13;
	static final int CLUB=1, DIAMOND=2, HEART=3, SPADE=4;

	int suit;
	int rank;

	Card (int s, int r) {
		suit = s;
		rank = r;
	}

	@Override
	String toString() {

		String image;
		switch (suit) {
			case CLUB:		image = "CL-"; break;
			case DIAMOND:	image = "DI-"; break;
			case HEART:	image = "HE-"; break;
			case SPADE:	image = "SP-"; break;
		}
		switch (rank) {
			case ACE:	image += "A "; break;
			case JACK:	image += "J "; break;
			case QUEEN:	image += "Q "; break;
			case KING:	image += "K "; break;
			case 10:	image += "10"; break;
			default:	image = image + rank + " ";
		}
		return image;
	}

	@Override
	public int compareTo(Card right) {
		int lrank, rrank;
		if (rank == ACE )
			lrank = KING + 1;
		else
			lrank = rank;
	
		if (right.rank == ACE )
			rrank = KING + 1;
		else
			rrank = right.rank;
	
		int diff = lrank - rrank;

		return diff;	
	}
}
