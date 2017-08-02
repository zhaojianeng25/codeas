package grass
{
	import flash.events.Event;
	
	import interfaces.ITile;
	
	import materials.Material;
	import materials.MaterialTree;
	
	import pack.ModePropertyMesh;
	
	public class GrassStaticMesh extends ModePropertyMesh implements ITile
	{
		private var _material:Material;
		private var _materialUrl:String;
		private var _modeUrl:String
		private var _grassArr:Array;
		

		private var _faceAtlook:Boolean
		private var _density:Number   //抖动速度
		private var _bishuaSize:Number  //笔刷大小
		private var _bishuaMidu:Number    //笔刷密度
		private var _bishuaScale:Number   //基础比例
		private var _bishuaScalRound:Number   //比例范围


		public function GrassStaticMesh()
		{
			super();
		}

	

	

		public function readObject():Object
		{
			var $obj:Object=new Object
			$obj.density=_density  
			$obj.bishuaSize=_bishuaSize
			$obj.bishuaMidu=_bishuaMidu
			$obj.bishuaScale=_bishuaScale
			$obj.bishuaScalRound=_bishuaScalRound
			$obj.grassArr=_grassArr
			$obj.materialUrl=_materialUrl
			$obj.modeUrl=_modeUrl
			$obj.faceAtlook=_faceAtlook
			return $obj
		}

		public function get faceAtlook():Boolean
		{
			return _faceAtlook;
		}
		[Editor(type="ComboBox",Label="面向视点",sort="11",Category="属性",Data="{name:false,data:false}{name:true,data:true}",Tip="")]
		public function set faceAtlook(value:Boolean):void
		{
			_faceAtlook = value;
			change();
		}
		public function get density():Number
		{
			return _density;
		}
		[Editor(type="Number",Label="抖动速度",Step="1",sort="12",MinNum="1",MaxNum="20",Category="属性",Tip="范围")]
		public function set density(value:Number):void
		{
			_density = value;
			change();
		}
		
		public function get bishuaScale():Number
		{
			return _bishuaScale;
		}
		[Editor(type="Number",Label="基础比例",Step="0.01",sort="13",MinNum="0.001",MaxNum="100",Category="属性",Tip="范围")]
		public function set bishuaScale(value:Number):void
		{
			_bishuaScale = value;
			change();
		}
		
		public function get bishuaScalRound():Number
		{
			return _bishuaScalRound;
		}
		[Editor(type="Number",Label="比例范围",Step="1",sort="14",MinNum="1",MaxNum="50",Category="属性",Tip="范围")]
		public function set bishuaScalRound(value:Number):void
		{
			_bishuaScalRound = value;
			change();
		}
		
		public function get bishuaSize():Number
		{
			return _bishuaSize;
		}
		[Editor(type="Number",Label="笔刷大小",Step="1",sort="15",MinNum="1",MaxNum="50",Category="属性",Tip="范围")]
		public function set bishuaSize(value:Number):void
		{
			_bishuaSize = value;
			change();
		}

		public function get bishuaMidu():Number
		{
			return _bishuaMidu;
		}
		[Editor(type="Number",Label="笔刷密度",Step="1",sort="16",MinNum="1",MaxNum="10",Category="属性",Tip="范围")]
		public function set bishuaMidu(value:Number):void
		{
			_bishuaMidu = value;
			change();
		}

		

		public function get grassArr():Array
		{
			return _grassArr;
		}

		public function set grassArr(value:Array):void
		{
			_grassArr = value;
		}
		public function get modeUrl():String
		{
			return _modeUrl;
		}
		[Editor(type="PreFabImg",Label="模型地址",extensinonStr="obj|axo|objs",sort="9",changePath="0",Category="模型")]
		public function set modeUrl(value:String):void
		{
			_modeUrl = value;
			change();
		}
		public function get material():Material
		{
			return _material;
		}
		[Editor(type="MaterialImg",Label="材质",donotDubleClik="1",extensinonStr="materials.Material",sort="10",changePath="0",Category="材质")]
		public function set material(value:Material):void
		{
			if(_material != value){
				if(_material){
					_material.removeEventListener(Event.CHANGE,onMaterialChange)
				}
				_material = value;
				_material.addEventListener(Event.CHANGE,onMaterialChange);
				if(_material is MaterialTree){
					_materialUrl = MaterialTree(_material).url;
				}
				change();
			}
		}
		protected function onMaterialChange(event:Event):void
		{
			change();
			
		}
		
		public function get materialUrl():String
		{
			return _materialUrl;
		}

		public function set materialUrl(value:String):void
		{
			_materialUrl = value;
		}

	}
}