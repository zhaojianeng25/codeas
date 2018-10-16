package modules.materials.treedata
{
	import modules.materials.view.BaseMaterialNodeUI;
	
	
	public class NodeTree
	{
		public static var OP:String = "op";
		public static var TEX:String = "tex";
		public static var ADD:String = "add";
		public static var SUB:String = "sub";
		public static var MUL:String = "mul";
		public static var DIV:String = "div";
		public static var RCP:String = "rcp";
		public static var MIN:String = "min";
		public static var MAX:String = "max";
		public static var FRC:String = "frc";
		public static var SQT:String = "sqt";
		public static var RSQ:String = "rsq";
		public static var POW:String = "pow";
		public static var LOG:String = "log";
		public static var EXP:String = "exp";
		public static var NRM:String = "nrm";
		public static var SIN:String = "sin";
		public static var COS:String = "cos";
		public static var CRS:String = "crs";
		public static var DP3:String = "dp3";
		public static var DP4:String = "dp4";
		public static var ABS:String = "abs";
		public static var NEG:String = "neg";
		public static var SAT:String = "sat";
		public static var LERP:String = "lerp";
		
		public static var VEC3:String = "vec3";
		public static var VEC2:String = "vec2";
		public static var FLOAT:String = "float";
		public static var TIME:String = "time";
		public static var TEXCOORD:String = "texcoord";
		public static var DYNVEC3:String = "dynvec3";
		public static var PTCOLOR:String = "ptColor";
		public static var VERCOLOR:String = "verColor";
		public static var HEIGHTINFO:String = "heightinfo";
		public static var FRESNEL:String = "fresnel";
		public static var REFRACTION:String = "refraction";
		public static var PANNER:String = "panner";
		
		
		public var id:int = -1;
		
		public var type:String;
		
		public var inputVec:Vector.<NodeTreeInputItem>;
		public var outputVec:Vector.<NodeTreeOutoutItem>;
		
		public var ui:BaseMaterialNodeUI;
		
		public var priority:int = -1;
		
		public var registerID:int;
		
		public var regResultTemp:RegisterItem;
		public var regResultConst:RegisterItem;
		public var regConstIndex:int;
		public var regResultTex:RegisterItem;
		
		public var shaderStr:String;
		
		private var _isDynamic:Boolean;
		public var canDynamic:Boolean;
		public var paramName:String;
		
		public function NodeTree()
		{
			inputVec = new Vector.<NodeTreeInputItem>;
			outputVec = new Vector.<NodeTreeOutoutItem>;
		}
		
		public function releaseUse():void{
			var allCompilde:Boolean = true;
			for(var i:int;i<outputVec.length;i++){
				var sunAry:Vector.<NodeTreeInputItem> = outputVec[i].sunNodeItems;
				var breakAble:Boolean = false;
				for(var j:int=0;j<sunAry.length;j++){
					if(!sunAry[j].hasCompiled){
						allCompilde = false;
						breakAble = true;
						break;
					}
				}
				if(breakAble){
					break;
				}
			}
			if(allCompilde){
				if(regResultTemp){
					regResultTemp.inUse = false;
				}
			}
		}
		
		public function getResultReg():RegisterItem{
			return regResultTemp;
		}
		public static var jsMode:Boolean = false;
		public static function getID($constID:int):String{
			if(NodeTree.jsMode){
				return "[" + $constID + "]";
			}else{
				return String($constID);
			}
			
		}
		
		public function getComponentID($id:int):String{
			if($id == 0){
				return  CompileOne.FT + this.regResultTemp.id + ".xyz";
			}else if($id == 1){
				return CompileOne.FT + this.regResultTemp.id + ".x";
			}else if($id == 2){
				return CompileOne.FT + this.regResultTemp.id + ".y";
			}else if($id == 3){
				return CompileOne.FT + this.regResultTemp.id + ".z";
			}else if($id == 4){
				return CompileOne.FT + this.regResultTemp.id + ".w";
			}else{
				return CompileOne.FT + this.regResultTemp.id;
			}
			return null;
		}
		
		public function addInput($in:NodeTreeItem):void{
			var initem:NodeTreeInputItem = $in as NodeTreeInputItem;
			if(!initem){
				throw new Error("转换失败");
			}
			inputVec.push(initem);
			initem.node = this;
			refreshID();
		}
		
		public function removeInput($in:NodeTreeItem):void{
			for(var i:int;i<inputVec.length;i++){
				if(inputVec[i] == $in){
					inputVec.splice(i,1);
					break;
				}
			}
			refreshID();
		}
		
		public function checkInput():Boolean{
			for(var i:int;i<inputVec.length;i++){
				if(!inputVec[i].parentNodeItem){
					return false;
				}
			}
			return true;
		}
		
		public function addOutput($in:NodeTreeItem):void{
			var initem:NodeTreeOutoutItem = $in as NodeTreeOutoutItem;
			if(!initem){
				throw new Error("转换失败");
			}
			outputVec.push(initem);
			initem.node = this;
			refreshID();
		}
		
		public function removeOutput($out:NodeTreeItem):void{
			for(var i:int;i<outputVec.length;i++){
				if(outputVec[i] == $out){
					outputVec.splice(i,1);
					break;
				}
			}
			
			refreshID();
		}
		
		public function refreshID():void{
			for(var i:int;i<inputVec.length;i++){
				inputVec[i].id = i;
			}
			
			for(i = 0;i<outputVec.length;i++){
				outputVec[i].id = i;
			}
		}
		
		public function getObj():Object{
			var obj:Object = new Object;
			obj.id = id;
			obj.type = type;
			obj.data = ui.getData();
			
			var inAry:Array = new Array;
			for(var i:int;i<inputVec.length;i++){
				inAry.push(inputVec[i].getObj());
			}
			obj.inAry = inAry;
			
			var outAry:Array = new Array;
			for(i = 0;i<outputVec.length;i++){
				outAry.push(outputVec[i].getObj())
			}
			obj.outAry = outAry;
			
			return obj;
		}
		
		public function toString():String{
			return  "id:" + this.id + "  type:" + this.type + "  priority:" + this.priority;
		}

		public function get isDynamic():Boolean
		{
			return _isDynamic;
		}

		public function set isDynamic(value:Boolean):void
		{
			_isDynamic = value;
		}
		


	}
	
}