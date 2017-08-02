package com.zcp.sound
{
	import com.zcp.timer.TimerData;
	import com.zcp.timer.TimerHelper;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.setInterval;
	
	/**
	 * 声音声道数据
	 * @author zcp
	 * 
	 */	
	public class SoundData extends EventDispatcher
	{
		/**循环播放完毕*/
		public static const LOOP_COMPLETE:String = "SoundData.LOOP_COMPLETE";
		
		/**声音*/
		public var sound:Sound;
		private var _channel:SoundChannel;
		/**剩余的循环次数*/
		private var _leftLoops:int;
		/**循环播放的时候,每次结尾后在开始新的之前的手动延迟时间  单位毫秒*/
		private var _loopDelay:int;
		private var _td:TimerData;
		
		//是否静音
		private var _mute:Boolean = false;
		//是否暂停
		private var _pause:Boolean = false;
		//音量大小
		private var _volume:Number = 1;
		/**
		 * SoundData
		 * @param $sound
		 * @param $channel
		 * @param $leftLoops 剩余的循环次数
		 * @param $loopDelay 循环播放的时候,每次结尾后在开始新的之前的手动延迟时间  单位毫秒
		 */
		public function SoundData($sound:Sound, $channel:SoundChannel, $leftLoops:int=0, $loopDelay:int=0)
		{
			sound = $sound;
			_channel = $channel;
			_leftLoops = $leftLoops;
			_loopDelay = $loopDelay;
			//音量初始值
			_volume = _channel.soundTransform.volume;
			//注册事件
			_channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
		}
		/**声道*/
		public function get channel():SoundChannel
		{
			return _channel;
		}
		/**
		 * 获取音量(此处专供SoundThread.setVolume调用)
		 */
		public function getVolume():Number
		{
			return _volume;
		}
		/**
		 * 设置音量(此处专供SoundThread.setVolume调用)
		 * @param $value
		 */
		public function setVolume($value:Number):void
		{
			_volume =  $value;
			//注意不能用channel.soundTransform.volume = _volume 也不能用channel.soundTransform.volume = _volume; channel.soundTransform = new SoundTransform(_volume);	
			_channel.soundTransform = new SoundTransform(_volume);	
		}
		/**
		 * 获取是否是静音
		 * @param $value
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
			_mute = $value;
			if(_mute)//静音
			{
				//注意: 不能直接用   setVolume(0);	//因为在还原的时候  需要使用 _volume属性,  如果此处调用 setVolume(0)  会把 _volume清除为0
				_channel.soundTransform = new SoundTransform(0);	
			}
			else//还原
			{
				setVolume(getVolume());
			}
		}
		/**
		 * 获取是否是静音
		 * @param $value
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
			_pause = $value;
			if(_pause)
			{
				var position:Number = _channel.position;//注意这句话不能省略，只有channel.stop之前执行channel.position其值才会更新到正确的位置
				_channel.stop();
				
				//如果td存在 则需要把td删除  
				if(_td)
				{
					_td.destroy();
					_td = null;
				}
				//派发循环播放完毕事件
				this.dispatchEvent(new Event(LOOP_COMPLETE));
			}
			else
			{
				_channel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
				_channel = sound.play(_channel.position,0,_channel.soundTransform);
				_channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);	
			}
		}
		
		/**
		 * @private
		 * 一次声音播放完毕
		 */
		private function soundCompleteHandler(e:Event):void
		{
			if(_channel)
			{
				_channel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			}
			
			if(_leftLoops>0)
			{
				//如果存在延迟时间, 则需要等待
				if(_loopDelay>0)
				{
					//如果td存在 则需要把td删除  
					if(_td)
					{
						_td.destroy();
						_td = null;
					}
					_td = TimerHelper.createExactTimer(_loopDelay,0, _loopDelay,null, playAgain);
				}
				else
				{
					playAgain();
				}
				
				function playAgain():void
				{
					//继续循环播放
					if(_channel && sound)
					{
						_leftLoops--;
						
						//这里要调用stop 释放声道		不然 在歌曲循环播放次数超过一定次数后 就会导致flash创建声道失败.
						_channel.stop();
						
						//此处代码 决定了 每次playagain 都会创建新的channel对象,  一旦创建失败, flash会返回null
						_channel = sound.play(0,0,_channel.soundTransform);
						//注意  要判断空指针, 因为这个chanel有可能是null  因为flash声道最多只支持32个.
						if(_channel != null)
						{
							_channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
						}
					}
				}
			}
			else
			{
				//派发循环播放完毕事件
				this.dispatchEvent(new Event(LOOP_COMPLETE));
			}
		}
		/**
		 * @private
		 * 释放掉
		 */
		public function stopAndDispose():void
		{
			if(_channel)
			{
				_channel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
				_channel.stop();
			}
			
			_leftLoops = 0;
			
			//如果td存在 则需要把td删除  
			if(_td)
			{
				_td.destroy();
				_td = null;
			}
		}

	}
}