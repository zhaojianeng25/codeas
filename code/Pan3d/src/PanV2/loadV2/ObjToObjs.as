package  PanV2.loadV2
{
	import _Pan3D.base.ObjData;
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;

	public class ObjToObjs
	{
		private const LINE_FEED:String = String.fromCharCode(10);
		private const SPACE:String = String.fromCharCode(32);
		private const SLASH:String = "/";
		private const VERTEX:String = "v";
		private const NORMAL:String = "vn";
		private const UV:String = "vt";
		private const INDEX_DATA:String = "f";
		private const USEMTL:String = "usemtl";

		public function ObjToObjs()
		{
		}
		public function loadObjUrl($url:String,$fun:Function=null):void
		{
			_bFun=$fun
			var loaderinfo : LoadInfo = new LoadInfo($url, LoadInfo.XML, onObjLoad,0);
			LoadManager.getInstance().addSingleLoad(loaderinfo);
		}
		private var _bFun:Function
		protected function onObjLoad(definition : String) : void {
	
			if(!baseObjData){
				baseObjData=new ObjData();
				baseObjData.vertices=new Vector.<Number>
				baseObjData.normals=new Vector.<Number>
				baseObjData.uvs=new Vector.<Number>
				baseObjData.indexs=new Vector.<uint>
			}
			objsItem=new Vector.<ObjData>
			
			var lines:Array = definition.split(LINE_FEED);
			var loop:uint = lines.length;
			for(var i:uint = 0; i < loop; ++i)
			{
				parseLine(lines[i]);
			}
			
       
			var $meshArr:Array=new Array
			for(var j:uint=0;j<objsItem.length;j++){
				var $obj:Object=new Object
					
				$obj.mtl = "box512";
				$obj.vertices = objsItem[j].vertices;
				$obj.uvs = objsItem[j].uvs;
				$obj.normals=objsItem[j].normals;
				$obj.indexs =new Vector.<uint>
				if(objsItem[j].uvs.length<=0)
				{
					for(var a:uint=0;a<$obj.vertices.length/3;a++){
						$obj.uvs.push(0,0)
					}
				}
				for(var k:uint=0;k<$obj.vertices.length/3;k++){
					$obj.indexs.push(k)
				}
				$meshArr.push($obj)
					
			

			}
			if(Boolean(_bFun)){
				_bFun($meshArr);
			}

	
		}
		
		private var objsItem:Vector.<ObjData>;
		private var baseObjData:ObjData;

		
		private function parseVertex(data:Array):void
		{
			var loop:uint = data.length;
			for (var i:uint = loop-3; i < loop; ++i)
			{
				var element:String = data[i];
				baseObjData.vertices.push(Number(element));
			}

		}
		private function parseNormal(data:Array):void
		{
			var loop:uint = data.length;
			for (var i:uint = loop-3; i < loop; ++i)
			{
				var element:String = data[i];
				baseObjData.normals.push(Number(element));
			}

		}
		private function parseUv(data:Array):void
		{
			var loop:uint = data.length;
			//只取xy
			for (var i:uint = loop-3; i < loop-1; ++i)
			{
				var element:String = data[i];
				baseObjData.uvs.push(Number(element));
			}


		}
		private function parseIndex(data:Array):void
		{

			
	
			var arr:Array=new Array
			for(var i:uint=0;i<data.length;i++)
			{
				if(data[i].length>3){
					arr.push(data[i])
				}
			}
			var tempObjData:ObjData=objsItem[objsItem.length-1]
			makeData(String(arr[0]).split("/"),String(arr[1]).split("/"),String(arr[2]).split("/"))
			if(arr.length==4){
				makeData(String(arr[0]).split("/"),String(arr[2]).split("/"),String(arr[3]).split("/"))
			}
		
			function makeData(a:Array,b:Array,c:Array):void
			{
				if(Number(a[1])==0){
					addVertex(a[0]-1,b[0]-1,c[0]-1)
					addNor(a[2]-1,b[2]-1,c[2]-1)
				}else{
					addVertex(a[0]-1,b[0]-1,c[0]-1)
					addUv(a[1]-1,b[1]-1,c[1]-1)
					addNor(a[2]-1,b[2]-1,c[2]-1)
				}
				
			}
			function addNor(a:uint,b:uint,c:uint):void
			{
				tempObjData.normals.push(baseObjData.normals[a*3+0],baseObjData.normals[a*3+1],baseObjData.normals[a*3+2])
				tempObjData.normals.push(baseObjData.normals[b*3+0],baseObjData.normals[b*3+1],baseObjData.normals[b*3+2])
				tempObjData.normals.push(baseObjData.normals[c*3+0],baseObjData.normals[c*3+1],baseObjData.normals[c*3+2])
			}
			function addUv(a:uint,b:uint,c:uint):void
			{
				tempObjData.uvs.push(baseObjData.uvs[a*2+0],baseObjData.uvs[a*2+1])
				tempObjData.uvs.push(baseObjData.uvs[b*2+0],baseObjData.uvs[b*2+1])
				tempObjData.uvs.push(baseObjData.uvs[c*2+0],baseObjData.uvs[c*2+1])
			}
			function addVertex(a:uint,b:uint,c:uint):void
			{
				tempObjData.vertices.push(baseObjData.vertices[a*3+0],baseObjData.vertices[a*3+1],baseObjData.vertices[a*3+2])
				tempObjData.vertices.push(baseObjData.vertices[b*3+0],baseObjData.vertices[b*3+1],baseObjData.vertices[b*3+2])
				tempObjData.vertices.push(baseObjData.vertices[c*3+0],baseObjData.vertices[c*3+1],baseObjData.vertices[c*3+2])
			}
		}
		private function parseLine(line:String):void
		{
			var words:Array = line.split(SPACE);
			if (words.length > 0){
				var data:Array = words.slice(1);
			}
			else{
				return;
			}
			var firstWord:String = words[0];
			if(firstWord=="#",words.length>2){
				if(words[1]=="object"){
					var tempObjData:ObjData=new ObjData();
					tempObjData.vertices=new Vector.<Number>
					tempObjData.normals=new Vector.<Number>
					tempObjData.uvs=new Vector.<Number>
					tempObjData.indexs=new Vector.<uint>
					objsItem.push(tempObjData)
				}
			}
			switch(firstWord)
			{
				case VERTEX:
				{
					parseVertex(words)
					break;
				}
				case NORMAL:
				{
					parseNormal(words)
					break;
				}
				case UV:
				{
					parseUv(words)
					break;
				}
				case INDEX_DATA:
				{
					parseIndex(words);
					break;
				}
				case USEMTL:
				{
					
					break;
				}
					
				default:
				{
					break;
				}
			}

		}
	}
}