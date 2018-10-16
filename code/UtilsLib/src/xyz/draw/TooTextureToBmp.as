package xyz.draw
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.Program3D;
	import flash.display3D.textures.TextureBase;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import xyz.base.TooAGALMiniAssembler;
	import xyz.base.TooObjData;

	public class TooTextureToBmp
	{
		private static var _objData:TooObjData;
		private static var _program3D:Program3D
		
		protected static function initProgram():void
		{
			
			_program3D = _context3D.createProgram();
			var assembler:TooAGALMiniAssembler = new TooAGALMiniAssembler;
			_program3D.upload(
				assembler.assemble(Context3DProgramType.VERTEX,
					
					"mov vo, va0 \n"+
					"mov vi1, va1"
					,TooMathMoveUint.agalLevel
				),
				assembler.assemble(Context3DProgramType.FRAGMENT,
					
					"tex ft0, vi1, fs0 <2d,nearest>\n"+
					"mov fo, ft0 "
					,TooMathMoveUint.agalLevel
				)
			);
		}
		private static var _context3D:Context3D
		public static function TextureToBitMapData($cont:Context3D,_texture:TextureBase,_backColor:Vector3D=null,_w:uint=512,_h:uint=512,_alpha:Boolean=true):BitmapData
		{
			var $backBmp:BitmapData=new BitmapData(_w,_h);
			_context3D=$cont
			if(!_objData||!_program3D){
				makeObjData()
				initProgram()
				
			}
			_context3D.configureBackBuffer($backBmp.width, $backBmp.height,0, true);
			if(_backColor){
				_context3D.clear(_backColor.x,_backColor.y,_backColor.z,_backColor.w);
			}else{
				_context3D.clear(1,1,1,1);
			}
			_context3D.setCulling(Context3DTriangleFace.FRONT);
			_context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
			_context3D.setProgram(_program3D);
			setVc();
			setVa(); 
			resetVa();
			function setVa() : void {
				_context3D.setVertexBufferAt(0, _objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
				_context3D.setVertexBufferAt(1, _objData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
				_context3D.setTextureAt(0, _texture);
				_context3D.drawTriangles(_objData.indexBuffer, 0, -1);
				
			}
			function resetVa() : void {
				_context3D.setVertexBufferAt(0, null);
				_context3D.setVertexBufferAt(1, null);
				_context3D.setTextureAt(0,null);
			}
			function setVc() : void {
				var $m:Matrix3D=new Matrix3D;
				_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,Vector.<Number>([0,0,0,1]));
			}
			_context3D.drawToBitmapData($backBmp);
			
			return $backBmp;
		}
		private static function  makeObjData():void
		{
			_objData=new TooObjData;
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
		private static function uplodToGpu() : void {
			
			_objData.vertexBuffer = _context3D.createVertexBuffer(_objData.vertices.length / 3, 3);
			_objData.vertexBuffer.uploadFromVector(Vector.<Number>(_objData.vertices), 0, _objData.vertices.length / 3);
			
			_objData.uvBuffer = _context3D.createVertexBuffer(_objData.uvs.length / 2, 2);
			_objData.uvBuffer.uploadFromVector(Vector.<Number>(_objData.uvs), 0, _objData.uvs.length / 2);
			
			_objData.indexBuffer = _context3D.createIndexBuffer(_objData.indexs.length);
			_objData.indexBuffer.uploadFromVector(Vector.<uint>(_objData.indexs), 0, _objData.indexs.length);
			
		}
	}
}


