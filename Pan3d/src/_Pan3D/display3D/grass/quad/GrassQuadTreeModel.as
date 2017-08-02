package _Pan3D.display3D.grass.quad
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;

	public class GrassQuadTreeModel
	{
		private var _tree:QuadTree;
		private var _groundWidth:uint=500
		private var _groundHeight:uint=500
		private var _clikPos:Point=new Point
		public function GrassQuadTreeModel()
		{
			
		}
		public function set clikPos(value:Point):void
		{
			_clikPos = value;
		}

		public function set groundHeight(value:uint):void
		{
			_groundHeight = value;
		}

		public function set groundWidth(value:uint):void
		{
			_groundWidth = value;
		}

		public function makeTree(arr:Array,addPos:Vector3D):void
		{
			if(!addPos){
				addPos=new Vector3D
			}
			
			_tree = new QuadTree( 4 , new Rectangle(0,0,_groundWidth,_groundHeight));
			for(var i:uint=0;i<arr.length;i++){
				var model:Object = new Object();
				model.id=i;
				model.x = arr[i].x+addPos.x
				model.z = arr[i].z+addPos.z

	
				_tree.insertObj( model );
			}
		}
		public function drawNextRec($rec:Rectangle,$lod:uint,$baseArr:Vector.<Object>):Vector.<Object>
		{
			var $arr:Vector.<Object>=new Vector.<Object>
			var $dis:Number= distanceRecAndPoint($rec,_clikPos)
			
			if($baseArr.length){
				$arr.push($baseArr[uint($baseArr.length/2)])
			}
			if($dis>500){
				return $arr
			}
			if($lod>(8-uint(($dis/500)*8))){
				return $arr
			}
			if($lod>8){
				return $arr
			}
			$arr=new Vector.<Object>
			
			var rec0:Rectangle=new Rectangle($rec.x,$rec.y,$rec.width/2,$rec.height/2)
			var rec1:Rectangle=new Rectangle($rec.x+$rec.width/2,$rec.y,$rec.width/2,$rec.height/2)
			var rec2:Rectangle=new Rectangle($rec.x,$rec.y+$rec.height/2,$rec.width/2,$rec.height/2)
			var rec3:Rectangle=new Rectangle($rec.x+$rec.width/2,$rec.y+$rec.height/2,$rec.width/2,$rec.height/2)
			
			$lod++	
			
			var item0:Vector.<Object>=_tree.searchByRect(rec0,true)
			var item1:Vector.<Object>=_tree.searchByRect(rec1,true)
			var item2:Vector.<Object>=_tree.searchByRect(rec2,true)
			var item3:Vector.<Object>=_tree.searchByRect(rec3,true)
			if(item0.length>1){
				$arr=$arr.concat(drawNextRec(rec0,$lod,item0))
			}else
			{
				$arr=$arr.concat(item0)
			}
			if(item1.length>1){
				$arr=$arr.concat(drawNextRec(rec1,$lod,item1))
			}else
			{
				$arr=$arr.concat(item1)
			}
			if(item2.length>1){
				$arr=$arr.concat(drawNextRec(rec2,$lod,item2))
			}else
			{
				$arr=$arr.concat(item2)
			}
			if(item3.length>1){
				$arr=$arr.concat(drawNextRec(rec3,$lod,item3))
			}else
			{
				$arr=$arr.concat(item3)
			}
			return $arr
			
		}
		private function distanceRecAndPoint($rec:Rectangle,$p:Point):Number
		{
			if($p.x>=$rec.x&&$p.y>=$rec.y&&$p.x<($rec.x+$rec.width)&&$p.y<($rec.y+$rec.height)){
				return 0
			}
			var a:Point=new Point($rec.x,$rec.y)
			var b:Point=new Point($rec.x+$rec.width,$rec.y)
			var c:Point=new Point($rec.x,$rec.y+$rec.height)
			var d:Point=new Point($rec.x+$rec.width,$rec.y+$rec.height)
			
			var d0:Number=pointToLineDistance(a,b,$p)
			var d1:Number=pointToLineDistance(a,c,$p)
			var d2:Number=pointToLineDistance(b,d,$p)
			var d3:Number=pointToLineDistance(c,d,$p)
			return Math.min(d0,d1,d2,d3)
		}
		public function pointToLineDistance( p1:Point, p2:Point, p3:Point ) : Number 
		{
			var xDelta: Number = p2. x - p1. x ;
			var yDelta: Number = p2. y - p1. y ;
			if ( ( xDelta == 0 ) && ( yDelta == 0 ) ) {
				// p1 and p2 cannot be the same point
				p2. x += 1 ;
				p2. y += 1 ;
				xDelta = 1 ;
				yDelta = 1 ;
			}
			var u: Number = ( ( p3. x - p1. x ) * xDelta + ( p3. y - p1. y ) * yDelta ) / ( xDelta * xDelta + yDelta * yDelta ) ;
			var closestPoint:Point;
			if ( u < 0 ) {
				closestPoint = p1 ;
			} else if ( u > 1 ) {
				closestPoint = p2 ;
			} else {
				closestPoint = new Point ( p1. x + u * xDelta, p1. y + u * yDelta ) ;
			} 
			return Point.distance ( closestPoint, p3 ) ;
		}
	}
}
