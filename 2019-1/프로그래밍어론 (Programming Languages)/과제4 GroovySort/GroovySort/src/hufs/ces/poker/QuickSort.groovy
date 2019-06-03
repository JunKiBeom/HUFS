package hufs.ces.poker

import java.util.ArrayList
import java.util.List

class QuickSort<T> implements ISorter<T> {

	ArrayList<T> list = null;

	public QuickSort(ArrayList<T> list) {
		this.list = list.clone();
	}
	
	@Override
	public List<T> sort() {

		quickSort(list);

		return list;
	}
	
	@Override
	public List<T> sort(Comparator<T> comp) {
		quickSort(list, comp);

		return list;
	}
	static<T> void quickSort(ArrayList<T> list) {
		int n = list.size();
		if (n < 2)
			return;

		ArrayList<T> list1 = new ArrayList<T>();
		ArrayList<T> list2 = new ArrayList<T>();
		ArrayList<T> listEq = new ArrayList<T>();

		T pivot = list.get(0);

		while (!list.isEmpty()) {
			if (list.get(0) < pivot) {
				list1.add(list.get(0));
			}
			else if (list.get(0) == pivot) {
				listEq.add(list.get(0));
			}
			else {
				list2.add(list.get(0));
			}
			list.remove(0);
		}
		quickSort(list1);
		quickSort(list2);

		list.addAll(list1);
		list.addAll(listEq);
		list.addAll(list2);
	}
	static<T> void quickSort(List list, Comparator<T> comp) {
		int n = list.size();
		if (n < 2)
			return;

		ArrayList<T> list1 = new ArrayList<T>();
		ArrayList<T> list2 = new ArrayList<T>();
		ArrayList<T> listEq = new ArrayList<T>();

		T pivot = list[0];

		while (!list.isEmpty()) {
			//println "${list[0]},${list[0].getClass()} -- ${pivot}, ${pivot.getClass()} "
			if (comp.compare(list[0],pivot) < 0) {
				list1.add(list[0]);
			}
			else if (comp.compare(list[0],pivot) == 0) {
				listEq.add(list[0]);
			}
			else {
				list2.add(list[0]);
			}
			list.remove(0);
		}
		quickSort(list1, comp);
		quickSort(list2, comp);

		list.addAll(list1);
		list.addAll(listEq);
		list.addAll(list2);
	}

}
