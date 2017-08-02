package _Pan3D.display3D.parallel
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import PanV2.xyzmove.lineTriV2.LineTri3DMultipleTriSprite;
	
	import _Pan3D.base.MakeModelData;
	import _Pan3D.base.ObjData;
	import _Pan3D.display3D.ground.ModelHasDepthSprite;
	import _Pan3D.program.Program3DManager;
	import _Pan3D.texture.TextureManager;
	import _Pan3D.vo.texture.TextureVo;
	
	import _me.Scene_data;
	
	public class Dispaly3DParallelLightSpreit extends ModelHasDepthSprite
	{
		private var _lineSprite:LineTri3DMultipleTriSprite
		private var _lightPicObjData:ObjData;
		public function Dispaly3DParallelLightSpreit(context:Context3D)
		{
			super(context);

			Program3DManager.getInstance().registe(Display3DParallelLightShader.DISPLAY3D_PARALLEL_LIGHT_SHADER,Display3DParallelLightShader)
			program=Program3DManager.getInstance().getProgram(Display3DParallelLightShader.DISPLAY3D_PARALLEL_LIGHT_SHADER)

			_lineSprite=new LineTri3DMultipleTriSprite(_context3D)
			drawLine()
			addPlanPic()
		}

		public function get colorVec():Vector3D
		{
			return _colorVec;
		}

		public function set colorVec(value:Vector3D):void
		{
			_colorVec = value;
		}

		private function addPlanPic():void
		{
			_objData=MakeModelData.makeJuXinTampData(new Vector3D(-10,10,0),new Vector3D(10,-10,0))
			uplodToGpu()
			TextureManager.getInstance().addTexture("assets/icon_class_DirectionalLight.png", addTexture, null,0);
		}
		
		override protected function addTexture(textureVo : TextureVo, info : Object) : void {
			_objData.texture = textureVo.texture;
		}

		private function drawLine():void
		{
			var n:Number=10
			var num:uint=3
			_lineSprite.thickness=0.3
			_lineSprite.colorVector3d=new Vector3D(1,1,1,1)
			_lineSprite.clear()
			for(var i:int=0;i<num;i++){
				for(var j:int=0;j<num;j++){
					var $pos:Vector3D=new Vector3D(i*n-(num*n)/2+n/2,0,j*n-(num*n)/2+n/2)
					_lineSprite.makeLineMode(new Vector3D($pos.x,0,$pos.z),new Vector3D($pos.x,-60,$pos.z))
				}
			}
			_lineSprite.reSetUplodToGpu()
		}
	
		override public function update() : void {
			if(!_visible||!ModelHasDepthSprite.editSee){
				return;
			}
			if (_objData && _objData.texture) {
				_context.setProgram(this.program);
				setVc();
				setVa();
				resetVa();
				
			}
			if(_select){
				_lineSprite.posMatrix=this.baseMatrix
				_lineSprite.update()
			}
			
		}
		override protected function setVa() : void {
			_context.setVertexBufferAt(0, _objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(1, _objData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			_context.setTextureAt(0, _objData.texture);
			_context.drawTriangles(_objData.indexBuffer, 0, -1);
			
		}
		
		override  protected function resetVa() : void {
			_context.setVertexBufferAt(0, null);
			_context.setVertexBufferAt(1, null);
			_context.setTextureAt(0, null);
			
		}
		private var baseMatrix:Matrix3D=new Matrix3D
		override public function updatePosMatrix():void{
			baseMatrix.identity();
			
			baseMatrix.prependTranslation(this._absoluteX, this._absoluteY, this._absoluteZ);
			baseMatrix.prependRotation(_rotationZ , Vector3D.Z_AXIS);
			baseMatrix.prependRotation(_rotationY , Vector3D.Y_AXIS);
			baseMatrix.prependRotation(_rotationX , Vector3D.X_AXIS);
			baseMatrix.prependScale(this._scale_x,this._scale_y,this._scale_z);
			
			posMatrix.identity();
			posMatrix.prependTranslation(this._absoluteX, this._absoluteY, this._absoluteZ);

			posMatrix.prependScale(this._scale_x,this._scale_y,this._scale_z);
			

			
			var $m:Matrix3D=new Matrix3D
			$m.appendRotation(-Scene_data.cam3D.rotationX,Vector3D.X_AXIS)
			$m.appendRotation(-Scene_data.cam3D.rotationY,Vector3D.Y_AXIS)
				
				
			posMatrix.prepend($m)
				
		}
		private var _colorVec:Vector3D=new Vector3D(1,0,0,1)
		override  protected function setVc() : void {
			this.updatePosMatrix();
			
			_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, posMatrix, true);
			

			_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([0.5,0.5,0.5,0.5])); 
			_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([_colorVec.x,_colorVec.y,_colorVec.z,1])); 
		}

		
	}
}