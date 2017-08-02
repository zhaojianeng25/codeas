package _Pan3D.load
{
	import com.zcp.loader.DobjLoadManager;
	import com.zcp.loader.UrlLoadManager;
	import com.zcp.loader.vo.LoadData;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	
	import _me.Scene_data;

	/**
	 * @author liuyanfei  QQ: 421537900
	 */
	public class LoadManager
	{
		
		//静态函数
//===========================================================
		/**版本控制函数  格式：function version(url:String):String*/
		private static var _getVersion:Function;
		
		/**
		 * 初始化pan3D要使用的解密和版本获取函数 
		 */		
		public static function initGlobalConfig( $version:Function ):void
		{
			_getVersion = $version;
		}
		
		
		private static var _instance:LoadManager;
		private var _listLoader:ListLoader;
		private var _stackLoader:StackLoader;
		
		public function LoadManager()
		{
			if(_instance!=null) throw new Error("Error: Singletons can only be instantiated via getInstance() method!");  
			LoadManager._instance = this;  
			init();
		}
		public static function getInstance():LoadManager{
			if(!_instance)
				_instance = new LoadManager();
			return _instance;
		}
		
		private function init():void{
			_listLoader = new ListLoader;
			_stackLoader = new StackLoader;
		}
		public function cancelLoadByUrl($url:String):void
		{
			UrlLoadManager.cancelLoadByUrl($url)
		}
		public function addSingleLoad(loaderInfo:LoadInfo):void{
//			_stackLoader.addLoad(loaderInfo);
//			return;
			if(loaderInfo.url.indexOf("finalscens/pan/panscene_hide/capture/")!=-1){
				
				trace("断点")
			}
			if(Scene_data.isDevelop){
				_stackLoader.addLoad(loaderInfo);
			}else{
				load(loaderInfo);
			}
		}
		
		public function addListLoad(list:Vector.<LoadInfo>,fun:Function):void{
			_listLoader.load(list);
			_listLoader.addEventListener(Event.COMPLETE,fun);
		}
		
		
		/**
		 * 加载资源 
		 * @param $url					资源地址
		 * @param $onCom				完成回调
		 * @param $onError				错误回调
		 * @param $priority				加载优先级
		 * @param $needDecode			是否需要解密,(只有.png和.jpg需要)
		 * @param $tryCount				最大尝试次数
		 */		
		public function load(loadInfo:LoadInfo):void
		{
			//版本控制
			var $url:String;
			if(_getVersion != null)
			{
				$url = _getVersion(loadInfo.url);
			}else{
				$url = loadInfo.url;
			}
			
			//3D中的图片不再需要解密!			//NICK
			var ld:LoadData = new LoadData($url, onComplete, null, onError, "", "", loadInfo.priority, URLLoaderDataFormat.BINARY, null, null);
			
			if(loadInfo.type == LoadInfo.BITMAP){
				DobjLoadManager.load(ld);
			}else{
				UrlLoadManager.load(ld);
			}
	
			
			//加载完成
			function onComplete($ld:LoadData, $e:Event=null):void
			{
				var result:Object;
				if(loadInfo.type == LoadInfo.BITMAP){
					result = $e.target.content as Bitmap;
				}else{
					var bytes:ByteArray = $e.target.data as ByteArray;
					if(loadInfo.type == LoadInfo.XML){
						result = bytes.readUTFBytes(bytes.bytesAvailable);
					}else{
						result = bytes;
					}
				}
				
				if(Boolean(loadInfo.fun))
				{
					if(loadInfo.info != null){
						loadInfo.fun(result,loadInfo.info);
					}else{
						loadInfo.fun(result);
					}
				}
			}
			
			function onError($ld:LoadData, $e:Event=null):void
			{
				if(Boolean(loadInfo.errorFun))
				{
					loadInfo.errorFun(loadInfo.info);
				}
			}
			
		}
		
		private function getType(str:String):String{
			if(str != LoadInfo.XML){
				 return URLLoaderDataFormat.BINARY;
			}else{
				 return URLLoaderDataFormat.TEXT;
			}
		}
		
	}
}