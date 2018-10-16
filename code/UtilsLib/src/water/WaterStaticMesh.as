package water
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Point;
	
	import interfaces.ITile;
	
	import materials.Material;
	import materials.MaterialTree;
	
	import pack.ModePropertyMesh;
	
	public class WaterStaticMesh extends ModePropertyMesh implements ITile
	{
		private var _textureSize:Number;
		private var _sizePoint:Point
		private var _depht:Number
		private var _color:int
		private var _dephtBmp:BitmapData
		private var _rootUrl:String
		private var _material:Material;
		private var _materialUrl:String;
		private var _captureId:uint;
		private var _reFlectionId:uint;
		private var _modeUrl:String;
		
	

		public function WaterStaticMesh()
		{
			super();
		}


		public function get materialUrl():String
		{
			return _materialUrl;
		}

		public function set materialUrl(value:String):void
		{
			_materialUrl = value;
		}

		public function get rootUrl():String
		{
			return _rootUrl;
		}

		public function set rootUrl(value:String):void
		{
			_rootUrl = value;
		}

		public function get dephtBmp():BitmapData
		{
			return _dephtBmp;
		}

		public function set dephtBmp(value:BitmapData):void
		{
			_dephtBmp = value;
		}

		public function get modeUrl():String
		{
			return _modeUrl;
		}
		[Editor(type="PreFabImg",Label="模型地址",extensinonStr="objs",sort="9",changePath="0",Category="模型")]
		public function set modeUrl(value:String):void
		{
			_modeUrl = value;
			change();
		}
		
		public function get color():int
		{
			return _color;
		}
		[Editor(type="ColorPick",Label="颜色",sort="10",Category="属性",Tip="范围")]
		public function set color(value:int):void
		{
			_color = value;
		}
		public function get material():Material
		{
			return _material;
		}
		[Editor(type="MaterialImg",Label="材质",donotDubleClik="1",extensinonStr="materials.Material",sort="9.1",changePath="0",Category="材质")]
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
		public function get depht():Number
		{
			return _depht;
		}
		[Editor(type="Number",Label="深度",Step="1",sort="11",MinNum="1",MaxNum="1000",Category="属性",Tip="范围")]
		public function set depht(value:Number):void
		{
			_depht = value;
			change();
		}

		public function get textureSize():Number
		{
			return _textureSize;
		}
		[Editor(type="Number",Label="信息尺寸",Step="1",sort="13",MinNum="1",MaxNum="512",Category="属性",Tip="范围")]
		public function set textureSize(value:Number):void
		{
			_textureSize = value;
			change()
		}
		public function get captureId():uint
		{
			return _captureId;
		}
		[Editor(type="CaptureIdUi",Label="captureId",extensinonStr="capture.CaptureStaticMesh",Step="1",sort="14",Category="属性",Tip="范围")]
		public function set captureId(value:uint):void
		{
			_captureId = value;
			change();
		}
		public function get reFlectionId():uint
		{
			return _reFlectionId;
		}
		[Editor(type="CaptureIdUi",Label="reFlectionId",extensinonStr="light.ReflectionStaticMesh",Step="1",sort="15",Category="属性",Tip="范围")]
		public function set reFlectionId(value:uint):void
		{
			_reFlectionId = value;
			change();
		}

		public function readObject():Object
		{
			var $obj:Object=new Object
			$obj.color=_color
			$obj.depht=_depht
			$obj.textureSize=_textureSize
			$obj.captureId=_captureId
			$obj.reFlectionId=_reFlectionId

			$obj.modeUrl=_modeUrl
			$obj.materialUrl=materialUrl
			return $obj
		}
		
		
	}
}