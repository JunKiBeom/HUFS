# DO NOT EDIT THIS CELL
data_str = 'apple,beer,rice,chicken\n'
data_str += 'apple,beer,rice\n'
data_str += 'apple,beer\n'
data_str += 'apple,mango\n'
data_str += 'milk,beer,rice,chicken\n'
data_str += 'milk,beer,rice\n'
data_str += 'milk,beer\n'
data_str += 'milk,mango'

# YOUR CODE MUST BE HERE

def gen_record(s):
    an = ', '.join(s.split(",")).split("\n")
    for i in range(len(an)):
        yield an[i].split(', ')

# DO NOT EDIT THIS CELL
test = gen_record(data_str)
next(test)

# DO NOT EDIT THIS CELL
next(test)

# YOUR CODE MUST BE HERE

def gen_frequent_1_itemset(dataset, min_sup=0.5):
    word_cnt={}
    for i in range(len(dataset)):
        for word in dataset[i]:
            try:
                word_cnt[word]+=1
            except KeyError:
                word_cnt[word]=1
    for key,cnt in word_cnt.items():
        if cnt>=len(data_str.split("\n"))*min_sup:
            yield key

# DO NOT EDIT THIS CELL
dataset = list(gen_record(data_str))
for item in gen_frequent_1_itemset(dataset, 0.5):
    print(item)
print('No more items')

# DO NOT EDIT THIS CELL
dataset = list(gen_record(data_str))
for item in gen_frequent_1_itemset(dataset, 0.7):
    print(item)
print('No more items')

# DO NOT EDIT THIS CELL
dataset = list(gen_record(data_str))
for item in gen_frequent_1_itemset(dataset, 0.2):
    print(item)
print('No more items')

# YOUR CODE MUST BE HERE

def gen_frequent_2_itemset(dataset, min_sup=0.5):
    d=set()
    data_set=[]
    for i in range(len(dataset)):
        a=dataset[i]
        for j in range(len(a)):
            d.add(a[j])
    d=list(d)
    for x in range(len(d)):
        for y in range(x+1,len(d)):
            data_set.append((d[x],d[y]))
    set_cnt = {}
    for _ in range(len(dataset)):
        for a in range(len(data_set)):
            cnt = 0
            if data_set[a][0] in dataset[_]:
                cnt+=1
            if data_set[a][1] in dataset[_]:
                cnt+=1
            if cnt==2:
                try:
                    set_cnt[data_set[a]] += 1
                except KeyError:
                    set_cnt[data_set[a]] = 1
    for key, cnt in set_cnt.items():
        if cnt >= len(data_str.split("\n")) * min_sup:
            yield key

# DO NOT EDIT THIS CELL
data = list(gen_record(data_str))
for item in gen_frequent_2_itemset(data, 0.5):
    print(item)
print('No more items')

# DO NOT EDIT THIS CELL
data = list(gen_record(data_str))
for item in gen_frequent_2_itemset(data, 0.3):
    print(item)
print('No more items')

# DO NOT EDIT THIS CELL
dataset = list(gen_record(data_str))
for item in gen_frequent_2_itemset(dataset, 0.2):
    print(item)
print('No more items')