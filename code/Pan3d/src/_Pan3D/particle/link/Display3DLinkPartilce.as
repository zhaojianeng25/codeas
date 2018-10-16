package _Pan3D.particle.link
{
	import _Pan3D.base.MakeModelData;
	import _Pan3D.base.ObjData;
	import _Pan3D.display3D.Display3D;
	import _Pan3D.display3D.interfaces.IDisplay3D;
	import _Pan3D.particle.Display3DParticle;
	import _Pan3D.particle.ParticleData;
	import _Pan3D.texture.TextureManager;
	
	import _me.Scene_data;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	

	/**
	 * 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class Display3DLinkPartilce extends Display3DParticle
	{
		//protected var _closeGround:Boolean;//紧贴地面
		//protected var _gormalsGround:Boolean;//使用地面法线
				
		//protected var _bitmapdata:BitmapData;
		//protected var _baseMatrix:Matrix3D;
		
		protected var _maxAnimTime:int;
		
		public function Display3DLinkPartilce(context:Context3D)
		{
			super(context);
			particleData = new ParticleData;
			_particleType = 10;
		}
		
		public function initData():void{
			//_bitmapdata = new BitmapData(512,512,true,0xffffffff);
			_normal = new Vector3D(0,0,1);
			
			uplodToGpu();
		}
		
		override protected function uplodToGpu() : void {
			var objData:ObjData = MakeModelData.makeLinkData(this._width,this._height,this._originWidthScale,this._originHeightScale,_isUV,_isU,_isV,_animLine,_animRow);
			
			particleData.vertices = objData.vertices;
			particleData.uvs = objData.uvs;
			particleData.indexs = objData.indexs;
			
			particleData.vaData = Vector.<Number>([12,13,13,12]);
			
			
			pushToGpu();
		}
		
		override public function pushToGpu():void{
			particleData.vertexBuffer = this._context3D.createVertexBuffer(particleData.vertices.length / 3, 3);
			particleData.vertexBuffer.uploadFromVector(Vector.<Number>(particleData.vertices), 0, particleData.vertices.length / 3);
			
			particleData.uvBuffer = this._context3D.createVertexBuffer(particleData.uvs.length / 2, 2);
			particleData.uvBuffer.uploadFromVector(Vector.<Number>(particleData.uvs), 0, particleData.uvs.length / 2);
			
			particleData.vaDataBuffer = this._context3D.createVertexBuffer(particleData.vaData.length, 1);
			particleData.vaDataBuffer.uploadFromVector(Vector.<Number>(particleData.vaData), 0, particleData.vaData.length);
			
			particleData.indexBuffer = this._context3D.createIndexBuffer(particleData.indexs.length);
			particleData.indexBuffer.uploadFromVector(Vector.<uint>(particleData.indexs), 0, particleData.indexs.length);
		}
		
		override protected function setVa() : void {
			_context3D.setVertexBufferAt(0, particleData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context3D.setVertexBufferAt(1, particleData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			_context3D.setVertexBufferAt(2, particleData.vaDataBuffer, 0, Context3DVertexBufferFormat.FLOAT_1);
			_context3D.setTextureAt(1, particleData.texture);
			_context3D.setTextureAt(2,_textureColor);
			_context3D.drawTriangles(particleData.indexBuffer, 0, -1);
			Scene_data.drawNum++;
			Scene_data.drawTriangle += int(particleData.indexs.length/3);
		}
		
		override protected function resetVa() : void {
			_context3D.setVertexBufferAt(0, null);
			_context3D.setVertexBufferAt(1, null);
			_context3D.setVertexBufferAt(2, null);
			_context3D.setTextureAt(1,null);
			_context3D.setTextureAt(2,null);
		}
		
		override protected function setVc() : void {
			this.updateMatrix();
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, modelMatrix, true);
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, modeRotationMatrix, true);
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 24, modeZiZhuanMatrix3D, true);// 传入整个粒子的旋转 
			
			var ma:Matrix3D = Scene_data.cam3D.cameraMatrix;
			var v1:Vector3D = new Vector3D(500,0,0);
			//v1 = ma.transformVector(v1);
			
			_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 12, Vector.<Number>([0,0,0,1]));
			_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 13, Vector.<Number>([v1.x,v1.y,v1.z,1]));
			//_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 14, Vector.<Number>([0,100,0,1]));
			//_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 15, Vector.<Number>([0,-100,0,1]));
			
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,Vector.<Number>( [_timer/Scene_data.frameTime/_life,_timer/Scene_data.frameTime,_animInterval,_maxAnimTime])); 
			
			if(_colorChange){
				_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([1+_colorChange.rValue*_colorChange.num, 1+_colorChange.gValue*_colorChange.num, 1+_colorChange.bValue*_colorChange.num, 1+_colorChange.aValue*_colorChange.num]));
			}else{
				_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([1,1,1,1]));
			}
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,3,Vector.<Number>( [ _animLine,_animRow,_uSpeed,_vSpeed ])); //UV移动
			
			

			if(_timer/Scene_data.frameTime > (_life-2)){
				this.visible = false;
			}
		}
		//private var _rotationMatrix:Matrix3D = new Matrix3D;
		protected  function  get modeRotationMatrix():Matrix3D
		{
			_rotationMatrix.identity();
			if(!_watchEye){
				return _rotationMatrix;
			}
			if(_axisRotaion){
				_rotationMatrix.prependRotation(-_axisRotaion.num,_axisRotaion.axis);
			}
			//var m:Matrix3D=bindMatrix.clone();
			if(bindRatation){
				bindMatrix.invert();
				_rotationMatrix.prepend(bindMatrix);
			}
			
			_rotationMatrix.prependRotation(-Scene_data.cam3D.angle_y , Vector3D.Y_AXIS);
			_rotationMatrix.prependRotation(-Scene_data.cam3D.angle_x , Vector3D.X_AXIS);
	
			return _rotationMatrix;
		}
		
		protected function get modeZiZhuanMatrix3D():Matrix3D
		{
			_rotationMatrix.identity();
			if(_ziZhuanAngly.x==_ziZhuanAngly.y&&_ziZhuanAngly.y==_ziZhuanAngly.z&&_ziZhuanAngly.z==0){
				
			}else{
				if(_selfRotaion){
					_rotationMatrix.prependRotation(_selfRotaion.num,_ziZhuanAngly);
				}
			}
			if(_scaleChange)
				_rotationMatrix.prependScale(_widthFixed?1:_scaleChange.num,_heightFixed?1:_scaleChange.num,_scaleChange.num);
	
			return _rotationMatrix;
		}
		
//		override public function updatePosMatrix():void{
//			posMatrix.identity();
//			posMatrix.prependTranslation(this._absoluteX, this._absoluteY, this._absoluteZ);
//			posMatrix.prependScale(this._scale,this._scale,this._scale);
//			posMatrix.prependRotation(_rotationX , Vector3D.X_AXIS);
//			posMatrix.prependRotation(_rotationY , Vector3D.Y_AXIS);
//			posMatrix.prependRotation(_rotationZ , Vector3D.Z_AXIS);
//		}
		
		override protected function processScale():void{
			
			//posMatrix.prependScale(_widthFixed?1:_scaleChange.num,_heightFixed?1:_scaleChange.num,_scaleChange.num);
		}
		
		public function setDynamicVc():void{
			
			//_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, baseColor); 
		}
		
		override public function getAllInfo():Object{
			var obj:Object = super.getAllInfo();
			//obj.closeGround = _closeGround;//紧贴地面
			//obj.gormalsGround = _gormalsGround;//使用地面法线
			obj.maxAnimTime = _maxAnimTime;
			return obj;
		}
		
		override public function setAllInfo(obj:Object,isClone:Boolean=false):void{
			//this._closeGround = obj.closeGround;
			//this._gormalsGround = obj.gormalsGround;
			this._maxAnimTime = obj.maxAnimTime;
			
			super.setAllInfo(obj,isClone);
			
			if(!isClone){
				uplodToGpu();
			}
			
		}
		
		override public function clone():Display3DParticle{
			var display:Display3DLinkPartilce = new Display3DLinkPartilce(_context3D);
			display.setProgram3D(this._program);
			display.setAllInfo(_data,true);
			display.particleData = particleData;
			display._textureColor = _textureColor;
			return display;
		}
		
		
		
		override public function getBufferNum():int{
			return 3;
		}
		
		
	}
}