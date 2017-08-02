package materials
{
	import flash.events.IEventDispatcher;
	
	import interfaces.ITile;

	
	public class TextureParticleMesh extends Texture2DMesh implements ITile
	{
		
	
			
		public function TextureParticleMesh(target:IEventDispatcher=null)
		{
			super(target);
		}
		override public function get filePath():String
		{
			return "img/TextureParticle/";
		}
		
		
	}
}