package _Pan3D.lineTri
{
	import _Pan3D.base.BaseLevel;
	import _Pan3D.program.Program3DManager;
	
	import _me.Scene_data;
	
	import flash.display3D.Program3D;
	import flash.geom.Vector3D;
	
	public class BallLine3DLevel extends BaseLevel
	{
		private var _lineSprite:LineTri3DSprite;
		
		public function BallLine3DLevel()
		{
			super();
		}
		
		override protected function initData():void
		{
			addLine();
		}
		override public function resetStage():void
		{
			_context3D=Scene_data.context3D;
			addShaders();
			_lineSprite.resetStage();
			var tmpeProgram3d:Program3D = Program3DManager.getInstance().getProgram(LineTri3DShader.LINE_TRI3D_SHADER);
			_lineSprite.setProgram3D(tmpeProgram3d);
		}
		override protected function addShaders():void
		{
			Program3DManager.getInstance().registe(LineTri3DShader.LINE_TRI3D_SHADER,LineTri3DShader);
		}
		protected function addLine():void
		{
			_lineSprite =new LineTri3DSprite(_context3D);
			_display3DContainer.addChild(_lineSprite);
			var tmpeProgram3d:Program3D = Program3DManager.getInstance().getProgram(LineTri3DShader.LINE_TRI3D_SHADER);
			_lineSprite.setProgram3D(tmpeProgram3d);
		}
		
		public function resetCircle(centre:Vector3D, range:Number):void
		{
			_display3DContainer.x = centre.x;
			_display3DContainer.y = centre.y;
			_display3DContainer.z = centre.z;
			_lineSprite.clear();
			makeCircle(new Vector3D(1, 0, 0), new Vector3D(0, 0, 1), range);
			makeCircle(new Vector3D(0, 0, 1), new Vector3D(0, 1, 0), range);
			makeCircle(new Vector3D(0, 1, 0), new Vector3D(1, 0, 0), range);
			_lineSprite.refreshGpu();
		}
		
		private function makeCircle(base:Vector3D, plus:Vector3D, range:Number, density:int = 32):void
		{
			var startPos:Vector3D = new Vector3D();
			startPos.x = base.x * range;
			startPos.y = base.y * range;
			startPos.z = base.z * range;
			var endPos:Vector3D = new Vector3D(-startPos.x, -startPos.y, -startPos.z);
			var color:Vector3D = new Vector3D(base.x + plus.x, base.y + plus.y, base.z + plus.z, 1);
			_lineSprite.makeLineMode(startPos, endPos, 0.2, color);
			var angle:Number = 0;
			var sin:Number = 0;
			var cos:Number = 0;
			for(var i:int = 0; i < density; i++)
			{
				angle = 2 * Math.PI * (1 + i) / density;
				sin = Math.sin(angle);
				cos = Math.cos(angle);
				endPos = new Vector3D();
				endPos.x = (base.x * cos + plus.x * sin) * range;
				endPos.y = (base.y * cos + plus.y * sin) * range;
				endPos.z = (base.z * cos + plus.z * sin) * range;
				_lineSprite.makeLineMode(startPos, endPos, 1, color);
				startPos = endPos;
			}
		}
		
	}
}