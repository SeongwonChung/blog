---
title: "Promise...?"
pubDatetime: 2020-12-23T08:16:33.641Z
description: "javascript 의 Promise에 대해 알아보자!"
tags:
  - JavaScript
  - TIL
  - promise
category: TIL
ogImage: "https://images.velog.io/images/syc1013/post/a5191caf-966a-4c91-b749-d21e22c5de73/midnightnavy.png"
draft: false
---

# Promise 
javascript에는 promise 라는 개념이 있다. promise가 어떤 개념인지 정리해보았다. 
## 정의
`Promise`는 javascript object로, 비동기 작업에서의 완료/실패, 그리고 결과 값을 나타낸다. 프로미스를 사용하면 비동기 메서드에서 마치 동기 메서드 처럼 값을 반환할 수 있다. 즉, 비동기 처리를 용이하게 하기 위해 `Promise`를 사용한다. 

---

## Promise의 상태
`Promise`는 3가지 상태를 가진다. 
* 대기(pending): 이행하거나 거부되지 않은 초기 상태. 비동기처리가 진행중인 상태
* 이행(fulfilled): 비동기 연산이 성공적으로 완료된 상태
* 거부(rejected): 비동기 연산이 실패한 상태

`Promise`는 pending 이후에 비동기처리의 상태에 따라 fulfilled/ rejected 상태가 되는 것이다. 

이러한 상태는 `Promise`의 method인 `Promise.resolve` 와 `Promise.reject`	로 결정된다. 
연산이 성공적으로 처리된 경우, `resolve`를 통해 결과를 반환하고, 그렇지 않은 경우 `reject`를 통해 결과를 반환한다. 

아래의 기본 예제를 통해 자세히 살펴볼수 있다. 

---

## method 사용 예시

```javascript
let myFirstPromise = new Promise((resolve, reject) => {
  // We call resolve(...) when what we were doing asynchronously was successful, and reject(...) when it failed.
  // In this example, we use setTimeout(...) to simulate async code.
  // In reality, you will probably be using something like XHR or an HTML5 API.
  setTimeout(function(){
    resolve("Success!"); // Yay! Everything went well!
  }, 250);
});

myFirstPromise.then((successMessage) => {
  // successMessage is whatever we passed in the resolve(...) function above.
  // It doesn't have to be a string, but if it is only a succeed message, it probably will be.
  console.log("Yay! " + successMessage);
});
```
위 처럼 `Promise`안에서 상태를 fulfilled로 하고, 성공시 값을 반환하고 싶으면 resolve()에 value를 전달해주면 된다. 이후에 해당 Promise object를 호출하고 `then` method를 통해 resolve에 전달한 값을 콜백함수가 다시 받아줄 수 있다. 위 예시 코드의 실행결과는 다음과 같을 것이다. 
``` bash
Yay! Success!
```
`Promise`에서 비동기 처리가 성공했을때는 `resolve`를 통해 반환 값을 전달하고, Promise를 호출할때 `then` 메서드에서 콜백함수로 반환 값을 받는다. 비동기 처리가 실패했을 때는, `reject`를 통해 값을 전달하고, `catch`로 그 값을 받아준다. 

```javascript
const doWorkPromise = new Promise((resolve, reject) => {
	setTimeout(() => {
    	resolve([7,4,1])
      	reject('Things went wrong!') // 이 부분은 실행되지 않는다. 
    }, 2000)
})

doWorkPromise.then((result) => {
	console.log('Success!', result)
}).catch((error) => {
	console.log('Error!', error)
})
```
위의 예시처럼, Promise 객체의 비동기 처리 결과를 then 과 catch 메서드를 통해 성공한 결과를 받아서 사용하거나, 실패한 결과 (error) 를 받아 사용할 수 있다. 여기서 중요한 점은 Promise에서 resolve가 실행되었기 때문에 reject가 실행되지 않을 것이라는 점이다. 따라서 위 코드의 Promise는 fulfilled될 것이고 실행결과는 다음과 같다. 
```bash
Success! [7,4,1]
```
---

## 실제사용

그렇다면 `Promise`는 실제로 어떻게 사용될까? 실제로 개발 단계에서는 `Promise`객체는 library에서 구현되어 있고, 우리는 그것을 가져와서 사용하는 경우가 많다. 웹에서 비동기 통신을 도와주는 **axios** 라이브러리가 그 예이다. 
```javascript
axios.post('/url', {전달할 data...})
	.then(response => console.log(response))
	.catch(response => console.error(error))
```
위와 같은 코드로 axios에서 제공하는 Promise object에 method를 사용해 쉽게 비동기 통신을 구현할 수 있다. 

---

## 📚 Reference
>
- MDN: 	https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Global_Objects/Promise
- Udemy The Complete Node.js Developer Course: 
https://www.udemy.com/course/the-complete-nodejs-developer-course-2/learn/lecture/13729160#overview

*상기 내용은 공부하면서 정리한 내용으로, 부정확한 정보가 있을 수 있습니다*