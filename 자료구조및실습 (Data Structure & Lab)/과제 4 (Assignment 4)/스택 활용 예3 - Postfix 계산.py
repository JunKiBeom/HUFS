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

usr=input()
print("%.4f"%(compute_postfix(usr)))
