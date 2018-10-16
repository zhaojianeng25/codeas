package renderLevel.levels
{
	import _Pan3D.base.ObjData;
	import _Pan3D.display3D.Display3DSprite;
	
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	public class Particle3DFacet extends Display3DSprite
	{
		private var verterList:Vector.<Vector3D>;
		private var xAxis:Vector3D;
		private var yAxis:Vector3D;
		private var zAxis:Vector3D;
		
		private var NormalVector:Vector3D;
		
		private var posRotationMatrix:Matrix3D;
		
		public function Particle3DFacet(context:Context3D)
		{
			super(context);
			
			
			
			initData();
		}
		private var width:Number = 1;
		private var height:Number = 1;
		
		
		private function initData():void{
			_objData=new ObjData;
			
			posRotationMatrix = new Matrix3D;
			
			xAxis = new Vector3D(1,0,0);
			yAxis = new Vector3D(0,1,0);
			zAxis = new Vector3D(0,0,1);
			
			verterList = new Vector.<Vector3D>;
			
			var uvAry:Array = new Array();
			var indexAry:Array = new Array();
			
			verterList.push(new Vector3D(-width,-height,0));
			verterList.push(new Vector3D(width,-height,0));
			verterList.push(new Vector3D(-width,height,0));
			verterList.push(new Vector3D(width,height,0));
			
			refershVertex();
			
			uvAry.push(0,0);
			uvAry.push(0,1);
			uvAry.push(1,1);
			uvAry.push(1,0);
			
			indexAry.push(0,1,2,1,3,2);
			
			_objData.uvBuffer = this._context.createVertexBuffer(uvAry.length / 2, 2);
			_objData.uvBuffer.uploadFromVector(Vector.<Number>(uvAry), 0, uvAry.length / 2);
			
			_objData.indexBuffer = this._context.createIndexBuffer(indexAry.length);
			_objData.indexBuffer.uploadFromVector(Vector.<uint>(indexAry), 0, indexAry.length);
			
			var tempBmp:BitmapData = new BitmapData(512,512,true,0xffffffff);
			_objData.texture=_context.createTexture(tempBmp.width,tempBmp.height, Context3DTextureFormat.BGRA,true);
			_objData.texture.uploadFromBitmapData(tempBmp);
			
			//rotationXangle(45);
		}
		
		private function refershVertex():void{
			var vertexAry:Array=new Array();
			
			for(var i:int;i<verterList.length;i++){
				vertexAry.push(verterList[i].x,verterList[i].y,verterList[i].z);
			}
			if(!_objData.vertexBuffer)
				_objData.vertexBuffer = this._context.createVertexBuffer(vertexAry.length / 3, 3);
			_objData.vertexBuffer.uploadFromVector(Vector.<Number>(vertexAry), 0, vertexAry.length / 3);
			
		}
		
		public function rotationXangle(value:Number):void{
			for(var i:int;i<verterList.length;i++){
				verterList[i] = Rotate_Point3D(value,xAxis,verterList[i]);
			}
			rotationAxis(value,xAxis);
			xAxis.normalize();
//			var sin:Number = Math.sin(value * Math.PI/180);
//			var cos:Number = Math.cos(value * Math.PI/180);
//			
//			for(var i:int;i<verterList.length;i++){
//				var tmp_ry:Number=verterList[i].y;
//				verterList[i].y = cos * tmp_ry - sin * verterList[i].z;
//				verterList[i].z = sin * tmp_ry + cos * verterList[i].z;
//			}
			
			//refershVertex();
			
		}
		public function rotationYangle(value:Number):void{
			for(var i:int;i<verterList.length;i++){
				verterList[i] = Rotate_Point3D(value,yAxis,verterList[i]);
			}
			rotationAxis(value,yAxis);
			yAxis.normalize();
//			var sin:Number = Math.sin(value * Math.PI/180);
//			var cos:Number = Math.cos(value * Math.PI/180);
//			
//			for(var i:int;i<verterList.length;i++){
//				var tmp_rx:Number=verterList[i].x;
//				verterList[i].x = cos * tmp_rx - sin * verterList[i].z;
//				verterList[i].z = sin * tmp_rx + cos * verterList[i].z;
//			}
			
			//refershVertex();
		}
		public function rotationZangle(value:Number):void{
			for(var i:int;i<verterList.length;i++){
				verterList[i] = Rotate_Point3D(value,zAxis,verterList[i]);
			}
			rotationAxis(value,zAxis);
			zAxis.normalize();
//			var sin:Number = Math.sin(value * Math.PI/180);
//			var cos:Number = Math.cos(value * Math.PI/180);
//			
//			for(var i:int;i<verterList.length;i++){
//				var tmp_rx:Number=verterList[i].x;
//				verterList[i].x = cos * tmp_rx - sin * verterList[i].y;
//				verterList[i].y = sin * tmp_rx + cos * verterList[i].y;
//			}
			
			//refershVertex();
		}
		
		private function rotationAxis(theta:Number, axis:Vector3D):void{
			var tempAxis:Vector3D = new Vector3D(axis.x,axis.y,axis.z);
			xAxis = Rotate_Point3D(theta,tempAxis,xAxis);
			yAxis = Rotate_Point3D(theta,tempAxis,yAxis);
			zAxis = Rotate_Point3D(theta,tempAxis,zAxis);
			
			NormalVector = zAxis;
		}
		
		public function rotationXYZangle(x:Number,y:Number,z:Number):void{
			verterList = new Vector.<Vector3D>;
			
			verterList.push(new Vector3D(-width,-height,0));
			verterList.push(new Vector3D(width,-height,0));
			verterList.push(new Vector3D(-width,height,0));
			verterList.push(new Vector3D(width,height,0));
			
			xAxis = new Vector3D(1,0,0);
			yAxis = new Vector3D(0,1,0);
			zAxis = new Vector3D(0,0,1);
			
			rotationXangle(x);
			rotationYangle(y);
			rotationZangle(z);
			
			refershVertex();
		}
		
		public function Rotate_Point3D(theta:Number, axis:Vector3D, ptIn:Vector3D):Vector3D{
			var nx:Number = axis.x;
			var ny:Number = axis.y;
			var nz:Number = axis.z;
			
//			var len:Number = Math.sqrt(nx*nx + ny*ny + nz*nz);
//			nx /= len;
//			ny /= len;    
//			nz /= len;
			
			var cos:Number = Math.cos(theta * Math.PI/180);
			var sin:Number = Math.sin(theta * Math.PI/180);
			var ptOut:Vector3D = new Vector3D;
			ptOut.x =  ptIn.x * (cos + nx * nx * (1 - cos)) +    
				ptIn.y * (nx * ny * (1 - cos) - nz * sin) + 
				ptIn.z * (nx * nz * (1 - cos) + ny * sin);
			ptOut.y = ptIn.x * (nx * ny * (1 - cos) + nz * sin) +  
				ptIn.y * (ny * ny * (1 - cos) + cos) + 
				ptIn.z * (ny * nz * (1 - cos) - nx * sin);
			ptOut.z = ptIn.x * (nx * nz * (1 - cos) - ny * sin) + 
				ptIn.y * (ny * nz * (1 -cos) + nx * sin) + 
				ptIn.z * (nz * nz * (1 - cos) + cos);
			return ptOut;
		}
		
		public var rotationNum:Number = 0;
		public function rotation():void{
			posMatrix.identity();
			posMatrix.prependTranslation(this._absoluteX, this._absoluteY, this._absoluteZ);
			posMatrix.prependScale(this._scale,this._scale,this._scale);
			posMatrix.prependRotation(rotationNum , NormalVector);
		}
		public function rotationByAxis():void{
			posMatrix.identity();
			posMatrix.prependTranslation(this._absoluteX, this._absoluteY, this._absoluteZ);
			posMatrix.prependScale(this._scale,this._scale,this._scale);
			posMatrix.prependRotation(rotationNum , new Vector3D(0,0,1),new Vector3D(-3,0,0));
			posMatrix.prependTranslation(rotationNum/100, 0, 0);
		}
		public function revolution():void{
			posMatrix.identity();
			posMatrix.prependTranslation(this._absoluteX, this._absoluteY, this._absoluteZ);
			posMatrix.prependScale(this._scale,this._scale,this._scale);
			posMatrix.prependRotation(rotationNum , new Vector3D(0,0,1),new Vector3D(-3,0,0));
			posMatrix.prependRotation(-rotationNum , new Vector3D(0,0,1));
		}
		
		
		
		
		
		
		
		
	}
}