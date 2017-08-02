package common.utils.ui.collision
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Tree;
	import mx.controls.listClasses.ListBaseContentHolder;
	import mx.core.ClassFactory;
	import mx.events.ListEvent;
	
	import _Pan3D.base.CollisionVo;
	import _Pan3D.core.MathCore;
	
	import collision.CollisionType;
	
	import common.msg.event.collision.MEvent_Collision;
	import common.utils.frame.BaseComponent;
	import common.utils.ui.color.ColorPickers;
	import common.utils.ui.prefab.PicBut;
	
	import modules.brower.fileWin.BrowerManage;
	import modules.collision.CollisionItemRender;

	public class CollisionUi  extends BaseComponent
	{
		private var _iconBmp:PicBut;
		private var _anShowAdd:PicBut;


		
		private var _tree:Tree;
		private var _collisionItem:Array

		private var _selectCollisionNode:CollisionNode;
		private var _boxIcon:PicBut;
		
		private var _collisionBoxMesh:CollisionBoxMesh;


		public function CollisionUi()
		{
			super();
			addList();
			addAllInfoPanels()
			addEvents();
			this.height=400;
			this.isDefault=false;
			
			addButA()
			addColor()
			
			
			
		}
		
		public function get collisionSpriteColor():uint
		{
			if(_selectCollisionNode){
				return _selectCollisionNode.collisionVo.colorInt;
			}else{
				return MathCore.argbToHex(255,0,0,255);
			}
		
		}

		public function set collisionSpriteColor(value:uint):void
		{
			if(_selectCollisionNode){
				_selectCollisionNode.collisionVo.colorInt=value
				ModuleEventManager.dispatchEvent(new MEvent_Collision(MEvent_Collision.CHANGE_COLLISION_POSTION));
			}
		}

		private function addColor():void
		{
			 _collisionColor = new ColorPickers;
			_collisionColor.FunKey ="collisionSpriteColor";
			_collisionColor.label = "显示颜色";
			_collisionColor.width = 100;
			_collisionColor.height = 18;

			_collisionColor.target=this
	
			_collisionColor.y=175;
			_collisionColor.x=25;
			this.addChild(_collisionColor)
			
		}

		
		private function addEvents():void
		{
			_tree.addEventListener(ListEvent.ITEM_CLICK,onItemClik);
			_tree.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,onDoubleClik)
			_tree.addEventListener(ListEvent.CHANGE,onChuange)
			_tree.addEventListener(MouseEvent.RIGHT_CLICK,onRightClick);
			_tree.addEventListener(Event.CLEAR,onDeleClear);
		
			

			
			
			
			
			var itemBox:NativeMenuItem = new NativeMenuItem("添加立方体");
			_menuFile.addItem(itemBox);
			
			var itemBall:NativeMenuItem = new NativeMenuItem("添加球体");
			_menuFile.addItem(itemBall);
			
			
			var itemCylinder:NativeMenuItem = new NativeMenuItem("添加圆柱");
			_menuFile.addItem(itemCylinder);
			
			var itemCone:NativeMenuItem = new NativeMenuItem("添加圆锥");
			_menuFile.addItem(itemCone);
			
			var itemPolygon:NativeMenuItem = new NativeMenuItem("添加凸边形");
			_menuFile.addItem(itemPolygon);
			
			
			itemBox.addEventListener(Event.SELECT,onAddSelitemBox);
			itemBall.addEventListener(Event.SELECT,onAddSelitemBall);
			itemPolygon.addEventListener(Event.SELECT,onAddSelitemPolygon);
			itemCylinder.addEventListener(Event.SELECT,onAddSelitemCylinder);
			itemCone.addEventListener(Event.SELECT,onAddSelitemCone);
			
		}		
		
		protected function onAddSelitemCone(event:Event):void
		{
			var $CollisionVo:CollisionVo=new CollisionVo;
			$CollisionVo.name="圆锥";
			$CollisionVo.type=CollisionType.Cone;
			$CollisionVo.scale_x=1
			$CollisionVo.scale_y=1
			$CollisionVo.scale_z=1
			
			$CollisionVo.colorInt=MathCore.argbToHex(255,255,0,255);
			_collisionItem.push($CollisionVo)
			change()
			
		}
		
		protected function onAddSelitemCylinder(event:Event):void
		{
			var $CollisionVo:CollisionVo=new CollisionVo;
			$CollisionVo.name="圆柱";
			$CollisionVo.type=CollisionType.Cylinder;
			$CollisionVo.scale_x=1
			$CollisionVo.scale_y=1
			$CollisionVo.scale_z=1
			
			$CollisionVo.colorInt=MathCore.argbToHex(255,0,255,255);
			_collisionItem.push($CollisionVo)
			change()
			
		}		

		
		protected function onDeleClear(evt:Event):void
		{
			if(_selectCollisionNode){
				for(var i:uint=0;i<_collisionItem.length;i++){
				
					if(_selectCollisionNode.collisionVo==_collisionItem[i]){
						_selectCollisionNode.collisionVo==_collisionItem[i]
						_collisionItem.splice(i,1)
						_selectCollisionNode=null
						change()
					    return ;
					}
				}
			}
		}		
		
		private function addAllInfoPanels():void
		{
			_collisionBoxMesh=new CollisionBoxMesh;
			this.addElement(_collisionBoxMesh)
			_collisionBoxMesh.y=205
			_collisionBoxMesh.visible=false
				
			_collisionPolygonMesh=new CollisionPolygonMesh;
			this.addElement(_collisionPolygonMesh)
			_collisionPolygonMesh.y=205
			_collisionPolygonMesh.visible=false
				
			_collisionBallMesh=new CollisionBallMesh;
			this.addElement(_collisionBallMesh)
			_collisionBallMesh.y=205
			_collisionBallMesh.visible=false
				
			_collisionCylinderMesh=new CollisionCylinderMesh;
			this.addElement(_collisionCylinderMesh)
			_collisionCylinderMesh.y=205
			_collisionCylinderMesh.visible=false
				
			_collisionConeMesh=new CollisionConeMesh;
			this.addElement(_collisionConeMesh)
			_collisionConeMesh.y=205
			_collisionConeMesh.visible=false
				
			_collisionBoxMesh.addEventListener(Event.CHANGE,onPanelChange)
			_collisionPolygonMesh.addEventListener(Event.CHANGE,onPanelChange)
			_collisionBallMesh.addEventListener(Event.CHANGE,onPanelChange)
			_collisionCylinderMesh.addEventListener(Event.CHANGE,onPanelChange)
			_collisionConeMesh.addEventListener(Event.CHANGE,onPanelChange)

	
		}
		
		protected function onPanelChange(event:Event):void
		{
			this.change();
			
		}
		
		protected function onAddSelitemBall(event:Event):void
		{
			var $CollisionVo:CollisionVo=new CollisionVo;
			$CollisionVo.name="球体";
			$CollisionVo.type=CollisionType.BALL
			$CollisionVo.radius=100
			$CollisionVo.colorInt=MathCore.argbToHex(255,255,0,0);
			_collisionItem.push($CollisionVo)
			change()
			
		}
		
		protected function onAddSelitemPolygon(event:Event):void
		{
			var $CollisionVo:CollisionVo=new CollisionVo;
			$CollisionVo.name="多凸边形";
			$CollisionVo.type=CollisionType.Polygon
			$CollisionVo.scale_x=1
			$CollisionVo.scale_y=1
			$CollisionVo.scale_z=1
			$CollisionVo.colorInt=MathCore.argbToHex(255,0,255,0);
			_collisionItem.push($CollisionVo)

			change()
			
		}
		protected function onAddSelitemBox(event:Event):void
		{
			var $CollisionVo:CollisionVo=new CollisionVo;
			$CollisionVo.name="立方体";
			$CollisionVo.type=CollisionType.BOX;
			$CollisionVo.scale_x=1
			$CollisionVo.scale_y=1
			$CollisionVo.scale_z=1
				
			$CollisionVo.colorInt=MathCore.argbToHex(255,0,0,255);
			_collisionItem.push($CollisionVo)
			change()
			
		}
		
	

		
		


		private var _menuFile:NativeMenu = new NativeMenu;
		private var _collisionPolygonMesh:CollisionPolygonMesh;
		private var _collisionBallMesh:CollisionBallMesh;
		private var _collisionCylinderMesh:CollisionCylinderMesh;
		private var _collisionConeMesh:CollisionConeMesh;
		private var _collisionColor:ColorPickers;
		protected function onRightClick(event:MouseEvent):void
		{
			if(event.target as ListBaseContentHolder){
				_menuFile.display(this.stage,stage.mouseX,stage.mouseY);
			}
			
		
		}
		
		protected function onSel(event:Event):void
		{
	
		}
		
		protected function onChuange(event:ListEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
		protected function onDoubleClik(event:ListEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
		protected function onItemClik(event:ListEvent):void
		{
			if(event.itemRenderer){
				 _selectCollisionNode=event.itemRenderer.data as CollisionNode	;

				 showCollisionNode()
				
				
			}
			
		}
		private function showCollisionNode():void
		{
			_collisionBoxMesh.visible=false
			_collisionPolygonMesh.visible=false
			_collisionBallMesh.visible=false
			_collisionCylinderMesh.visible=false
			_collisionConeMesh.visible=false
			
			switch(_selectCollisionNode.collisionVo.type)
			{
				case CollisionType.BOX:
				{
					_collisionBoxMesh.visible=true
					_collisionBoxMesh.collisionVo=_selectCollisionNode.collisionVo
					
					break;
				}
				case CollisionType.Polygon:
				{
					_collisionPolygonMesh.visible=true
					_collisionPolygonMesh.collisionVo=_selectCollisionNode.collisionVo
					break;
				}
				case CollisionType.BALL:
				{
					_collisionBallMesh.visible=true
					_collisionBallMesh.collisionVo=_selectCollisionNode.collisionVo
					break;
				}
				case CollisionType.Cylinder:
				{
					_collisionCylinderMesh.visible=true
					_collisionCylinderMesh.collisionVo=_selectCollisionNode.collisionVo
					break;
				}
					
				case CollisionType.Cone:
				{
					_collisionConeMesh.visible=true
					_collisionConeMesh.collisionVo=_selectCollisionNode.collisionVo
					break;
				}
					
				default:
				{
					break;
				}
			}
			
			_collisionColor.refreshViewValue();
			var objsEvent:MEvent_Collision = new MEvent_Collision(MEvent_Collision.SELECET_COLLISION_VO);
			objsEvent.collisionNode=_selectCollisionNode
			ModuleEventManager.dispatchEvent(objsEvent);
		}
		
		private function addButA():void
		{
			_anShowAdd=new PicBut
			this.addChild(_anShowAdd)
			_anShowAdd.setBitmapdata(BrowerManage.getIcon("materialsave"),16,16)
			_anShowAdd.y=180
			_anShowAdd.x=10
				
			_anShowAdd.addEventListener(MouseEvent.CLICK,onSaveMesh)
				

		}
		
		protected function onSaveMesh(event:MouseEvent):void
		{
			ModuleEventManager.dispatchEvent(new MEvent_Collision(MEvent_Collision.SAVE_COLLISION_TO_OBJS));
			
		
			
			
		}
		private function change():void
		{
			if(target&&FunKey){
				target[FunKey]=_collisionItem
			}
			
			this.refreshViewValue();
		}
			

		private function addList():void
		{
			_tree = new Tree;
			_tree.setStyle("top",5);
			_tree.setStyle("bottom",230);
			_tree.setStyle("left",5);
			_tree.setStyle("right",5);
			_tree.setStyle("contentBackgroundColor",0x505050);
			_tree.setStyle("color",0x9f9f9f);
			_tree.setStyle("borderVisible",false);
			this.addChild(_tree);
			_tree.labelField="name";
			_tree.itemRenderer = new ClassFactory(CollisionItemRender);

			

			
			
		}
		private function tree_iconFunc(item:CollisionNode):Class {  
			return BrowerManage.getIconClassByName("profeb_16")
			return BrowerManage.getIconClassByName("light_16")
		}

		override public function refreshViewValue():void
		{
			if(target&&FunKey){
				setItemData(target[FunKey]);
			}
			
		}
		
		private function setItemData($arr:Array):void
		{
			_collisionItem=$arr;
			var _searchArr:ArrayCollection=new ArrayCollection;
			for(var i:uint=0;i<_collisionItem.length;i++){
				var $CollisionNode:CollisionNode=new CollisionNode;
				$CollisionNode.name=CollisionVo(_collisionItem[i]).name;
				$CollisionNode.collisionVo=CollisionVo(_collisionItem[i]);
				_searchArr.addItem($CollisionNode)
				$CollisionNode.addEventListener(Event.CHANGE,onCollisionNodeChange)
			}
		
			_tree.dataProvider = _searchArr;
			_tree.invalidateList();
			_tree.validateNow();
			_tree.selectedIndex=0;
		
			if(_searchArr.length){
				_selectCollisionNode=_searchArr[0];
				_collisionColor.refreshViewValue();
				showCollisionNode()
			}
			
			
		}
		
		protected function onCollisionNodeChange(event:Event):void
		{
			_collisionBoxMesh.refreshViewValue();
			_collisionPolygonMesh.refreshViewValue();
			_collisionBallMesh.refreshViewValue();
			_collisionCylinderMesh.refreshViewValue();
			_collisionConeMesh.refreshViewValue();
			
		}
		
	}
}


