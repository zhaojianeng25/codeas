package _Pan3D.utils.materialShow
{
	import com.adobe.utils.PerspectiveMatrix3D;
	
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTriangleFace;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import PanV2.ConfigV2;
	
	import _Pan3D.display3D.Display3DMaterialSprite;
	import _Pan3D.program.Program3DManager;
	
	import _me.Scene_data;
	
	import materials.MaterialTree;
	

	public class MaterialShowModel
	{
		private static var instance:MaterialShowModel;
		
		private var _textureShowSprite:Display3DMaterialSprite;
		private var _material:MaterialTree;
		public function MaterialShowModel()
		{
			_textureShowSprite=new Display3DMaterialSprite(Scene_data.context3D);
		}
		public static function getInstance():MaterialShowModel{
			if(!instance){
				instance = new MaterialShowModel();
			}
			return instance;
		}
		public function renderMaterialToBitmapData($url:String,$camMatrix3D:Matrix3D,$materialTree:MaterialTree,$rec:Rectangle,$pos:Vector3D=null):BitmapData
		{
			
			
			if(_textureShowSprite.url!=$url){
				_textureShowSprite.url=$url
			}
			if(_material != $materialTree){
				Program3DManager.getInstance().regMaterial($materialTree);
				_material = $materialTree;
				_textureShowSprite.material=$materialTree;
				_material.addEventListener(Event.CHANGE,onMaterialChg);
			}
			if($pos){
				_textureShowSprite.x=$pos.x;
				_textureShowSprite.y=$pos.y;
				_textureShowSprite.z=$pos.z;
			}
			var _bmp:BitmapData=new BitmapData($rec.width,$rec.height,true,0);
			var _context3D:Context3D=Scene_data.context3D
			_context3D.configureBackBuffer(_bmp.width,_bmp.height,16, true);
			_context3D.clear(40/255,40/255,40/255,1);
			_context3D.setCulling(Context3DTriangleFace.NONE);
			_context3D.setDepthTest(true,Context3DCompareMode.LESS);
			
			var $viewMatrx3D:PerspectiveMatrix3D=new PerspectiveMatrix3D();
			$viewMatrx3D.perspectiveFieldOfViewLH(1,1,1, 5000);

			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, $viewMatrx3D, true);
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, $camMatrix3D, true);
			
	
			_textureShowSprite.update()
				
				
			_context3D.drawToBitmapData(_bmp)
			ConfigV2.getInstance().configAntiAlias(Scene_data.antiAlias,Scene_data.stage3DVO.width,Scene_data.stage3DVO.height)
			return _bmp
		}
		
		protected function onMaterialChg(event:Event):void
		{
			_textureShowSprite.material=_material;
		}		
		
		
	
	}
}