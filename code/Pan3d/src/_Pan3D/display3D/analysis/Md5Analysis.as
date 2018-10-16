package _Pan3D.display3D.analysis {
	import flash.utils.Dictionary;
	
	import _Pan3D.base.MeshData;
	import _Pan3D.base.ObjectBone;
	import _Pan3D.base.ObjectTri;
	import _Pan3D.base.ObjectUv;
	import _Pan3D.base.ObjectWeight;
	import _Pan3D.core.MathClass;

	
		/**
		 * @author liuyanfei  QQ: 421537900
		 */
		public class Md5Analysis
		{
			public function Md5Analysis():void {
				
			}
			private function joinUV(meshData:MeshData):void{
				var _meshNumverts:Array=meshData.mesh["numverts"];
				var _str:String="";
				var _arr:Array=new Array();
				var i:Number=0;
				for( i=0;i<_meshNumverts.length;i++){
					_str=genewStr(_meshNumverts[i]);
					_arr=_str.split(" ");
					var _temp:ObjectUv=new ObjectUv();
					_temp.id=_arr[1];
					_temp.x=_arr[2];
					_temp.y=_arr[3];
					_temp.a=_arr[4];
					_temp.b=_arr[5];
					
					meshData.uvItem.push(_temp);
				}
			}
			private function joinPoint(meshData:MeshData):void{
				var _meshNumweights:Array=meshData.mesh["numweights"];
				var _str:String="";
				var _arr:Array=new Array();
				var i:Number=0;
				for( i=0;i<_meshNumweights.length;i++){
					_str=genewStr(_meshNumweights[i]);
					_arr=_str.split(" ");
					var _temp:ObjectWeight=new ObjectWeight();
					_temp.id=_arr[1];
					_temp.boneId=_arr[2];
					_temp.w=_arr[3];
					_temp.x=_arr[4];
					_temp.y=_arr[5];
					_temp.z=_arr[6];
					meshData.weightItem.push(_temp);
				}
			}

			public function joinTri(meshData:MeshData):void{
				var _meshNumtris:Array = meshData.mesh["numtris"];
				var _str:String="";
				var _arr:Array=new Array();
				var i:Number=0;
				for( i=0;i<_meshNumtris.length;i++){
					_str=genewStr(_meshNumtris[i]);
					_arr=_str.split(" ");
					var _temp:ObjectTri=new ObjectTri();
					_temp.id=_arr[1];
					_temp.t0=_arr[2];
					_temp.t1=_arr[3];
					_temp.t2=_arr[4];
					meshData.triItem.push(_temp);
				}
			}
			
			
			public function joinJoints(meshData:MeshData):void{
				var jointAry:Array = meshData.mesh["joints"];
				var boneAry:Vector.<ObjectBone> = new Vector.<ObjectBone>
				for(var i:int;i<jointAry.length;i++){
					var line:String=jointAry[i];
					if(line.length <9){
						break;
					}
					 var boneName:String = line.match(/\".+\"/)[0]
					 line=line.replace(boneName,"")
					var boneNameAry:Array =			MathClass.getArrByStr(line);
					if(boneNameAry.length == 1){
						break;
					}
					
					var bone:ObjectBone = new ObjectBone();
					bone.name = boneName
					bone.father = boneNameAry[0];
					bone.tx = boneNameAry[2];
					bone.ty = boneNameAry[3];
					bone.tz = boneNameAry[4];
					
					bone.qx = boneNameAry[7];
					bone.qy = boneNameAry[8];
					bone.qz = boneNameAry[9];
					meshData.boneItem.push(bone);
				}
				
			}

			private function genewStr(_str:String):String
			{
				var _s:String="";
				var _t:String="";
				var _e:String=" ";
				var i:Number=0;
				while(i<_str.length){
					_t=_str.charAt(i);
					switch (_t) {
						case "(":
							break;
						case ")":
							break;
						case "\"":
							break;
						case "	":
							if(_e!=" "){
								_s=_s+" ";
							}
							_e=" ";
							break;
						case " ":
							if(_e!=" "){
								_s=_s+" ";
							}
							_e=" ";
							break;
						default:
							_s=_s+_t;
							_e=_t;
							break;
					}
					
					i++;
				}
//				trace(_str)
//				trace(_s)
//				trace("------------")
				return _s;
			}
			
		/**
		 * mesh信息
		 * */
		//public var mesh:Dictionary = new Dictionary();

		
		public function addMesh(str:String,flg:int=0):MeshData{
			var arr:Array;
			
			str=str.replace("origin","Bip001234") //特殊转换
			str=str.replace("Root","Bip002234") //特殊转换
			if (str.indexOf("mesh") != -1) {
				//存入没一个元件MESH;
				var meshData:MeshData = new MeshData();
				var meshSmaple:Dictionary = new Dictionary();
				if(flg==0){
					arr = str.split("\n\r");
				}else{
					arr = str.split("\r\n");
				}
				
				arr= str.split(/[\n\r]{2}/);
				
				var numverts:Boolean = false;
				
				var numvertsIndex:int = 0;
				
				var currentnumvertsIndex:int = 0;
				
				var numvertsArray:Array = new Array();
				
				var numtris:Boolean = false;
				
				var numtrisIndex:int = 0;
				
				var currentnumtrisIndex:int = 0;
				
				var numtrisArray:Array = new Array();
				
				var numweights:Boolean = false;
				
				var numweightsIndex:int = 0;
				
				var currentnumweightsIndex:int = 0;
				
				var numweightsArray:Array = new Array();
				
				var joints:Boolean;
				
				var jointAry:Array = new Array;
				
				var reg:RegExp = /\d+/;
				
				for (var m:int = 0 ; m < arr.length ; m++) {
					
					if (numverts) {
						
						if (currentnumvertsIndex < numvertsIndex) {
							
							numvertsArray.push(arr[m]);
							
							currentnumvertsIndex++;
							
						} else {
							
							//mesh["numverts"] = numvertsArray;
							meshSmaple["numverts"] = numvertsArray;
							
							
							numverts = false;
						}
					}
					
					if (numtris) {
						
						if (currentnumtrisIndex < numtrisIndex) {
							
							numtrisArray.push(arr[m]);
							
							currentnumtrisIndex++;
							
						} else {
							
							//mesh["numtris"] = numtrisArray;
							meshSmaple["numtris"] = numtrisArray;
							
							numtris = false;
						}
					}
					
					if (numweights) {
						
						if (currentnumweightsIndex < numweightsIndex) {
							
							numweightsArray.push(arr[m]);
							
							currentnumweightsIndex++;
							
						} else {
							
							//mesh["numweights"] = numweightsArray;
							meshSmaple["numweights"] = numweightsArray;
							
							numweights = false;
						}
					}
					
					if(joints){
						
						jointAry.push(arr[m]);
						
					}
					
					if (String(arr[m]).indexOf("numverts") != -1) {
						
						numverts = true;
						
						numvertsIndex = String(arr[m]).match(reg)[0];
						
					}
					
					if (String(arr[m]).indexOf("numtris") != -1) {
						
						numtris = true;
						
						numtrisIndex = String(arr[m]).match(reg)[0];
						
					}
					
					if (String(arr[m]).indexOf("numweights") != -1) {
						
						numweights = true;
						
						numweightsIndex = String(arr[m]).match(reg)[0];
						
					}
					
					if (String(arr[m]).indexOf("joints") != -1) {
						
						joints = true;
						
					}
					
					if (String(arr[m]).indexOf("mesh") != -1) {
						
						joints = false;
						meshSmaple["joints"] = jointAry;
					}
					if (String(arr[m]).indexOf("commandline") != -1) {
				
					
					}
					
					
				}
				meshData.mesh=meshSmaple;
				joinTri(meshData);
				joinPoint(meshData);
				joinUV(meshData);
				joinJoints(meshData);
			
				
				return meshData;
			}
			return null;
		}
			
		}
		
}

