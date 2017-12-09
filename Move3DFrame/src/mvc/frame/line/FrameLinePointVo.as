package mvc.frame.line
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import _Pan3D.base.Object3D;
	

	public class FrameLinePointVo  extends Object3D
	{

		public var time:uint;
		public var id:Number;
		public var iskeyFrame:Boolean;
		public var isAnimation:Boolean;
		public var data:Object;
		public var slectFlag:Boolean
		public function FrameLinePointVo()
		{
			this.iskeyFrame=true
		}
		public function getObject():Object
		{
			
			var $obj:Object=new Object;
			
			$obj.time=this.time;
			$obj.id=this.id;
			$obj.iskeyFrame=this.iskeyFrame;
			$obj.isAnimation=this.isAnimation;
			
			
			$obj.x=this.x
			$obj.y=this.y
			$obj.z=this.z
			
			$obj.scaleX=this.scale_x
			$obj.scaleY=this.scale_y
			$obj.scaleZ=this.scale_z
			$obj.data=this.data
				

			$obj.rotationX=this.rotationX
			$obj.rotationY=this.rotationY
			$obj.rotationZ=this.rotationZ
			return $obj;
		}
	 	public function cloneVo():FrameLinePointVo
		{
		
			var $vo:FrameLinePointVo=new FrameLinePointVo();
			$vo.time=this.time;
			$vo.id=this.id;
			$vo.iskeyFrame=this.iskeyFrame;
			$vo.isAnimation=this.isAnimation;
			
			$vo.x=this.x
			$vo.y=this.y
			$vo.z=this.z
			$vo.scale_x=this.scale_x
			$vo.scale_y=this.scale_y
			$vo.scale_z=this.scale_z
			$vo.rotationX=this.rotationX
			$vo.rotationY=this.rotationY
			$vo.rotationZ=this.rotationZ
			$vo.data=this.data
			return $vo
		}
		
		public function writeObject($obj:Object):void
		{
			
	
			
			this.time=$obj.time;
			this.iskeyFrame=$obj.iskeyFrame;
			this.isAnimation=$obj.isAnimation;
			
			this.id=$obj.id;
			
			this.x=$obj.x;
			this.y=$obj.y;
			this.z=$obj.z;
			
			this.scale_x=$obj.scaleX;
			this.scale_y=$obj.scaleY;
			this.scale_z=$obj.scaleZ;
			
			this.rotationX=$obj.rotationX;
			this.rotationY=$obj.rotationY;
			this.rotationZ=$obj.rotationZ;
			this.data=$obj.data
			
		}
		
		public static function copyto($a:FrameLinePointVo, $b:Object):void
		{

			$b.x=$a.x;
			$b.y=$a.y;
			$b.z=$a.z;
			
			$b.scale_x=$a.scale_x;
			$b.scale_y=$a.scale_y;
			$b.scale_z=$a.scale_z;
			
			$b.rotationX=$a.rotationX;
			$b.rotationY=$a.rotationY;
			$b.rotationZ=$a.rotationZ;
			
			
			
		}
		public function getMatrix3D():Matrix3D
		{
		
			var $m:Matrix3D=new Matrix3D;
			$m.prependTranslation(this.x, this.y, this.z);
			$m.prependScale(this.scale_x,this.scale_y,this.scale_z);
			$m.prependRotation(this.rotationZ , Vector3D.Z_AXIS);
			$m.prependRotation(this.rotationY , Vector3D.Y_AXIS);
			$m.prependRotation(this.rotationX , Vector3D.X_AXIS);
			
			return $m
			
		}
		
		public function setMatrix3D(value:Matrix3D):void
		{
			var vv:Vector.<Vector3D>=(value.clone()).decompose();
			var q:Vector3D=vv[0];//  平移
			var $arxi:Vector3D=vv[1];//  旋转
			var e:Vector3D=vv[2];//  缩放
		
			this.x=q.x;
			this.y=q.y;
			this.z=q.z;
			
			this.scale_x=e.x;
			this.scale_y=e.y;
			this.scale_z=e.z;
		
			$arxi.scaleBy(180/Math.PI)
			this.rotationX=$arxi.x;
			this.rotationY=$arxi.y;
			this.rotationZ=$arxi.z;
			
		}
	}
}