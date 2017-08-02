package mesh
{
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import interfaces.ITile;
	
	import mvc.top.OutTxtModel;
	
	import vo.H5UIFileNode;
	
	public class H5UIGroupMesh extends EventDispatcher implements ITile
	{

		private var _selectItem:Vector.<H5UIFileNode>
		private var _okBut:Boolean
		public function H5UIGroupMesh(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function get okBut():Boolean
		{
			return _okBut;
		}
		[Editor(type="Btn",Label="显示选取的名称",sort="3",Category="导出")]
		public function set okBut(value:Boolean):void
		{
			_okBut = value;
			
			var allStr:String=""
			for(var i:uint=0;i<_selectItem.length;i++){
				allStr+=_selectItem[i].name+"\n"
			}
			OutTxtModel.getInstance().initSceneConfigPanel(allStr);
		}

		public function get selectItem():Vector.<H5UIFileNode>
		{
			return _selectItem;
		}

		public function set selectItem(value:Vector.<H5UIFileNode>):void
		{
			_selectItem = value;
		}

		public function get kkd():Boolean
		{
			return true;
		}
		[Editor(type="AlignRect",Label="对齐",sort="4",Category="模型")]
		public function set kkd(value:Boolean):void
		{
			for(var i:uint=0;i<_selectItem.length;i++){
				_selectItem[i].sprite.updata()
			}
			
		}
		
		public function get rectSize():Object
		{
			var $rect:Rectangle=new Rectangle;
			for(var i:uint=0;i<_selectItem.length;i++){
				$rect.width+=_selectItem[i].rect.width
				$rect.height+=_selectItem[i].rect.height
				
			}
			$rect.width/=_selectItem.length
			$rect.height/=_selectItem.length
			
			return new Point($rect.width,$rect.height);
		}
		[Editor(type="Vec2",Label="尺寸",sort="2",Category="尺寸",Tip="坐标")]
		public function set rectSize(value:Object):void
		{
			for(var i:uint=0;i<_selectItem.length;i++){
				
				_selectItem[i].rect.width=value.x;
				_selectItem[i].rect.height=value.y;
				_selectItem[i].sprite.updata()
			}
		}

		public function getBitmapData():BitmapData
		{
			return null;
		}
		
		public function getName():String
		{
			return null;
		}
		
		public function acceptPath():String
		{
			return null;
		}
	}
}