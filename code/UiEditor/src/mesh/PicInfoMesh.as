package mesh
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	
	import interfaces.ITile;
	
	public class PicInfoMesh extends EventDispatcher implements ITile
	{
		private  var _picUrl:String
		public function PicInfoMesh(target:IEventDispatcher=null)
		{
			super(target);
		}
		


		public function get canverRectSize():Point
		{
			return new Point(0,0);
		}
		[Editor(type="Vec2",Label="尺寸",sort="2",Category="尺寸",Tip="坐标")]
		public function set canverRectSize(value:Point):void
		{
	
			change()
			
		}

		
		public function change():void{
			this.dispatchEvent(new Event(Event.CHANGE));
			
		}
		public function getBitmapData():BitmapData
		{
			return null;
		}
		
		public function getName():String
		{
			return null;
		}
		
		public function acceptPath():String
		{
			return null;
		}
	}
}