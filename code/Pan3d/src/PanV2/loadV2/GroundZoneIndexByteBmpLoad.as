package  PanV2.loadV2
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class GroundZoneIndexByteBmpLoad
	{
		private static var _instance:GroundZoneIndexByteBmpLoad;
		public function GroundZoneIndexByteBmpLoad()
		{
		}
		public static function getInstance():GroundZoneIndexByteBmpLoad{
			if(!_instance)
				_instance = new GroundZoneIndexByteBmpLoad();
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
				var bitmapdata:BitmapData = new BitmapData(256,256,false,0);
				bitmapdata.setPixels(new Rectangle(0,0,256,256),byte);
	
					
				_infoDic[$url].isFinish=true
				_infoDic[$url].data=bitmapdata
					
				backFun($url);
			}
			
			
		}
		private function backFun($url:String):void
		{
			
			
			var cc:Array=_funDic[$url]
			for(var i:uint=0;i<cc.length;i++){
				var $fun:Function=cc[i]
				$fun(_infoDic[$url].data)
			}
			
			
			
			
		}
		
		
		
		
	}
}


