package com.zcp._special.mic
{
	import com.zcp.events.EventDispatchCenter;
	
	import flash.events.Event;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.ByteArray;

	/**
	 * 播放器（播放录音）(单例)
	 * 请监听并处理RecordPlayEvent事件
	 * 注意此类不会创建ByteArray的副本，而是操作原始数据
	 * @author ZCP
	 * 
	 */	
	public class RecordPlayer extends EventDispatchCenter
	{
		private var _sound:Sound;
		private var _channel:SoundChannel;
		//声音数据
		private var _soundBytes:ByteArray;
		//上次播放到的位置
		private var _position:uint;
		//是否正在播放
		private var _isPlaying:Boolean;
		
		
		//每次采样样本数 取值范围[2048, 8192]
		private var _yangben:int;
		
		//单例
		static private var _instance:RecordPlayer;
		
		/**
		 * @param $yanben 每次采样样本数 取值范围[2048, 8192]
		 * 
		 */		
		public function RecordPlayer($yanben:int=4096)
		{
			if(_instance!=null)
			{
				throw new Error("Recorder单例");
			}
			_instance = this;
			
			
			_yangben = $yanben;
			if(_yangben<2048)_yangben=2048;
			else if(_yangben>8192)_yangben=8192;
			_sound = new Sound();
		}
		
		//================================================================================
		//public API
		//================================================================================
		/**
		 * 获取是否正在播放
		 */		
		public function get isPlaying():Boolean{
			return this._isPlaying;
		}
		/**
		 * 获取当前播放到的位置
		 */		
		public function get position():uint{
			if(_soundBytes!=null)
			{
				_position = _soundBytes.position;
			}
			return this._position;
		}
		/**
		 * 获取当前播放总长度
		 */		
		public function get length():uint{
			if(_soundBytes!=null)
			{
				return _soundBytes.length;
			}
			return 0;
		}
		/**
		 * 设置播放数据
		 * 注意此类不会创建ByteArray的副本，而是操作原始数据
		 */	
		public function setSoundBytes($bytes:ByteArray):void {
			//停止旧的播放
			stopPlay();
			
			_soundBytes = $bytes;
			_soundBytes.position = 0;
			_position = 0;
		}
		/**
		 * 开始或继续播放
		 * @param $position 若指定位置，则从指定位置开始播放
		 * 
		 */		
		public function startPlay($position:int=-1):void {
			if(_isPlaying)return;
			
			//检测可播放长度
			if(_soundBytes==null)return;
			if($position>=0)
			{
				if($position>_soundBytes.length)$position = _soundBytes.length;
				_position = $position;//播放位置
			}
			_soundBytes.position = _position;//用上次的位置
			if(_soundBytes.bytesAvailable==0)return;
			
			//开始播放
			_sound.addEventListener(SampleDataEvent.SAMPLE_DATA, writeData);
			_channel = _sound.play();
			if(_channel!=null)
			{
				//播放开始
				_channel.addEventListener(Event.SOUND_COMPLETE, playComplete);
				_isPlaying = true;
				dispatchRecordPlayEvent(RecordPlayEvent.PLAY_START);
			}
			else
			{
				//32个声道已经用完,暂停播放11111111111
				pausePlay();
			}
		}
		
		/**
		 * 停止播放(播放头会还原到开头)
		 */		
		public function stopPlay():void {
//			if(!_isPlaying)return;
			
			if(_soundBytes==null)return;
			//停掉播放
			_sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, writeData);
			if(_channel!=null)
			{
				_channel.removeEventListener(Event.SOUND_COMPLETE, playComplete);
				_channel.stop();
			}
			
			//还原位置
			_position = 0;
			
			//播放停止
			_isPlaying = false;
			dispatchRecordPlayEvent(RecordPlayEvent.PLAY_STOP);
		}
		/**
		 * 暂停播放(会记录下当前播放头位置)
		 */	
		public function pausePlay():void {
//			if(!_isPlaying)return;
			if(_soundBytes==null)return;
			//停掉播放
			_sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, writeData);
			if(_channel!=null)
			{
				_channel.removeEventListener(Event.SOUND_COMPLETE, playComplete);
				_channel.stop();
			}
			
			//记录位置
			_position = _soundBytes.position;
			
			//播放暂停
			_isPlaying = false;
			dispatchRecordPlayEvent(RecordPlayEvent.PLAY_PAUSE);
		}
		/**
		 * 清空播放数据
		 */		
		public function clearPlay():void {
			//清空已记录数据
			_soundBytes.clear();
		}
		/**
		 * 获取声音时长(秒)
		 */	
		public function get time():Number {
			if(_soundBytes==null)return 0;
			return Math.round((_soundBytes.length / 44100) / 4);//注意，此公式需要与录音时的频率相匹配11111111111111
		}
		//================================================================================
		//private API
		//================================================================================
		//Sound类接收_soundBytes存储的声音数据
		private function writeData(e:SampleDataEvent):void {
			var sample:Number;
			var i:int;//样本数取值范围[2048, 8192]
			while (i < _yangben &&  _soundBytes.bytesAvailable > 0) {
				sample = _soundBytes.readFloat();
				e.data.writeFloat(sample);//左声道
				e.data.writeFloat(sample);//右声道
				i++;
			};
		}
		//声音播放结束
		private function playComplete(e:Event):void {
			//停掉播放
			_sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, writeData);
			if(_channel!=null)
			{
				_channel.removeEventListener(Event.SOUND_COMPLETE, playComplete);
				_channel.stop();
			}
			
			//还原位置
			_position = 0;
			
			//播放结束
			_isPlaying = false;
			dispatchRecordPlayEvent(RecordPlayEvent.PLAY_COMPLETE);
		}
		//派发事件
		private function dispatchRecordPlayEvent($type:String):void {
			var event:RecordPlayEvent = new RecordPlayEvent($type);
			this.dispatchEvent(event);
		}
	}
}