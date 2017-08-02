package  xyz.draw
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Vector3D;
	
	import xyz.base.TooAGALMiniAssembler;
	import xyz.base.TooObjData;
	
	public class TooLineTri3DSprite extends TooUtilDisplay
	{

		protected var _thickness:Number;
		protected var _colorVector3d:Vector3D;
		public function TooLineTri3DSprite($context3D:Context3D)
		{
			_thickness=1
			_colorVector3d=new Vector3D(1,0,0,1)
			super($context3D);
			setLineData()
		}

		public static function get thickNessScale():Number
		{
			return _thickNessScale;
		}

		public static function set thickNessScale(value:Number):void
		{
			_thickNessScale = value;
		}

		override protected function initProgram():void
		{
			_program = _context3D.createProgram();
			var assembler:TooAGALMiniAssembler = new TooAGALMiniAssembler;
			_program.upload(
				assembler.assemble(Context3DProgramType.VERTEX,
					
					"mov vt6, va0 \n"+
					"mov vt7, va1 \n"+
					"mov vi0,va2 \n"+
					
					"mov vt0, vt6 \n"+ 
					
					"m44 vt0, vt0, vc8 \n" +
					"m44 vt0, vt0, vc4 \n" +
					
					"div vt2.z,vt0.z, vc12.z \n"+
					"mul vt7.xyz, vt7.xyz, vt2.z \n"+
					"add vt0, vt6.xyz, vt7.xyz \n"+
					"mov vt0.w, vt6.w \n"+
					
					"m44 vt0, vt0, vc8 \n" +
					"m44 vt0, vt0, vc4 \n" +
					
					
					"m44 vo, vt0, vc0 " 
					
					,TooMathMoveUint.agalLevel
				),
				assembler.assemble(Context3DProgramType.FRAGMENT,
					
					"mov ft0,vi0 \n"+
					"mov fo, ft0"
					,TooMathMoveUint.agalLevel
				)
			);
			
		}
		public function get colorVector3d():Vector3D
		{
			return _colorVector3d;
		}

		public function set colorVector3d(value:Vector3D):void
		{
			_colorVector3d = value;
		}

		public function get thickness():Number
		{
			return _thickness;
		}

		public function set thickness(value:Number):void
		{
			_thickness = value;
		}

	
		public function setLineData(obj:Object=null):void
		{
			clear();
			var a:Vector3D=new Vector3D(0,0,0);
			var b:Vector3D=new Vector3D(100,0,0);
			var c:Vector3D=new Vector3D(100,100,100);
			makeLineMode(a,b)
			makeLineMode(b,c)
			uplodToGpu();
		}
		override public function update() : void {
			if (_objData && _objData.indexBuffer) {
				_context3D.setProgram(this._program);
				setVc();
				setVa();
				resetVa();
			}
		}
		override protected function setVc() : void {
		
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8,posMatrix, true);
			
			_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,12,Vector.<Number>( [100,0,1024,0]));   //等用
		}
		override  protected function setVa() : void {
			_context3D.setVertexBufferAt(0, _objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(1, _objData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(2, _objData.normalsBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
			_context3D.drawTriangles(_objData.indexBuffer, 0, -1);
		}
		override  protected function resetVa() : void {
			_context3D.setVertexBufferAt(0, null);
			_context3D.setVertexBufferAt(1, null);
			_context3D.setVertexBufferAt(2, null);
		}
		
		public function clear():void
		{
			if(_objData){
				_objData.vertexBuffer=null;
				_objData.uvBuffer=null;
				_objData.indexBuffer=null;
			}
			_objData=new TooObjData;
		}
		
		override protected function uplodToGpu() : void {

			if(_objData&&_objData.vertices&&_objData.vertices.length>0){
			
				_objData.vertexBuffer = _context3D.createVertexBuffer(_objData.vertices.length / 3, 3);
				_objData.vertexBuffer.uploadFromVector(Vector.<Number>(_objData.vertices), 0, _objData.vertices.length / 3);
				
				_objData.uvBuffer =_context3D.createVertexBuffer(_objData.uvs.length / 3, 3);
				_objData.uvBuffer.uploadFromVector(Vector.<Number>(_objData.uvs), 0, _objData.uvs.length / 3);
				
				_objData.normalsBuffer = _context3D.createVertexBuffer(_objData.normals.length / 4, 4);
				_objData.normalsBuffer.uploadFromVector(Vector.<Number>(_objData.normals), 0, _objData.normals.length /4);
				
				_objData.indexBuffer = _context3D.createIndexBuffer(_objData.indexs.length);
				_objData.indexBuffer.uploadFromVector(Vector.<uint>(_objData.indexs), 0, _objData.indexs.length);
			}
		}
		private static var _thickNessScale:Number=3

		public function makeLineMode(a:Vector3D,b:Vector3D,num:Number=0,color:Vector3D=null,fuck:Boolean=true) : void {
			if(num){
				_thickness=num
			}
			if(!color){
				color=_colorVector3d;
			}
			var indexNum:uint=0;
			var i:uint;
			if(_objData.vertices){
				indexNum=_objData.indexs.length;
			}else{
				_objData.vertices=new Vector.<Number>
				_objData.uvs=new Vector.<Number>
				_objData.normals=new Vector.<Number>
				_objData.indexs=new Vector.<uint>
			}
			if(fuck){
				//高质量的线
				_objData.vertices.push(
					a.x, a.y, a.z,
					a.x, a.y, a.z,
					b.x, b.y, b.z,
					
					a.x, a.y, a.z,
					b.x, b.y, b.z,
					b.x, b.y, b.z,
					
					a.x, a.y, a.z,
					a.x, a.y, a.z,
					b.x, b.y, b.z,
					
					a.x, a.y, a.z,
					b.x, b.y, b.z,
					b.x, b.y, b.z,
					
					a.x, a.y, a.z,
					a.x, a.y, a.z,
					b.x, b.y, b.z,
					
					a.x, a.y, a.z,
					b.x, b.y, b.z,
					b.x, b.y, b.z
				);
				_objData.uvs.push(
					
					_thickness*thickNessScale,0,0,  -_thickness*thickNessScale,0,0,  -_thickness*thickNessScale,0,0, 
					_thickness*thickNessScale,0,0,  -_thickness*thickNessScale,0,0,   _thickness*thickNessScale,0,0,
					
					0,_thickness*thickNessScale,0,  0,-_thickness*thickNessScale,0,  0,-_thickness*thickNessScale,0, 
					0,_thickness*thickNessScale,0,  0,-_thickness*thickNessScale,0,   0,_thickness*thickNessScale,0,
					
					0,0,_thickness*thickNessScale,  0,0,-_thickness*thickNessScale,  0,0,-_thickness*thickNessScale, 
					0,0,_thickness*thickNessScale,  0,0,-_thickness*thickNessScale,   0,0,_thickness*thickNessScale
				);
				
				for( i=0;i<=17;i++)
				{
					_objData.indexs.push(indexNum+i)
					_objData.normals.push(color.x,color.y,color.z,color.w)  //存放颜色
				}
			}else{
				_objData.vertices.push(
					a.x, a.y, a.z,
					a.x, a.y, a.z,
					b.x, b.y, b.z
				);
				_objData.uvs.push(
					_thickness,0,0,  -_thickness,0,0,  -_thickness,0,0
				);
				for( i=0;i<3;i++)
				{
					_objData.indexs.push(indexNum+i)
					_objData.normals.push(color.x,color.y,color.z,color.w)  //存放颜色
				}
			}
			
		}
		
		public function reSetUplodToGpu():void
		{
			uplodToGpu()
			
		}
	}
}


