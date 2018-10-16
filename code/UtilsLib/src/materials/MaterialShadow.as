package materials
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import interfaces.ITile;
	
	public class MaterialShadow extends EventDispatcher implements ITile
	{

		private var _texturePath:String;
		private var _textureNameStr:String;
		private var _textureName:String;
		private var _id:uint
		public function MaterialShadow(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		

		public function get textureName():String
		{
			return _textureName;
		}
		[Editor(type="PreFabImg",Label="阴影贴图",extensinonStr="jpg|png|wdp",sort="1",changePath="1",Category="阴影贴图")]
		public function set textureName(value:String):void
		{
			if(_textureName != value){
				_textureName = value;
				change()
			}
			
		}

		public function get id():uint
		{
			return _id;
		}

		public function set id(value:uint):void
		{
			_id = value;
		}

		public function getBitmapData():BitmapData
		{
			return null;
		}
		
		public function getName():String
		{
			return "阴影贴图";
		}
		
		public function acceptPath():String
		{
			return null;
		}
		
		public function get texturePath():String
		{
			return _texturePath;
		}
		[Editor(type="TextLabelEnabel",Label="路径",sort="0",Category="贴图路径")]
		public function set texturePath(value:String):void
		{
			if(_texturePath!=value){
				_texturePath = value;
			
			}
		
		}
		public function get textureNameStr():String
		{
			return _textureNameStr;
		}
		public function set textureNameStr(value:String):void
		{

				_textureNameStr = value;
			
		}

		private function change():void
		{
			this.dispatchEvent(new Event(Event.CHANGE));
			
		}
	}
}