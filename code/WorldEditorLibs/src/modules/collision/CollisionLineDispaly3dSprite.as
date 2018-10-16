package modules.collision
{
	import flash.display3D.Context3D;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import PanV2.xyzmove.lineTriV2.LineTri3DSprite;
	
	import _Pan3D.base.CollisionVo;
	import _Pan3D.base.ObjData;
	import _Pan3D.core.MathCore;
	
	import collision.CollisionType;
	
	public class CollisionLineDispaly3dSprite extends LineTri3DSprite
	{
		private var _collisionVo:CollisionVo
		public function CollisionLineDispaly3dSprite($context3D:Context3D)
		{
			super($context3D);
		}

		public function get collisionVo():CollisionVo
		{
			return _collisionVo;
		}

		public function set collisionVo(value:CollisionVo):void
		{
			_collisionVo = value;
			
		}
		private function makePolygonLine():void
		{
			
		
			this.clear();
			var i0:uint;
			var i1:uint;
			var i2:uint;
			var a:Vector3D
			var b:Vector3D
			var c:Vector3D
			

				
			
			
			
			for(var i:uint=0;_collisionVo.data&&i<_collisionVo.data.indexs.length/3;i++){
				i0=_collisionVo.data.indexs[i*3+0]
				i1=_collisionVo.data.indexs[i*3+1]
				i2=_collisionVo.data.indexs[i*3+2]
				
				a=new Vector3D(_collisionVo.data.vertices[i0*3+0]*this._scale_x,_collisionVo.data.vertices[i0*3+1]*this._scale_y,_collisionVo.data.vertices[i0*3+2]*this._scale_z)
				b=new Vector3D(_collisionVo.data.vertices[i1*3+0]*this._scale_x,_collisionVo.data.vertices[i1*3+1]*this._scale_y,_collisionVo.data.vertices[i1*3+2]*this._scale_z)
				c=new Vector3D(_collisionVo.data.vertices[i2*3+0]*this._scale_x,_collisionVo.data.vertices[i2*3+1]*this._scale_y,_collisionVo.data.vertices[i2*3+2]*this._scale_z)
			
				
				this.makeLineMode(a,b)
				this.makeLineMode(a,c)
				this.makeLineMode(b,c)
		
				
				
			}
			
			
	
			
		}
		private function makeBoxLine():void
		{
			this.clear();
				var p:Vector3D=new Vector3D(100*this._scale_x,100*this._scale_y,100*this._scale_z);
				
			
	
				
				this.makeLineMode(new Vector3D(-p.x,-p.y,-p.z),new Vector3D(+p.x,-p.y,-p.z))
				this.makeLineMode(new Vector3D(+p.x,-p.y,-p.z),new Vector3D(+p.x,-p.y,+p.z))
				this.makeLineMode(new Vector3D(+p.x,-p.y,+p.z),new Vector3D(-p.x,-p.y,+p.z))
				this.makeLineMode(new Vector3D(-p.x,-p.y,+p.z),new Vector3D(-p.x,-p.y,-p.z))
					
				
				this.makeLineMode(new Vector3D(-p.x,+p.y,-p.z),new Vector3D(+p.x,+p.y,-p.z))
				this.makeLineMode(new Vector3D(+p.x,+p.y,-p.z),new Vector3D(+p.x,+p.y,+p.z))
				this.makeLineMode(new Vector3D(+p.x,+p.y,+p.z),new Vector3D(-p.x,+p.y,+p.z))
				this.makeLineMode(new Vector3D(-p.x,+p.y,+p.z),new Vector3D(-p.x,+p.y,-p.z))
					
					
				this.makeLineMode(new Vector3D(-p.x,-p.y,-p.z),new Vector3D(-p.x,+p.y,-p.z))
				this.makeLineMode(new Vector3D(+p.x,-p.y,-p.z),new Vector3D(+p.x,+p.y,-p.z))
				this.makeLineMode(new Vector3D(+p.x,-p.y,+p.z),new Vector3D(+p.x,+p.y,+p.z))
				this.makeLineMode(new Vector3D(-p.x,-p.y,+p.z),new Vector3D(-p.x,+p.y,+p.z))
					
					
		
			
		}
		private var _lastBallRadius:Number
		private function makeBallLine():void
		{
			
			if(_lastBallRadius&&_lastBallRadius==this.collisionVo.radius){
			    return ;//不再重绘	
			}
			_lastBallRadius=this.collisionVo.radius;
			var radiusNum100:Number=_lastBallRadius;
			this.clear();
			var num:uint=12;
			var p:Vector3D
			var m:Matrix3D
			var lastPos:Vector3D;
			var i:uint
			var j:uint;
			var bm:Matrix3D
			var bp:Vector3D
			
			

			for( j=0;j<=num;j++){
			
				lastPos=null;
				for( i=0;i<num;i++){
					p=new Vector3D(radiusNum100,0,0)
					m=new Matrix3D;
					m.appendRotation((360/num)*i,Vector3D.Z_AXIS)
					p=m.transformVector(p)
					bm=new Matrix3D;
					bm.appendRotation((360/num)*j,Vector3D.Y_AXIS)
					p=bm.transformVector(p)
					if(lastPos){
						this.makeLineMode(lastPos,p)
					}
				
					lastPos=p.clone();
				}
			}
	
			for( j=0;j<=4;j++){
				bm=new Matrix3D;
				bm.appendRotation(j*20,Vector3D.Z_AXIS);
				bp=bm.transformVector(new Vector3D(radiusNum100,0,0))
				
				
				lastPos=null;
				for( i=0;i<num;i++){
					p=bp.clone();
					m=new Matrix3D;
					m.appendRotation((360/num)*i,Vector3D.Y_AXIS)
					p=m.transformVector(p)
					if(lastPos){
						this.makeLineMode(lastPos,p)
					}
					if(i==num-1){
						this.makeLineMode(bp,p)
					}
					lastPos=p.clone();
				}
			}
			for( j=1;j<=4;j++){
				bm=new Matrix3D;
				bm.appendRotation(j*-20,Vector3D.Z_AXIS);
				bp=bm.transformVector(new Vector3D(radiusNum100,0,0))
				
				
				lastPos=null;
				for( i=0;i<num;i++){
					p=bp.clone();
					m=new Matrix3D;
					m.appendRotation((360/num)*i,Vector3D.Y_AXIS)
					p=m.transformVector(p)
					if(lastPos){
						this.makeLineMode(lastPos,p)
					}
					if(i==num-1){
						this.makeLineMode(bp,p)
					}
					lastPos=p.clone();
				}
			}
			
			
			
			
		}	
		override public function updatePosMatrix():void{
			posMatrix.identity();
			posMatrix.prependTranslation(this._x, this._y, this._z);
			posMatrix.prependRotation(_rotationZ , Vector3D.Z_AXIS);
			posMatrix.prependRotation(_rotationY , Vector3D.Y_AXIS);
			posMatrix.prependRotation(_rotationX , Vector3D.X_AXIS);

		}
		private function makeConeMesh():void
		{
			
			var w:Number=100*this._scale_x
			var h:Number=100*this._scale_y
			this.clear();
			var jindu:uint=12;
			var lastA:Vector3D;

			var i:uint
			
			
			for( i=0;i<jindu;i++){
				var a:Vector3D=new Vector3D(w,-h/2,0);
				var m:Matrix3D=new Matrix3D;
				m.appendRotation(i*(360/jindu),Vector3D.Y_AXIS);
				
				var A:Vector3D=m.transformVector(a);


				this.makeLineMode(A,new Vector3D(0,-h/2,0))
				this.makeLineMode(A,new Vector3D(0,+h/2,0))

				
				if(i==(jindu-1)){
					this.makeLineMode(A,a)
				}
				
				if(lastA){
					this.makeLineMode(A,lastA)

				}
				
				lastA=A.clone();

				
			}
		}
		private function makeCylinderMesh():void
		{
			var w:Number=100*this._scale_x
			var h:Number=100*this._scale_y
			this.clear();
			var jindu:uint=12;
			var lastA:Vector3D;
			var lastB:Vector3D;
			var i:uint
			
	
			for( i=0;i<jindu;i++){
				var a:Vector3D=new Vector3D(w,-h/2,0);
				var b:Vector3D=new Vector3D(w,+h/2,0);
				var m:Matrix3D=new Matrix3D;
				m.appendRotation(i*(360/jindu),Vector3D.Y_AXIS);
				
				var A:Vector3D=m.transformVector(a);
				var B:Vector3D=m.transformVector(b);
			
				this.makeLineMode(A,B)
					
				this.makeLineMode(A,new Vector3D(0,-h/2,0))
				this.makeLineMode(B,new Vector3D(0,+h/2,0))
					

				if(i==(jindu-1)){
					this.makeLineMode(A,a)
					this.makeLineMode(B,b)
				}
			
				if(lastA||lastB){
					this.makeLineMode(A,lastA)
					this.makeLineMode(B,lastB)
				}
				
				lastA=A.clone();
				lastB=B.clone();
				
			}
			
		
			
			
			
			
			
		

			
		}
		public function resetLineData():void
		{
			
			if(_collisionVo){
		
				this.colorVector3d=	MathCore.hexToArgbNum(_collisionVo.colorInt)
				this._thickness=0.3
				switch(_collisionVo.type)
				{
					case CollisionType.BOX:
					{
						makeBoxLine()
						
						break;
					}
					case CollisionType.BALL:
					{
						makeBallLine()
						
						break;
					}
					case CollisionType.Polygon:
					{
						makePolygonLine()
						
						break;
					}
					case CollisionType.Cylinder:
					{
						makeCylinderMesh()
						
						break;
					}
					case CollisionType.Cone:
					{
						makeConeMesh()
						
						break;
					}
						
					default:
					{
						
						break;
					}
				}
				this.uplodToGpu();
			}
		}
		
		
	
		
	}
}