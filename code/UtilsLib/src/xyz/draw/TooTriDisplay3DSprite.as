package xyz.draw
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Vector3D;
	
	import xyz.base.TooAGALMiniAssembler;
	import xyz.base.TooObjData;
	
	public class TooTriDisplay3DSprite extends TooUtilDisplay
	{
		public function TooTriDisplay3DSprite(context:Context3D)
		{
			super(context);
			var a:Vector3D=new Vector3D(0,0,0)
			var b:Vector3D=new Vector3D(100,0,0)
			var c:Vector3D=new Vector3D(0,0,100)
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
	
		public static var triSize:Number=20
		public function initData():void
		{
	
	
				
			var w:Number=triSize
			var a:Vector3D=new Vector3D(0,0,0);
			var b:Vector3D=new Vector3D(w,0,0)
			var c:Vector3D=new Vector3D(w,0,w)
			var d:Vector3D=new Vector3D(0,0,w)
	

				
			this.objData=new  TooObjData
			this.objData.vertices=new Vector.<Number>
			this.objData.uvs=new Vector.<Number>
			this.objData.indexs=new Vector.<uint>;
			
			this.objData.vertices.push(a.x,a.y,a.z)
			this.objData.vertices.push(b.x,b.y,b.z)
			this.objData.vertices.push(c.x,c.y,c.z)
			this.objData.vertices.push(d.x,d.y,d.z)
			this.objData.uvs.push(0,0)
			this.objData.uvs.push(0,0)
			this.objData.uvs.push(0,0)
			this.objData.uvs.push(0,0)
			this.objData.indexs.push(0,1,2)
			this.objData.indexs.push(0,2,3)
			

		
				
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
	

			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, posMatrix, true);
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([colorVec.x,colorVec.y,colorVec.z,colorVec.w])); //专门用来存树的通道的
		}
	}
}