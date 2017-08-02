package workSave
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.utils.ByteArray;
	
	import modules.hierarchy.FileSaveModel;
	
	public class WorkSaveFileModel extends Sprite
	{
		protected var _main2work:MessageChannel;
		protected var _work2main:MessageChannel;
		public function WorkSaveFileModel()
		{
			super();
			var worker:Worker = Worker.current;
			_main2work = worker.getSharedProperty("main2work");
			_work2main = worker.getSharedProperty("work2main");
			init();
			addEvent();
			run();
		}
		private function run():void
		{
			// TODO Auto Generated method stub
		}
		private function addEvent():void
		{
			_main2work.addEventListener(Event.CHANNEL_MESSAGE, onMain2Worker);
		}
		protected function init():void
		{
			_work2main.send("WorkSaveFileModelInit: "+Math.random())
		}
		protected function onMain2Worker(event:Event):void
		{
			var $backBytes:ByteArray=_main2work.receive()
			$backBytes.position=0
			trace($backBytes.length)
			$backBytes.position=0
			var $msid:int=$backBytes.readInt()
	         trace("消息号$msid",$msid)
			if($msid==3){   //jpg
				saveJpgFormByte($backBytes)
			}
			if($msid==4){   //png
				savePngFormByte($backBytes)
			}
		}
		private function savePngFormByte($backBytes:ByteArray):void
		{
			var $url:String=$backBytes.readUTF()
			var $w:uint=$backBytes.readInt()
			var $h:uint=$backBytes.readInt()
			var $bmp:BitmapData = new BitmapData($w,$h,true,0);
			$bmp.setPixels(new Rectangle(0,0,$w,$h),$backBytes);
			FileSaveModel.getInstance().saveBitmapdataToPng($bmp,$url)
		}
		private function saveJpgFormByte($backBytes:ByteArray):void
		{
			var $url:String=$backBytes.readUTF()
			var $w:uint=$backBytes.readInt()
			var $h:uint=$backBytes.readInt()
			var $bmp:BitmapData = new BitmapData($w,$h,true,0);
			$bmp.setPixels(new Rectangle(0,0,$w,$h),$backBytes);
			FileSaveModel.getInstance().saveBitmapdataToJpg($bmp,$url)
		}

	}
}