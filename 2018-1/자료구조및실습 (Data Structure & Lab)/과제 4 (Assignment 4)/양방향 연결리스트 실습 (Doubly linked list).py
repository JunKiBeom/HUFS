# 1. class Node 선언 부분
class Node:
    def __init__(self,key):
        self.key = key
        self.next = self.prev = self

# 2. class DoublyLinkedList 선언부분
class DoublyLinkedList:
    def __init__(self):
        self.head = Node(None)
        self.size = 0

    def printList(self):
        print("h -> ", end="")
        v=self.head.next
        while v != self.head:
            print(str(v.key)+" -> ", end="")
            v=v.next
        print("h")

    def splice(self,a,b,x):
        if a == None or b== None or x == None:
            return
        # 1. [a..b] 구간을 잘라내기
        a.prev.next=b.next
        b.next.prev=a.prev

        # 2. [a..b]를 x 다음에 삽입하기
        x.next.prev=b
        b.next=x.next
        a.prev=x
        x.next=a

    def moveAfter(self,a,x):
        self.splice(a,a,x)

    def moveBefore(self,a,x):
        self.splice(a,a,x.prev)

    def insertAfter(self,x,key):
        self.moveAfter(Node(key),x)
        self.size+=1

    def insertBefore(self,x,key):
        self.moveBefore(Node(key), x)
        self.size+=1

    def pushFront(self,key):
        self.insertAfter(self.head,key)
        self.size += 1

    def pushBack(self,key):
        self.insertBefore(self.head,key)
        self.size += 1
    # 수정

    def search(self,key):
        v = self.head.next
        while v != self.head:
            if v.key == key:
                return v
            v=v.next
        return None

    def deleteNode(self,x):
        if x== None or x==self.head: return
        x.prev.next, x.next.prev = x.next, x.prev
        self.size -= 1

    def remove(self,x):
        self.deleteNode(x)

    def popFront(self):
        if self.isEmpty(): return None    # size==0
        key = self.head.next.key
        self.remove(self.head.next)
        self.size -= 1
        return key
        
    def popBack(self):
        if self.isEmpty(): return None    # size==0
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
        #return self.__len__() == 0
        return self.head==self.head.next

    ㅈdef join(self):
    #def split(self):

L = DoublyLinkedList()
while True:
    cmd = input().split()
    if cmd[0] == 'pushF':
        L.pushFront(int(cmd[1]))
        print("+ {0} is pushed at Front".format(cmd[1]))
    elif cmd[0] == 'pushB':
        L.pushBack(int(cmd[1]))
        print("+ {0} is pushed at Back".format(cmd[1]))
    elif cmd[0] == 'popF':
        key = L.popFront()
        if key == None:
            print("* list is empty")
        else:
            print("- {0} is popped from Front".format(key))
    elif cmd[0] == 'popB':
        key = L.popBack()
        if key == None:
            print("* list is empty")
        else:
            print("- {0} is popped from Back".format(key))
    elif cmd[0] == 'search':
        v = L.search(int(cmd[1]))
        if v == None: print("* {0} is not found!".format(cmd[1]))
        else: print(" * {0} is found!".format(cmd[1]))
    elif cmd[0] == 'insertA':
        # inserta key_x key : key의 새 노드를 key_x를 갖는 노드 뒤에 삽입
        x = L.search(int(cmd[1]))
        if x == None: print("* target node of key {0} doesn't exit".format(cmd[1]))
        else:
            L.insertAfter(x, int(cmd[2]))
            print("+ {0} is inserted After {1}".format(cmd[2], cmd[1]))
    elif cmd[0] == 'insertB':
        # inserta key_x key : key의 새 노드를 key_x를 갖는 노드 앞에 삽입
        x = L.search(int(cmd[1]))
        if x == None: print("* target node of key {0} doesn't exit".format(cmd[1]))
        else:
            L.insertBefore(x, int(cmd[2]))
            print("+ {0} is inserted Before {1}".format(cmd[2], cmd[1]))
    elif cmd[0] == 'delete':
        x = L.search(int(cmd[1]))
        if x == None:
            print("- {0} is not found, so nothing happens".format(cmd[1]))
        else:
            L.deleteNode(x)
            print("- {0} is deleted".format(cmd[1]))
    elif cmd[0] == "first":
        print("* {0} is the value at the front".format(L.first()))
    elif cmd[0] == "last":
        print("* {0} is the value at the back".format(L.last()))
    elif cmd[0] == 'print':
        L.printList()
    elif cmd[0] == 'exit':
        break
    else:
        print("* not allowed command. enter a proper command!")

'''
pushB 10
pushF 11
pushF 12
print
popF
popB
print
pushB 22
pushF 100
exit
'''
