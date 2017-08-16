
package mvc.top
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	
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
			var txtFilter:FileFilter = new FileFilter("Text", ".js;*.js;.txt;*.txt;");
			$file.browseForOpen("打开工程文件 ",[txtFilter]);
			$file.addEventListener(Event.SELECT,onSelect);
			function onSelect(e:Event):void
			{
				/*
				var $fsScene:FileStream = new FileStream;
				$fsScene.open($file,FileMode.READ);
				var minbyte:ByteArray=new ByteArray;
				$fsScene.readBytes(minbyte,0,$fsScene.bytesAvailable);
				$fsScene.close();
				var toFilename:String=$file.url.replace(".min.js",".zip.js")
				writeFileToaa(toFilename,minbyte)
				*/
				changeZipByFile($file)
			} 
			
			
		}
		public function changeZipByFile($file:File):void
		{
			if($file.exists){
				var $fsScene:FileStream = new FileStream;
				$fsScene.open($file,FileMode.READ);
				var minbyte:ByteArray=new ByteArray;
				$fsScene.readBytes(minbyte,0,$fsScene.bytesAvailable);
				$fsScene.close();
				var toFilename:String
			 	if($file.extension=="js"&&$file.url.indexOf("min")!=-1){
					 toFilename=$file.url.replace(".min.js",".zip.js")
				}else{
					toFilename=$file.url.replace("."+$file.extension,".zip."+$file.extension);
					if($file.name=="tb.txt"){
						writeTbZipFile(new File($file.url.replace("tb.txt","scene.txt")),minbyte);
						
						return 
					}
				}
				writeFileToaa(toFilename,minbyte);
			}else{
			   Alert.show($file.url,"警告");
			}
		}
		private function writeTbZipFile($file:File,minbyte:ByteArray):void
		{
			if($file.exists){
				
				var $objsCone:ByteArray=new ByteArray();
				$objsCone.writeBytes(minbyte,0,minbyte.length)
				$objsCone.compress()
				
				var $fs:FileStream = new FileStream;
				$fs.open($file,FileMode.READ);
				var $urtr:String=$fs.readUTFBytes($fs.bytesAvailable);
				$fs.close();

				var fs:FileStream = new FileStream;
				fs.open(new File($file.url.replace("scene.txt","tb.zip.txt")),FileMode.WRITE);

				fs.writeInt($objsCone.length);
				fs.writeBytes($objsCone,0,$objsCone.length);		

				fs.writeInt($urtr.length);
				fs.writeUTFBytes($urtr);

				fs.close();
				
				Alert.show("生存了tb.zip.txt");
				
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