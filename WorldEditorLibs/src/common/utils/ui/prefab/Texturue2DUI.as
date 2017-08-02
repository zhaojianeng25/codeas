package common.utils.ui.prefab
{
	import flash.display.BitmapData;
	import flash.events.Event;
	
	import common.utils.frame.BaseComponent;
	
	import modules.brower.fileWin.BrowerManage;
	
	public class Texturue2DUI extends BaseComponent
	{
		private var _iconBmp:PicBut;
		private var _arrBmp:Vector.<BitmapData>
		public function Texturue2DUI()
		{
			super();
			
			this.baseWidth = 45;
			_iconBmp=new PicBut
			this.addChild(_iconBmp)
			
			_iconBmp.setBitmapdata(BrowerManage.getIcon("meinv"),80,80)
				
			this.height=80
			this.isDefault=false
				
			addEvents();
		}
		
		private function addEvents():void
		{
			this.addEventListener(Event.ENTER_FRAME,onEnterFrame)
			
		}
		private var _timeNum:int=0
		protected function onEnterFrame(event:Event):void
		{
			if(_timeNum++>_frameNum){
				_timeNum=0
				showNextBmp()
			}
		}
		private var picId:int=0
		private function showNextBmp():void
		{
			if(_arrBmp&&_arrBmp.length){
		
				if(picId<_arrBmp.length){
				}else{
					picId=0
				}
				setBigBmp(_arrBmp[picId])
				picId++
				
			}else{
				
			}
		}
		private function setBigBmp($bmp:BitmapData):void
		{
			_iconBmp.setBitmapdata($bmp,80,80)
		}
		private var _frameNum:uint=60
		override public function refreshViewValue():void
		{
			if(target&&FunKey){
				if(target[FunKey]){
				//	setBigBmp(target[FunKey].bigBmp)
					_arrBmp=target[FunKey].arrBmp
					_frameNum=target[FunKey].frameNum
				}
				
				//_texture2DMesh.bmpSprite={bigBmp:bigTextureBitmapData,arrBmp:bitmapDataVec}
			}
			
		}
	}
}