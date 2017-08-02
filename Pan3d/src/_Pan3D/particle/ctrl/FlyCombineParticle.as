package _Pan3D.particle.ctrl
{
	import _Pan3D.display3D.Display3D;
	import _Pan3D.display3D.Display3DContainer;
	import _Pan3D.display3D.Display3DSprite;
	import _Pan3D.display3D.interfaces.IBind;
	
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	public class FlyCombineParticle extends CombineParticle
	{
		public var fly:Flyer;
		public function FlyCombineParticle(container:Display3DContainer)
		{
			super(container);
			fly = new Flyer;
			fly.addEventListener(FlyerEvent.FLYREACH,onCom);
		}
		
		protected function onCom(event:Event):void{
			this.dispatchEvent(event);
		}
		public function setFlyConfig(obj:Object):void{
			fly.setData(obj);
			this.bindTarget = fly;
		}
		public function setFly($fly:Flyer):void{
			fly = $fly;
			fly.addEventListener(FlyerEvent.FLYREACH,onCom);
			this.bindTarget = fly;
		}
		public function bindFLyTarget(beginDisplay3D:Display3D,endDisplay3D:Display3D):void{
			fly.bindFLyTarget(beginDisplay3D,endDisplay3D);
		}
		override public function update(t:int):void{
			super.update(t);
			fly.updata(currentTime);
		}
		override public function reset(time:Number=0):void{
			super.reset(time);
			fly.reset();
		}
		override public function clone(container:Display3DContainer=null):CombineParticle{
			var combineParticle:FlyCombineParticle;
			
			if(container){
				combineParticle = new FlyCombineParticle(container);
			}else{
				combineParticle = new FlyCombineParticle(this._container);
			}
			
			if(_hasData){
				combineParticle.cloneData(this);
			}else{
				if(!this._cloneList){
					_cloneList = new Vector.<CombineParticle>;
				}
				_cloneList.push(combineParticle);
			}
			combineParticle.setFly(fly.clone());
			return combineParticle;
		}
	}
}