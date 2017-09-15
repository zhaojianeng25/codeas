package modules.materials.treedata
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import materials.ConstItem;
	import materials.MaterialBaseData;
	import materials.MaterialTree;
	import materials.TexItem;
	
	import modules.materials.treedata.nodetype.NodeTreeFloat;
	import modules.materials.treedata.nodetype.NodeTreeMin;
	import modules.materials.treedata.nodetype.NodeTreeOP;
	import modules.materials.treedata.nodetype.NodeTreePanner;
	import modules.materials.treedata.nodetype.NodeTreeTex;
	import modules.materials.treedata.nodetype.NodeTreeTime;
	import modules.materials.treedata.nodetype.NodeTreeVec2;
	import modules.materials.treedata.nodetype.NodeTreeVec3;
	import modules.materials.view.MaterialItemType;

	/**
	 * 
	 * @author LYF
	 * 
	 * 
	 * half DielectricSpecular = 0.08 * SpecularScale;
	 * half3 DiffuseColor = BaseColor * (1 - Metallic);
	 * half3 SpecularColor = DielectricSpecular * (1 - Metallic) + BaseColor * Metallic;

	 * lod = getMipLevelFromRoughness(roughness)
	 * prefilteredColor =  textureCube(PrefilteredEnvMap, refVec, lod)
	 * envBRDF = texture2D(BRDFIntegrationMap,vec2(roughness, ndotv)).xy
	 * indirectSpecular = prefilteredColor * (specularColor * envBRDF.x + envBRDF.y) * SpecularScale;
	 * 
	 * result = DiffuseColor + indirectSpecular;
	 */	
	public class CompileOne
	{
		
		public static var SPACE:String = " ";
		public static var COMMA:String = ",";
		public static var FC:String = "fc";
		public static var FT:String = "ft";
		public static var FS:String = "fs";
		public static var VI:String = "v";
		public static var OP:String = "op";
		public static var FO:String = "oc";
		public static var XYZ:String = ".xyz";
		public static var XY:String = ".xy";
		public static var X:String = ".x";
		public static var Y:String = ".y";
		public static var Z:String = ".z";
		public static var W:String = ".w";
		public static var ZW:String = ".zw";
		public static var MOV:String = "mov";
		public static var ZERO:String = "0";
		public static var ONE:String = "1";
		public static var TWO:String = "2";
		public static var THREE:String = "3";
		public static var FOUR:String = "4";
		public static var LN:String = "\n";
		public static var texType:String = "<2d,linear,repeat>";
		public static var TEX_2D:String = "2d";
		public static var TEX_CUBE:String = "cube";
		public static var TEX_LINEAR:String = "linear";
		public static var TEX_NEAREST:String = "nearest";
		public static var TEX_WRAP_REPEAT:String = "repeat";
		public static var TEX_WRAP_CLAMP:String = "clamp";
		public static var TEX_MIP_NONE:String = "mipnone";
		public static var TEX_MIP_NEAREST:String = "mipnearest";
		public static var TEX_MIP_LINEAR:String = "miplinear";
		public static var LEFT_BRACKET:String = "<";
		public static var RIGHT_BRACKET:String = ">";
		public static var texCubeType:String = "<cube,clamp,linear,mipnone>";
		
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
		public static var KIL:String = "kil";
		public static var M33:String = "m33";
		
		
		
		public var priorityList:Vector.<Vector.<NodeTree>>;
		
		private var fragmentTempList:Vector.<RegisterItem>;
		private var fragmentTexList:Vector.<RegisterItem>;
		private var fragmentConstList:Vector.<RegisterItem>;
		
		private var defaultUvReg:RegisterItem;
		private var defaultLightUvReg:RegisterItem;
		private var defaultPtReg:RegisterItem;
		private var defaultLutReg:RegisterItem;
		private var defaultTangent:RegisterItem;
		private var defaultPosReg:RegisterItem;
		//private var defaultBinormal:RegisterItem;
		
		private var strVec:Vector.<String>;
		private var texVec:Vector.<TexItem>;
		private var constVec:Vector.<ConstItem>;
		private var hasTime:Boolean;
		private var timeSpeed:Number;
		private var blendMode:int;
		private var writeZbuffer:Boolean;
		private var backCull:Boolean;
		private var killNum:Number;
		private var hasVertexColor:Boolean;
		private var usePbr:Boolean;
		private var useNormal:Boolean;
		private var roughness:Number;
		private var hasFresnel:Boolean;
		private var useDynamicIBL:Boolean;
		private var normalScale:Number;
		private var lightProbe:Boolean;
		private var directLight:Boolean;
		private var noLight:Boolean;
		private var fogMode:int;
		private var scaleLightMap:Boolean;
		private var hasAlpha:Boolean;
		
		public var materialBaseData:MaterialBaseData;
		public function CompileOne()
		{
			initReg();
			
			defaultUvReg = new RegisterItem(0);
			defaultPtReg = new RegisterItem(1);
			defaultLightUvReg = new RegisterItem(2);
			defaultLutReg = new RegisterItem(3);
			defaultTangent = new RegisterItem(4);
			defaultPosReg = new RegisterItem(5);
		}
		
		private function initReg():void{
			fragmentTempList = new Vector.<RegisterItem>;
			fragmentTexList = new Vector.<RegisterItem>;
			fragmentConstList = new Vector.<RegisterItem>;
			for(var i:int=0;i<8;i++){
				fragmentTempList.push(new RegisterItem(i));
				fragmentTexList.push(new RegisterItem(i));
			}
			
			for(i=0;i<28;i++){
				fragmentConstList.push(new RegisterItem(i));
			}
			
		}
		
		
		public function getFragmentTemp():RegisterItem{
			for(var i:int;i<fragmentTempList.length;i++){
				if(!fragmentTempList[i].inUse){
					fragmentTempList[i].inUse = true;
					return fragmentTempList[i];
				}
			}
			return null;
		}
		
		public function getFragmentTex(url:String=null):RegisterItem{
			for(var i:int;i<fragmentTexList.length;i++){
				if(url){
					if(fragmentTexList[i].inUse && fragmentTexList[i].url == url){
						return fragmentTexList[i];
					}
				}
				if(!fragmentTexList[i].inUse){
					fragmentTexList[i].inUse = true;
					fragmentTexList[i].url = url;
					return fragmentTexList[i];
				}
			}
			return null;
		}
		
		public function setFragmentConst($nodeTree:NodeTree):void{
			for(var i:int=5;i<fragmentConstList.length;i++){
				var tf:Boolean = fragmentConstList[i].getUse($nodeTree);
				if(tf){
					break;
				}
			}
		}
		
		public function compile($priorityList:Vector.<Vector.<NodeTree>>,$materialTree:MaterialTree):void{
			NodeTree.jsMode = false;
			
			priorityList = $priorityList;
			strVec = new Vector.<String>;
			texVec = new Vector.<TexItem>;
			constVec = new Vector.<ConstItem>;
			hasTime = false;
			hasVertexColor = false;
			usePbr = false;
			useNormal = false;
			roughness = 0;
			hasFresnel = false;
			useDynamicIBL = false;
			lightProbe = false;
			directLight = false;
			noLight = false;
			fogMode = 0;
			scaleLightMap = false;
			hasAlpha = false;
			this.materialBaseData = new MaterialBaseData;
			
			//processDefaultFc();
			
			for(var i:int = priorityList.length -1;i >= 0;i--){
				var treelist:Vector.<NodeTree> = priorityList[i];
				for(var j:int=0;j<treelist.length;j++){
					processNode(treelist[j]);
				}
			}
			
			var resultStr:String = new String;
			for(i=0;i<strVec.length;i++){
				resultStr += strVec[i] + "\n";
			}
			
			processMainTex();
			
			$materialTree.shaderStr = resultStr;
			$materialTree.constList = constVec;
			$materialTree.texList = texVec;
			$materialTree.hasTime = hasTime;
			$materialTree.timeSpeed = timeSpeed;
			$materialTree.blendMode = blendMode;
			$materialTree.backCull = backCull;
			$materialTree.killNum = killNum;
			$materialTree.hasVertexColor = hasVertexColor;
			$materialTree.usePbr = usePbr;
			$materialTree.useNormal = useNormal;
			$materialTree.roughness = roughness;
			$materialTree.writeZbuffer = writeZbuffer;
			$materialTree.hasFresnel = hasFresnel;
			$materialTree.useDynamicIBL = useDynamicIBL;
			$materialTree.normalScale = normalScale;
			$materialTree.lightProbe = lightProbe;
			$materialTree.directLight = directLight;
			$materialTree.noLight = noLight;
			$materialTree.fogMode = fogMode;
			$materialTree.hasAlpha = hasAlpha;
			$materialTree.scaleLightMap = scaleLightMap;
			$materialTree.materialBaseData = this.materialBaseData;
			
			$materialTree.dispatchEvent(new Event(Event.CHANGE));
			trace("all Shader");
			trace(resultStr);
			trace("compile Complete");
			
		}
		
		private function processMainTex():void{
			var flag:Boolean;
			for(var i:int;i<texVec.length;i++){
				if(texVec[i].isMain){
					flag = true;
				}
			}
			
			if(!flag){
				if(texVec.length){
					texVec[0].isMain = true;
				}
			}
			
		}
		
		public function processDefaultFc():void{
			var constItem:ConstItem = new ConstItem;
			constItem.id = 0;
			constItem.value = new Vector3D(1,0,0,0);
			constVec.push(constItem);
		}
		
		public function processNode($node:NodeTree):void{
			switch($node.type){
				case NodeTree.VEC3:
				case NodeTree.FLOAT:
				case NodeTree.VEC2:
					processVec3Node($node);
					break;
				case NodeTree.TEX:
					processTexNode($node);
					break;
				case NodeTree.MUL:
					processDynamicNode($node,MUL);
				break;
				case NodeTree.ADD:
					processDynamicNode($node,ADD);
				break;
				case NodeTree.SUB:
					processDynamicNode($node,SUB);
				break;
				case NodeTree.DIV:
					processDynamicNode($node,DIV);
				break;
				case NodeTree.OP:
					processOpNode($node);
				break;
				case NodeTree.TIME:
					processTimeNode($node);
				break;
				case NodeTree.SIN:
					processStaticNode($node,SIN);
				break;
				case NodeTree.LERP:
					processLerpNode($node);
				break;
				case NodeTree.PTCOLOR:
					processParticleColor($node);
					break;
				case NodeTree.VERCOLOR:
					hasVertexColor = true;
					break;
				case NodeTree.HEIGHTINFO:
					processHeightInfo($node);
					break;
				case NodeTree.FRESNEL:
					processFresnel($node);
					break;
				case NodeTree.REFRACTION:
					processRefraction($node);
					break;
				case NodeTree.PANNER:
					processPanner($node);
					break;
				case NodeTree.MIN:
					processMathMinNode($node);
					break;
			}
			
		}
		
		private function preSetNormal():void{
			for(var i:int = priorityList.length -1;i >= 0;i--){
				var treelist:Vector.<NodeTree> = priorityList[i];
				for(var j:int=0;j<treelist.length;j++){
					if(treelist[j].type == NodeTree.OP){
						
						var inputMetallic:NodeTreeInputItem = treelist[j].inputVec[1];
						var inputSpecular:NodeTreeInputItem = treelist[j].inputVec[2];
						var inputRoughness:NodeTreeInputItem = treelist[j].inputVec[3];
						var inputNormal:NodeTreeInputItem = treelist[j].inputVec[4];
						
						if(inputMetallic.parentNodeItem || inputSpecular.parentNodeItem || inputRoughness.parentNodeItem){
							usePbr = true;
						}else{
							usePbr = false;
						}
						
						if(inputNormal.parentNodeItem){
							useNormal = true;
						}else{
							useNormal = false;
						}
						
						return;
					}
				}
			}
		}
		
		public function processFresnel($node:NodeTree):void{
			
			
			preSetNormal();
			
			var str:String = new String;
			//var input0:NodeTreeInputItem = $node.inputVec[0];
			var input1:NodeTreeInputItem = $node.inputVec[0];
			var input2:NodeTreeInputItem = $node.inputVec[1];
			
			
			//var pNode0:NodeTree = input0.parentNodeItem.node;
			var pNode1:NodeTree = input1.parentNodeItem.node;
			var pNode2:NodeTree = input2.parentNodeItem.node;
			
//			var output:NodeTreeOutoutItem = $node.outputVec[0];
			
			var regtemp:RegisterItem = getFragmentTemp();
			
			var normalID:int;
			if(usePbr){
				if(useNormal){
					normalID = 7;
				}else{
					normalID = defaultTangent.id;
				}
			}else{
				normalID = defaultTangent.id;
			}
			
			str = SUB + SPACE + FT + regtemp.id + XYZ + COMMA + FC + TWO + XYZ + COMMA + VI + defaultPtReg.id + XYZ + LN;
			str += NRM + SPACE + FT + regtemp.id + XYZ + COMMA + FT + regtemp.id + XYZ + LN;
			str += DP3 + SPACE + FT + regtemp.id + X + COMMA + FT + regtemp.id + XYZ + COMMA + VI + normalID + XYZ + LN; 
			
			str += SUB + SPACE + FT + regtemp.id + X + COMMA + FC + ZERO + X + COMMA + FT + regtemp.id + X + LN;
			str += ADD + SPACE + FT + regtemp.id + X + COMMA + FT + regtemp.id + X + COMMA + pNode2.getComponentID(input2.parentNodeItem.id) + LN;
			str += SAT + SPACE + FT + regtemp.id + X + COMMA + FT + regtemp.id + X + LN;
			str += MUL + SPACE + FT + regtemp.id + X + COMMA + FT + regtemp.id + X + COMMA + pNode1.getComponentID(input1.parentNodeItem.id);
			//str += MUL + SPACE + FT + regtemp.id + XYZ + COMMA + pNode0.getComponentID(input0.parentNodeItem.id) + COMMA + FT + regtemp.id + X;
			
			
			input2.hasCompiled = true;
			input1.hasCompiled = true;
			
			pNode2.releaseUse();
			pNode1.releaseUse();
			
			$node.regResultTemp = regtemp;
			$node.shaderStr = str;
			strVec.push(str);
			this.hasFresnel = true;
		}
		public function processPanner($node:NodeTree):void{
			var str:String = new String;
			var input1:NodeTreeInputItem = $node.inputVec[0];
			var input2:NodeTreeInputItem = $node.inputVec[1];
			
			
			var regtemp:RegisterItem = getFragmentTemp();
			var regtemp2:RegisterItem = getFragmentTemp();
			
			var pNode1:NodeTree;
			if(input1.parentNodeItem){
				pNode1 = input1.parentNodeItem.node;
				str += MUL + SPACE + FT + regtemp.id + XY + COMMA + VI + defaultUvReg.id + XY + COMMA + pNode1.getComponentID(input1.parentNodeItem.id) + LN;
			}else{
				pNode1 = new NodeTreeVec2;
				pNode1.type = NodeTree.VEC2;
				NodeTreeVec2(pNode1).constValue = NodeTreePanner($node).coordinateValue;
				processVec3Node(pNode1);
				str += MUL + SPACE + FT + regtemp.id + XY + COMMA + VI + defaultUvReg.id + XY + COMMA + pNode1.getComponentID(0) + LN;
			}
			
			str += MOV + SPACE + FT + regtemp.id + Z + COMMA + FC + ZERO + W + LN;
			
			var pNode2:NodeTree;
			if(input2.parentNodeItem){
				pNode2 = input2.parentNodeItem.node;
				str += MUL + SPACE + FT + regtemp2.id + XY + COMMA + pNode2.getComponentID(input2.parentNodeItem.id) + COMMA + FT + regtemp.id + Z + LN;
			}else{
				pNode2 = new NodeTreeVec2;
				pNode2.type = NodeTree.VEC2;
				NodeTreeVec2(pNode2).constValue = NodeTreePanner($node).speedValue;
				processVec3Node(pNode2);
				str += MUL + SPACE + FT + regtemp2.id + XY + COMMA + pNode2.getComponentID(0) + COMMA + FT + regtemp.id + Z + LN;
			}
			
			
			str += ADD + SPACE + FT + regtemp.id + XY + COMMA + FT + regtemp.id + XY + COMMA + FT + regtemp2.id + XY;
			
			regtemp2.inUse = false;
			
			hasTime = true;
			timeSpeed = 0.001;
			
			$node.regResultTemp = regtemp;
			$node.shaderStr = str;
			strVec.push(str);
			pNode1.releaseUse();
			pNode2.releaseUse();
		}
		public function processRefraction($node:NodeTree):void{
			var str:String = new String;
			
			var regtex:RegisterItem = getFragmentTex();
			var regtemp:RegisterItem = getFragmentTemp();
			
			var input:NodeTreeInputItem = $node.inputVec[0];
			
			str = MOV + SPACE + FT + regtemp.id + COMMA + VI + "7" + LN;
			str += DIV + SPACE + FT + regtemp.id + XY + COMMA + FT + regtemp.id + XY + COMMA + FT + regtemp.id + Z + LN;
			str += ADD + SPACE + FT + regtemp.id + XY + COMMA + FT + regtemp.id + XY + COMMA + FC + FOUR + XY + LN;
			str += DIV + SPACE + FT + regtemp.id + XY + COMMA + FT + regtemp.id + XY + COMMA + FC + FOUR + ZW + LN;
			
			
			if(input.parentNodeItem){
				var pNode:NodeTree = input.parentNodeItem.node;
				str += ADD + SPACE + FT + regtemp.id + XY + COMMA + FT + regtemp.id + XY + COMMA + pNode.getComponentID(input.parentNodeItem.id) + LN;
			}
			
			str += TEX + SPACE + FT + regtemp.id + COMMA + FT + regtemp.id + XY + COMMA + FS + regtex.id + SPACE + getTexType(1);
			
			strVec.push(str);
			
			
			$node.regResultTemp = regtemp;
			$node.regResultTex = regtex;
			$node.shaderStr = str;
			
			var texItem:TexItem = new TexItem;
			texItem.id = regtex.id;
			texItem.type = TexItem.REFRACTIONMAP;
			texItem.isDynamic = false;
			texVec.push(texItem);
			
			if(pNode){
				pNode.releaseUse();
			}
		}
		
		public function processHeightInfo($node:NodeTree):void{
			var str:String = new String;
			
			var regtex:RegisterItem = getFragmentTex();
			var regtemp:RegisterItem = getFragmentTemp();
			
			var input:NodeTreeInputItem = $node.inputVec[0];
			
			if(input.parentNodeItem){
				var pNode:NodeTree = input.parentNodeItem.node;
				str = TEX + SPACE + FT + regtemp.id + COMMA + pNode.getComponentID(input.parentNodeItem.id) + COMMA + FS + regtex.id + SPACE + getTexType(0);
			}else{
				str = TEX + SPACE + FT + regtemp.id + COMMA + VI + defaultUvReg.id + COMMA + FS + regtex.id + SPACE + getTexType(0);
			}
			strVec.push(str);
			//str = DIV + SPACE + FT + regtemp.id + XYZ +  COMMA + FT + regtemp.id + XYZ + COMMA + FT + regtemp.id + W;
			//strVec.push(str);
			
			
			$node.regResultTemp = regtemp;
			$node.regResultTex = regtex;
			$node.shaderStr = str;
			
			
			var texItem:TexItem = new TexItem;
			texItem.id = regtex.id;
			texItem.type = TexItem.HEIGHTMAP;
			texItem.isDynamic = false;
			texVec.push(texItem);
			
			if(pNode){
				pNode.releaseUse();
			}
			
		}
		
		public function processVec3Node($node:NodeTree):void{
			var str:String = new String;
			setFragmentConst($node);
			addConstItem($node);
		}
		
		public function processTimeNode($node:NodeTree):void{
			var str:String = new String;
			var regtemp:RegisterItem = getFragmentTemp();
			
			var pNode:NodeTreeFloat = new NodeTreeFloat;
			pNode.type = NodeTree.FLOAT;
			pNode.constValue = NodeTreeTime($node).speed;
			processVec3Node(pNode);
			
			str += MOV + SPACE + FT + regtemp.id + X + COMMA + FC + ZERO + W + LN;
			str += MUL + SPACE + FT + regtemp.id + X + COMMA  + pNode.getComponentID(0) + COMMA + FT + regtemp.id + X;
			strVec.push(str);
			$node.regResultTemp = regtemp;
			hasTime = true;
			timeSpeed = 0.001;
		}
		
		public function processMathMinNode($node:NodeTree):void{
			var str:String = new String;
			var regtemp:RegisterItem = getFragmentTemp();
			
			var vcNode:NodeTreeFloat = new NodeTreeFloat;
			vcNode.type = NodeTree.FLOAT;
			vcNode.constValue = NodeTreeMin($node).value;
			processVec3Node(vcNode);
			
			var input:NodeTreeInputItem = $node.inputVec[0];
			var pNode:NodeTree = input.parentNodeItem.node;
			
			str = MIN + SPACE + FT + regtemp.id + X + COMMA + pNode.getComponentID(input.parentNodeItem.id) + COMMA + vcNode.getComponentID(0);
			input.hasCompiled = true;
			pNode.releaseUse();
			
			strVec.push(str);
			$node.regResultTemp = regtemp;
			
		}
		
		public function addConstItem($node:NodeTree):void{
			if($node.isDynamic){
				trace($node.paramName);
			}
			var constItem:ConstItem;
			
			var id:int = $node.regResultConst.id;
			
			for(var i:int=0;i<constVec.length;i++){
				if(constVec[i].id == id){
					constItem = constVec[i];
				}
			}
			
			if(!constItem){
				constItem = new ConstItem;
				constItem.id = $node.regResultConst.id;
				constVec.push(constItem);
			}
			
			
			if($node.type == NodeTree.VEC3){
				if($node.regConstIndex == 0){
					var v3d:Vector3D = NodeTreeVec3($node).constVec3;
					constItem.value.setTo(v3d.x,v3d.y,v3d.z);
					if($node.isDynamic){
						constItem.paramName0 = $node.paramName;
						constItem.param0Type = 4;
						constItem.param0Index = 0;
					}
				}
			}else if($node.type == NodeTree.FLOAT){
				var num:Number = NodeTreeFloat($node).constValue;
				if($node.regConstIndex == 0){
					constItem.value.x = num;
					if($node.isDynamic){
						constItem.paramName0 = $node.paramName;
						constItem.param0Type = 1;
						constItem.param0Index = 0;
					}
				}else if($node.regConstIndex == 1){
					constItem.value.y = num;
					if($node.isDynamic){
						constItem.paramName1 = $node.paramName;
						constItem.param1Type = 1;
						constItem.param1Index = 1;
					}
				}else if($node.regConstIndex == 2){
					constItem.value.z = num;
					if($node.isDynamic){
						constItem.paramName2 = $node.paramName;
						constItem.param2Type = 1;
						constItem.param2Index = 2;
					}
				}else if($node.regConstIndex == 3){
					constItem.value.w = num;
					if($node.isDynamic){
						constItem.paramName3 = $node.paramName;
						constItem.param3Type = 1;
						constItem.param3Index = 3;
					}
				}
			}else if($node.type == NodeTree.VEC2){
				var vec2:Point = NodeTreeVec2($node).constValue;
				if($node.regConstIndex == 0){
					constItem.value.x = vec2.x;
					constItem.value.y = vec2.y;
					if($node.isDynamic){
						constItem.paramName0 = $node.paramName;
						constItem.param0Type = 2;
						constItem.param0Index = 0;
					}
				}else if($node.regConstIndex == 1){
					constItem.value.y = vec2.x;
					constItem.value.z = vec2.y;
					if($node.isDynamic){
						constItem.paramName1 = $node.paramName;
						constItem.param1Type = 2;
						constItem.param1Index = 1;
					}
				}else if($node.regConstIndex == 2){
					constItem.value.z = vec2.x;
					constItem.value.w = vec2.y;
					if($node.isDynamic){
						constItem.paramName2 = $node.paramName;
						constItem.param2Type = 2;
						constItem.param2Index = 2;
					}
				}
			}
			
			constItem.creat();
			
		}
		
		
		public function processOpNode($node:NodeTree):void{
			
//			float DielectricSpecular = 0.08 * SpecularScale;
//			vec3 DiffuseColor = BaseColor * (1 - Metallic);
//			vec3 SpecularColor = DielectricSpecular * (1 - Metallic) + BaseColor * Metallic;
//			
//			float lod = getMipLevelFromRoughness(roughness)
//			vec3 prefilteredColor =  textureCube(PrefilteredEnvMap, refVec, lod)
//			vec2 envBRDF = texture2D(BRDFIntegrationMap,vec2(roughness, ndotv)).xy
//			vec3 indirectSpecular = prefilteredColor * (specularColor * envBRDF.x + envBRDF.y) * SpecularScale;
//			 
//			vec3 result = DiffuseColor + indirectSpecular;
			
			this.lightProbe = NodeTreeOP($node).lightProbe;
			this.directLight = NodeTreeOP($node).directLight;
			this.noLight = NodeTreeOP($node).noLight;
			this.fogMode = NodeTreeOP($node).fogMode;
			this.scaleLightMap = NodeTreeOP($node).scaleLightMap;
			
			var str:String = new String;
			var inputDiffuse:NodeTreeInputItem = $node.inputVec[0];
			var inputEmissive:NodeTreeInputItem = $node.inputVec[9];
			var inputMetallic:NodeTreeInputItem = $node.inputVec[1];
			var inputSpecular:NodeTreeInputItem = $node.inputVec[2];
			var inputRoughness:NodeTreeInputItem = $node.inputVec[3];
			var inputNormal:NodeTreeInputItem = $node.inputVec[4];
			
			if(!inputDiffuse.parentNodeItem && !inputEmissive.parentNodeItem){
				trace("can not find diffuse or emissive");
				return;
			}
			
			if(inputDiffuse.parentNodeItem){
				var mNode:NodeTree = inputDiffuse.parentNodeItem.node;
				if(mNode is NodeTreeVec3){
					this.materialBaseData.baseColor = NodeTreeVec3(mNode).constVec3;
				}else if(mNode is NodeTreeTex){
					this.materialBaseData.baseColorUrl = NodeTreeTex(mNode).url;
					
				}
			}
			
			if(inputMetallic.parentNodeItem || inputSpecular.parentNodeItem || inputRoughness.parentNodeItem){
				usePbr = true;
				trace("use PBR!");
				
				if(inputMetallic.parentNodeItem){
					mNode = inputMetallic.parentNodeItem.node
					if(mNode is NodeTreeFloat){
						this.materialBaseData.metallic = NodeTreeFloat(mNode).constValue
					}else{
						this.materialBaseData.metallic = 0.5;
					}
				}else{
					this.materialBaseData.metallic = 0.5;
				}
				
				if(inputSpecular.parentNodeItem){
					mNode = inputSpecular.parentNodeItem.node
					if(mNode is NodeTreeFloat){
						this.materialBaseData.specular = NodeTreeFloat(mNode).constValue
					}else{
						this.materialBaseData.specular = 0.5;
					}
				}else{
					this.materialBaseData.specular = 0.5;
				}
				
				if(inputRoughness.parentNodeItem){
					mNode = inputRoughness.parentNodeItem.node
					if(mNode is NodeTreeFloat){
						this.materialBaseData.roughness = NodeTreeFloat(mNode).constValue
					}else{
						this.materialBaseData.roughness = 0.5;
					}
				}else{
					this.materialBaseData.roughness = 0.5;
				}
				

			}else{
				usePbr = false;
			}
			
			this.materialBaseData.usePbr = usePbr;
			
			if(inputNormal.parentNodeItem){
				useNormal = true;
				mNode = inputNormal.parentNodeItem.node
				if(mNode is NodeTreeTex){
					this.materialBaseData.normalUrl = NodeTreeTex(mNode).url;
				}
				
			}else{
				useNormal = false;
			}
			
			useDynamicIBL = NodeTreeOP($node).useDynamicIBL;
			
			var regOp:RegisterItem;
			var texItem:TexItem;
			
			//traceFt();
			
			var hasDiffuse:Boolean = false;
			if(NodeTreeOP($node).isUseLightMap && inputDiffuse.parentNodeItem){//漫反射部分
				
				hasDiffuse = true;
				
				var pNodeDiffuse:NodeTree = inputDiffuse.parentNodeItem.node;//diffuse输入节点
				
				//tex lightMap lightColor
				
				var regtempLightMap:RegisterItem = getFragmentTemp();
				if(this.lightProbe){
					str = MOV + SPACE + FT + regtempLightMap.id + COMMA + VI + defaultLightUvReg.id + LN; 
					str += MUL + SPACE + FT + regtempLightMap.id + XYZ + COMMA + FT + regtempLightMap.id + XYZ + COMMA + FC + THREE + X;
					strVec.push(str);
				}else if(this.directLight){
					
//					MOV + SPACE + FT + regtempLightMap.id + COMMA + VI + defaultLightUvReg.id; 
//					MUL + SPACE + FT + regtempLightMap.id + XYZ + COMMA + FT + regtempLightMap.id + XYZ + COMMA + FC + THREE + X;
					str = MOV + SPACE + FT + regtempLightMap.id + COMMA + VI + defaultLightUvReg.id; 
					strVec.push(str);
				}else if(this.noLight){
					
				}else{
					var regtexLightMap:RegisterItem = getFragmentTex();
					str = TEX + SPACE + FT + regtempLightMap.id + COMMA + VI + defaultLightUvReg.id + COMMA + FS + regtexLightMap.id + SPACE + texType + LN;
					str += MUL + SPACE + FT + regtempLightMap.id + XYZ + COMMA + FT + regtempLightMap.id + XYZ + COMMA + FC + THREE + X;
					strVec.push(str);
					texItem = new TexItem;
					texItem.id = regtexLightMap.id;
					texItem.type = TexItem.LIGHTMAP;
					texVec.push(texItem);
				}
				if(this.noLight){
					//str = MOV + SPACE + FT + regtempLightMap.id + COMMA + VI + defaultUvReg.id + LN;
					if(this.directLight){
						str = MUL + SPACE + FT + regtempLightMap.id +  COMMA+ COMMA + VI + defaultLightUvReg.id
						str = MUL + SPACE + FT + regtempLightMap.id + XYZ + COMMA + FT + regtempLightMap.id + XYZ + COMMA +  pNodeDiffuse.getComponentID(inputDiffuse.parentNodeItem.id);
					}else{
						str = MOV + SPACE + FT + regtempLightMap.id + COMMA + pNodeDiffuse.getComponentID(5);
					}
					
				}else{
					str = MUL + SPACE + FT + regtempLightMap.id + XYZ + COMMA + FT + regtempLightMap.id + XYZ + COMMA +  pNodeDiffuse.getComponentID(inputDiffuse.parentNodeItem.id);
				}
				
				strVec.push(str);
				
				
				if(usePbr){
					
					var regtempPbr:RegisterItem = getFragmentTemp();
					
					var pNodeNormal:NodeTree;
					var regtempNormal:RegisterItem;
					regtempNormal = getFragmentTemp();
					if(useNormal){
						pNodeNormal = inputNormal.parentNodeItem.node; // normal * 2 - 1
						str = MUL + SPACE + FT + regtempNormal.id + XYZ + COMMA + pNodeNormal.getComponentID(inputNormal.parentNodeItem.id) + COMMA + FC + ZERO + Y + LN;
						str += SUB + SPACE + FT +  regtempNormal.id + XYZ + COMMA + FT + regtempNormal.id + XYZ + COMMA + FC + ZERO + X;
						strVec.push(str);
						
						str = M33 + SPACE + FT +  regtempNormal.id + XYZ + COMMA + FT +  regtempNormal.id + XYZ + COMMA + VI + defaultTangent.id + LN;
						str += NRM + SPACE + FT + regtempNormal.id + XYZ + COMMA + FT + regtempNormal.id + XYZ;
						strVec.push(str);
						
						inputNormal.hasCompiled = true;
						pNodeNormal.releaseUse();
					}else{
						str = MOV + SPACE + FT + regtempNormal.id + XYZ + COMMA + VI + defaultTangent.id + XYZ;
						strVec.push(str);
					}
					
					
					//trace(str);
					//traceFt();
					
					
					
					//SpecularColor = 0.08 * SpecularScale * (1-metallic) + basecolor * metallic
					var pNodeMetallic:NodeTree;
					if(inputMetallic.parentNodeItem){//basecolor * metallic
						pNodeMetallic = inputMetallic.parentNodeItem.node;
						str = MUL + SPACE + FT + regtempPbr.id + XYZ + COMMA + FT + regtempLightMap.id + XYZ + COMMA + pNodeMetallic.getComponentID(inputMetallic.parentNodeItem.id);
					}else{
						str = MUL + SPACE + FT + regtempPbr.id + XYZ + COMMA + FT + regtempLightMap.id + XYZ + COMMA + FC + ONE + Y;
					}
					//trace(str);
					strVec.push(str);
					
					//0.08 * SpecularScale * (1-metallic)
					
					//(1-metallic)
					
					var regtempMetallic:RegisterItem = getFragmentTemp();
					
					//traceFt();
					
					str = MOV + SPACE + FT + regtempMetallic.id + X + COMMA + FC + ZERO + X + LN;
					if(pNodeMetallic){
						str += SUB + SPACE + FT + regtempMetallic.id + X + COMMA + FT + regtempMetallic.id + X + COMMA + pNodeMetallic.getComponentID(inputMetallic.parentNodeItem.id);
						//inputMetallic.hasCompiled = true;
						//pNodeMetallic.releaseUse();
					}else{
						str += SUB + SPACE + FT + regtempMetallic.id + X + COMMA + FT + regtempMetallic.id + X + COMMA + FC + ONE + Y;
					}
					//trace(str);
					strVec.push(str);
					
					//SpecularScale * (1-metallic)
					var pNodeSpecular:NodeTree;
					if(inputSpecular.parentNodeItem){
						pNodeSpecular = inputSpecular.parentNodeItem.node;
						str = MUL + SPACE + FT + regtempMetallic.id + X + COMMA + FT + regtempMetallic.id + X + COMMA + pNodeSpecular.getComponentID(inputSpecular.parentNodeItem.id);
						inputSpecular.hasCompiled = true;
						//pNodeSpecular.releaseUse();
					}else{
						str = MUL + SPACE + FT + regtempMetallic.id + X + COMMA + FT + regtempMetallic.id + X + COMMA + FC + ONE + Y;
					}
					//trace(str);
					strVec.push(str);
					
					//0.08 * SpecularScale * (1-metallic)
					str = MUL + SPACE + FT + regtempMetallic.id + X + COMMA + FT + regtempMetallic.id + X + COMMA + FC + ONE + X;
					//trace(str);
					strVec.push(str);
					
					//SpecularColor = 0.08 * SpecularScale * (1-metallic) + basecolor * metallic
					str = ADD + SPACE + FT + regtempPbr.id + XYZ + COMMA + FT + regtempPbr.id + XYZ + COMMA + FT + regtempMetallic.id + X;
					//trace(str);
					strVec.push(str);
					
					regtempMetallic.inUse = false;
					
					
					//traceFt();
					// tex envBrdf
					var regtexEnvBRDF:RegisterItem = getFragmentTex();
					var regtempEnvBRDF:RegisterItem = getFragmentTemp();//defaultLutReg
					//traceFt();
					if(useNormal || true){
						//"mov vt3.x,vc13.y\n" + //粗糙度
						//"sub vt1,vc12,vt0\n" + //cos = dot(N,V)
						//"nrm vt1.xyz,vt1.xyz\n" +
						//"mov ft1.x,fc7.z\n" + 
						//"dp3 ft1.y,vi2.xyz,ft3.xyz \n"+
						str = SUB + SPACE + FT + regtempEnvBRDF.id + XYZ + COMMA + FC + TWO + XYZ + COMMA + VI + defaultPtReg.id + XYZ + LN;
						str += NRM + SPACE + FT + regtempEnvBRDF.id + XYZ + COMMA + FT + regtempEnvBRDF.id + XYZ + LN;
						str += DP3 + SPACE + FT + regtempEnvBRDF.id + Y + COMMA + FT + regtempEnvBRDF.id + XYZ + COMMA + FT + regtempNormal.id + XYZ  + LN; 
						
						var pNodeRoughness:NodeTree;
						if(inputRoughness.parentNodeItem){
							pNodeRoughness = inputRoughness.parentNodeItem.node;
							if(pNodeRoughness is NodeTreeFloat){
								roughness = NodeTreeFloat(pNodeRoughness).constValue;
							}else{
								roughness = 0.5;
							}
							str += MOV + SPACE + FT + regtempEnvBRDF.id + X + COMMA +  pNodeRoughness.getComponentID(inputRoughness.parentNodeItem.id) + LN;
							inputRoughness.hasCompiled = true;
							pNodeRoughness.releaseUse();
						}else{
							roughness = 0.5;
							str += MOV + SPACE + FT + regtempEnvBRDF.id + X + COMMA + FC + TWO + W + LN;
						}
						
						
						str += TEX + SPACE + FT + regtempEnvBRDF.id + COMMA + FT + regtempEnvBRDF.id + XY + COMMA + FS + regtexEnvBRDF.id + SPACE + texType;
						//trace(str);
					}
					strVec.push(str);
					texItem = new TexItem;
					texItem.id = regtexEnvBRDF.id;
					texItem.type = TexItem.LTUMAP;
					//trace(str);
					texVec.push(texItem);
					
					//SpecularColor * envBrdf.x + envBrdf.y
					str = MUL + SPACE + FT + regtempPbr.id + XYZ + COMMA + FT + regtempPbr.id + XYZ + COMMA + FT + regtempEnvBRDF.id + X + LN;
					str += ADD + SPACE + FT + regtempPbr.id + XYZ + COMMA + FT + regtempPbr.id + XYZ + COMMA + FT + regtempEnvBRDF.id + Y + LN;
					
					if(pNodeSpecular){
						str += MUL + SPACE + FT + regtempPbr.id + XYZ + COMMA + FT + regtempPbr.id + XYZ + COMMA + pNodeSpecular.getComponentID(inputSpecular.parentNodeItem.id);
						pNodeSpecular.releaseUse();
					}else{
						str += MUL + SPACE + FT + regtempPbr.id + XYZ + COMMA + FT + regtempPbr.id + XYZ + COMMA + FC + ONE + Y;
					}
					
					//trace(str);
					strVec.push(str);
					
					//specularIBL prefilteredColor * (SpecularColor * envBrdf.x + envBrdf.y) ;
					// tex prefilteredColor
					var regtexIBL:RegisterItem = getFragmentTex();
					if(useNormal || true){
						//"sub vt1,vt0,vc12 \n" + //反射方向  reflect = I - 2 * dot(N,I) * N
						//"nrm vt1.xyz,vt1.xyz\n" + 
						//"dp3 ft0.x,vi1.xyz,ft3.xyz \n"+//反射方向  reflect = I - 2 * dot(N,I) * N
						//	"mul ft0.xyz,ft3.xyz,ft0.x \n" +
						//	"mul ft0.xyz,ft0.xyz,fc7.y\n" +
						//	"sub ft0.xyz,vi1.xyz,ft0.xyz\n" +
						var regtempIBL:RegisterItem = getFragmentTemp();
						traceFt();
						
						//NodeTreeOP($node).writeZbuffer;
						
						if(useDynamicIBL){
							str = MOV + SPACE + FT + regtempEnvBRDF.id + COMMA + VI + defaultLutReg.id + LN;
							str += DIV + SPACE + FT + regtempEnvBRDF.id + XY + COMMA + FT + regtempEnvBRDF.id + XY + COMMA + FT + regtempEnvBRDF.id + Z + LN;
							str += ADD + SPACE + FT + regtempEnvBRDF.id + XY + COMMA + FT + regtempEnvBRDF.id + XY + COMMA + FC + FOUR + XY + LN;
							str += DIV + SPACE + FT + regtempEnvBRDF.id + XY + COMMA + FT + regtempEnvBRDF.id + XY + COMMA + FC + FOUR + ZW + LN;
							
							str += MUL + SPACE + FT + regtempIBL.id + XYZ + COMMA + FT + regtempNormal.id + XYZ + COMMA + FC + ONE + W + LN;
							
							str += ADD + SPACE + FT + regtempEnvBRDF.id + X + COMMA + FT + regtempEnvBRDF.id + X + COMMA + FT + regtempIBL.id + X + LN;
							str += ADD + SPACE + FT + regtempEnvBRDF.id + Y + COMMA + FT + regtempEnvBRDF.id + Y + COMMA + FT + regtempIBL.id + Z + LN;
							
							str += TEX + SPACE + FT + regtempEnvBRDF.id + COMMA + FT + regtempEnvBRDF.id + XY + COMMA + FS + regtexIBL.id + SPACE + getTexType(1,0);
						}else{
							str = SUB + SPACE + FT + regtempIBL.id + XYZ + COMMA + VI + defaultPtReg.id + XYZ + COMMA + FC + TWO + XYZ + LN;
							str += NRM + SPACE + FT + regtempIBL.id + XYZ + COMMA + FT + regtempIBL.id + XYZ + LN;
							str += DP3 + SPACE + FT + regtempEnvBRDF.id + X + COMMA + FT + regtempIBL.id + XYZ + COMMA + FT + regtempNormal.id + XYZ  + LN;
							str += MUL + SPACE + FT + regtempEnvBRDF.id + XYZ + COMMA + FT + regtempNormal.id + XYZ + COMMA + FT + regtempEnvBRDF.id + X + LN;
							str += MUL + SPACE + FT + regtempEnvBRDF.id + XYZ + COMMA + FT + regtempEnvBRDF.id + XYZ + COMMA + FC + ZERO + Y + LN;
							str += SUB + SPACE + FT + regtempEnvBRDF.id + XYZ + COMMA + FT + regtempIBL.id + XYZ + COMMA + FT + regtempEnvBRDF.id + XYZ + LN;
							str += TEX + SPACE + FT + regtempEnvBRDF.id + COMMA + FT + regtempEnvBRDF.id + XYZ + COMMA + FS + regtexIBL.id + SPACE + texCubeType;
						}
						
						regtempIBL.inUse = false;
						//trace(str);
					}else{
						//str = MOV + SPACE + FT + regtempEnvBRDF.id + COMMA + VI + defaultPtReg.id + LN;
						//str += SUB + SPACE + FT + regtempEnvBRDF.id + COMMA + FT + VI + "7" + regtempEnvBRDF.id + COMMA + LN;
						//str += TEX + SPACE + FT + regtempEnvBRDF.id + COMMA + FT + regtempEnvBRDF.id + COMMA + FS + regtexIBL.id + SPACE + texCubeType;
						str = TEX + SPACE + FT + regtempEnvBRDF.id + COMMA + VI + defaultPtReg.id + COMMA + FS + regtexIBL.id + SPACE + texCubeType;
						//trace(str);
					}
					//trace(str);
					strVec.push(str);
					texItem = new TexItem;
					texItem.id = regtexIBL.id;
					texItem.type = TexItem.CUBEMAP;
					texVec.push(texItem);
					
					str = MUL + SPACE + FT + regtempEnvBRDF.id + XYZ + COMMA + FT + regtempEnvBRDF.id + XYZ + COMMA + FC + ONE + Z; 
					//trace(str);
					strVec.push(str);
					
					str = MUL + SPACE + FT + regtempPbr.id + XYZ + COMMA + FT + regtempPbr.id + XYZ + COMMA + FT + regtempEnvBRDF.id + XYZ;
					//trace(str);
					strVec.push(str);
					
					//regtempEnvBRDF.inUse = false;
					if(regtempEnvBRDF){
						regtempEnvBRDF.inUse = false;
					}
					traceFt();
				}
				
				
				
				
				
				regOp = getFragmentTemp();//输出用临时寄存器
				
				if(usePbr){
					//diffuseColor = basecolor * (1-metallic)
					
					regtempMetallic = getFragmentTemp();
					str = MOV + SPACE + FT + regtempMetallic.id + X + COMMA + FC + ZERO + X + LN;
					if(pNodeMetallic){
						str += SUB + SPACE + FT + regtempMetallic.id + X + COMMA + FT + regtempMetallic.id + X + COMMA + pNodeMetallic.getComponentID(inputMetallic.parentNodeItem.id);
						inputMetallic.hasCompiled = true;
						pNodeMetallic.releaseUse();
					}else{
						str += SUB + SPACE + FT + regtempMetallic.id + X + COMMA + FT + regtempMetallic.id + X + COMMA + FC + ONE + Y;
					}
					strVec.push(str);
					
					str = MUL + SPACE + FT + regOp.id + XYZ + COMMA + FT + regtempLightMap.id + XYZ + COMMA + FT + regtempMetallic.id + X + LN;
					//str += MUL + SPACE + FT + regOp.id + XYZ + COMMA + FT + regOp.id + XYZ + COMMA + FT + regtempLightMap.id + XYZ  + LN;
					str += ADD + SPACE + FT + regOp.id + XYZ + COMMA + FT + regOp.id + XYZ + COMMA +  FT + regtempPbr.id + XYZ;
					
					regtempMetallic.inUse = false;
				}else{
					//str =  MUL + SPACE + FT + regOp.id + XYZ + COMMA + pNodeDiffuse.getComponentID(inputDiffuse.parentNodeItem.id) + COMMA + FT + regtempLightMap.id + XYZ;
					str =  MOV + SPACE + FT + regOp.id + XYZ + COMMA + FT + regtempLightMap.id + XYZ;
				}
				
				inputDiffuse.hasCompiled = true;
				pNodeDiffuse.releaseUse();
				
				strVec.push(str);
				
				regtempLightMap.inUse = false;
				if(regtempPbr){
					regtempPbr.inUse = false;
				}
					
				
			}
			
			if(inputEmissive.parentNodeItem){//自发光部分
				var pNodeEmissive:NodeTree = inputEmissive.parentNodeItem.node;//emissive输入节点
				
				if(!regOp){
					regOp = getFragmentTemp();
				}
				
				if(hasDiffuse){
					str =  ADD + SPACE + FT + regOp.id + XYZ + COMMA + FT + regOp.id + XYZ + COMMA + pNodeEmissive.getComponentID(inputEmissive.parentNodeItem.id);
				}else{
					str =  MOV + SPACE + FT + regOp.id + XYZ + COMMA + pNodeEmissive.getComponentID(inputEmissive.parentNodeItem.id);
				}
				strVec.push(str);
				
				pNodeEmissive.releaseUse();
			}
			
			//alpha
			str = new String;
			var inputAlpha:NodeTreeInputItem = $node.inputVec[7];
			if(!inputAlpha.parentNodeItem){
				str = MOV + SPACE + FT + regOp.id + W + COMMA + FC + ZERO + X;
			}else{
				var pNodeAlpha:NodeTree = inputAlpha.parentNodeItem.node;
				str = MOV + SPACE + FT + regOp.id + W + COMMA + pNodeAlpha.getComponentID(inputAlpha.parentNodeItem.id);
				pNodeAlpha.releaseUse();
				hasAlpha = true;
			}
			strVec.push(str);
			
			//kill
			str = new String;
			var inputKill:NodeTreeInputItem = $node.inputVec[8];
			if(inputKill.parentNodeItem){
				var pNodeKill:NodeTree = inputKill.parentNodeItem.node;
				
				var regtempKill:RegisterItem = getFragmentTemp();
				
				killNum = NodeTreeOP($node).killNum;
				
				str = SUB + SPACE + FT + regtempKill.id + X + COMMA + pNodeKill.getComponentID(inputKill.parentNodeItem.id) + COMMA + FC + ZERO + Z + LN;
				str += KIL + SPACE + FT + regtempKill.id + X;
				
				strVec.push(str);
			}
			
			var regtempFog:RegisterItem;
			if(fogMode == 1){
				regtempFog = getFragmentTemp();
				// sub ft0.xyz,fc3.xyz,vi4.xyz
				// dp3 ft0.x,ft0.xyz,ft0.xyz;
				// mul ft0.x,ft0.x,fc4.y
				//div ft0.x,fc4.z,ft0.x
				//mul ft0.xyz,fc4.xyz,ft0.x
				str=""
				str += SUB + SPACE + FT + regtempFog.id + XYZ + COMMA + VI + defaultPtReg.id + XYZ + COMMA + FC + TWO + XYZ + LN;
				str += DP3 + SPACE + FT + regtempFog.id + X + COMMA + FT + regtempFog.id + XYZ + COMMA + FT + regtempFog.id + XYZ + LN;
				
				str += "sqt" + SPACE + FT + regtempFog.id + X + COMMA + SPACE + FT + regtempFog.id + X + LN;
				
				
				str += SUB + SPACE + FT + regtempFog.id + X + COMMA  + FT + regtempFog.id + X  + COMMA+ FC + THREE + Z+ LN;
				str += MUL + SPACE + FT + regtempFog.id + X + COMMA + FT + regtempFog.id + X + COMMA + FC + THREE + Y + LN;
				
				
				str += SAT + SPACE + FT + regtempFog.id + X + COMMA + FT + regtempFog.id + X + LN;
				str += SUB + SPACE + FT + regtempFog.id + Y + COMMA + FC + ZERO + X + COMMA + FT + regtempFog.id + X + LN;
				str += MUL + SPACE + FT + regOp.id + XYZ + COMMA + FT + regOp.id + XYZ + COMMA + FT + regtempFog.id + Y + LN;
				str += MUL + SPACE + FT + regtempFog.id + XYZ + COMMA + FC + FOUR + XYZ + COMMA + FT + regtempFog.id + X + LN;
				str += ADD + SPACE + FT + regOp.id + XYZ + COMMA + FT + regOp.id + XYZ + COMMA + FT + regtempFog.id + XYZ;
				
				strVec.push(str);
			}else if(fogMode == 2){
				regtempFog = getFragmentTemp();
				//sub ft0.x,v4.y,fc3.z
				//mul ft0.x,ft0.x,fc3.y
				//add ft0.x,ft0.x,fc0.x
				//sat ft0.x,ft0.x
				
				str = SUB + SPACE + FT + regtempFog.id + X + COMMA + VI + defaultPtReg.id + Y + COMMA + FC + THREE + Z + LN;
				str += MUL + SPACE + FT + regtempFog.id + X + COMMA +  FT + regtempFog.id + X + COMMA + FC + THREE + Y + LN;
				str += ADD + SPACE + FT + regtempFog.id + X + COMMA +  FT + regtempFog.id + X + COMMA + FC + ZERO + X + LN;
				str += SAT + SPACE + FT + regtempFog.id + X + COMMA + FT + regtempFog.id + X + LN;
				str += SUB + SPACE + FT + regtempFog.id + Y + COMMA + FC + ZERO + X + COMMA + FT + regtempFog.id + X + LN;
				str += MUL + SPACE + FT + regOp.id + XYZ + COMMA + FT + regOp.id + XYZ + COMMA + FT + regtempFog.id + X + LN;
				str += MUL + SPACE + FT + regtempFog.id + XYZ + COMMA + FC + FOUR + XYZ + COMMA + FT + regtempFog.id + Y + LN;
				str += ADD + SPACE + FT + regOp.id + XYZ + COMMA + FT + regOp.id + XYZ + COMMA + FT + regtempFog.id + XYZ;
				strVec.push(str);
				
			}
			
			str = new String;
			str = MOV + SPACE + FO + COMMA + FT + regOp.id;
			strVec.push(str);
			
			
			
			this.backCull = NodeTreeOP($node).backCull;
			this.blendMode = NodeTreeOP($node).blendMode;
			this.writeZbuffer = NodeTreeOP($node).writeZbuffer;
			this.normalScale = NodeTreeOP($node).normalScale;
		}
		private function traceShader():void{
			var str:String = new String;
			for(var i:int=0;i<strVec.length;i++){
				str += strVec[i] + "\n";
			}
			trace(str);
		}
		private function traceFt():void{
			return;
			var tNum:int;
			var fNum:int;
			var tStr:String = new String;
			var fStr:String = new String;
			for(var i:int;i<fragmentTempList.length;i++){
				if(fragmentTempList[i].inUse){
					tStr += i + ",";
					tNum++;
				}else{
					fStr += i + ",";
					fNum++;
				}
			}
			
			trace("使用："+ tNum + " -- " +  tStr);
			trace("未使用："+ fNum + " -- " +  fStr);
		}
		
		public function processParticleColor($node:NodeTree):void{
			var str:String = new String;
			
			var regtex:RegisterItem = getFragmentTex();
			var regtemp:RegisterItem = getFragmentTemp();
			
			str = TEX + SPACE + FT + regtemp.id + COMMA + VI + defaultPtReg.id + COMMA + FS + regtex.id + SPACE + getTexType(1);
			
			$node.regResultTemp = regtemp;
			$node.regResultTex = regtex;
			$node.shaderStr = str;
			strVec.push(str);
			
			var texItem:TexItem = new TexItem;
			texItem.id = regtex.id;
			texItem.isDynamic = true;
			texItem.paramName = $node.paramName;
			texItem.isParticleColor = true;
			texVec.push(texItem);
			
		}
		
		public function processTexLightMapNode():void{
			var str:String = new String;
			
			
		}
		
		public function processTexNode($node:NodeTree):void{
			var str:String = new String;
			
			var input:NodeTreeInputItem = $node.inputVec[0];
			
			var regtex:RegisterItem = getFragmentTex(NodeTreeTex($node).url);
			var regtemp:RegisterItem = getFragmentTemp();
			if(input.parentNodeItem){
				var pNode:NodeTree = input.parentNodeItem.node;
				str = TEX + SPACE + FT + regtemp.id + COMMA + pNode.getComponentID(input.parentNodeItem.id) + COMMA + FS + regtex.id + SPACE + getTexType(NodeTreeTex($node).wrap,NodeTreeTex($node).filter,NodeTreeTex($node).mipmap);
			}else{
				str = TEX + SPACE + FT + regtemp.id + COMMA + VI + defaultUvReg.id + COMMA + FS + regtex.id + SPACE + getTexType(NodeTreeTex($node).wrap,NodeTreeTex($node).filter,NodeTreeTex($node).mipmap);
			}
			
			$node.regResultTemp = regtemp;
			$node.regResultTex = regtex;
			$node.shaderStr = str;
			strVec.push(str);
			
			var texItem:TexItem = new TexItem;
			texItem.id = regtex.id;
			texItem.url = NodeTreeTex($node).url;
			texItem.isDynamic = NodeTreeTex($node).isDynamic;
			texItem.paramName = NodeTreeTex($node).paramName;
			texItem.isMain = NodeTreeTex($node).isMain;
			texItem.wrap = NodeTreeTex($node).wrap;
			texItem.filter = NodeTreeTex($node).filter;
			texItem.mipmap = NodeTreeTex($node).mipmap;
			texItem.permul = NodeTreeTex($node).permul;
			texVec.push(texItem);
			
			input.hasCompiled = true;
			if(pNode){
				pNode.releaseUse();
			}

		}
		
		private function getTexType(wrpaType:int,lerpType:int=0,mipmapType:int=0):String{
			var wrapStr:String;
			var lerpStr:String;
			var mipStr:String;
			if(wrpaType == 0){
				wrapStr = TEX_WRAP_REPEAT;
			}else{
				wrapStr = TEX_WRAP_CLAMP;
			}
			
			if(lerpType == 0){
				lerpStr = TEX_LINEAR;
			}else{
				lerpStr = TEX_NEAREST;
			}
			
			if(mipmapType == 0){
				mipStr = TEX_MIP_NONE;
			}else if(mipmapType == 1){
				mipStr = TEX_MIP_NEAREST;
			}else if(mipmapType == 2){
				mipStr = TEX_MIP_LINEAR;
			}
			

			return LEFT_BRACKET + TEX_2D + COMMA + lerpStr + COMMA + wrapStr + COMMA + mipStr + RIGHT_BRACKET;
		}
		
		public function processLerpNode($node:NodeTree):void{
			var str:String = new String;
			var input0:NodeTreeInputItem = $node.inputVec[0];
			var input1:NodeTreeInputItem = $node.inputVec[1];
			var inputAlpha:NodeTreeInputItem = $node.inputVec[2];
			var type0:String = input0.type;
			var type1:String = input1.type;
			
			var pNode0:NodeTree = input0.parentNodeItem.node;
			var pNode1:NodeTree = input1.parentNodeItem.node;
			var pNodeAlpah:NodeTree = inputAlpha.parentNodeItem.node;
			
			var output:NodeTreeOutoutItem = $node.outputVec[0];
			
			var regtemp:RegisterItem = getFragmentTemp();
			var regtemp2:RegisterItem = getFragmentTemp();
			
			str = MUL + SPACE + FT + regtemp.id + getComByType(output.type) + COMMA;
			str += pNode0.getComponentID(input0.parentNodeItem.id) + COMMA;
			str += pNodeAlpah.getComponentID(inputAlpha.parentNodeItem.id);
			
			str += LN;
			if(inputAlpha.parentNodeItem.node is NodeTreeFloat){
				str += MOV + SPACE + FT + regtemp2.id + X + COMMA + FC + ZERO + X + LN;
				str += SUB + SPACE + FT + regtemp2.id + X + COMMA + FT + regtemp2.id + X + COMMA + pNodeAlpah.getComponentID(inputAlpha.parentNodeItem.id) + LN;
			}else{
				str += SUB + SPACE + FT + regtemp2.id + X + COMMA + FC + ZERO + X + COMMA + pNodeAlpah.getComponentID(inputAlpha.parentNodeItem.id) + LN;
			}
			
			str += MUL + SPACE + FT + regtemp2.id + getComByType(output.type) + COMMA;
			str += pNode1.getComponentID(input1.parentNodeItem.id) + COMMA;
			str += FT + regtemp2.id + X + LN ;
			
			str +=  ADD + SPACE + FT + regtemp.id + getComByType(output.type) + COMMA;
			str += FT + regtemp.id + getComByType(output.type) + COMMA;
			str += FT + regtemp2.id + getComByType(output.type);
			
			regtemp2.inUse = false;
			
			input0.hasCompiled = true;
			input1.hasCompiled = true;
			inputAlpha.hasCompiled = true;
			
			pNode0.releaseUse();
			pNode1.releaseUse();
			pNodeAlpah.releaseUse();
			
			$node.regResultTemp = regtemp;
			$node.shaderStr = str;
			strVec.push(str);
		}
		
		private function getComByType($type:String):String{
			if($type == MaterialItemType.FLOAT){
				return X;
			}else if($type == MaterialItemType.VEC2){
				return  XY;
			}else if($type == MaterialItemType.VEC3){
				return  XYZ;
			}
			return null;
		}
		
		public function processDynamicNode($node:NodeTree,opCode:String):void{
			var str:String = new String;
			var input0:NodeTreeInputItem = $node.inputVec[0];
			var input1:NodeTreeInputItem = $node.inputVec[1];
			var type0:String = input0.type;
			var type1:String = input1.type;
			
			var pNode0:NodeTree = input0.parentNodeItem.node;
			var pNode1:NodeTree = input1.parentNodeItem.node;
			
			var output:NodeTreeOutoutItem = $node.outputVec[0];
			
			var regtemp:RegisterItem = getFragmentTemp();
			
			if(input0.type == MaterialItemType.VEC4 || input1.type == MaterialItemType.VEC4){
				str = opCode + SPACE + FT + regtemp.id + COMMA;
			}else if(output.type == MaterialItemType.FLOAT){
				str = opCode + SPACE + FT + regtemp.id + X + COMMA;
			}else if(output.type == MaterialItemType.VEC2){
				str = opCode + SPACE + FT + regtemp.id + XY + COMMA;
			}else if(output.type == MaterialItemType.VEC3){
				str = opCode + SPACE + FT + regtemp.id + XYZ + COMMA;
			}
			
			str += pNode0.getComponentID(input0.parentNodeItem.id) + COMMA;
			str += pNode1.getComponentID(input1.parentNodeItem.id);
			
			
			input0.hasCompiled = true;
			input1.hasCompiled = true;
			pNode0.releaseUse();
			pNode1.releaseUse();
			
			$node.regResultTemp = regtemp;
			$node.shaderStr = str;
			strVec.push(str);
		}
		
		private function processStaticNode($node:NodeTree,opCode:String):void{
			var str:String = new String;
			var input:NodeTreeInputItem = $node.inputVec[0];
			var pNode:NodeTree = input.parentNodeItem.node;
			
			var regtemp:RegisterItem = getFragmentTemp();
			str = opCode + SPACE + FT + regtemp.id + X + COMMA + pNode.getComponentID(input.parentNodeItem.id);
			input.hasCompiled = true;
			pNode.releaseUse();
			
			$node.regResultTemp = regtemp;
			$node.shaderStr = str;
			strVec.push(str);
		}
		
		public function processMulNode($node:NodeTree):void{
			var str:String = new String;
			var input0:NodeTreeInputItem = $node.inputVec[0];
			var input1:NodeTreeInputItem = $node.inputVec[1];
			var type:String = input0.type;
			
			var pNode0:NodeTree = input0.parentNodeItem.node;
			var pNode1:NodeTree = input1.parentNodeItem.node;
			
			var regtemp:RegisterItem = getFragmentTemp();
			// mul ft2.xyz,ft0.xyz,ft1.xyz
			if(type == MaterialItemType.VEC3){
				str = MUL + SPACE + FT + regtemp.id + XYZ + COMMA + FT + pNode0.getResultReg().id + XYZ + COMMA + FT + pNode1.getResultReg().id + XYZ;
			}else if(type == MaterialItemType.FLOAT){
				str = MUL + SPACE + FT + regtemp.id + X + COMMA + FT + pNode0.getResultReg().id + pNode0.getComponentID(input0.parentNodeItem.id) + COMMA + FT + pNode1.getResultReg().id + pNode1.getComponentID(input1.parentNodeItem.id);
			}
			
			
			input0.hasCompiled = true;
			input1.hasCompiled = true;
			pNode0.releaseUse();
			pNode1.releaseUse();
			
			$node.regResultTemp = regtemp;
			$node.shaderStr = str;
			strVec.push(str);
		}
		
		
		
		
		
		
		
		
		
	}
}