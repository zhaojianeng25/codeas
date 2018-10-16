package  workSave
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;
	
	public class WorkFileSaveManager
	{
		private static var _instance:WorkFileSaveManager;
		public static function instance():WorkFileSaveManager
		{
			if(!_instance)
			{
				_instance = new WorkFileSaveManager();
			}
			return _instance;
		}
		private var worker:Worker;
		private var main2work:MessageChannel;
		private var work2main:MessageChannel;
		public function WorkFileSaveManager()
		{

		}
		private function saveFileFromBmp($bmp:BitmapData,$url:String,$typeStr:String):void
		{
			if($bmp&&$bmp.width&&$bmp.height){
				var $picByte:ByteArray=$bmp.getPixels(new Rectangle(0,0,$bmp.width,$bmp.height))
				var $byte:ByteArray=new ByteArray
				$byte.writeInt($bmp.width)
				$byte.writeInt($bmp.height)
				$byte.writeBytes($picByte)
				saveFileFromByte($byte,$url,$typeStr)
			}else{
				throw new Error("这个文件有问题:" + $url)
			}
	
		
			
		}
		private function saveFileFromByte($byte:ByteArray,$url:String,$typeStr:String):void
		{
			var byte:ByteArray=new ByteArray
			byte.writeUTF($url)
			byte.writeBytes($byte)
            if($typeStr=="jpg"){
				sendMsg(byte,3)
			}else
            if($typeStr=="png"){
				sendMsg(byte,4)
			}else{
				
			}

		}
		/**
		 * 
		 * @param $obj
		 * @param $url
		 * @param $typeStr   类形  //jpg,png,file
		 * 
		 */
	    public function saveFile($bmp:BitmapData,$url:String,$typeStr:String):void
		{
			if(!worker){
				addWork();
			}
			if($bmp&&$bmp.width>0&&$bmp.height>0){
				saveFileFromBmp($bmp,$url,$typeStr)
			}
		}
		

		public function addWork():void
		{
			worker = WorkerDomain.current.createWorker(Workers.workSave_WorkSaveFileModel, true);
			main2work = Worker.current.createMessageChannel(worker);
			work2main = worker.createMessageChannel(Worker.current);
			worker.setSharedProperty("main2work", main2work);
			worker.setSharedProperty("work2main", work2main);
			worker.start();
		}
		private function sendMsg(msgByte:ByteArray,msgId:uint):void
		{
			//trace((msgByte.length/1024/1024) + "MB");
			var byte:ByteArray = new ByteArray;
			var length:int = msgByte.length + 4;
			byte.writeInt(msgId);
			byte.writeBytes(msgByte);
			main2work.send(byte)
		}
	}
}