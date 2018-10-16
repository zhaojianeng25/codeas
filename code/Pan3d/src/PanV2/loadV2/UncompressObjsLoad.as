package  PanV2.loadV2
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class UncompressObjsLoad
	{
		private static var _instance:UncompressObjsLoad;
		public function UncompressObjsLoad()
		{
		}
		public static function getInstance():UncompressObjsLoad{
			if(!_instance)
				_instance = new UncompressObjsLoad();
			return _instance;
		}
		private var _infoDic:Dictionary=new Dictionary;
		private var _funDic:Dictionary=new Dictionary;
	
		public function addSingleLoad($url:String,$fun:Function):void{


			if(_infoDic[$url]){
				if(_infoDic[$url].isFinish){
					$fun(_infoDic[$url].data)
				}else{
					addPushFun($url,$fun)
				}

			}else{
				addPushFun($url,$fun)
				tempLoad($url);
				
				
			}
		}
		private function addPushFun($url:String,$fun:Function):void
		{
			if(!Boolean(_funDic[$url])){
				_funDic[$url]=new Array
			}
			_funDic[$url].push($fun)
		}
		private function tempLoad($url:String):void
		{
			var loaderinfo : LoadInfo = new LoadInfo($url, LoadInfo.BYTE, onObjByteLoad,10);
			LoadManager.getInstance().addSingleLoad(loaderinfo);
			_infoDic[$url]={isFinish:false}
			function onObjByteLoad(byte:ByteArray):void{

				byte.uncompress();
				var obj:Object = byte.readObject();
				_infoDic[$url].isFinish=true
				_infoDic[$url].data=obj
				
				backFun($url);
			}

		}
		private function backFun($url:String):void
		{
	
			
			var cc:Array=_funDic[$url]
			for(var i:uint=0;i<cc.length;i++){
				var $fun:Function=cc[i]
				$fun(Object(_infoDic[$url].data))
			}
				
				
			
		}
	
		 
		
	
	}
}