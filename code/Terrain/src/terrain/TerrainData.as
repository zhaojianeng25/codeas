package terrain
{
	import flash.display.BitmapData;
	import flash.geom.Vector3D;

	public class TerrainData
	{
		public var vertices:Vector.<Number>;
		public var normals:Vector.<Number>;
		public var uvs:Vector.<Number>;
		public var indexs:Vector.<uint>;
		
		public var nodeList:Vector.<Vector.<GroundNode>>;
		
		public var area_Size:Number
		public var area_Cell_Num:int;
		
		public var normalMap:BitmapData;
		
		public var cellX:uint
		public var cellZ:uint
		public var positon:Vector3D
		
		
		public function TerrainData()
		{
			
		}
		
		
	}
}