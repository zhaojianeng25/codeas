package modules.hierarchy.node
{
	import flash.display.Sprite;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import mx.controls.Alert;
	
	import _Pan3D.display3D.ground.GroundEditorSprite;
	import _Pan3D.display3D.navMesh.NavMeshLevel;
	
	import common.utils.ui.file.FileNode;
	
	import modules.hierarchy.HierarchyFileNode;
	import modules.hierarchy.HierarchyNodeType;
	
	import proxy.pan3d.ground.ProxyPan3dGround;
	import proxy.top.ground.IGround;
	
	import render.ground.GroundManager;
	
	import terrain.GroundData;

	public class SceneQuadTree
	{
		private var recList:Vector.<RectangleID> = new Vector.<RectangleID>;
		public var tempRecList:Array = new Array;
		private var rootNode:QuadTreeNode;
		
		public function SceneQuadTree()
		{
		}
		
		public function setHierarchy($arr:Vector.<FileNode>):Object
		{
			var ma:Matrix3D = new Matrix3D;
			for(var i:int=0;i<$arr.length;i++){
				var $hierarchyFileNode:HierarchyFileNode = $arr[i] as HierarchyFileNode;
				if($hierarchyFileNode.type == HierarchyNodeType.Prefab){
					if($hierarchyFileNode.iModel){
					}else{
						 Alert.show($hierarchyFileNode.name+"没有这个文件")
						return null;
						 
					}
					
					var vers:Vector.<Number> = $hierarchyFileNode.iModel.readObject.vertices;
					ma.identity();
					ma.appendScale($hierarchyFileNode.iModel.scaleX,$hierarchyFileNode.iModel.scaleY,$hierarchyFileNode.iModel.scaleZ);
					ma.appendRotation($hierarchyFileNode.iModel.rotationX , Vector3D.X_AXIS);
					ma.appendRotation($hierarchyFileNode.iModel.rotationY , Vector3D.Y_AXIS);
					ma.appendRotation($hierarchyFileNode.iModel.rotationZ , Vector3D.Z_AXIS);
					ma.appendTranslation($hierarchyFileNode.iModel.x,$hierarchyFileNode.iModel.y,$hierarchyFileNode.iModel.z);
					var rec:RectangleID = this.getMaxPoint(vers,ma);
					rec.id = $hierarchyFileNode.id;
					rec.type = HierarchyNodeType.Prefab;
					recList.push(rec);
				}else if($hierarchyFileNode.type == HierarchyNodeType.Particle){
					rec = new RectangleID($hierarchyFileNode.iModel.x,$hierarchyFileNode.iModel.y,1,1,$hierarchyFileNode.iModel.z,1);
					rec.id = $hierarchyFileNode.id;
					rec.type = HierarchyNodeType.Particle;
					recList.push(rec);
				}
			}
			if(GroundData.showTerrain){
				var groundId:Number=0
				for each(var $IGround:IGround in GroundManager.getInstance().groundItem)
				{
					var $ProxyPan3dGround:ProxyPan3dGround=$IGround as ProxyPan3dGround;
					var $groundEditorSprite:GroundEditorSprite=$ProxyPan3dGround.ground
				
					var recB:RectangleID = this.getMaxPoint( $ProxyPan3dGround.terrainData.vertices,$groundEditorSprite.modelMatrix);
					recB.id = groundId++
					recB.type = HierarchyNodeType.Ground;
					recList.push(recB);
				}
				
			}
			this.setRecList();
			this.processNode();
			this.draw3D();
			return this.rootNode.getData();
		}
		
		public function setRecList():void{
			for(var i:int=0;i<this.recList.length;i++){
				var rec:RectangleID = this.recList[i];
				var obj:Object = new Object;
				obj.x = rec.x;
				obj.y = rec.y;
				obj.z = rec.z;
				
				obj.width = rec.width;
				obj.height = rec.height;
				obj.depth = rec.depth;
				this.tempRecList.push(obj);
			}
		}
		
		
		
		private function processNode():void{
			this.rootNode = new QuadTreeNode();
			this.getEdge();
			this.rootNode.dataList = this.recList;
			this.rootNode.creatSun();

			//this.draw();
			
			this.rootNode.assign();
			
			this.rootNode.clearRootNode();
			
			this.rootNode.minNode();
			
			//this.rootNode.draw(sp);
		}
		
		private function getEdge():void{
			var maxX:Number = 0;
			var minX:Number = 0;
			
			var maxY:Number = 0;
			var minY:Number = 0;
			
			var maxZ:Number = 0;
			var minZ:Number = 0;
			
			for(var i:int=0;i<this.recList.length;i++){
				var x1:Number = this.recList[i].x;
				var x2:Number = this.recList[i].x + this.recList[i].width;
				
				var y1:Number = this.recList[i].y;
				var y2:Number = this.recList[i].y + this.recList[i].height;
				
				var z1:Number = this.recList[i].z;
				var z2:Number = this.recList[i].z + this.recList[i].depth;
				
				minX = Math.min(x1,minX);
				maxX = Math.max(x2,maxX);
				
				minY = Math.min(y1,minY);
				maxY = Math.max(y2,maxY);
				
				minZ = Math.min(z1,minZ);
				maxZ = Math.max(z2,maxZ);
				
			}
			
			var w:Number = Math.max(Math.abs(minX),maxX);
			var h:Number = Math.max(Math.abs(minZ),maxZ);
			w = Math.max(w,h) + 10;
			
			this.rootNode.x = -w;
			this.rootNode.z = -w;
			this.rootNode.y = minY - 10;
			this.rootNode.width = w*2;
			this.rootNode.depth = w*2;
			this.rootNode.height = maxY - minY + 10;
			
		}
		
		public function draw3D():void{
			NavMeshLevel.lineSprite.clear();
			//NavMeshLevel.lineSprite.makeLineMode(new Vector3D(0,0,0),new Vector3D(100,100,100))
			
			this.rootNode.drawNode();
			
			NavMeshLevel.lineSprite.reSetUplodToGpu()
		}

		private var sp:Sprite
		public function draw():void{
			sp = new Sprite();
			sp.graphics.clear();
			sp.graphics.beginFill(0,1);
			sp.graphics.drawRect(this.rootNode.x,this.rootNode.y,this.rootNode.width,this.rootNode.height);
			sp.graphics.endFill();
			for(var i:int=0;i<this.recList.length;i++){
				//sp.graphics.lineStyle(1,0xffffff * Math.random(),0.5);
				sp.graphics.beginFill(0xffffff * Math.random(),0.5);
				sp.graphics.drawRect(this.recList[i].x,this.recList[i].y,this.recList[i].width,this.recList[i].height);
			}
			
			sp.graphics.endFill();
			sp.graphics.lineStyle(1,0x00ffff);
			sp.graphics.drawCircle(0,0,200);
			sp.graphics.endFill();

			//Scene_data.stage.addChild(sp);
			var sc:Number = 0.5;
			sp.scaleX = sp.scaleY = sc;
			sp.x -= this.rootNode.x * sc ;
			sp.y -= this.rootNode.y * sc;
		}
		
		
		
		public function getMaxPoint(vers:Vector.<Number>,ma:Matrix3D):RectangleID{
			var posAry:Vector.<Vector3D> = new Vector.<Vector3D>;
			var maxX:Number = int.MIN_VALUE;
			var minX:Number = int.MAX_VALUE;
			
			var maxY:Number = int.MIN_VALUE;
			var minY:Number = int.MAX_VALUE;
			
			var maxZ:Number = int.MIN_VALUE;
			var minZ:Number = int.MAX_VALUE;
			
			for(var i:int;i<vers.length;i+=3){	
				var pos:Vector3D = new Vector3D(vers[i],vers[i+1],vers[i+2]);
				pos = ma.transformVector(pos);
				
				if(maxX < pos.x){
					maxX = pos.x;
				}
				if(minX > pos.x){
					minX = pos.x;
				}
				
				if(maxY < pos.y){
					maxY = pos.y;
				}
				if(minY > pos.y){
					minY = pos.y;
				}
				
				if(maxZ < pos.z){
					maxZ = pos.z;
				}
				if(minZ > pos.z){
					minZ = pos.z;
				}
				
			}
			var rec:RectangleID = new RectangleID();
			rec.x = minX;
			rec.y = minY;
			rec.z = minZ;
			rec.width = maxX - minX;
			rec.height = maxY - minY;
			rec.depth = maxZ - minZ;
			
			return rec;
			
		}
		
	}
}