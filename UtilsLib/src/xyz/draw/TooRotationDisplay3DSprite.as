package xyz.draw
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import xyz.base.TooAGALMiniAssembler;
	import xyz.base.TooObjData;
	
	public class TooRotationDisplay3DSprite extends TooUtilDisplay
	{
		public function TooRotationDisplay3DSprite(context:Context3D)
		{
			super(context);
			initData();
		}

		public function get colorV3d():Vector3D
		{
			return _colorV3d;
		}

		public function set colorV3d(value:Vector3D):void
		{
			_colorV3d = value;
		}

		override protected function initProgram():void
		{
			_program = _context3D.createProgram();
			var assembler:TooAGALMiniAssembler = new TooAGALMiniAssembler;
			_program.upload(
				assembler.assemble(Context3DProgramType.VERTEX,
					
					"m44 vt0, va0, vc8 \n" + 
					"m44 vt0, vt0, vc4 \n" + 
					"m44 vo,  vt0, vc0 " 

					,TooMathMoveUint.agalLevel
				),
				assembler.assemble(Context3DProgramType.FRAGMENT,
					
					"mov fo, fc0 "
					,TooMathMoveUint.agalLevel
				)
			);
			
		}
		private var _showObjData:TooObjData
		private function initData():void
		{
			this.objData=mathRoundTri(10);
			_showObjData=mathRoundTri(1);
			uplodToGpu();
			showObjDataUpGpu()
	
		}
		private var _disNum360:uint=360
		private function mathRoundTri($scale:Number=1):TooObjData
		{
			var $objData:TooObjData=new TooObjData;
			$objData.vertices=new Vector.<Number>
			$objData.uvs=new Vector.<Number>
			$objData.indexs=new Vector.<uint>
			var $num50:Number=TooMathMoveUint._line50
			var $wSize:Number=1*(TooMathMoveUint._line50/50)*$scale
			
			var A:Vector3D=new Vector3D(+$wSize,$num50,0)
			var B:Vector3D=new Vector3D(-$wSize,$num50,0)
			var $m:Matrix3D=new Matrix3D
			var $p0:Vector3D;
			var $p1:Vector3D;
			var $num:uint
			var $indexLen:uint=$objData.vertices.length/3
			for( var i:uint=0;i<_disNum360;i++)
			{
				$m.identity();
				$m.appendRotation(i,Vector3D.X_AXIS)
				$p0=$m.transformVector(A)
				$p1=$m.transformVector(B)
				$objData.vertices.push($p0.x,$p0.y,$p0.z)
				$objData.vertices.push($p1.x,$p1.y,$p1.z)
				
				$objData.uvs.push(0,0)
				$objData.uvs.push(0,0)
				if(i!=0){
					$num=i-1
					$objData.indexs.push($indexLen+$num*2+0,$indexLen+$num*2+1,$indexLen+$num*2+2)
					$objData.indexs.push($indexLen+$num*2+2,$indexLen+$num*2+1,$indexLen+$num*2+3)
				}	
				
			}
			return $objData
		}
		protected function showObjDataUpGpu() : void {
			_showObjData.vertexBuffer = _context3D.createVertexBuffer(_showObjData.vertices.length / 3, 3);
			_showObjData.vertexBuffer.uploadFromVector(Vector.<Number>(_showObjData.vertices), 0, _showObjData.vertices.length / 3);
			
			_showObjData.indexBuffer = _context3D.createIndexBuffer(_showObjData.indexs.length);
			_showObjData.indexBuffer.uploadFromVector(Vector.<uint>(_showObjData.indexs), 0, _showObjData.indexs.length);
		}
		
		
		
		override public function update() : void {
			if (_showObjData && _showObjData.indexBuffer) {
				_context3D.setProgram(this.program);
				setVc();
				setVa();
				resetVa();
			}
		
		}
		override protected function setVa() : void {
			_context3D.setVertexBufferAt(0, _showObjData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.drawTriangles(_showObjData.indexBuffer, 0, -1);
			
		}
		
		override  protected function resetVa() : void {
			_context3D.setVertexBufferAt(0, null);
			_context3D.setVertexBufferAt(1, null);
			
		}
		
		private var _colorV3d:Vector3D=new Vector3D(1,0,0,1)

		override  protected function setVc() : void {
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, posMatrix, true);
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([_colorV3d.x,_colorV3d.y,_colorV3d.z,_colorV3d.w])); //专门用来存树的通道的
		}
		
		
	}
}


