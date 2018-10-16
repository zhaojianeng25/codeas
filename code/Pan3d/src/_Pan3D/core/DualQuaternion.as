package _Pan3D.core
{
	import flash.geom.Matrix3D;
	import flash.geom.Orientation3D;
	import flash.geom.Vector3D;

	public class DualQuaternion
	{
//		public var real:Quaternion;
//		public var dual:Quaternion;
		
		public var rv:Vector.<Number>;
		public var tv:Vector.<Number>;
		
		public function DualQuaternion()
		{
		}
		
		public function setMatrix(ma:Matrix3D):void{
//			float4x4 tmp_mat = mat;
			
			var mat:Matrix3D = ma.clone();

			var rst:Vector.<Vector3D> = mat.decompose(Orientation3D.QUATERNION);

			rv = Vector.<Number>([rst[1].x,rst[1].y,rst[1].z,rst[1].w]);
			tv = Vector.<Number>([rst[0].x,rst[0].y,rst[0].z,rst[0].w]);
//			
//			
//			if(rst[2].x !=1 || rst[2].y != 1 || rst[2].z != 1){
//				trace(1111);
//			}
//			
//			var testV3d:Vector3D = new Vector3D(190,65,-98);
//			
//			var real:Quaternion = new Quaternion(rst[1].x,rst[1].y,rst[1].z,rst[1].w);
//			var rv3d:Vector3D = rst[0];
//			rv3d = real.rotatePoint(testV3d);
//			//rv3d = rv3d.add(rst[0]);
////			trace(rv3d);
////			trace(mat.transformVector(testV3d));
////			trace("------") 
//			var rv3d2:Vector3D = mat.transformVector(testV3d);
//			var rv3d3:Vector3D = rv3d.subtract(rv3d2);
//			if(rv3d3.length > 1){
////				trace(rv3d); 
////				trace(rv3d2);
////				trace("-------------");
//			}

//			if (MathLib::dot(MathLib::cross(float3(tmp_mat(0, 0), tmp_mat(0, 1), tmp_mat(0, 2)),
//				float3(tmp_mat(1, 0), tmp_mat(1, 1), tmp_mat(1, 2))),
//				float3(tmp_mat(2, 0), tmp_mat(2, 1), tmp_mat(2, 2))) < 0)
//			{
//				tmp_mat(2, 0) = -tmp_mat(2, 0);
//				tmp_mat(2, 1) = -tmp_mat(2, 1);
//				tmp_mat(2, 2) = -tmp_mat(2, 2);
//				
//				flip = -1;
//			}
//			var v1:Vector3D = new Vector3D(gm(mat,0,0),gm(mat,0,1),gm(mat,0,2));
//			var v2:Vector3D = new Vector3D(gm(mat,1,0),gm(mat,1,1),gm(mat,1,2));
//			var v3:Vector3D = new Vector3D(gm(mat,2,0),gm(mat,2,1),gm(mat,2,2));
//			
//			v1 = v1.crossProduct(v2);
//			var result:Number = v1.dotProduct(v3);
//			
//			var  flip:int = 1;
//			
//			if (result < 0){
////				revers(mat, 2, 0);
////				revers(mat, 2, 1);
////				revers(mat, 2, 2);
//				
//				var data:Vector.<Number> = mat.rawData;
//				data[2] *= -1;
//				data[6] *= -1;
//				data[10] *= -1;
//				mat.rawData = data;
//				//var rev:Vector3D = new Vector3D(-gm(mat,2,0),-gm(mat,2,1),-gm(mat,2,2),gm(mat,2,3));
//				//mat.copyColumnTo(2,rev);
//			
//				flip = -1;
//			}
//			
//			
//			
//			var qu:Quaternion = new Quaternion(rst[0].x * 0.5,rst[0].y * 0.5,rst[0].z * 0.5,0);
//			
//			var dual:Quaternion = new Quaternion();
//			var real:Quaternion = new Quaternion(rst[1].x,rst[1].y,rst[1].z,rst[1].w);
//			dual.multiply(qu,real);
//			
//			if (flip * real.w < 0){
//				real.neg();
//				dual.neg();
//			}
//			
//			rv = Vector.<Number>([real.x,real.y,real.z,real.w]);
//			tv = Vector.<Number>([dual.x,dual.y,dual.z,dual.w]);
// 
		}
		
		private function gm(mat:Matrix3D,i:int,j:int):Number{
			return mat.rawData[j*4+i];
		}
		private function revers(mat:Matrix3D,i:int,j:int):void{
			mat.rawData[j*4+i] *= -1;
		}
		
		
	}
}