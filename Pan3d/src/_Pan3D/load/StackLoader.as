package _Pan3D.load
{
	import flash.events.Event;

	/**
	 * @author liuyanfei  QQ: 421537900
	 */
	public class StackLoader
	{
		private var _maxNum:int = 4;
		private var _loaderAry:Vector.<LoaderThread>;
		private var _queueAry:Vector.<LoadInfo>;
		
		
		public function StackLoader()
		{
			init();
		}
		private function init():void{
			_loaderAry = new Vector.<LoaderThread>;
			for(var i:int=0;i<_maxNum;i++){
				var loader:LoaderThread = new LoaderThread;
				loader.addEventListener(Event.COMPLETE,onComplete);
				_loaderAry.push(loader);
			}
			_queueAry = new Vector.<LoadInfo>;
		}
		public function addLoad(loadInfo:LoadInfo):void{
			var loader:LoaderThread = getIdleLoader();
			
			if(loader){
				loader.load(loadInfo);
			}else{
				_queueAry.push(loadInfo);
			}
		}
		private function getIdleLoader():LoaderThread{
			for(var i:int;i<_maxNum;i++){
				if(_loaderAry[i].running == false){
					return _loaderAry[i];
				}
			}
			return null;
		}
		private function onComplete(event:Event):void{
			var loader:LoaderThread = event.target as LoaderThread;
			var loadInfo:LoadInfo = _queueAry.pop();
			if(loadInfo && !loadInfo.cancel){
				loader.load(loadInfo);
			}
		}
	}
}