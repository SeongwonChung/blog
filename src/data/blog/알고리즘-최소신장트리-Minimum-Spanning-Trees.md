---
title: "[알고리즘] 최소신장트리 (Minimum Spanning Trees)"
pubDatetime: 2021-01-30T06:48:52.245Z
description: 최소신장트리(Minimum Spanning Tree)는 특정 그래프의 신장트리 중에 가장 최소의 weight을 가지는 신장트리를 뜻한다.여기서 신장트리(Spanning Tree)는 그래프가 있을 때 모든 노드를 포함하면서 사이클이 존재하지 않는 최소 연결 부분 그래프를
tags:
  - kruskal
  - prim
  - 알고리즘
  - 파이썬
category: 알고리즘
series: 알고리즘 기초
draft: false
---

## 최소신장트리란?
`최소신장트리(Minimum Spanning Tree)`는 **특정 그래프의 신장트리 중에 가장 최소의 weight을 가지는 신장트리**를 뜻한다.

여기서 `신장트리(Spanning Tree)`는 **그래프가 있을 때 모든 노드를 포함하면서 사이클이 존재하지 않는 최소 연결 부분 그래프**를 의미한다. 

예를 들어, 마을의 모든 집을 그래프의 노드로 표현하고, 길을 간선으로 표현할 때, 모든 집을 이어주는 부분그래프가 신장트리가 되고, 여러개의 신장트리 중 가장 최소 비용을 갖는 신장트리를 `최소신장트리`라고 한다.

`신장트리`는 트리 형태이므로 사이클을 포함해서는 안되고, 모든 노드가 연결되어있어야 한다. 또, 노드가 `V`개일때 `|V|-1`개의 간선을 가진다. 

`최소신장트리`를 만드는 알고리즘은 대표적으로 두가지가 있는데, 두 알고리즘 모두 그리디 알고리즘으로, 탐욕적 방법으로 최적해를 찾아내는 것을 보장한다.
두 알고리즘은 `크루스칼(Kruskal)`, `프림(Prim)`알고리즘이다.

```
Generic-MT(G, w)
1 A = ∅
2 while A does not form a spanning tree
3 	find an edge(u,v) that is safe for A
4 	A = A ⋃ {(u,v)}
5 return A
```
위의 pseudo code는 최소신장트리, MST를 만드는 과정을 나타낸다. 여기서 `safe`라는 표현은 `set A`에 edge를 포함시켜도 `set A`가 여전히 MST의 subset임을 나타낸다. 즉, MST에 해당 edge를 포함시켜도 된다는 뜻이다. `kruskal`과 `prim`은 이 safe edge를 판별하는 과정에서 차이를 보인다. 
***
## Kruskal algorithm
크루스칼 알고리즘은 `set A`를 forest, 즉 독립적인 트리의 집합으로 본다. 각 노드를 single node tree로 보고, 이 forest안에서 두개의 트리를 연결하는 edge 중에 least-weight edge를 찾아서 연결한다. 

이 때, tree들을 연결하는 과정에서 `서로소 집합(disjoint set)`자료구조의 union, find연산을 사용한다. 
📌 [서로소 집합이란?](https://velog.io/@syc1013/알고리즘서로소-집합Disjoint-Sets)

알고리즘의 과정은 다음과 같다.
>
1. 간선 데이터를 비용에 따라 오름차순 정렬
2. 간선을 하나씩 확인하며 현재의 간선이 사이클을 발생시키는지 확인한다.
    i. 사이클이 발생하지 않는 경우, 최소신장트리에 포함
    ii. 사이클이 발생할 경우, 최소신장트리에 포함 x
3. 모든 간선에 대해 2. 반복

### code
```python
"""
**kruskal**

Greedy algorithm!
모든 edge weight에 따라 정렬한뒤, 가장 거리가 짧은 것 부터 집합에 포함한다. 단, 사이클이 발생할 경우 제외한다.

parent list에 각 노드의 root node 정보를 저장.
이를 통해 union, find 연산 구성
이를 사용해 아래 과정 수행
"""

# 특정 원소가 속한 집합 찾기
def find_parent(parent, x):
    # 루트노드가 아니면, 루트 노드를 찾을 때 까지 재귀적으로 호출
    if parent[x] != x:
        parent[x] = find_parent(parent, parent[x])
    return parent[x]


# 두 원소가 속한 집합을 합치기
def union_parent(parent, a, b):
    a = find_parent(parent, a)
    b = find_parent(parent, b)
    if a < b:
        parent[b] = a
    else:
        parent[a] = b


# 노드의 개수와 간선(union 연산) 개수 입력받기
v, e = map(int, input().split())
parent = [0] * (v + 1)

# 모든 간선을 담을 리스트와 최종비용 담을 변수
edges = []
result = 0

# 부모테이블에서 부모를 자기자신으로 초기화
for i in range(1, v + 1):
    parent[i] = i


# 모든 간선정보 입력받기
for _ in range(e):
    a, b, cost = map(int, input().split())
    edges.append((cost, a, b))

## KRUSKAL
# 간선을 비용순으로 정렬
edges.sort()

# 간선 하나씩 확인하며
for edge in edges:
    cost, a, b = edge
    # 사이클 아닌경우에만 집합에 포함
    if find_parent(parent, a) != find_parent(parent, b):
        union_parent(parent, a, b)
        result += cost
print(result)

"""
시간복잡도: O(ElogE)
간선 정렬에 ElogE만큼 걸린다. union/find는 그보다 적은 시간이므로 무시.
"""
```
위의 코드는 `disjoint set`의 union, find 연산을 통해 각 노드로 구성된 트리의 연결과 사이클 여부를 표현한다. 그리고, MST의 총 weight의 합을 출력한다.

**시간복잡도**
시간복잡도는 `E`개의 간선을 정렬하는데에 `O(ElogE)`의 시간이 걸리고, union, find는 이보다 적은 시간이 소요되므로 `O(ElogE)`라고 할 수 있다.
***
## Prim algorithm
프림 알고리즘은 `set A`가 single tree을 형성한다. 노드 각각을 독립적인 트리로 보지 않고, 하나의 tree를 구성하고 이를 확장시키면서 MST를 구성하는 알고리즘이다. 

따라서 프림 알고리즘에서 `set A`에 추가되는 safe edge는 현재 트리에 포함되지 않은 노드를 트리와 연결하는 least-weight edge이다. 

동작 과정은 다음과 같다.
>
1. 시작 정점을 MST에 추가한다.
2. MST set에 인접한 노드들 중에 최소 비용을 가지는 간선으로 연결된 노드를 선택하여 MST에 추가한다.
3. MST가 `V-1`개의 간선을 가질때까지 반복한다.

이 과정에서 `우선순위 큐`를 사용하면 효율적인 방법으로 구현이 가능하다. 아래는 `우선순위 큐`를 사용한 Prim 알고리즘의 pseudo code 이다.
```
MST-Prim(G, w, r)
1 for each u ∈ G.V
2 	u.key = ∞
3    	u.𝜋 = NIL
4 r.key = 0
5 Q = G.V // graph 구성하는 vertex를 min priority queue에 삽입
6 while Q ≠ 0
7 	u = Extract-Min(Q)
8     	for each v ∈ G.Adj[u]
9     		if v ∈ Q and w(u,v) < v.key
10             		v.𝜋 = u
11                     	v.key = w(u,v)
```
G는 그래프, w는 간선의 weight을 뜻하며, r은 시작 노드를 뜻한다. key는 edge(u,v)의 노드 v로 들어오는 edge weight중 최솟값을 나타내고, 
𝜋는 mst에서 이전 노드를 뜻한다. 

수도코드의 `line 11`에서 key값을 변경하게 되는데, 이는 heap의 `decrease-key`연산과 같다. 이렇게 key값이 변경되면 heap 내부에서 루트노드가 변경되어야 하는데, 파이썬의 `heapdict`라이브러리를 사용하면 이를 적용할 수 있다. 해당 코드는 아래 reference의 [잔재미코딩](https://www.fun-coding.org/Chapter20-prim-live.html) 사이트에 잘 설명되어 있다. 

위와 같이 알고리즘을 구성할 경우, 시간복잡도는 `O(ElogV)`이다.
***
## 📚 Reference
>
* 『이것이 코딩테스트다 with 파이썬』, 나동빈 지음
* 고려대학교 정순영 교수님 알고리즘 강의자료
* [Heee's Development Blog](https://gmlwjd9405.github.io/2018/08/28/algorithm-mst.html) 를 참고하였습니다. (MST)
* [잔재미코딩](https://www.fun-coding.org/Chapter20-prim-live.html) 을 참고하였습니다. (Prim algorithm)

