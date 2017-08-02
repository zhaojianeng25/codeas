package mesh
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	import interfaces.ITile;
	
	import vo.H5UIFileNode;

	public class H5UIFileMesh extends EventDispatcher implements ITile
	{
		

		protected var _url:String;
		protected var _h5UIFileNode:H5UIFileNode;
		protected var _rectPos:Point
		protected var _rectSize:Point
		
	

		public function get rectPos():Point
		{
			return new Point(_h5UIFileNode.rect.x,_h5UIFileNode.rect.y);
		}
		[Editor(type="Vec2",Label="坐标",sort="1",Category="尺寸",Tip="坐标")]
		public function set rectPos(value:Point):void
		{
			_h5UIFileNode.rect.x=value.x;
			_h5UIFileNode.rect.y=value.y;
			change()
		}

		public function get h5UIFileNode():H5UIFileNode
		{
			return _h5UIFileNode;
		}

		public function get rectSize():Object
		{
			return new Point(_h5UIFileNode.rect.width,_h5UIFileNode.rect.height);
		}
		[Editor(type="Vec2",Label="尺寸",sort="2",Category="尺寸",Tip="坐标")]
		public function set rectSize(value:Object):void
		{
			_h5UIFileNode.rect.width=value.x;
			_h5UIFileNode.rect.height=value.y;
			change()
		}
		
		public function set h5UIFileNode(value:H5UIFileNode):void
		{
			_h5UIFileNode = value;
		}
		public function change():void{
			this.dispatchEvent(new Event(Event.CHANGE));
			
		}
		
		

		public function acceptPath():String
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		public function getBitmapData():BitmapData
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		public function getName():String
		{
			// TODO Auto Generated method stub
			return _h5UIFileNode.name;
		}
		
	}
}


