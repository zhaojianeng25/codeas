package mesh
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	import interfaces.ITile;
	
	import mvc.left.panelleft.vo.PanelSkillMaskNode;
	
	import vo.H5UIFileNode;
	
	public class PanelRectInfoPictureMesh extends EventDispatcher implements ITile
	{
		protected var _url:String;
		protected var _panelRectInfoNode:PanelSkillMaskNode;
		protected var _rectPos:Point
		protected var _rectSize:Point

		
		private var _rectInfoPictureName:String



		public function get rectInfoPictureName():String
		{
			return String(_panelRectInfoNode.dataItem[0]);
		}
		[Editor(type="PanelPictureUI",Label="图片",sort="5",changePath="0",Category="模型")]
		public function set rectInfoPictureName(value:String):void
		{
			_panelRectInfoNode.dataItem[0] = value;
			change()

		}
		
//		public function get needSkyBox():Boolean
//		{
//			return _panelRectInfoNode.isui9;
//		}
//		[Editor(type="ComboBox",Label="为9宫格",sort="4",Category="属性",Data="{name:false,data:false}{name:true,data:true}",Tip="是否当地形用来扫描高度")]
//		public function set needSkyBox(value:Boolean):void
//		{
//			_panelRectInfoNode.isui9=value
//			change()
//		}

		public function get rectPos():Point
		{
			return new Point(_panelRectInfoNode.rect.x,_panelRectInfoNode.rect.y);
		}
		[Editor(type="Vec2",Label="坐标",sort="1",Category="尺寸",Tip="坐标")]
		public function set rectPos(value:Point):void
		{
			_panelRectInfoNode.rect.x=value.x;
			_panelRectInfoNode.rect.y=value.y;
			change()
		}
		
	
		
		public function get rectSize():Object
		{
			return new Point(_panelRectInfoNode.rect.width,_panelRectInfoNode.rect.height);
		}
		[Editor(type="Vec2",Label="尺寸",sort="2",Category="尺寸",Tip="坐标")]
		public function set rectSize(value:Object):void
		{
			_panelRectInfoNode.rect.width=value.x;
			_panelRectInfoNode.rect.height=value.y;
			change()
		}
		
		public function get rotationNum():Number
		{
			return _panelRectInfoNode.rotationNum;
		}
		[Editor(type="Number",Label="旋转角度",Step="1",sort="3",MinNum="0",MaxNum="360",Category="属性",Tip="范围")]
		public function set rotationNum(value:Number):void
		{
			_panelRectInfoNode.rotationNum = value;
			change()
		}
		public function get okbut():Boolean
		{
			return true;
		}
		[Editor(type="Btn",Label="居中对齐",sort="3",Category="尺寸")]
		public function set okbut(value:Boolean):void
		{
		
			_panelRectInfoNode.rect.x=(UiData.panelNodeVo.canverRect.width-_panelRectInfoNode.rect.width)/2
			_panelRectInfoNode.rect.y=(UiData.panelNodeVo.canverRect.height-_panelRectInfoNode.rect.height)/2
			
			change()

		}
		
		public function get panelRectInfoNode():PanelSkillMaskNode
		{
			return _panelRectInfoNode;
		}
		public function set panelRectInfoNode(value:PanelSkillMaskNode):void
		{
			_panelRectInfoNode = value;
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
			return _panelRectInfoNode.name;
		}
		
	}
}


