package _Pan3D.display3D.collision
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import _Pan3D.base.CollisionVo;
	import _Pan3D.base.MakeModelData;
	import _Pan3D.base.ObjData;
	import _Pan3D.base.ObjectHitBox;
	import _Pan3D.core.MathCore;
	import _Pan3D.display3D.ground.ModelHasDepthSprite;
	import _Pan3D.program.Program3DManager;
	
	import collision.CollisionType;
	
	public class Display3DCollisionSprite extends ModelHasDepthSprite
	{
		private var _collisionVo:CollisionVo
		private var _prentMatrx3D:Matrix3D
		public function Display3DCollisionSprite(context:Context3D)
		{
			super(context);
			Program3DManager.getInstance().registe(Display3DCollisionShader.DISPLAY3DCOLLISIONSHADER,Display3DCollisionShader)
			program=Program3DManager.getInstance().getProgram(Display3DCollisionShader.DISPLAY3DCOLLISIONSHADER)
		}



		public function get collisionVo():CollisionVo
		{
			return _collisionVo;
		}

		public function set prentMatrx3D(value:Matrix3D):void
		{
			_prentMatrx3D = value;
		}

		public function set collisionVo(value:CollisionVo):void
		{
			_collisionVo = value;
			switch(_collisionVo.type)
			{
				case CollisionType.BOX:
				{
					this.objData=MakeModelData.getCollisionBoxObjData();
					posMatrix.identity();
					posMatrix.prependTranslation(_collisionVo.x,_collisionVo.y,_collisionVo.z);
					posMatrix.prependRotation(_collisionVo.rotationZ , Vector3D.Z_AXIS);
					posMatrix.prependRotation(_collisionVo.rotationY , Vector3D.Y_AXIS);
					posMatrix.prependRotation(_collisionVo.rotationX , Vector3D.X_AXIS);
					posMatrix.prependScale(_collisionVo.scale_x,_collisionVo.scale_y,_collisionVo.scale_z);
					
					break;
				}
				case CollisionType.BALL:
				{
					this.objData=MakeModelData.getCollisionBallOjbData();
					posMatrix.identity();
					posMatrix.prependTranslation(_collisionVo.x,_collisionVo.y,_collisionVo.z);
					posMatrix.prependRotation(_collisionVo.rotationZ , Vector3D.Z_AXIS);
					posMatrix.prependRotation(_collisionVo.rotationY , Vector3D.Y_AXIS);
					posMatrix.prependRotation(_collisionVo.rotationX , Vector3D.X_AXIS);
					posMatrix.prependScale(_collisionVo.radius/100,_collisionVo.radius/100,_collisionVo.radius/100);
					
					
					
					
					break;
				}
				case CollisionType.Cylinder:
				{
					this.objData=MakeModelData.getCollisionCylinderObjData();
					posMatrix.identity();
					posMatrix.prependTranslation(_collisionVo.x,_collisionVo.y,_collisionVo.z);
					posMatrix.prependRotation(_collisionVo.rotationZ , Vector3D.Z_AXIS);
					posMatrix.prependRotation(_collisionVo.rotationY , Vector3D.Y_AXIS);
					posMatrix.prependRotation(_collisionVo.rotationX , Vector3D.X_AXIS);
					posMatrix.prependScale(_collisionVo.scale_x,_collisionVo.scale_y,_collisionVo.scale_x);
					
					
					
					
					break;
				}
				case CollisionType.Cone:
				{
					this.objData=MakeModelData.getCollisionConeObjData();
					posMatrix.identity();
					posMatrix.prependTranslation(_collisionVo.x,_collisionVo.y,_collisionVo.z);
					posMatrix.prependRotation(_collisionVo.rotationZ , Vector3D.Z_AXIS);
					posMatrix.prependRotation(_collisionVo.rotationY , Vector3D.Y_AXIS);
					posMatrix.prependRotation(_collisionVo.rotationX , Vector3D.X_AXIS);
					posMatrix.prependScale(_collisionVo.scale_x,_collisionVo.scale_y,_collisionVo.scale_x);
					
					
					
					
					break;
				}
				case CollisionType.Polygon:
				{
					this.objData=new ObjData;
					this.objData.vertices=_collisionVo.data.vertices
					this.objData.indexs=_collisionVo.data.indexs
					
					posMatrix.identity();
					posMatrix.prependTranslation(_collisionVo.x,_collisionVo.y,_collisionVo.z);
					posMatrix.prependRotation(_collisionVo.rotationZ , Vector3D.Z_AXIS);
					posMatrix.prependRotation(_collisionVo.rotationY , Vector3D.Y_AXIS);
					posMatrix.prependRotation(_collisionVo.rotationX , Vector3D.X_AXIS);
					posMatrix.prependScale(_collisionVo.scale_x,_collisionVo.scale_y,_collisionVo.scale_z);
					
					
					break;
				}
					
				default:
				{
					break;
				}
			}
		
			this.resetUplodToGpu();
		}


	
		override public function update() : void {
			
			if(_visible==false){
				return
			}

			_context.setCulling(Context3DTriangleFace.NONE);
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
		
			modelMatrix=_prentMatrx3D.clone()
			modelMatrix.prepend(posMatrix)
			
			_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, modelMatrix, true);
			
			
			if(_collisionVo&&_collisionVo.colorInt){
				var $colorVector3d:Vector3D=	MathCore.hexToArgbNum(_collisionVo.colorInt)
				_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([$colorVector3d.x,$colorVector3d.y,$colorVector3d.z,0.2])); //颜色
			}else{
				_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([0.5,0,0,0.2])); //颜色
			}
		}
		


	}
}