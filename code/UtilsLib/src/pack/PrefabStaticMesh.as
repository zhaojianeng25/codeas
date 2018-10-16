package pack
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import materials.Material;
	import materials.MaterialShadow;
	import materials.MaterialTree;

	public class PrefabStaticMesh extends Prefab
	{
		private var _material:Material;
		private var _materialInfoArr:Array
		private var _materialShadow:MaterialShadow;
		private var _materialUrl:String;
		
		private var _axoFileName:String;
		private var _axoFilePath:String;
		private var _modelFile:String;
		
		
		private var _showLevel:int		= 1;
		private var _renderLevel:int	= 1;
		private var _unitType:int		= 0;
		private var _shadowTextureID:int		= -1;
		private var _textureID:int		= -1;

		private var _textureContinueTimes:int	= 1;
		private var _shadow:Boolean		= false;
		private var _waterReflection:Boolean		= false;
		private var _lookCamera:int		= 0;
		private var _zTestType:int		= 0;
		private var _isColorAdd:Boolean		= false;
		private var _alpha:Number		= 1;
		private var _alphaIn:Number		= 0;
		private var _alphaOut:Number		= 0;
		private var _isEarthApplique:Boolean		= false;
		private var _needUnzip:Boolean		= false;
	
		
		
		private var _id:uint
		private var _url:String;
		
//		public var lightBlur:Number
//		public var isGroundHight:Number
//		public var lightProbe:Boolean
//		public var isNotCook:Boolean
//		public var captureId:Number
//		public var lightMapSize:Number
		
		public function PrefabStaticMesh()
		{
			
			
		}



		public function get materialInfoArr():Array
		{
			return _materialInfoArr;
		}

		public function set materialInfoArr(value:Array):void
		{
			_materialInfoArr = value;
			
			this.change()

		}

		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			_url = value;
		}

		public function get id():uint
		{
			return _id;
		}

		public function set id(value:uint):void
		{
			_id = value;
		}

		public function get textureID():int
		{
			return _textureID;
		}

		public function set textureID(value:int):void
		{
			_textureID = value;
		}

		public function readObject():Object
		{
			var $obj:Object=new Object
			$obj.modelFile=modelFile
			$obj.materialUrl=materialUrl
			$obj.showLevel=showLevel
			$obj.renderLevel=renderLevel
			$obj.unitType=unitType
			$obj.shadowTextureID=shadowTextureID
			$obj.textureContinueTimes=textureContinueTimes
			$obj.shadow=shadow
			$obj.waterReflection=waterReflection
			$obj.lookCamera=lookCamera
			$obj.zTestType=zTestType
			$obj.isColorAdd=isColorAdd
			$obj.alpha=alpha
			$obj.alphaIn=alphaIn
			$obj.alphaOut=alphaOut
			$obj.isEarthApplique=isEarthApplique
			$obj.needUnzip=needUnzip
			$obj.axoFileName=axoFileName
			$obj.csvID=csvID
			$obj.url=url
			$obj.materialInfoArr=materialInfoArr
			return $obj
		}
		public function get axoFilePath():String
		{
			return _axoFilePath;
		}
		[Editor(type="TextLabelEnabel",showType="0",Label="路径",sort="0",Category="模型路径")]
		public function set axoFilePath(value:String):void
		{
			_axoFilePath = value;

		}
		
		public function get modelFile():String
		{
			return _modelFile;
		}
	
		public function set modelFile(value:String):void
		{
			_modelFile = value;
			change();
		}

		
		public function get axoFileName():String
		{
			return _axoFileName;
		}
		[Editor(type="PreFabImg",Label="模型地址",extensinonStr="axo|objs",sort="0.9",changePath="1",Category="模型")]
		public function set axoFileName(value:String):void
		{
			_axoFileName = value;
			change();
		}
		override public function getName():String
		{
			if(name){
				return name

			}else{
				return "objs"

			}
		
		}
		
		public function get material():Material
		{
			return _material;
		}
		[Editor(type="MaterialImg",Label="材质",donotDubleClik="1",extensinonStr="materials.Material",sort="1",changePath="0",Category="材质")]
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
			
			trace("change")
			
			
		}
		
		public function get materialShadow():MaterialShadow
		{
			return _materialShadow;
		}
		[Editor(type="MaterialImg",Label="阴影材质",donotDubleClik="1",extensinonStr="materials.MaterialShadow",sort="1.1",changePath="0",Category="阴影材质",showType="0")]
		public function set materialShadow(value:MaterialShadow):void
		{
			_materialShadow = value;
			change();
		}
	

	
		public function get renderView():PrefabStaticMesh
		{
			return this;
		}
		[Editor(type="PrefabRenderWindow",Label="图",sort="1.3",changePath="1",Category="效果窗口",showType="1")]
		public function set renderView(value:PrefabStaticMesh):void
		{
		
			
		}

		public function get materialUrl():String
		{
			return _materialUrl;
		}
	//	[Editor(type="PreFabImg",Label="贴图地址",extensinonStr="jpg|png",sort="1",Category="贴图")]
		public function set materialUrl(value:String):void
		{
			_materialUrl = value;
			change();
		}
		


		public function get showLevel():int
		{
			return _showLevel;
		}
		[Editor(type="Number",Label="显示等级",Step="1",sort="2",Category="显示",Tip="根据游戏内设置的等级显示对应的物件，等级越低越优先显示，有firstLoad属性的默认为0")]
		public function set showLevel(value:int):void
		{
			_showLevel = value;
			change();
		}

		public function get renderLevel():int
		{
			return _renderLevel;
		}
		[Editor(type="Number",Label="渲染等级",Step="1",sort="3",Category="显示",Tip="根据游戏内设置的等级显示对应的物件，等级越低越优先显示，有firstLoad属性的默认为0")]
		public function set renderLevel(value:int):void
		{
			_renderLevel = value;
			change();
		}
		
		public function get unitType():int
		{
			return _unitType;
		}
		
		[Editor(type="ComboBox",Label="类型",sort="4",Category="显示",Data="{name:0,data:0}{name:1,data:1}{name:2,data:2}{name:3,data:3}{name:4,data:4}{name:5,data:5}{name:6,data:6}{name:7,data:7}{name:8,data:8}{name:9,data:9}{name:10,data:10}{name:11,data:11}{name:12,data:12}{name:13,data:13}{name:14,data:14}{name:14,data:14}{name:15,data:15}{name:16,data:16}{name:17,data:17}{name:18,data:18}",Tip="类型0默认属性，类型1{walkX}地图行走地面属性，类型2{walkY}地图行走阻挡属性，类型3{water}水体属性，类型4{waterUp}水体上方地图单元，类型5{LightOff}{NoFog}不受雾影响且无顶点光照无法线贴图，类型6{LightOff}无顶点光照无法线贴图，类型7{WdpMark}wdp格式遮罩 ，类型8{AtkHotArea}攻击热区，类型9{BeAtkHotArea}被击热区，类型10{addAirEffect}添加空气特效与{onlyAirEffect}仅空气特效，类型11{particle}+{alphaIn???}or{alphaOut???}粒子效果，顶点含透明信息粒子效果(模型顶点数据中会在顶点坐标之后储存alpha数据)，注意如果粒子不含顶点透明信息，他的UnitType = 0，类型12无命名，Csv手填，无顶点光照无法线贴图且不计算Ry旋转，一般用于loading替代图片，与看镜头配合使用  类型13  {wdpMarkMip}wdp格式遮罩注：例如树叶，与7相比(mipnearest，画质较低，渲染较快，不支持shadowMap和模型)，编号14  注：地图行走触发事件，ID[000]表示事件ID，存入Map3DUnit.as下的walkEvenID变量，Timer[0000000]表示如果站在上面多少毫秒触发一次，存入Map3DUnit.as下的walkEvenTimer变量，填0则站在上面只触发一次，不管填多少，如果移开后再次站上去一定会重新触发，")]
		public function set unitType(value:int):void
		{
			_unitType = value;
			change();
		}

		public function get shadowTextureID():int
		{
			return _shadowTextureID;
		}
		public function set shadowTextureID(value:int):void
		{
			if(_shadowTextureID == value){
				_shadowTextureID = value;
				change();
			}
			
		}

		public function get textureContinueTimes():int
		{
			return _textureContinueTimes;
		}
		//[Editor(type="Number",showType="0",Label="贴图连续次数",Step="1",sort="6",Category="显示")]
		public function set textureContinueTimes(value:int):void
		{
			_textureContinueTimes = value;
			change();
		}

		public function get shadow():Boolean
		{
			return _shadow;
		}
		[Editor(type="ComboBox",showType="0",Label="即时阴影",Data="{name:-1,data:false}{name:0,data:true}",sort="7",Category="显示",Tip="填写-1表示不用阴影贴图的Shader渲染，填写0就用阴影贴图的shader渲染，但该贴图默认全白(如果是地图物件，该数据无效，而是由.map文件直接获取该数据)")]
		public function set shadow(value:Boolean):void
		{
			_shadow = value;
			change();
		}

		public function get waterReflection():Boolean
		{
			return _waterReflection;
		}
		
		[Editor(type="ComboBox",showType="0",Label="水倒影",Data="{name:0,data:false}{name:1,data:true}",sort="8",Category="显示",Tip="只在A3D的即时阴影设置开启的前提下，本栏才有作用，填1表示开启，填0表示关闭")]
		public function set waterReflection(value:Boolean):void
		{
			_waterReflection = value;
			change();
		}

		public function get lookCamera():int
		{
			return _lookCamera;
		}

		[Editor(type="ComboBox",showType="0",Label="看镜头",Data="{name:0,data:0}{name:1,data:1}{name:2,data:2}{name:3,data:3}",sort="9",Category="显示",Tip="看镜头类型")]
		public function set lookCamera(value:int):void
		{
			_lookCamera = value;
			change();
		}

		public function get zTestType():int
		{
			return _zTestType;
		}

		[Editor(type="ComboBox",showType="0",Label="深度测试类型",Data="{name:0,data:0}{name:1,data:1}{name:2,data:2}",sort="10",Category="显示",Tip="[0]开启深度测试，被遮挡的不显示，[1]关闭深度测试，渲染只与渲染优先级有关，[2]法术类型专用深度测试，在自己范围关闭深渡测试，与其他东西有深度测试（交叉叠加时略有不真实），且渲染性能差（渲染2次），详见A3DZTestType.as")]
		public function set zTestType(value:int):void
		{
			_zTestType = value;
			change();
		}

		public function get isColorAdd():Boolean
		{
			return _isColorAdd;
		}

		[Editor(type="ComboBox",showType="0",Label="高亮叠加",Data="{name:0,data:false}{name:1,data:true}",sort="11",Category="显示")]
		public function set isColorAdd(value:Boolean):void
		{
			_isColorAdd = value;
			change();
		}

		public function get alpha():Number
		{
			return _alpha;
		}

		[Editor(type="Number",showType="0",Label="透明度",Step="0.01",MinNum="0",MaxNum="1",sort="12",Category="显示")]
		public function set alpha(value:Number):void
		{
			_alpha = value;
			change();
		}

		public function get alphaIn():Number
		{
			return _alphaIn;
		}

		[Editor(type="Number",showType="0",Label="透明渐入",Step="1",MinNum="0",MaxNum="100",sort="13",Category="显示",Tip="透明渐入的时间毫秒数")]
		public function set alphaIn(value:Number):void
		{
			_alphaIn = value;
			change();
		}

		public function get alphaOut():Number
		{
			return _alphaOut;
		}

		[Editor(type="Number",showType="0",Label="透明渐出",Step="1",MinNum="0",MaxNum="100",sort="14",Category="显示",Tip="透明渐出的时间毫秒数")]
		public function set alphaOut(value:Number):void
		{
			_alphaOut = value;
			change();
		}

		
		public function get isEarthApplique():Boolean
		{
			return _isEarthApplique;
		}

		[Editor(type="ComboBox",showType="0",Label="保留数据",Data="{name:0,data:false}{name:1,data:true}",sort="15",Category="显示",Tip="是否保留数组形式的数据,填1保留填0不保留")]
		public function set isEarthApplique(value:Boolean):void
		{
			_isEarthApplique = value;
			change();
		}

		public function get needUnzip():Boolean
		{
			return _needUnzip;
		}
		[Editor(type="ComboBox",showType="0",Label="地表贴花",Data="{name:0,data:false}{name:1,data:true}",sort="16",Category="显示")]
		public function set needUnzip(value:Boolean):void
		{
			_needUnzip = value;
			change();
		}
		public function change():void{
			this.dispatchEvent(new Event(Event.CHANGE));
		}

	}
}