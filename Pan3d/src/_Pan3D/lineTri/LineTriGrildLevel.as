package  _Pan3D.lineTri
{
	import flash.display3D.Program3D;
	import flash.geom.Vector3D;
	
	import _Pan3D.base.BaseLevel;
	import _Pan3D.base.MakeModelData;
	import _Pan3D.base.ObjData;
	import _Pan3D.display3D.Display3DSprite;
	import _Pan3D.program.Program3DManager;
	import _Pan3D.program.shaders.StatShader;
	import _Pan3D.texture.TextureManager;
	import _Pan3D.vo.texture.TextureVo;
	
	import _me.Scene_data;

	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class LineTriGrildLevel  extends BaseLevel
	{
		private var _lineGrldSprite:LineGrldSprite;

		public function LineTriGrildLevel()
		{
			super();

		}

		public function get lineGrldSprite():LineGrldSprite
		{
			return _lineGrldSprite;
		}

		public function set lineGrldSprite(value:LineGrldSprite):void
		{
			_lineGrldSprite = value;
		}

		public function setXyz(_p:Vector3D):void
		{
			_display3DContainer.x=_p.x;
			_display3DContainer.y=_p.y;
			_display3DContainer.z=_p.z;
		}
		override protected function initData():void
		{
			addLine();
			addPic()
		}
		private var _backPicSprite:Display3DSprite
		private function addPic():void
		{
			_backPicSprite=new Display3DSprite(Scene_data.context3D);
			_backPicSprite.objData=MakeModelData.makeJuXinTampData(new Vector3D(-100,0,100),new Vector3D(100,0,-100))
			uplodToGpu(_backPicSprite.objData)
			//_backPicSprite.objData.texture=TextureManager.getInstance().defaultLightTextVo.texture
			Program3DManager.getInstance().registe(StatShader.STATSHADER, StatShader)
			_backPicSprite.program=Program3DManager.getInstance().getProgram(StatShader.STATSHADER);
			_display3DContainer.addChild(_backPicSprite);

		}
		public function setBackUrl(value:String):void
		{
			_backPicSprite.objData.texture=null
			TextureManager.getInstance().addTexture(value, addTexture, null,0);
		}
		public function setBackScale(value:Number):void
		{
			_backPicSprite.scale=value
		}
		protected function addTexture(textureVo : TextureVo, info : Object) : void {
			_backPicSprite.objData.texture=textureVo.texture
		}
			
		
		protected function uplodToGpu(_objData:ObjData) : void {
			_context3D=Scene_data.context3D;
			_objData.vertexBuffer = _context3D.createVertexBuffer(_objData.vertices.length / 3, 3);
			_objData.vertexBuffer.uploadFromVector(Vector.<Number>(_objData.vertices), 0, _objData.vertices.length / 3);
			_objData.uvBuffer = _context3D.createVertexBuffer(_objData.uvs.length / 2, 2);
			_objData.uvBuffer.uploadFromVector(Vector.<Number>(_objData.uvs), 0, _objData.uvs.length / 2);
			_objData.indexBuffer = _context3D.createIndexBuffer(_objData.indexs.length);
			_objData.indexBuffer.uploadFromVector(Vector.<uint>(_objData.indexs), 0, _objData.indexs.length);
		}
		
		override public function resetStage():void
		{
			_context3D=Scene_data.context3D;
			addShaders();
			_lineGrldSprite.resetStage();
			var tmpeProgram3d:Program3D = Program3DManager.getInstance().getProgram(LineTri3DShader.LINE_TRI3D_SHADER);
			_lineGrldSprite.setProgram3D(tmpeProgram3d);
		}
		override protected function addShaders():void
		{
			Program3DManager.getInstance().registe(LineTri3DShader.LINE_TRI3D_SHADER,LineTri3DShader);
		}
		private function addLine():void
		{
			 _lineGrldSprite =new LineGrldSprite(_context3D);
			_lineGrldSprite.setLineData();
			_display3DContainer.addChild(_lineGrldSprite);
			var tmpeProgram3d:Program3D = Program3DManager.getInstance().getProgram(LineTri3DShader.LINE_TRI3D_SHADER);
			_lineGrldSprite.setProgram3D(tmpeProgram3d);
		}
	}
}