package  render.atf
{
	import flash.display3D.Context3D;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;

	public class AtfMenager
	{
		private static var _instance:AtfMenager;
		public function AtfMenager()
		{
		}
		public function init($context3D:Context3D):void
		{
			_context3D=$context3D
		}
		public static function getInstance():AtfMenager{
			if(!_instance)
				_instance = new AtfMenager();
			return _instance;
		}
		
		private var _infoDic:Dictionary=new Dictionary;
		private var _funDic:Dictionary=new Dictionary;
		private var _context3D:Context3D;
		
		public function addSingleLoad($url:String,$fun:Function):void{
			
			
			if(_infoDic[$url]){
				if(_infoDic[$url].isFinish){
					$fun(_infoDic[$url])
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
				
				var $aTFData:ATFData=new ATFData(byte)
				_infoDic[$url].isFinish=true
				_infoDic[$url].data=$aTFData
					
				 trace($aTFData.format,$aTFData.width,$aTFData.height)
		
				_infoDic[$url].atfTexture=_context3D.createTexture($aTFData.width,$aTFData.height,  $aTFData.format,false);
				_infoDic[$url].atfTexture.uploadCompressedTextureFromByteArray(byte,0,0);
	
				backFun($url);
				

			}
			
		}
		private function backFun($url:String):void
		{
			
			
			var $list:Array=_funDic[$url]
			for(var i:uint=0;i<$list.length;i++){
				var $fun:Function=$list[i]
				$fun(Object(_infoDic[$url]))
			}
			
			
			
		}
		
		
		
		
	}
}