package modules.hierarchy.node
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import _Pan3D.display3D.navMesh.NavMeshLevel;

	public class QuadTreeNode extends Rectangle
	{
		public var layer:int;
		public var parent:QuadTreeNode;
		public var sunNodeList:Vector.<QuadTreeNode>;
		public var z:Number;
		public var depth:Number;
		public var dataList:Vector.<RectangleID>;
		
		public var threshold:Number = 0.2;
		
		public function QuadTreeNode($x:Number=0,$y:Number=0,$width:Number=0,$height:Number=0)
		{
			super($x,$y,$width,$height);
			this.dataList = new Vector.<RectangleID>;
			
		}
		
		public function clearRootNode():void{
			if(!this.sunNodeList){
				return;
			}
			if(!this.hasData()){
				this.sunNodeList = null;
			}else{
				for(var i:int=0;i<this.sunNodeList.length;i++){
					this.sunNodeList[i].clearNode();
				}
			}
		}
		
		public function clearNode():void{
			if(!this.sunNodeList){
				return;
			}
			if(!this.hasData()){
				this.sunNodeList = null;
			}else{
				for(var i:int=0;i<this.sunNodeList.length;i++){
					this.sunNodeList[i].clearNode();
				}
			}
		}
		
		public function minNode():void{
			var maxNum:Number = 10000000;
			var minNum:Number = -10000000;
			var minV3d:Vector3D = new Vector3D(maxNum,maxNum,maxNum);
			var maxV3d:Vector3D = new Vector3D(minNum,minNum,minNum);
			
			this.getAabb(minV3d,maxV3d);
			
			this.x = minV3d.x;
			this.y = minV3d.y;
			this.z = minV3d.z;

			this.width = maxV3d.x - minV3d.x;
			this.height = maxV3d.y - minV3d.y;
			this.depth = maxV3d.z - minV3d.z;
			
			if(sunNodeList){
				for(var i:int=0;i<this.sunNodeList.length;i++){
					this.sunNodeList[i].minNode();
				}
			}
		
		}
		
		public function getAabb(minV3d:Vector3D,maxV3d:Vector3D):void{
			for(var i:int=0;i<this.dataList.length;i++){
				var rec:RectangleID = this.dataList[i];
				if(rec.x < minV3d.x){
					minV3d.x  = rec.x;
				}
				if(rec.y < minV3d.y){
					minV3d.y  = rec.y;
				}
				if(rec.z < minV3d.z){
					minV3d.z  = rec.z;
				}
				
				if(rec.x + rec.width > maxV3d.x){
					maxV3d.x = rec.x + rec.width;
				}
				if(rec.y + rec.height > maxV3d.y){
					maxV3d.y = rec.y + rec.height;
				}
				if(rec.z + rec.depth > maxV3d.z){
					maxV3d.z = rec.z + rec.depth;
				}
				
			}
			
			
			if(sunNodeList){
				for(i=0;i<this.sunNodeList.length;i++){
					this.sunNodeList[i].getAabb(minV3d,maxV3d);
				}
			}
			
		}
		
		public function hasData():Boolean{
//			if(!this.sunNodeList){
//				return this.dataList.length == 0 ? false : true;
//			}
			
			if(this.dataList.length > 0){
				return true;
			}
			
			if(!this.sunNodeList){
				return false;
			}
			
			
			var tf:Boolean = false;
			for(var i:int=0;i<this.sunNodeList.length;i++){
				if(this.sunNodeList[i].hasData()){
					tf = true; 
				}
			}
			
			return tf;
			
		}
		
		
		
		public function assign():void{
			//this.creatSun();
			if(!this.sunNodeList){
				return;
			}
			var ary:Vector.<RectangleID> = this.dataList;
			var needReduceList:Array = new Array;
			for(var j:int=0;j<this.sunNodeList.length;j++){
				var sunNode:QuadTreeNode = this.sunNodeList[j];
				
				for(var i:int=ary.length-1;i >= 0;i--){
					var type:int = sunNode.test(ary[i]);
					if(ary[i].id == 8){
						trace("-----")
					}
					if(type == 2){
						sunNode.dataList.push(ary[i]);
						needReduceList.push(ary[i]);
					}else if(type == 1){
//						var size:int = ary[i].width * ary[i].height;
//						if(size < this.areaSize * this.threshold){
//							var interRec:Rectangle = sunNode.intersection(ary[i]);
//							getSide(interRec,sunNode,ary[i]);
//							sunNode.dataList.push(ary[i]);
//							needReduceList.push(ary[i]);
//						}
					}
					
					
				}
				
			}
			
			for(var k:int=0;k<needReduceList.length;k++){
				var index:int = ary.indexOf(needReduceList[k]);
				if(index != -1){
					ary.splice(index,1);
				}
			}
			
			for(i=0;i<this.sunNodeList.length;i++){
				this.sunNodeList[i].assign();
			}

		}
		
		public function getData():Object{
			var obj:Object = new Object;
			obj.layer = this.layer;
			obj.x = this.x;
			obj.y = this.y;
			obj.z = this.z;
			obj.width = this.width;
			obj.height = this.height;
			obj.depth = this.depth;
			var dataAry:Array;
			
			if(this.dataList.length){
				dataAry = new Array;
				for(var i:int=0;i<this.dataList.length;i++){
					dataAry.push({id:dataList[i].id,type:dataList[i].type,x:dataList[i].x,y:dataList[i].y,z:dataList[i].z,
						width:dataList[i].width,height:dataList[i].height,depth:dataList[i].depth});
					if(dataList[i].id == 8){
						trace("------")
					}
				}
				obj.data = dataAry;
			}
			
			
			if(this.sunNodeList){
				var sunAry:Array = new Array;
				for(i=0;i<this.sunNodeList.length;i++){
					this.sunNodeList[i].getData();
					sunAry.push(this.sunNodeList[i].getData());
				}
				obj.sun = sunAry;
			}
			
			return obj;
		}
		
		private function getSide(interRec:Rectangle,sunNode:QuadTreeNode,rec:Rectangle):void{
			if(Math.abs(interRec.x - sunNode.x) < 5){ // 左边
				sunNode.left = rec.x;
			}
			if(Math.abs(interRec.y - sunNode.y) < 5){// 上边
				sunNode.top = rec.y;
			}
			if(Math.abs(interRec.right - sunNode.right) < 5){// 右边
				sunNode.width += (rec.width - interRec.width);
			}

			if(Math.abs(interRec.bottom - sunNode.bottom) < 5){// 右边
				sunNode.height += (rec.height - interRec.height);
			}
			
		}
		
		public function get areaSize():int{
			return this.width * this.height;
		}
		
		
		public function test(rec:RectangleID):int{
			var me:RectangleID = new RectangleID(this.x,this.y,this.width,this.height,this.z,this.depth);
			if(me.intersectsRec(rec)){
				if(me.containsRect3D(rec)){
					return 2;
				}
				return 1;
			}else{
				return 0
			}
		}
		
		public function creatSun():void{
			if(this.layer == 3){
				return;
			}
			this.sunNodeList = new Vector.<QuadTreeNode>;
			var s1:QuadTreeNode = new QuadTreeNode();
			s1.x = this.x;
			s1.y = this.y;
			s1.z = this.z;
			this.sunNodeList.push(s1);
			
			var s2:QuadTreeNode = new QuadTreeNode();
			s2.x = this.x + width/2;
			s2.y = this.y;
			s2.z = this.z;
			this.sunNodeList.push(s2);
			
			var s3:QuadTreeNode = new QuadTreeNode();
			s3.x = this.x + width/2;
			s3.y = this.y;
			s3.z = this.z + depth/2;
			this.sunNodeList.push(s3);
			
			var s4:QuadTreeNode = new QuadTreeNode();
			s4.x = this.x;
			s4.y = this.y;
			s4.z = this.z + depth/2;
			this.sunNodeList.push(s4);
			
			for(var i:int=0;i<this.sunNodeList.length;i++){
				this.sunNodeList[i].width = this.width/2;
				this.sunNodeList[i].height = this.height;
				this.sunNodeList[i].depth = this.depth/2;
				this.sunNodeList[i].layer = this.layer + 1;
				this.sunNodeList[i].creatSun();
			}
			
		}
		
		public function drawNode():void{
			this.drawRec(this);
			
			for(var i:int=0;i<this.dataList.length;i++){
				//this.drawRec(this.dataList[i]);
			}
			if(sunNodeList){
				for(i=0;i<this.sunNodeList.length;i++){
					this.sunNodeList[i].drawNode();
				}
			}
			
		}
		
		public function drawRec(obj:Object):void{
			
			var pos:Vector3D = new Vector3D(obj.x,obj.y,obj.z);
			var whd:Vector3D = new Vector3D(obj.width,obj.height,obj.depth);
			
			NavMeshLevel.lineSprite.makeLineMode(pos, new Vector3D(pos.x + whd.x, pos.y, pos.z));
			NavMeshLevel.lineSprite.makeLineMode(pos, new Vector3D(pos.x, pos.y, pos.z + whd.z));
			NavMeshLevel.lineSprite.makeLineMode(new Vector3D(pos.x + whd.x, pos.y, pos.z), new Vector3D(pos.x + whd.x, pos.y, pos.z + whd.z));
			NavMeshLevel.lineSprite.makeLineMode(new Vector3D(pos.x, pos.y, pos.z + whd.z), new Vector3D(pos.x + whd.x, pos.y, pos.z + whd.z));
			
			NavMeshLevel.lineSprite.makeLineMode(new Vector3D(pos.x, pos.y + whd.y, pos.z), new Vector3D(pos.x + whd.x, pos.y + whd.y, pos.z));
			NavMeshLevel.lineSprite.makeLineMode(new Vector3D(pos.x, pos.y + whd.y, pos.z), new Vector3D(pos.x, pos.y + whd.y, pos.z + whd.z));
			NavMeshLevel.lineSprite.makeLineMode(new Vector3D(pos.x + whd.x, pos.y + whd.y, pos.z), new Vector3D(pos.x + whd.x, pos.y + whd.y, pos.z + whd.z));
			NavMeshLevel.lineSprite.makeLineMode(new Vector3D(pos.x, pos.y + whd.y, pos.z + whd.z), new Vector3D(pos.x + whd.x, pos.y + whd.y, pos.z + whd.z));
			
			NavMeshLevel.lineSprite.makeLineMode(new Vector3D(pos.x, pos.y, pos.z), new Vector3D(pos.x, pos.y + whd.y, pos.z));
			NavMeshLevel.lineSprite.makeLineMode(new Vector3D(pos.x + whd.x, pos.y, pos.z), new Vector3D(pos.x + whd.x, pos.y + whd.y, pos.z));
			NavMeshLevel.lineSprite.makeLineMode(new Vector3D(pos.x, pos.y, pos.z + whd.z), new Vector3D(pos.x, pos.y + whd.y, pos.z + whd.z));
			NavMeshLevel.lineSprite.makeLineMode(new Vector3D(pos.x + whd.x, pos.y, pos.z + whd.z), new Vector3D(pos.x + whd.x, pos.y + whd.y, pos.z + whd.z));
		}
		
		public function draw(sp:Sprite):void{
			var color:uint;
			switch(this.layer)
			{
				case 0:
				{
					color = 0xff0000;
					break;
				}
				case 1:
				{
					color = 0x00ff00;
					break;
				}
				case 2:
				{
					color = 0x0000ff;
					break;
				}
				case 3:
				{
					color = 0xffff00;
					break;
				}
					
				default:
				{
					break;
				}
			}
			//if(this.layer == 3){
				sp.graphics.lineStyle(8 - this.layer * 2,color,1);
				sp.graphics.drawRect(this.x,this.y,this.width,this.height);
			//}
			
			sp.graphics.endFill();
			if(this.sunNodeList){
				for(var i:int=0;i<this.sunNodeList.length;i++){
					this.sunNodeList[i].draw(sp);
				}
			}
		}
	}
}