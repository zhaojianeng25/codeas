package  PanV2.loadV2
{
	import com.zcp.loader.UrlLoadManager;
	
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	

	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class BmpLoad
	{
		public function BmpLoad()
		{
		}
		public static function getInstance():BmpLoad{
			if(!_instance)
				_instance = new BmpLoad();
			return _instance;
		}
		private var _infoDic:Dictionary=new Dictionary;
		private var _funDic:Dictionary=new Dictionary;
		private static var _instance:BmpLoad;

		
		public function addSingleLoad($url:String,$fun:Function,info:Object):void{
			
			if(_infoDic[$url]){
				if(_infoDic[$url].isFinish){
					$fun(Bitmap(_infoDic[$url].data),Object(info))
				}else{
					addPushFun($url,$fun,info)
				}
				
			}else{
				addPushFun($url,$fun,info)
				tempLoad($url,info);
			}
		}
		public function clearDis():void
		{
			 this._infoDic=new Dictionary;
			 this._funDic=new Dictionary;
			 
		
		}
		public function cancelLoadByUrl($url:String):void
		{
			if(_infoDic[$url]){
				_infoDic[$url]=null
				LoadManager.getInstance().cancelLoadByUrl($url)
			}
		
		}
		private function addPushFun($url:String,$fun:Function,info:Object):void
		{
			if(!Boolean(_funDic[$url])){
				_funDic[$url]=new Object
				_funDic[$url].funItem=new Array
				_funDic[$url].infoItem=new Array
			}
			_funDic[$url].funItem.push($fun)
			_funDic[$url].infoItem.push(info)
		}
		private function tempLoad($url:String,info:Object):void
		{
			_infoDic[$url]={isFinish:false,info:info}
			var loaderinfo : LoadInfo = new LoadInfo($url, LoadInfo.BITMAP, onLightTexture,10,info);
			LoadManager.getInstance().addSingleLoad(loaderinfo);
			function onLightTexture(bitmap:Bitmap,$buildData:*):void{
				
				if(_infoDic.hasOwnProperty($url)&&_infoDic[$url]){
					_infoDic[$url].isFinish=true
					_infoDic[$url].data=bitmap
					backFun($url)
				}
			}
		}
		
		private function backFun($url:String):void
		{
			
			var cc:Array=_funDic[$url].funItem
			for(var i:uint=0;i<cc.length;i++){
				var $fun:Function=cc[i]
				$fun(Bitmap(_infoDic[$url].data),Object(_funDic[$url].infoItem[i]))
			}
			
			
			
		}
	}
}


