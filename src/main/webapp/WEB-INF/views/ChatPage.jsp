<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>채팅 페이지</title>
<style type="text/css">
	
		#chatArea{
			box-sizing: border-box;
			border: 3px solid black;
			border-radius: 10px;
			width: 650px;
			padding: 10px;
			background-color: #9bbbd4;
			height: 500px;
			overflow: scroll;
		}
		.sendMsg{
			text-align: right;
		}
		.msgComment{
			display: inline-block;
			padding: 7px;
			border-radius: 7px;
			max-width: 220px;
		}
		.receiveMsg>.msgComment{
			background-color: #ffffff;
		}
		.sendMsg>.msgComment{
			background-color: #fef01b;
		}
		.receiveMsg, .sendMsg{
			margin-bottom:5px;
		}
				
		.connMsg{
			min-width:200px;
			max-width:300px;
			margin:5px auto;
			text-align: center;
			background-color: #556677;
			color: white;
			border-radius: 10px;
			padding: 5px;
		}
		.msgId{	
			font-weight: bold;
			font-size: 13px;
			margin-bottom: 2px;
		}
		#inputMsg{
			box-sizing: border-box;
			border: 3px solid black;
			border-radius: 10px;
			width: 650px;
			padding: 10px;
		}
			
		#inputMsg{
			display: flex;
		}
		#inputMsg>input{
			width: 100%;
			padding:5px;
		}
		#inputMsg>button{
			width:100px;
			padding:5px;
		}
	
</style>
</head>

<body>
	<h1>ChatPage.jsp - ${sessionScope.loginId}</h1>
	
	<hr>

	<div id="chatArea">
		<div class="receiveMsg">
			<div class="msgId">아이디</div>
			<div class="msgComment">받은메세지</div>
		</div>
	
		<div class="sendMsg">
			<div class="msgComment">보낸메세지</div>
		</div>
		
		<div class="connMsg">
			<div class="msgId">접속/접속해제</div>
		</div>
	</div>
	<div id="inputMsg">
		<input type="text" id="sendMsg">
		<button onclick="sendMsg()">전송!</button>
	</div>


<!-- sockJS -->
	<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
	
	
	
	<script type="text/javascript">
			var sock = new SockJS('/chatPage'); //URL주소 chatPage로 변경.
		 sock.onopen = function() {
		     console.log('open');
		    // sock.send('test');
		 };
		
		 sock.onmessage = function(e) { 
			   //  console.log('message', e.data); //{"sendid":"dlwjddnjs","message":"메세지"}
			     let msgObj = JSON.parse(e.data); //"안내 메세지"
			     console.log("msgtype: ", +msgObj.msgtype); //"c" ,"m", "d"
			     console.log("msgid: "+msgObj.msgid);
			     console.log("msgcomm: "+msgObj.msgcomm);
			     //sock.close();
			    
			     let mtype = msgObj.msgtype;
			     switch(mtype){
			     case "m" :
			    	 printMessage(msgObj);	// 메세지 출력 기능
			    	    	 
			    	 break;
			     case "c" : 
			    	 
			    	// break;
			     case "d" :
			    	 printConnection(msgObj); //접속 정보 출력 기능0
			    	 
			    	 break;
			     }
			 };
		
		 sock.onclose = function() {
		     console.log('close');
		 };
	 </script>
	<script type="text/javascript">

	let chatAreaDiv =document.querySelector("#chatArea");

	function sendMsg(){
		let msgInput = document.querySelector("#sendMsg");
		sock.send(msgInput.value);
		
		let sendMsgDiv = document.createElement('div');
		sendMsgDiv.classList.add('sendMsg');
		sendMsgDiv.setAttribute('tabindex',"0");
		
		let msgCommDiv = document.createElement('div');
		msgCommDiv.classList.add('msgComment');
		msgCommDiv.innerText = msgInput.value;
		
		sendMsgDiv.appendChild(msgCommDiv);
		
		chatAreaDiv.appendChild(sendMsgDiv);
		
		msgInput.value="";
	}
	function printMessage(msgObj){
		console.log("메세지 출력 기능");
	//	let receiveMsgDiv = document.querySelector("#sendMsg");
		let receiveMsgDiv = document.createElement("div");
		receiveMsgDiv.classList.add('receiveMsg');
		receiveMsgDiv.setAttribute('tabindex',"0");
		
		let msgIdDiv = document.createElement("div");
		msgIdDiv.classList.add('msgId');
		msgIdDiv.innerText = msgObj.msgid;
		receiveMsgDiv.appendChild(msgIdDiv);
		
		let msgCommentDiv = document.createElement('div');
		msgCommentDiv.classList.add('msgComment');
		msgCommentDiv.innerText = msgObj.msgcomm;
		receiveMsgDiv.appendChild(msgCommentDiv);
		
		chatAreaDiv.appendChild(receiveMsgDiv);
	}
	function printConnection(msgObj){
		console.log("접속정보 출력 기능");
		let connMsgDiv = document.createElement('div');
		connMsgDiv.classList.add('connMsg');
		connMsgDiv.innerText = msgObj.msgid+'이/가 '+msgObj.msgcomm;
		connMsgDiv.setAttribute('tabindex',"0");
		chatAreaDiv.appendChild(connMsgDiv);
		connMsgDiv.focus();
	}
</script>
</body>
</html>