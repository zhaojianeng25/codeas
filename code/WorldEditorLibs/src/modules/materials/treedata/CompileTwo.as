package modules.materials.treedata
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import _Pan3D.utils.Cn2en;
	
	import materials.ConstItem;
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
	public class CompileTwo
	{
		
		public static var SPACE:String = " ";
		public static var COMMA:String = ",";
		public static var END:String = ";";
		public static var FC:String = "fc";
		public static var FT:String = "ft";
		public static var FS:String = "fs";
		public static var VI:String = "v";
		public static var OP:String = "op";
		public static var FO:String = "gl_FragColor";
		public static var XYZ:String = ".xyz";
		public static var XY:String = ".xy";
		public static var X:String = ".x";
		public static var Y:String = ".y";
		public static var Z:String = ".z";
		public static var W:String = ".w";
		public static var ZW:String = ".zw";
		public static var MOV:String = "mov";
		//public static var ONE:String = "1";
		public static var ONE_FLOAT:String = "1.0";
		public static var ZERO:String = "[0]";
		public static var ONE:String = "[1]";
		public static var TWO:String = "[2]";
		public static var TWO_FLOAT:String = "2.0";
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
		public static var LEFT_BRACKET:String = "<";
		public static var RIGHT_BRACKET:String = ">";
		public static var texCubeType:String = "<cube,clamp,linear,mipnone>";
		
		public static var TEX:String = "tex";
		public static var ADD:String = "add";
		public static var SUB:String = "sub";
		public static var MUL:String = "mul";
		public static var DIV:String = "div";
		public static var ADD_MATH:String = "+";
		public static var SUB_MATH:String = "-";
		public static var MUL_MATH:String = "*";
		public static var MUL_EQU_MATH:String = "*=";
		public static var DIV_MATH:String = "/";
		public static var RCP:String = "rcp";
		public static var MIN:String = "min";
		public static var MAX:String = "max";
		public static var FRC:String = "frc";
		public static var SQT:String = "sqt";
		public static var RSQ:String = "rsq";
		public static var POW:String = "pow";
		public static var LOG:String = "log";
		public static var EXP:String = "exp";
		public static var NRM:String = "normalize";
		public static var SIN:String = "sin";
		public static var COS:String = "cos";
		public static var CRS:String = "crs";
		public static var DP3:String = "dp3";
		public static var DOT:String = "dot";
		public static var DP4:String = "dp4";
		public static var ABS:String = "abs";
		public static var NEG:String = "neg";
		public static var SAT:String = "sat";
		public static var LERP:String = "lerp";
		public static var KIL:String = "kil";
		public static var M33:String = "m33";
		
		public static var VEC4:String = "vec4";
		public static var VEC3:String = "vec3";
		public static var VEC2:String = "vec2";
		public static var EQU:String = "=";
		public static var texture2D:String = "texture2D";
		public static var textureCube:String = "textureCube";
		public static var LEFT_PARENTH:String = "(";
		public static var RIGHT_PARENTH:String = ")";
		public static var DEFAULT_VEC4:String = "vec4(0,0,0,1)";
		public static var MIX:String = "mix";
		public static var REFLECT:String = "reflect";
		public static var IF:String = "if";
		public static var DISCARD:String = "{discard;}";
		public static var scalelight:String = "scalelight";
		//public static var fogdata:String = "fogdata";
		//public static var fogcolor:String = "fogcolor";
		
		
		
		
		
		public var priorityList:Vector.<Vector.<NodeTree>>;
		
		private var fragmentTempList:Vector.<RegisterItem>;
		private var fragmentTexList:Vector.<RegisterItem>;
		private var fragmentConstList:Vector.<RegisterItem>;
		
		private var defaultUvReg:RegisterItem;
		private var defaultLightUvReg:RegisterItem;
		private var defaultPtReg:RegisterItem;
		private var defaultLutReg:RegisterItem;
		private var defaultTangent:RegisterItem;
		private var defatultV5:RegisterItem;
		private var defatultV6:RegisterItem;
		//private var defaultBinormal:RegisterItem;
		
		private var strVec:Vector.<String>;
		private var texVec:Vector.<TexItem>;
		private var constVec:Vector.<ConstItem>;
		private var hasTime:Boolean;
		private var timeSpeed:Number= 0;
		private var blendMode:int;
		private var writeZbuffer:Boolean;
		private var backCull:Boolean;
		private var killNum:Number = 0;
		private var hasVertexColor:Boolean;
		private var usePbr:Boolean;
		private var useNormal:Boolean;
		private var roughness:Number= 0;
		private var hasFresnel:Boolean;
		private var useDynamicIBL:Boolean;
		private var normalScale:Number= 0;
		private var lightProbe:Boolean;
		private var useLightMap:Boolean;
		private var directLight:Boolean;
		private var noLight:Boolean;
		private var fogMode:int;
		private var scaleLightMap:Boolean;
		private var useKill:Boolean;
		private var fcNum:int;
		
		public function CompileTwo()
		{
			initReg();
			
			defaultUvReg = new RegisterItem(0);
			defaultPtReg = new RegisterItem(1);
			defaultLightUvReg = new RegisterItem(2);
			defaultLutReg = new RegisterItem(3);
			defaultTangent = new RegisterItem(4);
			
			defatultV5 = new RegisterItem(5);
			defatultV6 = new RegisterItem(6);
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
		
		public function getFragmentTex($nodeTreeTex:NodeTreeTex=null):RegisterItem{
			for(var i:int;i<fragmentTexList.length;i++){
//				if($nodeTreeTex&&$nodeTreeTex.url){
//					
//					if(fragmentTexList[i].inUse && fragmentTexList[i].id == $nodeTreeTex.id){
//						return fragmentTexList[i];
//					}
//				}
				if(!fragmentTexList[i].inUse){
					fragmentTexList[i].inUse = true;
					fragmentTexList[i].url ="";
					return fragmentTexList[i];
				}
			}
	
			return null;
		}
		
		public function setFragmentConst($nodeTree:NodeTree):void{
			for(var i:int=this._fcBeginID;i<fragmentConstList.length;i++){
				var tf:Boolean = fragmentConstList[i].getUse($nodeTree);
				if(tf){
					break;
				}
			}
		}
		
//		public function getFragmentConstBegin():void{
//			
//		}
		
		//0 kill time fogdata.x fogdata.y 
		//1 cam pos
		//2 fogcolor
		//3 scalelightmap
		
		private var _killID:int = 0;
		private var _timeID:int = 0;
		private var _fogdataID:int = 0;
		
		private var _camposID:int = 0;
		
		private var _fogcolorID:int = 0;
		private var _scalelightmapID:int = 0;
		
		private var _fcBeginID:int = 0;
		
		private function initBaseFc():void{
			var dataID:int = 0;
			
			
			var $useKill:Boolean = false;
			var $hasTime:Boolean = false;
			var $fogMode:int = 0;
			var $usePbr:Boolean = false;
			//var $hasFresnel:Boolean = false;
			var $scaleLightMap:Boolean = false;
			
			
			for(var i:int = priorityList.length -1;i >= 0;i--){
				var treelist:Vector.<NodeTree> = priorityList[i];
				for(var j:int=0;j<treelist.length;j++){
					
					var node:NodeTree = treelist[j];
					if(node.type == NodeTree.OP){
						var opnode:NodeTreeOP = node as NodeTreeOP;
						
						$fogMode = opnode.fogMode;
						$scaleLightMap = opnode.scaleLightMap;
						if(opnode.inputVec[8].parentNodeItem){
							$useKill = true;
						}
						
						var inputMetallic:NodeTreeInputItem = opnode.inputVec[1];
						var inputSpecular:NodeTreeInputItem = opnode.inputVec[2];
						var inputRoughness:NodeTreeInputItem = opnode.inputVec[3];

						if(inputMetallic.parentNodeItem || inputSpecular.parentNodeItem || inputRoughness.parentNodeItem){
							$usePbr = true;
						}

					}else if(node.type == NodeTree.TIME || node.type == NodeTree.PANNER){
						$hasTime = true;
					}
					
					
				}
			}
			
			if($useKill || $hasTime || $fogMode != 0){
				dataID++;
			}
			if($usePbr || $fogMode == 1){
				this._camposID = dataID;
				dataID++;
			}
			if($fogMode != 0){
				this._fogcolorID = dataID;
				dataID++;
			}
			if($scaleLightMap){
				this._scalelightmapID = dataID;
				dataID++;
			}
			this._fcBeginID = dataID;
			
		}
		
		private function get killStr():String{
			return "fc[" + this._killID + "].x";
		}
		
		private function get timeStr():String{
			return "fc[" + this._timeID + "].y";
		}
		
		private function get fogdataXStr():String{
			return "fc[" + this._fogdataID + "].z";
		}
		
		private function get fogdataYStr():String{
			return "fc[" + this._fogdataID + "].w";
		}
		
		private function get fogcolorStr():String{
			return "fc[" + this._fogcolorID + "].xyz";
		}
		
		private function get camposStr():String{
			return "fc[" + this._camposID + "].xyz";
		}
		private function get scalelightmapStr():String{
			return "fc[" + this._scalelightmapID + "].x";
		}
		
		private function preSetVcState():void{
			
		}
		
		
		public function compile($priorityList:Vector.<Vector.<NodeTree>>,$materialTree:MaterialTree):void{
			NodeTree.jsMode = true;
			
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
			useLightMap = false;
			useKill = false;
			directLight = false;
			noLight = false;
			fogMode = 0;
			scaleLightMap = false;
			
			//processDefaultFc();
			
			this.initBaseFc();
			
			for(var i:int = priorityList.length -1;i >= 0;i--){
				var treelist:Vector.<NodeTree> = priorityList[i];
				for(var j:int=0;j<treelist.length;j++){
					processNode(treelist[j]);
				}
			}
			
			var resultStr:String = getGLSLStr();
//			for(i=0;i<strVec.length;i++){
//				resultStr += strVec[i] + "\n";
//			}
			
			processMainTex();
			
			processTexForExp(texVec);
			
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
			$materialTree.useKill = useKill;
			$materialTree.directLight = directLight;
			$materialTree.noLight = noLight;
			$materialTree.fogMode = fogMode;
			$materialTree.scaleLightMap = scaleLightMap;
			$materialTree.fcNum = this.fcNum;
			$materialTree.fcIDAry = [this._camposID,this._fogcolorID,this._scalelightmapID];
			
			$materialTree.dispatchEvent(new Event(Event.CHANGE));
			trace("--Glsl Shader--");
			//trace(resultStr);
			var ary:Array = resultStr.split("\n");
			for(i = 0;i<ary.length;i++){
				if(i<9){
					trace((i+1) + "   " + ary[i]);
				}else{
					trace((i+1) + "  " + ary[i]);
				}
			}
			trace("compile Complete");
			
		}
		
		public function processTexForExp($texVec:Vector.<TexItem>):void{
			for(var i:int;i<$texVec.length;i++){
				if($texVec[i].type == 0){
					$texVec[i].url = Cn2en.toPinyin(decodeURI($texVec[i].url));
				}
			}
		}
		
		private function getGLSLStr():String{
			
			
			var mainStr:String = new String;
			for(var i:int=0;i<strVec.length;i++){
				mainStr += strVec[i] + "\n";
			}
			
			var perStr:String = "precision mediump float;\n";
			//"uniform sampler2D s_texture;\n" +
			var hasParticleColor:Boolean = false;
			var texStr:String = new String;
			for(i = 0;i < this.texVec.length;i++){
				if(this.texVec[i].type == 3){
					texStr += "uniform samplerCube fs" + this.texVec[i].id  + ";\n";
				}else{
					texStr += "uniform sampler2D fs" + this.texVec[i].id  + ";\n";
				}
				
				if(this.texVec[i].isParticleColor){
					hasParticleColor = true;
				}
			}
			
			
			var constStr:String = new String;
			
//			if(hasTime || this.usePbr || this.useKill){
//				constStr += "uniform vec4 fc" + 0 + ";\n";
//			}
//			
//			if(this.usePbr || this.fogMode == 1){
//				constStr += "uniform vec4 fc" + 2 + ";\n";
//			}
//			
//			if(this.scaleLightMap){
//				constStr += "uniform float " + scalelight + ";\n";
//			}
//			
//			if(this.fogMode != 0){
//				constStr += "uniform vec2 " + fogdata + ";\n";
//				constStr += "uniform vec3 " + fogcolor + ";\n";
//			}
//			
//			for(i = 0;i < this.constVec.length;i++){
//				constStr += "uniform vec4 fc" + this.constVec[i].id + ";\n";
//			}
			
			var maxID:int = 0;
			if(this.constVec.length){
				maxID = this.constVec[this.constVec.length-1].id + 1;
			}else{
				if(this._fcBeginID > 0){
					maxID = this._fcBeginID;
				}
			}
			
			this.fcNum = maxID;
			
			if(this.fcNum > 0){
				constStr += "uniform vec4 fc[" + (this.fcNum) + "];\n";
			}
			
			
			
			
			var varyStr:String = new String;
			varyStr +=  "varying vec2 v0;\n";
			if(this.lightProbe || this.directLight){
				varyStr +=  "varying vec3 v2;\n";
			}else if(this.useLightMap){
				varyStr +=  "varying vec2 v2;\n";
			}
			
			if(this.hasVertexColor){
				varyStr +=  "varying vec4 v2;\n";
			}
			
			if(this.usePbr){
				varyStr +=  "varying vec3 v1;\n";
				if(!this.useNormal){
					varyStr +=  "varying vec3 v4;\n";
				}else{
					varyStr +=  "varying mat3 v4;\n";
				}
				
			}else if(this.fogMode != 0){
				varyStr +=  "varying vec3 v1;\n";
			}
			
			if(hasParticleColor){
				varyStr +=  "varying vec2 v1;\n";
			}
			
			var beginStr:String = "void main(void){\n\n";
			var endStr:String = "\n}";
			
			
				
			var resultStr:String = perStr + texStr + constStr + varyStr + beginStr + mainStr + endStr;
			
			return resultStr;
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
					processDynamicNode($node,"*");
				break;
				case NodeTree.ADD:
					processDynamicNode($node,"+");
				break;
				case NodeTree.SUB:
					processDynamicNode($node,"-");
				break;
				case NodeTree.DIV:
					processDynamicNode($node,"/");
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
			
			if(!regtemp.hasInit){
				str = VEC4 + SPACE + FT + regtemp.id + SPACE + EQU + SPACE + DEFAULT_VEC4 + END;
				regtemp.hasInit = true;
				strVec.push(str);
			}
			
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
		
			//sub ft0.xyz,fc2.xyz,v1.xyz
			//normalize ft0.xyz,ft0.xyz
			//dp3 ft0.x,ft0.xyz,v4.xyz
			
			//str = FT + regtemp.id + XYZ + SPACE + EQU + SPACE + FC + ONE + XYZ + SPACE + SUB_MATH + SPACE + VI + defaultPtReg.id + XYZ + END + LN;
			str = FT + regtemp.id + XYZ + SPACE + EQU + SPACE + camposStr + SPACE + SUB_MATH + SPACE + VI + defaultPtReg.id + XYZ + END + LN;
			str += FT + regtemp.id + XYZ + SPACE + EQU + SPACE + NRM + LEFT_PARENTH + FT + regtemp.id + XYZ + RIGHT_PARENTH  + END + LN;
			str += FT + regtemp.id + X + SPACE + EQU + SPACE + DOT + LEFT_PARENTH + FT + regtemp.id + XYZ + COMMA + VI + normalID + XYZ + RIGHT_PARENTH + END + LN;
			
			
			//sub ft0.x,fc0.x,ft0.x
			//add ft0.x,ft0.x,fc5.y
			//sat ft0.x,ft0.x
			//mul ft0.x,ft0.x,fc5.x
			
//			str += SUB + SPACE + FT + regtemp.id + X + COMMA + FC + ZERO + X + COMMA + FT + regtemp.id + X + LN;
//			str += ADD + SPACE + FT + regtemp.id + X + COMMA + FT + regtemp.id + X + COMMA + pNode2.getComponentID(input2.parentNodeItem.id) + LN;
//			str += SAT + SPACE + FT + regtemp.id + X + COMMA + FT + regtemp.id + X + LN;
//			str += MUL + SPACE + FT + regtemp.id + X + COMMA + FT + regtemp.id + X + COMMA + pNode1.getComponentID(input1.parentNodeItem.id);
			
			str += FT + regtemp.id + X + SPACE + EQU + SPACE + "1.0" + SPACE + SUB_MATH + SPACE + FT + regtemp.id + X + SPACE + ADD_MATH + SPACE + pNode2.getComponentID(input2.parentNodeItem.id) + END +  LN;
			str += FT + regtemp.id + X + SPACE + EQU + SPACE + TEX_WRAP_CLAMP + LEFT_PARENTH + FT + regtemp.id + X + COMMA + "0.0" + COMMA + "1.0" + RIGHT_PARENTH + END + LN;
			str +=  FT + regtemp.id + X + SPACE + EQU + SPACE + FT + regtemp.id + X + SPACE + MUL_MATH + SPACE + pNode1.getComponentID(input1.parentNodeItem.id) + END;
			
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
			
			if(!regtemp.hasInit){
				str = VEC4 + SPACE + FT + regtemp.id + SPACE + EQU + SPACE + DEFAULT_VEC4 + END;
				regtemp.hasInit = true;
				strVec.push(str);
			}
			
			//var regtemp2:RegisterItem = getFragmentTemp();
			
			// ft0.xy = v0.xy * fc5.xy
			var pNode1:NodeTree;
			if(input1.parentNodeItem){
				pNode1 = input1.parentNodeItem.node;
				//str += MUL + SPACE + FT + regtemp.id + XY + COMMA + VI + defaultUvReg.id + XY + COMMA + pNode1.getComponentID(input1.parentNodeItem.id) + LN;
				str = FT + regtemp.id + XY + SPACE + EQU + SPACE + VI + defaultUvReg.id + XY + SPACE + MUL_MATH + SPACE + pNode1.getComponentID(input1.parentNodeItem.id) + END + LN;
			}else{
				pNode1 = new NodeTreeVec2;
				pNode1.type = NodeTree.VEC2;
				NodeTreeVec2(pNode1).constValue = NodeTreePanner($node).coordinateValue;
				processVec3Node(pNode1);
				//str += MUL + SPACE + FT + regtemp.id + XY + COMMA + VI + defaultUvReg.id + XY + COMMA + pNode1.getComponentID(0) + LN;
				str = FT + regtemp.id + XY + SPACE + EQU + SPACE + VI + defaultUvReg.id + XY + SPACE + MUL_MATH + SPACE + pNode1.getComponentID(0) + END + LN;
			}
			
			//str += MOV + SPACE + FT + regtemp.id + Z + COMMA + FC + ZERO + W + LN;
			//ft1.zw = fc5.zw * ft0.z
			var pNode2:NodeTree;
			if(input2.parentNodeItem){
				pNode2 = input2.parentNodeItem.node;
				//str += FT + regtemp.id + ZW + SPACE + EQU + SPACE + pNode2.getComponentID(input2.parentNodeItem.id) + SPACE + MUL_MATH + SPACE + FC + ZERO + W + END +LN;
				str += FT + regtemp.id + ZW + SPACE + EQU + SPACE + pNode2.getComponentID(input2.parentNodeItem.id) + SPACE + MUL_MATH + SPACE + timeStr + END +LN;
			}else{
				pNode2 = new NodeTreeVec2;
				pNode2.type = NodeTree.VEC2;
				NodeTreeVec2(pNode2).constValue = NodeTreePanner($node).speedValue;
				processVec3Node(pNode2);
				//str += FT + regtemp.id + ZW + SPACE + EQU + SPACE + pNode2.getComponentID(0) + SPACE + MUL_MATH + SPACE + FC + ZERO + W + END + LN;
				str += FT + regtemp.id + ZW + SPACE + EQU + SPACE + pNode2.getComponentID(0) + SPACE + MUL_MATH + SPACE + timeStr + END + LN;
			}
			//ft1.xy = ft1.xy + ft1.zw
			
			str += FT + regtemp.id + XY + SPACE + EQU + SPACE + FT + regtemp.id + XY + SPACE + ADD_MATH + SPACE + FT + regtemp.id + ZW + END;
			//str += ADD + SPACE + FT + regtemp.id + XY + COMMA + FT + regtemp.id + XY + COMMA + FT + regtemp2.id + XY;
			
			
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
			
			if(!regtemp.hasInit){
				str = VEC4 + SPACE + FT + regtemp.id + SPACE + EQU + SPACE + DEFAULT_VEC4 + END;
				regtemp.hasInit = true;
				strVec.push(str);
			}
			
			
			//str =  FT + regtemp.id + X + SPACE + EQU + SPACE + FC + ZERO + W + SPACE +  MUL_MATH + SPACE + pNode.getComponentID(0) + END;
			str =  FT + regtemp.id + X + SPACE + EQU + SPACE + timeStr + SPACE +  MUL_MATH + SPACE + pNode.getComponentID(0) + END;
			
			
			
			
			strVec.push(str);
			$node.regResultTemp = regtemp;
			hasTime = true;
			timeSpeed = 0.001;
		}
		
		public function processMathMinNode($node:NodeTree):void{
			var str:String = new String;
			var regtemp:RegisterItem = getFragmentTemp();
			
			if(!regtemp.hasInit){
				str = VEC4 + SPACE + FT + regtemp.id + SPACE + EQU + SPACE + DEFAULT_VEC4 + END;
				regtemp.hasInit = true;
				strVec.push(str);
			}
			
			var vcNode:NodeTreeFloat = new NodeTreeFloat;
			vcNode.type = NodeTree.FLOAT;
			vcNode.constValue = NodeTreeMin($node).value;
			processVec3Node(vcNode);
			
			var input:NodeTreeInputItem = $node.inputVec[0];
			var pNode:NodeTree = input.parentNodeItem.node;
			
			//ft0 = min(ft1,ft2);
			str = FT + regtemp.id + X + SPACE + EQU + SPACE;
			str += MIN + LEFT_PARENTH + pNode.getComponentID(input.parentNodeItem.id) + COMMA + vcNode.getComponentID(0) + RIGHT_PARENTH + END;
			
			//str = MIN + SPACE + FT + regtemp.id + X + COMMA + pNode.getComponentID(input.parentNodeItem.id) + COMMA + vcNode.getComponentID(0);
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
			//diffuse
			
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
			
			if(inputMetallic.parentNodeItem || inputSpecular.parentNodeItem || inputRoughness.parentNodeItem){
				usePbr = true;
				trace("use PBR!");
			}else{
				usePbr = false;
			}
			
			if(inputNormal.parentNodeItem){
				useNormal = true;
			}else{
				useNormal = false;
			}
			
			useDynamicIBL = NodeTreeOP($node).useDynamicIBL;
			
			var regOp:RegisterItem;
			var texItem:TexItem;
			
			traceFt();
			
			var hasDiffuse:Boolean = false;
			if(NodeTreeOP($node).isUseLightMap && inputDiffuse.parentNodeItem){//漫反射部分
				
				hasDiffuse = true;
				
				var pNodeDiffuse:NodeTree = inputDiffuse.parentNodeItem.node;//diffuse输入节点
				
				var regtempLightMap:RegisterItem = getFragmentTemp();
				var resultStr:String;
				if(regtempLightMap.hasInit){
					resultStr = FT + regtempLightMap.id;
				}else{
					resultStr = VEC4 + SPACE + FT + regtempLightMap.id;
					regtempLightMap.hasInit = true;
				}
				
				if(this.lightProbe){
					//vec4 ft1 = vec4(v0*5.0,1.0);
					str =  resultStr + SPACE + EQU + SPACE + VEC4 + LEFT_PARENTH + VI + defaultLightUvReg.id + MUL_MATH + "2.0" + COMMA + "1.0" + RIGHT_PARENTH + END;
					//str = MOV + SPACE + FT + regtempLightMap.id + COMMA + VI + defaultLightUvReg.id + LN; 
					//str += MUL + SPACE + FT + regtempLightMap.id + XYZ + COMMA + FT + regtempLightMap.id + XYZ + COMMA + FC + THREE + X;
					strVec.push(str);
				}else if(this.directLight){
					str = resultStr + SPACE + EQU + SPACE + VEC4 + LEFT_PARENTH + VI + defaultLightUvReg.id + COMMA + "1.0" + RIGHT_PARENTH + END;
					//str = resultStr + SPACE + EQU + SPACE + VEC4 + LEFT_PARENTH + VI + defaultLightUvReg.id + COMMA + "1.0" + RIGHT_PARENTH + END;
					//str = MOV + SPACE + FT + regtempLightMap.id + COMMA + VI + defaultLightUvReg.id; 
					//str += MUL + SPACE + FT + regtempLightMap.id + XYZ + COMMA + FT + regtempLightMap.id + XYZ + COMMA + FC + THREE + X;
					strVec.push(str);
				}else if(this.noLight){
				
				} else{
					var regtexLightMap:RegisterItem = getFragmentTex();
					// ve4 ft0 = texture2D(fs0,v1);
					// ft0.xyz = ft0.xyz * 5.0;
					str = resultStr + SPACE + EQU + SPACE + texture2D + LEFT_PARENTH + FS + regtexLightMap.id + COMMA + VI + defaultLightUvReg.id + RIGHT_PARENTH + END + LN;
					if(this.scaleLightMap){
						str += FT + regtempLightMap.id + XYZ + SPACE + EQU + SPACE + FT + regtempLightMap.id + XYZ + SPACE +  MUL_MATH + SPACE +  scalelight + END;
					}else{
						str += FT + regtempLightMap.id + XYZ + SPACE + EQU + SPACE + FT + regtempLightMap.id + XYZ + SPACE +  MUL_MATH + SPACE +  "2.0"  + END;
					}

					//					str = TEX + SPACE + FT + regtempLightMap.id + COMMA + VI + defaultLightUvReg.id + COMMA + FS + regtexLightMap.id + SPACE + texType + LN;
					//					str += MUL + SPACE + FT + regtempLightMap.id + XYZ + COMMA + FT + regtempLightMap.id + XYZ + COMMA + FC + THREE + X;
					strVec.push(str);
					texItem = new TexItem;
					texItem.id = regtexLightMap.id;
					texItem.type = TexItem.LIGHTMAP;
					texVec.push(texItem);
					this.useLightMap = true;
				}
				
				if(this.noLight&&!this.directLight){
					str = resultStr + SPACE + EQU + SPACE + VEC4 + LEFT_PARENTH + pNodeDiffuse.getComponentID(inputDiffuse.parentNodeItem.id) + COMMA + "1.0" + RIGHT_PARENTH + END;
				}else{
					str = FT + regtempLightMap.id + XYZ + SPACE + EQU + SPACE + FT + regtempLightMap.id + XYZ + SPACE + MUL_MATH 
						+ SPACE + pNodeDiffuse.getComponentID(inputDiffuse.parentNodeItem.id) + END;
				}
				strVec.push(str);
				
				pNodeDiffuse.releaseUse();
				
				if(usePbr){
					
					var pNodeNormal:NodeTree;
					var regtempNormal:RegisterItem;
					regtempNormal = getFragmentTemp();
					if(!regtempNormal.hasInit){
						str = VEC4 + SPACE + FT + regtempNormal.id + SPACE + EQU + SPACE + DEFAULT_VEC4 + END;
						regtempNormal.hasInit = true;
						strVec.push(str);
					}
					
					
					if(useNormal){
						pNodeNormal = inputNormal.parentNodeItem.node; // normal * 2 - 1
						// ft0.xyz = n.xyz * 2.0 - 1.0
						str = FT + regtempNormal.id + XYZ + SPACE + EQU + SPACE + pNodeNormal.getComponentID(inputNormal.parentNodeItem.id) + SPACE +
							MUL_MATH + SPACE + TWO_FLOAT + SPACE + SUB_MATH + SPACE + ONE_FLOAT + END;
						//str = MUL + SPACE + FT + regtempNormal.id + XYZ + COMMA + pNodeNormal.getComponentID(inputNormal.parentNodeItem.id) + COMMA + FC + ZERO + Y + LN;
						//str += SUB + SPACE + FT +  regtempNormal.id + XYZ + COMMA + FT + regtempNormal.id + XYZ + COMMA + FC + ZERO + X;
						strVec.push(str);
						
						str = FT + regtempNormal.id + XYZ + SPACE + EQU + SPACE + VI + defaultTangent.id + SPACE + MUL_MATH + SPACE + FT + regtempNormal.id + XYZ + END + LN;
						str += FT + regtempNormal.id + XYZ + SPACE + EQU + SPACE + NRM + LEFT_PARENTH + FT + regtempNormal.id + XYZ + RIGHT_PARENTH + END;
						strVec.push(str);
						
//						var regtempNormalMap:RegisterItem;
//						regtempNormalMap = getFragmentTemp();
//						if(!regtempNormalMap.hasInit){
//							str = VEC4 + SPACE + FT + regtempNormalMap.id + SPACE + EQU + SPACE + DEFAULT_VEC4 + END;
//							regtempNormalMap.hasInit = true;
//							strVec.push(str);
//						}
//						str = FT + regtempNormalMap.id + X + SPACE + EQU + SPACE + DOT + LEFT_PARENTH + FT + regtempNormal.id + XYZ + COMMA + VI + defatultV5.id + XYZ + RIGHT_PARENTH + END;
//						strVec.push(str);
//						
//						str = FT + regtempNormalMap.id + Y + SPACE + EQU + SPACE + DOT + LEFT_PARENTH + FT + regtempNormal.id + XYZ + COMMA + VI + defatultV6.id + XYZ + RIGHT_PARENTH + END;
//						strVec.push(str);
//						
//						str = FT + regtempNormalMap.id + Z + SPACE + EQU + SPACE + DOT + LEFT_PARENTH + FT + regtempNormal.id + XYZ + COMMA + VI + defaultTangent.id + XYZ + RIGHT_PARENTH + END;
//						strVec.push(str);
//						
//						str = FT + regtempNormal.id + XYZ + SPACE + EQU + SPACE + NRM + LEFT_PARENTH + FT + regtempNormalMap.id + XYZ + RIGHT_PARENTH + END;
						
						//str = M33 + SPACE + FT +  regtempNormal.id + XYZ + COMMA + FT +  regtempNormal.id + XYZ + COMMA + VI + defaultTangent.id + LN;
						//str += NRM + SPACE + FT + regtempNormal.id + XYZ + COMMA + FT + regtempNormal.id + XYZ;
//						strVec.push(str);
//						regtempNormalMap.inUse = false;
						
						inputNormal.hasCompiled = true;
						pNodeNormal.releaseUse();
					}else{
						//ft0.xyz = vi3.xyz
						str = FT + regtempNormal.id + XYZ + SPACE + EQU + SPACE + VI + defaultTangent.id + XYZ + END;
						//str = MOV + SPACE + FT + regtempNormal.id + XYZ + COMMA + VI + defaultTangent.id + XYZ;
						strVec.push(str);
					}
					//trace(str);
					//traceFt();
					
					var regtempPbr:RegisterItem = getFragmentTemp();
					
					if(!regtempPbr.hasInit){
						str = VEC4 + SPACE + FT + regtempPbr.id + SPACE + EQU + SPACE + DEFAULT_VEC4 + END;
						regtempPbr.hasInit = true;
						strVec.push(str);
					}
					//SpecularColor = 0.08 * SpecularScale * (1-metallic) + basecolor * metallic
					// SpecularColor = mix(0.08 * SpecularScale,basecolor,metallic);
					str = FT + regtempPbr.id + XYZ + SPACE + EQU + SPACE + MIX + LEFT_PARENTH;
					
					var pNodeSpecular:NodeTree;
					if(inputSpecular.parentNodeItem){
						pNodeSpecular = inputSpecular.parentNodeItem.node;
						//vec3(ft0,ft0,ft0) * 0.08
						str += VEC3 + LEFT_PARENTH + pNodeSpecular.getComponentID(inputSpecular.parentNodeItem.id) + COMMA 
							+ pNodeSpecular.getComponentID(inputSpecular.parentNodeItem.id) + COMMA
							+ pNodeSpecular.getComponentID(inputSpecular.parentNodeItem.id) + RIGHT_PARENTH + SPACE + MUL_MATH + SPACE + "0.08" + COMMA;
						//str += "0.08" + SPACE + MUL_MATH + SPACE + pNodeSpecular.getComponentID(inputSpecular.parentNodeItem.id) + COMMA;
						//str = MUL + SPACE + FT + regtempMetallic.id + X + COMMA + FT + regtempMetallic.id + X + COMMA + pNodeSpecular.getComponentID(inputSpecular.parentNodeItem.id);
						inputSpecular.hasCompiled = true;
					}else{
						str += "0.04" + COMMA;
						//str = MUL + SPACE + FT + regtempMetallic.id + X + COMMA + FT + regtempMetallic.id + X + COMMA + FC + ONE + Y;
					}
					
					str += FT + regtempLightMap.id + XYZ + COMMA;
					
					var pNodeMetallic:NodeTree;
					if(inputMetallic.parentNodeItem){//basecolor * metallic
						pNodeMetallic = inputMetallic.parentNodeItem.node;
						str += pNodeMetallic.getComponentID(inputMetallic.parentNodeItem.id) + RIGHT_PARENTH + END;
						//str = MUL + SPACE + FT + regtempPbr.id + XYZ + COMMA + pNodeDiffuse.getComponentID(inputDiffuse.parentNodeItem.id) + COMMA + pNodeMetallic.getComponentID(inputMetallic.parentNodeItem.id);
					}else{
						str += "0.5" + RIGHT_PARENTH + END;
						//str = MUL + SPACE + FT + regtempPbr.id + XYZ + COMMA + pNodeDiffuse.getComponentID(inputDiffuse.parentNodeItem.id) + XYZ + COMMA + FC + ONE + Y;
					}
					strVec.push(str);
					
					traceFt();
					
					var regtempEnvBRDF:RegisterItem = getFragmentTemp();//defaultLutReg
					if(!regtempEnvBRDF.hasInit){
						str = VEC4 + SPACE + FT + regtempEnvBRDF.id + SPACE + EQU + SPACE + DEFAULT_VEC4 + END;
						regtempEnvBRDF.hasInit = true;
						strVec.push(str);
					}
					traceFt();
					// ft0.xyz= fc0.xyz - vi1.xyz;
					//str = FT + regtempEnvBRDF.id + XYZ + SPACE + EQU + SPACE + FC + ONE + XYZ + SPACE + SUB_MATH + SPACE + VI + defaultPtReg.id + XYZ + END + LN;
					str = FT + regtempEnvBRDF.id + XYZ + SPACE + EQU + SPACE + camposStr + SPACE + SUB_MATH + SPACE + VI + defaultPtReg.id + XYZ + END + LN;
					str += FT + regtempEnvBRDF.id + XYZ + SPACE + EQU + SPACE + NRM + LEFT_PARENTH + FT + regtempEnvBRDF.id + XYZ + RIGHT_PARENTH + END + LN;
					str += FT + regtempEnvBRDF.id + Y + EQU + SPACE + DOT + LEFT_PARENTH + FT + regtempEnvBRDF.id + XYZ + COMMA + FT + regtempNormal.id + XYZ + RIGHT_PARENTH + END + LN;
					
					//"mov vt3.x,vc13.y\n" + //粗糙度
					//"sub vt1,vc12,vt0\n" + //cos = dot(N,V)
					//"nrm vt1.xyz,vt1.xyz\n" +
					//"mov ft1.x,fc7.z\n" + 
					//"dp3 ft1.y,vi2.xyz,ft3.xyz \n"+
					
					//str = SUB + SPACE + FT + regtempEnvBRDF.id + XYZ + COMMA + FC + TWO + XYZ + COMMA + VI + defaultPtReg.id + XYZ + LN;
					//str += NRM + SPACE + FT + regtempEnvBRDF.id + XYZ + COMMA + FT + regtempEnvBRDF.id + XYZ + LN;
					//str += DP3 + SPACE + FT + regtempEnvBRDF.id + Y + COMMA + FT + regtempEnvBRDF.id + XYZ + COMMA + FT + regtempNormal.id + XYZ  + LN; 
					
					var pNodeRoughness:NodeTree;
					if(inputRoughness.parentNodeItem){
						pNodeRoughness = inputRoughness.parentNodeItem.node;
						if(pNodeRoughness is NodeTreeFloat){
							roughness = NodeTreeFloat(pNodeRoughness).constValue;
						}else{
							roughness = 0.5;
						}
						str += FT + regtempEnvBRDF.id + X + SPACE + EQU + SPACE + pNodeRoughness.getComponentID(inputRoughness.parentNodeItem.id) + END + LN;
						//str += MOV + SPACE + FT + regtempEnvBRDF.id + X + COMMA +  pNodeRoughness.getComponentID(inputRoughness.parentNodeItem.id) + LN;
						inputRoughness.hasCompiled = true;
						pNodeRoughness.releaseUse();
					}else{
						roughness = 0.5;
						str += FT + regtempEnvBRDF.id + X + SPACE + EQU + SPACE + "0.5" + END + LN;
						//str += MOV + SPACE + FT + regtempEnvBRDF.id + X + COMMA + FC + TWO + W + LN;
					}
					
					// tex envBrdf
					var regtexEnvBRDF:RegisterItem = getFragmentTex();
					
					str += FT + regtempEnvBRDF.id + SPACE + EQU + SPACE + texture2D + LEFT_PARENTH + FS + regtexEnvBRDF.id + COMMA + FT + regtempEnvBRDF.id + XY + RIGHT_PARENTH + END;
					//str += TEX + SPACE + FT + regtempEnvBRDF.id + COMMA + FT + regtempEnvBRDF.id + XY + COMMA + FS + regtexEnvBRDF.id + SPACE + texType;
					
					strVec.push(str);
					texItem = new TexItem;
					texItem.id = regtexEnvBRDF.id;
					texItem.type = TexItem.LTUMAP;
					texVec.push(texItem);
					
					//SpecularColor * envBrdf.x + envBrdf.y
					str = FT + regtempPbr.id + XYZ + SPACE + EQU + SPACE + FT + regtempPbr.id + XYZ + SPACE + MUL_MATH + SPACE + FT + regtempEnvBRDF.id + X + SPACE;
					str += ADD_MATH + SPACE +  FT + regtempEnvBRDF.id + Y + END + LN;
					//str = MUL + SPACE + FT + regtempPbr.id + XYZ + COMMA + FT + regtempPbr.id + XYZ + COMMA + FT + regtempEnvBRDF.id + X + LN;
					//str += ADD + SPACE + FT + regtempPbr.id + XYZ + COMMA + FT + regtempPbr.id + XYZ + COMMA + FT + regtempEnvBRDF.id + Y + LN;
					
					if(regtempEnvBRDF){
						regtempEnvBRDF.inUse = false;
					}
					
					if(pNodeSpecular){
						//str += MUL + SPACE + FT + regtempPbr.id + XYZ + COMMA + FT + regtempPbr.id + XYZ + COMMA + pNodeSpecular.getComponentID(inputSpecular.parentNodeItem.id);
						str += FT + regtempPbr.id + XYZ + SPACE + EQU + SPACE + FT + regtempPbr.id + XYZ + SPACE + MUL_MATH + SPACE + pNodeSpecular.getComponentID(inputSpecular.parentNodeItem.id) + END;
						pNodeSpecular.releaseUse();
					}else{
						str += FT + regtempPbr.id + XYZ + SPACE + EQU + SPACE + FT + regtempPbr.id + XYZ + SPACE + MUL_MATH + SPACE + "0.5" + END + LN;
						//str += MUL + SPACE + FT + regtempPbr.id + XYZ + COMMA + FT + regtempPbr.id + XYZ + COMMA + FC + ONE + Y;
					}
					
					//trace(str);
					strVec.push(str);
					
					//specularIBL prefilteredColor * (SpecularColor * envBrdf.x + envBrdf.y) ;
					// tex prefilteredColor
					var regtexIBL:RegisterItem = getFragmentTex();
					
					//reflect(I,N)
					
					//"sub vt1,vt0,vc12 \n" + //反射方向  reflect = I - 2 * dot(N,I) * N
					//"nrm vt1.xyz,vt1.xyz\n" + 
					//"dp3 ft0.x,vi1.xyz,ft3.xyz \n"+//反射方向  reflect = I - 2 * dot(N,I) * N
					//	"mul ft0.xyz,ft3.xyz,ft0.x \n" +
					//	"mul ft0.xyz,ft0.xyz,fc7.y\n" +
					//	"sub ft0.xyz,vi1.xyz,ft0.xyz\n" +
					var regtempIBL:RegisterItem = getFragmentTemp();
					
					if(!regtempIBL.hasInit){
						str = VEC4 + SPACE + FT + regtempIBL.id + SPACE + EQU + SPACE + DEFAULT_VEC4 + END;
						regtempIBL.hasInit = true;
						strVec.push(str);
					}
					
					if(useDynamicIBL){
						/**
						str = MOV + SPACE + FT + regtempEnvBRDF.id + COMMA + VI + defaultLutReg.id + LN;
						str += DIV + SPACE + FT + regtempEnvBRDF.id + XY + COMMA + FT + regtempEnvBRDF.id + XY + COMMA + FT + regtempEnvBRDF.id + Z + LN;
						str += ADD + SPACE + FT + regtempEnvBRDF.id + XY + COMMA + FT + regtempEnvBRDF.id + XY + COMMA + FC + FOUR + XY + LN;
						str += DIV + SPACE + FT + regtempEnvBRDF.id + XY + COMMA + FT + regtempEnvBRDF.id + XY + COMMA + FC + FOUR + ZW + LN;
						
						str += MUL + SPACE + FT + regtempIBL.id + XYZ + COMMA + FT + regtempNormal.id + XYZ + COMMA + FC + ONE + W + LN;
						
						str += ADD + SPACE + FT + regtempEnvBRDF.id + X + COMMA + FT + regtempEnvBRDF.id + X + COMMA + FT + regtempIBL.id + X + LN;
						str += ADD + SPACE + FT + regtempEnvBRDF.id + Y + COMMA + FT + regtempEnvBRDF.id + Y + COMMA + FT + regtempIBL.id + Z + LN;
						
						str += TEX + SPACE + FT + regtempEnvBRDF.id + COMMA + FT + regtempEnvBRDF.id + XY + COMMA + FS + regtexIBL.id + SPACE + getTexType(1,0);
						*/
					}else{
						//
						//str = FT + regtempIBL.id + XYZ + SPACE + EQU + SPACE + VI + defaultPtReg.id + XYZ + SPACE + SUB_MATH + SPACE + FC + ONE + XYZ + END + LN;
						str = FT + regtempIBL.id + XYZ + SPACE + EQU + SPACE + VI + defaultPtReg.id + XYZ + SPACE + SUB_MATH + SPACE + camposStr + END + LN;
						str += FT + regtempIBL.id + XYZ + SPACE + EQU + SPACE + NRM + LEFT_PARENTH + FT + regtempIBL.id + XYZ + RIGHT_PARENTH + END + LN;
						str += FT + regtempIBL.id + XYZ + SPACE + EQU + SPACE + REFLECT + LEFT_PARENTH + FT + regtempIBL.id + XYZ + COMMA + FT + regtempNormal.id + XYZ + RIGHT_PARENTH + END + LN;
						str += FT + regtempIBL.id + SPACE + EQU + SPACE + textureCube + LEFT_PARENTH + FS + regtexIBL.id + COMMA + FT + regtempIBL.id + XYZ + RIGHT_PARENTH + END;
						//str = SUB + SPACE + FT + regtempIBL.id + XYZ + COMMA + VI + defaultPtReg.id + XYZ + COMMA + FC + TWO + XYZ + LN;
						//str += NRM + SPACE + FT + regtempIBL.id + XYZ + COMMA + FT + regtempIBL.id + XYZ + LN;
						//str += DP3 + SPACE + FT + regtempEnvBRDF.id + X + COMMA + FT + regtempIBL.id + XYZ + COMMA + FT + regtempNormal.id + XYZ  + LN;
						//str += MUL + SPACE + FT + regtempEnvBRDF.id + XYZ + COMMA + FT + regtempNormal.id + XYZ + COMMA + FT + regtempEnvBRDF.id + X + LN;
						//str += MUL + SPACE + FT + regtempEnvBRDF.id + XYZ + COMMA + FT + regtempEnvBRDF.id + XYZ + COMMA + FC + ZERO + Y + LN;
						//str += SUB + SPACE + FT + regtempEnvBRDF.id + XYZ + COMMA + FT + regtempIBL.id + XYZ + COMMA + FT + regtempEnvBRDF.id + XYZ + LN;
						//str += TEX + SPACE + FT + regtempEnvBRDF.id + COMMA + FT + regtempEnvBRDF.id + XYZ + COMMA + FS + regtexIBL.id + SPACE + texCubeType;
					}
					
					//trace(str);
					
					//trace(str);
					strVec.push(str);
					texItem = new TexItem;
					texItem.id = regtexIBL.id;
					texItem.type = TexItem.CUBEMAP;
					texVec.push(texItem);
					
					//str = FT + regtempIBL.id + XYZ + SPACE + EQU + SPACE + FT + regtempIBL.id + XYZ + SPACE +  MUL_MATH + SPACE + FC + ZERO + X + END;
					//strVec.push(str);
					
					str = FT + regtempPbr.id + XYZ + SPACE + EQU + SPACE + FT + regtempPbr.id + XYZ + SPACE + MUL_MATH + SPACE + FT + regtempIBL.id + XYZ + END;
					
					//str = MUL + SPACE + FT + regtempPbr.id + XYZ + COMMA + FT + regtempPbr.id + XYZ + COMMA + FT + regtempEnvBRDF.id + XYZ;
					//trace(str);
					strVec.push(str);
					
					regtempIBL.inUse = false;
					
					trace(str)
					
					//regtempEnvBRDF.inUse = false;
				}
				
				
				
				regOp = getFragmentTemp();//输出用临时寄存器
				
				if(!regOp.hasInit){
					str = VEC4 + SPACE + FT + regOp.id + SPACE + EQU + SPACE + DEFAULT_VEC4 + END;
					regOp.hasInit = true;
					strVec.push(str);
				}
				
				if(usePbr){
					//diffuseColor = basecolor * (1-metallic) 
					//f0.xyz = fc0.xyz * 
					//str = FT + regOp.id + XYZ + SPACE + EQU + SPACE + pNodeDiffuse.getComponentID(inputDiffuse.parentNodeItem.id) + SPACE + MUL_MATH + SPACE + FT + regtempLightMap.id + XYZ + END + LN;
					
					
					//var regtempMetallic:RegisterItem = getFragmentTemp();
					//str = MOV + SPACE + FT + regtempMetallic.id + X + COMMA + FC + ZERO + X + LN;
					if(pNodeMetallic){
						str = FT + regOp.id + XYZ + SPACE + EQU + SPACE + FT + regtempLightMap.id  + XYZ + SPACE + MUL_MATH + SPACE + LEFT_PARENTH 
							+ ONE_FLOAT + SUB_MATH + pNodeMetallic.getComponentID(inputMetallic.parentNodeItem.id) + RIGHT_PARENTH + END + LN;
						//str += SUB + SPACE + FT + regtempMetallic.id + X + COMMA + FT + regtempMetallic.id + X + COMMA + pNodeMetallic.getComponentID(inputMetallic.parentNodeItem.id);
						inputMetallic.hasCompiled = true;
						pNodeMetallic.releaseUse();
					}else{
						str = FT + regOp.id + XYZ + SPACE + EQU + SPACE + FT + regtempLightMap.id + XYZ + SPACE + MUL_MATH + SPACE + "0.5" + END + LN;
						//str += SUB + SPACE + FT + regtempMetallic.id + X + COMMA + FT + regtempMetallic.id + X + COMMA + FC + ONE + Y;
					}
					str += FT + regOp.id + XYZ + SPACE + EQU + SPACE + FT + regOp.id + XYZ + SPACE + ADD_MATH + SPACE + FT + regtempPbr.id + XYZ + END;
					
					//str = MUL + SPACE + FT + regOp.id + XYZ + COMMA + pNodeDiffuse.getComponentID(inputDiffuse.parentNodeItem.id) + COMMA + FT + regtempMetallic.id + X + LN;
					//str += MUL + SPACE + FT + regOp.id + XYZ + COMMA + FT + regOp.id + XYZ + COMMA + FT + regtempLightMap.id + XYZ  + LN;
					//str += ADD + SPACE + FT + regOp.id + XYZ + COMMA + FT + regOp.id + XYZ + COMMA +  FT + regtempPbr.id + XYZ;
					
					//regtempMetallic.inUse = false;
				}else{
					//ft2.xyz = ft0.xyz * ft1.xyz
					//str =  MUL + SPACE + FT + regOp.id + XYZ + COMMA + pNodeDiffuse.getComponentID(inputDiffuse.parentNodeItem.id) + COMMA + FT + regtempLightMap.id + XYZ;
					//str = FT + regOp.id + XYZ + SPACE + EQU + SPACE + FT + regtempLightMap.id + XYZ + SPACE + MUL_MATH + SPACE + FT + regtempLightMap.id + XYZ + END;
					//str =  MOV + SPACE + FT + regOp.id + XYZ + COMMA + FT + regtempLightMap.id + XYZ;
					str = FT + regOp.id + XYZ + SPACE + EQU + SPACE + FT + regtempLightMap.id + XYZ + END;
				}
				
				inputDiffuse.hasCompiled = true;
				//pNodeDiffuse.releaseUse();
				
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
					
					if(!regOp.hasInit){
						str = VEC4 + SPACE + FT + regOp.id + SPACE + EQU + SPACE + DEFAULT_VEC4 + END;
						regOp.hasInit = true;
						strVec.push(str);
					}
				}
				
				if(hasDiffuse){
					//op.xyz = op.xyz + ft0.xyz
					//str =  ADD + SPACE + FT + regOp.id + XYZ + COMMA + FT + regOp.id + XYZ + COMMA + pNodeEmissive.getComponentID(inputEmissive.parentNodeItem.id);
					//op.xyz = op.xyz + ft0.xyz
					str = FT + regOp.id + XYZ + SPACE + EQU + SPACE + FT + regOp.id + XYZ + SPACE + ADD_MATH + SPACE + pNodeEmissive.getComponentID(inputEmissive.parentNodeItem.id) + END;
				}else{
					//str =  MOV + SPACE + FT + regOp.id + XYZ + COMMA + pNodeEmissive.getComponentID(inputEmissive.parentNodeItem.id);
					//op.xyz = ft0.xyz
					str = FT + regOp.id + XYZ + SPACE + EQU + SPACE + pNodeEmissive.getComponentID(inputEmissive.parentNodeItem.id) + END;
				}
				strVec.push(str);
				
				pNodeEmissive.releaseUse();
			}
			
			//alpha
			str = new String;
			var inputAlpha:NodeTreeInputItem = $node.inputVec[7];
			if(!inputAlpha.parentNodeItem){
				//str = MOV + SPACE + FT + regOp.id + W + COMMA + FC + ZERO + X;
				//op.w = 1
				str = FT + regOp.id + W + SPACE + EQU + SPACE + ONE_FLOAT + END;
			}else{
				var pNodeAlpha:NodeTree = inputAlpha.parentNodeItem.node;
				//str = MOV + SPACE + FT + regOp.id + W + COMMA + pNodeAlpha.getComponentID(inputAlpha.parentNodeItem.id);
				//op.w = ft0.w
				str = FT + regOp.id + W + SPACE + EQU + SPACE + pNodeAlpha.getComponentID(inputAlpha.parentNodeItem.id) + END + LN;
				
				/*
				相对于之前剑域之后的修改 %%%%%%%%  (有可能出现新的问题) version:int = 34; 
				特别注意这是修改子这前的程序，删除了下面的这句
				str += FT + regOp.id + XYZ + SPACE + EQU + SPACE +  FT + regOp.id + XYZ + SPACE + MUL_MATH + SPACE + FT + regOp.id + W + END;
				*/
				pNodeAlpha.releaseUse();
			}
			strVec.push(str);
			
			//kill
			str = new String;
			var inputKill:NodeTreeInputItem = $node.inputVec[8];
			if(inputKill.parentNodeItem){
				var pNodeKill:NodeTree = inputKill.parentNodeItem.node;
				killNum = NodeTreeOP($node).killNum;
				
				//if(ft0.x < ft1.x){discard;}
				//str = IF + LEFT_PARENTH + pNodeKill.getComponentID(inputKill.parentNodeItem.id) + LEFT_BRACKET + FC + ZERO + Z + RIGHT_PARENTH + DISCARD;
				
				str = IF + LEFT_PARENTH + pNodeKill.getComponentID(inputKill.parentNodeItem.id) + LEFT_BRACKET + killStr + RIGHT_PARENTH + DISCARD;
				
				strVec.push(str);
				
				this.useKill = true;
			}
			
			var regtempFog:RegisterItem;
			if(fogMode == 1){
				regtempFog = getFragmentTemp();
				// sub ft0.xyz,fc3.xyz,vi4.xyz
				// dp3 ft0.x,ft0.xyz,ft0.xyz;
				// mul ft0.x,ft0.x,fc4.y
				//div ft0.x,fc4.z,ft0.x
				//mul ft0.xyz,fc4.xyz,ft0.x
				
				
				//str +=  FT + regtempFog.id + X + SPACE + EQU + SPACE + "distance("  +VI + defaultPtReg.id + XYZ+"*0.01" + COMMA + FC + ONE + XYZ +")*100.0" + END + LN;
				str =  FT + regtempFog.id + X + SPACE + EQU + SPACE + "distance("  +VI + defaultPtReg.id + XYZ+"*0.01" + COMMA + camposStr +")*100.0" + END + LN;
				
				
				//str += FT + regtempFog.id + X + SPACE + EQU + SPACE + FT + regtempFog.id + X + SPACE + SUB_MATH + SPACE + fogdata + X + END + LN;
				str += FT + regtempFog.id + X + SPACE + EQU + SPACE + FT + regtempFog.id + X + SPACE + SUB_MATH + SPACE + fogdataXStr + END + LN;
				//str += FT + regtempFog.id + X + SPACE + EQU + SPACE + fogdata + Y + SPACE + MUL_MATH + SPACE + FT + regtempFog.id + X + END + LN;
				str += FT + regtempFog.id + X + SPACE + EQU + SPACE + fogdataYStr + SPACE + MUL_MATH + SPACE + FT + regtempFog.id + X + END + LN;
				str += FT + regtempFog.id + X + SPACE + EQU + SPACE + TEX_WRAP_CLAMP + LEFT_PARENTH + FT + regtempFog.id + X + COMMA + "0.0" + COMMA + "1.0" + RIGHT_PARENTH + END + LN;
				//str += FT + regOp.id + XYZ + SPACE + EQU + SPACE + MIX + LEFT_PARENTH+ FT + regOp.id + XYZ + COMMA +   fogcolor+ XYZ + COMMA + FT + regtempFog.id + X + RIGHT_PARENTH + END;
				str += FT + regOp.id + XYZ + SPACE + EQU + SPACE + MIX + LEFT_PARENTH+ FT + regOp.id + XYZ + COMMA + fogcolorStr   + COMMA + FT + regtempFog.id + X + RIGHT_PARENTH + END;
				
				strVec.push(str);
			}else if(fogMode == 2){ 
				regtempFog = getFragmentTemp();
//				"ft1.x = distance(v1.xyz*0.01, fc2.xyz)*100.0;\n" +
//				"ft1.x = ft1.x - fogdata.x;\n"+
//				"ft1.x = fogdata.y * ft1.x;\n" +
//				"ft1.x = clamp(ft1.x,0.0,1.0);\n"+
//				"ft2.xyz = mix(ft2.xyz,fogcolor.xyz,ft1.x);\n" +
				
				//str = FT + regtempFog.id + X + SPACE + EQU + SPACE + VI + defaultPtReg.id + Y + SPACE + SUB_MATH + SPACE + fogdata + X + END + LN;
				str = FT + regtempFog.id + X + SPACE + EQU + SPACE + VI + defaultPtReg.id + Y + SPACE + SUB_MATH + SPACE + fogdataXStr + END + LN;
				//str += FT + regtempFog.id + X + SPACE + EQU + SPACE + FT + regtempFog.id + X + SPACE + MUL_MATH + SPACE + fogdata + Y + END + LN;
				str += FT + regtempFog.id + X + SPACE + EQU + SPACE + FT + regtempFog.id + X + SPACE + MUL_MATH + SPACE + fogdataYStr + END + LN;
				str += FT + regtempFog.id + X + SPACE + EQU + SPACE + FT + regtempFog.id + X + SPACE + ADD_MATH + SPACE + "1.0" + END + LN;
				str += FT + regtempFog.id + X + SPACE + EQU + SPACE + TEX_WRAP_CLAMP + LEFT_PARENTH + FT + regtempFog.id + X + COMMA + "0.0" + COMMA + "1.0" + RIGHT_PARENTH + END + LN;
				
				//str += FT + regOp.id + XYZ + SPACE + EQU + SPACE + MIX + LEFT_PARENTH + fogcolor + XYZ + COMMA + FT + regOp.id + XYZ + COMMA + FT + regtempFog.id + X + RIGHT_PARENTH + END;
				str += FT + regOp.id + XYZ + SPACE + EQU + SPACE + MIX + LEFT_PARENTH + fogcolorStr + COMMA + FT + regOp.id + XYZ + COMMA + FT + regtempFog.id + X + RIGHT_PARENTH + END;
				strVec.push(str);
				
			}
			
			str = new String;
			//"gl_FragColor = infoUv;\n" +
			str = FO + SPACE + EQU + SPACE + FT + regOp.id + END;
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
			
			var resultStr:String;
			
			if(regtemp.hasInit){
				resultStr = FT + regtemp.id;
			}else{
				resultStr = VEC4 + SPACE + FT + regtemp.id;
				regtemp.hasInit = true;
			}
			
			str = resultStr + SPACE + EQU + SPACE + texture2D + LEFT_PARENTH + FS + regtex.id + COMMA + VI + defaultPtReg.id + RIGHT_PARENTH + END + LN;
			//str = TEX + SPACE + FT + regtemp.id + COMMA + VI + defaultPtReg.id + COMMA + FS + regtex.id + SPACE + texType;
			//
			//ft5.xyz = ft5.xyz * ft5.w
			str += FT + regtemp.id + XYZ + SPACE + EQU + SPACE + FT + regtemp.id + XYZ + SPACE + MUL_MATH + SPACE + FT + regtemp.id + W + END;
			
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
			
			var regtex:RegisterItem = getFragmentTex(NodeTreeTex($node));
			var regtemp:RegisterItem = getFragmentTemp();
			
			//"vec4 infoUv = texture2D(s_texture, v_texCoord.xy);\n" +
			
			var resultStr:String;
			
			if(regtemp.hasInit){
				resultStr = FT + regtemp.id;
			}else{
				resultStr = VEC4 + SPACE + FT + regtemp.id;
				regtemp.hasInit = true;
			}
			if(input.parentNodeItem){
				var pNode:NodeTree = input.parentNodeItem.node;
				//str = TEX + SPACE + FT + regtemp.id + COMMA + pNode.getComponentID(input.parentNodeItem.id) + COMMA + FS + regtex.id + SPACE + getTexType(NodeTreeTex($node).wrap);
				str = resultStr + SPACE + EQU + SPACE + texture2D + LEFT_PARENTH + FS + regtex.id + COMMA + pNode.getComponentID(input.parentNodeItem.id) + RIGHT_PARENTH + END;
			}else{
				//str = TEX + SPACE + FT + regtemp.id + COMMA + VI + defaultUvReg.id + COMMA + FS + regtex.id + SPACE + getTexType(NodeTreeTex($node).wrap);
				
				str = resultStr + SPACE + EQU + SPACE + texture2D + LEFT_PARENTH + FS + regtex.id + COMMA + VI + defaultUvReg.id + RIGHT_PARENTH + END;
			}
			if(NodeTreeTex($node).permul){
				str += LN + FT + regtemp.id + XYZ + SPACE + MUL_EQU_MATH + SPACE + FT + regtemp.id + W + END;
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
		
		private function getTexType(wrpaType:int,lerpType:int=0):String{
			var wrapStr:String;
			var lerpStr:String;
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

			return LEFT_BRACKET + TEX_2D + COMMA + lerpStr + COMMA + wrapStr + RIGHT_BRACKET;
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
			
			if(!regtemp.hasInit){//vec4(0,0,0,0)
				str = VEC4 + SPACE + FT + regtemp.id + SPACE + EQU + SPACE + DEFAULT_VEC4 + END + LN;
				regtemp.hasInit = true;
			}
			str += FT + regtemp.id + getComByType(output.type) + SPACE + EQU + SPACE;
			str += MIX + LEFT_PARENTH + pNode0.getComponentID(input0.parentNodeItem.id) + COMMA;
			str += pNode1.getComponentID(input1.parentNodeItem.id) + COMMA;
			str += pNodeAlpah.getComponentID(inputAlpha.parentNodeItem.id) + RIGHT_PARENTH + END;
			//ft3 = mix(ft0,ft1,ft2)
			
			
//			var regtemp2:RegisterItem = getFragmentTemp();
//			
//			str = MUL + SPACE + FT + regtemp.id + getComByType(output.type) + COMMA;
//			str += pNode0.getComponentID(input0.parentNodeItem.id) + COMMA;
//			str += pNodeAlpah.getComponentID(inputAlpha.parentNodeItem.id);
//			
//			str += LN;
//			if(inputAlpha.parentNodeItem.node is NodeTreeFloat){
//				str += MOV + SPACE + FT + regtemp2.id + X + COMMA + FC + ZERO + X + LN;
//				str += SUB + SPACE + FT + regtemp2.id + X + COMMA + FT + regtemp2.id + X + COMMA + pNodeAlpah.getComponentID(inputAlpha.parentNodeItem.id) + LN;
//			}else{
//				str += SUB + SPACE + FT + regtemp2.id + X + COMMA + FC + ZERO + X + COMMA + pNodeAlpah.getComponentID(inputAlpha.parentNodeItem.id) + LN;
//			}
//			
//			str += MUL + SPACE + FT + regtemp2.id + getComByType(output.type) + COMMA;
//			str += pNode1.getComponentID(input1.parentNodeItem.id) + COMMA;
//			str += FT + regtemp2.id + X + LN ;
//			
//			str +=  ADD + SPACE + FT + regtemp.id + getComByType(output.type) + COMMA;
//			str += FT + regtemp.id + getComByType(output.type) + COMMA;
//			str += FT + regtemp2.id + getComByType(output.type);
//			
//			regtemp2.inUse = false;
			
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
			
			var resultStr:String = new String;
			
			//"vec4 ft0 = vec4(0,0,0,0);
			if(!regtemp.hasInit && !(input0.type == MaterialItemType.VEC4 || input1.type == MaterialItemType.VEC4)){//vec4(0,0,0,0)
				resultStr = VEC4 + SPACE + FT + regtemp.id + SPACE + EQU + SPACE + DEFAULT_VEC4 + END + LN;
				regtemp.hasInit = true;
			}
			
			//"vec4 info = infoUv * infoLight;\n" +
			
			if(input0.type == MaterialItemType.VEC4 || input1.type == MaterialItemType.VEC4){
				//str = opCode + SPACE + FT + regtemp.id + COMMA;
				if(!regtemp.hasInit){
					resultStr = VEC4 + SPACE;
					regtemp.hasInit = true;
				}
				str = FT + regtemp.id + SPACE + EQU + SPACE;
			}else if(output.type == MaterialItemType.FLOAT){
				//str = opCode + SPACE + FT + regtemp.id + X + COMMA;
				str = FT + regtemp.id + X + SPACE + EQU + SPACE;
			}else if(output.type == MaterialItemType.VEC2){
				//str = opCode + SPACE + FT + regtemp.id + XY + COMMA;
				str = FT + regtemp.id + XY + SPACE + EQU + SPACE;
			}else if(output.type == MaterialItemType.VEC3){
				//str = opCode + SPACE + FT + regtemp.id + XYZ + COMMA;
				str = FT + regtemp.id + XYZ + SPACE + EQU + SPACE;
			}
			
			str += pNode0.getComponentID(input0.parentNodeItem.id);
			
			str += SPACE + opCode + SPACE;
			
			str += pNode1.getComponentID(input1.parentNodeItem.id);
			
			str = resultStr + str + END;
			
			
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
			
			
			if(!regtemp.hasInit){//vec4(0,0,0,0)
				str = VEC4 + SPACE + FT + regtemp.id + SPACE + EQU + SPACE + DEFAULT_VEC4 + END + LN;
				regtemp.hasInit = true;
			}
			// ft0.x = sin(ft1.x);
			str += FT + regtemp.id + X + SPACE + EQU + SPACE + opCode + LEFT_PARENTH + pNode.getComponentID(input.parentNodeItem.id) + RIGHT_PARENTH + END;
			//str += opCode + SPACE + FT + regtemp.id + X + COMMA + pNode.getComponentID(input.parentNodeItem.id);
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