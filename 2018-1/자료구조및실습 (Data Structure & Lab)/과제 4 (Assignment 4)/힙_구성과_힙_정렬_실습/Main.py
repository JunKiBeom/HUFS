class Heap:
    def __init__(self, L=[]):
        self.A = L

    def __str__(self):
        return str(self.A)

    def heapify_down(self, k, n):
            # n = 힙의 전체 노드수 [heap_sort를 위해 필요함]
            # A[k]가 힙 성질을 위배한다면, 밑으로 내려가면서 힙성질을 만족하는 위치를 찾는다
        while 2*k+1 < n:    # 왼쪽 자식노드가 없을 때까지 반복 / 리프노드 여부 확인
            L, R = 2*k+1, 2*k+2    # L = 왼쪽 자식 노드, R = 오른쪽 자식 노드
            if self.A[L] > self.A[k]:
                m = L
            else:
                m = k
            if R<n and self.A[R]>self.A[m]:
                m = R
            # m = A[k], A[L], A[R] 중 최대값의 인덱스

            if m != k:    # A[k]가 최대값이 아니라면 힙 성질 위배
                self.A[k], self.A[m] = self.A[m], self.A[k]
                k = m
            else:
                break

    def make_heap(self):
        n = len(self.A)
        for k in range(n - 1, -1, -1):    # A[n-1] ~ A[0] / range(n//2, -1, -1)로 변경해도 문제 없음
            self.heapify_down(k, n)

    def heap_sort(self):
        n = len(self.A)
        for k in range(len(self.A) - 1, -1, -1):
            # i = n-1, n-2, ,,,,,,,,,,,, 3,2,1,0
            self.A[0], self.A[k] = self.A[k], self.A[0]
            n = n - 1    # A[n-1[은 정렬되었으므로
            self.heapify_down(0, n)

S = [int(x) for x in input().split()]
H = Heap(S)
H.make_heap()
H.heap_sort()
print(H)
