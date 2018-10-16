package modules.hierarchy.h5
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import _me.Scene_data;

	public class MakeResFileList
	{
		private static var instance:MakeResFileList;
		public function MakeResFileList()
		{
		}
		public static function getInstance():MakeResFileList{
			if(!instance){
				instance = new MakeResFileList();
			}
			return instance;
		}
		private var _fileItem:Vector.<String>
		public function clear():void
		{
			_fileItem=new Vector.<String>;
			
		}
		public function pushUrl($url:String):void
		{
			if(new File(Scene_data.fileRoot+$url).extension=="png"){
				var $jpngName:String=$url
				$jpngName=$jpngName.replace(".png",".jpng");
				var $file:File=new File(Scene_data.fileRoot+$jpngName)
				if($file.exists){
					this.pushUrl($jpngName)
				}
			}
			
			for(var i:uint=0;i<_fileItem.length;i++)
			{
				if(_fileItem[i]==$url){
				       return ;
				}
			}

	
			
			
			_fileItem.push($url)
	
		}
		public function saveFileListToH5($rootUrl:String,$prentName:String,$filename:String):void
		{
			var $fileUrl:String=$rootUrl+$prentName+"/"+$filename+".gfile"
			pushUrl($fileUrl);

			var str:String =""
			for(var j:uint=0;j<_fileItem.length;j++)
			{
	
				var tempStr:String=_fileItem[j].replace($rootUrl,"")  //去掉根目录
				str+=tempStr;
				str+="\n"
			
				
			}
			var fs:FileStream = new FileStream();
			fs.open(new File($fileUrl), FileMode.WRITE);
			
			for(var i:uint = 0; i < str.length; i++)
			{
				fs.writeMultiByte(str.substr(i,1),"utf-8");
			}
			
			fs.close();
			
		
		}
	}
}