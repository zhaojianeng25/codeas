package materials
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import interfaces.ITile;
	
	public class MaterialReflect extends EventDispatcher implements ITile
	{
		
		public var id:int;
		private var _textureName:String;
		private var _texturePath:String = "img/TextureSpecial/";
		
		
		public function MaterialReflect(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function getBitmapData():BitmapData
		{
			return null;
		}
		
		public function getName():String
		{
			return "特殊贴图";
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
		
		public function get texturePath():String
		{
			return _texturePath;
		}
		[Editor(type="TextLabelEnabel",Label="路径",sort="0",Category="贴图路径")]
		public function set texturePath(value:String):void
		{
			_texturePath = value;
		}
		
		public function get textureName():String
		{
			return _textureName;
		}
		
		[Editor(type="PreFabImg",Label="反射贴图",extensinonStr="jpg|png|wdp",sort="1",changePath="1",Category="贴图纹理")]
		public function set textureName(value:String):void
		{
			if(_textureName!=value){
				_textureName = value;
				change();
			}
		}
		
		private function change():void
		{
			this.dispatchEvent(new Event(Event.CHANGE));
			
		}
		
	
		
		public function acceptPath():String
		{
			return _texturePath;
		}
		
		
		
	}
}