# 1. class Node 선언 부분
class Node:
    def __init__(self, key):
        self.key = key
        self.next = self.prev = self


# 2. class DoublyLinkedList 선언부분
class DoublyLinkedList:
    def __init__(self):
        self.head = Node(None)
        self.size = 0

    def printList(self):
        print("h -> ", end="")
        v = self.head.next
        while v != self.head:
            print(str(v.key) + " -> ", end="")
            v = v.next
        print("h")

    def splice(self, a, b, x):
        if a == None or b == None or x == None:
            return
        # 1. [a..b] 구간을 잘라내기
        a.prev.next = b.next
        b.next.prev = a.prev

        # 2. [a..b]를 x 다음에 삽입하기
        x.next.prev = b
        b.next = x.next
        a.prev = x
        x.next = a

    def moveAfter(self, a, x):
        self.splice(a, a, x)

    def moveBefore(self, a, x):
        self.splice(a, a, x.prev)

    def insertAfter(self, x, key):
        self.moveAfter(Node(key), x)
        self.size += 1

    def insertBefore(self, x, key):
        self.moveBefore(Node(key), x)
        self.size += 1

    def pushFront(self, key):
        self.insertAfter(self.head, key)
        self.size += 1

    def pushBack(self, key):
        self.insertBefore(self.head, key)
        self.size += 1

    # 수정

    def search(self, key):
        v = self.head.next
        while v != self.head:
            if v.key == key:
                return v
            v = v.next
        return None

    def deleteNode(self, x):
        if x == None or x == self.head: return
        x.prev.next, x.next.prev = x.next, x.prev
        self.size -= 1

    def remove(self, x):
        self.deleteNode(x)

    def popFront(self):
        if self.isEmpty(): return None  # size==0
        key = self.head.next.key
        self.remove(self.head.next)
        self.size -= 1
        return key

    def popBack(self):
        if self.isEmpty(): return None  # size==0
        key = self.head.prev.key
        self.remove(self.head.prev)
        self.size -= 1
        return key

    def first(self):
        return self.head.next.key

    def last(self):
        return self.head.prev.key

    def __len__(self):
        return self.size

    def isEmpty(self):
        # return self.__len__() == 0
        return self.head == self.head.next


def josephus(n, k):
    # DoublyLinkedList 클래스 인스탠스 L을 선언
    L = DoublyLinkedList()
# 1번부터 n번까지의 key 값을 갖는 노드를 pushBack 함수를 써서 L에 삽입
    for i in range (1,n+1):
        L.pushBack(i)
# k개의 링크를 따라간 노드를 remove하는 과정을 한 노드만 남을때까지 반복.
    X = L.head.next
    for i in range (n-1):
        for i in range(k):
            X = X.next
            if X == L.head:
                X = X.next
        Y = X.next
        L.deleteNode(X)
        X = Y
        if X == L.head:
            X = X.next
# 주의: k개의 링크를 따라갈때 dummy노드도 방문될수 있다는 점

# 남아 있는 노드의 key를 리턴
    return L.head.next.key  # X.key
# n과 k를 입력
n, k = input().split()
n, k = int(n), int(k)
# n과 k에 대해서 Josephus함수 호출에서 리턴값을 출력
print(josephus(n,k))
