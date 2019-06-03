package hufs.ces.poker

class SelSort<T> implements ISorter<T> {
	
	private ArrayList<T> list = null;

	public SelSort(ArrayList<T> list) {
		this.list = list.clone();
	}

	@Override
	public List<T> sort() {

		int lsize = list.size();
		for (int i=0; i<lsize; ++i){
			int minit = getMinIndex(i);
			swapNode(i, minit);
		}
		return list;
	}
	@Override
	public List<T> sort(Comparator<T> comp) {
		int lsize = list.size();
		for (int i=0; i<lsize; ++i){
			int minit = getMinIndex(i, comp);
			swapNode(i, minit);
		}
		return list;
	}
	
	private void swapNode(int p, int q) {
		T tempNode = list.get(p);
		list.set(p, list.get(q));
		list.set(q, tempNode);
	}
	private int getMinIndex(int rest) {
		assert rest >= 0 && rest < list.size();
		int minInd = rest;
		for (int i=rest+1; i<list.size(); ++i) {
			if (list.get(i) < list.get(minInd)) {
				minInd = i;
			}
		}
		return minInd;
	}
	private int getMinIndex(int rest, Comparator<T> comp) {
		assert rest >= 0 && rest < list.size();
		int minInd = rest;
		for (int i=rest+1; i<list.size(); ++i) {
			if (comp.compare(list.get(i),list.get(minInd)) < 0) {
				minInd = i;
			}
		}
		return minInd;
	}

}
