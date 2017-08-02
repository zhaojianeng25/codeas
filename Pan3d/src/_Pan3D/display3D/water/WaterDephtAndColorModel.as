package _Pan3D.display3D.water
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.Program3D;
	import flash.display3D.textures.RectangleTexture;
	import flash.geom.Vector3D;
	
	import _Pan3D.base.ObjData;
	import _Pan3D.program.Program3DManager;
	
	import _me.Scene_data;

	public class WaterDephtAndColorModel
	{
		private static var _objData:ObjData;
		private static var _program3D:Program3D;
		
		public static function TextureAdd(top:RectangleTexture, bottom:RectangleTexture,$bmpW:uint=128,$bmpH:uint=128):BitmapData
		{
			var _context3D:Context3D = Scene_data.context3D;
			if(!_program3D)
			{
				makeObjData();
				Program3DManager.getInstance().registe(WaterDephtAndColorShader.WATER_DEPHTAND_COLOR_SHADER,WaterDephtAndColorShader);
				_program3D = Program3DManager.getInstance().getProgram(WaterDephtAndColorShader.WATER_DEPHTAND_COLOR_SHADER);
			}
			var $bmp:BitmapData=new BitmapData($bmpW,$bmpH,true)
			_context3D.configureBackBuffer($bmp.width, $bmp.height,0, true);
			_context3D.clear(0,0,0,0);
			
			_context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA,Context3DBlendFactor.ONE);
			_context3D.setProgram(_program3D);
			setVc();
			setVa(); 
			resetVa();
			function setVa():void 
			{
				_context3D.setVertexBufferAt(0, _objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
				_context3D.setVertexBufferAt(1, _objData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
				_context3D.setTextureAt(0, top);
				_context3D.setTextureAt(1, bottom);
				_context3D.drawTriangles(_objData.indexBuffer, 0, -1);
		
			}
			function resetVa() : void 
			{
				_context3D.setVertexBufferAt(0, null);
				_context3D.setVertexBufferAt(1, null);
				_context3D.setTextureAt(0,null);
				_context3D.setTextureAt(1,null);
			}
			function setVc() : void 
			{
				_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,Vector.<Number>([1,1,1,1]));
			}
	
			_context3D.drawToBitmapData($bmp)
			return $bmp
		}
		
		private static function makeObjData():void
		{
			_objData = new ObjData;
			var a:Vector3D = new Vector3D(-1,1,0);
			var b:Vector3D = new Vector3D(1,-1,0);
			
			var v:Array=
				[a.x, a.y, a.z,
					a.x, b.y, b.z, 
					b.x, b.y, b.z, 
					b.x, a.y, a.z];
			var u:Array=
				[0, 0,
					0, 1,  
					1, 1,  
					1, 0];
			var k : Array = [0, 2, 3, 0, 1, 2];
			
			_objData.vertices=new Vector.<Number>;
			var id:uint=0;
			for(id=0;id<v.length;id++)
			{
				_objData.vertices.push(v[id]);
			}
			_objData.uvs=new Vector.<Number>;
			for(id=0;id<u.length;id++)
			{
				_objData.uvs.push(u[id]);
			}
			_objData.indexs=new Vector.<uint>;
			for(id=0;id<k.length;id++)
			{
				_objData.indexs.push(k[id]);
			}
			uplodToGpu();
		}
		
		private static function uplodToGpu() : void 
		{
			var _context3D:Context3D=Scene_data.context3D;
			_objData.vertexBuffer = _context3D.createVertexBuffer(_objData.vertices.length / 3, 3);
			_objData.vertexBuffer.uploadFromVector(Vector.<Number>(_objData.vertices), 0, _objData.vertices.length / 3);
			
			_objData.uvBuffer = _context3D.createVertexBuffer(_objData.uvs.length / 2, 2);
			_objData.uvBuffer.uploadFromVector(Vector.<Number>(_objData.uvs), 0, _objData.uvs.length / 2);
			
			_objData.indexBuffer = _context3D.createIndexBuffer(_objData.indexs.length);
			_objData.indexBuffer.uploadFromVector(Vector.<uint>(_objData.indexs), 0, _objData.indexs.length);
		}
		
	}
}


