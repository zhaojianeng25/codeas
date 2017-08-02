package curves
{
	import flash.geom.Vector3D;

	public class Curve
	{
		public var curveList:Vector.<CurveItem>;
		public var valueVec:Vector.<Vector.<Number>>;
		public var type:int;
		private var valueV3d:Vector3D;
		private var maxFrame:int;
		private var _speedType:Boolean
		private var _sideType:Boolean
		private var _useColorType:Boolean
		public function Curve()
		{
			curveList = new Vector.<CurveItem>;
			valueVec = new Vector.<Vector.<Number>>;
			for(var i:int;i<4;i++){
				valueVec.push(new Vector.<Number>);
			}
			
			valueV3d = new Vector3D(1,1,1,1);
		}
		
		public function get useColorType():Boolean
		{
			return _useColorType;
		}

		public function set useColorType(value:Boolean):void
		{
			_useColorType = value;
		}

		public function get sideType():Boolean
		{
			return _sideType;
		}

		public function set sideType(value:Boolean):void
		{
			_sideType = value;
		}

		public function get speedType():Boolean
		{
			return _speedType;
		}

		public function set speedType(value:Boolean):void
		{
			_speedType = value;
		}

		public function getValue($t:Number):Vector3D{
			if(!curveList.length){
				return valueV3d;
			}
			var flag:int = $t/(1000/60) - curveList[0].frame;
			if(flag < 0){
				flag = 0;
			}else if(flag > maxFrame - curveList[0].frame){
				flag = maxFrame - curveList[0].frame;
			}
			
			if(type == 1){
				valueV3d.x = valueVec[0][flag];
			}else if(type == 2){
				valueV3d.x = valueVec[0][flag];
				valueV3d.y = valueVec[1][flag];
			}else if(type == 3){
				valueV3d.x = valueVec[0][flag];
				valueV3d.y = valueVec[1][flag];
				valueV3d.z = valueVec[2][flag];
			}else if(type == 4){
				valueV3d.x = valueVec[0][flag];
				valueV3d.y = valueVec[1][flag];
				valueV3d.z = valueVec[2][flag];
				valueV3d.w = valueVec[3][flag];
				
				valueV3d.scaleBy(valueV3d.w);
				
			}
			return valueV3d;
		}
		
		public function resetData():void{
			for(var i:int=0;i<valueVec.length;i++){
				valueVec[i].length = 0;
			}
			
			maxFrame = 0;
			
			for(i = 0;i<curveList.length;i++){
				if(type == 1){
					valueVec[0] = valueVec[0].concat(curveList[i].valueVec0);
				}else if(type == 2){
					valueVec[0] = valueVec[0].concat(curveList[i].valueVec0);
					valueVec[1] = valueVec[1].concat(curveList[i].valueVec1);
				}else if(type == 3){
					valueVec[0] = valueVec[0].concat(curveList[i].valueVec0);
					valueVec[1] = valueVec[1].concat(curveList[i].valueVec1);
					valueVec[2] = valueVec[2].concat(curveList[i].valueVec2);
				}else if(type == 4){
					valueVec[0] = valueVec[0].concat(curveList[i].valueVec0);
					valueVec[1] = valueVec[1].concat(curveList[i].valueVec1);
					valueVec[2] = valueVec[2].concat(curveList[i].valueVec2);
					valueVec[3] = valueVec[3].concat(curveList[i].valueVec3);
				}
				maxFrame = Math.max(curveList[i].frame,maxFrame);
			}
			
			
			
		}
		
		public function getData():Object{
			var ary:Array = new Array;
			for(var i:int = 0;i<curveList.length;i++){
				ary.push(curveList[i].getData());
			}
			var valueAry:Array = new Array;
			for(i=0;i<valueVec.length;i++){
				var arr:Array = new Array;
				valueAry.push(arr);
				for(var j:int=0;j<valueVec[i].length;j++){
					arr.push(valueVec[i][j]);
				}
			}
			var obj:Object = new Object;
			obj.items = ary;
			obj.values = valueAry;
			obj.type = type;
			obj.maxFrame = maxFrame;
			obj.speedType = speedType;
			obj.sideType = sideType;
			obj.useColorType = useColorType;
			return obj;
		}
		
		public function setData(obj:Object):void{
			var ary:Array = obj.items;
			for(var i:int;i<ary.length;i++){
				var item:CurveItem = new CurveItem;
				item.setData(ary[i]);
				curveList.push(item);
			}
			var arr2:Array = obj.values;
			for(i=0;i<arr2.length;i++){
				for(var j:int=0;j<arr2[i].length;j++){
					valueVec[i][j] = arr2[i][j];
				}
			}
			this.type = obj.type;
			this.speedType = obj.speedType;
			this.sideType = obj.sideType;
			this.useColorType = obj.useColorType;
			this.maxFrame = obj.maxFrame;
		}
		
		
		
		
	}
}