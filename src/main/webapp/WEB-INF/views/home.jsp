<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
	<title>Home</title>
<style text="text/css">
	#chatArea{
		border: 2px solid black;
		width: 500px;
		padding: 10px;
	}
	.receiveMsg{
		margin-bottom: 3px;
	}
	.sendMsg{
		text-align: right;
		margin-bottom: 3px;
	}
</style>	
</head>
<body>
	<h1>
		home.jsp 
	</h1>
	<input type="text" id="sendMsg">
	<button onclick="msgSend()">전송</button>
	<hr>
	<div id="chatArea">
		<div class="receiveMsg">
		받은메세지
		</div>
		
		<div class="sendMsg">
		<!-- 보낸 메세지 -->
		보낸메세지
		</div>	
	
	</div>
	<P>  The time on the server is ${serverTime}. </P>
	
	<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
	<script type="text/javascript">
	
		let chatAreaDiv = document.querySelector('#chatArea'); //전역변수
	
		 var sock = new SockJS('chatSocket'); //여기 안에 URL을 써주면 된다. 접속되는 서버 
		 sock.onopen = function() { //접속할 때 실행되는 function
		 console.log('open');
		 // sock.send('test'); //접속되어 있는 서버로 메세지 전송 
		 };
		
		 sock.onmessage = function(e) { //정보를 보냈을 때
			 
		     console.log('받은 메세지: ', e.data);
		     //sock.close();//접속해제하는function
		 	 let receiceMsgDiv = document.createElement('div');
		 	 receiceMsgDiv.classList.add('receiveMsg');
		 	 receiceMsgDiv.innerText = e.data;
		 	 chatAreaDiv.appendChild(receiceMsgDiv);
		 		
		 };
		
		 sock.onclose = function() { //접속을 끊었을 때
		     console.log('close');
		 };
	</script>
	<script type="text/javascript">
		function msgSend(){
			let msgInput = document.querySelector("#sendMsg");
			//console.log("보낸 메세지: "+msgInput.value);
			sock.send(msgInput.value);//클라이언트가 데이터를 chat 서버로 전송 (클라이언트->서버)
			
			let sendDiv = document.createElement('div');
			sendDiv.classList.add('sendMsg');
			sendDiv.innerText = msgInput.value;
			chatAreaDiv.appendChild(sendDiv); //채팅 화면에 메세지 출력
			
			msgInput.value=""; //메세지 입력했던 input태그를 초기화
		}
	</script>
</body>
</html>
