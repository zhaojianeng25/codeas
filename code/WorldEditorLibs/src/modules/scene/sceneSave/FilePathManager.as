package modules.scene.sceneSave
{
	import flash.net.SharedObject;

	public class FilePathManager
	{
		private static var instance:FilePathManager;
		private var _sharedObject:SharedObject;
		private var _urlDic:Object
		public function FilePathManager()
		{
		
			
			_sharedObject=SharedObject.getLocal("pathDic","/")
				
			if(_sharedObject.data.dic){
				
			}else{
				_sharedObject.data.dic=new Object();
			}
		
		
		}
		public static function getInstance():FilePathManager{
			if(!instance){
				instance = new FilePathManager();
			}
			return instance;
		}
		public function getPathByUid($str:String):String
		{
			var dic:Object=Object(_sharedObject.data.dic);
			if(dic.hasOwnProperty($str)){
				return dic[$str]
				
			}
			return null
		}
		public function setPathByUid($str:String,$url:String):void
		{
			var dic:Object=Object(_sharedObject.data.dic);
			dic[$str]=$url;
			
		}
		
	}
}