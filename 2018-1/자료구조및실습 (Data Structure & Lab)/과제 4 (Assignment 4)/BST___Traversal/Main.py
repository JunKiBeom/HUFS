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


T = Tree()

while True:
    cmd = input().split()
    if cmd[0] == 'insert':
        v = T.insert(int(cmd[1]))
        print("+ {0} is set into H".format(v.key))
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