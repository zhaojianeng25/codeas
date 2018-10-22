package renderLevel.levels
{
	import flash.display3D.Program3D;
	import flash.events.Event;
	
	import _Pan3D.display3D.Display3DContainer;
	import _Pan3D.particle.Display3DFacetPartilce;
	import _Pan3D.particle.Display3DParticle;
	import _Pan3D.particle.Display3DPartilceShader;
	import _Pan3D.particle.ball.Display3DBallNewShader;
	import _Pan3D.particle.ball.Display3DBallPartilceNew;
	import _Pan3D.particle.bone.Display3DBoneNewShader;
	import _Pan3D.particle.bone.Display3DBoneParticleNew;
	import _Pan3D.particle.bone.Display3DBonePartilce;
	import _Pan3D.particle.bone.Display3DBoneShader;
	import _Pan3D.particle.crossFacet.Display3DCrossFacetPartilce;
	import _Pan3D.particle.crossFacet.Display3DCrossFacetShader;
	import _Pan3D.particle.cylinder.Display3DCylinderPartilce;
	import _Pan3D.particle.cylinder.Display3DCylinderShader;
	import _Pan3D.particle.follow.Display3DFollowPartilce;
	import _Pan3D.particle.follow.Display3DFollowShader;
	import _Pan3D.particle.followLocus.Display3DFollowLocusPartilce;
	import _Pan3D.particle.followLocus.Display3DFollowLocusShader;
	import _Pan3D.particle.hightLocus.Display3DHightLocusPartilce;
	import _Pan3D.particle.hightLocus.Display3DHightLocusShader;
	import _Pan3D.particle.link.Display3DLinkPartilce;
	import _Pan3D.particle.link.Display3DLinkShader;
	import _Pan3D.particle.locus.Display3DLocusPartilce;
	import _Pan3D.particle.locus.Display3DLocusShader;
	import _Pan3D.particle.locusball.Display3DLocusBallPartilce;
	import _Pan3D.particle.locusball.Display3DLocusBallShader;
	import _Pan3D.particle.mask.Display3DMaskPartilce;
	import _Pan3D.particle.mask.Display3DMaskShader;
	import _Pan3D.particle.modelObj.Display3DModelParticleNew;
	import _Pan3D.particle.modelObj.Display3DModelPartilce;
	import _Pan3D.particle.modelObj.Display3DModelShader;
	import _Pan3D.particle.modelObj.Display3dModelNewShader;
	import _Pan3D.particle.specialLocus.Display3DSpecialLocusPartilce;
	import _Pan3D.particle.specialLocus.Display3DSpecialLocusShader;
	import _Pan3D.program.Program3DManager;

	public class ParticleLevel
	{
		private var _particleContainer:Display3DContainer;
		private var _distortionContainer:Display3DContainer;
		private var _list:Vector.<Display3DParticle>;
		public function ParticleLevel()
		{
			_particleContainer = new Display3DContainer;
			_distortionContainer = new Display3DContainer;
			
			_list = new Vector.<Display3DParticle>;
		}
		public function addParticle(particle3d:Display3DParticle):void{
			if(particle3d.distortion){
				_distortionContainer.addChild(particle3d);
			}else{
				_particleContainer.addChild(particle3d);
			}
			
			_list.push(particle3d);
			
			var program:Program3D;
			if(particle3d is Display3DFollowPartilce){
				Program3DManager.getInstance().registe(Display3DFollowShader.DISPLAY3DFOLLOWSHADER,Display3DFollowShader);
				program = Program3DManager.getInstance().getProgram(Display3DFollowShader.DISPLAY3DFOLLOWSHADER);

		
			}else if(particle3d is Display3DFacetPartilce){
				Program3DManager.getInstance().registe(Display3DPartilceShader.DISPLAY3DPARTILCESHADER,Display3DPartilceShader);
				program = Program3DManager.getInstance().getProgram(Display3DPartilceShader.DISPLAY3DPARTILCESHADER);
		
	
			}else if(particle3d is Display3DCylinderPartilce){
				Program3DManager.getInstance().registe(Display3DCylinderShader.DISPLAY3DCYLINDERSHADER,Display3DCylinderShader);
				program = Program3DManager.getInstance().getProgram(Display3DCylinderShader.DISPLAY3DCYLINDERSHADER);
			}else if(particle3d is Display3DHightLocusPartilce){
				Program3DManager.getInstance().registe(Display3DHightLocusShader.DISPLAY3DHIGHTLOCUSSHADER,Display3DHightLocusShader);
				program = Program3DManager.getInstance().getProgram(Display3DHightLocusShader.DISPLAY3DHIGHTLOCUSSHADER);
			}else if(particle3d is Display3DSpecialLocusPartilce){
				Program3DManager.getInstance().registe(Display3DSpecialLocusShader.DISPLAY3DSPECIALLOCUSSHADER,Display3DSpecialLocusShader);
				program = Program3DManager.getInstance().getProgram(Display3DSpecialLocusShader.DISPLAY3DSPECIALLOCUSSHADER);
			}else if(particle3d is Display3DLocusPartilce){
				Program3DManager.getInstance().registe(Display3DLocusShader.DISPLAY3DLOCUSSHADER,Display3DLocusShader);
				program = Program3DManager.getInstance().getProgram(Display3DLocusShader.DISPLAY3DLOCUSSHADER);
			}else if(particle3d is Display3DCrossFacetPartilce){
				Program3DManager.getInstance().registe(Display3DCrossFacetShader.DISPLAY3DPARTILCESHADER,Display3DCrossFacetShader);
				program = Program3DManager.getInstance().getProgram(Display3DCrossFacetShader.DISPLAY3DPARTILCESHADER);
			}else if(particle3d is Display3DModelParticleNew){
				Program3DManager.getInstance().registe(Display3dModelNewShader.DISPLAY3DMODELNEWSHADER,Display3dModelNewShader);
				program = Program3DManager.getInstance().getProgram(Display3dModelNewShader.DISPLAY3DMODELNEWSHADER);
			}else if(particle3d is Display3DModelPartilce){
				Program3DManager.getInstance().registe(Display3DModelShader.DISPLAY3DMODELSHADER,Display3DModelShader);
				program = Program3DManager.getInstance().getProgram(Display3DModelShader.DISPLAY3DMODELSHADER);
			}else if(particle3d is Display3DLinkPartilce){
				Program3DManager.getInstance().registe(Display3DLinkShader.DISPLAY3DLINKSHADER,Display3DLinkShader);
				program = Program3DManager.getInstance().getProgram(Display3DLinkShader.DISPLAY3DLINKSHADER);
			}else if(particle3d is Display3DMaskPartilce){
				Program3DManager.getInstance().registe(Display3DMaskShader.DISPLAY3DMASKSHADER,Display3DMaskShader);
				program = Program3DManager.getInstance().getProgram(Display3DMaskShader.DISPLAY3DMASKSHADER);
			}else if(particle3d is Display3DFollowLocusPartilce){
				Program3DManager.getInstance().registe(Display3DFollowLocusShader.DISPLAY3DFOLLOWLOCUSSHADER,Display3DFollowLocusShader);
				program = Program3DManager.getInstance().getProgram(Display3DFollowLocusShader.DISPLAY3DFOLLOWLOCUSSHADER);
			}else if(particle3d is Display3DBoneParticleNew){
				Program3DManager.getInstance().registe(Display3DBoneNewShader.DISPLAY3D_BONENEW_SHADER,Display3DBoneNewShader);
				program = Program3DManager.getInstance().getProgram(Display3DBoneNewShader.DISPLAY3D_BONENEW_SHADER);
			}else if(particle3d is Display3DBonePartilce){
				Program3DManager.getInstance().registe(Display3DBoneShader.DISPLAY3D_BONE_SHADER,Display3DBoneShader);
				program = Program3DManager.getInstance().getProgram(Display3DBoneShader.DISPLAY3D_BONE_SHADER);
			}else if(particle3d is Display3DLocusBallPartilce){
				Program3DManager.getInstance().registe(Display3DLocusBallShader.DISPLAY3DLOCUSBALLSHADER,Display3DLocusBallShader);
				program = Program3DManager.getInstance().getProgram(Display3DLocusBallShader.DISPLAY3DLOCUSBALLSHADER);
			
			}else if(particle3d is Display3DBallPartilceNew){
				Program3DManager.getInstance().registe(Display3DBallNewShader.Display3DBallNewShader,Display3DBallNewShader);
				program = Program3DManager.getInstance().getProgram(Display3DBallNewShader.Display3DBallNewShader);
			}
			particle3d.setProgram3D(program);
			particle3d.addEventListener(Event.CHANNEL_STATE,onCHange);
		}
		
		protected function onCHange(event:Event):void
		{
			var display3d:Display3DParticle = event.target as Display3DParticle;
			
			if(display3d.distortion){
				if(display3d.parent != _distortionContainer){
					_particleContainer.removeChild(display3d);
					_distortionContainer.addChild(display3d);
				}
			}else{
				if(display3d.parent != _particleContainer){
					_distortionContainer.removeChild(display3d);
					_particleContainer.addChild(display3d);
				}
			}
		}
		
		public function removeParticle(particle3d:Display3DParticle):void{
			_particleContainer.removeChild(particle3d);
			if(particle3d.distortion){
				_distortionContainer.removeChild(particle3d);
			}
		}
		
		public function exchage(particle3d1:Display3DParticle,particle3d2:Display3DParticle):void{
			if(particle3d1.distortion || particle3d2.distortion){
				return;
			}
			_particleContainer.exchageChild(particle3d1,particle3d2);
		}
		
		public function upData():void
		{
			_particleContainer.update();
		}
		
		public function updateDistortion():void{
			_distortionContainer.update();
		}
		
		
	}
}