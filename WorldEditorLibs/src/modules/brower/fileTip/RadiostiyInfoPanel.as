package modules.brower.fileTip
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.core.UIComponent;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	
	import common.utils.frame.BasePanel;
	import common.utils.ui.tab.TabButton;
	
	import modules.hierarchy.RenderModel;

	public class RadiostiyInfoPanel extends BasePanel
	{
		private var _btnVec:Vector.<TabButton>;
		private var _panelVec:Vector.<BasePanel>;
		private var _bg:UIComponent;
		//private var _shape:UIComponent;
		

		private var _filters:Array = [];
		private var _canScroll:Boolean = true;

		private var _textField:TextField;


		public function RadiostiyInfoPanel()
		{
			super();
			//this.setStyle("backgroundColor",0x404040);
			this.setStyle("borderColor",0x000000);
			this.setStyle("borderStyle","solid");
			this.setStyle("borderVisible",true);
			this.horizontalScrollPolicy = "off";

			addBack()
			addLabels();
			addButs();
			addListLabel()
			
			addEvents();
			
		}
		
		private function addButs():void
		{
			 _btnEnd = new RadiostiyInfoEndBut;
			_btnEnd.label = "停止渲染"
			_btnEnd.height = 30;
			_btnEnd.width = 130;
			_btnEnd.x=0
			_btnEnd.y=0
			this.addChild(_btnEnd)
			_btnEnd.refreshViewValue();

			
		}
		public function setRenderFinish():void
		{
			_btnEnd.label = "渲染结束"
		}
			
		
		private function addBack():void
		{
			_bg = new UIComponent;
			this.addChild(_bg);
//			_shape = new UIComponent;
//			this.addChild(_shape);
			
		}
		private function addLabels():void
		{

			
				
				
             _sampleLoad=new RadiostiyLoadBar("渲染进度:")
             this.addChild(_sampleLoad)
			 _sampleLoad.width=200
			 _sampleLoad.height=50
			 _sampleLoad.y=30
			 _sampleLoad.x=30

			
			 _tatolLoad=new RadiostiyLoadBar("统计进度:")
			 this.addChild(_tatolLoad)
			 _tatolLoad.width=200
			 _tatolLoad.height=50
			 _tatolLoad.y=90
			 _tatolLoad.x=30

			
			
		}
		
		private function addListLabel():void
		{
			
			_textField = new TextField();
			_textField.width = 300;
			_textField.height =200;
			_textField.y = 150;
			_textField.x=30
			_textField.multiline = true;
			_textField.wordWrap = true;
			_textField.backgroundColor=0x202020
			_textField.border=true
			_textField.borderColor=0x6c6c6c


			_textField.background=true
			_textField.defaultTextFormat = new TextFormat("微软雅黑,宋体,Arial", 12);
			_bg.addChild(_textField)
			
		
			
		}
		private var _msgs:Array = [];
		private var _sampleLoad:RadiostiyLoadBar;
		private var _tatolLoad:RadiostiyLoadBar;
		private var _btnEnd:RadiostiyInfoEndBut;
		private function print(type:String, args:Array, color:uint):void {
			//var msg:String = "<font color='#" + color.toString(16) + "'><b>[" + type + "]</b>" + args.join(" ") + "</font>\n";
			var msg:String = "<font color='#" + color.toString(16) + "'><b></b>" + args.join(" ") + "</font>\n";
			
			if(msg.search("render complete!")!=-1){
				this.setRenderFinish();
				_sampleLoad.setNum(100);
				_tatolLoad.setNum(100);
			}
			
			
			_msgs.push(msg);
			while(_msgs.length > 2000)
			{
				_msgs.shift();
			}
			refresh(msg);
		
		}
		/**根据过滤刷新显示*/
		private function refresh(newMsg:String):void {
			var msg:String = "";
			if (newMsg != null) {
				if (isFilter(newMsg)) {
					msg = (_textField.htmlText || "") + newMsg;
					_textField.htmlText = msg;
				}
			} else {
				for each (var item:String in _msgs) {
					if (isFilter(item)) {
						msg += item;
					}
				}
				_textField.htmlText = msg;
			}
			if (_canScroll) {
				_textField.scrollV = _textField.maxScrollV;
			}
		}

		/**是否是筛选属性*/
		private function isFilter(msg:String):Boolean {
			if (_filters.length < 1) {
				return true;
			}
			for each (var item:String in _filters) {
				if (msg.indexOf(item) > -1) {
					return true;
				}
			}
			return false;
		}
		
		public function setInfo($idType:uint,$byte:ByteArray):void
		{
			
				 switch($idType)
				 {
					 case 21:
					 {
//						 by.writeInt(resultNum);
//						 by.writeInt(_ary.length);
						 var resultNum:Number=$byte.readInt()
						 var lenght:Number=$byte.readInt();
	
							 
						 _sampleLoad.setNum(int((resultNum)/lenght*100))
						
						 
						 break;
					 }
					 case 22:
					 {
//						 by.writeInt(rodiosityNum);
//						 by.writeInt(allNum);
						 
						 var rodiosityNum:Number=$byte.readInt()
						 var allNum:Number=$byte.readInt()

							 
						 _tatolLoad.setNum(int((rodiosityNum)/allNum*100))
						 break;
					 }
					 case 23:
					 {
//						 by.writeUTF(str);
						 var str:String=$byte.readUTF()
						 print("提示", [str], 0xAAAAAA);
				
						 break;
					 }
					case 24:
					{
						var num:int = $byte.readInt();
						trace("end");
						break;
					}
						 
					 default:
					 {
						 break;
					 }
				 }
		}
		
	
		
		private function addEvents():void
		{
			this.addEventListener(FlexEvent.CREATION_COMPLETE,onStage);
			this.addEventListener(ResizeEvent.RESIZE,onStage);
			
			_btnEnd.addEventListener(MouseEvent.MOUSE_DOWN,btnDown)
	
			
		}
		protected function btnDown(event:MouseEvent):void
		{
			
			if(_btnEnd.label == "渲染结束"){
				RadiostiyInfoWindow.getInstance().close()
				return ;
			}

			Alert.yesLabel="确定";
			Alert.noLabel="取消";
			Alert.show("是否真的要停止渲染","警告!",3,this,enterFun)
				
			function enterFun(event:CloseEvent):void
			{
				if(event.detail==Alert.YES)
				{
					 RenderModel.getInstance().stopRender()
				}
			}
		}
		
		
		protected function onStage(event:Event):void
		{
			drawback();
		}
		
		private function drawback():void{
			
			
			
//			_shape.graphics.clear();
//			_shape.graphics.beginFill(0x303030,1);
//			_shape.graphics.lineStyle(1,0x151515);
//			
//			_shape.graphics.drawRect(0,0,this.width,20);
//			_shape.graphics.endFill();
			
			_bg.graphics.clear();
			_bg.graphics.beginFill(0x282828,1);
			_bg.graphics.drawRect(0,0,this.width,this.height);
			_bg.graphics.endFill();
			
			
			
			var $w:uint=Math.max(300,this.width)
			var $h:uint=Math.max(300,this.height)
			
			_textField.width=$w-60
			_textField.height=$h-210
	
				
				
			_btnEnd.y=$h-45
			_btnEnd.x=width/2-50
				
			_sampleLoad.width=$w-60
			_tatolLoad.width=$w-60
				
		
	
			
		}
		
		override public function set width(value:Number):void{
			super.width = value;
			drawback();
		}
		
		override public function changeSize():void{
			drawback();
			
		}
		override public function show($parent:Sprite):void{
			if(this.parent != $parent){
				$parent.addChild(this);
			}
		}
		
	}
}



