import re

fname = input()
m = int(input())
freq={}    # empty dict 생성
#with open("/Users/junkibeom/Desktop/test.txt" , 'r', encoding='utf-8') as f: #+ fname 확인용
with open("data/" + fname, 'r', encoding='utf-8') as f:
    L = re.split('\W+', f.read())  # L은 단어들로 구성된 리스트

for word in L:    # L의 길이 만큼 반복 (단어 모두 확인)
    cnt = freq.get(word, 0)    # cnt는 단어 빈도 / freq에 단어가 있는지 확인하며 cnt에 value return, 단어가 없는 경우에 value = 0 return
    freq[word] = cnt + 1    # freq의 단어(key)를 읽어 카운트 해주며 freq에 추가

freq_list = list(freq.keys())   # 단어(key)들만 list Type으로 남김
words=[]    # 정렬에 활용할 빈 리스트

for i in freq_list:    # 반복문 돌며 단어를 넣음
    if freq[i]>=m:    # 단어의 key값(value:카운트)이 사용자가 입력한 값보다 큰지 확인
        words.append(i)    # 리스트에 추가
words.sort()    # 리스트 정렬
words=" ".join(words)    # 출력 형식을 맞춰주기 위해 문자열로 변환 후 단어 구분을 위해 단어마다 공백을 줌
print(words)
