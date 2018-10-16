package tempest.manager
{
	import com.adobe.utils.DictionaryUtil;

	import flash.utils.Dictionary;

	import tempest.common.audio.SoundThread;
	import tempest.common.audio.vo.SoundData;

	public class AudioManager
	{
		public static var cacheList:Dictionary=new Dictionary(true);
		private static var _soundThreadList:Dictionary=new Dictionary(true);

		public function AudioManager()
		{
			throw new Error("静态类");
		}

		/**
		 * 获取声道数量
		 * @return
		 *
		 */
		public static function getSoundThreadsNum():int
		{
			return _soundThreadList ? DictionaryUtil.getLength(_soundThreadList) : 0;
		}

		/**
		 * 获取所有音效数量
		 * @return
		 *
		 */
		public static function getSoundsNum():int
		{
			var _soundThread:SoundThread;
			var _count:Number=0;
			for each (_soundThread in _soundThreadList)
			{
				_count=(_count + _soundThread.getSoundsNum());
			}
			return _count;
		}

		/**
		 *根据音效类型创建音效线程
		 * @param type  音效类型
		 * @return
		 *
		 */
		public static function creatNewSoundThread(type:int):SoundThread
		{
			var _soundThread:SoundThread;
			if (hasSoundThread(type))
			{
				_soundThread=_soundThreadList[type];
			}
			else
			{
				_soundThread=new SoundThread(type);
				_soundThreadList[type]=_soundThread;
			}
			return _soundThread;
		}

		/**
		 *播放音效
		 * @param url  音效地址
		 * @param volume  默认音效量
		 * @param loop   播放次数
		 * @param type   音效类型
		 * @param soundThread  播放指定线程
		 * @return
		 *
		 */
		public static function playSound(url:String, type:int, volume:Number=1, loop:Number=-1, isSingle:Boolean=true, soundThread:SoundThread=null):SoundThread
		{
			var _soundThead:SoundThread;
			if (soundThread != null)
			{
				_soundThead=soundThread;
				if (!hasSoundThread(_soundThead.type))
				{
					_soundThreadList[_soundThead.type]=_soundThead;
				}
			}
			else
			{
				_soundThead=getSoundThread(type);
			}
			if (_soundThead)
			{
				if (isSingle) //现成是否单声道
				{
					_soundThead.removeAllSounds();
				}
				_soundThead.setVolume(volume);
				_soundThead.playSound(url, loop);
			}
			return _soundThead;
		}

		/**
		 *获取指定类型音效线程
		 * @param type
		 * @return
		 *
		 */
		public static function getSoundThread(type:int):SoundThread
		{
			var _soundThread:SoundThread;
			_soundThread=_soundThreadList[type] as SoundThread;
			if (_soundThread)
			{
				return _soundThread;
			}
			return creatNewSoundThread(type);
		}

		/**
		 * 获取所有声道
		 * @return
		 *
		 */
		public static function getSoundThreads():Dictionary
		{
			return _soundThreadList;
		}

		/**
		 *设置音量
		 * @param value
		 *
		 */
		public static function setVolume(value:Number):void
		{
			var _soundThead:SoundThread;
			for each (_soundThead in _soundThreadList)
			{
				_soundThead.setVolume(value);
			}
		}

		/**
		 *静声/有声
		 * @param value
		 *
		 */
		public static function setClam(value:Boolean):void
		{
			var _soundThead:SoundThread;
			for each (_soundThead in _soundThreadList)
			{
				_soundThead.isClam=value;
			}
		}

		/**
		 *暂停开始
		 * @param value
		 *
		 */
		public static function setPause(value:Boolean):void
		{
			var _soundThead:SoundThread;
			for each (_soundThead in _soundThreadList)
			{
				_soundThead.isPause=value;
			}
		}

		/**
		 *移除所有线程
		 *
		 */
		public static function removeAllSoundThreads():void
		{
			removeAllSounds();
			_soundThreadList=new Dictionary();
		}

		public static function removeAllSounds():void
		{
			var _soundThread:SoundThread;
			for each (_soundThread in _soundThreadList)
			{
				_soundThread.removeAllSounds();
			}
		}

		/**
		 *移除指定线程中所有音效
		 * @param soundTreead
		 *
		 */
		public static function removeSoundThread(soundTreead:SoundThread):void
		{
			var _soundThread:SoundThread;
			if (!_soundThread)
			{
				return;
			}
			for each (_soundThread in _soundThreadList)
			{
				if (_soundThread == soundTreead)
				{
					_soundThread.removeAllSounds();
					delete _soundThreadList[_soundThread.type];
					break;
				}
			}
		}

		/**
		 *移除所有线程中指定音效
		 * @param soundData
		 *
		 */
		public static function removeSound(soundData:SoundData):void
		{
			var _soundData:SoundThread;
			if (soundData == null)
			{
				return;
			}
			for each (_soundData in _soundThreadList)
			{
				_soundData.removeSound(soundData);
			}
		}

		/**
		 *是否包含指定线程
		 * @param soundThred
		 * @return
		 *
		 */
		public static function hasSoundThread(type:int):Boolean
		{
			return (!(_soundThreadList[type] == null));
		}

		/**
		 *所有线程中是否包含指定音效
		 * @param _arg1
		 * @return
		 *
		 */
		public static function hasSound(soundData:SoundData):Boolean
		{
			var _soundData:SoundThread;
			for each (_soundData in _soundThreadList)
			{
				if (_soundData.hasSound(soundData))
				{
					return true;
				}
			}
			return false;
		}
	}
}


