# -*- coding: utf-8 -*-
# UTF-8 encoding when using korean
class Node:
    def __init__(self, key):
        self.key = key
        self.parent = self.left = self.right = None

    def __str__(self):
        return str(self.key)


class Tree:
    def __init__(self):
        self.root = None
        self.size = 0

    def __len__(self):
        return self.size

    def preorder(self, v):
        if v != None:
            print(v, end=" ")
            self.preorder(v.left)
            self.preorder(v.right)

    def inorder(self, v):
        if v != None:
            self.inorder(v.left)
            print(v, end=" ")
            self.inorder(v.right)

    def postorder(self, v):
        if v != None:
            self.postorder(v.left)
            self.postorder(v.right)
            print(v, end=" ")

    def find_loc(self, key):
        if self.size==0: return None
        p=None
        v=self.root
        while v != None:
            if v.key == key: return v
            elif v.key < key:
                p=v
                v=v.right
            else:
                p=v
                v=v.left
        return p

    def search(self, key):
        p=self.find_loc(key)
        if p != None and p.key == key:    # key is in tree
            return p
        else:                     # key is not in tree
            return None

    def insert(self, key):
        v = Node(key)
        if self.size == 0: self.root = v
        else :
            p = self.find_loc(key)
            if p and p.key != key:  # key is a new one
                v.parent = p
                if p.key >= key:  # check if left/right
                    p.left = v
                else :
                    p.right = v
        self.size += 1
        return v

    def deleteByMerging(self, x):
        # assume that x is not None
        a, b, pt = x.left, x.right, x.parent
        # c = node which will be at the position x
        if a == None:
            c = b
        else:  # a != None
            c = m = a
            while m.right: m = m.right  # find m
            # make b as the right child of m
            m.right = b
            if b:
                b.parent = m
        if self.root == x:  # c becomes a new root
            if c: c.parent = None
            self.root = c
        else:  # c becomes a child of pt (of x)
            if pt.left == x:
                pt.left = c
            else:
                pt.right = c
            if c: c.parent = pt
        self.size = self.size - 1

    def deleteByCopying(self, x):
        a,b,p=x.left,x.right,x.parent
        # find y
        y=None
        if a:
            y=a
            while y.right:
                y=y.right
        elif b:
            y=b
            while y.left:
                y=y.left

        if y==None:
            #delete x
            if p:
                if p.left==x:
                    p.left=None
                else:
                    p.right=None
            else:
                self.root=None
        else:
            x.key=y.key
            ya, yb, yp = y.left, y.right, y.parent
            c=ya
            if yb:
                c=yb
            if c: c.parent=yp
            if yp.left==y:
                yp.left=c
            else:
                yp.right=c
        self.size-=1



T = Tree()

while True:
    cmd = input().split()
    if cmd[0] == 'insert':
        v = T.insert(int(cmd[1]))
        print("+ {0} is inserted".format(v.key))
    elif cmd[0] == 'deleteC':
        v = T.search(int(cmd[1]))
        T.deleteByCopying(v)
        print("- {0} is deleted by copying".format(int(cmd[1])))
    elif cmd[0] == 'deleteM':
        v = T.search(int(cmd[1]))
        T.deleteByMerging(v)
        print("- {0} is deleted by merging".format(int(cmd[1])))
    elif cmd[0] == 'search':
        v = T.search(int(cmd[1]))
        if v == None:
            print("* {0} is not found!".format(cmd[1]))
        else:
            print(" * {0} is found!".format(cmd[1]))
    elif cmd[0] == 'preorder':
        T.preorder(T.root)
        print()
    elif cmd[0] == 'postorder':
        T.postorder(T.root)
        print()
    elif cmd[0] == 'inorder':
        T.inorder(T.root)
        print()
    elif cmd[0] == 'exit':
        break
    else:
        print("* not allowed command. enter a proper command!")