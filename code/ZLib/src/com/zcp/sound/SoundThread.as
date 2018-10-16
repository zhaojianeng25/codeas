package com.zcp.sound
{
	import com.zcp.cache.Cache;
	import com.zcp.loader.loader.DobjLoader;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.*;
	import flash.net.URLRequest;
	
	/**
	 * 声音执行线程模型对象
	 * @author zcp
	 * 
	 */	
	public class SoundThread
	{
		/**声音缓存*/
		private static var soundCache:Cache = new Cache("SoundThread.soundCache",50);//类型为Sound
		/**设置声音缓存数量*/
		public static function setSoundCacheSize($size:int):void
		{
			soundCache.resize($size);
		}
		
		
		
		
		
		//声音集合
		private var _soundArr:Array = [];
		/** 此音效线程是否处于静音 */
		private var _mute:Boolean = false;
		/** 此音效线程是否处于暂停 */
		private var _pause:Boolean = false;
		
		//音量大小
		private var _volume:Number = 1;
		
		/**
		 * SoundThread
		 * 
		 */	
		public function SoundThread()
		{
		}
		
		/**
		 * 获取声音数量
		 * 
		 */			
		public function getSoundsNum():int
		{
			return _soundArr.length;
		}	
		/**
		 * 获取音量
		 */
		public function getVolume():Number
		{
			return _volume;
		}
		/**
		 * 设置音量
		 * @param $value
		 */
		public function setVolume($value:Number):void
		{
			if($value<0)$value=0;
			if($value>1)$value=1;
			if(_volume!=$value)
			{
				_volume =  $value;
				
				var sd:SoundData;
				for each(sd in _soundArr)
				{
					sd.setVolume(_volume);
				}
			}
		}
		/**
		 * 获取静音
		 */
		public function getMute():Boolean
		{
			return _mute;
		}
		/**
		 * 设置静音
		 * @param $value
		 */
		public function setMute($value:Boolean):void
		{
			if(_mute!=$value)
			{
				_mute = $value;
				
				var sd:SoundData;
				for each(sd in _soundArr)
				{
					sd.setMute(_mute);
				}
			}
		}
		/**
		 * 获取暂停
		 */
		public function getPause():Boolean
		{
			return _pause;
		}
		/**
		 * 设置暂停
		 * @param $value
		 */
		public function setPause($value:Boolean):void
		{
			if(_pause!=$value)
			{
				_pause = $value;
				
				var sd:SoundData;
				for each(sd in _soundArr)
				{
					sd.setPause(_pause);
				}
			}
		}
		
		
		/**
		 * 是否存在指定的声道
		 * @param $soundData
		 * 
		 */			
		public function hasSound($soundData:SoundData):Boolean
		{
			return _soundArr.indexOf($soundData)!=-1;
		}
		
		
		/**
		 * 停止某个声音,并从数组中移除
		 * @param $soundData
		 */
		public function removeSound($soundData:SoundData):void
		{
			var sd:SoundData;
			for each(sd in _soundArr)
			{
				if(sd == $soundData)
				{
					sd.removeEventListener(SoundData.LOOP_COMPLETE,soundLoopCompleteHandler);//移除事件
					sd.stopAndDispose();
					_soundArr.splice(_soundArr.indexOf(sd),1);
					break;
				}
			}
		}
		/**
		 * 停止所有短声音播放,并从数组中移除
		 */
		public function removeAllSounds():void
		{
			var sd:SoundData;
			for each(sd in _soundArr)
			{
				sd.removeEventListener(SoundData.LOOP_COMPLETE,soundLoopCompleteHandler);//移除事件
				sd.stopAndDispose();
			}
			_soundArr = [];
		}
		
		/**
		 * 添加并播放一个声音
		 * @param $sound 声音类名 或 网络地址(要用完整地址，否则缓存无效)
		 * @param $startTime 开始时间
		 * @param $loops  循环次数
		 * @param $selfVolume  自己的音量（如果$selfVolume不在0到1之间则取该SoundThread的默认音量）
		 * @param $loopDelay 循环播放的时候,每次结尾后在开始新的之前的手动延迟时间  单位毫秒
		 */		
		public function playSound($sound:String, $startTime:Number=0, $loops:int=0, $selfVolume:Number=-1, $loopDelay:int=0):SoundData
		{
			var sd:SoundData;
			//获取sound
			var sound:Sound;
			if(soundCache.has($sound))
			{
				sound = soundCache.get($sound) as Sound;
			}
			else
			{
				//优先在类中查找尝试
				sound = DobjLoader.getInstance($sound) as Sound;
				//不存在则新建
				if(sound==null)
				{
					sound = new Sound();
					sound.addEventListener(Event.COMPLETE, soundLoadHandler);
					sound.addEventListener(IOErrorEvent.IO_ERROR, soundLoadHandler);
					sound.load(new URLRequest($sound));
				}
				//添加进缓存
				soundCache.push(sound,$sound);
			}
			
			//判断为空
			if(sound==null)
			{
				return sd;
			}
			
			//开始播放
			try{
				//可调SoundTransform
				var selfVolume:Number = ($selfVolume>=0 && $selfVolume<=1)?$selfVolume:_volume;
				var nowSoundTransform:SoundTransform = new SoundTransform(selfVolume);
				var channel:SoundChannel = sound.play($startTime,0,nowSoundTransform);
				if(channel!=null)//没有声卡或所有声道（最多32个）都已用完，则返回null
				{
					sd = new SoundData(sound, channel, $loops-1, $loopDelay);
					sd.addEventListener(SoundData.LOOP_COMPLETE,soundLoopCompleteHandler);//注册事件
					_soundArr.push(sd);//添加进数组
					
					//静音
					if(_mute)
					{
						sd.setMute(true);
					}
					//暂停
					if(_pause)
					{
						sd.setPause(true);
					}
					
				}
			}catch(e:Error){}
			
			return sd;
		}
		/**
		 * @private
		 * 从网络上加载声音的事件
		 * */
		private function soundLoadHandler(e:*):void
		{
			var sound:Sound = e.currentTarget;
			switch(e.type)
			{
				case Event.COMPLETE:
					//添加进缓存
					soundCache.push(sound,sound.url);
					break;
				case IOErrorEvent.IO_ERROR:
					//从数组中删除
					var sd:SoundData;
					var len:int = _soundArr.length;
					while(len-->0)
					{
						sd = _soundArr[len];
						if(sd.sound == sound)
						{
							sd.removeEventListener(SoundData.LOOP_COMPLETE,soundLoopCompleteHandler);//移除事件
							sd.stopAndDispose();
							_soundArr.splice(len,1);
						}
					}
					break;
			}
		}
		/**
		 * @private
		 * 声音循环播放完毕
		 */
		private function soundLoopCompleteHandler(e:Event):void
		{
			var currentSd:SoundData = e.currentTarget as SoundData;
			var sd:SoundData;
			for each(sd in _soundArr)
			{
				if(sd == currentSd)
				{
					sd.removeEventListener(SoundData.LOOP_COMPLETE,soundLoopCompleteHandler);//移除事件
					sd.stopAndDispose();
					//从数组中彻底移除
					_soundArr.splice(_soundArr.indexOf(sd),1);
					break;
				}
			}
		}
	}
}