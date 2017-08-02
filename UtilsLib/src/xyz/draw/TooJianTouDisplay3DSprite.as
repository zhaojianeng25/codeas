package  xyz.draw
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import xyz.base.TooAGALMiniAssembler;
	import xyz.base.TooMakeModelData;
	import xyz.base.TooObjData;
	import xyz.base.TooObjectHitBox;
	
	public class TooJianTouDisplay3DSprite extends TooUtilDisplay
	{
		public function TooJianTouDisplay3DSprite(context:Context3D)
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
			var $num:uint=2

				
			this.objData=mathRoundTri()
			uplodToGpu();
		}
		private function mathRoundTri():TooObjData
		{
			var $objData:TooObjData=new TooObjData;
			var $m:Matrix3D=new Matrix3D
			$objData.vertices=new Vector.<Number>
			$objData.uvs=new Vector.<Number>
			$objData.indexs=new Vector.<uint>
			
			var $num50:Number=2*(TooMathMoveUint._line50/50)*2
			var $wSize:Number=5*(TooMathMoveUint._line50/50)*2
			makeObjData($objData,new Vector3D(+$wSize,0,0),new Vector3D(-$wSize,$num50,0),Vector3D.X_AXIS,12)
		
			
			return $objData
		}
		
		private function makeObjData($objData:TooObjData,A:Vector3D,B:Vector3D,$axis:Vector3D,$colorId:uint):void
		{
			var $m:Matrix3D=new Matrix3D
			var $p0:Vector3D;
			var $p1:Vector3D;
			var $num:uint
			var $indexLen:uint=$objData.vertices.length/3
			for( var i:uint=0;i<360;i++)
			{
				$m.identity();
				$m.appendRotation(i,$axis)
				$p0=$m.transformVector(A)
				$p1=$m.transformVector(B)
				$objData.vertices.push($p0.x,$p0.y,$p0.z)
				$objData.vertices.push($p1.x,$p1.y,$p1.z)
				
				$objData.uvs.push($colorId,$colorId)
				$objData.uvs.push($colorId,$colorId)
				if(i!=0){
					$num=i-1
					$objData.indexs.push($indexLen+$num*2+0,$indexLen+$num*2+1,$indexLen+$num*2+2)
					$objData.indexs.push($indexLen+$num*2+2,$indexLen+$num*2+1,$indexLen+$num*2+3)
				}	
				
			}
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
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([colorVec.x,colorVec.y,colorVec.z,colorVec.w])); //专门用来存树的通道的
		}
	}
}


