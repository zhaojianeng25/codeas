package _Pan3D.particle.ctrl.utils
{
	public class ScaleAnim extends BaseAnim
	{
		public var scaleAry:Array;
		public var beginScale:Number;
		public var scaleNum:int;
		private var _currentTarget:Object;
		private var flag:int;
		
		private var numAry:Array;
		
		public function ScaleAnim()
		{
			super();
			num = 1;
		}
		override public function update(t:int):void{
			if(_isDeath){
				return;
			}
			time = t - baseTime;
			if(_isActiva){
				coreCalculate();
				if(time > lastTime){
					_isDeath = true;
				}
			}else{
				if(time >= beginTime){
					//time = time-beginTime;
					_isActiva = true;
				}
			}
			
		}
		
		override public function coreCalculate():void{
			var frameNum:int = time/(1000/60);
			if(frameNum >= numAry.length){
				num = numAry[numAry.length-1];
			}else{
				num = numAry[frameNum];
			}
			return;
			if(time>_currentTarget.beginTime){//切换阶段
				beginTime = _currentTarget.beginTime;
				beginScale = _currentTarget.value;
				flag++;
				if(flag == scaleAry.length){
					_isDeath = true;
					return;
				}
				_currentTarget = scaleAry[flag];
			}
			num = (_currentTarget.value-beginScale)/_currentTarget.time*(time-beginTime) + beginScale;
		}
		
		override public function reset():void{
			super.reset();
			num = 1;
			flag = 0;
		}
		override public function set data(value:Array):void{
			
			numAry = new Array;
			
			this.beginTime = value[0].value;
			if(value[1].value == -1){
				this.lastTime = int.MAX_VALUE;
			}else{
				this.lastTime = value[1].value;
			}
			beginScale = value[2].value;
			scaleNum = value[3].value;
			
			scaleAry = new Array;
			var addTime:int=0;
			for(var i:int=4;i<4+scaleNum*2;i+=2){
				var obj:Object = new Object;
				obj.value = Number(value[i].value);
				obj.time = int(value[i+1].value);
				addTime += obj.time;
				obj.beginTime = this.beginTime + addTime;
				scaleAry.push(obj);
			}
			
			var frameNum:int;
			
			var btime:Number = 0;
			var aTime:Number = 1;
			if(scaleAry.length){
				frameNum = (scaleAry[scaleAry.length-1].beginTime + scaleAry[scaleAry.length-1].time)/(1000/60);
				aTime = scaleAry[0].beginTime;
				_currentTarget = scaleAry[0];
			}else{
				frameNum = 0;
			}
			
			var flag:int = 0;
			for(i=0;i<frameNum;i++){
				var ctime:Number = 1000 / 60 * i;
				if(ctime >= _currentTarget.beginTime){
					beginScale = _currentTarget.value;
					btime = _currentTarget.beginTime;
					if(flag == scaleAry.length-1){
						_currentTarget = scaleAry[scaleAry.length-1];
					}else{
						flag++;
						_currentTarget = scaleAry[flag];
					}
					aTime = _currentTarget.time;
				}
				var cNum:Number = (ctime - btime)/aTime * (_currentTarget.value - beginScale) + beginScale;
				
				numAry.push(cNum);
			}
			
			_currentTarget = scaleAry[0];
			
			
		}
		
		override public function getAllNum(allTime:Number):void{
			allTime = Math.min(allTime,lastTime+beginTime);
			
			var target:Object = scaleAry[scaleAry.length-1];
			if(allTime >= (target.beginTime+target.time)){
				baseNum = target.value;
				return;
			}
			
			var flag:int;
			for(var i:int;i<scaleAry.length;i++){
				if(allTime > scaleAry[i].beginTime){
					_currentTarget = scaleAry[i];
					beginTime = _currentTarget.beginTime;
					beginScale = _currentTarget.value;
					flag = i;
				}
			}
			
			flag++;
			_currentTarget = scaleAry[flag];
			
			baseNum = (_currentTarget.value-beginScale)/_currentTarget.time*(allTime-beginTime) + beginScale;
			
		}
		
	}
}