package com.WebSocketChat.SockController;

import java.util.ArrayList;

import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

public class ChatSocketHandler extends TextWebSocketHandler {
	// 접속 클라이언트 저장 - session들을 모아두면 누가 session에 접속했는지, 메세지 보냈는지 정보등을 알수있다
	private ArrayList<WebSocketSession> connectionClienetList = new ArrayList<WebSocketSession>();

	@Override // 클라이언트가 접속요청해서 해당 웹소켓서버에 접속을 하는 경우에 실행
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		System.out.println("afterConnectionEstablished()- 채팅서버 접속");		
		connectionClienetList.add(session); // 접속 클라이언 목록에 저장
		for(WebSocketSession conn : connectionClienetList) { 
			conn.sendMessage(new TextMessage("채팅서버에 새로운 사용자가 접속했습니다."));								
		}
		System.out.println("접속자: " + connectionClienetList.size());
	}

	@Override //접속 중인 클라이언트에서 데이터를 전송하면 실행(누군가 채팅 페이지 들어가서 채팅 메시지 치고 전송버튼 누르면 실행) 
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception { //session: 누군가, message: 메세지
		System.out.println("handleTextMessage() - 메세지 전송");
		System.out.println("message.getPayload(): "+message.getPayload());		
		//	for(int i=0; i<connClientList.size(); i++){ }
		for(WebSocketSession conn : connectionClienetList) { 
			if(!conn.getId().equals(session.getId() )) {
				//sendMessage() 서버가 클라이언트에게 메세지 전송 서버에서 클라링언트쪽으로 메세지를 전송하면 onmessage발생
				conn.sendMessage(new TextMessage(message.getPayload() ));								
			}		
		}
	}
	@Override // 특정한 클라이언트가 접속을 해제하는 경우에 실행
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		System.out.println("afterConnectionClosed()- 채팅서버 접속해제");
		connectionClienetList.remove(session); // 접속을 해제한 세션을 접속클라이언트 목록에서 삭제	
		for(WebSocketSession conn : connectionClienetList) { 
			conn.sendMessage(new TextMessage("사용자가 접속을 해제 했습니다."));								
		}
		System.out.println("접속자: " + connectionClienetList.size());
	}

}
