package _Pan3D.display3D.light
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import PanV2.xyzmove.lineTriV2.LineTri3DSprite;
	
	import _Pan3D.base.MakeModelData;
	import _Pan3D.base.ObjData;
	import _Pan3D.base.ObjectHitBox;
	import _Pan3D.display3D.ground.ModelHasDepthSprite;
	import _Pan3D.program.Program3DManager;
	import _Pan3D.texture.TextureManager;
	import _Pan3D.vo.texture.TextureVo;
	
	import _me.Scene_data;
	
	public class Display3DLightSprite extends ModelHasDepthSprite
	{
		
		private var _lineTri3DSprite:LineTri3DSprite
		private var _distance:Number=100
		private var _colorVec:Vector3D=new Vector3D(1,0,0,1)
		public function Display3DLightSprite(context:Context3D)
		{
			super(context);
			
			Program3DManager.getInstance().registe(Display3DLightShader.DISPLAY3D_LIGHT_SHADER,Display3DLightShader)
			program=Program3DManager.getInstance().getProgram(Display3DLightShader.DISPLAY3D_LIGHT_SHADER)
			initData();
			addLineRound()
		}

		public function get colorVec():Vector3D
		{
			return _colorVec;
		}

		public function set colorVec(value:Vector3D):void
		{
			_colorVec = value;
		}

		public function get distance():Number
		{
			return _distance;
		}

		public function set distance(value:Number):void
		{
			_distance = value;
		}

		private function addLineRound():void
		{
			_lineTri3DSprite=new LineTri3DSprite(_context3D)
			_lineTri3DSprite.clear()
			_lineTri3DSprite.thickness=0.2
			_lineTri3DSprite.colorVector3d=new Vector3D(0.6,0.6,0.6,1)
	
			var $m:Matrix3D=new Matrix3D
			var $arrZ:Vector.<Vector3D>=new Vector.<Vector3D>
			var $arrY:Vector.<Vector3D>=new Vector.<Vector3D>
			var $arrX:Vector.<Vector3D>=new Vector.<Vector3D>
			var $num360:Number=180
			for( var i:uint=0;i<$num360;i++)
			{
				$m.identity();
				$m.appendRotation(360/$num360*i,Vector3D.Z_AXIS)
				$arrZ.push($m.transformVector(new Vector3D(100,0,0)))
					
				$m.identity();
				$m.appendRotation(360/$num360*i,Vector3D.Y_AXIS)
				$arrY.push($m.transformVector(new Vector3D(100,0,0)))
					
				$m.identity();
				$m.appendRotation(360/$num360*i,Vector3D.X_AXIS)
				$arrX.push($m.transformVector(new Vector3D(0,0,100)))
			}
			for(var j:uint=0;j<$arrZ.length-1;j++){
				_lineTri3DSprite.makeLineMode($arrZ[j],$arrZ[j+1])
				_lineTri3DSprite.makeLineMode($arrY[j],$arrY[j+1])
				_lineTri3DSprite.makeLineMode($arrX[j],$arrX[j+1])
			}
			
				
			_lineTri3DSprite.reSetUplodToGpu()
			
		}
		
	
		private function initData():void
		{
	
			makePicModel();
				
				
			var hitbox:ObjectHitBox=new ObjectHitBox;
			var $num:uint=10
			hitbox.beginx=-$num
			hitbox.beginy=-$num
			hitbox.beginz=-$num
			
			hitbox.endx=$num
			hitbox.endy=$num
			hitbox.endz=$num
			this.objData=MakeModelData.makeBoxTampData(hitbox,1)
				
			uplodToGpu();
			TextureManager.getInstance().addTexture("assets/pointlight.png", addTexture, null,0);
		}
		
		private function makePicModel():void
		{
			_lightPicObjData=MakeModelData.makeJuXinTampData(new Vector3D(-15,15,0),new Vector3D(15,-15,0))
			_lightPicObjData.vertexBuffer = this._context.createVertexBuffer(_lightPicObjData.vertices.length / 3, 3);
			_lightPicObjData.vertexBuffer.uploadFromVector(Vector.<Number>(_lightPicObjData.vertices), 0, _lightPicObjData.vertices.length / 3);
			_lightPicObjData.uvBuffer = this._context.createVertexBuffer(_lightPicObjData.uvs.length / 2, 2);
			_lightPicObjData.uvBuffer.uploadFromVector(Vector.<Number>(_lightPicObjData.uvs), 0, _lightPicObjData.uvs.length / 2);
			_lightPicObjData.indexBuffer = this._context.createIndexBuffer(_lightPicObjData.indexs.length);
			_lightPicObjData.indexBuffer.uploadFromVector(Vector.<uint>(_lightPicObjData.indexs), 0, _lightPicObjData.indexs.length);
			
		}
		override protected function addTexture(textureVo : TextureVo, info : Object) : void {
			_lightPicObjData.texture = textureVo.texture;
		}
		
		override public function update() : void {
			
			if(!_visible||!ModelHasDepthSprite.editSee){
				return 
			}
			if (_lightPicObjData && _lightPicObjData.indexBuffer&&_lightPicObjData.texture ) {
				_context.setCulling(Context3DTriangleFace.NONE);
				_context.setProgram(this.program);
				setVc();
				setVa();
				resetVa();
			}
			if(_lineTri3DSprite&&_select){
				_lineTri3DSprite.posMatrix=_boxMatrix.clone()
				var sm:Number=_distance*((this.scale_x+this.scale_y+this.scale_z)/3)/100;
				if(sm!=0){
					_lineTri3DSprite.posMatrix.prependScale(sm,sm,sm);
				}
				_lineTri3DSprite.update();
			}
		}
		override protected function setVa() : void {
			_context.setVertexBufferAt(0, _lightPicObjData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(1, _lightPicObjData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			_context.setTextureAt(0,_lightPicObjData.texture )
			_context.drawTriangles(_lightPicObjData.indexBuffer, 0, -1);
			
		}
		
		override  protected function resetVa() : void {
			_context.setVertexBufferAt(0, null);
			_context.setVertexBufferAt(1, null);
			_context.setTextureAt(0,null)
			
		}
	
		
	
		
		
		private var _boxMatrix:Matrix3D=new Matrix3D
		private var _lightPicObjData:ObjData;
		override public function updatePosMatrix():void{
			_boxMatrix.identity();
			_boxMatrix.prependTranslation(this._absoluteX, this._absoluteY, this._absoluteZ);
		}
		override  protected function setVc() : void {

	       var $pos:Vector3D=_boxMatrix.position
		   $pos=Scene_data.cam3D.cameraMatrix.transformVector($pos)
		   $pos=Scene_data.viewMatrx3D.transformVector($pos)
			  
		   posMatrix.identity();
		   posMatrix.prependTranslation(this._absoluteX, this._absoluteY, this._absoluteZ);
		   posMatrix.prependScale($pos.z/1024,$pos.z/1024,$pos.z/1024);
		 

		   var $bosPostion:Vector3D=_boxMatrix.position.clone()
		   var $camPostion:Vector3D=Scene_data.cam3D.clone()
		   var $nrm:Vector3D= $camPostion.subtract($bosPostion)
		   $nrm.normalize();
		   var $m:Matrix3D=new Matrix3D
		  $m.appendRotation(-Scene_data.cam3D.rotationX,Vector3D.X_AXIS)
		  $m.appendRotation(-Scene_data.cam3D.rotationY,Vector3D.Y_AXIS)
			   

			_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, posMatrix, true);
			_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 12, $m, true);
			
			_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([0.5,0.5,0.5,0.5])); 
			_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([_colorVec.x,_colorVec.y,_colorVec.z,1])); 
		
		}
	}
}


