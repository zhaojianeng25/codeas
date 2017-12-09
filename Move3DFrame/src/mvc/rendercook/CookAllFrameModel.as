package mvc.rendercook
{
	import flash.utils.setTimeout;
	
	import mx.controls.Alert;
	
	import _me.FpsView;
	import _me.Scene_data;
	
	import mvc.frame.FrameModel;
	import mvc.frame.lightbmp.LightBmpModel;

	public class CookAllFrameModel
	{
		private static var instance:CookAllFrameModel;

		public function CookAllFrameModel()
		{
		}
		public static function getInstance():CookAllFrameModel{
			if(!instance){
				instance = new CookAllFrameModel();
			}
			return instance;
		}
		public var needCookItem:Array;
		public var cookSkipNum:int

		public function start():void
		{
			this.cookSkipNum=-1;
			this.needCookItem=LightBmpModel.getInstance().getAllNeedCookFrameItem();
			this.needCookItem=new Array;
			var $maxTime:uint= FrameModel.getInstance().getTotalTime()
			for(var i:Number=0;i<$maxTime;i++){
				this.needCookItem.push(i)
			}
			trace(this.needCookItem);
			this.oneByone();

		}
	    public function cookSampleFrame(value:Number):void
		{
			RayTraceModel.getInstance().openRadiosity();
			CookNetManager.getInstance().cookEndFun=closeSampleFrame
			FrameModel.getInstance().framePanel.playFrameTo(value,true);
			setTimeout(function ():void{
				RayTraceModel.getInstance().renderCtrl();
			},2000)
		}
		public function closeSampleFrame():void
		{
			RayTraceModel.getInstance().exitAll();
			Alert.show("当前帧渲染结束");
		}
	
		private function oneByone():void
		{
			this.cookSkipNum++
			if(this.needCookItem.length>this.cookSkipNum){
				var $playFrameNum:int=	this.needCookItem[this.cookSkipNum];
				FrameModel.getInstance().framePanel.playFrameTo($playFrameNum,true);
				RayTraceModel.getInstance().openRadiosity();
				CookNetManager.getInstance().cookEndFun=close
				setTimeout(function ():void{
					RayTraceModel.getInstance().renderCtrl();
				},2000)
			}else{
				
				LightBmpModel.getInstance().resetLightNodel()
				Alert.show("所有的都线束了结束");
				
				
			}
		}
		public function close():void
		{
		
			trace("烘培"+this.cookSkipNum+"结束")
			RayTraceModel.getInstance().exitAll();
			setTimeout(function ():void{
				oneByone()
			},2000)
		}
		
		
	}
}