package mode3d
{
	import flash.events.Event;
	
	import pack.Prefab;

	public class XFileMode3DStaticMesh extends Prefab
	{
		

	
		private var _boneID:int
		private var _boneMesh:XFileBoneStaticMesh
		private var _showLevel:int
		private var _renderLevel:int
		private var _unitType:int
		private var _fogEffect:Boolean
		private var _shadow:Boolean
		private var _waterReflection:Boolean
		private var _lookCamera:Number
		private var _zTestType:Number
		private var _isColorAdd:Boolean
		private var _alpha:Number
		private var _alphaIn:Number
		private var _alphaOut:Number
		private var _needUnzip:Boolean
		private var _isEarthApplique:Boolean
		
		private var _motion:Object
		private var _motionObjAxm0:Object
		private var _motionObjAxm1:Object
		private var _motionObjAxm2:Object
		private var _motionObjAxm3:Object
		private var _motionObjAxm4:Object
		private var _motionObjAxm5:Object
		private var _motionObjAxm6:Object
		private var _motionObjAxm7:Object
		private var _motionObjAxm8:Object
		private var _motionObjAxm9:Object
		private var _motionObjAxm10:Object
		private var _motionObjAxm11:Object
		private var _motionObjAxm12:Object
		private var _motionObjAxm13:Object
		private var _motionObjAxm14:Object
		private var _motionObjAxm15:Object
		private var _motionObjAxm16:Object
		private var _motionObjAxm17:Object
		private var _motionObjAxm18:Object
		private var _motionObjAxm19:Object

		

		public function XFileMode3DStaticMesh()
		{
		}

		public function get motionObjAxm0():Object
		{
			return _motionObjAxm0;
		}
		[Editor(type="MotionModelPic",Label="AXM",extensinonStr="axm",sort="10",changePath="1",Category="motion0")]
		public function set motionObjAxm0(value:Object):void
		{
			_motionObjAxm0 = value;
			
			change();
		}
		public function get motionObjAxm1():Object
		{
			return _motionObjAxm1;
		}
		[Editor(type="MotionModelPic",Label="AXM",extensinonStr="axm",sort="11",changePath="1",Category="motion1")]
		public function set motionObjAxm1(value:Object):void
		{
			_motionObjAxm1 = value;
			change();
		}


		public function get motionObjAxm2():Object
		{
			return _motionObjAxm2;
		}
		[Editor(type="MotionModelPic",Label="AXM",extensinonStr="axm",sort="12",changePath="1",Category="motion2")]
		public function set motionObjAxm2(value:Object):void
		{
			_motionObjAxm2 = value;
			change();
		}

		public function get motionObjAxm3():Object
		{
			return _motionObjAxm3;
		}
		[Editor(type="MotionModelPic",Label="AXM",extensinonStr="axm",sort="13",changePath="1",Category="motion3")]
		public function set motionObjAxm3(value:Object):void
		{
			_motionObjAxm3 = value;
			change();
		}

		public function get motionObjAxm4():Object
		{
			return _motionObjAxm4;
		}
		[Editor(type="MotionModelPic",Label="AXM",extensinonStr="axm",sort="14",changePath="1",Category="motion4")]
		public function set motionObjAxm4(value:Object):void
		{
			_motionObjAxm4 = value;
			change();
		}

		public function get motionObjAxm5():Object
		{
			return _motionObjAxm5;
		}
		[Editor(type="MotionModelPic",Label="AXM",extensinonStr="axm",sort="15",changePath="1",Category="motion5")]
		public function set motionObjAxm5(value:Object):void
		{
			_motionObjAxm5 = value;
			change();
		}

		public function get motionObjAxm6():Object
		{
			return _motionObjAxm6;
		}
		[Editor(type="MotionModelPic",Label="AXM",extensinonStr="axm",sort="16",changePath="1",Category="motion6")]
		public function set motionObjAxm6(value:Object):void
		{
			_motionObjAxm6 = value;
			change();
		}

		public function get motionObjAxm7():Object
		{
			return _motionObjAxm7;
		}
		[Editor(type="MotionModelPic",Label="AXM",extensinonStr="axm",sort="17",changePath="1",Category="motion7")]
		public function set motionObjAxm7(value:Object):void
		{
			_motionObjAxm7 = value;
			change();
		}

		public function get motionObjAxm8():Object
		{
			return _motionObjAxm8;
		}
		[Editor(type="MotionModelPic",Label="AXM",extensinonStr="axm",sort="18",changePath="1",Category="motion8")]
		public function set motionObjAxm8(value:Object):void
		{
			_motionObjAxm8 = value;
			change();
		}

		public function get motionObjAxm9():Object
		{
			return _motionObjAxm9;
		}
		[Editor(type="MotionModelPic",Label="AXM",extensinonStr="axm",sort="19",changePath="1",Category="motion9")]
		public function set motionObjAxm9(value:Object):void
		{
			_motionObjAxm9 = value;
			change();
		}

		public function get motionObjAxm10():Object
		{
			return _motionObjAxm10;
		}

		public function set motionObjAxm10(value:Object):void
		{
			_motionObjAxm10 = value;
		}

		public function get motionObjAxm11():Object
		{
			return _motionObjAxm11;
		}

		public function set motionObjAxm11(value:Object):void
		{
			_motionObjAxm11 = value;
		}

		public function get motionObjAxm12():Object
		{
			return _motionObjAxm12;
		}

		public function set motionObjAxm12(value:Object):void
		{
			_motionObjAxm12 = value;
		}

		public function get motionObjAxm13():Object
		{
			return _motionObjAxm13;
		}

		public function set motionObjAxm13(value:Object):void
		{
			_motionObjAxm13 = value;
		}

		public function get motionObjAxm14():Object
		{
			return _motionObjAxm14;
		}

		public function set motionObjAxm14(value:Object):void
		{
			_motionObjAxm14 = value;
		}

		public function get motionObjAxm15():Object
		{
			return _motionObjAxm15;
		}

		public function set motionObjAxm15(value:Object):void
		{
			_motionObjAxm15 = value;
		}

		public function get motionObjAxm16():Object
		{
			return _motionObjAxm16;
		}

		public function set motionObjAxm16(value:Object):void
		{
			_motionObjAxm16 = value;
		}

		public function get motionObjAxm17():Object
		{
			return _motionObjAxm17;
		}

		public function set motionObjAxm17(value:Object):void
		{
			_motionObjAxm17 = value;
		}

		public function get motionObjAxm18():Object
		{
			return _motionObjAxm18;
		}

		public function set motionObjAxm18(value:Object):void
		{
			_motionObjAxm18 = value;
		}

		public function get motionObjAxm19():Object
		{
			return _motionObjAxm19;
		}

		public function set motionObjAxm19(value:Object):void
		{
			_motionObjAxm19 = value;
		}

	
		public function change():void{
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get motion():Object
		{
			return _motion;
		}

		public function set motion(value:Object):void
		{
			_motion = value;
			var $id:uint=0
			if(_motion){
				for(var i:uint=0;i<_motion.length&&$id<=9;i++)
				{
					if(_motion[i]){
						this["motionObjAxm"+$id]=_motion[i]
						$id++
					}
				}
				
			}
			while($id<=9){
				var $obj:Object=new Object
				$obj.frameSpeed=30
				$obj.motionID=$id
				this["motionObjAxm"+$id]=$obj
				$id++	
			}
		}

		public function get boneID():int
		{
			return _boneID;
		}

		public function set boneID(value:int):void
		{
			_boneID = value;
		}

		public function get boneMesh():XFileBoneStaticMesh
		{
			return _boneMesh;
		}
		[Editor(type="MaterialImg",Label="bone",donotDubleClik="1",extensinonStr="mode3d.XFileBoneStaticMesh",sort="1",changePath="0",Category="动作")]
		public function set boneMesh(value:XFileBoneStaticMesh):void
		{
			_boneMesh = value;
			
			change();
		}

		override public function getName():String
		{
			return name;
		}
	
		public function get shadow():Boolean
		{
			return _shadow;
		}

		public function set shadow(value:Boolean):void
		{
			_shadow = value;
		}

		public function get isEarthApplique():Boolean
		{
			return _isEarthApplique;
		}

		public function set isEarthApplique(value:Boolean):void
		{
			_isEarthApplique = value;
		}

		public function get needUnzip():Boolean
		{
			return _needUnzip;
		}

		public function set needUnzip(value:Boolean):void
		{
			_needUnzip = value;
		}

		public function get isColorAdd():Boolean
		{
			return _isColorAdd;
		}

		public function set isColorAdd(value:Boolean):void
		{
			_isColorAdd = value;
		}

		public function get waterReflection():Boolean
		{
			return _waterReflection;
		}

		public function set waterReflection(value:Boolean):void
		{
			_waterReflection = value;
		}

		public function get fogEffect():Boolean
		{
			return _fogEffect;
		}

		public function set fogEffect(value:Boolean):void
		{
			_fogEffect = value;
		}

		public function get alphaOut():Number
		{
			return _alphaOut;
		}

		public function set alphaOut(value:Number):void
		{
			_alphaOut = value;
		}

		public function get alphaIn():Number
		{
			return _alphaIn;
		}

		public function set alphaIn(value:Number):void
		{
			_alphaIn = value;
		}

		public function get alpha():Number
		{
			return _alpha;
		}

		public function set alpha(value:Number):void
		{
			_alpha = value;
		}

		public function get zTestType():Number
		{
			return _zTestType;
		}

		public function set zTestType(value:Number):void
		{
			_zTestType = value;
		}

		public function get lookCamera():Number
		{
			return _lookCamera;
		}

		public function set lookCamera(value:Number):void
		{
			_lookCamera = value;
		}





		public function get unitType():int
		{
			return _unitType;
		}

		public function set unitType(value:int):void
		{
			_unitType = value;
		}

		public function get renderLevel():int
		{
			return _renderLevel;
		}

		public function set renderLevel(value:int):void
		{
			_renderLevel = value;
		}

		public function get showLevel():int
		{
			return _showLevel;
		}

		public function set showLevel(value:int):void
		{
			_showLevel = value;
		}



		



	}
}