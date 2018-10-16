package render.grass
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayCollection;
	
	import _Pan3D.base.BaseLevel;
	
	import _me.Scene_data;
	
	import common.AppData;
	import common.vo.editmode.EditModeEnum;
	
	import grass.GrassStaticMesh;
	
	import modules.hierarchy.HierarchyFileNode;
	import modules.hierarchy.HierarchyNodeType;
	import modules.materials.view.MaterialTreeManager;
	import modules.scene.SceneEditModeManager;
	import modules.terrain.TerrainDrawHeightModel;
	
	import proxy.top.grass.IGrass;
	import proxy.top.render.Render;
	
	import render.ground.GroundManager;
	import render.ground.TerrainEditorData;
	
	import terrain.GroundData;

	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class GrassManager extends BaseLevel
	{

		private static var instance:GrassManager;
		public function GrassManager()
		{
            super()
			addEvents();
		}
		public function clear():void
		{
			Render.clearGrassAll()
		}

		public static function getInstance():GrassManager{
			if(!instance){
				instance = new GrassManager();
			}
			return instance;
		}
		override public function upData():void
		{
			changeQuere()
		}
		private function changeQuere():void
		{
//			for each(var $igrass:IGrass in grassItem)
//			{
//				var k:Vector3D=new Vector3D;
//				k.x=Scene_data.cam3D.x
//				k.z=Scene_data.cam3D.z
//				if(Vector3D.distance($igrass.lastQuadPos,k)>100){
//					var hitPos:Vector3D=GroundManager.getInstance().getLookAtGroundCentenPos();
//					if(hitPos){
//						$igrass.listGrassQuad(hitPos)
//					}
//				}
//			}
		
			
		}

		
		public var listArr:ArrayCollection
		public function addGrassModel($id:uint):void
		{
			var $grassMesh:GrassStaticMesh=new GrassStaticMesh

			$grassMesh.materialUrl=AppData.defaultMaterialUrl
			$grassMesh.material=MaterialTreeManager.getMaterial(AppData.workSpaceUrl+$grassMesh.materialUrl);
			
			$grassMesh.density=0
			$grassMesh.bishuaSize=10
			$grassMesh.bishuaMidu=5
			$grassMesh.bishuaScale=1
			$grassMesh.bishuaScalRound=0

			$grassMesh.grassArr=new Array

			for(var i:uint=0;i<0;i++){
				var tempModelVo:Object=new Object
				tempModelVo.x=int(Math.random()*400-200)
				tempModelVo.y=0
				tempModelVo.z=int(Math.random()*400-200)
				tempModelVo.scaleH=2
				tempModelVo.rotationY=0
				$grassMesh.grassArr.push(tempModelVo)
			}
			//var $igrass:IGrass=Render.creaGrass(AppData.workSpaceUrl+"img/moba/Grass1.png",$grassMesh.grassArr,10,10)
			var $igrass:IGrass=Render.creatGrassModel($grassMesh)
			var $hierarchyFileNode:HierarchyFileNode=new HierarchyFileNode;	
			$hierarchyFileNode.id=$id
			$hierarchyFileNode.iModel=$igrass
			$hierarchyFileNode.name="草"
			$hierarchyFileNode.type=HierarchyNodeType.Grass
			$hierarchyFileNode.data=$grassMesh;
			listArr.addItem($hierarchyFileNode)
			$grassMesh.addEventListener(Event.CHANGE,onMeshChange)

		}
		protected function onMeshChange(event:Event):void
		{
			var $grassMesh:GrassStaticMesh=GrassStaticMesh(event.target)
			TerrainDrawHeightModel.brushSize=$grassMesh.bishuaSize;
			GroundManager.getInstance().changeBrushData()
			
		}
		public  function objToGrassMesh($obj:Object):GrassStaticMesh
		{
			var $grassMesh:GrassStaticMesh = new GrassStaticMesh();
			for(var i:String in $obj) {
				$grassMesh[i]=$obj[i]
			}
			if($grassMesh.materialUrl){
				$grassMesh.material = MaterialTreeManager.getMaterial(AppData.workSpaceUrl+$grassMesh.materialUrl);
			}
			$grassMesh.addEventListener(Event.CHANGE,onMeshChange)
			return $grassMesh
		}
		private var _selectGrassNode:HierarchyFileNode
		private var _isMouseDown:Boolean;
		public function setSelectGrassFileNode($hierarchyFileNode:HierarchyFileNode):void
		{
			_selectGrassNode=$hierarchyFileNode
		}
		
		
		private function addEvents():void
		{
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown)
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove)
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp)
			Scene_data.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown)
			Scene_data.stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,onStageRightDown)
			Scene_data.stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP,onStageRightUp)
			
		}
		private var _mouseRightDown:Boolean=false
		protected function onStageRightUp(event:MouseEvent):void
		{
			_mouseRightDown=false
			
		}
		
		protected function onStageRightDown(event:MouseEvent):void
		{
			_mouseRightDown=true
			
		}
		private var _isDrawGrassReady:Boolean=true;
		protected function onKeyDown(event:KeyboardEvent):void
		{
			if(!_mouseRightDown&&_selectGrassNode){
				if(event.keyCode==Keyboard.Q||event.keyCode==27){
					_selectGrassNode=null
					SceneEditModeManager.changeMode(EditModeEnum.EDIT_WORLD)
					GroundData.showShaderHitPos=false
				}
			}
			
		}
		private function drawGrass():void
		{
			var hitPos:Vector3D=GroundManager.getInstance().getMouseHitGroundWorldPos();
			
			if(_isDrawGrassReady&&hitPos){
				
				var grassStaticMesh:GrassStaticMesh=GrassStaticMesh(_selectGrassNode.data)
	
					var $pos:Vector3D=new Vector3D()
					var $sizeRound:Number=TerrainDrawHeightModel.brushSize*GroundData.cellScale/2
					var $arr:Array=[];
					for(var i:uint=0;i<grassStaticMesh.bishuaMidu;i++){
						
						$pos.x=Math.random()*$sizeRound
						$pos.z=0
						var $m:Matrix3D=new Matrix3D;
						$m.appendRotation(Math.random()*360,Vector3D.Y_AXIS)
						$pos=$m.transformVector($pos)	
						$pos.x+=hitPos.x
						$pos.z+=hitPos.z
						var tempModelVo:Object=new Object
						tempModelVo.x=$pos.x
						tempModelVo.y=TerrainEditorData.getTerrainHeight($pos.x,$pos.z)
						tempModelVo.z=$pos.z
						tempModelVo.scaleH=grassStaticMesh.bishuaScale+(grassStaticMesh.bishuaScalRound*grassStaticMesh.bishuaScale*(Math.random()>0.5?+1:-1))
						tempModelVo.rotationY=0
						
						if(inScene($pos)){
							$arr.push(tempModelVo)
						}
					}
					grassStaticMesh.grassArr=grassStaticMesh.grassArr.concat($arr);
					var $temp:IGrass=_selectGrassNode.iModel as IGrass
					if($temp){
						$temp.addGrassArr($arr)
					}
					
				
			}
			function inScene($p:Vector3D):Boolean
			{
				var tw:Number=GroundData.cellNumX*GroundData.cellScale*GroundData.terrainMidu*4
				var th:Number=GroundData.cellNumZ*GroundData.cellScale*GroundData.terrainMidu*4
				if(Math.abs($p.x)>tw/2||Math.abs($p.z)>th/2){
					return false
				}else{
					return true
				}
			}
			
		}
		private function isCanEditGrass():Boolean
		{
			if(AppData.editMode==EditModeEnum.EDIT_GRASS&&_selectGrassNode){
				return true
			}else{
				return false
			}
			
		}
		private function get mouseInStage3D():Boolean
		{
			var $rect:Rectangle=new Rectangle(0,0,Scene_data.stage3DVO.width,Scene_data.stage3DVO.height)
			return $rect.containsPoint(new Point(Scene_data.stage3DVO.mouseX,Scene_data.stage3DVO.mouseY));
		}
		protected function onMouseUp(event:MouseEvent):void
		{
			if(_isMouseDown&&_isDrawGrassReady&&!event.shiftKey&&isCanEditGrass()){
		
				
				var grassStaticMesh:GrassStaticMesh=GrassStaticMesh(_selectGrassNode.data)
		
				var $tempGrassSprite:IGrass=_selectGrassNode.iModel as IGrass
				if($tempGrassSprite){
					$tempGrassSprite.setGrassInfoItem(grassStaticMesh.grassArr)
				}
				
			}
			_isMouseDown=false
			
		}
		
		protected function onMouseMove(event:MouseEvent):void
		{
			if(_isMouseDown&&_isDrawGrassReady&&!event.shiftKey&&event.ctrlKey==false&&isCanEditGrass()){
				drawGrass()
			}
			
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			if(mouseInStage3D&&isCanEditGrass()&&event.ctrlKey==false){
				_isMouseDown=true;
				if(_isMouseDown&&_isDrawGrassReady&&!event.shiftKey){
					drawGrass()
				}
				if(event.shiftKey&&_isDrawGrassReady){
					clearGrass()
				}
				
			}
			
		}
		private function clearGrass():void
		{
			
			var hitPos:Vector3D=GroundManager.getInstance().getMouseHitGroundWorldPos();
			if(hitPos){
				var $sizeRound:Number=TerrainDrawHeightModel.brushSize*GroundData.cellScale/2
			
				var grassStaticMesh:GrassStaticMesh=GrassStaticMesh(_selectGrassNode.data)
				
					var $tempArr:Array=[]
					for(var j:uint=0;j<grassStaticMesh.grassArr.length;j++)
					{
						var $grassObj:Object=grassStaticMesh.grassArr[j];
						var $pos:Vector3D=new Vector3D($grassObj.x,$grassObj.y,$grassObj.z);
						if(Vector3D.distance(hitPos,$pos)>$sizeRound){
							$tempArr.push($grassObj)
						}
					}
					
					if(grassStaticMesh.grassArr.length!=$tempArr.length){
						grassStaticMesh.grassArr=$tempArr
						var $temp:IGrass=_selectGrassNode.iModel as IGrass
						if($temp){
							$temp.setGrassInfoItem(grassStaticMesh.grassArr)
						}
				
				}
	
			}

		}



	}
}