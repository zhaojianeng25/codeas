package _Pan3D.utils.scanhit
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import _Pan3D.base.MeshData;
	import _Pan3D.core.MathClass;
	import _Pan3D.core.MathCore;
	import _Pan3D.display3D.Display3dGameMovie;
	import _Pan3D.program.Program3DManager;
	
	import _me.Scene_data;
	
	public class HitTest
	{
		public function HitTest()
		{
		}
		public static var instance:HitTest;
		public static function getInstance():HitTest{
			if(!instance){
				instance = new HitTest();
				Program3DManager.getInstance().registe(HitTestShader.HIT_TEST_SHADER,HitTestShader)
			}
			return instance;
		}
		private var pointArr:Vector.<Point>
		private var _camDistence:uint=128
		private var _angleY:Number=-30;
		/**
		 * 测试对象是否与点相交 
		 * @param arr 测试对象的数组
		 * @param hitMousePoint 测试点
		 * @return 相交点的ID 如果没有则返回0
		 * 
		 */		
		public function testPoint(arr:Vector.<Display3dGameMovie>,hitMousePoint:Point,secenMousePoint:Point):Display3dGameMovie
		{
			//return null;
			var i:uint;
			for(i=0;i<arr.length;i++)
			{
				var display3dGameMovie:Display3dGameMovie=arr[i];
				var d:Number=MathClass.math_distance(display3dGameMovie.absolute2Dx+50,display3dGameMovie.absolute2Dy-50,secenMousePoint.x/Scene_data.mainRelateScale,secenMousePoint.y/Scene_data.mainRelateScale);
				if(d<300){
					if(display3dGameMovie.testPoint(hitMousePoint)){
						return display3dGameMovie;
					}
				}
			}
			
			return null;
			hitMousePoint.x=(hitMousePoint.x+Scene_data.focus2D.x-Scene_data.cam3D.fovw/2)
			hitMousePoint.y=(hitMousePoint.y-Scene_data.focus2D.z-Scene_data.cam3D.fovh/2)

			var context3D:Context3D=Scene_data.context3D;
			context3D.configureBackBuffer(_camDistence, _camDistence,0, true);
			context3D.clear(1,1,1,1);
			var MS:Matrix3D=new Matrix3D;
			MS.appendScale(1/_camDistence,1/_camDistence,1/1000);
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, MS, true);
			context3D.setProgram(Program3DManager.getInstance().getProgram(HitTestShader.HIT_TEST_SHADER));
			for(i = 0;i<arr.length;i++)
			{
				var display3dGameMovie:Display3dGameMovie=arr[i];
				var d:Number=MathClass.math_distance(display3dGameMovie.absolute2Dx+50,display3dGameMovie.absolute2Dy-50,hitMousePoint.x,hitMousePoint.y);
				display3dGameMovie.colorID = i+1;
				if(d<100){
					scanTemapNpcModel(display3dGameMovie,hitMousePoint);
				}
			}	
			if(!showMc){
				toBmp=new BitmapData(_camDistence,_camDistence);
//				showMc=new Bitmap(toBmp)			
//				showSprite=new Sprite;
//				showSprite.graphics.lineStyle(1,0xff0000,0.5)
//					
//				showSprite.graphics.moveTo(64,0);
//				showSprite.graphics.lineTo(64,128);
//				
//				showSprite.graphics.moveTo(0,64);
//				showSprite.graphics.lineTo(128,64);
//				
//				Scene_data.stage.addChild(showMc);
//				Scene_data.stage.addChild(showSprite);
		
			}
			context3D.drawToBitmapData(toBmp);
			context3D.configureBackBuffer(Scene_data.stageWidth, Scene_data.stageHeight,Scene_data.antiAlias, true);
			var hitId:uint=toBmp.getPixel(int(_camDistence/2),int(_camDistence/2))
		
//			trace("选中对象" +　(hitId) + "," + arr.length)
//			if(hitId == arr.length){
//				trace('133333333333333333333333333333333333333333333')
//			}
				
			if(hitId == 0||hitId>arr.length){
				return null;
			}else{
				return arr[hitId-1];
			}
		}
		private var toBmp:BitmapData;
		private var showMc:Bitmap
		private var showSprite:Sprite
		private function scanTemapNpcModel(npcDisplaySprite:Display3dGameMovie,centenPoint:Point):void
		{
			var context3D:Context3D=Scene_data.context3D;
			var MZ:Matrix3D=new Matrix3D;
			var tox:Number=npcDisplaySprite.absolute2Dx-centenPoint.x;
			var toy:Number=centenPoint.y-npcDisplaySprite.absolute2Dy;
			

			MZ.appendRotation(Scene_data.focus3D.angle_y,new Vector3D(0,1,0));
			MZ.appendRotation(npcDisplaySprite.rotationY,new Vector3D(0,1,0));
			MZ.appendRotation(-30,new Vector3D(1,0,0));
			MZ.appendScale(Scene_data.mainScale/2,Scene_data.mainScale/2,Scene_data.mainScale/2)
			MZ.appendTranslation(tox,toy,_camDistence/2);
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, MZ, true);
			
			
			var colorVector:Vector3D=MathCore.hexToArgb(npcDisplaySprite.colorID,false)
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 4, Vector.<Number>([colorVector.x/255,colorVector.y/255,colorVector.z/255,1]));
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 5, Vector.<Number>([1, 1, 1, 0.8]));
			
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
				if(!npcDisplaySprite.curentAction||! npcDisplaySprite.animDic[npcDisplaySprite.curentAction]){
					return;
				}
				var ary:Array = npcDisplaySprite.animDic[npcDisplaySprite.curentAction][npcDisplaySprite.curentFrame]
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
				Scene_data.drawTriangle += (meshData.faceNum);
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