---
title: NodeJS로 Chat-app 만들기
pubDatetime: 2021-01-07T08:30:47.836Z
description: udemy 에서 수강하던 nodeJS 강의의 마지막 부분인 Socket.io를 사용하여 chat-app 만들기 section을 수강하면서 배운 내용을 정리한 포스트입니다.
tags:
  - heroku
  - nodejs
  - socket.io
  - udemy
category: 프로젝트
ogImage: "https://images.velog.io/images/syc1013/post/82231def-b1a3-4807-b893-6570243fe14f/Screen Shot 2021-01-07 at 16.28.25 PM.png"
draft: false
---

udemy 에서 수강하던 nodeJS 강의의 마지막 부분인 `Socket.io`를 사용하여 chat-app 만들기 section을 수강하면서 배운 내용을 정리한 포스트입니다.

https://sw-node-chat-app.herokuapp.com/
위 링크에서 결과물을 확인할 수 있습니다.
***
## Express server 구축
우선 Express 를 사용하여 server를 만들어 주어야 하는데, 그 과정은 아래와 같습니다. 
>
1. npm init
2. npm i express --save
3. src directory 만들고, index.js 만들기
4. index.js 작성


```javascript
//index.js
const path = require('path') // to serve public dir, path는 core node module이라 install not required
const express = require('express')
const app = express()

const PORT = process.env.PORT || 3000
const publicDirectoryPath = path.join(__dirname, '../public')

app.use(express.static(publicDirectoryPath))

app.listen(PORT, () => {
    console.log(`server on port ${PORT}!`)
})
```
>5. public 폴더의 html을 serve하기 위해, `path`module 사용하여 `publicDirectoryPath` 설정해주고, `app.use(express.static(publicDirectoryPath))` 설정.

평소에는 ReactJS와 같은 프론트엔드 프레임워크를 사용해서 `public`폴더를 통해 static file을 serve하는 방법을 잘 몰랐는데, `5.`와 같은 과정으로 설정해줄 수 있다는 것을 배웠다. 	
***
## Websocket ?
**websocket protocol**
websocket protocol은 무엇일까? [MDN](https://developer.mozilla.org/en-US/docs/Web/API/WebSockets_API)에서는 다음과 같이 설명한다. 
>The WebSocket API is an advanced technology that makes it possible to open a two-way interactive communication session between the user's browser and a server. With this API, you can send messages to a server and receive event-driven responses without having to poll the server for a reply.

간단히 말하면, `WebSocket`을 통해 client(browser)와 server가 양방향 통신을 할 수 있다. `HTTP`통신 같은 경우, client에서 server로의 일방향 request만 가능하다면, `WebSocket`은 양방향 통신이 가능하며, client 와 server가 수시로 통신이 가능하다. 따라서 이 기술을 통해 실시간 채팅과 같은 기능 구현이 가능하다!
***
## Socket.io
**Socket.io**는 Websocket protocol을 nodeJS에서 사용할 수 있게 해주는 npm library이다. 

### Setting
- server side 
	- index.js 에서 httpserver를 따로 선언해주고, `socketio`를 load해서 parameter에 httpserver를 전달해준다. 
        
```javascript
		const http = require('http')
		const socketio = require('socket.io')

		const server = http.createServer(app)
		const io = socketio(server)

		server.listen(PORT, () => {
    		console.log(`server on port ${PORT}!`)
		})
```
주의할 점은 기존에 express를 통해 background에서 http server를 생성해 주었지만, socketio의 parameter로 전달하기 위해 명시적으로 선언해준다는 점이다. 이에 따라 `app.listen(port,...)`도 `server.listen(port, ...)`로 바뀐다. 
- client side
	- index.html에 script 넣어준다. 강의에서는 html에 socket.io.js를 load함으로써 client에서 socketio를 통한 통신을 한다. 
```html        
<script src="/socket.io/socket.io.js"></script>
<script src="/js/chat.js"></script>
```
   - js/chat.js에는 `io()` 호출해준다. 
	`chat.js`는 client side에서 socketio를 사용한 통신을 하기 위한 코드를 작성할 파일이다.

### Usage
```javascript
//index.js
io.on('connection', (socket) => {
})
```
위 코드를 serverside에 입력해 주면, websocket connection을 연결할 수 있다. 그리고 아래의 method들을 통해 통신이 가능하다. 

> 
`socket.emit()`: 하나의 client에 정보 전달
`io.emit()`: 연결된 모든 client에 정보 전달
`socket.broadcast.emit()`: 해당 client 제외 모든 연결된 client에 정보 전달
`socket.on()`: client 나 server에서 상대편에서 보내는 정보를 받아준다. 

위와 같이 간단하게 정리할 수 있고, 보다 정확한 내용과 예시는 [공식문서](https://socket.io/docs/v3)를 참조하는 것이 좋다. 

또, `.on()`을 통해 정보를 받은 후에 정보를 보낸 쪽에 다시 feedback을 줄 수 있는데, 이것을 `acknowledgement`라고 한다. 

```js
socket.on('join', ({username, room}, callback) => {
        const { error, user } = addUser({ id: socket.id, username, room })

        if (error) {
            return callback(error) // acknoledgement. error를 client side로 보냄.
        }
        socket.join(user.room)

        socket.emit('message', generateMessage({text: 'Welcome!', username: 'Admin'}))
        socket.broadcast.to(user.room).emit('message', generateMessage({text: `${user.username} has joined!`, username: 'Admin'}))
        io.to(user.room).emit('roomData', {
            room: user.room,
            users: getUsersInRoom(user.room)
        })
        
        callback() // acknowledgement without error
    })
```
위 코드는 server의 `index.js`에서 새로운 유저를 가입시키고, welcome 메시지와 유저의 접속 소식을 알리는 기능의 코드이다. `acknowledgement`를 위해 callback을 parameter로 전달하고, callback()을 통해 정보를 보낸(emit) client side에 error와 같은 값을 전달할 수 있다. 

**동작 과정**
socketio connection 의 통신과정을 정리하면 다음과 같다.
>
server(emit) => client(receive) ==acknowledgement=> server
client(emit) => server(receive) ==acknowledgement=> client


### Socket room

우리가 사용하는 채팅 서비스는 특정 유저끼리 정보를 주고받을 수 있도록 하는 기능이 있다. 이것을 가능케 하는 것이 `room`이다. `room`은 아래와 같이 사용한다. 

```javascript
    socket.on('join', ({username, room}) => {
        socket.join(room)
    })
```

**`socket.join` 통해서 room에 join. 
to('room') 사용해서 특정 room에 emit.**

`io.to("roomname").emit` => 특정 room의 connection으로만 정보 전달. 
`socket.broadcast.to("roomname").emit` => 특정 room에서 client 자신 제외하고 정보전달

***

## javascript array methods

user를 관리하는 과정에서 javascript의 array형태로 저장하게 되었는데, user를 추가/삭제/탐색 하는 과정에서 아래와 같은 methods를 사용했다. 각자의 차이를 간단히 정리했다. 역시 자세한 내용은 [MDN](https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Global_Objects/Array)이 좋다...! 
>
아래의 세 함수 모두 배열의 각 원소를 parameter로 받는 판별함수(testing function)를 parameter로 받고, testing function의 결과에 따라 값을 return한다. 
>
`.find()`: 메서드는 주어진 판별 함수를 만족하는 첫 번째 요소의 값을 반환합니다. 그런 요소가 없다면 undefined를 반환한다.
`.findIndex()`: 주어진 판별 함수를 만족하는 배열의 첫 번째 요소에 대한 인덱스를 반환합니다. 만족하는 요소가 없으면 -1을 반환합니다.
`.filter()`: 주어진 함수의 테스트를 통과하는 모든 요소를 모아 새로운 배열로 반환한다. 

***

## Automatic Scrolling

이 기능은 채팅창 component에서 최근메시지가 있을때 자동으로 스크롤을 내려주고, 기존의 채팅내용을 사용자가 보고 있을 때는 자동스크롤을 하지 않는 기능이다. 다른 프로젝트에서도 유용하게 사용할 수 있을 것 같아 기록해 두려고 한다.

- user가 most recent content 보고있을때만 아래로 auto scroll
```javascript
const autoscroll = () => {
    // New message element
    const $newMessage = $messages.lastElementChild

    // Height of the new message
    const newMessageStyles = getComputedStyle($newMessage)
    const newMessageMargin = parseInt(newMessageStyles.marginBottom)
    const newMessageHeight = $newMessage.offsetHeight + newMessageMargin

    // visible height
    const visibleHeight = $messages.offsetHeight
    
    // height of messages container
    const containerHeight = $messages.scrollHeight

    // How far have I scrolled?
    const scrollOffset = $messages.scrollTop + visibleHeight

    if(containerHeight - newMessageHeight <= scrollOffset) {
        $messages.scrollTop = $messages.scrollHeight
    } // 위에 볼때는 no autoscroll 
```
`newMessageHeight`에 새로운 message 컴포넌트의 높이를 저장한다.
`visibleHeight`은 사용자가 보는 컴포넌트의 높이이고,
`containerHeight`은 전체 모든 message내용을 담는 container의 높이이다. 
그리고 `scrollOffset`은 스크롤을 통해 가려진 윗부분과 현재 사용자가 보고있는 부분을 합한 부분의 높이로, 전체 사이즈에서 스크롤 된 정도를 나타낸다. 

따라서 `scrollOffset`보다 `containerHeight - newMessageHeight`가 작거나 같을 경우, scroll을 최대한 아래로 내리게 하고, 그렇지 않을 경우, `scrollOffset`이 더 작은 경우는 사용자가 위로 스크롤한 경우이므로 autoscroll을 하지 않는다. 
***
## Heroku Deploy
마지막으로 Heroku 로 배포하는 방법을 잊지않기 위해서 다시 기록한다!

1. install
	`brew install heroku/brew/heroku`
    우선 heroku cli를 설치한다. 나는 mac환경이라 homebrew를 통해 설치했다.
2. project를 git init, commit
	heroku로 app을 배포하기위해 프로젝트를 git으로 관리해야한다.
2. heroku login
	terminal에서 `heroku login`을 통해 login한다.
3. heroku create
	`heroku create app이름` 을 통해 heroku app 을 만든다. 이름은 unique해야 한다.  
4. git push heroku master
	최종커밋 이후에 github에 push하듯이 `git push heroku master` 커맨드를 통해 deploy할 수 있다.
    
오랜만에 Heroku를 사용해봤는데 역시 굉장히 간단한 것 같다.

***
## 📚References
>
* udemy 강의
[udemy - The Complete Node.js Developer Course (3rd Edition)](https://www.udemy.com/course/the-complete-nodejs-developer-course-2/)
* Socket.io 공식문서
https://socket.io/docs/v3
* MDN
`websocket`: https://developer.mozilla.org/en-US/docs/Web/API/WebSockets_API
`array methods`: https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Global_Objects/Array
* Heroku
https://devcenter.heroku.com/articles/getting-started-with-nodejs