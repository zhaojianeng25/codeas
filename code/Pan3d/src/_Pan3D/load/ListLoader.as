package _Pan3D.load
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * @author liuyanfei  QQ: 421537900
	 */
	public class ListLoader extends EventDispatcher
	{
		private var _loaderThread:LoaderThread;
		private var _loadList:Vector.<LoadInfo>;
		private var _flag:int;
		
		public function ListLoader()
		{
			init();
		}
		private function init():void{
			_loaderThread = new LoaderThread;
			_loaderThread.addEventListener(Event.COMPLETE,onComplete);
		}
		public function load(loadList:Vector.<LoadInfo>):void{
			_flag = 0;
			this._loadList = loadList;
			_loaderThread.load(_loadList[_flag]);
		}
		private function onComplete(event:Event):void{
			_flag++;
			if(_flag == _loadList.length){
				this.dispatchEvent(new Event(Event.COMPLETE));
				return;
			}else{
				_loaderThread.load(_loadList[_flag]);
			}
				
		}
	}
}