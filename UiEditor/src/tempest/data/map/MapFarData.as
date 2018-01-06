package tempest.data.map
{

	public class MapFarData
	{
		public var name:String;
		public var xMoveRate:Number=0;
		public var yMoveRate:Number=0;
		public var width:uint;
		public var height:uint;
		public var x:int;
		public var y:int;

		/**
		 * 发生改变，用于编辑器
		 */
		public var isChange:Boolean=false;

		public function MapFarData(data:String)
		{
			var list:Array=data.split(",");
			this.name=list[0].toString();
			this.xMoveRate=Number(list[1]);
			this.yMoveRate=Number(list[2]);
			this.width=parseInt(list[3]);
			this.height=parseInt(list[4]);
			this.x=parseInt(list[5]);
			this.y=parseInt(list[6]);
		}

		public function toString():String
		{
			return this.name + "," + this.xMoveRate + "," + this.yMoveRate + "," + this.width + "," + this.height + "," + this.x + "," + this.y;
		}
	}
}
