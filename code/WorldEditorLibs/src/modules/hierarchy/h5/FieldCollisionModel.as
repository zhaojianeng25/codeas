package modules.hierarchy.h5
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.Program3D;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import _Pan3D.base.CollisionVo;
	import _Pan3D.base.ObjData;
	import _Pan3D.core.MathCore;
	import _Pan3D.display3D.collision.Display3DCollisionSprite;
	import _Pan3D.display3D.ground.GroundEditorSprite;
	import _Pan3D.display3D.model.Display3DModelSprite;
	import _Pan3D.program.Program3DManager;
	import _Pan3D.scene.SceneContext;
	
	import _me.Scene_data;
	
	import common.utils.ui.file.FileNode;
	
	import terrain.GroundData;

	public class FieldCollisionModel
	{
		private static var instance:FieldCollisionModel;
		private var _fileNodeItem:Vector.<FileNode>;
		public function FieldCollisionModel()
		{
			
			Program3DManager.getInstance().registe(FieldCollisionShader.FIELDCOLLISIONSHADER,FieldCollisionShader)
			program=Program3DManager.getInstance().getProgram(FieldCollisionShader.FIELDCOLLISIONSHADER)
		}
		public static function getInstance():FieldCollisionModel{
			if(!instance){
				instance = new FieldCollisionModel();
			}
			return instance;
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
		public  static  var  ShowMc:*
		private var $rec:Rectangle=new Rectangle(0,0,50,50)
		private var program:Program3D;
		public function setHierarchy($arr:Vector.<FileNode>):void
		{
			sceneCollisionItem=new Vector.<H5CollistionVo>
		
			resetVa()
			var _bmp:BitmapData=new BitmapData($rec.width,$rec.height,true,0);
			var _context3D:Context3D=Scene_data.context3D

			
			var mview:Matrix3D=new Matrix3D();
			var sizeNum:Number=	getSceneWH();  //500
			var dephtNum:Number=1000
				
			_context3D.configureBackBuffer(_bmp.width,_bmp.height,16, true);
			_context3D.clear((dephtNum/2%255)/255,(dephtNum/2/255)/255,0,1);
			_context3D.setCulling(Context3DTriangleFace.NONE);
			_context3D.setDepthTest(true,Context3DCompareMode.LESS);
			_context3D.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ZERO);
				
			mview.appendScale(1/sizeNum,1/sizeNum,1/dephtNum)
			var camM:Matrix3D=new Matrix3D;
			camM.appendRotation(-90,Vector3D.X_AXIS)
			camM.appendTranslation(0,0,dephtNum/2)
		
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, mview, true);
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, camM, true);
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([255,255,255,1])); //颜色
			_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([1,0,0,1])); //颜色
			
				
			for each(var $modelSprite:Display3DModelSprite in SceneContext.sceneRender.modelLevel.modelItem)
			{
				tatolCollision($modelSprite)
				if($modelSprite.objData&&$modelSprite.objData.isField&&$modelSprite.display3DCollistionGrop)
				{
					
					_context3D.setProgram(program);
					for each(var $display3DCollisionSprite:Display3DCollisionSprite in 	$modelSprite.display3DCollistionGrop.item ){
					     //var $objData:ObjData=$display3DCollisionSprite.objData;
						 _context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, $display3DCollisionSprite.modelMatrix, true);
						 _context3D.setVertexBufferAt(0, $display3DCollisionSprite.objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
						 _context3D.drawTriangles($display3DCollisionSprite.objData.indexBuffer, 0, -1);
					}
				}
			}
			
			if(GroundData.showTerrain){   //计算地面的点
				for each(var $groundEditorSprite:GroundEditorSprite in SceneContext.sceneRender.groundlevel.groundItem)
				{
					_context3D.setProgram(program);
					_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, $groundEditorSprite.posMatrix, true);
					_context3D.setVertexBufferAt(0, $groundEditorSprite.baseGroundObjData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
					_context3D.drawTriangles($groundEditorSprite.baseGroundObjData.indexBuffer, 0, -1);
					
				}
			}
			
			
			
			
			resetVa()
			_context3D.drawToBitmapData(_bmp)
			_context3D.configureBackBuffer(Scene_data.stage3DVO.width, Scene_data.stage3DVO.height,0, true);
			//FieldCollisionModel.ShowMc.setBitMapData(_bmp);
			var $hightArr:Array=[];
			for(var i:uint=0;i<_bmp.width;i++){
				$hightArr[i]=[]
				for(var j:uint=0;j<_bmp.height;j++){
					var $colorV:Vector3D=MathCore.hexToArgb(_bmp.getPixel32(i,_bmp.height-j-1))
					var h:Number=$colorV.x+$colorV.y*0xff
					$hightArr[i].push((dephtNum/2)-h);
				}
				
			}
			fieldVo=new Object;
			fieldVo.data=$hightArr;
			fieldVo.sizeNum=sizeNum;
			fieldVo.sizeX=sizeNum
			fieldVo.sizeY=sizeNum
		
		    

		}
		public var fieldVo:Object;
		public var sceneCollisionItem:Vector.<H5CollistionVo>;
		public function getsceneCollisionItemObject():Array{
			var $arr:Array=new Array();
			for(var i:Number=0;i<sceneCollisionItem.length;i++){
				var  $obj:Object=new Object;
				$obj.x=sceneCollisionItem[i].x;
				$obj.y=sceneCollisionItem[i].y;
				$obj.z=sceneCollisionItem[i].z;
				$obj.uid=sceneCollisionItem[i].uid;

				var collisionVo:CollisionVo=	sceneCollisionItem[i].collisionVo;
				var  $vobj:Object=new Object;
				$vobj.scale_x=collisionVo.scale_x
				$vobj.scale_y=collisionVo.scale_y;
				$vobj.scale_z=collisionVo.scale_z;
				$vobj.x=collisionVo.x;
				$vobj.y=collisionVo.y;
				$vobj.z=collisionVo.z;
				$vobj.rotationX=collisionVo.rotationX;
				$vobj.rotationY=collisionVo.rotationY;
				$vobj.rotationZ=collisionVo.rotationZ;
				$vobj.type=collisionVo.type;
				$vobj.radius=collisionVo.radius;
				$vobj.data=collisionVo.data;
				$vobj.colorInt=collisionVo.colorInt;
				
				$obj.collisionVo=$vobj;
				$arr.push($obj);
			}
		
			return $arr
		}
		private function tatolCollision($spriet:Display3DModelSprite):void
		{
			if(!$spriet.objData){
				return ;
			}
			if($spriet.objData.isField){
				return ;
			}
			
			if($spriet.objData.collisionItem){
				for each(var vo:CollisionVo in $spriet.objData.collisionItem){
					var $h5CollistionVo:H5CollistionVo=new H5CollistionVo;
					$h5CollistionVo.x=$spriet.x;
					$h5CollistionVo.y=$spriet.y;
					$h5CollistionVo.z=$spriet.z;
					$h5CollistionVo.rotationX=$spriet.rotationX;
					$h5CollistionVo.rotationY=$spriet.rotationY;
					$h5CollistionVo.rotationZ=$spriet.rotationZ;
					$h5CollistionVo.scale_x=$spriet.scale_x;
					$h5CollistionVo.scale_y=$spriet.scale_y;
					$h5CollistionVo.scale_z=$spriet.scale_z;
					$h5CollistionVo.collisionVo=vo;
					$h5CollistionVo.friction=$spriet.objData.friction;
					$h5CollistionVo.restitution=$spriet.objData.restitution;
					$h5CollistionVo.data=vo.data
					$h5CollistionVo.uid=$spriet.uid
					sceneCollisionItem.push($h5CollistionVo);
				}
			}
			
			
		}
		private function getSceneWH():Number
		{
			var minVec3d:Vector3D=new Vector3D;
			var maxVec3d:Vector3D=new Vector3D;
			var $objData:ObjData;
			for each(var $modelSprite:Display3DModelSprite in SceneContext.sceneRender.modelLevel.modelItem)
			{
				if($modelSprite.display3DCollistionGrop)
				{
		
					for each(var $display3DCollisionSprite:Display3DCollisionSprite in 	$modelSprite.display3DCollistionGrop.item ){
					
						mathMinAndMax($display3DCollisionSprite.objData,$display3DCollisionSprite.modelMatrix,minVec3d,maxVec3d)
						
					}
				}
			}
			if(GroundData.showTerrain){   //计算地面的点
				for each(var $groundEditorSprite:GroundEditorSprite in SceneContext.sceneRender.groundlevel.groundItem)
				{
					mathMinAndMax($groundEditorSprite.baseGroundObjData,$groundEditorSprite.posMatrix,minVec3d,maxVec3d)
					
				
				}
				
			}
			
			
			if(Math.abs(minVec3d.x-maxVec3d.x)==0||Math.abs(minVec3d.z-maxVec3d.z)==0){
				return 1000; //没用显示对象时
			}
			var $w:Number=Math.max(Math.abs(minVec3d.x),Math.abs(maxVec3d.x))
			var $h:Number=Math.max(Math.abs(minVec3d.z),Math.abs(maxVec3d.z))
			
			return Math.max($w,$h);
			
		}
		private function mathMinAndMax($objData:ObjData,$posMatrix:Matrix3D,minVec3d:Vector3D,maxVec3d:Vector3D):void
		{
			
			for(var i:uint=0;i<$objData.vertices.length/3;i++){
				var $p:Vector3D=new Vector3D()
				$p.x=$objData.vertices[i*3+0]
				$p.y=$objData.vertices[i*3+1]
				$p.z=$objData.vertices[i*3+2]
				$p=$posMatrix.transformVector($p);
				if(!minVec3d||!maxVec3d){
					minVec3d=$p.clone()
					maxVec3d=$p.clone()
				}else{
					if($p.x<minVec3d.x){
						minVec3d.x=$p.x
					}
					if($p.x>maxVec3d.x){
						maxVec3d.x=$p.x
					}
					
					if($p.y<minVec3d.y){
						minVec3d.y=$p.y
					}
					if($p.y>maxVec3d.y){
						maxVec3d.y=$p.y
					}
					
					if($p.z<minVec3d.z){
						minVec3d.z=$p.z
					}
					if($p.z>maxVec3d.z){
						maxVec3d.z=$p.z
					}
					
				}
			}
		
		}
		
	}
}
import _Pan3D.base.CollisionVo;
import _Pan3D.display3D.Display3D;

class H5CollistionVo extends Display3D
{
    public var collisionVo:CollisionVo;
	public var friction:Number;
	public var restitution:Number;
	public var data:Object
	public var uid:String
}

