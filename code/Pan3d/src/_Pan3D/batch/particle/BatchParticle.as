package _Pan3D.batch.particle
{
	import _Pan3D.display3D.interfaces.IDisplay3D;
	import _Pan3D.particle.Display3DParticle;
	import _Pan3D.particle.ParticleData;
	
	import _me.Scene_data;
	
	import flash.display3D.Context3D;
	import flash.display3D.Program3D;

	public class BatchParticle
	{
		protected var particleData:ParticleData;
		protected var _context3D:Context3D;
		protected var _program:Program3D;
		protected var _idleNum:int;
		
		public function BatchParticle()
		{
			_context3D = Scene_data.context3D;
			particleData = new ParticleData;
		}
		
		public function update():void{
			_context3D.setProgram(this._program);
			setVc();
			setVa();
			resetVa();
		}
		
		protected function setVa() : void {
			
		}
		
		protected function setVc() : void {
			
			
		}
		
		protected function resetVa():void{
			
		}
		
		public function add(particle:Display3DParticle):void{
			
		}
		/**
		 * 移除粒子 
		 * @param particle
		 * @return -1 表示不再此队列 1表示在此队列且移除后队列不为空 0表示在队列移除后为空
		 * 
		 */		
		public function remove(particle:Display3DParticle):int{
			return -1;
		}
		
		public function hasIdle():Boolean{
			return _idleNum>0;
		}
		
		
	}
	
}