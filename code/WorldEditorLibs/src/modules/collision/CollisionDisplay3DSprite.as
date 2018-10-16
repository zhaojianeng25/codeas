package modules.collision
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Vector3D;
	
	import _Pan3D.base.CollisionVo;
	import _Pan3D.core.MathCore;
	import _Pan3D.display3D.ground.ModelHasDepthSprite;
	import _Pan3D.program.Program3DManager;
	
	public class CollisionDisplay3DSprite extends ModelHasDepthSprite
	{
		private var _collisionVo:CollisionVo
		
		private var _collisionLineDispaly3dSprite:CollisionLineDispaly3dSprite
		private static var _showTriModel:Boolean=true
		public function CollisionDisplay3DSprite(context:Context3D)
		{
			super(context);
			_showTri=true;
			Program3DManager.getInstance().registe(CollisionDisplay3DShader.COLLISIONDISPLAY3DSHADER,CollisionDisplay3DShader)
			program=Program3DManager.getInstance().getProgram(CollisionDisplay3DShader.COLLISIONDISPLAY3DSHADER)
			initData();
		}
		
		

		public static function get showTriModel():Boolean
		{
			return _showTriModel;
		}

		public static function set showTriModel(value:Boolean):void
		{
			_showTriModel = value;
		}

		public function get collisionVo():CollisionVo
		{
			return _collisionVo;
		}

		public function set collisionVo(value:CollisionVo):void
		{
			_collisionVo = value;
			_collisionLineDispaly3dSprite.collisionVo=_collisionVo;
		}

		private function initData():void
		{
			_collisionLineDispaly3dSprite=new CollisionLineDispaly3dSprite(this._context3D);
			
		}		
		override public function update() : void {
			
			if(_visible==false){
				return
			}
			_collisionLineDispaly3dSprite.update();
			
			if(_showTriModel){
				_context.setDepthTest(false,Context3DCompareMode.LESS);
				_context.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA,Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
				if (_objData && _objData.indexBuffer) {
					_context.setProgram(this.program);
					setVc();
					setVa();
					resetVa();
				}
				_context.setDepthTest(true,Context3DCompareMode.LESS);
				_context.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ZERO);
				_context.setCulling(Context3DTriangleFace.NONE);
			}
		
			
		

		}
		override public function updatePosMatrix():void{
			super.updatePosMatrix();
			
			_collisionLineDispaly3dSprite.x=this.x;
			_collisionLineDispaly3dSprite.y=this.y;
			_collisionLineDispaly3dSprite.z=this.z;
			_collisionLineDispaly3dSprite.rotationX=this.rotationX;
			_collisionLineDispaly3dSprite.rotationY=this.rotationY;
			_collisionLineDispaly3dSprite.rotationZ=this.rotationZ;
			_collisionLineDispaly3dSprite.scale_x=this.scale_x;
			_collisionLineDispaly3dSprite.scale_y=this.scale_y;
			_collisionLineDispaly3dSprite.scale_z=this.scale_z;
			_collisionLineDispaly3dSprite.updatePosMatrix()
			_collisionLineDispaly3dSprite.resetLineData();
		}
		
		
		override protected function setVa() : void {
			_context.setVertexBufferAt(0, _objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.drawTriangles(_objData.indexBuffer, 0, -1);
			
		}
		override protected function uplodToGpu() : void {
			_objData.vertexBuffer = this._context.createVertexBuffer(_objData.vertices.length / 3, 3);
			_objData.vertexBuffer.uploadFromVector(Vector.<Number>(_objData.vertices), 0, _objData.vertices.length / 3);

			_objData.indexBuffer = this._context.createIndexBuffer(_objData.indexs.length);
			_objData.indexBuffer.uploadFromVector(Vector.<uint>(_objData.indexs), 0, _objData.indexs.length);
		}
		public function resetUplodToGpu():void
		{
			if(_objData&&_objData.indexs){
				this.uplodToGpu();
			}
			
		}
		override  protected function resetVa() : void {
			_context.setVertexBufferAt(0, null);
			_context.setVertexBufferAt(1, null);
		}
		
		override  protected function setVc() : void {
			this.updateMatrix();
			_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, posMatrix, true);
			
			if(_collisionVo&&_collisionVo.colorInt){
				var $colorVector3d:Vector3D=	MathCore.hexToArgbNum(_collisionVo.colorInt)
				_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([$colorVector3d.x,$colorVector3d.y,$colorVector3d.z,0.3])); //颜色
			}else{
				_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([0.5,0,0,0.5])); //颜色
			}

		}
	}
}


