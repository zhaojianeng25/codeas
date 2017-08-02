package _Pan3D.particle.ctrl.utils
{
	import _me.Scene_data;

	public class FrameTimeLineUtils
	{
		protected var _selfRotaion:SelfRotation;
		protected var _axisRotaion:AxisRotaion;
		protected var _centrifugal:Centrifugal;
		protected var _axisMove:AxisMove;
		protected var _colorChange:ColorChange;
		protected var _scaleChange:ScaleChange;
		protected var _scaleAnim:ScaleAnim;
		protected var _scaleNosie:ScaleNoise;
		
		private var _animAry:Array;
		private static var _instance:FrameTimeLineUtils;
		public function FrameTimeLineUtils()
		{
			_selfRotaion = new SelfRotation;
			_axisRotaion = new AxisRotaion;
			_centrifugal = new Centrifugal;
			_axisMove = new AxisMove;
			_colorChange = new ColorChange;
			_scaleChange = new ScaleChange;
			_scaleAnim = new ScaleAnim;
			_scaleNosie = new ScaleNoise;
			
			_animAry = [_selfRotaion,_axisRotaion,_centrifugal,_axisMove,_colorChange,null,_scaleChange,_scaleAnim,_scaleNosie];
		}
		public static function getInstance():FrameTimeLineUtils{
			if(!_instance){
				_instance = new FrameTimeLineUtils;
			}
			_instance.reset();
			return _instance;
		}
		public function process(arys:Array):Array{
			//trace(123)
			var valueAry:Array = initValueData(arys.length-1);;
			for(var i:int=1;i<arys.length-1;i++){
				var animData:Array = arys[i-1].animData;
				var currentValue:Array = valueAry[i];
				var baseTime:int = arys[i-1].frameNum * Scene_data.frameTime;
				var lastTime:Number = (arys[i].frameNum - arys[i-1].frameNum)*Scene_data.frameTime;
				if(animData){
					for(var j:int=0;j<animData.length;j++){
						animData[j].baseTime = baseTime;
						if(animData[j].type == 1){
							_selfRotaion.data = animData[j].data;
							_selfRotaion.getAllNum(lastTime);
							//currentValue[animData[j].type] = _selfRotaion.baseNum;
						}else if(animData[j].type == 2){
							_axisRotaion.data = animData[j].data;
							_axisRotaion.getAllNum(lastTime);
							//currentValue[animData[j].type] = _axisRotaion.baseNum;
						}else if(animData[j].type == 3){
							_centrifugal.data = animData[j].data;
							_centrifugal.getAllNum(lastTime);
							//currentValue[animData[j].type] = _centrifugal.baseNum;
						}else if(animData[j].type == 4){
							_colorChange.data = animData[j].data;
							_colorChange.getAllNum(lastTime);
							//currentValue[animData[j].type] = _colorChange.baseNum;
						}else if(animData[j].type == 6){
							_scaleChange.data = animData[j].data;
							_scaleChange.getAllNum(lastTime);
							//currentValue[animData[j].type] = _scaleChange.baseNum;
						}else if(animData[j].type == 7){
							_scaleAnim.data = animData[j].data;
							_scaleAnim.getAllNum(lastTime);
							//currentValue[animData[j].type] = _scaleAnim.baseNum;
						}else if(animData[j].type == 8){
							_scaleNosie.data = animData[j].data;
							_scaleNosie.getAllNum(lastTime);
							//currentValue[animData[j].type] = _scaleNosie.baseNum;
						}else if(animData[j].type == 9){
							_axisMove.data = animData[j].data;
							_axisMove.getAllNum(lastTime);
							//currentValue[animData[j].type] = _axisMove.baseNum;
						}
					}
					
				}
				currentValue[1] = _selfRotaion.baseNum;
				currentValue[2] = _axisRotaion.baseNum;
				currentValue[3] = _centrifugal.baseNum;
				currentValue[4] = _colorChange.baseNum;
				currentValue[6] = _scaleChange.baseNum;
				currentValue[7] = _scaleAnim.baseNum;
				currentValue[8] = _scaleNosie.baseNum;
				currentValue[9] = _axisMove.baseNum;
			}
			
			for(i = 0;i<arys.length-1;i++){
				arys[i].baseValue = valueAry[i];
			}
			
			return valueAry;
		}
		public function getObj(ary:Array,type:int):Object{
			for(var i:int;i<ary.length;i++){
				if(ary[i].type == type){
					return ary[i];
				}
			}
			throw new Error("fuck...");
			return null;
		}
		public function initValueData(num:int):Array{
			var valueAry:Array = new Array;
			for(var j:int;j<num;j++){
				var obj:Array = new Array(10);
				valueAry.push(obj);
			}
			return valueAry
		}
		public function reset():void{
			//trace(123)
			for(var i:int;i<_animAry.length;i++){
				if(_animAry[i]){
					_animAry[i].depthReset();
				}
			}
		}
		
		
		
	}
}