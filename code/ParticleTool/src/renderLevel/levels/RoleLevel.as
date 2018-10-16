package renderLevel.levels
{
	import _Pan3D.display3D.Display3DContainer;
	import _Pan3D.display3D.Display3dGameMovie;
	import _Pan3D.display3D.MovieAction;
	import _Pan3D.program.Program3DManager;
	import _Pan3D.program.shaders.Md5Shader;
	import _Pan3D.program.shaders.StatShader;
	import _Pan3D.role.AvatarParamData;
	
	import _me.Scene_data;
	
	import flash.display3D.Context3D;
	import flash.display3D.Program3D;
	import flash.utils.getTimer;
	
	import renderLevel.Display3DMovieLocal;
	import renderLevel.Display3DTarget;

	public class RoleLevel
	{
		private var _display3DContainer:Display3DContainer;
		private var _context3D:Context3D;
		private var role:Display3dGameMovie;
		public function RoleLevel()
		{
			_display3DContainer=new Display3DContainer();
			AppParticleData.roleContanier = _display3DContainer;
			_context3D=Scene_data.context3D;
			Program3DManager.getInstance().registe(Md5Shader.MD5SHADER,Md5Shader);
//			role = new Display3dGameMovie(_context3D);
//			_display3DContainer.addChild(role);
//			var tmpeProgram3d:Program3D = Program3DManager.getInstance().getProgram(Md5Shader.MD5SHADER);
//			role.setProgram3D(tmpeProgram3d);
			//role.rotationY = 60;
			//role.x = 100;
			//role.z = 100;
			//AppData.role = role;
			
//			var avatarList:Array = ["zid285"];
//			for(var i:int=0;i<avatarList.length;i++){
//				var apd1:AvatarParamData = new AvatarParamData(String(i), '0', "assets/testrole/" + avatarList[i] + "/");
//				role.addAvatarPart(apd1);
//			}
//			var movie:MovieAction = new MovieAction();
//			movie.name = MovieAction.STAND;
//			movie.url = "assets/testrole/aid286/stand.md5anim";
//			role.addAction(movie);
//			role.play("stand");
//			
//			role.visible = false;
//			ride = new Display3DMovieLocal(_context3D);
//			_display3DContainer.addChild(ride);
//			ride.setProgram3D(tmpeProgram3d);
//			AppData.ride = ride;
			
			
			
//			targetRole = new Display3DTarget(_context3D);
//			_display3DContainer.addChild(targetRole);
//			tmpeProgram3d = Program3DManager.getInstance().getProgram(StatShader.STATSHADER);
//			targetRole.setProgram3D(tmpeProgram3d);
//			AppData.targetRole = targetRole;
//			targetRole.z = 800;
//			targetRole.x = 0;
//			targetRole.y = 70;
//			targetRole.scale = 0.5;
//			targetRole.visible = false;
			time = getTimer();
		}
		private var time:int;
		public function upData():void
		{
			_display3DContainer.update();
//			var t:int = getTimer();
//			role.updateFrame(t - time);
//			time = t;
		}
	}
}