package tempest.common.audio
{
	import flash.events.*;
	import flash.events.Event;
	import flash.media.*;
	import flash.net.*;
	import tempest.common.audio.vo.SoundData;
	import tempest.manager.AudioManager;

	/**
	 *声音线程
	 * @author zhangyong
	 *
	 */
	public class SoundThread
	{
		public static var modifyHandler:Function=null;
		public var type:int=1; //音效线程类型
		private var _soundList:Array; //线程播放列表
		private var _isClam:Boolean=false; //是否静音
		private var _pause:Boolean=false; //是否暂停
		private var _volume:Number=1; //音量

		public function SoundThread(type:int)
		{
			this.type=type;
			this._soundList=[];
		}

		/**
		 *获取播放列长度
		 * @return
		 *
		 */
		public function getSoundsNum():int
		{
			return (this._soundList.length);
		}

		/**
		 *该线程音量
		 * @return
		 *
		 */
		public function getVolume():Number
		{
			return (this._volume);
		}

		/**
		 *设置该线程音量
		 * @param value
		 *
		 */
		public function setVolume(value:Number):void
		{
			var _soundData:SoundData;
			if (value < 0)
			{
				value=0;
			}
			if (value > 1)
			{
				value=1;
			}
			if (this._volume != value) //设置音量是否与现在的音量相同
			{
				this._volume=value;
				for each (_soundData in this._soundList)
				{
					_soundData.setVolume(this._volume);
				}
			}
		}

		public function get isClam():Boolean
		{
			return (this._isClam);
		}

		public function set isClam(value:Boolean):void
		{
			var _soundData:SoundData;
			if (this._isClam != value)
			{
				this._isClam=value;
				for each (_soundData in this._soundList)
				{
					_soundData.isClam=this._isClam;
				}
			}
		}

		public function get isPause():Boolean
		{
			return (this._pause);
		}

		public function set isPause(value:Boolean):void
		{
			var _soundData:SoundData;
			if (this._pause != value)
			{
				this._pause=value;
				for each (_soundData in this._soundList)
				{
					_soundData.isPause=this._pause;
				}
			}
		}

		/**
		 *是否存在指定音效
		 * @param value
		 * @return
		 *
		 */
		public function hasSound(value:SoundData):Boolean
		{
			return (!((this._soundList.indexOf(value) == -1)));
		}

		/**
		 *删除指定音效
		 * @param value
		 *
		 */
		public function removeSound(value:SoundData):void
		{
			var _soundData:SoundData;
			for each (_soundData in this._soundList)
			{
				if (_soundData == value)
				{
					_soundData.stopAndDispose(null);
					this._soundList.splice(this._soundList.indexOf(_soundData), 1);
					break;
				}
			}
		}

		/**
		 *清空播放线程
		 *
		 */
		public function removeAllSounds():void
		{
			var _soundData:SoundData;
			for each (_soundData in this._soundList)
			{
				_soundData.stopAndDispose(null);
			}
			this._soundList=[];
		}

		/**
		 *播放音效
		 * @param url
		 * @param loop
		 * @param volume
		 * @return
		 *
		 */
		public function playSound(url:String, loop:int=0):SoundData
		{
			var _soundData:SoundData=null;
			var _sound:Sound=null;
			var nowSoundTransform:*=null;
			var channel:*=null;
			var $loops:int=((loop == 0) ? int.MAX_VALUE : loop);
			var cacheSound:Sound=null;
			var req:URLRequest=new URLRequest(url);
			if (modifyHandler)
			{
				modifyHandler(req);
			}
			cacheSound=(AudioManager.cacheList[req.url] as Sound);
			if (cacheSound)
			{
				_sound=cacheSound;
			}
			else
			{
				_sound=new Sound();
				_sound.addEventListener(Event.COMPLETE, this.soundLoadHandler);
				_sound.addEventListener(IOErrorEvent.IO_ERROR, this.soundLoadHandler);
				_sound.load(req);
			}
			if (_sound == null)
			{
				return (_soundData);
			}
			try
			{
				nowSoundTransform=new SoundTransform(this._volume);
				channel=_sound.play(0, $loops, nowSoundTransform);
				if (channel != null)
				{
					_soundData=new SoundData($loops, _sound, channel);
					_soundData.addEventListener(SoundData.SOUNDDATA_COMPLETE, onSoundDataComplete);
					this._soundList.push(_soundData);
					if (this._isClam) //如果该声道静音
					{
						_soundData.isClam=true;
					}
					if (this._pause) //如果该声道暂停
					{
						_soundData.isPause=true;
					}
				}
			}
			catch (e:Error)
			{
			}
			return _soundData;
		}

		/**
		 *加载完毕
		 * @param e
		 *
		 */
		private function soundLoadHandler(e:Event):void
		{
			var _soundData:SoundData;
			var sound:Sound=(e.currentTarget as Sound);
			switch (e.type)
			{
				case Event.COMPLETE: //加载成功缓存
					AudioManager.cacheList[sound.url]=sound;
					break;
				case IOErrorEvent.IO_ERROR: //加载错误删除
					for each (_soundData in this._soundList)
					{
						if (_soundData.sound == sound)
						{
							_soundData.stopAndDispose(null);
							this._soundList.splice(this._soundList.indexOf(_soundData), 1);
						}
					}
					break;
			}
		}

		/**
		 * 音效文件全部次数播放完毕
		 * @param e
		 *
		 */
		private function onSoundDataComplete(e:Event):void
		{
			var _soundData:SoundData;
			_soundData=e.currentTarget as SoundData;
			if (_soundData)
			{
				_soundData.removeEventListener(SoundData.SOUNDDATA_COMPLETE, this.onSoundDataComplete);
				this._soundList.splice(this._soundList.indexOf(e.currentTarget), 1);
			}
		}
	}
}
