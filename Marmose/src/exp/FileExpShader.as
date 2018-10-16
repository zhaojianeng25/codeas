package exp
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;

	public class FileExpShader
	{
		private static var instance:FileExpShader;
		public function FileExpShader()
		{
		}
		public static function getInstance():FileExpShader{
			if(!instance){
				instance = new FileExpShader();
			}
			return instance;
		}
		public  function run():void
		{
			var $file:File=new File;
			//var txtFilter:FileFilter = new FileFilter("Text", ".xml;*.xml;");
			var txtFilter:FileFilter = new FileFilter("Text",".txt;*.txt;");
			$file.browseForOpen("打开导入的文件 ",[txtFilter]);
			$file.addEventListener(Event.SELECT,onSelect);
			function onSelect(e:Event):void
			{
				reandRoot($file)
				
			}
		}
		
		
		private function reandRoot($indexsFile:File):void
		{
			var fs:FileStream = new FileStream();   
			fs.open($indexsFile,FileMode.READ);    
			var $str:String=fs.readUTFBytes(fs.bytesAvailable)
		   var $arr:Array=	$str.split("\r\n");
		
			  for(var i:Number=0;i<$arr.length;i++){
				  var $outStr:String="\""+$arr[i]+"\\"+"n"+"\""+"\+";
				
				  trace($outStr)
			  }
		
		}
		
	}
}