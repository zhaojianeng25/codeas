package mvc.rendercook
{
	import flash.utils.ByteArray;
	
	import common.msg.net.TSocket;
	
	public class FrameTSocket extends TSocket
	{
		public function FrameTSocket()
		{
			super();
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
		override protected function receiveMsg(msgNum:int,byte:ByteArray):void{
			if(msgNum == 1){
				trace("读取渲染服务器数据");
			}else if(msgNum == 3){
				
			}
			CookNetManager.getInstance().returnMsg(msgNum,byte)
		}
		
	}
}