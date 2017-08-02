package modules.cradiosity
{
	import com.zcp.frame.Module;
	import com.zcp.frame.event.ModuleEvent;
	
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import _Pan3D.core.MathCore;
	
	import common.AppData;
	import common.utils.frame.BaseProcessor;
	import common.utils.frame.MetaDataView;
	
	import cradiosity.CradiosityMesh;
	
	import manager.LayerManager;
	
	public class CradiosityProcessor extends BaseProcessor
	{
		public function CradiosityProcessor($module:Module)
		{
			super($module);
		}
		override protected function listenModuleEvents():Array 
		{
			return [
				CradiosityEvent,

			]
		}
		
		override protected function receivedModuleEvent($me:ModuleEvent):void 
		{
			switch($me.getClass()) {
				
				case CradiosityEvent:
		
					if($me.action==CradiosityEvent.SHOW_RADIOSITY_C_PROJECT){
						
						showObjsMesh()
				
					}
					break;
						
						
			}
		}
		private var _cradiosityMeshView:MetaDataView;
		private var _cradiosityMesh:CradiosityMesh;
		private function showObjsMesh():void
		{
				
				if(!_cradiosityMeshView){
					_cradiosityMeshView = new MetaDataView();
					_cradiosityMeshView.init(this,"属性",2);
					_cradiosityMeshView.creatByClass(CradiosityMesh);
				}
		
				_cradiosityMesh=new CradiosityMesh;
	
			
				
				
				if(AppData.Ambient_light_intensity<0){
					AppData.Ambient_light_intensity=MathCore.argbToHex(255,255,0,0);
				}
	
				
				_cradiosityMesh.Ambient_light_intensity=AppData.Ambient_light_intensity;;
				_cradiosityMesh.Ambient_light_Size=AppData.Ambient_light_Size;;
				_cradiosityMesh.Shadow_precision=AppData.Shadow_precision;
				_cradiosityMesh.patch_precision=AppData.patch_precision;
				_cradiosityMesh.patch_num=AppData.patch_num;
				_cradiosityMesh.openAo=AppData.openAo;
				_cradiosityMesh.Ao_Range=AppData.Ao_Range;
				_cradiosityMesh.Ao_strength=AppData.Ao_strength;
		
				LayerManager.getInstance().showPropPanle(_cradiosityMeshView);
				
				_cradiosityMeshView.setTarget(_cradiosityMesh);
				
				_cradiosityMesh.addEventListener(Event.CHANGE,onMeshChange)

		}
		
		protected function onMeshChange(event:Event):void
		{
			var $cradiosityMesh:CradiosityMesh=CradiosityMesh(event.target)
				
			AppData.Ambient_light_intensity=$cradiosityMesh.Ambient_light_intensity;
			AppData.Ambient_light_Size=$cradiosityMesh.Ambient_light_Size;
			AppData.Shadow_precision=$cradiosityMesh.Shadow_precision;
			AppData.patch_precision=$cradiosityMesh.patch_precision;
			AppData.patch_num=$cradiosityMesh.patch_num;
			AppData.openAo=$cradiosityMesh.openAo;
			AppData.Ao_Range=$cradiosityMesh.Ao_Range;
			AppData.Ao_strength=$cradiosityMesh.Ao_strength;
			
			
		    
			
			trace(	MathCore.hexToArgb($cradiosityMesh.Ambient_light_intensity))
			
		}		
		
	}
}