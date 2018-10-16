package modules.collision
{
	import com.adobe.utils.PerspectiveMatrix3D;
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTriangleFace;
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import _Pan3D.base.CollisionVo;
	import _Pan3D.base.MakeModelData;
	import _Pan3D.base.ObjData;
	import _Pan3D.display3D.Display3DSprite;
	
	import _me.Scene_data;
	
	import collision.CollisionMesh;
	import collision.CollisionType;
	
	import common.AppData;
	import common.utils.ui.collision.CollisionNode;
	import common.vo.editmode.EditModeEnum;
	
	import xyz.MoveScaleRotationLevel;
	import xyz.base.TooXyzPosData;
	import xyz.draw.TooXyzMoveData;
	

	public class CollisionLevel
	{
		private static var instance:CollisionLevel;
		private var _collisionMesh:CollisionMesh;
		private var _collisionGridLine:CollisionGridLine;
		private var _display3DMaterialSprite:CollisionObjsDisplay3DSprite
	
		public function CollisionLevel()
		{
			Scene_data.stage.addEventListener(Event.ENTER_FRAME,update);
		}

		public function get selectCollisionNode():CollisionNode
		{
			return _selectCollisionNode;
		}
		public function resetData():void
		{
			collisionMesh=_collisionMesh;
		}

		public function set selectCollisionNode(value:CollisionNode):void
		{
			_selectCollisionNode = value;
			
			
			for(var i:uint=0;_modelItem&&i<_modelItem.length;i++)
			{
				var sp:CollisionDisplay3DSprite=CollisionDisplay3DSprite(_modelItem[i])
				if(sp.collisionVo==_selectCollisionNode.collisionVo){
					var _tooXyzMoveData:TooXyzMoveData=new TooXyzMoveData
					_tooXyzMoveData.dataItem=new Vector.<TooXyzPosData>;
					_tooXyzMoveData.modelItem=new Array
					var $tooXyzPosData:TooXyzPosData=new TooXyzPosData;
					$tooXyzPosData.x=sp.x
					$tooXyzPosData.y=sp.y
					$tooXyzPosData.z=sp.z
					$tooXyzPosData.scale_x=sp.scale_x
					$tooXyzPosData.scale_y=sp.scale_y
					$tooXyzPosData.scale_z=sp.scale_z
					$tooXyzPosData.angle_x=sp.rotationX
					$tooXyzPosData.angle_y=sp.rotationY
					$tooXyzPosData.angle_z=sp.rotationZ
					_tooXyzMoveData.dataItem.push($tooXyzPosData)
					_tooXyzMoveData.modelItem.push(sp)
					_tooXyzMoveData.fun=xyzBfun
					MoveScaleRotationLevel.getInstance().xyzMoveData=_tooXyzMoveData
						
						
					Scene_data.selectVec=new Vector3D($tooXyzPosData.x,$tooXyzPosData.y,$tooXyzPosData.z)
				}
			}
		
		}

		public function get collisionMesh():CollisionMesh
		{
			return _collisionMesh;
		}

		public function set collisionMesh(value:CollisionMesh):void
		{
			_selectCollisionNode=null;
			_collisionMesh = value;
			_collisionMesh.addEventListener(Event.CHANGE,onCollisionMeshChange)
			onCollisionMeshChange();
		}
		private var _modelItem:Vector.<Display3DSprite>;
		protected function onCollisionMeshChange(event:Event=null):void
		{
			trace("levelChange")
			
			
			_display3DMaterialSprite=new CollisionObjsDisplay3DSprite(Scene_data.context3D);
			_display3DMaterialSprite.url=_collisionMesh.url;
	
			
			_modelItem=new Vector.<Display3DSprite>;
			
			
			
			for(var i:uint=0;i<_collisionMesh.item.length;i++){
				var $CollisionVo:CollisionVo=CollisionVo(_collisionMesh.item[i]);
			
				var ballSprite:CollisionDisplay3DSprite=new CollisionDisplay3DSprite(Scene_data.context3D)
				ballSprite.collisionVo=$CollisionVo;
				ballSprite.objData=new ObjData

				_modelItem.push(ballSprite)
					
				switch($CollisionVo.type)
				{
					case CollisionType.Polygon:
					{
						if($CollisionVo.data){
							ballSprite.objData.vertices=$CollisionVo.data.vertices
							ballSprite.objData.indexs=$CollisionVo.data.indexs
						}
						break;
					}
					case CollisionType.BOX:
					{
						ballSprite.objData=MakeModelData.getCollisionBoxObjData();
						break;
					}
					case CollisionType.BALL:
					{
						ballSprite.objData=MakeModelData.getCollisionBallOjbData();
						break;
					}
					case CollisionType.Cylinder:
					{
						ballSprite.objData=MakeModelData.getCollisionCylinderObjData();
		
						break;
					}
					case CollisionType.Cone:
					{
						ballSprite.objData=MakeModelData.getCollisionConeObjData();
		
						break;
					}
						
					default:
					{
						break;
					}
				}
	
			
				ballSprite.resetUplodToGpu();
				
			}
			changeCollisionPostion();

		}
	
		private var _selectCollisionNode:CollisionNode;
	
		public function changeCollisionPostion():void
		{
			for(var i:uint=0;_modelItem&&i<_modelItem.length;i++)
			{
				var sp:CollisionDisplay3DSprite=CollisionDisplay3DSprite(_modelItem[i])
				sp.x=sp.collisionVo.x;
				sp.y=sp.collisionVo.y;
				sp.z=sp.collisionVo.z;
				sp.rotationX=sp.collisionVo.rotationX;
				sp.rotationY=sp.collisionVo.rotationY;
				sp.rotationZ=sp.collisionVo.rotationZ;
				
				if(sp.collisionVo.type==CollisionType.Polygon || sp.collisionVo.type==CollisionType.BOX){
					sp.scale_x=Boolean(sp.collisionVo.scale_x)?sp.collisionVo.scale_x:0.01;
					sp.scale_y=Boolean(sp.collisionVo.scale_y)?sp.collisionVo.scale_y:0.01;
					sp.scale_z=Boolean(sp.collisionVo.scale_z)?sp.collisionVo.scale_z:0.01;
				}
	
				if(sp.collisionVo.type==CollisionType.BALL){
					sp.scale_x=sp.scale_y=sp.scale_z=Boolean(sp.collisionVo.radius)?sp.collisionVo.radius/100:0.01;

				}
				if(sp.collisionVo.type==CollisionType.Cylinder||sp.collisionVo.type==CollisionType.Cone){
					sp.scale_x=Boolean(sp.collisionVo.scale_x)?sp.collisionVo.scale_x:0.01;
					sp.scale_z=sp.scale_x
					sp.scale_y=Boolean(sp.collisionVo.scale_y)?sp.collisionVo.scale_y:0.01;
				
				}
		
				
			
			}
			
		
			if(_selectCollisionNode){
				selectCollisionNode=_selectCollisionNode
			}
		}
		private  function xyzBfun($XyzMoveData:xyz.draw.TooXyzMoveData):void
		{
			for(var i:uint=0;i<$XyzMoveData.modelItem.length;i++){
				var $sp:CollisionDisplay3DSprite=CollisionDisplay3DSprite($XyzMoveData.modelItem[i])
				var $dataPos:TooXyzPosData=$XyzMoveData.dataItem[i]
				
				$sp.x=$dataPos.x
				$sp.y=$dataPos.y
				$sp.z=$dataPos.z
				
				$sp.rotationX=$dataPos.angle_x
				$sp.rotationY=$dataPos.angle_y
				$sp.rotationZ=$dataPos.angle_z
				
				$sp.scale_x=$dataPos.scale_x
				$sp.scale_y=$dataPos.scale_y
				$sp.scale_z=$dataPos.scale_z
					
				$sp.collisionVo.x=$sp.x
				$sp.collisionVo.y=$sp.y
				$sp.collisionVo.z=$sp.z
					
				$sp.collisionVo.rotationX=$sp.rotationX
				$sp.collisionVo.rotationY=$sp.rotationY
				$sp.collisionVo.rotationZ=$sp.rotationZ
					
				if($sp.collisionVo.type==CollisionType.BOX){
					$sp.collisionVo.scale_x=$sp.scale_x
					$sp.collisionVo.scale_y=$sp.scale_y
					$sp.collisionVo.scale_z=$sp.scale_z
			
				}
				if($sp.collisionVo.type==CollisionType.Polygon){
					$sp.collisionVo.scale_x=$sp.scale_x
					$sp.collisionVo.scale_y=$sp.scale_y
					$sp.collisionVo.scale_z=$sp.scale_z
				}
				if($sp.collisionVo.type==CollisionType.Cylinder){
					
					$sp.scale_x=($sp.scale_x+$sp.scale_z)/2
					$sp.scale_z=$sp.scale_x
					
					$sp.collisionVo.scale_x=$sp.scale_x
					$sp.collisionVo.scale_y=$sp.scale_y
					$sp.collisionVo.scale_z=$sp.scale_z
				}
				if($sp.collisionVo.type==CollisionType.BALL){
					$sp.scale_x=($sp.scale_x+$sp.scale_y+$sp.scale_z)/3
					$sp.scale_y=$sp.scale_x
					$sp.scale_z=$sp.scale_x
						
					$sp.collisionVo.scale_x=$sp.scale_x
					$sp.collisionVo.scale_y=$sp.scale_y
					$sp.collisionVo.scale_z=$sp.scale_z
					$sp.collisionVo.radius=$sp.collisionVo.scale_x*100;
						
					
				}
				if($sp.collisionVo.type==CollisionType.Cone){
					
					$sp.scale_x=($sp.scale_x+$sp.scale_z)/2
					$sp.scale_z=$sp.scale_x
					
					$sp.collisionVo.scale_x=$sp.scale_x
					$sp.collisionVo.scale_y=$sp.scale_y
					$sp.collisionVo.scale_z=$sp.scale_z
				}
					
		
					
				
			}
			if(_selectCollisionNode){
				_selectCollisionNode.dispatchEvent(new Event(Event.CHANGE))
			}
		}

		public static function getInstance():CollisionLevel{
			if(!instance){
				instance = new CollisionLevel();
			}
			return instance;
		}

		protected function update(event:Event):void
		{
			if(_collisionMesh&&AppData.editMode == EditModeEnum.EDIT_COLLISION){
				
				if(!_collisionGridLine){
				
					_collisionGridLine=new CollisionGridLine(Scene_data.context3D)
				}
				resetVa()
				var $context3D:Context3D=Scene_data.context3D
				$context3D.clear(50/255,50/255,50/255,1)
				var $viewMatrx3D:PerspectiveMatrix3D=new PerspectiveMatrix3D();
				$viewMatrx3D.perspectiveFieldOfViewLH(1,1,1, 5000);
				Scene_data.viewMatrx3D=$viewMatrx3D
				$context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, Scene_data.viewMatrx3D, true);
				$context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, Scene_data.cam3D.cameraMatrix, true);
				
				$context3D.setDepthTest(true,Context3DCompareMode.LESS);
				$context3D.setCulling(Context3DTriangleFace.NONE);
				$context3D.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ZERO);
				

				_collisionGridLine.update();
				if(_display3DMaterialSprite){
					_display3DMaterialSprite.update();
				}

				for(var i:uint=0;_modelItem&&i<_modelItem.length;i++)
				{
					_modelItem[i].update();
				}
				$context3D.setDepthTest(true,Context3DCompareMode.LESS);
				$context3D.setCulling(Context3DTriangleFace.NONE);
				$context3D.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ZERO);
				MoveScaleRotationLevel.getInstance().upData();
				$context3D.present();
			}
			
			
		}
		
		protected function resetVa() : void {
			var _context3D:Context3D=Scene_data.context3D
			_context3D.setVertexBufferAt(0, null);
			_context3D.setVertexBufferAt(1, null);
			_context3D.setVertexBufferAt(2, null);
			_context3D.setVertexBufferAt(3, null);
			_context3D.setVertexBufferAt(4, null);
			_context3D.setVertexBufferAt(5, null);
			_context3D.setVertexBufferAt(6, null);
			
			_context3D.setTextureAt(0,null)
			_context3D.setTextureAt(1,null)
			_context3D.setTextureAt(2,null)
			_context3D.setTextureAt(3,null)
			_context3D.setTextureAt(4,null)
			_context3D.setTextureAt(5,null)
			_context3D.setTextureAt(6,null)
			
		}

	}
}