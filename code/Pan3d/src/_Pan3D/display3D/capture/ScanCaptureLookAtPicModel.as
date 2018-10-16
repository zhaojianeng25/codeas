package _Pan3D.display3D.capture
{
	import com.adobe.utils.PerspectiveMatrix3D;
	
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTriangleFace;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import _Pan3D.scene.SceneContext;
	
	import _me.Scene_data;

	public class ScanCaptureLookAtPicModel
	{
		private static var instance:ScanCaptureLookAtPicModel;
		public static var ShowMc:*
		public function ScanCaptureLookAtPicModel()
		{
		}
		public static function getInstance():ScanCaptureLookAtPicModel{
			if(!instance){
				instance = new ScanCaptureLookAtPicModel();
			}
			return instance;
		}
		private var _currentPatch:Vector3D
		public  function scanLookAtBmp($pos:Vector3D,$rect:Rectangle,$textureSize:Number):BitmapData
		{

			_currentPatch=new Vector3D($pos.x,$pos.y,$pos.z)

			var $context3D:Context3D=Scene_data.context3D
			$context3D.configureBackBuffer($rect.width, $rect.height,0, true);
			var $viewMatrx3D:PerspectiveMatrix3D=new PerspectiveMatrix3D();
			$viewMatrx3D.perspectiveFieldOfViewLH(90 * Math.PI / 180,1,0.1, 6000);
			$context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, $viewMatrx3D, true);
			
			$context3D.setDepthTest(true,Context3DCompareMode.LESS);
			$context3D.setCulling(Context3DTriangleFace.NONE);
	
			var $bigBmp0:BitmapData=scanTempFace(setCaramRotation(0,Vector3D.X_AXIS),$rect)  //正前
			var $bigBmp1:BitmapData=scanTempFace(setCaramRotation(90,Vector3D.X_AXIS),$rect)  //上
			var $bigBmp2:BitmapData=scanTempFace(setCaramRotation(-90,Vector3D.X_AXIS),$rect)  //下
			var $bigBmp3:BitmapData=scanTempFace(setCaramRotation(90,Vector3D.Y_AXIS),$rect)  //左
			var $bigBmp4:BitmapData=scanTempFace(setCaramRotation(-90,Vector3D.Y_AXIS),$rect)  //右
			var $bigBmp5:BitmapData=scanTempFace(setCaramRotation(-180,Vector3D.Y_AXIS),$rect)  //后
				
	
			var $bigBmp:BitmapData=new BitmapData($rect.width*4,$rect.height*3,false)
			var $toBmp:BitmapData=new BitmapData($rect.height*3,$rect.width*4,false) 
			var $m:Matrix=new Matrix
				
			var numb128:uint=$rect.width	
			$m.identity()
			$m.tx=numb128*1
			$m.ty=numb128*1
			$bigBmp.draw($bigBmp0,$m)

				
			$m.identity()
			$m.tx=numb128*1
			$m.ty=numb128*0
			$bigBmp.draw($bigBmp1,$m)

				
			$m.identity()
			$m.tx=numb128*1
			$m.ty=numb128*2
			$bigBmp.draw($bigBmp2,$m)

				
			$m.identity()
			$m.tx=numb128*0
			$m.ty=numb128*1
			$bigBmp.draw($bigBmp3,$m)

				
			$m.identity()
			$m.tx=numb128*2
			$m.ty=numb128*1
			$bigBmp.draw($bigBmp4,$m)

				
			$m.identity()
			$m.tx=numb128*3
			$m.ty=numb128*1
			$bigBmp.draw($bigBmp5,$m)
			$context3D.configureBackBuffer(Scene_data.stage3DVO.width, Scene_data.stage3DVO.height,0, true);
			
			$m.identity()
		
			$m.rotate(90/180*Math.PI)
			$m.tx=$rect.height*3
			$toBmp.draw($bigBmp,$m)
			
			
			if(ShowMc){
			//	ShowMc.setBitMapData($toBmp)
			}
			return $toBmp
		}
		private function scanTempFace(cameraMatrix:Matrix3D,$rect:Rectangle):BitmapData
		{
			var $bmp:BitmapData=new BitmapData($rect.width,$rect.height,false,0x000000)
			var $context3D:Context3D=Scene_data.context3D
			$context3D.clear(1,1,1,1)
			$context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, cameraMatrix, true);

			SceneContext.sceneRender.skyLevel.updata();
			SceneContext.sceneRender.groundlevel.updata();
			SceneContext.sceneRender.modelLevel.updata();

				
			$context3D.drawToBitmapData($bmp)
				
			return $bmp
			
		}
		public function setCaramRotation(num:Number,axis:Vector3D):Matrix3D
		{
			var p:PerspectiveMatrix3D = new PerspectiveMatrix3D;
			p.appendRotation(num,axis);
			p.prependTranslation(-_currentPatch.x, -_currentPatch.y,-_currentPatch.z);
			return p
		}

		
	}
}