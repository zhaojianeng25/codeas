package modules.terrain
{
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import _Pan3D.core.MathCore;
	
	import _me.Scene_data;
	
	import render.ground.GroundManager;
	import render.ground.TerrainEditorData;
	
	import terrain.GroundData;
	import terrain.GroundMath;

	public class TerrainDrawGrassModel
	{
		private static var instance:TerrainDrawGrassModel;
		private var _isCanDraw:Boolean;
		private var _isDrawPass:Boolean;
		private static var _shap:Shape = new Shape();//画刷
		
		public function TerrainDrawGrassModel()
		{
		}
		public static function getInstance():TerrainDrawGrassModel
		{
			
			if(!instance){
				instance=new TerrainDrawGrassModel()
			}
			return instance;
		}
		public function mouseDown($pos:Vector3D):void
		{
			if(mouseInStage3D){
				_isCanDraw=true
				_isDrawPass=false
			}
		}
		public function mouseMove($pos:Vector3D,$idNum:uint):void
		{
			if($idNum>TerrainEditorData.sixTeenFileNodeArr.length){
				return ;
			}
			
			if(_isCanDraw){
		
				_isDrawPass=true
				drawGrasst($pos,$idNum)
			}
		}
		public function mouseUp($pos:Vector3D,$idNum:uint):void
		{
			if($idNum>TerrainEditorData.sixTeenFileNodeArr.length){
				return ;
			}
			
			if(!_isDrawPass){
				if($pos){
					mouseMove($pos,$idNum)
				}
			}
			_isCanDraw=false
			_isDrawPass=false
		}

		private function drawGrasst($pos:Vector3D, $idNum:uint):void
		{
			
			
			var Area_Size:uint=GroundMath.getInstance().Area_Size;
			var ID_MAP_SCALE:uint=GroundMath.getInstance().ID_MAP_SCALE;
			var Area_Cell_Num:uint=GroundMath.getInstance().Area_Cell_Num;
			var $tempScale:Number=Area_Cell_Num*ID_MAP_SCALE/Area_Size
			
		
			var brushSize:Number=TerrainDrawHeightModel.brushSize*GroundData.idMapScale
			if(brushSize<=0){
				brushSize=1
			}
	
			_shap.graphics.clear();
			var fillType:String = GradientType.RADIAL;
			var colors:Array = [0xFF0000, 0xff0000];
			var alphas:Array = [TerrainDrawHeightModel.brushPow, 0];
			var ratios:Array = [(1-TerrainDrawHeightModel.brushBluer )* 255, 255];
			var matr:Matrix = new Matrix();
			matr.createGradientBox( brushSize,  brushSize, 0, 0, 0);
			var spreadMethod:String = SpreadMethod.PAD;
			_shap.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod,InterpolationMethod.LINEAR_RGB,0);  
			_shap.graphics.drawRect(0,0, brushSize,brushSize);
			_shap.graphics.endFill();
			
			
			
			var lingshiBitmap:BitmapData=new BitmapData( brushSize, brushSize,false,0x000000);
			lingshiBitmap.draw(_shap)
		
			var $p:Vector3D=new Vector3D($pos.x*$tempScale,0,$pos.z*$tempScale)
			for(var i:uint=0;i<lingshiBitmap.width;i++){
				for(var j:uint=0;j<lingshiBitmap.width;j++){
					var h:Number=MathCore.hexToArgb(lingshiBitmap.getPixel(i,j),false).x
					if(h>0){
						var $changeP:Vector3D=new Vector3D($p.x+i-brushSize/2,0,$p.z+j-brushSize/2)
						var $idV:Vector3D=MathCore.hexToArgb(TerrainEditorData.bigIdMapBmp.getPixel($changeP.x,$changeP.z))
						var $colorV:Vector3D=MathCore.hexToArgb(TerrainEditorData.bigInfoMapBmp.getPixel($changeP.x,$changeP.z))
							
					
						changeIdAndInfo($changeP,$idV,$colorV,$idNum,h)

//						$idV=new Vector3D(2,0,0)	
//						$colorV=new Vector3D(255,0,0)
//						TerrainData.bigIdMapBmp.setPixel($changeP.x,$changeP.z,MathCore.argbToHex16($idV.x,$idV.y,$idV.z))
//						TerrainData.bigInfoMapBmp.setPixel($changeP.x,$changeP.z,MathCore.argbToHex16($colorV.x,$colorV.y,$colorV.z))
					}
				}
			}
			
			var $tric:Rectangle=new Rectangle($p.x-brushSize/2,$p.z-brushSize/2,brushSize,brushSize);
			GroundManager.getInstance().upAllidMap($tric)
		}
		private function changeIdAndInfo($changeP:Vector3D,$idV:Vector3D,$colorV:Vector3D,$idNum:uint,h:Number):void
		{

			var total:Number;
			if($idNum==$idV.x){
				//加颜色
				$colorV.x=$colorV.x+h
				if($colorV.x>0xFF){
					$colorV.x=0xFF
					$colorV.y=0
					$colorV.z=0
				}else{
					total=(0xFF-$colorV.x)/($colorV.y+$colorV.z)
					$colorV.y=total*$colorV.y
					$colorV.z=total*$colorV.z
				}
			}else if($idNum==$idV.y){
				$colorV.y=$colorV.y+h
				if($colorV.y>0xFF){
					$colorV.x=0
					$colorV.y=0xFF
					$colorV.z=0
				}else{
					total=(0xFF-$colorV.y)/($colorV.x+$colorV.z)
					$colorV.x=total*$colorV.x
					$colorV.z=total*$colorV.z
				}
				
			}else if($idNum==$idV.z){
				$colorV.z=$colorV.z+h
				if($colorV.z>0xFF){
					$colorV.x=0
					$colorV.y=0
					$colorV.z=0xFF
				}else{
					total=(0xFF-$colorV.z)/($colorV.x+$colorV.y)
					$colorV.x=total*$colorV.x
					$colorV.y=total*$colorV.y
				}
			}else{
				//找到最小值的修改ID
				if($colorV.x<=$colorV.y&&$colorV.x<=$colorV.z){
					$idV.x=$idNum
					$colorV.x=h
					
				}else if($colorV.y<$colorV.z){
					$idV.y=$idNum
					$colorV.y=h
				}else{
					$idV.z=$idNum
					$colorV.z=h
				}
			}
			TerrainEditorData.bigIdMapBmp.setPixel($changeP.x,$changeP.z,MathCore.argbToHex16($idV.x,$idV.y,$idV.z))
			TerrainEditorData.bigInfoMapBmp.setPixel($changeP.x,$changeP.z,MathCore.argbToHex16($colorV.x,$colorV.y,$colorV.z))
		}
		
		
		
	
		private function get mouseInStage3D():Boolean
		{
			var $rect:Rectangle=new Rectangle(0,0,Scene_data.stage3DVO.width,Scene_data.stage3DVO.height)
			return $rect.containsPoint(new Point(Scene_data.stage3DVO.mouseX,Scene_data.stage3DVO.mouseY));
		}
	}
}
