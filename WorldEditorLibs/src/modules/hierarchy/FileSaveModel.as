package modules.hierarchy
{
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import mx.graphics.codec.JPEGEncoder;
	import mx.graphics.codec.PNGEncoder;
	
	import PanV2.loadV2.BmpLoad;

	public class FileSaveModel
	{
		private static var instance:FileSaveModel;
		private var jpgEncoder:JPEGEncoder;


		public static function getInstance():FileSaveModel{
			if(!instance){
				instance = new FileSaveModel();
			}
			return instance;
		}
		public function FileSaveModel()
		{
			
	
		}
		public function deleFile($url:String):void
		{
			var file:File = new File($url);		
			if(file.exists){
				file.deleteFile()
			}
			
		}
		
		public var workSaveFile:Object
		/**
		 *专门为了使用在多线程 
		 * @param $data
		 * @param $url
		 * @param $typeStr
		 * 
		 */
		public function useWorkerSaveBmp($data:BitmapData,$url:String,$typeStr:String):void
		{
			this.workSaveFile=null //关闭多线程写入文件
			if(this.workSaveFile){
				this.workSaveFile.saveFile($data,$url,$typeStr)
			}else{
				if($typeStr=="jpg"){
					this.saveBitmapdataToJpg(BitmapData($data),$url)
				}
				if($typeStr=="png"){
					this.saveBitmapdataToPng(BitmapData($data),$url)
				}
			}
			
		}
	
		public function initJpgQuality($num:uint):void
		{
			jpgEncoder = new JPEGEncoder($num);
		}
			
			

		public function saveBitmapdataToJpg($bmp:BitmapData,$url:String):void
		{
			if(!$bmp){
				return 
			}
			BmpLoad.getInstance().cancelLoadByUrl($url)

			if(!jpgEncoder){
				jpgEncoder = new JPEGEncoder(100);
			}
			var by:ByteArray;
			var fs:FileStream = new FileStream();
			var file:File = new File($url);			
			fs.open(file,FileMode.WRITE);
			by = jpgEncoder.encode($bmp);
			by.position = 0;
			fs.writeBytes(by);
			by.clear();
			by = null;
			fs.close();
		}
		private var pngEncoder:PNGEncoder;
		public function saveBitmapdataToPng($bmp:BitmapData,$url:String):void
		{
			if(!$bmp){
				return 
			}
			BmpLoad.getInstance().cancelLoadByUrl($url)
			
			if(!pngEncoder){
				pngEncoder = new PNGEncoder();
			}
			var by:ByteArray;
			var fs:FileStream = new FileStream();
			var file:File = new File($url);			
			fs.open(file,FileMode.WRITE);
			by = pngEncoder.encode($bmp);
			by.position = 0;
			fs.writeBytes(by);
			by.clear();
			by = null;
			fs.close();
		}
		public static function saveByteToFile($by:ByteArray,$url:String):void
		{

			var fs:FileStream = new FileStream();
			var file:File = new File($url);			
			fs.open(file,FileMode.WRITE);
			$by.position = 0;
			fs.writeBytes($by);
			$by.clear();
			$by = null;
			fs.close();
			
			
		}
	}
}