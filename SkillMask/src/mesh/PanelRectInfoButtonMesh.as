package mesh
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	import interfaces.ITile;
	
	import mvc.left.panelleft.vo.PanelSkillMaskNode;
	
	public class PanelRectInfoButtonMesh extends EventDispatcher implements ITile
	{
		protected var _url:String;
		protected var _panelSkillMaskNode:PanelSkillMaskNode;
		protected var _rectPos:Point
		protected var _rectSize:Point
		
		private var _rectInfoPictureName:String
		
		
		public function get selectTab():Boolean
		{
			return _panelSkillMaskNode.selectTab;
		}
		//[Editor(type="ComboBox",Label="是否选中",sort="4.5",Category="属性",Data="{name:false,data:false}{name:true,data:true}",Tip="是否当地形用来扫描高度")]
		public function set selectTab(value:Boolean):void
		{
			_panelSkillMaskNode.selectTab=value
			change()
		}
		
		public function get rotationNum():Number
		{
			return _panelSkillMaskNode.rotationNum;
		}
		[Editor(type="Number",Label="旋转角度",Step="1",sort="3",MinNum="0",MaxNum="360",Category="属性",Tip="范围")]
		public function set rotationNum(value:Number):void
		{
			_panelSkillMaskNode.rotationNum = value;
			change()
		}
		
		public function get openNum():Number
		{
			return _panelSkillMaskNode.openNum;
		}
		[Editor(type="Number",Label="开口",Step="1",sort="4",MinNum="0",MaxNum="360",Category="属性",Tip="范围")]
		public function set openNum(value:Number):void
		{
			_panelSkillMaskNode.openNum = value;
			change()
		}
		
		
		public function get rectInfoPictureA():String
		{
			return String(_panelSkillMaskNode.dataItem[0]);
		}
		[Editor(type="PanelPictureUI",Label="图片",sort="5",changePath="0",Category="模型")]
		public function set rectInfoPictureA(value:String):void
		{
			_panelSkillMaskNode.dataItem[0] = value;
			change()
			
		}
		

		
		public function get rectInfoPictureB():String
		{
			return String(_panelSkillMaskNode.dataItem[1]);
		}
	//	[Editor(type="PanelPictureUI",Label="图片",sort="6",changePath="0",Category="按下")]
		public function set rectInfoPictureB(value:String):void
		{
			_panelSkillMaskNode.dataItem[1] = value;
			change()
			
		}
		
//		public function get rectInfoPictureC():String
//		{
//			return String(_panelRectInfoNode.dataItem[2]);
//		}
//		[Editor(type="PanelPictureUI",Label="图片",sort="7",changePath="0",Category="按下")]
//		public function set rectInfoPictureC(value:String):void
//		{
//			_panelRectInfoNode.dataItem[2] = value;
//			change()
//			
//		}
		
		public function get rectPos():Point
		{
			return new Point(_panelSkillMaskNode.rect.x,_panelSkillMaskNode.rect.y);
		}
		[Editor(type="Vec2",Label="坐标",sort="1",Category="尺寸",Tip="坐标")]
		public function set rectPos(value:Point):void
		{
			_panelSkillMaskNode.rect.x=value.x;
			_panelSkillMaskNode.rect.y=value.y;
			change()
		}
		

		
		public function get rectSize():Object
		{
			return new Point(_panelSkillMaskNode.rect.width,_panelSkillMaskNode.rect.height);
		}
		[Editor(type="Vec2",Label="尺寸",sort="2",Category="尺寸",Tip="坐标")]
		public function set rectSize(value:Object):void
		{
			_panelSkillMaskNode.rect.width=value.x;
			_panelSkillMaskNode.rect.height=value.y;
			change()
		}
		
		public function get okbut():Boolean
		{
			return true;
		}
		[Editor(type="Btn",Label="居中对齐",sort="3",Category="尺寸")]
		public function set okbut(value:Boolean):void
		{
	
	
			
			_panelSkillMaskNode.rect.x=(UiData.panelNodeVo.canverRect.width-_panelSkillMaskNode.rect.width)/2
			_panelSkillMaskNode.rect.y=(UiData.panelNodeVo.canverRect.height-_panelSkillMaskNode.rect.height)/2
			
				change()
				
				
		
		}
		public function get panelSkillMaskNode():PanelSkillMaskNode
		{
			return _panelSkillMaskNode;
		}
		public function set panelSkillMaskNode(value:PanelSkillMaskNode):void
		{
			_panelSkillMaskNode = value;
		}
		public function change():void{
			this.dispatchEvent(new Event(Event.CHANGE));
			
		}
		
		
		
		public function acceptPath():String
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		public function getBitmapData():BitmapData
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		public function getName():String
		{
			// TODO Auto Generated method stub
			return _panelSkillMaskNode.name;
		}
		
	}
}



