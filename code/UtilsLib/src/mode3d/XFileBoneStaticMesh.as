package mode3d
{
	import flash.events.Event;
	
	import pack.Prefab;
	
	public class XFileBoneStaticMesh extends Prefab
	{
		

		private var _motion:Object
		private var _boneMotion0:Object
		private var _boneMotion1:Object
		private var _boneMotion2:Object
		private var _boneMotion3:Object
		private var _boneMotion4:Object
		private var _boneMotion5:Object
		private var _boneMotion6:Object
		private var _boneMotion7:Object
		private var _boneMotion8:Object
		private var _boneMotion9:Object
		private var _boneMotion10:Object
		private var _boneMotion11:Object
		private var _boneMotion12:Object
		private var _boneMotion13:Object
		private var _boneMotion14:Object
		private var _boneMotion15:Object
		private var _boneMotion16:Object
		private var _boneMotion17:Object
		private var _boneMotion18:Object
		private var _boneMotion19:Object
		private var _boneMotion20:Object
		private var _boneMotion21:Object
		private var _boneMotion22:Object
		private var _boneMotion23:Object
		private var _boneMotion24:Object
		

		public function XFileBoneStaticMesh()
		{
			super();
		}

	
		public function change():void{
			this.dispatchEvent(new Event(Event.CHANGE));
		}

		public function get boneMotion0():Object
		{
			return _boneMotion0;
		}
		[Editor(type="BoneMotionModePic",Label="BON",extensinonStr="bon|boq",sort="10",changePath="1",Category="motion0")]
		public function set boneMotion0(value:Object):void
		{
			_boneMotion0 = value;
			change();
		}

		public function get boneMotion1():Object
		{
			return _boneMotion1;
		}
		[Editor(type="BoneMotionModePic",Label="BON",extensinonStr="bon|boq",sort="11",changePath="1",Category="motion1")]
		public function set boneMotion1(value:Object):void
		{
			_boneMotion1 = value;
			change();
		}

		public function get boneMotion2():Object
		{
			return _boneMotion2;
		}
		[Editor(type="BoneMotionModePic",Label="BON",extensinonStr="bon|boq",sort="12",changePath="1",Category="motion2")]
		public function set boneMotion2(value:Object):void
		{
			_boneMotion2 = value;
			change();
		}

		public function get boneMotion3():Object
		{
			return _boneMotion3;
		}
		[Editor(type="BoneMotionModePic",Label="BON",extensinonStr="bon|boq",sort="13",changePath="1",Category="motion3")]
		public function set boneMotion3(value:Object):void
		{
			_boneMotion3 = value;
			change();
		}

		public function get boneMotion4():Object
		{
			return _boneMotion4;
		}
		[Editor(type="BoneMotionModePic",Label="BON",extensinonStr="bon|boq",sort="14",changePath="1",Category="motion4")]
		public function set boneMotion4(value:Object):void
		{
			_boneMotion4 = value;
			change();
		}

		public function get boneMotion5():Object
		{
			return _boneMotion5;
		}
		[Editor(type="BoneMotionModePic",Label="BON",extensinonStr="bon|boq",sort="15",changePath="1",Category="motion5")]
		public function set boneMotion5(value:Object):void
		{
			_boneMotion5 = value;
			change();
		}

		public function get boneMotion6():Object
		{
			return _boneMotion6;
		}
		[Editor(type="BoneMotionModePic",Label="BON",extensinonStr="bon|boq",sort="16",changePath="1",Category="motion6")]
		public function set boneMotion6(value:Object):void
		{
			_boneMotion6 = value;
			change();
		}

		public function get motion():Object
		{
			return _motion;
		}

		public function set motion(value:Object):void
		{
			_motion = value;
			
			for(var j:uint=0;j<6;j++)
			{
				var $obj:Object=new Object
				$obj.motionID=j
				this["boneMotion"+j]=$obj
			}
			
			var $id:uint=0
			if(_motion){
				
				for(var i:uint=0;i<_motion.length&&$id<=6;i++)
				{
					if(_motion[i]){
						this["boneMotion"+$id]=_motion[i]
						$id++
					}
				}
			}
			
			
		}

		override public function getName():String
		{
			return "Bone_"+csvID;
		}
	}
}