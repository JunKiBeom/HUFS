from tkinter import Tk, Label, Button, Entry, StringVar
from functools import partial

class Stack:
    def __init__(self):
        self.items = []
    
    def push(self, val):
        self.items.append(val)
    
    def pop(self):
        try:
            return self.items.pop()
        except IndexError:
            print("Stack is empty")

def top(self):
    try:
        return self.items[-1]
        except IndexError:
            print("Stack is empty")
                
                def __len__(self):
                    return len(self.items)

def isEmpty(self):
    return self.__len__() == 0

'''
    Infix to postfix
    '''

def infix_to_postfix(infix):
    
    opstack = Stack()
    outstack = []
    token_list = infix.split(' ')
    
    # 연산자의 우선순위 설정
    prec = {}
    prec['('] = 0
    prec['+'] = 1
    prec['-'] = 1
    prec['*'] = 2
    prec['/'] = 2
    prec['^'] = 3
    
    for token in token_list:
        if token == '(':    #(
            opstack.push(token)# ...?
        elif token == ')':    #)
            top = opstack.pop()
            while top != '(':
                outstack.append(top)
                top = opstack.pop()# ...?
        elif token in '+-/*^':    #연산자
            if not opstack.isEmpty():    #공백이 아닐때
                temp = opstack.top()    #가장 위에 있는거 temp에 넣음
                
                while not opstack.isEmpty() and prec[temp] >= prec[token]:    #비어있지 않을때까지 아닐때까지 비교
                    outstack.append(opstack.pop())    #맞다면 pop
                    if not opstack.isEmpty():    #비어있지 않다면
                        temp = opstack.top()    #가장 위에 있는거 다시 넣음

    opstack.push(token)    #조건에 안맞으면 바로 넣음
        else: # operand일 때
            outstack.append(token)# ...?

# opstack 에 남은 모든 연산자를 pop 후 outstack에 append
# ... ... ...
while not opstack.isEmpty():
    outstack.append(opstack.pop())
    
    return " ".join(outstack)

'''
    infix_expr = input()
    postfix_expr = infix_to_postfix(infix_expr)
    print(postfix_expr)
    '''

# 1 + ( 2 + 3 ) / 4
# 1 2 3 + 4 / +

'''
    postfix calc
    '''

def Math(op, op1, op2):
    op1, op2 = float(op1), float(op2)
    if op == "*":
        return op1 * op2
    elif op == "/":
        return op1 / op2
    elif op == "+":
        return op1 + op2
    elif op == "-":
        return op1 - op2
    elif op == "^":
        return op1 ** op2

def compute_postfix(postfix):
    opStack = Stack()
    tokenList = postfix.split()
    
    for token in tokenList:
        if not token in "+-*/^":
            opStack.push(token)
        else:
            if not opStack.isEmpty():
                operand2 = opStack.pop()
                operand1 = opStack.pop()
                result = Math(token, operand1, operand2)
                opStack.push(result)
    return opStack.pop()


def do_something():
    value = compute_postfix(infix_to_postfix(expr.get()))
    total.set("{0:.4f}".format(value))
    return

root = Tk()
root.title("My Calculator")
expr = StringVar()
title_label = Label(root, text="My Calcualtor").grid(row=0, columnspan=2)
input_exam = Label(root, text="Space between terms: ( 3 + 2 ) * 8").grid(row=1, columnspan=2)
exp_entry = Entry(root, textvariable=expr).grid(row=2, column=0)
total_label = Label(root, text="TOTAL").grid(row=3, column=0)
total = StringVar()
total.set('0')
value_label = Label(root, textvariable=total, width=20).grid(row=3, column=1)
equal_btn = Button(root, text=' = ', width=20, command=do_something).grid(row=2, column=1)
root.mainloop()
root.destroy()
