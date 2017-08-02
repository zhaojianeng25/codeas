package mesh
{
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	import interfaces.ITile;
	
	import mvc.left.panelleft.vo.PanelRectInfoNode;
	import mvc.left.panelleft.vo.PanelRectInfoType;
	import mvc.top.OutTxtModel;
	


	public class PanelRectGroupMesh extends EventDispatcher implements ITile
	{
		
		private var _selectItem:Vector.<PanelRectInfoNode>
		private var _sizeData:Boolean
		private var _outPutData:Boolean;
		public function PanelRectGroupMesh(target:IEventDispatcher=null)
		{
			super(target);
		}
		public function get outPutData():Boolean
		{
			return _outPutData;
		}
		[Editor(type="Btn",Label="导出H5添加方法",sort="2",Category="导出")]
		public function set outPutData(value:Boolean):void
		{
			_outPutData = value;
			
			var allStr:String=""
			for(var i:uint=0;i<_selectItem.length;i++){
				var $PanelRectInfoNode:PanelRectInfoNode=PanelRectInfoNode(_selectItem[i]);

				if($PanelRectInfoNode.name=="newName"){
					continue;
				}
				
				var $str:String="renderLevel.getComponent("+"\""+$PanelRectInfoNode.name+"\""+")";
				
				switch($PanelRectInfoNode.type)
				{
					case PanelRectInfoType.BUTTON:
					{
						
						$str="<"+"SelectButton"+">"+$str;						
						
						//this.A_select_but_0 = <SelectButton>this._midRender.getComponent("A_select_but_0")
						
						break;
					}
						
					default:
					{
					//	$str="<"+"UICompenent"+">"+$str;
						
						break;
					}
				}
				
			//	var a_role_pic:UICompenent=<UICompenent>renderLevel.getComponent("a_role_pic")
				
				$str="this.addChild("+$str+");";
				allStr=allStr+$str+"\n"
			//	$str="this.addChild("+$PanelRectInfoNode.name+")"

			}
			OutTxtModel.getInstance().initSceneConfigPanel(allStr);
		}
		
		public function get sizeData():Boolean
		{
			return _sizeData;
		}
		[Editor(type="Btn",Label="原始尺寸",sort="3",Category="尺寸")]
		public function set sizeData(value:Boolean):void
		{
			_sizeData = value;
			
			Alert.show("是否重置为原始尺寸","重置",3,null ,function callBack(event:CloseEvent):void
			{
				if(event.detail == Alert.YES)
				{
					for(var i:uint=0;i<_selectItem.length;i++){
						
						var bmp:BitmapData=UiData.getUIBitmapDataByName(_selectItem[i].dataItem[0]);
						if(bmp){
							_selectItem[i].rect.width=bmp.width
							_selectItem[i].rect.height=bmp.height
							_selectItem[i].sprite.changeSize()
						}
						
					}
				}
				
			});
		
		}

		public function get selectItem():Vector.<PanelRectInfoNode>
		{
			return _selectItem;
		}
		
		public function set selectItem(value:Vector.<PanelRectInfoNode>):void
		{
			_selectItem = value;
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
		[Editor(type="Vec2",Label="尺寸",sort="1",Category="尺寸",Tip="坐标")]
		public function set rectSize(value:Object):void
		{
			for(var i:uint=0;i<_selectItem.length;i++){
				
				_selectItem[i].rect.width=value.x;
				_selectItem[i].rect.height=value.y;
				_selectItem[i].sprite.changeSize()
			}
		}
		
		
		public function get kkd():Boolean
		{
			return true;
		}
		[Editor(type="AlignRect",Label="对齐",sort="4",Category="模型")]
		public function set kkd(value:Boolean):void
		{
			for(var i:uint=0;i<_selectItem.length;i++){
				_selectItem[i].sprite.changeSize()
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


