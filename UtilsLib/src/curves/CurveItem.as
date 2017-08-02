package curves
{
	import flash.geom.Vector3D;

	public class CurveItem
	{
		public var vec3:Vector3D;
		private var _rotationVec:Vector3D;
		private var _rotationLeft:Vector3D;
		private var _curveType:Vector3D
		private var _curveTypeLeft:Vector3D
		
		public var time:Number;
		public var frame:int;
		
		public var valueVec0:Vector.<Number>;
		public var valueVec1:Vector.<Number>;
		public var valueVec2:Vector.<Number>;
		public var valueVec3:Vector.<Number>; 
		
		public function CurveItem()
		{
			
		}
		
		public function get curveTypeLeft():Vector3D
		{
			return _curveTypeLeft;
		}

		public function set curveTypeLeft(value:Vector3D):void
		{
			_curveTypeLeft = value;
		}

		public function get rotationLeft():Vector3D
		{
			return _rotationLeft;
		}

		public function set rotationLeft(value:Vector3D):void
		{
			_rotationLeft = value;
		}

		public function get curveType():Vector3D
		{
			return _curveType;
		}

		public function set curveType(value:Vector3D):void
		{
			_curveType = value;
		}

		public function get rotationVec():Vector3D
		{
			return _rotationVec;
		}

		public function set rotationVec(value:Vector3D):void
		{
			_rotationVec = value;
		}

		public function getData():Object{
			var obj:Object = new Object;
			obj.vec3 = this.vec3;
			obj.rotation = this._rotationVec;
			obj.rotationLeft = this._rotationLeft;
			obj.frame = this.frame;
			obj.time = this.time;
			obj.curveType = this._curveType;
			obj.curveTypeLeft = this._curveTypeLeft;
			return obj;
		}
		
		public function setData(obj:Object):void{
			this.vec3 = new Vector3D(obj.vec3.x,obj.vec3.y,obj.vec3.z,obj.vec3.w);
			this._rotationVec = new Vector3D(obj.rotation.x,obj.rotation.y,obj.rotation.z,obj.rotation.w);
			if(obj.rotationLeft){
				this._rotationLeft= new Vector3D(obj.rotationLeft.x,obj.rotationLeft.y,obj.rotationLeft.z,obj.rotationLeft.w);
			}else{
				this._rotationLeft=new Vector3D
			}
			if(obj.curveType){
				this._curveType=new Vector3D(obj.curveType.x,obj.curveType.y,obj.curveType.z,obj.curveType.w);
			}else{
				this._curveType=new Vector3D(CurveType.A,CurveType.A,CurveType.A,CurveType.A)
			}
			if(obj.curveTypeLeft){
				this._curveTypeLeft=new Vector3D(obj.curveTypeLeft.x,obj.curveTypeLeft.y,obj.curveTypeLeft.z,obj.curveTypeLeft.w);
			}else{
				this._curveTypeLeft=new Vector3D(CurveType.A,CurveType.A,CurveType.A,CurveType.A)
			}
			trace(vec3.x,vec3.y,vec3.z,vec3.w)
			
			//vec3=new Vector3D(0,0,0,0)
			
			this.frame = obj.frame;
			this.time = obj.time;
		}
		
	}
}