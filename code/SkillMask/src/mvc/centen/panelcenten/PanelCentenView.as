package mvc.centen.panelcenten
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Label;
	import mx.core.UIComponent;
	
	import common.utils.frame.BasePanel;
	
	import mvc.left.panelleft.vo.PanelNodeVo;
	import mvc.left.panelleft.vo.PanelSkillMaskNode;
	
	public class PanelCentenView extends BasePanel
	{
		private var _panelCentenBack:PanelCentenBackSprite;
		private var _panelSkillInfoLevel:PanelSkillInfoLevel
		private var _panelNodeVo:PanelNodeVo
		private var _selectArr:Vector.<PanelSkillMaskNode>;

	
		public function PanelCentenView()
		{
			super();
			initData()
			this.addEventListener(Event.ADDED_TO_STAGE,onAddToStage)
			
		}
		
		public function get panelSkillInfoLevel():PanelSkillInfoLevel
		{
			return _panelSkillInfoLevel;
		}

		public function set panelSkillInfoLevel(value:PanelSkillInfoLevel):void
		{
			_panelSkillInfoLevel = value;
		}

		public function get scaleNum():Number
		{
			return _scaleNum;
		}

		public function get selectArr():Vector.<PanelSkillMaskNode>
		{
			return _selectArr;
		}

		public function set selectArr(value:Vector.<PanelSkillMaskNode>):void
		{
			_selectArr = value;
		}
		public function get nodeItem():ArrayCollection
		{
			return _panelNodeVo.item;
		}

		public function set nodeItem(value:ArrayCollection):void
		{
			_panelNodeVo.item = value;
		}

		protected function onAddToStage(event:Event):void
		{
			UiData.editMode=1
		}

		public function get panelNodeVo():PanelNodeVo
		{
			return _panelNodeVo;
		}

		public function set panelNodeVo(value:PanelNodeVo):void
		{
			_selectArr=new Vector.<PanelSkillMaskNode>
			_panelNodeVo = value;

			_panelSkillInfoLevel.setItem=_panelNodeVo.item
			changeData()
		}
		public function changeData():void
		{
			_panelCentenBack.drawColorSprite(_panelNodeVo)
		}

		private function initData():void
		{
			
			_selectArr=new Vector.<PanelSkillMaskNode>
			_panelCentenBack=new PanelCentenBackSprite()
			this.addChild(_panelCentenBack)
			_panelSkillInfoLevel=new PanelSkillInfoLevel()
			this.addChild(_panelSkillInfoLevel)
			addLabel()
			
			addLineSprite()
			
		}
		public function get beginLinePoin():Point
		{
			return _beginLinePoin;
		}
		
		private function addLineSprite():void
		{
			_selectLineSprite=new UIComponent;
			this.addChild(_selectLineSprite)
		}
		private var _beginLinePoin:Point
		public function beginDrawLine():void
		{
			_beginLinePoin=new Point(this.mouseX,this.mouseY)
		}
		public function endDrawLine():void
		{
			_selectLineSprite.graphics.clear();
			_beginLinePoin=null;
		}
		public function drawSelectLine():void
		{
			if(_beginLinePoin){
				var a:Point=_beginLinePoin
				var b:Point=new Point(this.mouseX,this.mouseY)
				_selectLineSprite.graphics.clear();
				_selectLineSprite.graphics.lineStyle(1,0xff0000,1)
				_selectLineSprite.graphics.moveTo(a.x,a.y)
				_selectLineSprite.graphics.lineTo(a.x,b.y)
				_selectLineSprite.graphics.lineTo(b.x,b.y)
				_selectLineSprite.graphics.lineTo(b.x,a.y)
				_selectLineSprite.graphics.lineTo(a.x,a.y)
			}
			
			
			
		}
		private function addLabel():void
		{
			_sizeTxt=new Label
			_sizeTxt.width=80
			_sizeTxt.height=20
			this.addChild(_sizeTxt)
			_sizeTxt.text="比例:100%"
			
		}
		override public function onSize(event:Event= null):void
		{
			
			_sizeTxt.x=this.width-81
		}

		public function changePanelInfoLevel():void
		{
			for(var i:uint=0;i<_panelNodeVo.item.length;i++){
				var $PanelRectInfoNode:PanelSkillMaskNode=_panelNodeVo.item[i]  as PanelSkillMaskNode;
				var $parent:DisplayObjectContainer=$PanelRectInfoNode.sprite.parent
				if($parent){
					var num:int=$parent.getChildIndex($PanelRectInfoNode.sprite)
					$PanelRectInfoNode.level=num
				}
			}

		
		}
	
		
		private var lastMousePos:Point;
		private var lastDisPos:Point
		private var _middleDown:Boolean;
		private var _scaleNum:Number=1;
		private var _copyItem:Vector.<PanelSkillMaskNode>;
		private var _sizeTxt:Label;
		private var _selectLineSprite:UIComponent;
		public function set middleDown(value:Boolean):void
		{
			_middleDown = value;
			if(_middleDown){
				lastMousePos=new Point(this.mouseX,this.mouseY)
				lastDisPos=new Point(_panelCentenBack.x,_panelCentenBack.y)
			}
		}
		public function mouseMove():void
		{
			if(_middleDown){
				var nowMouse:Point=new Point(this.mouseX,this.mouseY)
				_panelCentenBack.x=lastDisPos.x+(nowMouse.x-lastMousePos.x)
				_panelCentenBack.y=lastDisPos.y+(nowMouse.y-lastMousePos.y)
				
				_panelSkillInfoLevel.x=_panelCentenBack.x;
				_panelSkillInfoLevel.y=_panelCentenBack.y;
			}
		}
		public function get PexilX():Number
		{
			return _panelCentenBack.x
		}
		public function get PexilY():Number
		{
			return _panelCentenBack.y
		}
	
		public function KeyAdd():void
		{
			_scaleNum=_scaleNum*1.1
			if(Math.abs(1-_scaleNum)<0.05){
				_scaleNum=1
			}	
			_panelCentenBack.scaleX=_scaleNum;
			_panelCentenBack.scaleY=_scaleNum;
			_panelSkillInfoLevel.scaleX=_scaleNum;
			_panelSkillInfoLevel.scaleY=_scaleNum;
			_sizeTxt.text="比例:"+String(int(_scaleNum*100))+"%"
		}
		public function KeySub():void
		{
			_scaleNum=_scaleNum*0.9
				
			if(Math.abs(1-_scaleNum)<0.05){
				_scaleNum=1
			}	
			_panelCentenBack.scaleX=_scaleNum;
			_panelCentenBack.scaleY=_scaleNum;
			_panelSkillInfoLevel.scaleX=_scaleNum;
			_panelSkillInfoLevel.scaleY=_scaleNum;
			
			_sizeTxt.text="比例:"+String(int(_scaleNum*100))+"%"
		}
		
		public function makeCopy():void
		{
			_copyItem=new Vector.<PanelSkillMaskNode>
			if(selectArr&&selectArr.length){
				for(var i:uint=0;i<selectArr.length;i++)
				{
					_copyItem.push(selectArr[i])
				}
			}
			
		}
		
		public function paste():Boolean
		{
			if(_copyItem&&_copyItem.length){
				_selectArr=new Vector.<PanelSkillMaskNode>
				for(var i:uint=0;i<_copyItem.length;i++)
				{
					_copyItem[i].select=false;
					_copyItem[i].sprite.changeSize();
					var $PanelRectInfoNode:PanelSkillMaskNode=_copyItem[i].clone();
					$PanelRectInfoNode.name=_copyItem[i].name+"_copy";
					$PanelRectInfoNode.select=true
					nodeItem.addItem($PanelRectInfoNode)
					_panelSkillInfoLevel.addPanelRectInfoNode($PanelRectInfoNode)
					_selectArr.push($PanelRectInfoNode)
						
				}
				
				
				
				return true
				
				
			}
			return false
			
		}
		
		public function getBmpPostion():Point
		{
			// TODO Auto Generated method stub
			return new Point(_panelSkillInfoLevel.x,_panelSkillInfoLevel.y);
		}
	}
}