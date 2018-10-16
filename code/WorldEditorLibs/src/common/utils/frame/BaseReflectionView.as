package common.utils.frame
{
	import flash.events.Event;
	
	import common.utils.ui.btn.LButton;
	import common.utils.ui.cbox.ComLabelBox;
	import common.utils.ui.check.CheckLabelBox;
	import common.utils.ui.color.ColorPickers;
	import common.utils.ui.curves.GapLineUI;
	import common.utils.ui.curves.TextCurvesUI;
	import common.utils.ui.prefab.MaterialModelPic;
	import common.utils.ui.prefab.PreFabModelPic;
	import common.utils.ui.txt.ColorVec3Input;
	import common.utils.ui.txt.TextCtrlInput;
	import common.utils.ui.txt.TextLabelEnabel;
	import common.utils.ui.txt.TextLabelInput;
	import common.utils.ui.txt.TextVec2Input;
	import common.utils.ui.txt.TextVec3Input;

	public class BaseReflectionView extends BasePanel
	{
		
		protected var _accordList:Vector.<AccordionCanvas>;
		protected var ui:Vector.<BaseComponent>;
		public function BaseReflectionView()
		{
			super();
			_accordList = new Vector.<AccordionCanvas>;
		}
		
		public function get accordList():Vector.<AccordionCanvas>
		{
			return _accordList;
		}

		public function set accordList(value:Vector.<AccordionCanvas>):void
		{
			_accordList = value;
		}

		public function refreshView():void{
			for(var i:int;i<ui.length;i++){
				ui[i].refreshViewValue();
			}
		}
		
		public function creat(data:Array):void{
			ui = new Vector.<BaseComponent>;
			for(var i:int=0;i<data.length;i++){
				ui.push(creatComponent(data[i]));
			}
			
			addComponentView();
		}
		
		public function addComponentView():void{
			var mapvec:Vector.<CategoryMap> = new Vector.<CategoryMap>;
			
			for(var i:int=0;i<ui.length;i++){
				var cate:CategoryMap = null;
				for(var j:int=0;j<mapvec.length;j++){
					if(mapvec[j].category == ui[i].category){
						cate = mapvec[j];
						break;
					}
				}
				
				if(cate == null){
					cate = new CategoryMap;
					cate.category = ui[i].category;
					mapvec.push(cate);
				}
				
				cate.vec.push(ui[i]);
			}
			
			for(i=0;i<mapvec.length;i++){
				var cav:AccordionCanvas = new AccordionCanvas;
				cav.Lable = mapvec[i].category;
				this.addChild(cav);
				for(j=0;j<mapvec[i].vec.length;j++){
					var coms:BaseComponent = mapvec[i].vec[j];
					cav.addComponent(coms);
				}
				_accordList.push(cav);
				
				cav.addEventListener("openchange",relistPos);
			}
			relistPos();
		}
		
		public function removeAllComponent():void{
			for(var i:int;i<_accordList.length;i++){
				if(_accordList[i].parent){
					_accordList[i].parent.removeChild(_accordList[i]);
				}
			}
			_accordList.length = 0;
			if(ui){
				ui.length = 0;
			}
		}
		
		public function relistPos(event:Event = null):void{
			var ypos:int;
			for(var i:int;i<_accordList.length;i++){
				_accordList[i].y = ypos;
				ypos += _accordList[i].height + 1;
			}
		}
		
		public function creatComponent(obj:Object):BaseComponent{
			var type:String = obj[ReflectionData.Key_Type];
			
			if(type == ReflectionData.Number){
				return getNumComponent(obj);
			}else if(type == ReflectionData.ColorPick){
				return getColorComponent(obj);
			}else if(type == ReflectionData.ComboBox){
				return getComboxComponent(obj);
			}else if(type == ReflectionData.CheckBox){
				return getCheckComponent(obj);
			}else if(type == ReflectionData.Vec3){
				return getVec3Component(obj);
			}else if(type == ReflectionData.Vec2){
				return getVec2Component(obj);
			}else if(type == ReflectionData.Btn){
				return getBtnComponent(obj);
			}else if(type == ReflectionData.UserView){
				return getUserVier(obj);
			}else if(type == ReflectionData.PreFabImg){
				return getPreFabImg(obj);
			}else if(type == ReflectionData.MaterialImg){
				return getMaterialImg(obj);
			}else if(type == ReflectionData.Vec3Color){
				return getColorVec3Component(obj);
			}else if(type == ReflectionData.Curve){
				return getCurveComponent(obj);
			}else if(type == ReflectionData.Gap){
				return getGapComponent(obj);
			}else if(type == ReflectionData.Input){
				return getInputComponent(obj);
			}else if(type == ReflectionData.TextLabelEnabel){
				return getTextLabelComponent(obj);
			}
			
			return null;
		}
		
		private function getMaterialImg(obj:Object):BaseComponent
		{
			var $preFabModelPic:MaterialModelPic=new MaterialModelPic()
			$preFabModelPic.titleLabel=obj[ReflectionData.Key_Label];
			$preFabModelPic.FunKey = obj.key;
			$preFabModelPic.category = obj[ReflectionData.Key_Category];
			$preFabModelPic.target=obj.target
			$preFabModelPic.donotDubleClik = obj[ReflectionData.donotDubleClik];
			$preFabModelPic.extensinonStr= obj[ReflectionData.ExtensinonStr];
			return $preFabModelPic;
		}
		
		private function getPreFabImg(obj:Object):BaseComponent
		{
			
			var $preFabModelPic:PreFabModelPic=new PreFabModelPic()
			$preFabModelPic.FunKey = obj.key;
			$preFabModelPic.category = obj[ReflectionData.Key_Category];
			$preFabModelPic.target=obj.target
			$preFabModelPic.hasCloseBut=obj[ReflectionData.closeBut];
			$preFabModelPic.extensinonStr= obj[ReflectionData.ExtensinonStr];
			$preFabModelPic.donotDubleClik = obj[ReflectionData.donotDubleClik];
			$preFabModelPic.titleLabel = obj[ReflectionData.Key_Label];
			return $preFabModelPic;
		}

		
		public function getUserVier(obj:Object):BaseComponent{
			var view:BaseComponent = obj[ReflectionData.Key_GetView]();
			view.category = obj[ReflectionData.Key_Category];
			return view;
		}
		
		public function getNumComponent(obj:Object):TextCtrlInput{
			var text:TextCtrlInput = new TextCtrlInput;
			text.height = 18;
			text.center = true;
			text.label = obj[ReflectionData.Key_Label];
			text.getFun = obj[ReflectionData.Key_GetFun];
			text.changFun = obj[ReflectionData.Key_SetFun];
			
			if(obj.hasOwnProperty(ReflectionData.Key_MaxNum)){
				text.maxNum = obj[ReflectionData.Key_MaxNum];
			}
			if(obj.hasOwnProperty(ReflectionData.Key_MinNum)){
				text.minNum = obj[ReflectionData.Key_MinNum];
			}
			
			if(obj.hasOwnProperty(ReflectionData.Key_GetMaxNumFun)){
				text.getMaxFun = obj[ReflectionData.Key_GetMaxNumFun];
			}
			if(obj.hasOwnProperty(ReflectionData.Key_GetMinNumFun)){
				text.getMinFun = obj[ReflectionData.Key_GetMinNumFun];
			}
			
			
			if(obj.hasOwnProperty(ReflectionData.Key_Step)){
				text.step = obj[ReflectionData.Key_Step];
			}
			
			text.category = obj[ReflectionData.Key_Category];
			
			text.refreshViewValue();
			
			return text;
		}
		
		public function getInputComponent(obj:Object):TextLabelInput{
			var text:TextLabelInput = new TextLabelInput;
			text.height = 18;
			text.label = obj[ReflectionData.Key_Label];
			text.getFun = obj[ReflectionData.Key_GetFun];
			text.changFun = obj[ReflectionData.Key_SetFun];
			
			text.category = obj[ReflectionData.Key_Category];
			
			text.refreshViewValue();
			
			return text;
		}
		
		public function getTextLabelComponent(obj:Object):TextLabelEnabel{
			var text:TextLabelEnabel = new TextLabelEnabel;
			text.height = 18;
			text.label = obj[ReflectionData.Key_Label];
			text.getFun = obj[ReflectionData.Key_GetFun];
			text.changFun = obj[ReflectionData.Key_SetFun];
			
			text.category = obj[ReflectionData.Key_Category];
			
			text.refreshViewValue();
			
			return text;
		}
		
		public function getColorComponent(obj:Object):ColorPickers{
			var cp:ColorPickers = new ColorPickers;
			cp.label = obj[ReflectionData.Key_Label];
			cp.width = this.width;
			cp.height = 18;
			
			//cp.color = (obj[ReflectionData.Key_GetFun])();
			cp.getFun = obj[ReflectionData.Key_GetFun];
			cp.changFun = obj[ReflectionData.Key_SetFun];
			
			cp.category = obj[ReflectionData.Key_Category];
			
			cp.refreshViewValue();
			
			return cp;
		}
		
		public function getColorVec3Component(obj:Object):ColorVec3Input{
			var cp:ColorVec3Input = new ColorVec3Input;
			cp.label = obj[ReflectionData.Key_Label];
			cp.width = this.width;
			cp.height = 40;
			
			cp.getFun = obj[ReflectionData.Key_GetFun];
			cp.changFun = obj[ReflectionData.Key_SetFun];
			
			cp.category = obj[ReflectionData.Key_Category];
			
			if(obj[ReflectionData.Key_Step]){
				cp.step = obj[ReflectionData.Key_Step];
			}else{
				cp.step = 1;
			}
			
			cp.refreshViewValue();
			
			return cp;
		}
		
		public function getCurveComponent(obj:Object):TextCurvesUI{
			var cp:TextCurvesUI = new TextCurvesUI;
			cp.label = obj[ReflectionData.Key_Label];
			cp.width = this.width;
			cp.height = 40;
			
			cp.getFun = obj[ReflectionData.Key_GetFun];
			cp.changFun = obj[ReflectionData.Key_SetFun];
			
			cp.category = obj[ReflectionData.Key_Category];
			
			cp.refreshViewValue();
			
			return cp;
		}
		
		public function getGapComponent(obj:Object):GapLineUI{
			var cp:GapLineUI = new GapLineUI;
			cp.width = this.width;
			cp.height = 3;
			cp.category = obj[ReflectionData.Key_Category];
			return cp;
		}
		
		public function getComboxComponent(obj:Object):ComLabelBox{
			var cb:ComLabelBox = new ComLabelBox;
			cb.label = obj[ReflectionData.Key_Label];;
			cb.width = this.width;
			cb.height = 18;
			cb.data = obj[ReflectionData.Key_Data];
			//cb.selectIndex = obj[ReflectionData.Key_SelectIndex];
			cb.getFun = obj[ReflectionData.Key_GetFun];
			cb.changFun = obj[ReflectionData.Key_SetFun];
			cb.category = obj[ReflectionData.Key_Category];
			
			cb.refreshViewValue();
			return cb;
		}
		
		public function getCheckComponent(obj:Object):CheckLabelBox{
			var ck:CheckLabelBox = new CheckLabelBox;
			ck.label = obj[ReflectionData.Key_Label];
			ck.width = this.width;
			ck.height = 18;
			
			ck.changFun = obj[ReflectionData.Key_SetFun];
			ck.getFun = obj[ReflectionData.Key_GetFun];
			ck.category = obj[ReflectionData.Key_Category];
			
			ck.refreshViewValue();
			return ck;
		}
		
		public function getVec3Component(obj:Object):TextVec3Input{
			var vc:TextVec3Input = new TextVec3Input;
			vc.category = obj[ReflectionData.Key_Category];
			vc.label = obj[ReflectionData.Key_Label];
			vc.changFun = obj[ReflectionData.Key_SetFun];
			vc.getFun = obj[ReflectionData.Key_GetFun];
			
			vc.refreshViewValue();
			return vc;
		}
		
		public function getVec2Component(obj:Object):TextVec2Input{
			var vc:TextVec2Input = new TextVec2Input;
			vc.category = obj[ReflectionData.Key_Category];
			vc.label = obj[ReflectionData.Key_Label];
			vc.changFun = obj[ReflectionData.Key_SetFun];
			vc.getFun = obj[ReflectionData.Key_GetFun];
			
		
			
			if(obj.hasOwnProperty(ReflectionData.Key_MaxNum)){
				vc.maxNum = obj[ReflectionData.Key_MaxNum];
			}
			if(obj.hasOwnProperty(ReflectionData.Key_MinNum)){
				vc.minNum = obj[ReflectionData.Key_MinNum];
			}
			
			
			
			vc.refreshViewValue();
			return vc;
		}
		
		public function getBtnComponent(obj:Object):LButton{
			var btn:LButton = new LButton;
			btn.category = obj[ReflectionData.Key_Category];
			btn.label = obj[ReflectionData.Key_Label];
			btn.changFun = obj[ReflectionData.Key_SetFun];
			btn.FunKey = obj.key
			//btn.height = 20;
			//btn.width = 100;
			btn.refreshViewValue();
			return btn;
		}
		
		
	}
}
import common.utils.frame.BaseComponent;

class CategoryMap{
	public var category:String;
	public var vec:Vector.<BaseComponent> = new Vector.<BaseComponent>;
}