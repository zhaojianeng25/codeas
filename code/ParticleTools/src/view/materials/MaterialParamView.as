package view.materials
{
	
	import flash.events.Event;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	
	import spark.components.Label;
	
	import _Pan3D.utils.MaterialManager;
	
	import _me.Scene_data;
	
	import common.utils.frame.BasePanel;
	import common.utils.ui.curves.TextCurvesTexUI;
	import common.utils.ui.curves.TextCurvesUI;
	import common.utils.ui.img.ImageComponent;
	
	import materials.DynamicConstItem;
	import materials.DynamicTexItem;
	import materials.MaterialTreeParam;
	
	public class MaterialParamView extends BasePanel
	{
		private var _container:Canvas;
		private var _materialParam:MaterialTreeParam;
		private var _txt:Label;
		public function MaterialParamView()
		{
			super();
			
			_container = new Canvas;
			//_container.width = 1000;
			//_container.height = 1000;
			this.addChild(_container);
			
			_txt = new Label();
			_txt.setStyle("color",0x9f9f9f);
			_txt.width = 200;
			_txt.height = 45;
			_txt.x = 30;
			this.addChild(_txt);
			//_txt.text = "123";
		}
		
		private static var _instance:MaterialParamView;
		public static function getInstance():MaterialParamView{
			if(!_instance){
				_instance = new MaterialParamView;
			}
			return _instance;
		}
		
		public function removeAll():void{
			while(_container.numChildren){
				_container.removeChildAt(0);
			}
		}
		
		public function showMaterial($material:MaterialTreeParam):void{
			_materialParam = $material;
			removeAll();
			
			initView();
			
			_txt.text = $material.materialUrl.replace(Scene_data.fileRoot,"");
		}
		private var dynamicObj:Object;
		public function initView():void{
			var dynamicTexList:Vector.<DynamicTexItem> = _materialParam.dynamicTexList;
			dynamicObj = new Object;
			var flagY:int = 45;
			for(var i:int;i<dynamicTexList.length;i++){
				if(dynamicTexList[i].isParticleColor){
					dynamicObj[dynamicTexList[i].paramName] = dynamicTexList[i];
					var curveImg:TextCurvesTexUI = new TextCurvesTexUI;
					curveImg.label = dynamicTexList[i].paramName;
					curveImg.target = dynamicObj;
					curveImg.FunKey = dynamicTexList[i].paramName;
					
					_container.addChild(curveImg);
					curveImg.y = flagY;
					flagY += curveImg.height; 
					curveImg.addEventListener(Event.CHANGE,onImgChg);
					curveImg.refreshViewValue();
				}else{
					dynamicObj[dynamicTexList[i].paramName] = dynamicTexList[i].url;
					var img:ImageComponent = new ImageComponent;
					img.baseUrl = Scene_data.fileRoot;
					img.target = dynamicObj;
					img.FunKey = dynamicTexList[i].paramName;
					img.label = dynamicTexList[i].paramName;
					_container.addChild(img);
					img.y = flagY;
					flagY += img.height; 
					img.addEventListener(Event.CHANGE,onImgChg);
					img.refreshViewValue();
				}
				
			}
			
			var dynamicConstList:Vector.<DynamicConstItem> = _materialParam.dynamicConstList;
			
			for(i=0;i<dynamicConstList.length;i++){
				dynamicObj[dynamicConstList[i].paramName] = dynamicConstList[i].curve;
				var cureView:TextCurvesUI = new TextCurvesUI;
				cureView.label = dynamicConstList[i].paramName;
				cureView.target = dynamicObj;
				cureView.FunKey = dynamicConstList[i].paramName;
				
				_container.addChild(cureView);
				cureView.y = flagY;
				flagY += cureView.height; 
				cureView.addEventListener(Event.CHANGE,onImgChg);
				cureView.refreshViewValue();
			}
			
		}
		
		
		
		protected function onImgChg(event:Event):void
		{
			
			var dynamicTexList:Vector.<DynamicTexItem> = _materialParam.dynamicTexList;
			for(var key:String in dynamicObj){
				if(dynamicObj[key] is String){
					for(var i:int = 0;i<dynamicTexList.length;i++){
						if(dynamicTexList[i].paramName == key){
							dynamicTexList[i].url = String(dynamicObj[key]);
							break;
						}
					}
				}
			}
			
			MaterialManager.getInstance().loadDynamicTexUtil(_materialParam);
		}		
		
		
		
		
	}
}