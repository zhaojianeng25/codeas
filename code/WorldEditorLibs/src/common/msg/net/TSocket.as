package common.msg.net
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import common.AppData;

	public class TSocket extends EventDispatcher
	{
		public function TSocket()
		{
		}
		
		private var _type:String;
		private var socket:Socket;
		
		private var bufferByteArray:ByteArray = new ByteArray();//接受数据的缓冲区
		private static var BUFFER_MAX_LENGTH:int=100000;//缓冲区最大长度
		
		private var connectCallFun:Function;
		
		public function initSocket($type:String=Endian.BIG_ENDIAN):void{
			socket = new Socket();
			socket.addEventListener(Event.CONNECT,onconnect);
			socket.addEventListener(IOErrorEvent.IO_ERROR,onError);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onseError);
			socket.addEventListener(ProgressEvent.SOCKET_DATA,onData);
			socket.addEventListener(Event.CLOSE,onClose);
			
			this._type = $type;
			socket.endian = $type;
			bufferByteArray.endian = $type;
			
			
			//connect();
		}
		
		
		public function hasConnect():Boolean{
			return socket.connected;
		}
		
		public function connect($fun:Function = null,$connetType:int = 1):Boolean{
			if(!socket.connected){
				connectCallFun = $fun;
				trace(AppData.RenderSocketUrl);
				if($connetType == 1){
					socket.connect(AppData.RenderSocketUrl,8588);
				}else if($connetType == 2){
					socket.connect(AppData.RenderSocketUrl,8333);
				}else if($connetType == 3){
					socket.connect(AppData.RenderSocketUrl,8332);
				}
				return true;
			}else {
				return false;
			}
		}
		
		protected function onClose(event:Event):void
		{
			this.dispatchEvent(new Event(Event.CLOSE));
		}
		
		private function onconnect(e:Event):void{
			trace("连接成功");
			if(Boolean(this.connectCallFun)){
				connectCallFun();
			}
		}
		
		//接收到消息
		protected function onData(e:ProgressEvent):void{
			
			//将数据写入缓冲区
			socket.readBytes(bufferByteArray, bufferByteArray.length, socket.bytesAvailable);
			//清除掉读过的数据，防止bufferByteArray过长
			if(bufferByteArray.length > BUFFER_MAX_LENGTH) 
			{
				var tempBA:ByteArray = new ByteArray();
				tempBA.endian = this._type;
				//bufferByteArray 的 position 决定了 bytesAvailable 肯定是未读取的数据的长度  ---nick
				bufferByteArray.readBytes(tempBA, 0, bufferByteArray.bytesAvailable);
				bufferByteArray.position = 0;
				bufferByteArray.length = 0;
				tempBA.readBytes(bufferByteArray, 0, tempBA.bytesAvailable);
			}
			//读取缓冲区数据
			readSocketData();
			
		}
		
		private function onError(e:IOErrorEvent):void{
			trace("连接失败,服务器没打开!")
		}
		private function onseError(e:SecurityErrorEvent):void{
			trace("连接失败，安全错误"+e.text)
		}
		
		private function readSocketData():void 
		{
			var bufferPosition:int;//记录当前缓冲区的指针
			var msgHeadMark:int;//取出消息头标识
			var msgLen:int;//得到该数据包的包体长度
			
			while(bufferByteArray.bytesAvailable>=4) //这里如果网速过慢，会不会等待超过15毫秒？？  不会的！
			{
				bufferPosition = bufferByteArray.position
				
				msgLen = bufferByteArray.readInt();
				if(msgLen > bufferByteArray.bytesAvailable) {//长度不够，等待缓冲区下一次读取
					bufferByteArray.position = bufferPosition;//还原指针
					return;
				} 
				else 
				{
					var dataBuf:ByteArray = new ByteArray();
					dataBuf.endian = this._type;
					//根据数据流中存储的包长度 减去文件头2和长度数据自身2,剩下的就是包的主体长度  ---nick
					bufferByteArray.readBytes(dataBuf, 0, msgLen);
					
					var msg:int = dataBuf.readInt();
					
					receiveMsg(msg,dataBuf);
					
				}
				
				
			}
		}
		/**
		 * 主服务接受信息 
		 * 
		 * 1 表示从渲染客户端回传的光照信息
		 * 3 表示接受的模型信息
		 * @param msgNum
		 * @param byte
		 * 
		 */		
		protected function receiveMsg(msgNum:int,byte:ByteArray):void{
			if(msgNum == 1){
				trace("读取渲染服务器数据");
			}else if(msgNum == 3){
				
			}
			NetManager.getInstance().returnMsg(msgNum,byte)
		}
		
		public function setByte(byte:ByteArray):void{
			if(!socket.connected){
				trace("服务器已关闭");
				return;
			}
			socket.writeBytes(byte);
			socket.flush();
		}
		
		
	}
}