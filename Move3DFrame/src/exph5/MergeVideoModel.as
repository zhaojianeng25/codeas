package exph5
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import _me.Scene_data;
	
	import modules.hierarchy.h5.MaxRectsBinPack;

	public class MergeVideoModel
	{
		private static var instance:MergeVideoModel;
		private var BigLightBmp:BitmapData;
		public function MergeVideoModel()
		{
		}
		public static function getInstance():MergeVideoModel{
			if(!instance){
				instance = new MergeVideoModel();
			}
			return instance;
		}
		public function clear():void
		{
			this._frameLightUvItem=new Array;
		}
		public function playEnd():void
		{
			this.data=this._frameLightUvItem;
		}
		public var data:Array
		public function get videoLightUvData():Array
		{
			return data
		}
		private var  _frameLightUvItem:Array
		public function mathLightUvInfo($arr:Vector.<ExpVideoBmpVo>,$frameNum:Number):BitmapData
		{
			$arr.sort(upperCaseFunc);
			function upperCaseFunc(a:ExpVideoBmpVo,b:ExpVideoBmpVo):int{
				if(b.lightuvSize==a.lightuvSize){
					return b.nodeId-a.nodeId;
				}
				return b.lightuvSize-a.lightuvSize;
			}
			var $rects:Vector.<Rectangle> = new Vector.<Rectangle>();
			for(var i:uint=0;i<$arr.length;i++)
			{
				$rects.push(new Rectangle(0,0,$arr[i].lightuvSize,$arr[i].lightuvSize))
			}
			var $maxPos:Point=new Point
			var $endItem:Vector.<Rectangle>;
			if($arr.length>1){
				$endItem=MaxRectsBinPack.makeMin($rects)
			}else{
				$endItem=$rects;
			}
			for(var j:int = 0; j <$endItem.length; j++) {
				var endRect:Rectangle=$endItem[j]
				$maxPos.x=Math.max($maxPos.x,(endRect.x+endRect.width))
				$maxPos.y=Math.max($maxPos.y,(endRect.y+endRect.height))
			}
//			$maxPos.x=Math.pow(2,Math.ceil(Math.log($maxPos.x)/Math.log(2)))
//			$maxPos.y=Math.pow(2,Math.ceil(Math.log($maxPos.y)/Math.log(2)))
			var $temp:BitmapData=new BitmapData($maxPos.x,$maxPos.y,false,0xffffff);
			var $frameInfo:Array=new Array;
			for(var k:uint=0;k<$arr.length;k++)
			{
				var $m:Matrix=new Matrix();
				$m.scale($endItem[k].width/$arr[k].bmp.width,$endItem[k].height/$arr[k].bmp.height)
				$m.tx=$endItem[k].x;
				$m.ty=$endItem[k].y;
				$temp.draw($arr[k].bmp,$m);
				$frameInfo.push({id:$arr[k].nodeId,x:$endItem[k].x,y:$endItem[k].y,width:$endItem[k].width,height:$endItem[k].height})
			}
			this._frameLightUvItem.push($frameInfo);
		
			return $temp
		
		}
	}
}