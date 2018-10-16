package _Pan3D.display3D.lightProbe
{
	import flash.geom.Vector3D;
	

	public class LightProbeManager
	{
		private static var instance:LightProbeManager;
		
		private var _dataAry:Array;
		private var _defaultVec:Vector.<Vector3D>;
		public function LightProbeManager()
		{
			_defaultVec = new Vector.<Vector3D>;
			for(var i:int;i<9;i++){
				_defaultVec.push(new Vector3D());
			}
		}

		public function get dataAry():Array
		{
			return _dataAry;
		}

		public function set dataAry(value:Array):void
		{
			_dataAry = value;
		}

		public static function getInstance():LightProbeManager{
			if(!instance){
				instance = new LightProbeManager();
			}
			return instance;
		}
		
		public function setLightProbeData($arr:Array):void
		{
			_dataAry = $arr;
		}
		
		public function getData($pos:Vector3D):Vector.<Vector3D>{
			if(!_dataAry){
				return _defaultVec;
			}
			for(var i:int;i<_dataAry.length;i++){
				var lightArea:Object = _dataAry[i];
				if(testPoint(lightArea,$pos)){
					var baseV3d:Vector3D = lightArea.postion;
					var bp:Vector3D = $pos.subtract(baseV3d);
					return getResultData(lightArea.posItem,int(bp.x/lightArea.betweenNum),int(bp.z/lightArea.betweenNum),int(bp.y/lightArea.betweenNum),lightArea.betweenNum,bp);
				}
			}
			return _defaultVec;
		}
		
		public function testPoint(lightArea:Object,$pos:Vector3D):Boolean{
			var xNum:int = (lightArea.cubeVec.x-1) * lightArea.betweenNum;
			var yNum:int = (lightArea.cubeVec.y-1) * lightArea.betweenNum;
			var zNum:int = (lightArea.cubeVec.z-1) * lightArea.betweenNum;
			
			var cx:int = $pos.x - lightArea.postion.x;
			var cy:int = $pos.y - lightArea.postion.y;
			var cz:int = $pos.z - lightArea.postion.z;
			
			if(cx >=0 && cx < xNum && cy >=0 && cy < yNum && cz >=0 && cz < zNum ){
				return true;
			}else{
				return false;
			}
		}
		
		public function getResultData(ary:Array,x:int,z:int,y:int,bNum:Number,$pos:Vector3D):Vector.<Vector3D>{
			var posAry:Vector.<PosItem> = new Vector.<PosItem>;
			
			posAry.push(new PosItem(ary[x][z][y],$pos));
			posAry.push(new PosItem(ary[x+1][z][y],$pos));
			posAry.push(new PosItem(ary[x][z+1][y],$pos));
			posAry.push(new PosItem(ary[x+1][z+1][y],$pos));
			
			posAry.push(new PosItem(ary[x][z][y+1],$pos));
			posAry.push(new PosItem(ary[x+1][z][y+1],$pos));
			posAry.push(new PosItem(ary[x][z+1][y+1],$pos));
			posAry.push(new PosItem(ary[x+1][z+1][y+1],$pos));
			
			var allDis:Number = 0;
			for(var i:int;i<posAry.length;i++){
				allDis += posAry[i].dis;
			}
			
			for(i = 0;i<posAry.length;i++){
				posAry[i].setBais(allDis);
			}
			
			var allBais:Number = 0;
			for(i = 0;i<posAry.length;i++){
				allBais += posAry[i].bais;
			}
			
			for(i = 0;i<posAry.length;i++){
				posAry[i].bais = posAry[i].bais/allBais;
			}
			
			var arr:Vector.<Vector3D> = new Vector.<Vector3D>;
			for(i=0;i<9;i++){
				var v3d:Vector3D = new Vector3D;
				for(var j:int=0;j<posAry.length;j++){
					var tempV3d:Vector3D = posAry[j].vecNum[i].clone();
					tempV3d.scaleBy(posAry[j].bais);
					v3d = v3d.add(tempV3d);
				}
				arr.push(v3d);
			}
			return arr;
			
		}
		
	}
}
import flash.geom.Vector3D;

class PosItem{
	public var pos:Vector3D;
	public var bais:Number;
	public var dis:Number;
	public var vecNum:Vector.<Vector3D>;
	public function PosItem(basePos:Object,centerPos:Vector3D){
		pos = new Vector3D(basePos.x,basePos.y,basePos.z);
		
		vecNum = basePos.resultSHVec;
		
		dis = Vector3D.distance(pos,centerPos);
	}
	
	public function setBais(allDis:Number):void{
		bais = (dis/allDis)*(dis/allDis);
		bais = 1/bais;
	}
}