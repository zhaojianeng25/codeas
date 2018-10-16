package _Pan3D.display3D.water
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.Program3D;
	import flash.display3D.textures.Texture;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import PanV2.TextureCreate;
	import PanV2.loadV2.ObjsLoad;
	
	import _Pan3D.base.MakeModelData;
	import _Pan3D.base.ObjData;
	import _Pan3D.display3D.Display3DMaterialSprite;
	import _Pan3D.display3D.analysis.AnalysisServer;
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	import _Pan3D.program.Program3DManager;
	
	import _me.Scene_data;

	
	public class Display3DWaterSprite extends Display3DMaterialSprite
	{
		private var _dephtBmp:BitmapData
		private var _heightTexture:Texture
		private var _selfProgram:Program3D
		private var _emptyProgram:Program3D
		public function Display3DWaterSprite(context:Context3D)
		{
			super(context);
			Program3DManager.getInstance().registe(Display3DWaterShader.DISPLAY3D_WATER_SHADER,Display3DWaterShader)
			_selfProgram=Program3DManager.getInstance().getProgram(Display3DWaterShader.DISPLAY3D_WATER_SHADER)
			Program3DManager.getInstance().registe(Display3DWaterEmptyShader.DISPLAY3D_WATER_EMPTY_SHADER,Display3DWaterEmptyShader)
			_emptyProgram=Program3DManager.getInstance().getProgram(Display3DWaterEmptyShader.DISPLAY3D_WATER_EMPTY_SHADER)
		
		}
		
		public function get dephtBmp():BitmapData
		{
			return _dephtBmp;
		}
		public function set dephtBmp(value:BitmapData):void
		{
			_dephtBmp = value;
			_heightTexture=TextureCreate.getInstance().bitmapToTexture(_dephtBmp)
		}
		private function initData():void
		{
			this.objData=MakeModelData.makeJuXinTampData(new Vector3D(-1000,0,-1000),new Vector3D(1000,0,1000))
			objsFun(this.objData)
		}
		override public function set url(value : String) : void {
			_url =value;
			//_url=""
			if(_url.search(".objs")!=-1){
				ObjsLoad.getInstance().addSingleLoad(_url,objsFun)
			}else{
				initData();
			}
			
			
		}
		override protected function objsFun(obj:ObjData):void
		{
			_objData=obj;
			var maxVec:Vector3D
			var minVec:Vector3D
			var i:uint=0
			for( i=0;i<_objData.vertices.length/3;i++){
				var p:Vector3D=new Vector3D(_objData.vertices[i*3+0],_objData.vertices[i*3+1],_objData.vertices[i*3+2])
				if(maxVec){
					maxVec.x=Math.max(maxVec.x,p.x);
					maxVec.z=Math.max(maxVec.z,p.z);
				}else{
					maxVec=p.clone()
				}
				if(minVec){
					minVec.x=Math.min(minVec.x,p.x);
					minVec.z=Math.min(minVec.z,p.z);
				}else{
					minVec=p.clone()
				}
			}

			
            var a:Number=100/Math.max(Math.abs(minVec.x),Math.abs(maxVec.x))
            var b:Number=100/Math.max(Math.abs(minVec.z),Math.abs(maxVec.z))
			
			if(a!=b){
				trace("水面模型比例不正确",a,b)
			}
			trace(a,b)
			for( i=0;i<_objData.vertices.length/3;i++){
				_objData.vertices[i*3+0]=_objData.vertices[i*3+0]*a
				_objData.vertices[i*3+1]=0
				_objData.vertices[i*3+2]=_objData.vertices[i*3+2]*b
					
					
				_objData.uvs[2*i+0]=(_objData.vertices[i*3+0]+100)/200
				_objData.uvs[2*i+1]=(_objData.vertices[i*3+2]+100)/200
			}
			objData.lightUvs=objData.uvs

			processTBN();
			uplodToGpu();
		}
	
	
		override protected function setHeightTexture($id:int):void{
			_context.setTextureAt($id, _heightTexture);
		}

		private var numSkip:Number=0
		override public function update() : void {
			super.update();return;
			
			if(_reflectionTextureVo&&_reflectionTextureVo.texture){
				if(_objData&&_objData.indexBuffer){
					_context.setProgram(_selfProgram)
					_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, posMatrix, true);

	
					_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 12, Scene_data.cam3D.cameraMatrix, true);
					_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([1,-1,2,-2]));//lerpuse,lightuse,use,use;
					
					
					_context.setVertexBufferAt(0, _objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
					_context.setVertexBufferAt(1, _objData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
					
					_context.setTextureAt(0,_reflectionTextureVo.ZeTexture)
						
					_context.drawTriangles(_objData.indexBuffer, 0, -1);
					
					resetVa();
				}
			}else{
				super.update();
			}
			
		}
		public function upDataScanFa():void
		{
			if(_objData&&_objData.indexBuffer){
				_context.setProgram(_emptyProgram)
				_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, posMatrix, true);
				_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([0,0,0,0]));//lerpuse,lightuse,use,use;
				
				_context.setVertexBufferAt(0, _objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
				_context.setVertexBufferAt(1, _objData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
				_context.drawTriangles(_objData.indexBuffer, 0, -1);
				
				resetVa();
			}
		}

		
		
	}
}


			