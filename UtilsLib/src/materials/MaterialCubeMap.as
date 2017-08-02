package materials
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import interfaces.ITile;
	
	public class MaterialCubeMap extends EventDispatcher implements ITile
	{
		public var id:int;
		private var _textureName0:String;
		private var _textureName1:String;
		private var _textureName2:String;
		private var _textureName3:String;
		private var _textureName4:String;
		private var _textureName5:String;
		private var _cubeName:String
		private var _url:String
		
		private var _xMove:int;
		private var _firstLoad:int;
		
		private var _texturePath:String = "img/TextureCubeMap/";
		
		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			_url = value;
		}

		public function get cubeName():String
		{
			return _cubeName;
		}

		public function set cubeName(value:String):void
		{
			_cubeName = value;
		}

		public function acceptAttribue(key:String, value:*):int
		{
			if(key == "textureName"){
				return 0;
			}else{
				if(_texturePath){
					if(String(value).indexOf(_texturePath)){
						return 2;//添加的路径与默认贴图不一致
					}
				}else{
					return 1;//默认贴图必须先设置
				}
			}
			return 0;
		}
		public function readObject():Object
		{
			var $obj:Object=new Object;
			$obj.textureName0=_textureName0;
			$obj.textureName1=_textureName1;
			$obj.textureName2=_textureName2;
			$obj.textureName3=_textureName3;
			$obj.textureName4=_textureName4;
			$obj.textureName5=_textureName5;
			return $obj;
		}
		
		public function setObject($obj:Object):void{
			_textureName0 = $obj.textureName0;
			_textureName1 = $obj.textureName1;
			_textureName2 = $obj.textureName2;
			_textureName3 = $obj.textureName3;
			_textureName4 = $obj.textureName4;
			_textureName5 = $obj.textureName5;
		}
		
		public function MaterialCubeMap(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function getBitmapData():BitmapData
		{
			return null;
		}
		
		public function getName():String
		{
			if(cubeName){
				return cubeName
			}
			
			return "立方体贴图" + id;
		}

		public function get texturePath():String
		{
			return _texturePath;
		}
		[Editor(type="TextLabelEnabel",Label="路径",sort="0",Category="贴图路径")]
		public function set texturePath(value:String):void
		{
			_texturePath = value;
		}
		
		public function get textureName0():String
		{
			return _textureName0;
		}
		
		[Editor(type="PreFabImg",Label="右方贴图",extensinonStr="jpg|png|wdp",sort="1",Category="第0面")]	
		public function set textureName0(value:String):void
		{
			if(_textureName0!=value){
				_textureName0 = value;
				change();
			}
		
		}

		public function get textureName1():String
		{
			return _textureName1;
		}

		[Editor(type="PreFabImg",Label="左方贴图",extensinonStr="jpg|png|wdp",sort="2",Category="第1面")]
		public function set textureName1(value:String):void
		{
			if(_textureName1!=value){
				_textureName1 = value;
				change();
			}
		}

		public function get textureName2():String
		{
			return _textureName2;
		}

		[Editor(type="PreFabImg",Label="下方贴图",extensinonStr="jpg|png|wdp",sort="3",Category="第2面")]
		public function set textureName2(value:String):void
		{
			if(_textureName2!=value){
				_textureName2 = value;
				change();
			}
		}

		public function get textureName3():String
		{
			return _textureName3;
		}

		[Editor(type="PreFabImg",Label="上方贴图",extensinonStr="jpg|png|wdp",sort="4",Category="第3面")]
		public function set textureName3(value:String):void
		{
			if(_textureName3!=value){
				_textureName3 = value;
				change();
			}
		}

		public function get textureName4():String
		{
			return _textureName4;
		}

		[Editor(type="PreFabImg",Label="后方贴图",extensinonStr="jpg|png|wdp",sort="5",Category="第4面")]
		public function set textureName4(value:String):void
		{
			if(_textureName4!=value){
				_textureName4 = value;
				change();
			}
		}

		public function get textureName5():String
		{
			return _textureName5;
		}

		[Editor(type="PreFabImg",Label="前方贴图",extensinonStr="jpg|png|wdp",sort="6",Category="第5面")]
		public function set textureName5(value:String):void
		{
			if(_textureName5!=value){
				_textureName5 = value;
				change();
			}
		}

		public function get xMove():int
		{
			return _xMove;
		}
		[Editor(type="Number",Label="X轴流动",Step="1",sort="7",Category="显示",Tip="根据游戏内设置的等级显示对应的物件，等级越低越优先显示，有firstLoad属性的默认为0")]
		public function set xMove(value:int):void
		{
			_xMove = value;
			change();
		}
		
		private function change():void
		{
			this.dispatchEvent(new Event(Event.CHANGE));
			
		}
		
		public function get firstLoad():int
		{
			return _firstLoad;
		}
		[Editor(type="Number",Label="预读取",Step="1",sort="8",Category="显示",Tip="根据游戏内设置的等级显示对应的物件，等级越低越优先显示，有firstLoad属性的默认为0")]
		public function set firstLoad(value:int):void
		{
			_firstLoad = value;
		}


		
		public function acceptPath():String
		{
			// TODO Auto Generated method stub
			return _texturePath;
		}
		
		
		

	}
}