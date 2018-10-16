package com.zcp._special.mic
{
	import com.zcp.events.EventDispatchCenter;
	
	import flash.events.SampleDataEvent;
	import flash.events.StatusEvent;
	import flash.media.Microphone;
	import flash.media.MicrophoneEnhancedOptions;
	import flash.media.SoundCodec;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	import flash.utils.ByteArray;

	/**
	 * 录音机(单例)
	 * 请监听并处理RecordEvent事件
	 * 事件抛出的为数据副本，外部可放心修改
	 * 对于麦克风的设置暂时硬编码到此类内了
	 * @author ZCP
	 * 
	 */	
	public class Recorder extends EventDispatchCenter
	{
		//麦克风
		private var _mic:Microphone;
		//用户是否拒绝了使用麦克风
		private var _micMuted:Boolean=false;
		//录音数据
		private var _soundBytes:ByteArray = new ByteArray();
		
		//是否正在录音
		private var _isRecording:Boolean;
		
		//单例
		static private var _instance:Recorder;
		
		public function Recorder()
		{
			if(_instance!=null)
			{
				throw new Error("Recorder单例");
			}
			_instance = this;
		}
		
		//================================================================================
		//public API
		//================================================================================
		/**
		 * 获取是否正在录音
		 */		
		public function get isRecording():Boolean{
			return this._isRecording;
		}
		/**
		 * 开始或继续录音
		 * @param $clearOld 是否清除旧的（true:全新的录音，false:继续上次录音）
		 * 
		 */		
		public function startRecord($clearOld:Boolean=true):void {
			if(_isRecording)return;
			
			//获取麦克风
			//注意每次都要这样取一次， 因为在程序运行期间，上次已记录的麦克风可能被其他程序占用，所以每次需要重新获取。
			//Microphone.getEnhancedMicrophone() || Microphone.getMicrophone()多次调用依然会获取对同一麦克风的引用 
			_mic = getMic();
			
			//判断存在性
			if(_mic==null)return;
			
			
			//如果麦克风处于拒绝使用状态，则给出提示
			if(_micMuted)
			{
				dispatchRecordEvent(RecordEvent.RECORD_MSG,null,"麦克风已被用户禁用,请刷新以启用麦克风");
			}
			else//否则开始录音
			{
				if(_mic.muted)//第一次默认是拒绝状态
				{
					//通过这种方式使FLASH弹出是否允许启用麦克风窗口
					_mic.addEventListener(SampleDataEvent.SAMPLE_DATA, record);
					_mic.removeEventListener(SampleDataEvent.SAMPLE_DATA, record);
				}
				else//否则开始录音
				{
					//清空已记录数据
					if($clearOld)
					{
						clearRecord();
					}
					//注册麦克风监听,开始录音
					_mic.addEventListener(SampleDataEvent.SAMPLE_DATA, record);
					
					_isRecording = true;
					dispatchRecordEvent(RecordEvent.RECORD_START,null,"开始录音");
				}
			}
		}
		/**
		 * 停止录音(完成录音)
		 */		
		public function stopRecord():void {
//			if(!_isRecording)return;
			
			if(_mic==null)return;
			//if(_micMuted)return;
			
			//移除麦克风监听
			_mic.removeEventListener(SampleDataEvent.SAMPLE_DATA, record);
			
			_isRecording = false;
			dispatchRecordEvent(RecordEvent.RECORD_STOP,_soundBytes,"停止录音");
		}
		/**
		 * 暂停录音
		 */		
		public function pauseRecord():void {
//			if(!_isRecording)return;
			
			if(_mic==null)return;
			//if(_micMuted)return;
			
			//移除麦克风监听
			_mic.removeEventListener(SampleDataEvent.SAMPLE_DATA, record);
			
			_isRecording = false;
			dispatchRecordEvent(RecordEvent.RECORD_PAUSE,_soundBytes,"暂停录音");
		}
		/**
		 * 清空录音数据
		 */		
		public function clearRecord():void {
			//清空已记录数据
			_soundBytes.clear();
		}
		
		
		//================================================================================
		//private API
		//================================================================================
		//获取麦克风
		private function getMic():Microphone {
			//检查支持性
			if(!Microphone.isSupported)
			{
				dispatchRecordEvent(RecordEvent.RECORD_MSG,null,"当前平台不支持麦克风");
				return null;
			}
			
			//获取麦克风
			var m:Microphone = Microphone.getEnhancedMicrophone() || Microphone.getMicrophone();
			if(m!=null)
			{
				//设置麦克风
				//配置1
				//--------------------------------------------
				m.codec = SoundCodec.NELLYMOSER;
				m.setSilenceLevel(5, 10000);
				m.gain = 50;
				m.rate = 44;//此值影响RecordPlayer.time函数内的公式11111111111111
				var option:MicrophoneEnhancedOptions = new MicrophoneEnhancedOptions();
				option.autoGain = true;
				m.enhancedOptions = option;
				//--------------------------------------------
//				//配置2
//				//--------------------------------------------
//				//设置麦克风
//				m.codec = SoundCodec.SPEEX;
//				m.setSilenceLevel(0, 10000);
//				m.gain = 50;
//				var option:MicrophoneEnhancedOptions = new MicrophoneEnhancedOptions();
//				option.autoGain = true;
//				m.enhancedOptions = option;
//				//--------------------------------------------
				
				//使用音频编解码器的回音抑制功能
				m.setUseEchoSuppression(true);
				//监听麦克风是被启用还是被禁用
				m.addEventListener(StatusEvent.STATUS, statusHandler);
			}
			else//麦克风不可用
			{
				if(Microphone.names.length==0)
				{
					dispatchRecordEvent(RecordEvent.RECORD_MSG,null,"系统上没有安装任何麦克风");
				}
				else
				{
					dispatchRecordEvent(RecordEvent.RECORD_MSG,null,"麦克风正由其它应用程序使用,请选择一个可用的麦克风");
					Security.showSettings(SecurityPanel.MICROPHONE);//显示选择麦克风选项
				}
				return null;//这种状态下直接返回
			}
			//----------------------------------------------------------------
			
			return m;
		}
		//麦克风启用状态处理
		private function statusHandler(event:StatusEvent):void {
			//获取麦克风是被拒绝还是被允许使用
			_micMuted = _mic.muted;
			if(_micMuted)
			{
				dispatchRecordEvent(RecordEvent.RECORD_MSG,null,"麦克风已被用户禁用,请刷新以启用麦克风");
			}
			else
			{
				dispatchRecordEvent(RecordEvent.RECORD_MSG,null,"麦克风已启用,请重新开始录音");
			}
		}
		//录音函数
		private function record(e:SampleDataEvent):void {
			while(e.data.bytesAvailable)
			{
				_soundBytes.writeFloat(e.data.readFloat());
			}
		}
		//派发事件
		private function dispatchRecordEvent($type:String, $data:ByteArray=null,$msg:String=null):void {
			
			//创建数据副本
			//-------------------------
			if($data!=null)
			{
				var bytes:ByteArray = new ByteArray();
				bytes.writeBytes($data);
				$data = bytes;
			}
			//-------------------------
			
			var event:RecordEvent = new RecordEvent($type);
			event.recordData = $data;
			event.msg = $msg;
			this.dispatchEvent(event);
		}
	}
}