package renderLevel.levels
{
	import _Pan3D.display3D.Display3DContainer;
	import _Pan3D.particle.Display3DParticle;

	public class ParticleLevel
	{
		public var particleContainer:Display3DContainer;
		public function ParticleLevel()
		{
			particleContainer = new Display3DContainer;
		}
		
		public function removeParticle(particle3d:Display3DParticle):void{
			particleContainer.removeChild(particle3d);
		}
		public function exchage(particle3d1:Display3DParticle,particle3d2:Display3DParticle):void{
			particleContainer.exchageChild(particle3d1,particle3d2);
		}
		public function upData():void
		{
			particleContainer.update();
		}
		
	}
}