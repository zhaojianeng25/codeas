package exph5
{
	import flash.display.BitmapData;

	public class ExpVideoBmpVo
	{
		public var nodeId:Number
		public var bmp:BitmapData
		public var lightuvSize:Number
		
		public function ExpVideoBmpVo($nodeId:Number,$bmp:BitmapData,$lightuvSize:Number)
		{
			this.nodeId=$nodeId;
			this.bmp=$bmp;
			this.lightuvSize=$lightuvSize;
		}
	}
}