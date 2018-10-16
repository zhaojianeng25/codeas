package  xyz.draw
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import xyz.base.TooAGALMiniAssembler;
	import xyz.base.TooMakeModelData;
	import xyz.base.TooObjectHitBox;
	
	public class TooBoxDisplay3DSprite extends TooUtilDisplay
	{
		public function TooBoxDisplay3DSprite(context:Context3D)
		{
			super(context);
	
			initData();
		}
		override protected function initProgram():void
		{
			_program = _context3D.createProgram();
			var assembler:TooAGALMiniAssembler = new TooAGALMiniAssembler;
			_program.upload(
				assembler.assemble(Context3DProgramType.VERTEX,
					
					"m44 vt0, va0, vc8 \n" + 
					"m44 vt0, vt0, vc4 \n" + 
					"m44 vo,  vt0, vc0 \n" + 
					"mov vi1, va1"
					
					,TooMathMoveUint.agalLevel
				),
				assembler.assemble(Context3DProgramType.FRAGMENT,
					
					"mov ft1, vi1 \n"+
					"mov fo, fc0 "
					,TooMathMoveUint.agalLevel
				)
			);
			
		}
		private function initData():void
		{
			var hitbox:TooObjectHitBox=new TooObjectHitBox;
			var $num:uint=(TooMathMoveUint._line50/20)*2
			hitbox.beginx=-$num
			hitbox.beginy=-$num
			hitbox.beginz=-$num
				
			hitbox.endx=$num
			hitbox.endy=$num
			hitbox.endz=$num
				
			this.objData=TooMakeModelData.makeBoxTampData(hitbox,1)
			uplodToGpu();
		}
		

		
		override public function update() : void {
			
			if (_objData && _objData.indexBuffer) {
				_context3D.setProgram(this.program);
				setVc();
				setVa();
				resetVa();
				
			}
			//super.update()
		}
		override protected function setVa() : void {
			_context3D.setVertexBufferAt(0, _objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(1, _objData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			_context3D.drawTriangles(_objData.indexBuffer, 0, -1);
			
		}
		
		override  protected function resetVa() : void {
			_context3D.setVertexBufferAt(0, null);
			_context3D.setVertexBufferAt(1, null);
			
		}
		public var colorVec:Vector3D=new Vector3D(1,0,0)
		override  protected function setVc() : void {
			this.updateMatrix();
			var $m:Matrix3D=posMatrix.clone();
			$m.prependScale(0.5,0.5,0.5)
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, $m, true);
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([colorVec.x,colorVec.y,colorVec.z,1])); //专门用来存树的通道的
		}
	}
}