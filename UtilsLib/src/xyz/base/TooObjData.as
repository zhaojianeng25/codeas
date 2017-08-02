package  xyz.base
{
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;


	public class TooObjData
	{
		public var uid:uint;
		public var vertices:Vector.<Number>;
		public var normals:Vector.<Number>;
		public var uvs:Vector.<Number>;
		public var lightUvs:Vector.<Number>;
		public var indexs:Vector.<uint>;
		public var mtl:String;
		
		public var vertexBuffer:VertexBuffer3D;
		public var uvBuffer:VertexBuffer3D;
		public var lightUvsBuffer:VertexBuffer3D;
		public var normalsBuffer:VertexBuffer3D;
		public var indexBuffer:IndexBuffer3D;
		
	
		public function TooObjData()
		{
			
		}
		public function dispose():void
		{
			
		}
	
		
	}
}