package  common.utils.ui.navMesh
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.display.InteractiveObject;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.Tree;
	import mx.controls.listClasses.ListBaseContentHolder;
	import mx.core.ClassFactory;
	import mx.events.CloseEvent;
	import mx.events.ListEvent;
	
	import _Pan3D.display3D.model.Display3DModelSprite;
	
	import _me.Scene_data;
	
	import common.msg.event.collision.MEvent_Collision;
	import common.utils.frame.BaseComponent;
	import common.utils.ui.prefab.PicBut;
	
	import modules.brower.fileWin.BrowerManage;
	import modules.collision.CollisionItemRender;
	import modules.navMesh.NavMeshEvent;
	import modules.navMesh.NavMeshPosVo;
	
	public class NavMeshUi  extends BaseComponent
	{


		
		
		
		private var _tree:Tree;
		private var _collisionItem:Array
		
		private var _selectCollisionNode:NavMeshNode;

		private var _navAddInfoMesh:NavAddInfoMesh;
		
		
		public function NavMeshUi()
		{
			super();
			addList();
			addEvents();
			addButresetHeight()
			addButmeshStart()
			this.height=400;
			this.isDefault=false;
			
			this.addAllInfoPanels();	
			
			
			
		}
		
		private function addAllInfoPanels():void
		{
			_navAddInfoMesh=new NavAddInfoMesh;
			this.addElement(_navAddInfoMesh)
			_navAddInfoMesh.y=10
	
		}
		private function addButmeshStart():void
		{
			var $anMeshStart:PicBut=new PicBut
			this.addChild($anMeshStart)
			$anMeshStart.setBitmapdata(BrowerManage.getIcon("prefab"),16,16)
			$anMeshStart.y=360;
			$anMeshStart.x=60;
			$anMeshStart.addEventListener(MouseEvent.MOUSE_UP,anMeshStartClik)
			
		}
		protected function anMeshStartClik(event:MouseEvent):void
		{

			var $InteractiveObject:InteractiveObject=Scene_data.stage.focus
			Alert.show("刷新NavMesh地形高度","提示",Alert.YES | Alert.NO,null,	function onClose(evt:CloseEvent):void
			{
				if(evt.detail == Alert.YES){

					if(!Display3DModelSprite.collistionState){ 
						ModuleEventManager.dispatchEvent(new MEvent_Collision(MEvent_Collision.SHOW_SCENE_COLLISTION));
					}
					ModuleEventManager.dispatchEvent(new NavMeshEvent(NavMeshEvent.SHOW_NAVMESH_START_LINE));
				}
				Scene_data.stage.focus=$InteractiveObject
		
			});

		}
		
		private function addButresetHeight():void
		{
			var $anResetHeight:PicBut=new PicBut
			this.addChild($anResetHeight)
			$anResetHeight.setBitmapdata(BrowerManage.getIcon("prefab"),16,16)
			$anResetHeight.y=360;
			$anResetHeight.x=20;
			$anResetHeight.addEventListener(MouseEvent.MOUSE_UP,onSaveMesh)
			
			
		}
		
		protected function onSaveMesh(event:MouseEvent):void
		{
			var $InteractiveObject:InteractiveObject=Scene_data.stage.focus
			Alert.show("生存A星数据","提示",Alert.YES | Alert.NO,null,	function onClose(evt:CloseEvent):void
			{
				if(evt.detail == Alert.YES){
					
					if(!Display3DModelSprite.collistionState){ 
						ModuleEventManager.dispatchEvent(new MEvent_Collision(MEvent_Collision.SHOW_SCENE_COLLISTION));
					}
					ModuleEventManager.dispatchEvent(new NavMeshEvent(NavMeshEvent.SHOW_NAVMESH_TRI_LINE));
				}
				Scene_data.stage.focus=$InteractiveObject
			});
	
			
		}

		
		
		private function addEvents():void
		{
			_tree.addEventListener(ListEvent.ITEM_CLICK,onItemClik);
			_tree.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,onDoubleClik)
			_tree.addEventListener(ListEvent.CHANGE,onChuange)
			_tree.addEventListener(MouseEvent.RIGHT_CLICK,onRightClick);
			_tree.addEventListener(Event.CLEAR,onDeleClear);
			
			
			
			
			
			var itemBox:NativeMenuItem = new NativeMenuItem("添加");
			_menuFile.addItem(itemBox);
			

			
			
			itemBox.addEventListener(Event.SELECT,onAddSelitemBox);
	
			
		}		

		
		protected function onDeleClear(evt:Event):void
		{
			if(_selectCollisionNode){
				for(var i:uint=0;i<_collisionItem.length;i++){
					
			
					
					if(_selectCollisionNode==_collisionItem[i]){
						_selectCollisionNode==_collisionItem[i]
						_collisionItem.splice(i,1)
						_selectCollisionNode=null
						change()
						
				
						
					
						return ;
					}
				}
			}
		}		
		

		
		protected function onPanelChange(event:Event):void
		{
			this.change();
			
		}

		protected function onAddSelitemBox(event:Event):void
		{
	
			_collisionItem.push(getTempRound(new Vector3D(0,30,0)))
			change()
			
		}
		private function getTempRound($basePos:Vector3D):NavMeshNode
		{
			
			var node:NavMeshNode=new NavMeshNode()
			var $arr:Vector.<NavMeshPosVo>=new Vector.<NavMeshPosVo>
			var n:Number=4
			for(var i:Number=0;i<n;i++){
				var m:Matrix3D=new Matrix3D;
				m.appendRotation(i*360/n,Vector3D.Y_AXIS)
				var $pos:Vector3D=m.transformVector(new Vector3D(100,0,0));
				$pos=$pos.add($basePos)
				var $NavMeshPosVo:NavMeshPosVo=new NavMeshPosVo(Scene_data.context3D);
				
				$NavMeshPosVo.x=$pos.x;
				$NavMeshPosVo.y=$pos.y;
				$NavMeshPosVo.z=$pos.z;
				$arr.push($NavMeshPosVo)
				
			}
			node.data=$arr
				
			if(_collisionItem&&_collisionItem.length){
				node.id=_collisionItem[_collisionItem.length-1].id+1
				node.name="id"+String(node.id)
			}else{
				node.name="around"
			}	
		
	
			return node
			
			
			
		}
		
		
		
		
		
		
		
		private var _menuFile:NativeMenu = new NativeMenu;



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
				_selectCollisionNode=event.itemRenderer.data as NavMeshNode
				var $navMeshEvent:NavMeshEvent=new NavMeshEvent(NavMeshEvent.SELECT_NAVEMESH_NODE_MOVE)
				$navMeshEvent.navMeshNode=_selectCollisionNode	;
				ModuleEventManager.dispatchEvent($navMeshEvent);
				
		
				_navAddInfoMesh.navMeshNode=_selectCollisionNode
			
			}
			
		}
	
		

		private function change():void
		{
			if(target&&FunKey){
				target[FunKey]=_collisionItem
			}
			
			this.refreshViewValue();
			
			ModuleEventManager.dispatchEvent(new NavMeshEvent(NavMeshEvent.RESET_NAVMESH_SPRITE));
		}
		
		
		private function addList():void
		{
			_tree = new Tree;
			_tree.setStyle("top",40);
			_tree.setStyle("bottom",50);
			_tree.setStyle("left",5);
			_tree.setStyle("right",5);
			_tree.setStyle("contentBackgroundColor",0x505050);
			_tree.setStyle("color",0x9f9f9f);
			_tree.setStyle("borderVisible",false);
			this.addChild(_tree);
			_tree.labelField="name";
			_tree.itemRenderer = new ClassFactory(CollisionItemRender);
			
			
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
	
				_searchArr.addItem($arr[i])
			
			}
			
			_tree.dataProvider = _searchArr;
			_tree.invalidateList();
			_tree.validateNow();
			_tree.selectedIndex=0;
			
			if(_searchArr.length){
				_selectCollisionNode=_searchArr[0];

			}
			
			
		}
		
		protected function onCollisionNodeChange(event:Event):void
		{


			
		}
		
	}
}



