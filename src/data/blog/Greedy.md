---
title: "[알고리즘] Greedy 알고리즘"
pubDatetime: 2021-01-08T11:30:47.396Z
description: 그리디 알고리즘에 대해 알아보자
tags:
  - greedy
  - 알고리즘
  - 파이썬
category: 알고리즘
series: 알고리즘 기초
draft: false
---

## Greedy Algorithm
그리디 알고리즘은 '탐욕법'으로 번역된다. 그리디 알고리즘은 항상 locally optimal choice를 선택한다. 즉, **현재 상황에서 가장 좋아보이는 선택을 반복함**으로써 optimal solution을 찾는 알고리즘이다.

하지만 모든 문제에 Greedy algorithm을 적용해서 최적의 답을 구할 수 있는 것은 아니다. 문제에서 `두가지 조건`이 성립할 때, 그리디 알고리즘을 통해 최적해를 구할 수 있다.
***
### 조건
>
**greedy-choice property **: 앞의 선택이 이후의 선택에 영향을 주지 않는다
>
**optimal substructure **: 문제에 대한 최적해가 부분문제에 대해서도 역시 최적해이다. 

따라서 두 조건이 만족하는 경우, 그리디 알고리즘을 통한 문제해결 전략은 다음과 같은 형태로 나타난다.
>
1. 문제의 `optimal substructure`를 결정한다. 즉, 문제에 대한 optimal solution이 전체 문제의 부분문제에도 optimal solution으로 적용되어야 한다.
2. 재귀적인 해법을 찾는다.
3. 모든 재귀 단계에서 greedy choice가 최적의 choice에 포함됨을 증명한다. = 항상 greedy choice 가 옳다는 것 증명
4. greedy choice 이후에 하나의 subproblem만 남는 것을 보인다.
5. recursive 한 greedy algorithm을 구성한다.
6. recursive algorithm 을 iterative algorithm으로 변환한다. 

따라서 greedy algorithm은 `greedy choice` + `나머지 subproblem` 의 형태가 되고, 이 greedy choice를 선택하는 것을 재귀적으로 반복함으로써 최적의 해를 찾는다.

하지만 이렇게 이론만 봐서는 개념이 잘 와닿지 않고, 코딩테스트 같은 환경에서 항상 문제를 위와 같은 과정으로 풀기는 쉽지 않다. 따라서 코딩테스트를 위한 공부라면 예시를 통해 간단하게 이해하고, 문제를 많이 풀어보면서 감을 익히는 것이 좋을 것 같다. 
***
### 예시
아래는 _『이것이 코딩테스트다 with 파이썬』_의 예제 3-1이다.
>
당신은 음식점의 계산을 도와주는 점원이다. 카운터에는 거스름돈으로 사용할 500원, 100원, 50원, 10원짜리 동전이 무한히 존재한다고 가정한다. 손님에게 거슬러 줘야 할 돈이 N원일 때 거슬러줘야할 동전의 최소 개수를 구하라. 단, 거슬러 줘야 할 돈 N은 항상 10의 배수이다. 

이 문제는 대표적인 greedy 알고리즘을 통해 풀 수 있는 문제이다. 이 문제에서의 greedy choice는 `가장 큰 값의 동전부터 거슬러 주는 것`이다.

위에서 언급한 내용에 따라 문제를 분석해보면, greedy choice인 `가장 큰 값의 동전부터 거슬러 주는 것`이 최적해이고, `나머지 금액을 거슬러 준다`는 subproblem에서도 greedy choice가 최적해로 성립하므로 `optimal substructure`의 조건을 만족한다고 이해할 수 있다.

간단하게 생각해보면, 주어진 화폐단위가 큰 단위는 항상 작은 단위의 배수이므로 작은 단위의 동전으로 큰 단위를 사용할 때 보다 최적의 해를 찾을 수 없다. 따라서 greedy algorithm을 사용할 수 있는 것이다. 
***

### 정리

**그리디 알고리즘**은 
👉 매 순간 최적의 `greedy choice`를 하고, 
👉 나머지 `subproblem`에서 `greedy choice`를 반복하면서 전체 문제를 해결하는 
👉 `top-down`방식의 문제 접근 방법이다. 

모든 문제에 그리디 알고리즘을 적용할 수는 없지만, 조건이 맞다면 직관적이고 간단하게 문제를 해결할 수 있다.
### 📚Reference
>
* wikipedia greedy 알고리즘: https://ko.wikipedia.org/wiki/%ED%83%90%EC%9A%95_%EC%95%8C%EA%B3%A0%EB%A6%AC%EC%A6%98
* 고려대학교 정순영 교수님 알고리즘 강의자료(2019-2학기)
* 『이것이 코딩테스트다 with 파이썬』, 나동빈 지음

