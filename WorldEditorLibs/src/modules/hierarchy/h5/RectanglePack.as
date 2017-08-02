package modules.hierarchy.h5
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	
	import modules.hierarchy.node.RectangleID;
	
	import render.ground.TerrainEditorData;

	public class RectanglePack
	{
		public function RectanglePack()
		{
		}

		public function get packId():int
		{
			return _packId;
		}

		public function set packId(value:int):void
		{
			_packId = value;
		}

		private var _callBack:Function;
		private var _packId:int;
		public var rects:Vector.<RectangleID>;
		public function pack($rects:Vector.<RectangleID>,id:int,$fun:Function):void{
			this._callBack = $fun;
			this._packId = id;
			$rects.sort(function (r1:RectangleID,r2:RectangleID):int{
				return r2.area - r1.area;
			});
			
			this.rects = $rects;
			
			var baseSize:int = 128;
			var half:Boolean = true;
			
			for(var i:int=0;i<10;i++){
				var node:PackNode = new PackNode(baseSize);
				node.isHalf = true;
				half = true;
				if (node.assign(cloneAry($rects))){
					break;
				}
				
				node = new PackNode(baseSize);
				node.isHalf = false;
				half = false;
				if (node.assign(cloneAry($rects))){
					break;
				}
				
				baseSize *= 2;
				
			}
			
			//trace("合并纹理大小：" + baseSize);
			this.drawBitmap(half,baseSize,$rects);
			
			return;
			
			
		}
		public var bitmapdata:BitmapData;
		public var loadComplte:int;
		public var allComplte:int;
		public function drawBitmap(half:Boolean,size:int,$rects:Vector.<RectangleID>):void{
			loadComplte = 0;
			allComplte = $rects.length;
			bitmapdata = new BitmapData(size,half?size/2:size,false,0);
			for(var i:int=0;i<$rects.length;i++){
				//var color:uint = 0xffffff * Math.random();
				//var bp:BitmapData = new BitmapData($rects[i].width,$rects[i].width,false,color);
				//bitmapdata.copyPixels(bp,new Rectangle(0,0,$rects[i].width,$rects[i].width),new Point($rects[i].x,$rects[i].y));
				
				var loadinfo:LoadInfo = new LoadInfo(TerrainEditorData.fileRoot+"lightuv/"+"build"+$rects[i].id + ".jpg",
					LoadInfo.BITMAP,this.loadBitMapCom,0,$rects[i]);
				LoadManager.getInstance().load(loadinfo);
			}
			
			
			
			
		}
		
		public function loadBitMapCom($bitmap:Bitmap,rec:RectangleID):void{
			bitmapdata.copyPixels($bitmap.bitmapData,new Rectangle(0,0,rec.width,rec.width),new Point(rec.x,rec.y));
			loadComplte++;
			if(loadComplte == allComplte){
				this._callBack(this._packId,bitmapdata);
//				var jpg:JPEGEncoder = new JPEGEncoder(100);
//				var byte:ByteArray = jpg.encode(bitmapdata);
//				
//				var file:File = new File(File.desktopDirectory.url + "/testbitmap/" + Math.random() + ".jpg");
//				var fs:FileStream = new FileStream();
//				fs.open(file,FileMode.WRITE);
//				fs.writeBytes(byte);
//				fs.close();
			}
			
		}
		
		public function cloneAry($rects:Vector.<RectangleID>):Vector.<RectangleID>{
			var newAry:Vector.<RectangleID> = new Vector.<RectangleID>;
			for(var i:int=0;i<$rects.length;i++){
				newAry.push($rects[i]);
			}
			return newAry;
		}
		
	}
}

import modules.hierarchy.node.RectangleID;

class PackNode{
	public var isRootNode:Boolean;
	public var isHalf:Boolean;
	public var sunList:Vector.<PackNode>;
	public var parent:PackNode;
	public var size:int = 128;
	public var x:int=0;
	public var y:int=0;
	public var rec:RectangleID;
	
	public function PackNode($size:int)
	{
		this.size = $size;
	}
	
	public function assign($rects:Vector.<RectangleID>):Boolean{
		if($rects.length == 0){
			return true;
		}
		if(this.isHalf){
			this.sunList = new Vector.<PackNode>(2);
		}else{
			this.sunList = new Vector.<PackNode>(4);
		}
		if(this.size == $rects[0].width){
			$rects[0].x = x;
			$rects[0].y = y;
			this.rec = $rects[0];
			$rects.shift();
			return false;
		}
		if(this.size == 128){
			return false;
		}
		
		for(var i:int=0;i<this.sunList.length;i++){
			var sun:PackNode = new PackNode(size/2);
			if(i==0){
				sun.x = this.x;
				sun.y = this.y;
			}else if(i == 1){
				sun.x = this.x + size/2;
				sun.y = this.y;
			}else if(i == 2){
				sun.x = this.x;
				sun.y = this.y + size/2;
			}else if(i == 3){
				sun.x = this.x + size/2;
				sun.y = this.y + size/2;
			}
			sun.assign($rects);
		}
		
		if($rects.length == 0){
			return true;
		}else{
			return false;
		}
	}
	
}

