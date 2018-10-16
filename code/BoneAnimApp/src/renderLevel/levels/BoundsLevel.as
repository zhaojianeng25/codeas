package renderLevel.levels
{
	import _Pan3D.base.ObjectBound;
	import _Pan3D.display3D.Display3DContainer;
	import _Pan3D.lineTri.LineTri3DShader;
	import _Pan3D.lineTri.LineTri3DSprite;
	import _Pan3D.program.Program3DManager;
	import _Pan3D.program.shaders.Md5Shader;
	import _Pan3D.program.shaders.StatShader;
	
	import _me.Scene_data;
	
	import flash.display3D.Context3D;
	import flash.display3D.Program3D;
	import flash.geom.Vector3D;
	
	import renderLevel.BaseMd5Shader;
	import renderLevel.Display3DLineMovie;
	import renderLevel.Display3DMovieLocal;
	import renderLevel.Display3DTarget;

	public class BoundsLevel
	{
		private var _display3DContainer:Display3DContainer;
		private var _context3D:Context3D;
		private var _lineTri3DSprite:Display3DLineMovie;
		public function BoundsLevel()
		{
			_display3DContainer=new Display3DContainer();
			_context3D=Scene_data.context3D;
			_lineTri3DSprite=new Display3DLineMovie(_context3D);
			_display3DContainer.addChild(_lineTri3DSprite);
			
			Program3DManager.getInstance().registe(LineTri3DShader.LINE_TRI3D_SHADER,LineTri3DShader);
			var tmpeProgram3d:Program3D = Program3DManager.getInstance().getProgram(LineTri3DShader.LINE_TRI3D_SHADER);
			_lineTri3DSprite.setProgram3D(tmpeProgram3d);
			
			AppDataBone.boundsLevel = this;
		}
		
		public function upData():void
		{
			_display3DContainer.update();
		}
		
		public function refreshData(bounds:ObjectBound):void{
			_lineTri3DSprite.draw(bounds);
		}
		/**
		 * 通过数组 
		 * @param ary
		 * 
		 */		
		public function refreshDataByAry(ary:Vector.<Vector3D>):void{
			_lineTri3DSprite.drawByAry(ary);
		}
		
		public function clear():void{
			_lineTri3DSprite.clear();
//			/_lineTri3DSprite.refreshGpu();
		}
		
		
		
		
		
	}
}