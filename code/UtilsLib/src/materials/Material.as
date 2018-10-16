package materials
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import interfaces.ITile;
	
	
	public class Material extends EventDispatcher implements ITile
	{
		public var id:int = -1;
		private var _textureName:String = "-1";
		private var _texturePath:String = "-1";
		private var _textureMaskName:String = "-1";
		private var _textureNormalsName:String = "-1";
		private var _textureLightName:String = "-1";
		private var _playType:String = "-1";
		private var _textureReflectID:int = -1;
		private var _materialRefalect:MaterialReflect;
		private var _textureCubeMapID:int = -1;
		private var _materialCubeMap:MaterialCubeMap;
		private var _textureComplexTimes:int = 1;
		private var _textureOverallNormalsName:String = "-1";
		private var _materialID:int = -1;
		private var _xMove:Number = 0;
		private var _cullingType:int = 0;
		private var _isCompress:Boolean = true;
		private var _firstLoad:Boolean = false;
		private var _name:String
		
		public static var TEX:String = "tex";
		public static var VEC3:String = "vec3";
		public static var VEC2:String = "vec2";
		public static var FLOAT:String = "float";

		
		public function Material()
		{
			
		}
		

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		private function change(e:Event=null):void{
			this.dispatchEvent(new Event(Event.CHANGE));
		}

		public function get textureName():String
		{
			return _textureName;
		}
		
		[Editor(type="PreFabImg",Label="贴图",extensinonStr="jpg|png|wdp",sort="1",changePath="1",Category="漫反射")]
		public function set textureName(value:String):void
		{
			if(_textureName != value){
				_textureName = value;
				change();
			}
		}
		public function get texturePath():String
		{
			return _texturePath;
		}
		[Editor(type="TextLabelEnabel",Label="路径",sort="0",Category="贴图路径")]
		public function set texturePath(value:String):void
		{
			if(_texturePath != value){
				_texturePath = value;
				change();
			}
		}
		
		public function acceptPath():String
		{
			// TODO Auto Generated method stub
			return _texturePath;
		}
		
		
		public function get textureMaskName():String
		{
			return _textureMaskName;
		}
		[Editor(type="PreFabImg",Label="贴图",extensinonStr="jpg|png|wdp",sort="2",changePath="0",Category="遮罩贴图")]
		public function set textureMaskName(value:String):void
		{
			if(_textureMaskName != value){
				_textureMaskName = value;
				change();
			}
		}

		public function get textureNormalsName():String
		{
			return _textureNormalsName;
		}
		[Editor(type="PreFabImg",Label="贴图",extensinonStr="jpg|png|wdp",sort="3",changePath="0",Category="法线贴图")]
		public function set textureNormalsName(value:String):void
		{
			if(_textureNormalsName != value){
				_textureNormalsName = value;
				change();
			}
		}

		public function get textureLightName():String
		{
			return _textureLightName;
		}
		[Editor(type="PreFabImg",Label="贴图",extensinonStr="jpg|png|wdp",sort="3",changePath="0",Category="高光贴图")]
		public function set textureLightName(value:String):void
		{
			if(_textureLightName != value){
				_textureLightName = value;
				change();
			}
		}
		
		public function get textureReflectID():int
		{
			return _textureReflectID;
		}

		public function set textureReflectID(value:int):void
		{
			if(_textureReflectID != value){
				_textureReflectID = value;
				change();
			}
			
		}
		
		public function get materialRefalect():MaterialReflect
		{
			return _materialRefalect;
		}
		
		[Editor(type="MaterialImg",Label="贴图",extensinonStr="materials.MaterialReflect",sort="4",path="0",Category="反光贴图")]
		public function set materialRefalect(value:MaterialReflect):void
		{
			if(_materialRefalect != value){
				_materialRefalect = value;
				change();
				if(_materialRefalect)
					_materialRefalect.addEventListener(Event.CHANGE,change);
			}
		}
		
		
		public function get materialCubeMap():MaterialCubeMap
		{
			return _materialCubeMap;
		}
		[Editor(type="MaterialImg",Label="贴图",extensinonStr="materials.MaterialCubeMap",sort="4",Category="立方体贴图")]
		public function set materialCubeMap(value:MaterialCubeMap):void
		{
			if(_materialCubeMap != value){
				_materialCubeMap = value;
				change();
				if(_materialCubeMap)
					_materialCubeMap.addEventListener(Event.CHANGE,change);
			}
		}
		public function get textureOverallNormalsName():String
		{
			return _textureOverallNormalsName;
		}
		[Editor(type="PreFabImg",Label="贴图",extensinonStr="jpg|png|wdp",sort="4.2",Category="全局法线贴图")]
		public function set textureOverallNormalsName(value:String):void
		{
			if(_textureOverallNormalsName != value){
				_textureOverallNormalsName = value;
				change();
			}
			
		}
		

		public function get textureCubeMapID():int
		{
			return _textureCubeMapID;
		}

		public function set textureCubeMapID(value:int):void
		{
			if(_textureCubeMapID != value){
				_textureCubeMapID = value;
				change();
			}
			
		}



		public function get materialID():int
		{
			return _materialID;
		}

		public function set materialID(value:int):void
		{
			if(_materialID != value){
				_materialID = value;
				change();
			}
			
		}
		
		public function get textureComplexTimes():int
		{
			return _textureComplexTimes;
		}
		
		
		[Editor(type="Number",Label="贴图整合次数",Step="1",sort="20",Category="显示",Tip="贴图整合次数")]
		public function set textureComplexTimes(value:int):void
		{
			if(_textureComplexTimes != value){
				_textureComplexTimes = value;
				change();
			}
		}
		
		public function get xMove():Number
		{
			return _xMove;
		}
		[Editor(type="Number",Label="X轴流动",Step="0.1",sort="21",Category="显示",Tip="X轴流动")]
		public function set xMove(value:Number):void
		{
			if(_xMove != value){
				_xMove = value;
				change();	
			}
		}

		public function get playType():String
		{
			return _playType;
		}
		//[Editor(type="ComboBox",Label="连续帧信息",Data="{name:-1,data:-1}{name:0,data:0}{name:1,data:1}{name:2,data:2}",sort="22",Category="显示",Tip="没有连续帧的填-1，playTyp = 0循环播放，1播放到最后一帧删除，2停在最后一帧")]
		public function set playType(value:String):void
		{
			if(_playType != value){
				_playType = value;
				change();
			}
			
		}



		public function get cullingType():int
		{
			return _cullingType;
		}
		[Editor(type="ComboBox",Label="渲染模式",Data="{name:0,data:0}{name:1,data:1}{name:2,data:2}",sort="23",Category="显示",Tip="0背面裁切，1前面裁切，2不裁切双目渲染")]
		public function set cullingType(value:int):void
		{
			if(_cullingType != value){
				_cullingType = value;
				change();
			}
		}

		public function get isCompress():Boolean
		{
			return _isCompress
		}
		[Editor(type="ComboBox",Label="是否压缩",sort="24",Category="显示",Data="{name:false,data:false}{name:true,data:true}",Tip="是否压缩")]
		public function set isCompress(value:Boolean):void
		{
			_isCompress = value
			change();
		}
		
		public function getName():String
		{
			return _name;
		}
		
		
		public function get firstLoad():Boolean
		{
			return _firstLoad;
		}

		public function set firstLoad(value:Boolean):void
		{
			_firstLoad = value;
		}


		public function getBitmapData():BitmapData
		{
			return null;
		}


		

		
	}
}