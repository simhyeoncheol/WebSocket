<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메인페이지</title>
</head>
<body>
	<h1>Main.jsp</h1>
	<button onclick="chatPage2()">채팅페이지</button>
	
	<script type="text/javascript">
		function chatPage2(){
			let chatId =prompt('사용자 이름 입력');
			console.log(chatId);	
			location.href ="chatPage2?chatid="+chatId;
		}
	</script>
</body>
</html>