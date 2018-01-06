package out
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	
	import tempest.data.map.MapConfig;

	public class OutNetMapModel
	{
		private static var instance:OutNetMapModel;
		public function OutNetMapModel()
		{
		}
		public static function getInstance():OutNetMapModel{
			if(!instance){
				instance = new OutNetMapModel();
			}
			return instance;
		}
		
		public  function run():void
		{
			var $file:File=new File;
			//var txtFilter:FileFilter = new FileFilter("Text", ".xml;*.xml;");
			var txtFilter:FileFilter = new FileFilter("Text",".txt;*.TXT;");
			$file.browseForOpen("打开导入的文件 ",[txtFilter]);
			$file.addEventListener(Event.SELECT,onSelect);
			function onSelect(e:Event):void
			{
				//readAST($file)
				showDic($file.parent)
			}
		}
		private function showDic($perentFile:File):void
		{
			var $list:Array=$perentFile.getDirectoryListing();
			for(var i:Number=0;i<$list.length;i++){
				var $one:File=$list[i];
				if($one.extension=="txt"){

					readAST($one)
				}
			
			
			}
		}
		private function readAST($file:File):void
		{
			var $fs:FileStream = new FileStream();   
			$fs.open($file,FileMode.READ);    
			var  $baseStr:String=$fs.readUTFBytes($fs.bytesAvailable);
			$fs.close();
			var $mapConfig:MapConfig=new MapConfig()
			var dd:Array=$mapConfig.anlyData($baseStr,false);
			var $temp:String=""
			for(var i:Number=0;i<dd.length;i++){
				$temp+=dd[i]+"\n";
			}
			$fs.open($file,FileMode.WRITE);    
			$fs.writeUTFBytes($temp)
			$fs.close();
			
			trace($file.name)
			
			
		}

	}
}