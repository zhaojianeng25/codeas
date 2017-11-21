package _Pan3D.skill.vo
{
	import flash.media.Sound;
	import flash.net.URLRequest;
	
	import _me.Scene_data;

	public class SoundVo
	{
		public var time:int;
		public var url:String;
		private var _sound:Sound;
		public function SoundVo()
		{
		}
		
		public function setData(obj:Object):void{
			this.time = obj.time * Scene_data.frameTime;
			this.url = obj.url;
			this._sound = new Sound(new URLRequest(Scene_data.fileRoot + this.url));
		}
		public function play():void{
			this._sound.play();
		}
	}
}