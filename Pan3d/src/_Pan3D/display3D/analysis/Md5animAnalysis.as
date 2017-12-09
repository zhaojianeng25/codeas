package _Pan3D.display3D.analysis {
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import _Pan3D.base.ObjectBone;
	import _Pan3D.base.ObjectBound;
	import _Pan3D.core.MathClass;

	/**
	 * @author liuyanfei  QQ: 421537900
	 */
	public class Md5animAnalysis{

		public var allFrames:Array;
		public var framesok:Boolean;
		
		private var _dir:Dictionary;
		private var _hierarchyitem:Vector.<ObjectBone>;
		private var _hierarchy:Array;
		private var _baseframe:Array;
		private var _bounds:Array;
		private var _frame:Array;

		public var bigArr:Array;
		
		public var resultInfo:Object;
		
		private var loopKey:String = "inLoop";
		private var boundsKey:String = "mybounds";
		private var nameHeightKey:String = "nameheight";
		private var interKey:String = "inter";
		private var pos:String = "pos";
		/**
		 * 包围盒最终数据 
		 */		
		private var _boundFrameAry:Vector.<Vector3D>;
		
		private var _posFrameAry:Vector.<Vector3D>;
		
		private var _interAry:Array;
		
		public function Md5animAnalysis() {

			
		}

		public function addAnim(ini:String):void {
			

				
			ini=ini.replace("origin","Bip001234") //特殊转换
			ini=ini.replace("Root","Bip002234") //特殊转换
			
			_dir = new Dictionary();
			allFrames = new Array();
			framesok = false;
			_hierarchyitem = new Vector.<ObjectBone>;
			_hierarchy = new Array();
			_baseframe = new Array();
			_bounds = new Array();
			_frame = new Array();
			
			//var ini:String = urlloader.data;

			var arr:Array = ini.split("\r\n");

			var len:int = arr.length;

			bigArr = new Array();

			var tempStr:String = "";

			var isbig:Boolean = false;
			
			//var t:int = getTimer();
			for (var i:int ; i < len ; i++) {

				var dindex:int = String(arr[i]).indexOf("//");

				if (dindex == 0) {
					//注释行
					continue;
				}

				if (dindex != -1) {
					//包含注释
					arr[i] = String(arr[i]).substring(0 , dindex);

						//删除注释
				}

				if (String(arr[i]).indexOf("{") != -1) {

					isbig = true;
				}

				if (isbig) {

					tempStr += arr[i] + "\n\r";

					if (String(arr[i]).indexOf("}") != -1) {

						isbig = false;

						bigArr.push(tempStr);

						tempStr = "";
					}

				} else {

					if (arr[i] != "") {

						var arr2:Array = String(arr[i]).split(" ");

						_dir[arr2[0]] = arr2[1];

							//正常行
					} else {
						//空行
					}

				}
			}

			//trace("anim字符串解析耗时：" + (getTimer() - t))
			//t = getTimer();
//			trace(3)
			for (var p:int =  0 ; p < bigArr.length ; p++) {
				handleBigWord(bigArr[p]);
			}
			//trace("anim字符串二次解析耗时：" + (getTimer() - t))
			//t = getTimer();
			_pushhierarchyitem();
			processBounds();
			processInter();
			processPos();
			setRestult();
			//trace("anim四元数迭代：" + (getTimer() - t))
		}
		
		private function setRestult():void{
			resultInfo = new Object;
			resultInfo.frames = allFrames;
			//resultInfo.bounds = _boundFrameAry;
			if(_dir[loopKey]){
				resultInfo.inLoop = _dir[loopKey];
			}
			if(_dir[boundsKey]){
				resultInfo.bounds = _boundFrameAry;
			}
			if(_dir[nameHeightKey]){
				resultInfo.nameHeight = _dir[nameHeightKey];
			}
			if(_dir[interKey]){
				resultInfo.inter = _interAry;
			}
			if(_dir[pos]){
				resultInfo.pos = _posFrameAry;
			}
		}
		private function processInter():void{
			var interStr:String = _dir[interKey];
			if(!interStr){
				return;
			}
			_interAry = interStr.split(",");
			_interAry.pop();
		}
		/**
		 * 处理包围盒信息 
		 * 
		 */		
		private function processBounds():void{
			_boundFrameAry = new Vector.<Vector3D>;
			var boundsStr:String = _dir[boundsKey];
			if(!boundsStr){
				return;
			}
			var boundNumAry:Array = boundsStr.split(",");
			boundNumAry.pop();
			
			for(var i:int;i<boundNumAry.length;i+=3){
				_boundFrameAry.push(new Vector3D(boundNumAry[i],boundNumAry[i+1],boundNumAry[i+2]));
			}
			
		}
		/**
		 * 处理位移信息 
		 * 
		 */		
		private function processPos():void{
			_posFrameAry = new Vector.<Vector3D>;
			var boundsStr:String = _dir[pos];
			if(!boundsStr){
				return;
			}
			var boundNumAry:Array = boundsStr.split(",");
			boundNumAry.pop();
			
			for(var i:int;i<boundNumAry.length;i+=3){
				_posFrameAry.push(new Vector3D(boundNumAry[i],boundNumAry[i+1],boundNumAry[i+2]));
			}
		}
		
		private function _pushhierarchyitem():void{
		
			var t:int = getTimer();
				
			var _str:String="";
			var _arr:Array=new Array();
			var i:Number=0;

			for( i=0;i<_hierarchy.length;i++){
				//_str=_genewStr(_hierarchy[i]);
				var tempary:Array = getBoneFilterStr(_hierarchy[i]);
				_arr=tempary[1].split(" ");
				//_arr=_str.split(" ");
				var _temp:ObjectBone=new ObjectBone();
				_temp.father = _arr[0];
                _temp.changtype=_arr[1];
				_temp.startIndex = _arr[2];
				_temp.name = tempary[0];
				_hierarchyitem.push(_temp);
					
			}
			trace("anim 基础骨骼解析耗时：" + (getTimer() - t))
			//t = getTimer();
			_pushbasefamer();
		}
		public function _pushfamers():void{


			var i:Number=0;
			for( i=0;i<_frame.length;i++){
				if(_frame[i]){
					allFrames.push(_getsamplefamer(_frame[i]));
				}
				//trace(_allframes)
			}
			framesok=true;
		}
	    private function _pushbasefamer():void{
			
			var _str:String="";

			var i:Number=0;
			for( i=0;i<_baseframe.length;i++){
				//_str=_genewStr(_baseframe[i]);
				//_arr=_str.split(" ");
				var _arr:Array=MathClass.getArrByStr(_baseframe[i])
				_hierarchyitem[i].tx=_arr[1];
				_hierarchyitem[i].ty=_arr[2];
				_hierarchyitem[i].tz=_arr[3];
				_hierarchyitem[i].qx=_arr[6];
				_hierarchyitem[i].qy=_arr[7];
				_hierarchyitem[i].qz=_arr[8];
			}
			_pushfamers();
			
		}
		
		public function _getsamplefamer(_framesample:Array):Array{
		
			var i:Number=0;
			var _arr:Array=new Array;

			var _arrframesample:Array;
			
			var tt:int = getTimer();
			_arrframesample = new Array;
			for(var js:int=0;js<_framesample.length;js++){
			//	_strframesample=_genewStr(_framesample[js]);
			//	var aar:Array = _strframesample.split(" ");
				var aar:Array=MathClass.getArrByStr(_framesample[js])
				if(aar.length && aar[aar.length-1] == ""){
					aar.pop();
				}
				_arrframesample = _arrframesample.concat(aar);
			}
			
			var t:int = getTimer();
			for( i=0;i<_hierarchyitem.length;i++){
				var _temp:ObjectBone=new ObjectBone();
				_temp.father = _hierarchyitem[i].father;
				_temp.name = _hierarchyitem[i].name;
				_temp.tx=_hierarchyitem[i].tx;
				_temp.ty=_hierarchyitem[i].ty;
				_temp.tz=_hierarchyitem[i].tz;
				_temp.qx=_hierarchyitem[i].qx;
				_temp.qy=_hierarchyitem[i].qy;
				_temp.qz=_hierarchyitem[i].qz;
				
				
//				trace(_hierarchyitem[i].startIndex)
//				trace("--------------")
				
				
			
					//trace("帧数耗时：" + (getTimer()-tt));
					var k:int = 0;
					if (_hierarchyitem[i].changtype & 1){
						_temp.tx = _arrframesample[_hierarchyitem[i].startIndex + k];
						k++;
					}
					if (_hierarchyitem[i].changtype & 2){
						_temp.ty = _arrframesample[_hierarchyitem[i].startIndex + k];
						k++;
					}
					if (_hierarchyitem[i].changtype & 4){
						_temp.tz = _arrframesample[_hierarchyitem[i].startIndex + k];
						k++;
					}
					if (_hierarchyitem[i].changtype & 8){
						_temp.qx = _arrframesample[_hierarchyitem[i].startIndex + k];
						k++;
					}
					if (_hierarchyitem[i].changtype & 16){
						_temp.qy = _arrframesample[_hierarchyitem[i].startIndex + k];
						k++;
					}
					if (_hierarchyitem[i].changtype & 32){
						_temp.qz = _arrframesample[_hierarchyitem[i].startIndex + k];
						k++;
					}
			
					
					_arr.push(_temp);
			}
			//for(var k:* in _arr){
//				_str=_str+"\n"+String(_arr[k].qz)+" "
			//}
			//trace("帧数解析耗时：" + (getTimer()-t))
			return _arr;
		}
		private function getBoneFilterStr(_str:String):Array
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
			var index:int = _s.indexOf("\"",1);
			var name:String = _s.slice(1,index);
		//	var num:String = _s.slice(index+2,-1);
			var num:String = _s.substring(index+2,_s.length);
			return [name,num];
		}
		
		
		private function handleBigWord(str:String):void {

			var reg:RegExp = /\d+/;
			var arr:Array;

//			if (str.indexOf("inLoop") != -1) {
//				
//				arr = str.split("\n\r");
//				
//				for (var i:int = 0 ; i < arr.length ; i++) {
//					
//					if (String(arr[i]).indexOf("{") == -1 && String(arr[i]).indexOf("}") == -1 && arr[i] != "") {
//						
//						_hierarchy.push(arr[i]);
//					}
//				}
//			}
			
			if (str.indexOf("hierarchy") != -1) {

				arr = str.split("\n\r");

				for (var i:int = 0 ; i < arr.length ; i++) {

					if (String(arr[i]).indexOf("{") == -1 && String(arr[i]).indexOf("}") == -1 && arr[i] != "") {

						_hierarchy.push(arr[i]);
					}
				}
			}


			if (str.indexOf("bounds") != -1) {

				arr = str.split("\n\r");

				for (var m:int = 0 ; m < arr.length ; m++) {

					if (String(arr[m]).indexOf("{") == -1 && String(arr[m]).indexOf("}") == -1 && String(arr[m]) != "") {

						_bounds.push(arr[m]);
					}
				}
			}

			if (str.indexOf("baseframe") != -1) {
				arr = str.split("\n\r");
				for (var k:int = 0 ; k < arr.length ; k++) {

					if (String(arr[k]).indexOf("{") == -1 && String(arr[k]).indexOf("}") == -1 && arr[k] != "") {

						_baseframe.push(arr[k]);
					}
				}
			}

			if (str.indexOf("frame") != -1 && str.indexOf("baseframe") == -1 && str.indexOf("BoneScale") == -1) {
				arr = str.split("\n\r")
				var arrsign:int;
				var tempArray:Array = new Array();
				for (var w:int = 0 ; w < arr.length ; w++) {
						if (String(arr[w]).indexOf("frame") != -1) {
							arrsign = String(arr[w]).match(reg)[0];
						}
						if (String(arr[w]).indexOf("{") == -1 && String(arr[w]).indexOf("}") == -1 && arr[w] != "") {
							tempArray.push(arr[w]);
						}
						
						_frame[arrsign] = tempArray;  
			
		
				}
			}
		}
		
		public function get hierarchy():Vector.<ObjectBone>{
			return _hierarchyitem;
		}
		
	}
}