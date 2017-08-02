package modules.brower
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	

	public class BrowerInputDaeFile
	{
		private static var instance:BrowerInputDaeFile;
		public function BrowerInputDaeFile()
		{
		}
		public static function getInstance():BrowerInputDaeFile{
			if(!instance){
				instance = new BrowerInputDaeFile();
			}
			return instance;
		}
		private var _bFun:Function
		private static var _toUrl:String;
		private static var _fileName:String
		public function inputFileUrl($url:String,$toUrl:String,$fileName:String,$bfun:Function=null):void
		{
			_fileName=$fileName
			_toUrl=$toUrl
			_bFun=$bfun
				
		
			LoadManager.getInstance().cancelLoadByUrl($url)
				
			var loaderinfo : LoadInfo = new LoadInfo($url, LoadInfo.XML, onObjLoad,0);
			LoadManager.getInstance().addSingleLoad(loaderinfo);
			
		}
		protected function onObjLoad(str : String) : void {
			DaeMeshModel.getInstance().setData(str,meshModelFun)
		}
		private function meshModelFun($arr:Array):void
		{
			var $urlArr:Array=new Array
			for(var i:uint=0;i<$arr.length;i++)
			{
				var _editPreUrl:String=_toUrl+"/"+_fileName+"_"+String(i)+".objs"
				var obj:Object=$arr[i]
				var fs:FileStream = new FileStream;
				fs.open(new File(_editPreUrl),FileMode.WRITE);
				fs.writeObject(obj);
				fs.close();
				$urlArr.push( _fileName+"_"+String(i)+".objs")
			}

			if(Boolean(_bFun)){
				_bFun($urlArr)
			}
			
		}
	
	}
}