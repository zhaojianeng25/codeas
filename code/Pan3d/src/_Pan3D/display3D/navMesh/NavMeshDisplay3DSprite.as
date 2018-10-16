package _Pan3D.display3D.navMesh
{
	import flash.display3D.Context3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import PanV2.xyzmove.lineTriV2.UtilDisplay;
	
	import navMesh.NavMeshStaticMesh;
	
	import xyz.draw.TooMultipleLineTri3DSprite;
	
	public class NavMeshDisplay3DSprite extends UtilDisplay
	{
		

		private var _lingSprite:TooMultipleLineTri3DSprite;
		public function NavMeshDisplay3DSprite($context3D:Context3D)
		{
			super($context3D);
			this._lingSprite=new TooMultipleLineTri3DSprite(this._context3D)
		}

		private var _item:Array

		public function get lingSprite():TooMultipleLineTri3DSprite
		{
			return _lingSprite;
		}

		public function set lingSprite(value:TooMultipleLineTri3DSprite):void
		{
			_lingSprite = value;
		}

		public function setNavMeshDataItem(arr:Array):void
		{
			_item=arr;
			this.refeshData()
		}
		private function updataItemSprite():void
		{
			for(var i:Number=0;i<_item.length;i++){
				for(var j:Number=0;j<_item[i].data.length;j++){
				
					NavMeshBoxDisplay3DSprite(_item[i].data[j]).update()
				}
			}
		
		}
		
		public function showNavMeshTriLine($item:Object,$baseVectItem:Vector.<Vector3D>):void
		{
		
			for(var i:Number=0;$item&&i<$item.length;i++){
				
				var a:Object=$item[i].pointA;
				var b:Object=$item[i].pointB;
				var c:Object=$item[i].pointC;
			
				_lingSprite.colorVector3d=new Vector3D(1,0,1,1)
				_lingSprite.makeLineMode(new Vector3D(a.x,getNerY(a),a.y),new Vector3D(b.x,getNerY(b),b.y))
				_lingSprite.makeLineMode(new Vector3D(a.x,getNerY(a),a.y),new Vector3D(c.x,getNerY(c),c.y))
				_lingSprite.makeLineMode(new Vector3D(b.x,getNerY(b),b.y),new Vector3D(c.x,getNerY(c),c.y))
				
			}
			function getNerY($p:Object):Number
			{
				var nearNmu:Number=100000
				var breakHeight:Number;
				for(var j:int=0;j<$baseVectItem.length;j++){
					var temp:Object=$baseVectItem[j]
					var dis:Number=Point.distance(new Point(temp.x,temp.z),new Point($p.x,$p.y))
					if(nearNmu>dis){
						nearNmu=dis
						breakHeight=temp.y
					}
				
				}
			   return breakHeight
			}
			
		
			
			this._lingSprite.reSetUplodToGpu()
		}
	

		public function makeNewLine($navMeshStaticMesh:NavMeshStaticMesh):void
		{
			var w: Number = $navMeshStaticMesh.heightItem.length;
			var h: Number = $navMeshStaticMesh.heightItem[0].length;
			var midu: Number = $navMeshStaticMesh.midu;
			var aPos: Vector3D = $navMeshStaticMesh.aPos;
			
			var vecItem: Vector.<Vector3D> = new Vector.<Vector3D>
			var ty: Number = 0;
			for (var i: Number = 0; i < w; i++) {
				for (var j: Number = 0; j < h; j++) {
					ty = $navMeshStaticMesh.heightItem[i][j];
					var pos: Vector3D = new Vector3D(i * midu, ty, j * midu);
					pos.x = pos.x + aPos.x;
					pos.z = pos.z + aPos.z;
					vecItem.push(pos);
					
					if (i < 2 || j < 2 || i > (w - 2) || j > (h - 2)) {
					//	$navMeshStaticMesh.astarItem[i][j] = 0  //特殊边缘为不可寻走
					}
					
				}
			}
			this._lingSprite.clear()
			this.refeshData()
	
			for (i = 0; i < w - 1; i++) {
				for (j = 0; j < h - 1; j++) {
					var a: Number = i * h + j;
					var b: Number = a + 1
					var c: Number = a + 1 + h
					var d: Number = a + h
					
					if ($navMeshStaticMesh.astarItem[i][j] == 1) {
						this._lingSprite.makeLineMode(vecItem[a], vecItem[b]);
						this._lingSprite.makeLineMode(vecItem[a], vecItem[d]);
						
						if ($navMeshStaticMesh.astarItem[i + 1][j] == 0) {
							this._lingSprite.makeLineMode(vecItem[c], vecItem[d]);
						}
						if ($navMeshStaticMesh.astarItem[i][j + 1] == 0) {
							this._lingSprite.makeLineMode(vecItem[b], vecItem[c]);
						}
					}
				}
			}
			this._lingSprite.reSetUplodToGpu()
				
			
		}
	
		
	
		public function refeshData():void
		{
			this._lingSprite.clear()
			this._lingSprite.colorVector3d=new Vector3D(1,1,1,1)
			this._lingSprite.thickness=5
			for(var i:Number=0;i<_item.length;i++){
				for(var j:Number=0;j<_item[i].data.length;j++){
					
					var dis1:NavMeshBoxDisplay3DSprite=NavMeshBoxDisplay3DSprite(_item[i].data[j])
					var dis2:NavMeshBoxDisplay3DSprite
					if(j==_item[i].data.length-1){
						 dis2=NavMeshBoxDisplay3DSprite(_item[i].data[0])	
					}else{
						 dis2=NavMeshBoxDisplay3DSprite(_item[i].data[j+1])	
					}

					_lingSprite.makeLineMode(new Vector3D(dis1.x,dis1.y,dis1.z),new Vector3D(dis2.x,dis2.y,dis2.z))
				}
			}
			
			
			this._lingSprite.reSetUplodToGpu()
		}


		override public function update() : void {
		
			
			if(!_visible){
				return 
			}
				this.updataItemSprite()
				this._lingSprite.update()
			
		}
	}
}