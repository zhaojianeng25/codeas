package utils
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class FileConfigUtils
	{
		public function FileConfigUtils()
		{
		}
		public static function readConfig():Object{
			var file:File = new File(File.documentsDirectory.url + "/particle/config.txt");
			if(!file.exists){
				return new Object;
			}
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.READ);
			var obj:Object = fs.readObject();
			fs.close();
			return obj;
		}
		public static function writeConfig(key:String,value:*):void{
			var obj:Object = readConfig();
			obj[key] = value;
			
			var file:File = new File(File.documentsDirectory.url + "/particle/config.txt");
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.WRITE);
			fs.writeObject(obj);
			fs.close();
		}
	}
}