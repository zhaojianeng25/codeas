package _Pan3D.display3D.model
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Vector3D;
	
	import PanV2.loadV2.ObjsLoad;
	
	import _Pan3D.base.MakeModelData;
	import _Pan3D.base.ObjData;
	import _Pan3D.display3D.analysis.AnalysisServer;
	import _Pan3D.display3D.collision.Display3DCollistionGrop;
	import _Pan3D.display3D.ground.ModelHasDepthSprite;
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	import _Pan3D.program.Program3DManager;
	
	public class Display3DModelSprite extends ModelHasDepthSprite
	{
	
		private var _uid:String

		private var _display3DCollistionGrop:Display3DCollistionGrop;

		public function Display3DModelSprite(context:Context3D)
		{
			super(context);
			
			Program3DManager.getInstance().registe(ModelShader.MODEL_SHADER,ModelShader)
			program=Program3DManager.getInstance().getProgram(ModelShader.MODEL_SHADER)
			initData();
		}
		



		public function get display3DCollistionGrop():Display3DCollistionGrop
		{
			return _display3DCollistionGrop;
		}

		public function set display3DCollistionGrop(value:Display3DCollistionGrop):void
		{
			_display3DCollistionGrop = value;
		}

	
        public static var  collistionState:Boolean
		public function  showCollision():void
		{

			if(collistionState&&this.objData &&this.objData.collisionItem){
				if(!_display3DCollistionGrop){
					_display3DCollistionGrop=new Display3DCollistionGrop();
					_display3DCollistionGrop.prentModel=this;
					
				}
				_display3DCollistionGrop.collisionItem=this.objData.collisionItem;
			}else{
				if(_display3DCollistionGrop){
					_display3DCollistionGrop.clear()
					_display3DCollistionGrop=null
				}
				
			}
		}

		public function get uid():String
		{
			return _uid;
		}

		public function set uid(value:String):void
		{
			_uid = value;
		}

		private function initData():void
		{
		
			return 
			this.objData=MakeModelData.makeJuXinTampData(new Vector3D(-100,0,-100),new Vector3D(100,0,100))
			uplodToGpu();
		}
		override public function set url(value : String) : void {
			_url =value;
			if(_url.indexOf(".objs")!=-1){
				//loadObjs()
				ObjsLoad.getInstance().addSingleLoad(_url,objsFun)
			}else{
				var loaderinfo : LoadInfo = new LoadInfo(_url, LoadInfo.XML, onObjLoad,0);
				LoadManager.getInstance().addSingleLoad(loaderinfo);
			}
		}
		protected function objsFun(obj:ObjData):void
		{
	
			this.objData=obj;
			processTBN();
			
		}
		override protected function onObjLoad(str : String) : void {

			_objData = AnalysisServer.getInstance().analysisObj(str);
			_objData.lightUvs=_objData.uvs
			uplodToGpu();
		}
		override public function update() : void {
		
			if(_visible==false){
				return
			}
			
			if (_objData && _objData.indexBuffer) {
				_context.setProgram(this.program);
				setVc();
				setVa();
				resetVa();
			}
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