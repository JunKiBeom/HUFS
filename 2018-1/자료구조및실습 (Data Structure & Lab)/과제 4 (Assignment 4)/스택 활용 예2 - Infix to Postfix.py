'''
    Infix to postfix
    '''


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


infix_expr = input()
postfix_expr = infix_to_postfix(infix_expr)
print(postfix_expr)

# 1 + ( 2 + 3 ) / 4
# 1 2 3 + 4 / +
