package _Pan3D.role
{
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	
	import _me.Scene_data;
	
	import com.zcp.timer.TimerHelper;
	
	import flash.utils.ByteArray;

	public class BuffManager
	{
		private static var _instance:BuffManager;
		
		private var dic:Object;
		
		private var requestList:Array;
		
		public function BuffManager()
		{
			requestList = new Array;
			initBuff();
		}
		
		public static function getInstance():BuffManager{
			if(!_instance){
				_instance = new BuffManager;
			}
			return _instance;
		}
		
		public function loadBuff(url:String,fun:Function):void{
			if(dic){
				if(dic[url])
					fun(dic[url]);
			}else{
				requestList.push({key:url,fun:fun});
			}
		}
		
		public function initBuff():void{
			var url:String = Scene_data.buffRoot + "all.lyfb";
			var loaderinfo : LoadInfo = new LoadInfo(url, LoadInfo.BYTE, onInfoCom,5);
			LoadManager.getInstance().addSingleLoad(loaderinfo);
		}
		private function onInfoCom(byte:ByteArray):void{
			dic = byte.readObject();
			TimerHelper.createTimer(1, 1,callback);
			function callback():void
			{
				for(var i:int;i<requestList.length;i++){
					if(dic[requestList[i].key])
						requestList[i].fun(dic[requestList[i].key]);
				}
				requestList.length = 0;
			}
		}
		
	}
}