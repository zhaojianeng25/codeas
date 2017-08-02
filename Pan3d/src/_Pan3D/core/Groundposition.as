package _Pan3D.core {
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import _Pan3D.base.Camera3D;
	import _Pan3D.base.Object3D;
	
	import _me.Scene_data;

	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class Groundposition {
		//private static var _thisCam : Camera3D = new Camera3D({});
		private static var _vitem : Vector.<Object3D> = new Vector.<Object3D>;

		public function Groundposition() : void {
		}
		private static function _pushpoint(_obj : Object3D) : void {
			var _temp : Object3D = new Object3D();
			_temp.x = _obj.x;
			_temp.y = _obj.y;
			_temp.z = _obj.z;
			_temp.rx = 0;
			_temp.ry = 0;
			_temp.rz = 0;
			_vitem.push(_temp);
		}
		public static function _getMouseMovePosition():Object3D
		{
			var baceObject3D:Object3D=new Object3D;
			baceObject3D.rx=(Scene_data.stage.mouseX-Scene_data.cam3D.fovw/2)/Scene_data.cam3D.fovw*Scene_data.cam3D.distance;
			baceObject3D.ry=-(Scene_data.stage.mouseY-Scene_data.cam3D.fovh/2)/Scene_data.cam3D.fovw*Scene_data.cam3D.distance;
			baceObject3D.rz=Scene_data.cam3D.distance;
			Calculation._anti_computing_point_copy( baceObject3D,Scene_data.cam3D);
			return baceObject3D
		}
		public static function _getposition(_sceneCam : Camera3D, f : Number, g : Number) : Object3D {
			_vitem = new Vector.<Object3D>;  //设定一个三角形，等会要跟据镜头的射线，来取得相交的点。（形容地面上的一个平面）
			_pushpoint(new Object3D(0,0, 500));
			_pushpoint(new Object3D(-500, 0, 0));
			_pushpoint(new Object3D(500, 0, 0));
			
			//复制镜头，因为这个新的镜头有别于原来;

			for each (var object3D:Object3D in _vitem) {
				math_change_point(object3D);
			}
			return Calculation._get_hit_rec(_vitem[0], _vitem[1], _vitem[2], _sceneCam, f - _sceneCam.fovw / 2,  _sceneCam.fovh / 2-g);
		}
	    public static function getScene3DPoint():Object3D
		{
			var _E:Object3D=Groundposition._getposition(Scene_data.cam3D, Scene_data.stage.mouseX - Scene_data.stage3D.x, Scene_data.stage.mouseY - Scene_data.stage3D.y);
			var endX:int=Scene_data.cam3D.x + _E.x;
			var endZ:int=Scene_data.cam3D.z + _E.z;
			return new Object3D(endX,0,endZ);
		}
		public static function math_change_point(_3dpoint : Object3D) : void {
			//对坐标系里的原始点，跟据镜头角度算出新的从坐标
		
			var rx : Number = _3dpoint.x - Scene_data.cam3D.x;
			var ry : Number = _3dpoint.y - Scene_data.cam3D.y;
			var rz : Number = _3dpoint.z - Scene_data.cam3D.z;
			
			var $m:Matrix3D=new Matrix3D;
			$m.appendRotation(Scene_data.cam3D.angle_y,Vector3D.Y_AXIS);
			$m.appendRotation(Scene_data.cam3D.angle_x,Vector3D.X_AXIS);
			var $p:Vector3D=$m.transformVector(new Vector3D(rx, ry, rz))
			_3dpoint.rx=$p.x 
			_3dpoint.ry=$p.y
			_3dpoint.rz=$p.z

		}
		
		/**
		 * 
		 * @param $p 屏幕鼠标点
		 * @return 返回屏幕射线的点，然后可以做为和镜头所
		 * 
		 */
		public static function  mouseHitInWorld3D($p:Point):Vector3D
		{
			var $v:Vector3D=new Vector3D
			$v.x=$p.x-Scene_data.stageWidth/2
			$v.y=Scene_data.stageHeight/2-$p.y
			$v.z=Scene_data.sceneViewHW*2;
			var $m:Matrix3D=new Matrix3D;
			$m.appendRotation(-Scene_data.cam3D.angle_x,Vector3D.X_AXIS)
			$m.appendRotation(-Scene_data.cam3D.angle_y,Vector3D.Y_AXIS)
			$m.appendTranslation(Scene_data.cam3D.x,Scene_data.cam3D.y,Scene_data.cam3D.z)
			return $m.transformVector($v);
		}
	}
}