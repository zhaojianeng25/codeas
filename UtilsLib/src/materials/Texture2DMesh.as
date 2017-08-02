package materials
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import interfaces.ITile;
	
	public class Texture2DMesh extends EventDispatcher implements ITile
	{
		private var _textureName:String;
        private var _name:String
		private var _textureBmpSprite:Object;
		private var _textureCompressTypeID:int;
		private var _info:String;
		private var _id:int;

		private var _centerPos:Object
		

		
		private var _inputBut:int;
		
		
		private static var _typeA:Boolean=false  //是否均匀分布转图
		private static var _addOnePixel:Boolean=true  //第帧之间是否增加一像素
		private static var _enlargePixelType:Boolean=false  //向外增加一像素
		private static var _simplifyTexture:Boolean=true  //去除无效像素
		
		
		private static var _frameSpeed:Number=20   //帧数
		private static var _step1_B:int=0      //播放类形


		private static var _step2_A:Boolean=false    //鼠标设至为中心点
		private static var _step2_B:Boolean=true    //设计注册点为左上角
		
		
		private static var _step3_A:int=80   //导出jpg品质
			
			
			

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get filePath():String
		{
			return "img/Texture2D/";
		}

		public function set filePath(value:String):void
		{
	
		}



		public function get textureName():String
		{
			return _textureName;
		}
		[Editor(type="PreFabImg",Label="贴图",extensinonStr="jpg|png|wdp",sort="0",changePath="0",Category="贴图")]
		public function set textureName(value:String):void
		{
			_textureName = value;
		}
		
		public function get bmpSprite():Object
		{
			return _textureBmpSprite;
		}
		[Editor(type="Texturue2DUI",Label="贴图",sort="1",Category="图集")]
		public function set bmpSprite(value:Object):void
		{
			_textureBmpSprite = value;
			
			
		}
		private function change():void
		{
			this.dispatchEvent(new Event(Event.CHANGE));
			
		}
		public var chooseFolder:Function

		public function Texture2DMesh(target:IEventDispatcher=null)
		{
			super(target);
		}
		

		
		
		public function get centerPos():Object
		{
			return _centerPos;
		}
		[Editor(type="Vec2",Label="中心点坐标",sort="4",Category="坐标",Tip="坐标")]
		public function set centerPos(value:Object):void
		{
			_centerPos = value;
		}

		
		
		public var setXyPanelFun:Function 
		public function get setXy():int
		{
			return _inputBut;
		}
		[Editor(type="Btn",Label="选择中心坐标",sort="5",Category="坐标",Tip="坐标")]
		public function set setXy(value:int):void
		{
			{
				if(Boolean(setXyPanelFun)){
					setXyPanelFun()
				}
			}
			
		}
		
		public function get step3_A():int
		{
			return _step3_A;
		}
		[Editor(type="Number",Label="导出Jpeg品质",Step="2",sort="40",MinNum="0",MaxNum="100",Category="第三步",Tip="范围")]
		public function set step3_A(value:int):void
		{
			_step3_A = value;
		}

		public function get step2_A():Boolean
		{
			return _step2_A;
		}
		[Editor(type="ComboBox",Label="鼠标设至为中心点",sort="30",Category="第二步",Data="{name:false,data:false}{name:true,data:true}",Tip="是否当地形用来扫描高度")]
		public function set step2_A(value:Boolean):void
		{
			_step2_A = value;
		}

		public function get step2_B():Boolean
		{
			return _step2_B;
		}
		[Editor(type="ComboBox",Label="设计注册点为左上角",sort="31",Category="第二步",Data="{name:false,data:false}{name:true,data:true}",Tip="是否当地形用来扫描高度")]
		public function set step2_B(value:Boolean):void
		{
			_step2_B = value;
		}
		
		

		public function get frameSpeed():Number
		{
			return _frameSpeed;
		}
		[Editor(type="Number",Label="设置每帧间隔",Step="1",sort="20",MinNum="1",MaxNum="60",Category="第一步",Tip="范围")]
		public function set frameSpeed(value:Number):void
		{
			_frameSpeed = value;
			change();
		}

		public function get step1_B():int
		{
			return _step1_B;
		}
		[Editor(type="ComboBox",Label="设置播放模式",sort="21",Category="第一步",Data="{name:循环播放,data:0}{name:播放到最后删除,data:1}{name:停在最后一帧,data:2}{name:自动播放后续动作,data:3}",Tip="2的幂")]
		public function set step1_B(value:int):void
		{
			_step1_B = value;
		}

		public function get typeA():Boolean
		{
			return _typeA;
		}
		[Editor(type="ComboBox",Label="是否均匀分布转图",sort="10",Category="构建参数",Data="{name:false,data:false}{name:true,data:true}",Tip="是否当地形用来扫描高度")]
		public function set typeA(value:Boolean):void
		{
			_typeA = value;
		}

		public function get addOnePixel():Boolean
		{
			return _addOnePixel;
		}
		[Editor(type="ComboBox",Label="之间是否增加一像素",sort="11",Category="构建参数",Data="{name:false,data:false}{name:true,data:true}",Tip="是否当地形用来扫描高度")]
		public function set addOnePixel(value:Boolean):void
		{
			_addOnePixel = value;
		}

		public function get enlargePixelType():Boolean
		{
			return _enlargePixelType;
		}
		[Editor(type="ComboBox",Label="向外增加一像素",sort="12",Category="构建参数",Data="{name:false,data:false}{name:true,data:true}",Tip="是否当地形用来扫描高度")]
		public function set enlargePixelType(value:Boolean):void
		{
			_enlargePixelType = value;
		}

		public function get simplifyTexture():Boolean
		{
			return _simplifyTexture;
		}
		[Editor(type="ComboBox",Label="去除无效像素",sort="13",Category="构建参数",Data="{name:false,data:false}{name:true,data:true}",Tip="是否当地形用来扫描高度")]
		public function set simplifyTexture(value:Boolean):void
		{
			_simplifyTexture = value;
		}

		
		public function get inputBut():int
		{
			return _inputBut;
		}
		[Editor(type="Btn",Label="选取文件夹",sort="50",Category="导入文件夹",Tip="范围")]
		public function set inputBut(value:int):void
		{
			if(Boolean(chooseFolder)){
				chooseFolder()
			}
			
		}

		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}


		public function get textureCompressTypeID():int
		{
			return _textureCompressTypeID;
		}

		public function set textureCompressTypeID(value:int):void
		{
			_textureCompressTypeID = value;
		}

		public function get info():String
		{
			return _info;
		}

		public function set info(value:String):void
		{
			_info = value;
		}

		public function getBitmapData():BitmapData
		{
			return null;
		}
		
		public function getName():String
		{
			return _name
		}
		
		public function acceptPath():String
		{
			return null;
		}
	}
}