package mvc.frame.line
{
	import common.utils.frame.BaseComponent;
	
	public class FrameLinePointSprite extends BaseComponent
	{
		private var _frameLinePointVo:FrameLinePointVo;

		public function FrameLinePointSprite()
		{
			super();

			
		}

		public function get frameLinePointVo():FrameLinePointVo
		{
			return _frameLinePointVo;
		}

		public function set frameLinePointVo(value:FrameLinePointVo):void
		{
			_frameLinePointVo = value;
			this.refrishDraw()
		}

		public function get iskeyFrame():Boolean
		{
			return frameLinePointVo.iskeyFrame
		}

		public function set iskeyFrame(value:Boolean):void
		{
			_frameLinePointVo.iskeyFrame = value;
			this.refrishDraw()
		}
		public function refrishDraw():void
		{
			this.graphics.clear();

			
			if(_frameLinePointVo.slectFlag){
				this.graphics.beginFill(0xff0000,1);
			}else{
				this.graphics.beginFill(0xffffff,1);
			}

			this.graphics.lineStyle(1,0x000000);
			this.graphics.drawRect(0,2,8,16);
			this.graphics.endFill();
			
			if(_frameLinePointVo.iskeyFrame){
				this.graphics.lineStyle(1,0x000000,0);
				this.graphics.beginFill(0x000000,0.7);
				this.graphics.drawCircle(5,10,2)
				this.graphics.endFill();
			}else{
				this.graphics.lineStyle(1,0x000000,1);
				this.graphics.beginFill(0x000000,0.0);
				this.graphics.drawCircle(5,10,2)
				this.graphics.endFill();
			}
		
		}

	
	}
}