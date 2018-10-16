package tempest.data
{
	import flash.utils.getTimer;

	import org.as3commons.logging.api.getLogger;

	import tempest.utils.Fun;



	/**
	 * fps相关的各种监测
	 * @author qihei
	 *
	 */
	public class FPSMgr
	{
		private const UPDATE_INTERVAL:Number=0.5;
		private var mFrameCount:int=0;
		private var mTotalTime:Number=0;

		//上5帧的耗时
		private var _prevFPS:Number=60;
		private var _prevFPS1:Number=60;
		private var _prevFPS2:Number=60;
		private var _prevFPS3:Number=60;
		private var _prevFPS4:Number=60;

		/**
		 * 帧率
		 */
		public var fps:Number=0;
		public var avgFps:Number;

		/**
		 * 是否高性能机器 ,临时开启给张勇用
		 */
		public var performanceHigh:Boolean=false;
		private var _performaceHighCount:uint=0;

		/**检测间隔*/
		public function get checkInterval():int
		{
			return _checkInterval;
		}

		/**
		 * @private
		 */
		public function set checkInterval(value:int):void
		{
			_checkInterval=value;
			this._nextSyncTime=value;
		}

		/**检测到作弊回调*/
		private var _onCheat:Function;

		public function FPSMgr(onCheat:Function, checkInterval:int=15000)
		{
			_onCheat=onCheat;
			this._nextSyncTime=this.checkInterval=checkInterval;
		}

		/**服务器当前时间戳*/
		private var _stime:uint;
		/**第一次收到的服务器时间*/
		private var _sCurrentTime:uint;
		/**第一次收到的服务器时间*/
		private var _cCurrentTime:uint;
		/**统计两分钟内心跳次数(因为对时一分钟一次)*/
		private var _countHeart:int;
		/**作弊被抓次数*/
		private var _cheatCount:int;
		/**开始检测作弊*/
		public var pauseCheat:Boolean=false;
		private var _checkInterval:int;
		private var _nextSyncTime:int;
		public var allow:int=1000;
		public var allowSpeed:Number=1.1;
		private var oldDTime:int;
		private var oldTTime:int;
		private var oldSTIme:int;

//		/**
//		 * 设置服务器当前时间戳(定期校时)
//		 *
//		 */
//		public function setServerTime(value:uint):void
//		{
//			if (_countHeart) //下一次对时的时候来统计结算
//			{
//				var diff:int=(value - _sCurrentTime); //这个是服务器的时间所以不会有问题  *_limitSpeed 是算上误差
//				if (_countHeart > (diff * 60) || ((getTimer() - _cCurrentTime) / 1000) > diff) //帧率和时间都大于服务器的
//				{
//					_cheatCount++; //检测到一次帧率异常基本判断有加速行为
//					if (_onCheat != null)
//					{
//						_onCheat(_cheatCount); //回调作弊次数给外部处理
//					}
//				}
//			}
//			//开始统计
//			_sCurrentTime=value;
//			_cCurrentTime=Time.getTimer();
//			_countHeart=0;
//		}

		/**
		 * 清除作弊次数
		 *
		 */
		public function clearCheatCount():void
		{
			_cheatCount=0;
		}

		/**
		 * 时间心跳
		 * @param diff
		 *
		 */
		public function update(diff:uint):void
		{
			_countHeart++;
			mTotalTime+=diff / 1000;
			mFrameCount++;

			if (mTotalTime > UPDATE_INTERVAL)
			{
				fps=mTotalTime > 0 ? mFrameCount / mTotalTime : 0;
				mFrameCount=mTotalTime=0;

				//记录帧率
				//刷新上5帧的耗时
				_prevFPS4=_prevFPS3;
				_prevFPS3=_prevFPS2;
				_prevFPS2=_prevFPS1;
				_prevFPS1=_prevFPS;
				//本帧心跳耗时
				_prevFPS=fps;

				//平均帧率
				avgFps=(_prevFPS + _prevFPS1 + _prevFPS2 + _prevFPS3 + _prevFPS4) / 5;

				//非高性能
				if (!performanceHigh)
				{
					//并且连续，平均帧率大于50
					if (avgFps > 50)
					{
						_performaceHighCount++;
					}
					else
					{
						_performaceHighCount=0;
					}
					//连续触发20次，则认为是高性能
					if (_performaceHighCount > 20)
					{
						performanceHigh=true;
						trace("[FPSMgr]************** 开启高性能 *****************");
					}
				}
			}
			if (!pauseCheat)
			{
				return;
			}
			if (!Fun.lastDateTime) //时间还没同步到
			{
				return;
			}
			if (_nextSyncTime > diff)
			{
				_nextSyncTime-=diff;
			}
			else
			{
				//date
				var cdtime:int=new Date().time;
				if (!oldDTime)
				{
					oldDTime=cdtime;
				}
				var diffDate:int=(cdtime - oldDTime);
				oldDTime=cdtime;
				//
				var ctime:int=getTimer();
				if (!oldTTime)
				{
					oldTTime=ctime;
				}
				var diffGetime:int=ctime - oldTTime;
				oldTTime=ctime;
				if (!diffGetime || diffGetime < checkInterval)
				{
					return;
				}
//				if (Math.abs(diffDate - checkInterval) < allow) //日期误差在合理范围
//				{
//					return;
//				}
				//
				var sdtime:int=Fun.getTime();
				if (!oldSTIme)
				{
					oldSTIme=sdtime;
				}
				var diffServer:int=(sdtime - oldSTIme) * allowSpeed;
				oldSTIme=sdtime;
				var cur:int=(checkInterval - allow); //1000毫秒是误差 只防止加速外挂，不防止减速外挂所以是-1000
				if (diffServer && diffServer < cur)
				{
					_cheatCount++
					if (_onCheat != null)
					{
						_onCheat(_cheatCount, diffServer, diffDate, diffGetime, cur); //回调作弊次数给外部处理
					}
				}
			}
		}
	}
}
