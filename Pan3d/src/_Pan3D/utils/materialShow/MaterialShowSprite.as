package _Pan3D.utils.materialShow
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Vector3D;
	
	import _Pan3D.base.MakeModelData;
	import _Pan3D.display3D.analysis.AnalysisServer;
	import _Pan3D.display3D.ground.ModelHasDepthSprite;
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	import _Pan3D.program.Program3DManager;
	
	public class MaterialShowSprite extends ModelHasDepthSprite
	{
		public function MaterialShowSprite(context:Context3D)
		{
			super(context);
			
			Program3DManager.getInstance().registe(MaterialShowShader.TEXTURE_SHOW_SHADER,MaterialShowShader)
			program=Program3DManager.getInstance().getProgram(MaterialShowShader.TEXTURE_SHOW_SHADER)
			//initData();
		}
		
		private function initData():void
		{
			this.objData=MakeModelData.makeJuXinTampData(new Vector3D(-100,0,-100),new Vector3D(100,0,100))
			uplodToGpu();
		}
		override public function set url(value : String) : void {
			_url =value;
			var loaderinfo : LoadInfo = new LoadInfo(value, LoadInfo.XML, onObjLoad,0);
			LoadManager.getInstance().addSingleLoad(loaderinfo);
		}
		
		override protected function onObjLoad(str : String) : void {
			
			_objData = AnalysisServer.getInstance().analysisObj(str);
			uplodToGpu();
		}
		
		
		override public function update() : void {
			
			if (_objData && _objData.indexBuffer) {
				_context.setProgram(this.program);
				setVc();
				setVa();
				resetVa();
				
			}
			super.update()
		}
		override protected function setVa() : void {
			_context.setVertexBufferAt(0, _objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(1, _objData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			_context.drawTriangles(_objData.indexBuffer, 0, -1);
			
		}
		
		override  protected function resetVa() : void {
			_context.setVertexBufferAt(0, null);
			_context.setVertexBufferAt(1, null);
			
		}
		
		override  protected function setVc() : void {
			this.updateMatrix();
			_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, posMatrix, true);
			_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([0.6,0.6,0.6,1])); //专门用来存树的通道的
		}
	}
}


