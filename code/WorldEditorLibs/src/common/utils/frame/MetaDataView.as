package common.utils.frame
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.describeType;
	
	import common.AppData;
	import common.utils.ui.cbox.ComLabelBox;
	import common.utils.ui.collision.CollisionUi;
	import common.utils.ui.color.ColorPickers;
	import common.utils.ui.img.IconNameLabel;
	import common.utils.ui.navMesh.NavMeshUi;
	import common.utils.ui.prefab.AlignPanelPic;
	import common.utils.ui.prefab.BoneMotionModePic;
	import common.utils.ui.prefab.CaptureIdUi;
	import common.utils.ui.prefab.MaterialModelPic;
	import common.utils.ui.prefab.MotionModelPic;
	import common.utils.ui.prefab.PreFabModelPic;
	import common.utils.ui.prefab.PrefabRenderWindow;
	import common.utils.ui.prefab.Texturue2DUI;
	import common.utils.ui.txt.TextCtrlInput;
	import common.utils.ui.txt.TextLabelEnabel;
	import common.utils.ui.txt.TextVec2Input;
	import common.utils.ui.txt.TextVec3Input;
	
	import interfaces.ITile;
	
	import modules.brower.fileWin.BrowerManage;

	public class MetaDataView extends BaseReflectionView
	{
		protected var iconLable:IconNameLabel;
		public function MetaDataView()
		{
			super();
			iconLable = new IconNameLabel;
			this.addChild(iconLable);
		}
		
		public function creatByClass($cls:Class):void{
			//var xml:XML = describeType($cls);
			var xml:XMLList = describeType($cls)["factory"][0]["accessor"];
			var data:Array = new Array;
			for each(var item:XML in xml){
				//trace(item);
				var obj:Object = null;
				for each(var metadata:XML in item["metadata"]){
					if(metadata.@["name"] == "Editor"){
						obj = new Object;
						for each(var metadataItem:XML in metadata["arg"]){
							obj[String(metadataItem.@key)] = String(metadataItem.@value);
						}
						break;
					}
				}
				if(obj){
					obj.key = String(item.@["name"]);
					obj.keyType = String(item.@["type"]);
					obj.sort = Number(obj.sort);
					data.push(obj);
				}
				
			}
			
			data.sortOn("sort",Array.NUMERIC);
			
			ui = new Vector.<BaseComponent>;
			for(var i:int=0;i<data.length;i++){
				if(data[i].hasOwnProperty("showType")){
					if(data[i]["showType"] != AppData.type){
						continue;
					}
				}
				var component:BaseComponent = creatComponteByMetadata(data[i]);
				if(component){
					ui.push(component);
				}
			}
			
			addComponentView();
		}
		
		public function setTarget(target:Object):void{
			for(var i:int;i<ui.length;i++){
				ui[i].setTarget(target);
			}
			iconLable.icon = BrowerManage.getIconByClass(target["constructor"] as Class);
			iconLable.label = ITile(target).getName();
			
			iconLable.target=target
			EventDispatcher(target).addEventListener(Event.CHANGE,onTargetChange);
		}
		
		protected function onTargetChange(event:Event):void
		{
			refreshView();
		}
		
		override public function relistPos(event:Event = null):void{
	
			var ypos:int = 43;
			for(var i:int;i<_accordList.length;i++){
				_accordList[i].y = ypos;
				ypos += _accordList[i].height + 1;
			}
		}
		
		public function creatComponteByMetadata(obj:Object):BaseComponent{
			var type:String = obj.type;
			
			
			if(type == ReflectionData.Num){
				return getNumComponent(obj);
			}else if(type == ReflectionData.ColorPick){
				return getColorComponentPan(obj);
			}else if(type == ReflectionData.ComboBox){
				return getComboxComponent(obj);
			}else if(type == ReflectionData.CheckBox){
				//return getCheckComponent(obj);
			}else if(type == ReflectionData.Vec3){
				return getVec3Text(obj);
			}else if(type == ReflectionData.Vec2){
				return getVec2Text(obj);
			}else if(type == ReflectionData.Btn){
				return getBtnComponent(obj);
			}else if(type == ReflectionData.Texturue2DUI){
				return getTexturue2DUI(obj);
				
			}else if(type == ReflectionData.PreFabImg){
				return getPrefabImg(obj);
			}else if(type == ReflectionData.PrefabRenderWindow){
				return getPrefabRenderWindow(obj);
			}else if(type == ReflectionData.AlignPanelPic){
				return getAlignPanelPic(obj);
			}else if(type == ReflectionData.CollisionUi){
				return getCollisionUi(obj);
			}else if(type == ReflectionData.NavMeshUi){
				return getNavMeshUi(obj);
			}else if(type == ReflectionData.MotionModelPic){
				return getMotionModelPic(obj);
			}else if(type == ReflectionData.BoneMotionModePic){
				return getBoneMotionModelPic(obj);
			}else if(type == ReflectionData.MaterialImg){
				return getMaterialImg(obj);
			}else if(type == ReflectionData.TextLabelEnabel){
				return getTextLabelInput(obj);
			}else if(type == ReflectionData.CaptureIdUi){
				return getCaptureIdUi(obj);
			}
			return null
		}
		
		private function getCollisionUi(obj:Object):BaseComponent
		{
			var $CollisionUi:CollisionUi=new CollisionUi()
			$CollisionUi.FunKey = obj.key;
			$CollisionUi.category = obj[ReflectionData.Key_Category];
			return $CollisionUi;
		}
		private function getNavMeshUi(obj:Object):BaseComponent
		{
			var $NavMeshUi:NavMeshUi=new NavMeshUi()
			$NavMeshUi.FunKey = obj.key;
			$NavMeshUi.category = obj[ReflectionData.Key_Category];
			return $NavMeshUi;
		}
		
		private function getCaptureIdUi(obj:Object):BaseComponent
		{
			var text:CaptureIdUi = new CaptureIdUi;
			text.center = true;
			text.height = 18;
			text.label = obj[ReflectionData.Key_Label];
			text.FunKey = obj.key;
			text.tip = getTip(obj);
			
			text.extensinonStr= obj[ReflectionData.ExtensinonStr];
			text.category = obj[ReflectionData.Key_Category];
	
			return text;
		}
		
		private function getMotionModelPic(obj:Object):BaseComponent
		{
			var $motionModelPic:MotionModelPic=new MotionModelPic()
			$motionModelPic.FunKey = obj.key;
			$motionModelPic.titleLabel=obj[ReflectionData.Key_Label];
			$motionModelPic.changePath=obj[ReflectionData.ChangePath];
			$motionModelPic.category = obj[ReflectionData.Key_Category];
			
			$motionModelPic.donotDubleClik = obj[ReflectionData.donotDubleClik];
			$motionModelPic.extensinonStr= obj[ReflectionData.ExtensinonStr];
			return $motionModelPic;
		}
		private function getBoneMotionModelPic(obj:Object):BaseComponent
		{
			var $motionModelPic:BoneMotionModePic=new BoneMotionModePic()
			$motionModelPic.FunKey = obj.key;
			$motionModelPic.titleLabel=obj[ReflectionData.Key_Label];
			$motionModelPic.changePath=obj[ReflectionData.ChangePath];
			$motionModelPic.category = obj[ReflectionData.Key_Category];
			
			$motionModelPic.donotDubleClik = obj[ReflectionData.donotDubleClik];
			$motionModelPic.extensinonStr= obj[ReflectionData.ExtensinonStr];
			return $motionModelPic;
		}
		public function getColorComponentPan(obj:Object):ColorPickers{
			var cp:ColorPickers = new ColorPickers;
			cp.FunKey = obj.key;
			cp.label = obj[ReflectionData.Key_Label];
			cp.width = this.width;
			cp.height = 18;

			cp.getFun = obj[ReflectionData.Key_GetFun];
			cp.changFun = obj[ReflectionData.Key_SetFun];
			cp.category = obj[ReflectionData.Key_Category];
			cp.refreshViewValue();
			
			return cp;
		}
		private function getVec3Text(obj:Object):TextVec3Input
		{
	
			var vc:TextVec3Input = new TextVec3Input;
			vc.FunKey = obj.key;
			vc.category = obj[ReflectionData.Key_Category];
			vc.step = obj[ReflectionData.Key_Step];
			vc.label = obj[ReflectionData.Key_Label];
			
	
			return vc;
		}
		private function getVec2Text(obj:Object):TextVec2Input
		{
	
			var vc:TextVec2Input = new TextVec2Input;
			vc.FunKey = obj.key;
			vc.category = obj[ReflectionData.Key_Category];
			//vc.maxNum = obj[ReflectionData.Key_MaxNum];
			//vc.minNum = obj[ReflectionData.Key_MinNum];
			//vc.step = obj[ReflectionData.Key_Step];
			vc.label = obj[ReflectionData.Key_Label];
			
	
			return vc;
		}
		
		private function getTextLabelInput(obj:Object):TextLabelEnabel
		{
			var $TextLabelInput:TextLabelEnabel=new TextLabelEnabel()
			$TextLabelInput.FunKey = obj.key;
			$TextLabelInput.category = obj[ReflectionData.Key_Category];
			$TextLabelInput.label = obj[ReflectionData.Key_Label];
			return $TextLabelInput;
		}
		
		private function getPrefabImg(obj:Object):PreFabModelPic
		{
			var $preFabModelPic:PreFabModelPic=new PreFabModelPic()
			$preFabModelPic.FunKey = obj.key;
			$preFabModelPic.titleLabel=obj[ReflectionData.Key_Label];
			$preFabModelPic.changePath=obj[ReflectionData.ChangePath];
			$preFabModelPic.category = obj[ReflectionData.Key_Category];
			
			$preFabModelPic.donotDubleClik = obj[ReflectionData.donotDubleClik];
			$preFabModelPic.extensinonStr= obj[ReflectionData.ExtensinonStr];
			return $preFabModelPic;
		}
		private function getAlignPanelPic(obj:Object):AlignPanelPic
		{
			var $prefabRenderWindow:AlignPanelPic=new AlignPanelPic()
			$prefabRenderWindow.FunKey = obj.key;
			$prefabRenderWindow.category = obj[ReflectionData.Key_Category];
			return $prefabRenderWindow;
		}
		private function getPrefabRenderWindow(obj:Object):PrefabRenderWindow
		{
			var $prefabRenderWindow:PrefabRenderWindow=new PrefabRenderWindow()
			$prefabRenderWindow.FunKey = obj.key;
			$prefabRenderWindow.category = obj[ReflectionData.Key_Category];
			return $prefabRenderWindow;
		}
		private function getMaterialImg(obj:Object):PreFabModelPic
		{
			var $preFabModelPic:MaterialModelPic=new MaterialModelPic()
			$preFabModelPic.titleLabel=obj[ReflectionData.Key_Label];
			$preFabModelPic.FunKey = obj.key;
			$preFabModelPic.category = obj[ReflectionData.Key_Category];
			
			$preFabModelPic.donotDubleClik = obj[ReflectionData.donotDubleClik];
			$preFabModelPic.extensinonStr= obj[ReflectionData.ExtensinonStr];
			

			return $preFabModelPic;
		}
		private function getTexturue2DUI(obj:Object):Texturue2DUI
		{
			var $texturue2DUI:Texturue2DUI=new Texturue2DUI()

			$texturue2DUI.FunKey = obj.key;
			$texturue2DUI.category = obj[ReflectionData.Key_Category];


			return $texturue2DUI;
		}
		
		override public function getNumComponent(obj:Object):TextCtrlInput{
			var text:TextCtrlInput = new TextCtrlInput;
			text.center = true;
			text.height = 18;
			text.label = obj[ReflectionData.Key_Label];
			text.FunKey = obj.key;
			text.tip = getTip(obj);
			
			if(obj.hasOwnProperty(ReflectionData.Key_MaxNum)){
				text.maxNum = obj[ReflectionData.Key_MaxNum];
			}
			if(obj.hasOwnProperty(ReflectionData.Key_MinNum)){
				text.minNum = obj[ReflectionData.Key_MinNum];
			}
			
			if(obj.hasOwnProperty(ReflectionData.Key_Step)){
				text.step = obj[ReflectionData.Key_Step];
			}
			
			text.category = obj[ReflectionData.Key_Category];
			
			//text.refreshViewValue();
			return text;
		}
		
		override public function getComboxComponent(obj:Object):ComLabelBox{
			var cb:ComLabelBox = new ComLabelBox;
			cb.label = obj[ReflectionData.Key_Label];;
			cb.width = this.width;
			cb.height = 18;
			cb.labelData = getComboxData(obj[ReflectionData.Key_Data],obj.keyType);
			cb.tip = getTip(obj);
			
			cb.FunKey = obj.key;
			cb.category = obj[ReflectionData.Key_Category];
			
			//cb.refreshViewValue();
			return cb;
		}
		
		public function getComboxData(str:String,type:String):Array{
			var ary:Array = new Array;
			
			var reg:RegExp =  /(?<={)[^{}]+(?=})/g;
			var arr:Array = str.match(reg);
			
			for(var i:int=0;i<arr.length;i++){
				var ss:String = arr[i];
				var sary:Array = ss.split(",");
				
				var obj:Object = new Object;
				
				var nameStr:String = sary[0];
				var valueStr:String = sary[1];
				var itemAry:Array = nameStr.split(":");
				obj.name = itemAry[1];
				
				itemAry = valueStr.split(":");
				
				var value:String = itemAry[1];
				if(type == "int"){
					obj.data = int(value);
				}else if(type == "Boolean"){
					if(value=="true"){
						obj.data = true;
					}else if(value=="false"){
						obj.data = false;
					}else{
						throw new Error("配置出错");
					}
				}else if(type == "Number"){
					obj.data = Number(value);
				}else if(type == "String"){
					obj.data = String(value);
				}
				ary.push(obj);
			}
			
			return ary;
		}
		
		public function getTip(obj:Object):String{
			return "属性：\n\t" + obj.key + "\n" + "描述:\n\t" + (obj[ReflectionData.Key_Tip] ? obj[ReflectionData.Key_Tip] : "无");
		}
		
	}
}