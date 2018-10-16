package _Pan3D.scene.postprocess
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.Program3D;
	import flash.display3D.textures.TextureBase;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import _Pan3D.base.ObjData;
	
	import _me.Scene_data;

	public class PostBaseRender
	{
		protected var _objData:ObjData; 
		protected var _context3D:Context3D; 
		public var texture:TextureBase;
		protected var _program:Program3D;
		public function PostBaseRender(context3d:Context3D)
		{
			_context3D = context3d;
			makeObjData();
		}
		
		public function update():void{
			
		}
		
		protected function render():void{
			setVc();
			setVa();
			resetVa();
		}
		
		protected function setVa() : void {
		}
		protected function resetVa() : void {
		}
		protected function setVc() : void {
		}
		
		private function  makeObjData():void
		{
			_objData=new ObjData;
			var a:Vector3D=new Vector3D(-1,1,0);
			var b:Vector3D=new Vector3D(1,-1,0);
			
			var v : Array=
				[a.x, a.y, a.z,
					a.x, b.y, b.z, 
					b.x, b.y, b.z, 
					b.x, a.y, a.z];
			var u : Array=
				[0, 0,
					0, 1,  
					1, 1,  
					1, 0];
			var k : Array = [0, 2, 3, 0, 1, 2];
			
			_objData.vertices=new Vector.<Number>;
			var id:uint=0;
			for(id=0;id<v.length;id++){
				_objData.vertices.push(v[id])
			}
			_objData.uvs=new Vector.<Number>;
			for(id=0;id<u.length;id++){
				_objData.uvs.push(u[id])
			}
			_objData.indexs=new Vector.<uint>;
			for(id=0;id<k.length;id++){
				_objData.indexs.push(k[id])
			}
			uplodToGpu();
		}
		private function uplodToGpu() : void {
			var _context3D:Context3D=Scene_data.context3D
			_objData.vertexBuffer = _context3D.createVertexBuffer(_objData.vertices.length / 3, 3);
			_objData.vertexBuffer.uploadFromVector(Vector.<Number>(_objData.vertices), 0, _objData.vertices.length / 3);
			
			_objData.uvBuffer = _context3D.createVertexBuffer(_objData.uvs.length / 2, 2);
			_objData.uvBuffer.uploadFromVector(Vector.<Number>(_objData.uvs), 0, _objData.uvs.length / 2);
			
			_objData.indexBuffer = _context3D.createIndexBuffer(_objData.indexs.length);
			_objData.indexBuffer.uploadFromVector(Vector.<uint>(_objData.indexs), 0, _objData.indexs.length);
			
		}
		
		
	}
}