package _Pan3D.role
{
	import _Pan3D.core.MathClass;
	import _Pan3D.display3D.Display3DMovie;
	
	import _me.Scene_data;
	
	import flash.display3D.Context3D;
	import flash.display3D.Program3D;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	public class Role extends Display3DMovie
	{
		private var _info:RoleVo;
		private var _selected:Boolean;
		public var minDistance:Number = 1;
		public  var inRender:Boolean = true;
		//private var _currentProgram:Program3D;
		//private var _selectProgram:Program3D;
		
		public function Role(context:Context3D,info:RoleVo)
		{
			super(context);
			this._info = info;
			//setTimeout(init,10000);
			initRole();
		}
		private function initRole():void{
			//var t:int = getTimer();
			for(var key:String in _info.equipment){
				this.addMesh(key,_info.equipment[key]);
			}
			//trace("耗时：" + (getTimer()-t));
			//t = getTimer();
			for(key in _info.action){
				this.addAnim(_info.action[key].url,key);
			}
			//trace("耗时：" + (getTimer()-t));
		}
		
		public function walk():void{
			//if(_animDic.hasOwnProperty(RoleVo.WALK)){
				_curentAction = RoleVo.WALK;
				_curentFrame = 1;
			//}
		}
		public function run():void{
			//if(_animDic.hasOwnProperty(RoleVo.RUN)){
			if(_curentAction!=RoleVo.RUN){//如果上一帧同为跑，那保持上一次的动画帧数。 
				_curentAction = RoleVo.RUN;
				_curentFrame = 1;
			}
			//}
		}
		public function ride():void{
			if(_animDic.hasOwnProperty(RoleVo.RIDE)){
				_curentAction = RoleVo.RIDE;
				_curentFrame = 1;
			}
		}
		public function death():void{
			if(_animDic.hasOwnProperty(RoleVo.DEATH)){
				_curentAction = RoleVo.DEATH;
				_curentFrame = 1;
			}
		}
		override public function stop():void{
			if(_animDic.hasOwnProperty(RoleVo.STAND)){
				_curentAction = RoleVo.STAND;
				_curentFrame = 1;
			}
		}
		public function attack(mode:String):void{
			if(_animDic.hasOwnProperty(mode)){
				_curentAction = mode;
				_curentFrame = 1;
			}
		}
		override public function playOver():void{
			if(!_info.action[_curentAction].zyklus){
				stop();
			}
		}
		
		public function moveEnd():void{
			
		}
		
		private var willStop:Boolean;
		public var seepNum:Number=2; 
		private var targetAngle:Number;
		override public function update():void
		{
			//_context.setProgram(this.program);
			super.update();
			doLogic();
			//Scene_data.focus3D.x=this.x;
			//Scene_data.focus3D.z=this.z;
			//this.y = 0;
			//trace(this.x,this.z)
		}
		public function doLogic():void{
			var d:Number;
			var angly:Number;
			if (_nextPoint)
			{
				d=MathClass.math_distance(this.x, this.z, _nextPoint.x, _nextPoint.z)
				angly=MathClass.math_angle(_nextPoint.x, _nextPoint.z, this.x, this.z)
				targetAngle = 90 - angly;
				/*if(targetAngle < -180){
				targetAngle += 360;
				}*/
				var interpolation:Number = targetAngle - this.rotationY;
				
				if(interpolation > 180){
					//this.rotationY -= 360;
					this.rotationY = 360 - interpolation + targetAngle;
					
				}else if(interpolation < -180){
					this.rotationY =  - 360 - interpolation + targetAngle;
				}
				//trace(targetAngle)
				if (d > minDistance)
				{
					
					this.x=this.x + seepNum * Math.cos(angly * Math.PI / 180);
					this.z=this.z + seepNum * Math.sin(angly * Math.PI / 180);
					
					//this.rotationY = 90 - angly;
					this.rotationY += (targetAngle - this.rotationY)/5;
				}
				else
				{
					_nextPoint=null;
					if(willStop){
						stop();
						willStop = false;
						moveEnd();
					}
				}
			}
			else
			{
				if (_loadArr && _loadArr.length > 0)
				{
					var k:Vector3D=_loadArr.shift();
					_nextPoint=new Vector3D(k.x*5 , 0, k.z*5)
					if(_loadArr.length == 0){
						willStop = true;
					}
				}
			}
		}
		private var _loadArr:Vector.<Vector3D>;
		private var _nextPoint:Vector3D;
		
		public function pushLoadArr(arr:Vector.<Vector3D>,type:String="walk"):void
		{
			if(arr && arr.length){
				arr.shift();
			}
			_loadArr=arr;
			_nextPoint=null;
			willStop = false;
			if(type == RoleVo.WALK){
				if(_curentAction != type){
					walk();
				}
			}else if(type == RoleVo.RUN){
				if(_curentAction != type){
					run();
				}
			}
			
		}
		
		public function stopWalk():void{
			_loadArr = null;
			_nextPoint=null;
			
			stop();
		}
		
		public function set selected(value:Boolean):void{
			this._selected = value;
		}
		
		public function get selected():Boolean{
			return this._selected;
		}

		public function get info():RoleVo
		{
			return _info;
		}

		public function set info(value:RoleVo):void
		{
			_info = value;
		}
		
		
	}
}