package com.WebSocketChat.SockController;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.google.gson.Gson;

public class ChatPageHandler extends TextWebSocketHandler {
//접속이 됐을 때, 해제됐을 때, 클라이언트에서 메세지를 보내줬을 때 3개의 처리
	//채팅페이지에 접속한 클라이언트 목록
	private ArrayList<WebSocketSession> clientList = new ArrayList<WebSocketSession>();
	
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		System.out.println("채팅 페이지 접속");
		Map<String, Object> sessionAttrs = session.getAttributes(); 
		String loginId =(String)sessionAttrs.get("loginId"); //현재 채팅방에 접속한 사람의 아이디 
		
		Gson gson = new Gson();
		HashMap<String, String> msgInfo = new HashMap<String, String>();
		msgInfo.put("msgtype", "c"); //c:접속해서 보내는 메세지 , d:접속해제해서 보내는 메세지, m:채팅,누가 채팅을 해서 사용하는 메세지
		msgInfo.put("msgid", loginId); //msgid에 loginId(로그인한 아이디)
		msgInfo.put("msgcomm", "접속 했습니다.");
		// { "msgtype" : "c" , "msgid" : loginid, "msgcomm" : "접속했습니다."}
		for(WebSocketSession client : clientList) {
			//새 참여자 접속 안내 메세지 전송
			client.sendMessage( new TextMessage(gson.toJson(msgInfo)) );
		}
		clientList.add(session); //접속을 한 클라이언트를 목록에 저장
	}

	@Override //session:클라이언트의 session, 채팅메시지를 보낸 session /message:클라이언트에서 보낸 메세지가 담긴다 
	//session이 가진 속성을 반환하고 그 중에 필요로 하는 로그인상태로 채팅방 들어가서 메세지를 보낸 사람의 아이디 
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		System.out.println("채팅 메세지 전송");
		System.out.println("전송한 메세지: "+message.getPayload());
		//key,value로 이루어져있는 map객체가 sessionAttrs에 담기고 그 중에 loginId key를 지정하면 session 안에 있던 loginId를 찾고 value를 String로 변환해서
		Map<String, Object> sessionAttrs = session.getAttributes(); //누군가 접속한 클라이언트가 보낼 때 실행. 누가보냈는지에대한정보
		String loginId =(String)sessionAttrs.get("loginId");
		System.out.println("보내는 사람:" +loginId);
		
		Gson gson = new Gson();
		HashMap<String, String> msgInfo = new HashMap<String, String>();
		msgInfo.put("msgtype", "m");
		msgInfo.put("msgid", loginId); //보내는 사람의 아이디
		msgInfo.put("msgcomm", message.getPayload() );//msgcomm은 message.getPayload()가 실제로 보내는 메세지 
	
		for(WebSocketSession client : clientList) {
			if( !client.getId().equals(session.getId()) ) {
				client.sendMessage(new TextMessage(gson.toJson(msgInfo)) ); //{sendid:dlwjddnjs, message:1234}
				//client.sendMessage(new TextMessage(loginId+"_"+message.getPayload()) ); dlwjddnjs_메세지
			}
		}
	}

	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		System.out.println("체팅 페이지 접속해제");
		clientList.remove(session); //접속 해제한 session을 클아이언트 목록에서 제거
		
		Map<String, Object> sessionAttrs = session.getAttributes(); 
		String loginId =(String)sessionAttrs.get("loginId"); //현재 채팅방에 접속한 사람의 아이디 
		
		Gson gson = new Gson();
		HashMap<String, String> msgInfo = new HashMap<String, String>();
		msgInfo.put("msgtype", "d"); //c:접속해서 보내는 메세지 , d:접속해제해서 보내는 메세지, m:채팅,누가 채팅을 해서 사용하는 메세지
		msgInfo.put("msgid", loginId); //msgid에 loginId(로그인한 아이디)
		msgInfo.put("msgcomm", "접속을 해제했습니다.");

		for(WebSocketSession client : clientList) {
			if( !client.getId().equals(session.getId()) ) {
				client.sendMessage(new TextMessage(gson.toJson(msgInfo)) ); //{sendid:dlwjddnjs, message:1234}
				//client.sendMessage(new TextMessage(loginId+"_"+message.getPayload()) ); dlwjddnjs_메세지
			}
		}
	}
	
	
}
