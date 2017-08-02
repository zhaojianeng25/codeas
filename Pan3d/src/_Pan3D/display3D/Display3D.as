package _Pan3D.display3D {
	import flash.display3D.Program3D;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import _Pan3D.display3D.interfaces.IDisplay3DContainer;
	
	import _me.Scene_data;
	/**
	 * @author liuyanfei  QQ: 421537900
	 */
	public class Display3D extends EventDispatcher
	{
		protected var _x:Number = 0;
		protected var _y:Number = 0;
		protected var _z:Number = 0;
		protected var _lastx:Number = 0;
		protected var _lasty:Number = 0;
		protected var _lastz:Number = 0;
		protected var _id:int=0;
		protected var _name:String;
		protected var _rotationX:Number = 0;
		protected var _rotationY:Number = 0;
		protected var _rotationZ:Number = 0;
		
		protected var _scale:Number = 1;
		protected var _scale_x:Number = 1;
		protected var _scale_y:Number = 1;
		protected var _scale_z:Number = 1;
		
		public var modelMatrix:Matrix3D;
		public var posMatrix:Matrix3D;
		protected var _parent:IDisplay3DContainer;
	
		
		protected var _absoluteX:Number = 0;
		protected var _absoluteY:Number = 0;
		protected var _absoluteZ:Number = 0;
		
		protected var _visible:Boolean = true;
		
		public var loadComplete:Boolean;
		protected var _program:Program3D;
		
		
		public var isInGroup:Boolean;
		public var groupPos:Vector3D;
		public var groupScale:Vector3D;
		public var groupRotation:Vector3D;
	
		
		
		public function Display3D()
		{
			modelMatrix = new Matrix3D;
			posMatrix = new Matrix3D;
			//updataPos();
		}
		
		public function get scale_z():Number
		{
			return _scale_z;
		}

		public function set scale_z(value:Number):void
		{
			_scale_z = value;
			updatePosMatrix();
		}

		public function get scale_y():Number
		{
			return _scale_y;
		}

		public function set scale_y(value:Number):void
		{
			_scale_y = value;
			updatePosMatrix();
		}

		public function get scale_x():Number
		{
			return _scale_x;
		}

		public function set scale_x(value:Number):void
		{
			_scale_x = value;
			updatePosMatrix();
		}

		public function get lastz():Number
		{
			return _lastz;
		}

		public function set lastz(value:Number):void
		{
			_lastz = value;
		}

		public function get lasty():Number
		{
			return _lasty;
		}

		public function set lasty(value:Number):void
		{
			_lasty = value;
		}

		public function get lastx():Number
		{
			return _lastx;
		}

		public function set lastx(value:Number):void
		{
			_lastx = value;
		}

		public function get x():Number
		{
			return _x;
		}

		public function set x(value:Number):void
		{
			_x = value;
			updataPos();
		}

		public function get y():Number
		{
			return _y;
		}

		public function set y(value:Number):void
		{
			_y = value;
			updataPos();
		}

		public function get z():Number
		{
			return _z;
		}

		public function set z(value:Number):void
		{
			_z = value;
			updataPos();
		}

		public function get rotationX():Number
		{
			return _rotationX;
		}

		public function set rotationX(value:Number):void
		{
			_rotationX = value;
			updatePosMatrix();
		}

		public function get rotationY():Number
		{
			return _rotationY;
		}

		public function set rotationY(value:Number):void
		{
			_rotationY = value;
			updatePosMatrix();
		}

		public function get rotationZ():Number
		{
			return _rotationZ;
		}

		public function set rotationZ(value:Number):void
		{
			_rotationZ = value;
			updatePosMatrix();
		}

		public function get scale():Number
		{
			return _scale;
		}

		public function set scale(value:Number):void
		{
			_scale = value;
			_scale_x = value;
			_scale_y = value;
			_scale_z = value;
			updatePosMatrix();
		}
		
		public function updateMatrix():void{
			modelMatrix.identity();
			modelMatrix.prepend(Scene_data.cam3D.cameraMatrix);
			modelMatrix.prepend(posMatrix);
		}

		public function get parent():IDisplay3DContainer
		{
			return _parent;
		}

		public function set parent(value:IDisplay3DContainer):void
		{
			_parent = value;
			updataPos();
		}
		
		public function updataPos():void{
			if(this._parent){
				this._absoluteX = this._x*Scene_data.mainRelateScale + this._parent.absoluteX;
				this._absoluteY = this._y*Scene_data.mainRelateScale + this._parent.absoluteY;
				this._absoluteZ = this._z*Scene_data.mainRelateScale + this._parent.absoluteZ;
			}else{
				this._absoluteX = this._x*Scene_data.mainRelateScale;
				this._absoluteY = this._y*Scene_data.mainRelateScale;
				this._absoluteZ = this._z*Scene_data.mainRelateScale;
			}
			updatePosMatrix();
		}
		
		public function updatePosMatrix():void{
			posMatrix.identity();
			posMatrix.prependTranslation(this._absoluteX, this._absoluteY, this._absoluteZ);
			posMatrix.prependScale(this._scale_x,this._scale_y,this._scale_z);
			posMatrix.prependRotation(_rotationY , Vector3D.Y_AXIS);
		}
		
	
		
		public function get absoluteX():Number
		{
			return _absoluteX;
		}

		public function set absoluteX(value:Number):void
		{
			_absoluteX = value;
		}

		public function get absoluteY():Number
		{
			return _absoluteY;
		}

		public function set absoluteY(value:Number):void
		{
			_absoluteY = value;
		}

		public function get absoluteZ():Number
		{
			return _absoluteZ;
		}

		public function set absoluteZ(value:Number):void
		{
			_absoluteZ = value;
		}
		
		public function setProgram3D(value:Program3D):void{
			program = value;
		}

		public function get visible():Boolean
		{
			return _visible;
		}

		public function set visible(value:Boolean):void
		{
			_visible = value;
		}

		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function set name(value:String):void
		{
			_name = value;
		}

		public function get program():Program3D
		{
			return _program;
		}

		public function set program(value:Program3D):void
		{
			_program = value;
		}
		public function dispose():void
		{
			modelMatrix = null;
			posMatrix = null;
			_parent = null;
		}

	}
}