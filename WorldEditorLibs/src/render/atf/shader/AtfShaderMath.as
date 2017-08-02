package render.atf.shader
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	
	import _Pan3D.program.Program3DManager;
	
	import _me.Scene_data;
	
	import render.atf.AtfDisplay3DSprite;
	

	public class AtfShaderMath
	{
		private static var instance:AtfShaderMath;
		public function AtfShaderMath()
		{
		}
		public static function getInstance():AtfShaderMath{
			if(!instance){
				instance = new AtfShaderMath();
			}
			return instance;
		}
		public function updata(dp:AtfDisplay3DSprite,type:uint):void
		{
			switch(type)
			{
				case 0:
				{
					draw0(dp)
					break;
				}
				case 1:
				{
					draw1(dp)
					break;
				}
				case 2:
				{
					draw2(dp)
					break;
				}
					
				default:
				{
					break;
				}
			}
		
		}
		
		private function draw2(dp:AtfDisplay3DSprite):void
		{
			var _context:Context3D=Scene_data.context3D
			
			Program3DManager.getInstance().registe(AtfDx1Shader.ATF_DX1_SHADER,AtfDx1Shader)
			_context.setProgram(Program3DManager.getInstance().getProgram(AtfDx1Shader.ATF_DX1_SHADER));
			_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, dp.posMatrix, true);
			
			_context.setVertexBufferAt(0, dp.objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(1, dp.objData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			_context.setTextureAt(0,dp.atfTexture)
			_context.drawTriangles(dp.objData.indexBuffer, 0, -1);
			
			
			_context.setVertexBufferAt(0, null);
			_context.setVertexBufferAt(1, null);
			_context.setVertexBufferAt(2, null);
			_context.setTextureAt(0,null);
			
		}
		
		private function draw1(dp:AtfDisplay3DSprite):void
		{
			var _context:Context3D=Scene_data.context3D
			
			Program3DManager.getInstance().registe(AftMinTextureShader.AFT_MINTEXTURE_SHADER,AftMinTextureShader)
			_context.setProgram(Program3DManager.getInstance().getProgram(AftMinTextureShader.AFT_MINTEXTURE_SHADER));
			_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, dp.posMatrix, true);
			
			_context.setVertexBufferAt(0, dp.objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(1, dp.objData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			_context.setTextureAt(0,dp.minTexture)
			_context.drawTriangles(dp.objData.indexBuffer, 0, -1);
			
			
			_context.setVertexBufferAt(0, null);
			_context.setVertexBufferAt(1, null);
			_context.setVertexBufferAt(2, null);
			_context.setTextureAt(0,null);
			
		}
		
		private function draw0(dp:AtfDisplay3DSprite):void
		{
	
				var _context:Context3D=Scene_data.context3D
					
				Program3DManager.getInstance().registe(AtfDisplay3DShader.ATF_DISPLAY3D_SHADER,AtfDisplay3DShader)
				_context.setProgram(Program3DManager.getInstance().getProgram(AtfDisplay3DShader.ATF_DISPLAY3D_SHADER));
				_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, dp.posMatrix, true);
			
				_context.setVertexBufferAt(0, dp.objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
				_context.setVertexBufferAt(1, dp.objData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
				_context.setTextureAt(0,dp.baseTexture)
				_context.drawTriangles(dp.objData.indexBuffer, 0, -1);
				

				_context.setVertexBufferAt(0, null);
				_context.setVertexBufferAt(1, null);
				_context.setVertexBufferAt(2, null);
				_context.setTextureAt(0,null);
		
			
			
		}
	}
}