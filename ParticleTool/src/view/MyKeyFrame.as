package view
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * 
	 * @author liuyanfei QQ:421537900
	 * </p>
	 * 关键帧对象
	 */		
	public class MyKeyFrame extends Sprite
	{
		public var isBegin:Boolean;//是否是起始帧
		public var isEnd:Boolean;//是否是结束帧
		private var _frameNum:int;//当前帧数
		private var _keyWidth:int = 8;//每帧所占的宽度
		
		public var preKeyFrame:MyKeyFrame;//前一个关键帧
		public var nextKeyFrame:MyKeyFrame;//后一个关键帧
		
		//public var particleItem:ParticleItem;
		
		//public var data:MyKeyFrameData;
		private var _animData:Array;//运动信息数据
		public var baseValue:Array;
		private var shape:Shape;//运动信息的绘画容器
		public function MyKeyFrame()
		{
			super();
			shape = new Shape;
			this.addChild(shape);
			this.graphics.lineStyle(1,0x222222);
			this.graphics.beginFill(0x666666);
			this.graphics.drawRect(0,0,6,14);
			this.graphics.endFill();
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		}
		
		public function get frameNum():int
		{
			return _frameNum;
		}
		/**
		 * 设置帧数
		 * @param value 帧数
		 * 
		 */		
		public function set frameNum(value:int):void
		{
			_frameNum = value;
			
			this.x = value * _keyWidth;
			this.y = 3;

		}
		/**
		 * 鼠标按下的时候 可以拖动 
		 * @param event
		 * 
		 */		
		private function onMouseDown(event:MouseEvent):void{
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		private function onMove(event:MouseEvent):void{
			this.x = this.parent.mouseX;
			if(this.preKeyFrame){
				if(this.x < this.preKeyFrame.x + 10){
					this.x = this.preKeyFrame.x + 10;
				}
			}else{
				if(this.x <= 0){
					this.x = 0;
				}
			}
			
			if(this.nextKeyFrame){
				if(this.x >= this.nextKeyFrame.x - 10){
					this.x = this.nextKeyFrame.x - 10;
				}
			}
	

			
		}
		/**
		 * 移动完成，向外分发事件 
		 * @param event
		 * 
		 */		
		private function onMouseUp(event:MouseEvent):void{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			
			this.x = this.x - this.x%8;
			
			this._frameNum = this.x/8;
			
			this.dispatchEvent(new Event(Event.CHANGE))
				
		
		}
		/**
		 * 运动信息数据 
		 * @return 运动信息
		 * 
		 */		
		public function get animData():Array
		{
			return _animData;
		}
		/**
		 * 设置运动信息并重绘 
		 * @param value 运动信息
		 * 
		 */		
		public function set animData(value:Array):void
		{
			_animData = value;
			drawAnim();
			//this.dispatchEvent(new Event(Event.CHANGE))
		}
		
		/**
		 * 绘制运动信息
		 * 
		 */		
		public function drawAnim():void{
	

			shape.graphics.clear();
		
	
			//var maxlong:int = this.nextKeyFrame.x - this.x;
			for(var i:int;i<_animData.length;i++){//根据不同的类型绘制不同的颜色
				var color:uint;
				var ypos:int;
				switch(_animData[i].type){
					case 1:
						color = 0xff0000;
						break;
					case 2:
						color = 0xff8000;
						break;
					case 3:
						color = 0xffff00;
						break;
					case 4:
						color = 0x00ff00;
						break;
					case 5:
						color = 0x0000ff;
						break;
					case 6:
						color = 0x00ffff;
						break;
					case 7:
						color = 0xff00ff;
						break;
					case 8:
						color = 0x666666;
						break;
					case 9:
						color = 0x808000;
						break;
				}
				
				shape.graphics.lineStyle(2,color);
				var data:Object = _animData[i].data;
				var beginX:int = data[0].value/1000*60*8;
				var endX:int;
				if(data[1].value == -1){
					if(this.nextKeyFrame){
						endX = this.nextKeyFrame.x;
					}else{
						endX = beginX;
					}
				}else{
					endX = beginX + data[1].value/1000*60*8;
				}
				if(nextKeyFrame){
					if(endX > this.nextKeyFrame.x){
						endX = this.nextKeyFrame.x;
					}
				}
				shape.graphics.moveTo(beginX,_animData[i].type*2-3);
				shape.graphics.lineTo(endX-this.x,_animData[i].type*2-3);
				shape.graphics.endFill()
			}
		}
		/**
		 * 获取运动信息+对应帧数 
		 * @return 所有关键信息
		 * 
		 */		
		public function getAllInfo():Object{
			var obj:Object = new Object;
			obj.animdata = _animData; 
			obj.frameNum = _frameNum;
			obj.baseValue = baseValue;
			return obj;
		}
		
		

	}
}