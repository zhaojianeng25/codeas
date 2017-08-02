package _Pan3D.display3D.lightProbe
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Vector3D;
	
	import _Pan3D.display3D.model.Display3DModelSprite;
	import _Pan3D.program.Program3DManager;

	public class Display3DLightProbeItemSprite  extends Display3DModelSprite
	{
		private var _baseSH:Vector.<Number>;
		public var resultSHVec:Vector.<Vector3D>;
		
		public function Display3DLightProbeItemSprite(context:Context3D)
		{
			super(context);
			program=Program3DManager.getInstance().getProgram(Display3DLightProbeItemShader.DISPLAY3D_LIGHT_PROBE_ITEM_SHADER);
			resultSHVec = new Vector.<Vector3D>;
			for(var i:int;i<9;i++){
				resultSHVec.push(new Vector3D(0,0,0));
			}
			initSH();
		}
		public function setSH(arr:Vector.<Vector3D>):void{
			resultSHVec = arr;
		}
		
		override public function update():void{
			if(!_visible){
				return 
			}
			if (_objData && resultSHVec) {
				_context.setProgram(this.program);
				setVc();
				setVa();
				resetVa();
			}
		}
		
		override protected function setVa() : void {
			_context.setVertexBufferAt(0, _objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(1, _objData.normalsBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.drawTriangles(_objData.indexBuffer, 0, -1);
			
		}

		override  protected function resetVa() : void {
			_context.setVertexBufferAt(0, null);
			_context.setVertexBufferAt(1, null);
			
		}
		
		override  protected function setVc() : void {
			this.updateMatrix();
			_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, posMatrix, true);
			
			_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 12, Vector.<Number>( [_baseSH[0],_baseSH[1],_baseSH[2],_baseSH[3]]));
			_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 13, Vector.<Number>( [_baseSH[4],_baseSH[5],_baseSH[6],_baseSH[7]]));
			_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 14, Vector.<Number>( [_baseSH[8],3,0.8,0]));
			
			
			for(var i:int=0;i<9;i++){
				_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 16 + i, Vector.<Number>( [resultSHVec[i].x,resultSHVec[i].y,resultSHVec[i].z,0]));
			}
			
			_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>( [1,0,0,1]));
			
		}
		
		private function initSH():void{
			var sh0:Number = 0.5 * Math.sqrt(1/Math.PI);
			var sh1:Number = -0.5 * Math.sqrt(3/Math.PI);
			var sh2:Number = 0.5 * Math.sqrt(3/Math.PI);
			var sh3:Number = -0.5 * Math.sqrt(3/Math.PI);
			var sh4:Number = 0.5 * Math.sqrt(15/Math.PI);
			var sh5:Number = -0.5 * Math.sqrt(15/Math.PI);
			var sh6:Number = 0.25 * Math.sqrt(5/Math.PI);
			var sh7:Number = -0.5 * Math.sqrt(15/Math.PI);
			var sh8:Number = 0.25 * Math.sqrt(15/Math.PI);
			_baseSH = Vector.<Number>([sh0,sh1,sh2,sh3,sh4,sh5,sh6,sh7,sh8]);
		}
		
	}
}