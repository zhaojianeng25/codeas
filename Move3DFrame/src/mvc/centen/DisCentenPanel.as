package mvc.centen
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import mx.controls.Label;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	import _me.Scene_data;
	
	import common.AppData;
	import common.msg.event.scene.MEvent_Show_Imodel;
	import common.utils.frame.BaseComponent;
	import common.utils.frame.BasePanel;
	import common.utils.ui.file.FileNode;
	import common.utils.ui.file.FileNodeManage;
	import common.vo.editmode.EditModeEnum;
	
	import mvc.frame.FrameModel;
	import mvc.frame.line.FrameLinePointVo;
	import mvc.frame.view.FrameFileNode;
	import mvc.libray.LibrayFildNode;
	
	import proxy.top.render.Render;
	
	import render.ground.GroundManager;
	
	import xyz.MoveScaleRotationLevel;
	import xyz.draw.TooMathMoveUint;
	
	public class DisCentenPanel extends BasePanel
	{
	

		private var _sizeTxt:Label;
		private var _selectLineSprite:UIComponent


		private var _empteyPanel:BaseComponent
		public function DisCentenPanel()
		{
			super();
			
			//this.setStyle("borderColor",0x151515);
			//this.setStyle("borderStyle","solid");
			//this.setStyle("borderVisible",true);
			this.horizontalScrollPolicy = "off";

			addLabel();
			addLineSprite()
			
			this.addEmpteyPanel()
			
			this.addEventListener(Event.ADDED_TO_STAGE,onAddToStage)
				
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown)
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove)
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp)
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{

				if(this.lastMousePos){
					
					if(this.mouseLineSprite.parent){
						this.mouseLineSprite.graphics.clear()
					}
					var $rect:Rectangle=getMouseRect()
					
					if($rect.width<2||$rect.height<2){
						selectCtrlMouseDown(event)
					}else{
						
						$rect.x-=Scene_data.stage3DVO.x
						$rect.y-=Scene_data.stage3DVO.y
						var evt:MEvent_Show_Imodel=new MEvent_Show_Imodel(MEvent_Show_Imodel.MEVENT_SELECT_ITEM_IMODEL);
						evt.item=Render.getRectHitModel($rect);
						evt.shiftKey=event.shiftKey
						ModuleEventManager.dispatchEvent(evt);
					}
					
					
					
					this.lastMousePos=null;
					
				}
				
	
			
	
			
		}
		
		private function selectCtrlMouseDown(event:MouseEvent):void
		{
			// TODO Auto Generated method stub
			
		}
		private var mouseLineSprite:Sprite=new Sprite
		protected function onMouseMove(event:MouseEvent):void
		{
			if(this.lastMousePos){
				
				if(!this.mouseLineSprite.parent){
					Scene_data.stage.addChild(this.mouseLineSprite)
				}
				this.mouseLineSprite.graphics.clear()
				this.mouseLineSprite.graphics.lineStyle(1,0xFFFFFF,0.5)
				this.mouseLineSprite.graphics.beginFill(0xFFFFFF,0.2);
				
				var $rect:Rectangle=getMouseRect()
				this.mouseLineSprite.graphics.drawRect($rect.x,$rect.y,$rect.width,$rect.height);
				this.mouseLineSprite.graphics.endFill();
				
				
			}
			
		}
		private function getMouseRect():Rectangle
		{
			var rect:Rectangle=new Rectangle;
			rect.x=Math.min(this.lastMousePos.x,Scene_data.stage.mouseX);
			rect.y=Math.min(this.lastMousePos.y,Scene_data.stage.mouseY);
			rect.width=Math.abs(this.lastMousePos.x-Scene_data.stage.mouseX);
			rect.height=Math.abs(this.lastMousePos.y-Scene_data.stage.mouseY);
			
			return rect
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
		
			if(!MoveScaleRotationLevel.getInstance().useIt &&mouseInStage3D){
				this.lastMousePos=new Point(Scene_data.stage.mouseX,Scene_data.stage.mouseY)
			}
			
		}
		private function get mouseInStage3D():Boolean
		{
			var $rect:Rectangle=new Rectangle(0,0,Scene_data.stage3DVO.width,Scene_data.stage3DVO.height)
			return $rect.containsPoint(new Point(Scene_data.stage3DVO.mouseX,Scene_data.stage3DVO.mouseY));
		}
		private function addEmpteyPanel():void
		{
			this._empteyPanel=new BaseComponent();
			this.addChild(this._empteyPanel)
				

			
			this._empteyPanel.addEventListener(DragEvent.DRAG_ENTER,list_dragEnterHandler)
			this._empteyPanel.addEventListener(DragEvent.DRAG_DROP,list_dragDropHandler)
		}
		public function getMouseHitGroundPostion():Vector3D
		{
			var pos:Vector3D=GroundManager.mathDisplay2Dto3DWorldPos(Scene_data.stage3DVO,new Point(Scene_data.stage.mouseX,Scene_data.stage.mouseY),500)
			var triItem:Vector.<Vector3D>=new Vector.<Vector3D>
			triItem.push(new Vector3D(0,0,0))
			triItem.push(new Vector3D(-100,0,100))
			triItem.push(new Vector3D(+100,0,100))
			var camPos:Vector3D=new Vector3D(Scene_data.cam3D.x,Scene_data.cam3D.y,Scene_data.cam3D.z)
			return TooMathMoveUint.getLinePlaneInterectPointByTri(camPos,pos,triItem)
		}
		protected function list_dragDropHandler(event:DragEvent):void
		{
			var $fileNode:FileNode = event.dragSource.dataForFormat(FileNode.FILE_NODE) as FileNode;
			var $moveNode:LibrayFildNode=$fileNode as LibrayFildNode
			if($moveNode){
				var $hipPos:Vector3D=getMouseHitGroundPostion();
				if($moveNode.type==LibrayFildNode.Pefrab_TYPE1){
					var $tempB:FrameFileNode = new FrameFileNode;
					
					$tempB.id=	FileNodeManage.getFileNodeNextId(FrameModel.getInstance().ary)
					$tempB.pointitem=new Vector.<FrameLinePointVo>;
					var $scale:Number=0.25
					for(var i:Number=0;i<2;i++){
						var $obj:FrameLinePointVo=new FrameLinePointVo ;
						$obj.scale_x=$scale;
						$obj.scale_y=$scale;
						$obj.scale_z=$scale;
						$obj.x=$hipPos.x
						$obj.y=$hipPos.y
						$obj.z=$hipPos.z
						if(i==0){
							$obj.time=0;
							$obj.iskeyFrame=true;
						}else{
							$obj.time=100
							$obj.iskeyFrame=false;
						}
						$tempB.pointitem.push($obj);
					}
					$tempB.url=$moveNode.url.replace(AppData.workSpaceUrl,"")
					$tempB.iModel=AppDataFrame.addModel($tempB.url)
					$tempB.type=FrameFileNode.build1
					$tempB.iModel.scaleX=$scale
					$tempB.iModel.scaleY=$scale
					$tempB.iModel.scaleZ=$scale
					$tempB.name=$moveNode.name
		
					FrameModel.getInstance().ary.addItem($tempB)
				}
			}
			FrameModel.getInstance().framePanel.refrishFrameList()
		}
		
		protected function list_dragEnterHandler(event:DragEvent):void
		{
			
			
				var $fileNode:FileNode = event.dragSource.dataForFormat(FileNode.FILE_NODE) as FileNode;
			
		
				var ui:UIComponent = event.target as UIComponent;
				DragManager.acceptDragDrop(ui);
				
		
				
				
			
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
		private var lastMousePos:Point;
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
		
		protected function onPanelClik(event:MouseEvent):void
		{
		
			
		}
		
		protected function onAddToStage(event:Event):void
		{
			AppDataFrame.editMode=0
			
		}
		

		override public function onSize(event:Event= null):void
		{

			_sizeTxt.x=this.width-81
				
			this._empteyPanel.graphics.clear()
				
			this._empteyPanel.graphics.beginFill(0x505050,0);
			this._empteyPanel.graphics.lineStyle(1,0x353535);
			this._empteyPanel.graphics.drawRect(0,0,this.width,this.height);
			this._empteyPanel.graphics.endFill();
				
	
		}




		
	
	
	}
}


