---
title: "[알고리즘] 위상정렬(Topology Sort)"
pubDatetime: 2021-01-29T07:09:30.669Z
description: 위상정렬(Topology Sort)이란
tags:
  - 알고리즘
  - 위상정렬
  - 파이썬
category: 알고리즘
series: 알고리즘 기초
draft: false
---

## 위상정렬이란?
`위상정렬(Topology Sort)`이란 정렬 알고리즘의 일종으로, **방향 그래프의 모든 노드를 방향성에 거스르지 않도록 순서대로 나열하는 것이다.**

위상정렬이 수행되는 대표적인 상황은 _선수과목을 고려한 학습 순서_ 가 있다. 위상 정렬을 통해 정렬된 결과는 그래프에 (u,v)의 edge가 있다면 u가 무조건 v보다 먼저 나오게 된다. 따라서 그래프 상의 선후관계를 유지하면서 전체 순서를 정렬할 수 있다.

위상정렬은 각 노드의 `진입차수(indegree)`를 기준으로 하게 되는데, `진입차수`란 각 노드로 들어오는 간선의 개수를 뜻한다. 방향성이 있는 그래프에서 자신을 가리키고 있는 간선의 개수가 indegree가 된다.

`위상정렬`은 각 노드의 `진입차수`와 `큐`자료구조를 활용하여 다음과 같은 과정을 거친다.
>
1. `진입차수`가 0인 노드를 큐에 넣는다.
2. `큐`가 빌때까지 아래를 반복
    i. `큐`에서 원소를 꺼내고, 해당 노드와 해당 노드에서 출발하는 간선을 그래프에서 제거한다.(해당 노드에서 출발하는 간선이 도착하는 노드의 `진입차수`를 감소시킨다.)
    ii. 새롭게 `진입차수`가 0이 된 노드를 큐에 넣는다.

위 과정을 거치면서 큐에서 빠져나온 노드 순서대로 정렬하면 위상정렬의 결과가 된다.

위상 정렬의 특징은, 
한 단계에서 큐에 삽입되는 노드가 여러개일 경우, 답이 여러 개일 수 있다. 
또, 방향성이 있고 cycle이 없는 그래프의 경우에만 위상정렬이 가능하다. 그래프에 cycle이 있을 경우, cycle에 포함되는 노드는 큐에 삽입될 수 없기 때문이다. 
***
### 소스코드
```python
from collections import deque

v, e = map(int, input().split())
# 진입차수 0으로 초기화
indegree = [0] * (v + 1)
# 각 노드에 연결된 간선정보를 담기위한 linked list 초기화
graph = [[] for i in range(v + 1)]

# 방향 그래프의 모든 간선정보를 입력받기
for _ in range(e):
    a, b = map(int, input().split())
    graph[a].append(b)
    # a -> b
    indegree[b] += 1

# 위상정렬
def topology_sort():
    result = []
    q = deque()

    # 처음 시작시 진입차수가 0인 노드 삽입
    for i in range(1, v + 1):
        if indegree[i] == 0:
            q.append(i)

    while q:
        now = q.popleft()
        # 큐에서 꺼낸 노드 결과에 기록
        result.append(now)
        # 해당 원소와 연결된 노드들의 진입차수에서 1 빼기
        for i in graph[now]:
            indegree[i] -= 1

            # 새롭게 진입차수가 0인 노드 큐에 삽입
            if indegree[i] == 0:
                q.append(i)

    # 결과 출력
    for i in result:
        print(i, end=" ")


topology_sort()

```
소스코드는 _『이것이 코딩테스트다 with 파이썬』_을 참조하였다. 
큐 자료구조 사용을 위해 `deque`모듈을 활용하며, `indegree` 배열을 선언하여 진입차수를 기준으로 큐에 노드를 삽입/삭제 한다.

**시간복잡도**
시간 복잡도는 `O(V+E)`에 해당한다. 
차례대로 모든 노드를 확인하면서 해당 노드에서 출발하는 간선을 차례대로 제거해야 한다. 따라서 모든 노드와 간선을 확인하므로 `O(V+E)`이다.
## 📚 Reference
>
* 『이것이 코딩테스트다 with 파이썬』, 나동빈 지음
* [Heee's Development Blog](https://gmlwjd9405.github.io/2018/08/27/algorithm-topological-sort.html)의 포스트를 참고하였습니다.