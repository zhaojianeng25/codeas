package view.meshSort
{
	import _Pan3D.base.MeshData;
	import _Pan3D.base.ObjectBone;
	import _Pan3D.base.ObjectTri;
	import _Pan3D.base.ObjectUv;
	import _Pan3D.base.ObjectWeight;
	
	import _me.Scene_data;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.collections.ArrayCollection;
	
	import view.action.ActionPanel;
	import view.mesh.MeshPanel;
	/**
	 * 
	 * @author liuyanfei QQ:421537900
	 *  </p>此类用来处理骨骼排序问题
	 * </br>把所有的骨骼按照先bip后weapon最后bone的序列排序
	 * </br>这样保证正确的处理换武器的问题
	 */	
	public class MeshSortUtils
	{
		private static var SPACE:String = " ";
		private static var LEFT:String = "(";
		private static var RIGHT:String = ")";
		
		private var newBoneNameAry:Array;

		private var actionAry:ArrayCollection;
		private var meshDataAry:Array;

		//private var mapkeyAry:Array;
		
		private var backupUrl:String = "file:///D:/BoneAnimApp%e5%a4%87%e4%bb%bd/";
		public function MeshSortUtils()
		{
		}
		/**
		 * 排序 对骨骼进行排序 bip>weapon>bone 
		 * 
		 */		
		public function sort():void{
			
			actionAry = ActionPanel.getInstance().dataAry;
			for(var i:int;i<actionAry.length;i++){
				processBoneNew(actionAry[i].hierarchy,actionAry[i]);
			}
			//return;
			var meshAry:ArrayCollection = MeshPanel.getInstance().treeAry;
			meshDataAry = new Array;
			for(i=0;i<meshAry.length;i++){
				for(var j:int=0;j<meshAry[i].children.length;j++){
					meshDataAry.push(meshAry[i].children[j]);
				}
			}
			
			for(i=0;i<meshDataAry.length;i++){
				var file:File = new File(Scene_data.md5Root + meshDataAry[i].url);
				//var url:String = file.parent.url + "/" + file.name.split(".")[0] + "_r.md5mesh" 
				processMesh(meshDataAry[i].data,file. url);
			}
			//trace(1);
			
			
			
		}
		
		public function processMesh(meshData:MeshData,url:String):void{
			var weightAry:Vector.<ObjectWeight> = new Vector.<ObjectWeight>;
			for(var i:int;i<meshData.weightItem.length;i++){
				weightAry.push(meshData.weightItem[i].clone());
			}
			
			var mapkeyAry:Array = getMapValue(meshData.boneItem);
			
			for(i=0;i<weightAry.length;i++){
				//trace(weightAry[i].boneId,mapkeyAry[weightAry[i].boneId])
				weightAry[i].boneId = mapkeyAry[weightAry[i].boneId]
			}
			//trace(1);
			
			var resultStr:String = new String;
			var vertStr:String = new String;
			var triStr:String = new String;
			var weightStr:String = new String;
			
			var vertAry:Vector.<ObjectUv> = meshData.uvItem;
			var triAry:Vector.<ObjectTri> = meshData.triItem;
			
			
			
			for(i=0;i<vertAry.length;i++){
				vertStr += "\tvert" + SPACE + vertAry[i].id + SPACE 
					+ LEFT + SPACE + vertAry[i].x + SPACE + vertAry[i].y + SPACE + RIGHT + SPACE + vertAry[i].a + SPACE + vertAry[i].b + "\r\n";//vert 0 ( 1.0 1.0 ) 0 1
			}
			
			for(i=0;i<triAry.length;i++){
				triStr += "\ttri" + SPACE + triAry[i].id + SPACE + triAry[i].t0 + SPACE + triAry[i].t1 + SPACE + triAry[i].t2 + "\r\n";//tri 0 0 2 1
			}
			
			for(i=0;i<weightAry.length;i++){
				weightStr += "\tweight" + SPACE + weightAry[i].id + SPACE + weightAry[i].boneId + SPACE + weightAry[i].w 
					+ SPACE + LEFT + SPACE + weightAry[i].x + SPACE + weightAry[i].y + SPACE + weightAry[i].z + SPACE + RIGHT + "\r\n"//weight 0 0 1.0 ( 16.4771 -8.70046 8.20959 )
			}
			
			resultStr = "mesh {\r\n" 
			resultStr += "\tnumverts " + vertAry.length + "\r\n" + vertStr + "\r\n" ;
			resultStr += "\tnumtris " + triAry.length + "\r\n" + triStr + "\r\n";
			resultStr += "\tnumweights " + weightAry.length + "\r\n" +  weightStr + "}";
			resultStr = "resort 1\r\n" + resultStr;
			//trace(resultStr);
			var file:File = new File(url);
			
			var readStream:FileStream = new FileStream;
			readStream.open(file,FileMode.READ);
			var soureStr:String = readStream.readUTFBytes(readStream.bytesAvailable);
			readStream.close();
			
			if(soureStr.indexOf("resort") == -1){
				file = new File(url);
				var fs:FileStream = new FileStream;
				fs.open(file,FileMode.WRITE);
				fs.writeUTFBytes(resultStr);
				fs.close();
			}
			
		}
		/**
		 * 处理一个骨骼 
		 * @param targetAry 基础骨骼数据
		 * @param action 动作骨骼数据
		 * 
		 */		
		public function processBoneNew(targetAry:Vector.<ObjectBone>,action:Object):void{

			
			var newTargetAry:Vector.<ObjectBone> = new Vector.<ObjectBone>;
			//添加bip骨骼到新数组
			for(var i:int;i<targetAry.length;i++){
				if(targetAry[i].name.indexOf("Bip") != -1){
					newTargetAry.push(targetAry[i]);
				}
			}
			//添加weapon骨骼到新数组
			for(i = 0;i<targetAry.length;i++){
				if(targetAry[i].name.indexOf("weapon") != -1){
					newTargetAry.push(targetAry[i]);
				}
			}
			//添加剩余的骨骼到新数组
			for(i = 0;i<targetAry.length;i++){
				if(newTargetAry.indexOf(targetAry[i]) == -1){
					newTargetAry.push(targetAry[i]);
				}
			}
			
			var mapkeyAry:Array = new Array;//新旧ID映射关系
			
			for(i = 0;i<targetAry.length;i++){
				var index:int = newTargetAry.indexOf(targetAry[i]);
				mapkeyAry.push(index);
			}
			//trace(mapkeyAry);
			
			var resultAry:Vector.<ObjectBone> = new Vector.<ObjectBone>;//最终更新的数据
			for(i = 0;i<newTargetAry.length;i++){//数据复制
				resultAry.push(newTargetAry[i].clone());
			}
			
			for(i=0;i<resultAry.length;i++){//从映射关系更新父级id
				index = resultAry[i].father;
				if(index != -1){
					resultAry[i].father = mapkeyAry[index];
				}
			}
			
			
			var baseFrameAry:Array = getBaseFrameAry(getBaseFrameStr(action.strAry));//基础帧的数组
			
			trace(resultAry.length,baseFrameAry.length);
			trace(baseFrameAry);
			
			var newBaseFrameAry:Array = new Array(baseFrameAry.length);//根据映射关系更新基础帧的数据
			for(i=0;i<baseFrameAry.length;i++){
				//newBaseFrameAry.push(baseFrameAry[mapkeyAry[i]])
				newBaseFrameAry[mapkeyAry[i]] = baseFrameAry[i];
			}
			
			var hierarchy:String = getHierarchy(resultAry);//骨骼数据组合后的字符串
			var baseframeStr:String = getBaseFrame(newBaseFrameAry);//基础帧组合后的字符串
			
			var allStr:String = hierarchy + baseframeStr;
			var start:int = frameStartIndex(action.strAry);
			for(i=start;i<action.strAry.length;i++){
				var framestr:String = converFrame(action.strAry[i]);
				allStr += framestr + "\r\n";//action.strAry[i];
			}
			trace(allStr);
			allStr = "resort 1\r\n" + allStr;//写入字符串表示已经处理过排序（跳过备份）
			
			if(action.nameHeight){
				allStr = "nameheight " + action.nameHeight  + "\r\n" + allStr;
			}
			
			if(action.bound){//写入盒子信息
				var boundstr:String = new String;
				for(i=0;i<action.bound.length;i++){
					boundstr += action.bound[i].x + "," + action.bound[i].y + "," + action.bound[i].z + ","
				}
				allStr = "mybounds " + boundstr  + "\r\n" + allStr;
			}
			
			if(action.interAry ){//写入插帧值信息
				var interStr:String = new String;
				for(i=0;i<action.interAry.length;i++){
					interStr += action.interAry[i]+",";
				}
				allStr = "inter " + interStr + "\r\n" + allStr;
			}
			
			if(action.inLoop){//写入循环帧信息
				allStr = "inLoop " + action.inLoop  + "\r\n" + allStr;
			}
			
			var file:File = new File(Scene_data.md5Root + action.url);
			var readStream:FileStream = new FileStream;
			readStream.open(file,FileMode.READ);
			var soureStr:String = readStream.readUTFBytes(readStream.bytesAvailable);
			readStream.close();
			if(soureStr.indexOf("resort") == -1){//如果已经排序则不需要备份
				var backUpFile:File = new File(backupUrl + action.url);
				file.copyTo(backUpFile,true);
			}
			
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.WRITE);
			fs.writeUTFBytes(allStr);
			fs.close();
		}
		/**
		 * 从字符数组中找到baseframe所在的字符串 
		 * @param ary
		 * @return 
		 * 
		 */		
		private function getBaseFrameStr(ary:Array):String{
			for(var i:int;i<ary.length;i++){
				var str:String = ary[i];
				if(str.indexOf("baseframe") != -1){
					return str;
				}
			}
			return "";
		}
		/**
		 * frame 开始的位置 
		 * @param ary
		 * @return 
		 * 
		 */		
		private function frameStartIndex(ary:Array):int{
			for(var i:int;i<ary.length;i++){
				var str:String = ary[i];
				if(str.indexOf("frame 0") != -1){
					return i;
				}
			}
			return 0;
		}
				
		private function getHierarchy(ary:Vector.<ObjectBone>):String{
			var str:String = new String;
			for(var i:int;i<ary.length;i++){
				str += "\t\"" + ary[i].name + "\"\t" + ary[i].father + " " + ary[i].changtype + " " + ary[i].startIndex + "\t//\r\n "; //"Bip01"	-1 63 0	
			}
			
			str = "hierarchy {\r\n" + str + "}\r\n"
			return str;
		}
		
		private function getBaseFrame(ary:Array):String{
			var str:String = new String;
			for(var i:int;i<ary.length;i++){
				str += ary[i] + "\r\n"
			}
			str = "baseframe {\r\n" + str + "}\r\n";
			return str;
		}
		
		private function getBaseFrameAry(str:String):Array{
			var ary:Array = str.split("\n\r");
			var newAry:Array = new Array;
			for(var i:int;i<ary.length;i++){
				var s:String = ary[i];
				if(s == "" || s.indexOf("{") != -1 || s.indexOf("}") != -1){
					continue;
				}
				newAry.push(ary[i]);
			}
			return newAry;
		}
		
		private function converFrame(str:String):String{
			var reg:RegExp = /\n\r/g;
			str = str.replace(reg,"\r\n");
			return str;
		}
		/**
		 * 返回映射关系列表 
		 * @param targetAry
		 * @return 
		 * 
		 */		
		public function getMapValue(targetAry:Vector.<ObjectBone>):Array{
			var newTargetAry:Vector.<ObjectBone> = new Vector.<ObjectBone>;
			//添加bip骨骼到新数组
			for(var i:int;i<targetAry.length;i++){
				if(targetAry[i].name.indexOf("Bip") != -1){
					newTargetAry.push(targetAry[i]);
				}
			}
			//添加weapon骨骼到新数组
			for(i = 0;i<targetAry.length;i++){
				if(targetAry[i].name.indexOf("weapon") != -1){
					newTargetAry.push(targetAry[i]);
				}
			}
			//添加剩余的骨骼到新数组
			for(i = 0;i<targetAry.length;i++){
				if(newTargetAry.indexOf(targetAry[i]) == -1){
					newTargetAry.push(targetAry[i]);
				}
			}
			
			var mapkeyAry:Array = new Array;//新旧ID映射关系
			
			for(i = 0;i<targetAry.length;i++){
				var index:int = newTargetAry.indexOf(targetAry[i]);
				mapkeyAry.push(index);
			}
			return mapkeyAry;
		}
		
	}
}