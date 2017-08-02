package _Pan3D.utils.materialShow
{
	import com.adobe.utils.PerspectiveMatrix3D;
	
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTriangleFace;
	import flash.geom.Rectangle;
	
	import PanV2.ConfigV2;
	
	import _Pan3D.base.Camera3D;
	import _Pan3D.display3D.Display3DMaterialSprite;
	import _Pan3D.program.Program3DManager;
	
	import _me.Scene_data;
	
	import materials.MaterialTree;

	public class BuildShowModel
	{
		//private var _textureShowSprite:Display3DMaterialSprite;
		//private var _material:MaterialTree;
		private static var instance:BuildShowModel;
		public function BuildShowModel()
		{
			//_textureShowSprite=new Display3DMaterialSprite(Scene_data.context3D);
		}
		public static function getInstance():BuildShowModel{
			if(!instance){
				instance = new BuildShowModel();
			}
			return instance;
		}
		private var _buildItem:Vector.<ScanModelSprite>
		private function makeBuildList($arr:Array):void
		{
			clear();
			for(var i:uint;i<$arr.length;i++){
				var tempSprite:ScanModelSprite=new ScanModelSprite(Scene_data.context3D)
				tempSprite.url=$arr[i].url
				tempSprite.x=$arr[i].x
				tempSprite.y=$arr[i].y
				tempSprite.z=$arr[i].z

				if($arr[i].scale){
					tempSprite.scale_x=$arr[i].scale
					tempSprite.scale_y=$arr[i].scale
					tempSprite.scale_z=$arr[i].scale
				}

		
				if(MaterialTree($arr[i].material)){
					Program3DManager.getInstance().regMaterial(MaterialTree($arr[i].material));
					tempSprite.material=MaterialTree($arr[i].material);
				}
			
			
				_buildItem.push(tempSprite)
			}
			
		}
		private function clear():void
		{
			_buildItem=new Vector.<ScanModelSprite>
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
		public function renderBuildToBitmapData($arr:Array,$cam:Camera3D,$rec:Rectangle):BitmapData
		{
			if($arr){
				makeBuildList($arr);
			}
			resetVa()
			var _bmp:BitmapData=new BitmapData($rec.width,$rec.height,true,0);
			var _context3D:Context3D=Scene_data.context3D
			_context3D.configureBackBuffer(_bmp.width,_bmp.height,16, true);
			_context3D.clear(40/255,40/255,40/255,1);
			_context3D.setCulling(Context3DTriangleFace.NONE);
			_context3D.setDepthTest(true,Context3DCompareMode.LESS);
			var $viewMatrx3D:PerspectiveMatrix3D=new PerspectiveMatrix3D();
			$viewMatrx3D.perspectiveFieldOfViewLH(1,1,1, 5000);
			
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, $viewMatrx3D, true);
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, $cam.cameraMatrix, true);
				
			for(var i:uint=0;i<_buildItem.length;i++)
			{
			
				_buildItem[i].cameraPosV3d=$cam
				_buildItem[i].update()
			}
			_context3D.drawToBitmapData(_bmp)
			ConfigV2.getInstance().configAntiAlias(Scene_data.antiAlias,Scene_data.stage3DVO.width,Scene_data.stage3DVO.height)
			return _bmp
		}
		
	
		

		
		
	}
}


