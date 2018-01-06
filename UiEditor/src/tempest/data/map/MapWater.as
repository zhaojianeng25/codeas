package tempest.data.map
{
	public class MapWater
	{
		public var name:String;

		public var x:int;
		public var y:int;
		public var width:uint=512;
		public var height:uint=512;

		/**
		 * 位于底层
		 */
		public var atBottom:Boolean=true;

		//浪高,默认200，可选(0-255)
		public var waveHeight:uint=200;
		//波长,默认256，可选(64,128,256,512,1024)
		public var waveLength:uint=64;
		//震幅，默认6，可选(0-10)
		public var waveBreadth:uint=6;
		//水流方向，默认由上至下，可选(4个方向)
		public var streamDirect:uint=0;
		//流水速度 1原速度，1以下减速，1以上加速
		public var streamSpeed:Number=1;

		public function MapWater(data:String)
		{
			var list:Array=data.split(",");
			this.name=list[0].toString();
			this.x=parseInt(list[1]);
			this.y=parseInt(list[2]);
			this.width=parseInt(list[3]);
			this.height=parseInt(list[4]);
			this.atBottom=Boolean(int(list[5]));
			this.waveHeight=parseInt(list[6]);
			this.waveLength=parseInt(list[7]);
			this.waveBreadth=parseInt(list[8]);
			this.streamDirect=parseInt(list[9]);
			this.streamSpeed=parseInt(list[10]);
		}

		public function toString():String
		{
			return this.name + "," + this.x + "," + this.y + "," + this.width + "," + this.height + "," + (this.atBottom ? 1 : 0) + "," + this.waveHeight + "," + this.waveLength + "," + this.waveBreadth + "," + this.streamDirect + "," + this.streamSpeed;
		}
	}
}
