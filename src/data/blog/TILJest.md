---
title: "[TIL]Jest "
pubDatetime: 2021-01-01T15:49:26.914Z
description: 2021.01.01 TIL
tags:
  - TIL
  - jest
  - udemy
category: TIL
draft: false
---

오늘은 새해 첫날인 만큼 공부한 내용을 꼭 기록하고 싶었다. 

기존에 Udemy에서 NodeJS 수업을 수강했었는데, 끝까지 수강하지 못하고 남겨둔 부분이 있었다. 그 부분을 마저 듣기 위해 수업을 들었는데, 내용은 ExpressJS의 test를 위한 testing framwork **Jest**에 대한 내용이다. 

아래는 수업을 들으면서 간략하게 정리한 내용이고, 자세한 부분이나 궁금한 점은 따로 정리해야 할것 같다...!
***
## Testing Framework
NodeJS 를 위한 Test Framework - Jest, Mocha 를 많이 사용한다. 

Jest = zero configuration test Framework.

1. npm i jest --save-dev
2. script에 "test":"jest"추가
3. test script 작성
    * test() function 작성.
    * function에서 error발생하면 해당 testcase가 failure.
    * test 과정에서 error발생하면 throw new Error해서 test할 수 있다.

> Why test?
    - saves time
    - creates reliable software
    - gives flexibility to developers
        - refactorying
        - collaborating
        - profiling
    - peace of mind

```javascript
const { calculateTip } = require("../src/math")

test("Should calculate total with tip", () => {
    const total = calculateTip(10, .3)

    if (total !== 13) {
        throw new Error(`Total tip should be 13. Got ${total}`)
    }
})
```
Jest에는 Assert 를 위한 library가 있다. --> expect()
- `expect(value).toBe(target)`
value가 target과 다르면 error! value는 test하려는 function의 결과값

testing 통해서 refactoring으로 코드 수정시 기능이 그대로 유지되었는지 검사할 수 있다. 

## Testing Asynchronous code

jest --watch: testcode 변경시 자동으로 test 재실행

asynchronous code의 경우 그냥 test()에서 인식하지 못한다. 따라서 extra code통해 async임을 알려줘야한다. callback에 parameter전달한다. 
```javascript
test("Async test demo", (done) => {
    setTimeout(()=>{
        expect(1).toBe(2)   
        done() // test code 종료 알려준다.      
    }, 2000)
})
```
**async/await 을 사용한 syntax의 경우 done을 callback parameter로 전달하지 않아도 된다. await을 jest가 기다림**
```javascript
test('Should add two numbers async/await', async() => {
    const sum = await add(10, 22)
    expect(sum).toBe(32)
})
```

## Library for testing Express server: Supertest
- 서버가 실행중이 아니어도 Express만으로 test할 수 있다. (listen 없이 `app`만 가져와서 test)
https://www.npmjs.com/package/supertest

## beforeEach / afterEach
각각 test() function 실행 전후로 실행됨. 이번 예시에서는 db test시에 test db 비워줄 때 사용함

beforeEach 에서 user 지우고, 테스트용 유저 생성함. 
auth 위해서 token 생성도 함.
```javascript
test('Should get profile for user', async () => {
    await request(app)
    .get('/users/me')
    .set('Authorization', `Bearer ${userOne.tokens[0].token}`) // set Auth header
    .send()
    .expect(200)
})
```
## Mocking
jest를 사용해 test run할 때는 필요없는 기능은 실행 되지 않도록. 
>
tests
------|\__mocks__

ex) npm module인 @sendgrid/mail 을 사용하는데 이것을 mock 하려면
mocks dir 하위에 @sendgrid directory 생성, mail.js 생성.
mail.js에서 testcase에서 실행될 때 사용되는 function을 test 에서 사용할 기능으로 설정. (빈칸으로 두면 pass)

object 간에 비교할 때 toBe 사용 x ==> {} !== {} 
toEqual 사용.


## Task test suite
- user test suite에서 선언한 test user에 접근 필요. 
- db.js에서 beforeEach에서 하던 처리 하도록 한다. 
- jest -- runInBand
    series 로 test suite 순서대로 실행되게 함. DB 사용하는 test과정에서 꼬이지 않게 해준다. 

## ? 궁금한점
What's `Bearer token`?
>
https://gist.github.com/egoing/cac3d6c8481062a7e7de327d3709505f
위 링크에서 `Bearer token`에 대한 설명을 볼 수 있었다!
