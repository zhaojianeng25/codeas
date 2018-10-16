package mesh
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	import interfaces.ITile;
	
	import mvc.left.panelleft.vo.PanelRectInfoNode;
	
	import vo.H5UIFileNode;
	
	public class PanelRectInfoPictureMesh extends EventDispatcher implements ITile
	{
		protected var _url:String;
		protected var _panelRectInfoNode:PanelRectInfoNode;
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
			if(_panelRectInfoNode.name=="newName")
			{
				var $changeName:String=value.toLocaleLowerCase();
				_panelRectInfoNode.name=$changeName.substr(0,1)+value.substring(1,value.length);
			}
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
		
		public function get okbut():Boolean
		{
			return true;
		}
		[Editor(type="Btn",Label="原始尺寸",sort="3",Category="尺寸")]
		public function set okbut(value:Boolean):void
		{
			var bmp:BitmapData=UiData.getUIBitmapDataByName(_panelRectInfoNode.dataItem[0]);
			var $H5UIFileNode:H5UIFileNode=UiData.getUiNodeByName(_panelRectInfoNode.dataItem[0])
	
			if(bmp){
				_panelRectInfoNode.rect.width=bmp.width
				_panelRectInfoNode.rect.height=bmp.height
				
				if($H5UIFileNode.type==2&&$H5UIFileNode.rowColumn&&$H5UIFileNode.rowColumn.x>0&&$H5UIFileNode.rowColumn.y>0){
					_panelRectInfoNode.rect.width=bmp.width/$H5UIFileNode.rowColumn.x
					_panelRectInfoNode.rect.height=bmp.height/$H5UIFileNode.rowColumn.y
				}
					
				change()
			}
		}
		
		public function get panelRectInfoNode():PanelRectInfoNode
		{
			return _panelRectInfoNode;
		}
		public function set panelRectInfoNode(value:PanelRectInfoNode):void
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


