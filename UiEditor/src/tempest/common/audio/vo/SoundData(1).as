package tempest.common.audio.vo
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;

	/**
	 * ...声音实体
	 * @author  enger
	 */
	public class SoundData extends EventDispatcher
	{
		private var _volume:Number=1; //音量
		private var _sound:Sound; //声音流
		private var _loops:uint; //播放次数
		private var _isReady:Boolean=false; //声音加载状态
		private var _isBroken:Boolean=true; //是否损坏(IO错误)
		private var _isClam:Boolean=false; //是否静音
		private var _isPause:Boolean=false; //是否暂停
		private var _position:uint=0;
		private var _soundChannel:SoundChannel; //声道
		public static const SOUNDDATA_COMPLETE:String="soundData_complete";

		public function SoundData(loop:uint, sound:Sound, soundChannel:SoundChannel)
		{
			this._loops=loop; //次数
			this._sound=sound;
			this._soundChannel=soundChannel;
			this._volume=this._soundChannel.soundTransform.volume;
			this._soundChannel.addEventListener(Event.SOUND_COMPLETE, this.stopAndDispose);
		}

		/**
		 *获取音量
		 * @return
		 *
		 */
		public function getVolume():Number
		{
			return (this._volume);
		}

		/**
		 *设置音量
		 * @param value
		 *
		 */
		public function setVolume(value:Number):void
		{
			this._volume=value;
			this._soundChannel.soundTransform = new SoundTransform(this._volume);
		}

		/**
		 *是否静音
		 * @return
		 *
		 */
		public function get isClam():Boolean
		{
			return (this._isClam);
		}

		/**
		 *设置静音
		 * @param value
		 *
		 */
		public function set isClam(value:Boolean):void
		{
			this._isClam = value;
			if (this._isClam)
			{
				this._soundChannel.soundTransform = new SoundTransform(0);
			}
			else
			{
				this.setVolume(this.getVolume());
			}
		}

		/**
		 *是否暂停
		 * @return
		 *
		 */
		public function get isPause():Boolean
		{
			return (this._isPause);
		}

		/**
		 *暂停/重新播放
		 * @param value
		 *
		 */
		public function set isPause(value:Boolean):void
		{
			this._isPause=value;
			if (this._isPause)
			{
				_position=this._soundChannel.position;
				this._soundChannel.stop();
			}
			else
			{
				this._loops--;
				this._soundChannel=this._sound.play(_position, this._loops, this._soundChannel.soundTransform);
				this._soundChannel.addEventListener(Event.SOUND_COMPLETE, this.stopAndDispose);
			}
		}

		/**
		 *播放完毕回收对象
		 *
		 */
		public function stopAndDispose(e:Event):void
		{
			this.dispatchEvent(new Event(SOUNDDATA_COMPLETE));
			this._soundChannel.removeEventListener(Event.SOUND_COMPLETE, this.stopAndDispose);
			this._soundChannel.stop();
			this._loops=0;
		}

		public function get sound():Sound
		{
			return _sound;
		}

		public function set sound(value:Sound):void
		{
			_sound=value;
		}

		public function get isReady():Boolean
		{
			return _isReady;
		}

		public function set isReady(value:Boolean):void
		{
			_isReady=value;
		}

		public function get isBroken():Boolean
		{
			return _isBroken;
		}

		public function set isBroken(value:Boolean):void
		{
			_isBroken=value;
		}
	}
}


