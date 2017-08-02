package modules.navMesh
{
	import com.zcp.frame.Module;
	import com.zcp.frame.Processor;
	import com.zcp.frame.event.ModuleEvent;
	
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	
	import _Pan3D.core.MathCore;
	import _Pan3D.display3D.navMesh.NavMeshBoxDisplay3DSprite;
	
	import _me.Scene_data;
	
	import common.AppData;
	import common.utils.ui.navMesh.NavMeshNode;
	import common.vo.editmode.EditModeEnum;
	
	import modules.hierarchy.HierarchyFileNode;
	import modules.scene.SceneEditModeManager;
	
	import navMesh.NavMeshStaticMesh;
	
	import org.navmesh.NavUtils;
	import org.navmesh.geom.Polygon;
	import org.navmesh.geom.Triangle;
	import org.navmesh.geom.Vector2f;
	
	import proxy.pan3d.navMesh.ProxyPan3dNavMesh;
	
	import xyz.MoveScaleRotationLevel;
	import xyz.base.TooXyzPosData;
	import xyz.draw.TooXyzMoveData;
	
	public class NavMeshProcessor extends Processor
	{
		public function NavMeshProcessor($module:Module)
		{
			super($module);
		}
		
		override protected function listenModuleEvents():Array 
		{
			return [
				NavMeshEvent,
		
			]
		}
		override protected function receivedModuleEvent($me:ModuleEvent):void 
		{
			switch($me.getClass()) {
				case NavMeshEvent:
					var $navMeshEvent:NavMeshEvent= $me as NavMeshEvent
					if($navMeshEvent.action==NavMeshEvent.SELECT_NAVMESH_NODE){
						this.selectNode($navMeshEvent.hierarchyFileNode)
						SceneEditModeManager.changeMode(EditModeEnum.EDIT_NAVMESH)
					}
					if($navMeshEvent.action==NavMeshEvent.RESET_NAVMESH_SPRITE){
						restNavMeshSpriet()
					}
					if($navMeshEvent.action==NavMeshEvent.SELECT_NAVEMESH_NODE_MOVE){
						selectMove($navMeshEvent.navMeshNode)
					}
					if($navMeshEvent.action==NavMeshEvent.SHOW_NAVMESH_TRI_LINE){
						makeStarData()
					}
					if($navMeshEvent.action==NavMeshEvent.SHOW_NAVMESH_START_LINE){
						showNavMeshStartLine()
					}
			}
			this.addEvents()
		}
		//生存A星
		private function makeStarData():void
		{
			if(!_hierarchyFileNode){
				return 
			}
			var $proxyPan3dNavMesh:ProxyPan3dNavMesh	=_hierarchyFileNode.iModel as ProxyPan3dNavMesh
			var $obj:Object=getNavUtils();
			var $jumpVecTri:Vector.<Triangle>=getNavUtils(true).vecTri;
			NavMeshJsModel.getInstance().restAstartData($obj.vecTri,$obj.baseVectItem,$proxyPan3dNavMesh,$jumpVecTri)


			
		}
		//生存三角形
		private function showNavTriLine():void 
		{
			if(!_hierarchyFileNode){
				return 
			}
			var $ProxyPan3dNavMesh:ProxyPan3dNavMesh	=_hierarchyFileNode.iModel as ProxyPan3dNavMesh
			var $obj:Object=getNavUtils();

			$ProxyPan3dNavMesh.navMeshDisplay3DSprite.showNavMeshTriLine($obj.vecTri,$obj.baseVectItem)
			
			
		}
		private function getNavUtils(value:Boolean=false):Object{    //默认为false
			var $ProxyPan3dNavMesh:ProxyPan3dNavMesh	=_hierarchyFileNode.iModel as ProxyPan3dNavMesh
			var listData:Array=$ProxyPan3dNavMesh.navMeshStaticMesh.listData
			var polygonV:Vector.<Polygon> = new Vector.<Polygon>;	
			var $baseVectItem:Vector.<Vector3D>=new Vector.<Vector3D>
			for(var i:int;i<listData.length;i++){
				var  $NavMeshNode:NavMeshNode=listData[i];
				if($NavMeshNode.isJumpRect==value){
					var pointVec:Vector.<NavMeshPosVo> = listData[i].data
					var $arrTrc:Vector.<Vector2f> = new Vector.<Vector2f>();
					
					for(var j:int=0;j<pointVec.length;j++){
						$arrTrc.push(new Vector2f(pointVec[j].x,pointVec[j].z));
						$baseVectItem.push(new Vector3D(pointVec[j].x,pointVec[j].y,pointVec[j].z));
					}
					var poly0:Polygon = new Polygon($arrTrc.length, $arrTrc);
					poly0.cw();
					polygonV.push(poly0);
				}
				
			}
			
			if(polygonV.length){
				var navUtils:NavUtils = new NavUtils;
				var $vecTri:Vector.<Triangle> = navUtils.buildTriangle(polygonV);
				return {vecTri:$vecTri,baseVectItem:$baseVectItem}
			}else{
				return {vecTri:null,baseVectItem:null}
			}
		
		}
        //刷新高度贴合地面高度
		private function showNavMeshStartLine():void
		{
			if(!_hierarchyFileNode){
				return 
			}
			var $proxyPan3dNavMesh:ProxyPan3dNavMesh	=_hierarchyFileNode.iModel as ProxyPan3dNavMesh
			var $obj:Object=getNavUtils();
			NavMeshJsModel.getInstance().setTirItem($obj.vecTri,$proxyPan3dNavMesh)
			NavMeshProcessor._selectMoveSpriteItem=null;
		
	
		}
		private function saveTriItem($item:Vector.<Triangle> ):void
		{
			var $navMeshStaticMesh:NavMeshStaticMesh=_hierarchyFileNode.data as NavMeshStaticMesh
				
			$navMeshStaticMesh.vecTri=new Vector.<Vector3D>;
				
			var h:Number=10;
			for(var i:Number=0;$item&&i<$item.length;i++){
				
				var a:Object=$item[i].pointA;
				var b:Object=$item[i].pointB;
				var c:Object=$item[i].pointC;
				
				if(isClockwise(a,b,c)){
					$navMeshStaticMesh.vecTri.push(new Vector3D(Number(a.x),h,Number(a.y)))
					$navMeshStaticMesh.vecTri.push(new Vector3D(Number(b.x),h,Number(b.y)))
					$navMeshStaticMesh.vecTri.push(new Vector3D(Number(c.x),h,Number(c.y)))
				}else{
					$navMeshStaticMesh.vecTri.push(new Vector3D(Number(a.x),h,Number(a.y)))
					$navMeshStaticMesh.vecTri.push(new Vector3D(Number(c.x),h,Number(c.y)))
					$navMeshStaticMesh.vecTri.push(new Vector3D(Number(b.x),h,Number(b.y)))
				
				}

			}
			
		}
		private function  isClockwise(a:Object,b:Object,c:Object):Boolean
		{
			//		if((x2-x1)*(y3-y1)-(x3-x1)*(y2-y1) < 0)  
			if((b.x-a.x)*(c.y-a.y)-(c.x-a.x)*(b.y-a.y) < 0)  
			{  
				return true 
			}  
			else  
			{  
				return false
			}  
		}
		
		private function selectMove(navMeshNode:NavMeshNode):void
		{
			
				var $itemBox:Vector.<NavMeshBoxDisplay3DSprite>=new Vector.<NavMeshBoxDisplay3DSprite>
				for(var i:Number=0;i<	navMeshNode.data.length;i++){
					$itemBox.push(navMeshNode.data[i])
				}	
				if($itemBox.length){
					xyzPosMoveItem($itemBox)
				}
			
		}		
		
		private static function restNavMeshSpriet():void
		{
			if(!_hierarchyFileNode){
				return 
			}
			
			var df:ProxyPan3dNavMesh	=_hierarchyFileNode.iModel as ProxyPan3dNavMesh
			
			
			df.navMeshDisplay3DSprite.refeshData()
			
		}
		private function addEvents():void
		{
			
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_DOWN,onStageMouseDown)
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp)
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMove)
			Scene_data.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
		
		}
		private var mouseLineSprite:Sprite=new Sprite
		protected function onStageMouseMove(event:MouseEvent):void
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
		private function tatolSelectPoint():void
		{
			if(!_hierarchyFileNode){
				return 
			}
			
			var $rect:Rectangle=getMouseRect()
			$rect.x-=Scene_data.stage3DVO.x
			$rect.y-=Scene_data.stage3DVO.y
			var $mouse2D:Point=new Point(Scene_data.stage3DVO.mouseX,Scene_data.stage3DVO.mouseY)
			var $navMeshStaticMesh:NavMeshStaticMesh=_hierarchyFileNode.data as NavMeshStaticMesh
			var $itemBox:Vector.<NavMeshBoxDisplay3DSprite>=new Vector.<NavMeshBoxDisplay3DSprite>
			for(var i:Number=0;i<$navMeshStaticMesh.listData.length;i++){
				for(var j:Number=0;j<$navMeshStaticMesh.listData[i].data.length;j++){
					
					var dis:NavMeshBoxDisplay3DSprite=NavMeshBoxDisplay3DSprite($navMeshStaticMesh.listData[i].data[j])
					var p:Point=MathCore.mathWorld3DPosto2DView(new Vector3D(dis.x,dis.y,dis.z));
					var dz:Vector3D=Scene_data.cam3D.cameraMatrix.transformVector(new Vector3D(dis.x,dis.y,dis.z))
					dis.colorVec=new Vector3D(1,0,0)
					if(dz.z>1){
						if($rect.containsPoint(p)){
							$itemBox.push(dis)
							dis.colorVec=new Vector3D(0,1,0)
						}
					}

				}
			}
			
			for(var k:Number=0;_selectMoveSpriteItem&&k<_selectMoveSpriteItem.length;k++){
			
				var $needADD:Boolean=true
				for(var v:Number=0;v<$itemBox.length;v++)
				{
					if($itemBox[v]==_selectMoveSpriteItem[k]){
						$needADD=false
					}
				
				}
				if($needADD){
					_selectMoveSpriteItem[k].colorVec=new Vector3D(0,1,0)
					$itemBox.push(_selectMoveSpriteItem[k])
				}
				
			}
			
			if($itemBox.length){
				this.isSelectPoint=true
				xyzPosMoveItem($itemBox)
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
		
		protected function onStageMouseUp(event:MouseEvent):void
		{
			
	
			if(AppData.editMode==EditModeEnum.EDIT_NAVMESH){
				if(this.mouseLineSprite.parent){
					this.mouseLineSprite.graphics.clear()
				}
				
				if(mouseInStage3D){
					if(this.lastMousePos){
						if(!event.shiftKey){
							_selectMoveSpriteItem=null
						}
						this.tatolSelectPoint()
					}else{
					
						if(!event.shiftKey||!event.ctrlKey){
							if(NavMeshProcessor._selectMoveSpriteItem){
								showNavTriLine();
							}
						}
					}
				
						
					
	
				}
			}
			
			this.lastMousePos=null;
		
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			if(AppData.editMode==EditModeEnum.EDIT_NAVMESH&&mouseInStage3D){
				if(event.keyCode==Keyboard.DELETE)
				{

					deleTempPoint()
			
				
				}
				if(event.keyCode==Keyboard.INSERT)
				{
					insetTempPoint()
				}
				
			}
		}
		
		private function insetTempPoint():void
		{
			if(!_hierarchyFileNode){
				return 
			}
			
			if(!_selectMoveSpriteItem){
				return 
			}
			
			
			var $navMeshStaticMesh:NavMeshStaticMesh=_hierarchyFileNode.data as NavMeshStaticMesh
			for(var i:Number=0;i<$navMeshStaticMesh.listData.length;i++){
				for(var j:Number=0;j<$navMeshStaticMesh.listData[i].data.length;j++){
					var dis:NavMeshBoxDisplay3DSprite=NavMeshBoxDisplay3DSprite($navMeshStaticMesh.listData[i].data[j])
					if(dis==_selectMoveSpriteItem[0]){
						
						trace("添加一个");
						
		
						var $addDis:NavMeshBoxDisplay3DSprite
						if(j==($navMeshStaticMesh.listData[i].data.length-1)){
							$addDis=NavMeshBoxDisplay3DSprite($navMeshStaticMesh.listData[i].data[0])

						}else{
							$addDis=NavMeshBoxDisplay3DSprite($navMeshStaticMesh.listData[i].data[j+1])
						}
						var $NavMeshPosVo:NavMeshPosVo=new NavMeshPosVo(Scene_data.context3D);
						$NavMeshPosVo.x=(dis.x+$addDis.x)/2
						$NavMeshPosVo.y=(dis.y+$addDis.y)/2
						$NavMeshPosVo.z=(dis.z+$addDis.z)/2
							
	
						$navMeshStaticMesh.listData[i].data.splice(j+1,0,$NavMeshPosVo)
						restNavMeshSpriet()
						return ;
						
						
						
					}
					
				}
			}
			
		}
		private function deleTempPoint():void
		{
		
			if(!_hierarchyFileNode){
				return 
			}
			
			if(!_selectMoveSpriteItem){
				return 
			}
			
			
			var $navMeshStaticMesh:NavMeshStaticMesh=_hierarchyFileNode.data as NavMeshStaticMesh
			for(var i:Number=0;i<$navMeshStaticMesh.listData.length;i++){
				for(var j:Number=0;j<$navMeshStaticMesh.listData[i].data.length;j++){
					var dis:NavMeshBoxDisplay3DSprite=NavMeshBoxDisplay3DSprite($navMeshStaticMesh.listData[i].data[j])
					if(dis==_selectMoveSpriteItem[0]){
						
						if($navMeshStaticMesh.listData[i].data.length>3){
						
							trace("找到了一个");
							
							$navMeshStaticMesh.listData[i].data.splice(j,1)//删除一个
							xyzPosMoveItem(null)
							restNavMeshSpriet()
							
							return ;
						}

					}
						
				}
			}
		
		}
		private var isSelectPoint:Boolean=false;
		private var lastMousePos:Point
		protected function onStageMouseDown(event:MouseEvent):void
		{

			//trace(MoveScaleRotationLevel.moveSelectId)
			
			if(!_hierarchyFileNode){
				return 
			}
			if(!MoveScaleRotationLevel.getInstance().useIt&&AppData.editMode==EditModeEnum.EDIT_NAVMESH&&mouseInStage3D){
				this.lastMousePos=new Point(Scene_data.stage.mouseX,Scene_data.stage.mouseY)
			}
			
			
		}
		
		private static var _tooXyzMoveData:TooXyzMoveData
		private static var _selectMoveSpriteItem:Vector.<NavMeshBoxDisplay3DSprite>
		public static function xyzPosMoveItem($arr:Vector.<NavMeshBoxDisplay3DSprite>):TooXyzMoveData
		{
			_selectMoveSpriteItem=$arr
			if(_tooXyzMoveData){
				_tooXyzMoveData.dataItem=null
				_tooXyzMoveData.lineBoxItem=null
				_tooXyzMoveData.isCenten=false
				_tooXyzMoveData.modelItem=null
				_tooXyzMoveData.dataChangeFun=null
				_tooXyzMoveData.dataUpDate=null
			}
			_tooXyzMoveData=new TooXyzMoveData
			if($arr){
				
				_tooXyzMoveData.dataItem=new Vector.<TooXyzPosData>;
				_tooXyzMoveData.modelItem=new Array
				for (var i:uint=0;i<$arr.length;i++)
				{
					var k:TooXyzPosData=new TooXyzPosData;
					k.x=$arr[i].x
					k.y=$arr[i].y
					k.z=$arr[i].z
					k.scale_x=1
					k.scale_y=1
					k.scale_z=1
					k.angle_x=0
					k.angle_y=0
					k.angle_z=0
	
					_tooXyzMoveData.dataItem.push(k)
					_tooXyzMoveData.modelItem.push($arr[i])
					
				}
				_tooXyzMoveData.fun=xyzBfun
				MoveScaleRotationLevel.getInstance().xyzMoveData=_tooXyzMoveData
				
				
				
			}else{
				MoveScaleRotationLevel.getInstance().xyzMoveData=null
				
			}
			Scene_data.selectVec=MoveScaleRotationLevel.getInstance().xyzMoveData
			return _tooXyzMoveData
			
		}
		private static function xyzBfun($XyzMoveData:xyz.draw.TooXyzMoveData):void
		{
			for(var i:uint=0;i<$XyzMoveData.modelItem.length;i++){
				var $iModel:NavMeshBoxDisplay3DSprite=NavMeshBoxDisplay3DSprite($XyzMoveData.modelItem[i])
				var $dataPos:TooXyzPosData=$XyzMoveData.dataItem[i]
				
				$iModel.x=$dataPos.x
				$iModel.y=$dataPos.y
				$iModel.z=$dataPos.z
				
				
			}
			
			restNavMeshSpriet()
		
			
		}

		

		
		private function get mouseInStage3D():Boolean
		{
			var $rect:Rectangle=new Rectangle(0,0,Scene_data.stage3DVO.width,Scene_data.stage3DVO.height)
			return $rect.containsPoint(new Point(Scene_data.stage3DVO.mouseX,Scene_data.stage3DVO.mouseY));
		}
		//private static var _navMeshStaticMesh:NavMeshStaticMesh
		private static var _hierarchyFileNode:HierarchyFileNode
		private function selectNode($hierarchyFileNode:HierarchyFileNode):void
		{
		
			_hierarchyFileNode=$hierarchyFileNode
				
				
			
			
	
		}
	}
}