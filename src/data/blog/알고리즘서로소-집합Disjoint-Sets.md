---
title: "[알고리즘] 서로소 집합(Disjoint Sets)"
pubDatetime: 2021-01-30T03:18:20.263Z
description: 서로소 집합이란 공통 원소가 없는 두 집합을 의미한다. 그리고 이 개념은 서로소 집합 자료구조로 몇몇 그래프 알고리즘에서 중요하게 사용된다. 서로소 집합 자료구조는 union, find 두가지 연산으로 이루어진다.
tags:
  - Union Find
  - 서로소집합
  - 알고리즘
  - 파이썬
category: 알고리즘
series: 알고리즘 기초
draft: false
---

## 서로소 집합이란?
`서로소 집합`이란 공통 원소가 없는 두 집합을 의미한다. 
그리고 이 개념은 서로소 집합 자료구조로 몇몇 그래프 알고리즘에서 중요하게 사용된다. 
`서로소 집합 자료구조`는 `union`, `find` 두가지 연산으로 이루어진다. 

* union: 두개의 원소가 각각 포함되어 있는 집합을 하나로 합친다.
* find: 특정한 원소가 속한 집합이 어떤 집합인지 찾는다.


`서로소 집합`은 트리 자료구조를 통해 집합을 표현하고, 연산을 수행한다.
하나의 트리를 하나의 집합으로 볼 때, `find`연산은 트리의 루트노드를 찾고, 그 루트노드를 통해 특정 집합을 표현한다. 
그리고, `union`연산의 경우 두 원소에 대해 `find`연산을 수행하여 각각의 루트노드를 찾고, 한 쪽의 루트노드를 다른 쪽에 연결함으로써 하나의 트리로 만드는 합집합 연산을 수행한다.

### code 
```python 
"""
disjoint set source code
"""

# 특정 원소가 속한 집합을 찾기(find)
# 이 경우, find 는 O(V)이다.
def find_parent(parent, x):
    # 루트노드 아니면 재귀적으로 호출하여 루트노드를 찾는다.
    if parent[x] != x:
        return find_parent(parent, parent[x])
    return x


# 경로압축 기법 적용한 find 함수
# 재귀적으로 호출한 뒤 부모테이블 갱신
def find_parent_compress(parent, x):
    if parent[x] != x:
        parent[x] = find_parent(parent, parent[x])
    return parent[x]


# 두 원소가 속한 집합 합치기(union)
def union_parent(parent, a, b):
    a = find_parent(parent, a)
    b = find_parent(parent, b)
    if a < b:
        parent[b] = a
    else:
        parent[a] = b


# 노드의 개수와 간선(union 연산)의 개수 입력받기
v, e = map(int, input().split())
parent = [0] * (v + 1)  # 부모 테이블 초기화

# 부모 테이블상에서, 부모를 자기 자신으로 초기화
for i in range(1, v + 1):
    parent[i] = i

# union 연산 각각 수행
for i in range(e):
    a, b = map(int, input().split())
    union_parent(parent, a, b)

# 각 원소가 속한 집합 출력
print("각 원소가 속한 집합: ", end=" ")
for i in range(1, v + 1):
    print(find_parent(parent, i), end=" ")

print()

# 부모 테이블 출력
print("부모 테이블: ", end=" ")
for i in range(1, v + 1):
    print(parent[i], end=" ")


""" 
노드의 개수가 V일때, V-1개의 Union 연산과 M개의 find연산이 가능하다면 
경로압축법을 적용한 시간복잡도는 O(V + M(1 + log_(2-m/v)V))

"""
```

이 때, `find`연산에는 경로압축기법이라는 것이 존재한다. 현재 코드에서 `parent` 리스트를 통해 parent node를 표현하고 있는데, 일반적으로 parent node를 표현하게 될 경우, find연산의 비용이 커지게 된다. 

따라서 루트 노드에 더욱 빠르게 접근할 수 있도록 해당 노드의 루트노드가 바로 parent node가 되도록 수정한다. 이를 적용한 부분이 `find_parent_compress` 함수 부분이다. 이것이 성능이 좋기 때문에 이후 다른 그래프 알고리즘에서 `find` 연산을 사용할 때도 방법을 사용하게 된다.
***
## 서로소 집합을 통한 사이클 판별
`서로소 집합` 자료구조의 연산은 무방향 그래프에서의 사이클 판별에 사용될 수 있다. 

그 과정은 다음과 같다.
>
1. 각 간선을 확인하며 두 노드의 루트노드 확인
	i. 루트 노드가 서로 다르면 `union`연산 수행
    ii. 루트 노드가 같으면, **사이클(Cycle)**발생
2. 그래프의 모든 간선에 대해 _1. _반복

### code
```python
v, e = map(int, input().split())
parent = [0] * (v + 1)

for i in range(1, v + 1):
    parent[i] = i

cycle = False

for i in range(e):
    a, b = map(int, input().split())

    # 사이클 발생시 종료
    if find_parent(parent, a) == find_parent(parent, b):
        cycle = True
        break
    else:
        union_parent(parent, a, b)

if cycle:
    print("cycle exists")
else:
    print("no cycle")
```
위에서 정의한 `union_parent`, `find_parent` 함수를 사용하여 사이클 여부를 판별한다.
***
`서로소 집합 자료구조`는 위에서 말했듯이 다른 그래프 알고리즘에서 사용되는데, 대표적으로 최소신장트리를 만드는 알고리즘인 `크루스칼(Kruskal)`알고리즘에서 활용된다. 최소신장트리 알고리즘에 대해서는 따로 정리하도록 하겠다. 
***
## 📚 Reference
>
* 『이것이 코딩테스트다 with 파이썬』, 나동빈 지음