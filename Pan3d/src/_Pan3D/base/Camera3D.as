package _Pan3D.base{
	import flash.geom.Matrix3D;
	
	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	//镜头对象
	public class Camera3D extends Object3D {

		public var br:Number=1.8304877;
		public var fovw:Number=1024;
		public var fovh:Number =600;
		public var distance:Number = 0;
		public var outofsight:Number = 1000;
		public var move:Boolean = true;
		public var sin_x:Number = 0;
		public var cos_x:Number = 0;
		public var sin_y:Number = 0;
		public var cos_y:Number = 0;
		public var area:String;
		public var cameraMatrix:Matrix3D=new Matrix3D();
		public var camera2dMatrix:Matrix3D=new Matrix3D();
		public var camera3dMatrix:Matrix3D=new Matrix3D();

		
	
		
		public function Camera3D(temp_obj:Object=null):void {
			
			
			
		}
		public function cloneCamera() : Camera3D {
			var camera3D:Camera3D=new Camera3D({});
			camera3D.distance=distance;
			camera3D.fovw=fovw;
			camera3D.fovh=fovh;
			return camera3D;
		}
		
	}
	
}