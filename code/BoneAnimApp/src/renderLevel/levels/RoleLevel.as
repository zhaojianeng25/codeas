package renderLevel.levels
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Program3D;
	
	import mx.effects.Fade;
	
	import _Pan3D.display3D.Display3D;
	import _Pan3D.display3D.Display3DContainer;
	import _Pan3D.display3D.interfaces.IDisplay3D;
	import _Pan3D.program.Program3DManager;
	import _Pan3D.program.shaders.Md5Shader;
	import _Pan3D.program.shaders.StatShader;
	import _Pan3D.texture.TextureManager;
	
	import _me.Scene_data;
	
	import renderLevel.BaseMd5Shader;
	import renderLevel.Display3DMovieLocal;
	import renderLevel.Display3DTarget;
	import renderLevel.NewMd5Shader;
	
	import utils.ai.AIManager;

	public class RoleLevel
	{
		private var _display3DContainer:Display3DContainer;
		private var _context3D:Context3D;
		private var role:Display3DMovieLocal;
		public function RoleLevel()
		{
			_display3DContainer=new Display3DContainer();
			AppDataBone.roleContanier = _display3DContainer;
			_context3D=Scene_data.context3D;
			Program3DManager.getInstance().registe(BaseMd5Shader.BASEMD5SHADER,BaseMd5Shader);
			Program3DManager.getInstance().registe(NewMd5Shader.NewMd5Shader,NewMd5Shader);
			role = new Display3DMovieLocal(_context3D);
			_display3DContainer.addChild(role);
			var tmpeProgram3d:Program3D = Program3DManager.getInstance().getProgram(BaseMd5Shader.BASEMD5SHADER);
			//role.setProgram3D(tmpeProgram3d);
			//role.rotationY = 60;
			//role.x = 100;
			//role.z = 100;
			AppDataBone.role = role;
			
			
			AIManager.getInstance().init(_display3DContainer);
			
		}
		public function upData():void
		{
			_display3DContainer.update();
		}
		
		public function addChild($display:IDisplay3D):void{
			_display3DContainer.addChild($display);
		}
		
		public function removeChile($display:IDisplay3D):void{
			_display3DContainer.removeChild($display);
		}
		
	}
}