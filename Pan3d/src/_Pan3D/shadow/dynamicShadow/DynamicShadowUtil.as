package _Pan3D.shadow.dynamicShadow
{
	import _Pan3D.base.Camera3D;
	import _Pan3D.base.Focus3D;
	import _Pan3D.base.MeshData;
	import _Pan3D.core.MathCore;
	import _Pan3D.display3D.Display3dGameMovie;
	import _Pan3D.program.Program3DManager;
	
	import _me.Scene_data;
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	public class DynamicShadowUtil
	{
		public function DynamicShadowUtil()
		{
		}
		public static var instance:DynamicShadowUtil;
		public static function getInstance():DynamicShadowUtil{
			if(!instance){
				instance = new DynamicShadowUtil();
				Program3DManager.getInstance().registe(DynamicShadowUtilShader.DYNAMIC_SHADOW_SHADER,DynamicShadowUtilShader)

			}
			return instance;
		}
		private  function _catch_cam(_Cam:Camera3D, _focus_3d:Focus3D,shake:Vector3D=null):void
		{

			_Cam.angle_x=_focus_3d.angle_x;
			_Cam.angle_y=_focus_3d.angle_y;
			_Cam.cameraMatrix.identity();
			_Cam.cameraMatrix.prependTranslation(0, 0, DynamicShadowUtil.shadowDis);
			_Cam.cameraMatrix.prependRotation(_Cam.angle_x, Vector3D.X_AXIS);
			_Cam.cameraMatrix.prependRotation(_Cam.angle_y, Vector3D.Y_AXIS);
			_Cam.cameraMatrix.prependTranslation(-_focus_3d.x, -_focus_3d.y,-_focus_3d.z);

		}
		public function scanNpcShadow(arr:Vector.<Display3dGameMovie>):void
		{
			var context3D:Context3D=Scene_data.context3D;
			//context3D.setRenderToTexture(Display3DynamicShadow.npcShadowText,true)
			//context3D.clear(0, 0, 0, 0);
			//var focus3D:Focus3D= Scene_data.focus3D.cloneFocus3D()
			//focus3D.angle_y=Scene_data.focus3D.angle_y+shadowAngleY
			//focus3D.angle_x=shadowAnglX
		   // _catch_cam(Scene_data.cam3D,focus3D);
			context3D.setProgram(Program3DManager.getInstance().getProgram(DynamicShadowUtilShader.DYNAMIC_SHADOW_SHADER));
			for(var i:uint=0;i<arr.length;i++)
			{
				if(arr[i].hasShadow){
					scanTemapNpcModel(arr[i],new Point());
				}
			}
			//context3D.setRenderToBackBuffer();
			//shadowCamMatrix=Scene_data.cam3D.cameraMatrix.clone()
			//MathCore._catch_cam(Scene_data.cam3D, Scene_data.focus3D);
		}
		public static var shadowCamMatrix:Matrix3D=new Matrix3D;
		private var _npcShadowTextW:uint=2048
		//颜色
		public static var shadowColor:Vector3D=new Vector3D(0,0,0,0.4);
		//密度
		public static var shadowDis:uint=2000;
		//角度X
		public static var shadowAnglX:Number=-35;
		//角度y
		public static var shadowAngleY:Number=30;

		private function scanTemapNpcModel(npcDisplaySprite:Display3dGameMovie,centenPoint:Point):void
		{
			var cam3D:Camera3D=Scene_data.cam3D
			if(!npcDisplaySprite.animDic[npcDisplaySprite.curentAction] &&　!npcDisplaySprite.animDic["stand"]){
				return;
			}
			var context3D:Context3D=Scene_data.context3D;
			//npcDisplaySprite.updateMatrix();
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, npcDisplaySprite.modelMatrix, true);
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([0,0,0,1]));
			for(var i:int;i<npcDisplaySprite.equipList.length;i++){
				if(!npcDisplaySprite.equipList[i].visible){
					continue;
				}
				setVc(npcDisplaySprite.equipList[i].meshData);
				context3D.setTextureAt(1,npcDisplaySprite.equipList[i].textureVo.texture);
				setVa(npcDisplaySprite.equipList[i].meshData);
			}
			resetVa();
			function setVc(meshData:MeshData):void{
				var ary:Array
				if(!npcDisplaySprite.curentAction||! npcDisplaySprite.animDic[npcDisplaySprite.curentAction]){
					ary = npcDisplaySprite.animDic["stand"][npcDisplaySprite.curentFrame];
				}else{
					ary = npcDisplaySprite.animDic[npcDisplaySprite.curentAction][npcDisplaySprite.curentFrame]
				}
				var boneIDary:Array = meshData.boneNewIDAry;
				for(var i:int = 0;i<boneIDary.length;i++){
					context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 12+i*4,  ary[boneIDary[i]], true);
				}
			}
			function setVa(meshData:MeshData):void{
				context3D.setVertexBufferAt(0,meshData.vertexBuffer1, 0, Context3DVertexBufferFormat.FLOAT_3);
				context3D.setVertexBufferAt(1,meshData.vertexBuffer2, 0, Context3DVertexBufferFormat.FLOAT_3);
				context3D.setVertexBufferAt(2,meshData.vertexBuffer3, 0, Context3DVertexBufferFormat.FLOAT_3);
				context3D.setVertexBufferAt(3,meshData.vertexBuffer4, 0, Context3DVertexBufferFormat.FLOAT_3);
				context3D.setVertexBufferAt(4,meshData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
				context3D.setVertexBufferAt(5,meshData.boneWeightBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
				context3D.setVertexBufferAt(6,meshData.boneIdBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
				context3D.drawTriangles(meshData.indexBuffer, 0, -1);
				Scene_data.drawNum++;
			}
			function resetVa():void{
				context3D.setVertexBufferAt(0,null, 0, Context3DVertexBufferFormat.FLOAT_3);
				context3D.setVertexBufferAt(1,null, 0, Context3DVertexBufferFormat.FLOAT_3);
				context3D.setVertexBufferAt(2,null, 0, Context3DVertexBufferFormat.FLOAT_3);
				context3D.setVertexBufferAt(3,null, 0, Context3DVertexBufferFormat.FLOAT_3);
				context3D.setVertexBufferAt(4,null, 0, Context3DVertexBufferFormat.FLOAT_2);
				context3D.setVertexBufferAt(5,null, 0, Context3DVertexBufferFormat.FLOAT_4);
				context3D.setVertexBufferAt(6,null, 0, Context3DVertexBufferFormat.FLOAT_4);
				context3D.setTextureAt(1,null);
			}
			
		}
	}
}