package _Pan3D.display3D.modelLine
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Vector3D;
	
	import _Pan3D.base.ObjData;
	import _Pan3D.display3D.Display3DSprite;
	import _Pan3D.program.Program3DManager;
	
	public class ModelLineSprite extends Display3DSprite
	{
		
		private var _modelBoxSprite:ModelBoxSprite
		private var _showTri:Boolean=true   //显示三角形

		public function ModelLineSprite(context:Context3D)
		{
			super(context);
			_context3D=_context
		
			init()
		}
		//private var _lineObjData:ObjData
		private var _context3D:Context3D;

		public function setModelObjData(value:ObjData,$isTri:Boolean=true):void
		{
			if(!value){
				return ;
			}
			_showTri=$isTri
			if(_showTri){
				makeTreLineObjData(value)
			}else
			{
				makeBoxLineObjData(value)
			}

			
		}
		private function makeTreLineObjData($objData:ObjData):void
		{
			var i0:uint;
			var i1:uint;
			var i2:uint;
			var a:Vector3D
			var b:Vector3D
			var c:Vector3D
			
			_objData=new ObjData
			_objData.vertices=new Vector.<Number>
			_objData.uvs=new Vector.<Number>
			_objData.indexs=new Vector.<uint>

			
			for(var i:uint=0;i<$objData.indexs.length/3;i++){
				i0=$objData.indexs[i*3+0]
				i1=$objData.indexs[i*3+1]
				i2=$objData.indexs[i*3+2]
				
				a=new Vector3D($objData.vertices[i0*3+0],$objData.vertices[i0*3+1],$objData.vertices[i0*3+2])
				b=new Vector3D($objData.vertices[i1*3+0],$objData.vertices[i1*3+1],$objData.vertices[i1*3+2])
				c=new Vector3D($objData.vertices[i2*3+0],$objData.vertices[i2*3+1],$objData.vertices[i2*3+2])
				
				
				
				_objData.vertices.push(a.x,a.y,a.z)
				_objData.vertices.push(b.x,b.y,b.z)
				_objData.vertices.push(c.x,c.y,c.z)
				
				_objData.uvs.push(1, 0, 0)
				_objData.uvs.push(0, 1, 0)
				_objData.uvs.push(0, 0, 1)
				
				_objData.indexs.push(i*3+0)
				_objData.indexs.push(i*3+1)
				_objData.indexs.push(i*3+2)
				
				
			}
			
			
			_objData.vertexBuffer= _context3D.createVertexBuffer(_objData.vertices.length/3, 3);
			_objData.vertexBuffer.uploadFromVector(_objData.vertices, 0, _objData.vertices.length/3);
			
			_objData.uvBuffer= _context3D.createVertexBuffer(_objData.uvs.length/3, 3);
			_objData.uvBuffer.uploadFromVector(_objData.uvs, 0, _objData.uvs.length/3);
			
			_objData.indexBuffer = _context3D.createIndexBuffer(_objData.indexs.length);
			_objData.indexBuffer.uploadFromVector(Vector.<uint>(_objData.indexs), 0, _objData.indexs.length);
		}
		
		private function makeBoxLineObjData($objData:ObjData):void
		{
			
			var i0:uint;
			var i1:uint;
			var i2:uint;
			var a:Vector3D
			var b:Vector3D
			var c:Vector3D
			var $minPos:Vector3D
			var $maxPos:Vector3D
			
			for(var i:uint=0;i<$objData.indexs.length/3;i++){
				i0=$objData.indexs[i*3+0]
				i1=$objData.indexs[i*3+1]
				i2=$objData.indexs[i*3+2]
				
				a=new Vector3D($objData.vertices[i0*3+0],$objData.vertices[i0*3+1],$objData.vertices[i0*3+2])
				b=new Vector3D($objData.vertices[i1*3+0],$objData.vertices[i1*3+1],$objData.vertices[i1*3+2])
				c=new Vector3D($objData.vertices[i2*3+0],$objData.vertices[i2*3+1],$objData.vertices[i2*3+2])

				
				if(!$minPos){
					$minPos=a.clone()
					$maxPos=a.clone()
				}
				$minPos.x=Math.min($minPos.x,a.x,b.x,c.x)
				$minPos.y=Math.min($minPos.y,a.y,b.y,c.y)
				$minPos.z=Math.min($minPos.z,a.z,b.z,c.z)
				$maxPos.x=Math.max($maxPos.x,a.x,b.x,c.x)
				$maxPos.y=Math.max($maxPos.y,a.y,b.y,c.y)
				$maxPos.z=Math.max($maxPos.z,a.z,b.z,c.z)
				
			}
			if(!_modelBoxSprite){
				_modelBoxSprite=new ModelBoxSprite(_context3D);
				_modelBoxSprite.clear()
			}
			_modelBoxSprite.makeBoxLineObjData($minPos,$maxPos)

		}
		override public function dispose():void
		{
		
		}
		protected function init():void
		{
			Program3DManager.getInstance().registe(ModelLineShader.MODEL_LINE_SHADER,ModelLineShader)
			_program=Program3DManager.getInstance().getProgram(ModelLineShader.MODEL_LINE_SHADER)
		
		}
	
		override public function update():void
		{
			if(this.visible){
				_context3D.setDepthTest(true,Context3DCompareMode.LESS_EQUAL);
				if(_showTri){
					if(_objData&&_objData.indexs){
						_context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA,Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
						_context3D.setProgram(this._program);
						setVc();
						setVa();
						resetVa();
						_context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
						_context3D.setDepthTest(true,Context3DCompareMode.LESS);
					}
				}else{
					if(_modelBoxSprite&&_modelBoxSprite.objData&&_modelBoxSprite.objData.indexBuffer){
						_modelBoxSprite.posMatrix=this.posMatrix
						_modelBoxSprite.update()
					}
				}
				
			}
			
		}
		override protected function setVc() : void {
			
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8,posMatrix, true);
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([1, 2, 3, .5]));
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([0.8,0.8,0.8,1]));
		}
		override  protected function setVa() : void {
			_context3D.setVertexBufferAt(0, _objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(1, _objData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.drawTriangles(_objData.indexBuffer, 0, -1);
		}
		override  protected function resetVa() : void {
			_context3D.setVertexBufferAt(0, null);
			_context3D.setVertexBufferAt(1, null);
		}

	}
}