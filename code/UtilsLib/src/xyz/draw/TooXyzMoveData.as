package  xyz.draw
{
	import xyz.base.TooXyzPosData;

	public class TooXyzMoveData extends TooXyzPosData
	{
		public var dataItem:Vector.<TooXyzPosData>
		public var lineBoxItem:Vector.<TooHitBoxLineSprite3D>
		public var isCenten:Boolean;
		public var modelItem:Array;
		public var dataChangeFun:Function
		public var dataUpDate:Function 

		public function TooXyzMoveData()
		{
		}
	}
}