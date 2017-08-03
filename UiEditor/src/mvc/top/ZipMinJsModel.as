
package mvc.top
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	
	import modules.scene.sceneSave.FilePathManager;

	public class ZipMinJsModel
	{
		public function ZipMinJsModel()
		{
		}
		
		private static var instance:ZipMinJsModel;

		public static function getInstance():ZipMinJsModel{
			if(!instance){
				instance = new ZipMinJsModel();
			}
			return instance;
		}
		public function run():void
		{
	
			var $file:File=new File(FilePathManager.getInstance().getPathByUid("minjs"))
			var txtFilter:FileFilter = new FileFilter("Text", ".js;*.js;");
			$file.browseForOpen("打开工程文件 ",[txtFilter]);
			$file.addEventListener(Event.SELECT,onSelect);
			function onSelect(e:Event):void
			{
				
				var $fsScene:FileStream = new FileStream;
				$fsScene.open($file,FileMode.READ);
				var minbyte:ByteArray=new ByteArray;
				$fsScene.readBytes(minbyte,0,$fsScene.bytesAvailable);
				$fsScene.close();
				var toFilename:String=$file.url.replace(".min.js",".zip.js")
				writeFileToaa(toFilename,minbyte)
			} 
			
			
		}
		
		private function writeFileToaa(_toFilename:String,minbyte:ByteArray):void
		{
			trace(minbyte.length/1024,"k")
			
			var $objsCone:ByteArray=new ByteArray();
			$objsCone.writeBytes(minbyte,0,minbyte.length)
			$objsCone.compress()
	
			trace($objsCone.length/1024,"k")
			
			var fs:FileStream = new FileStream;
			fs.open(new File(_toFilename),FileMode.WRITE);
			fs.writeBytes($objsCone,0,$objsCone.length);		
			fs.close();
		}
		
	}
}