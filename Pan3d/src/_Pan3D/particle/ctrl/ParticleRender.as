package _Pan3D.particle.ctrl
{
	import _Pan3D.particle.Display3DParticle;

	public class ParticleRender
	{
		
		private var _showList:Vector.<Display3DParticle>;
		private var _distortionList:Vector.<Display3DParticle>;
		
		private static var _instance:ParticleRender;
		
		public static function getInstance():ParticleRender{
			if(!_instance){
				_instance = new ParticleRender;
			}
			return _instance;
		}
		
		public function ParticleRender()
		{
			_showList = new Vector.<Display3DParticle>;
			_distortionList = new Vector.<Display3DParticle>;
			
		}
		
		public function addParticle(particle:CombineParticle):void{
			var timeLineAry:Vector.<TimeLine> = particle.timeLineAry;
			for(var i:int;i<timeLineAry.length;i++){
				var display3d:Display3DParticle = timeLineAry[i].display3D;
				if(display3d.distortion){
					_distortionList.push(display3d);
				}else{
					_showList.push(display3d);
				}
			}
		}
		
		public function removeParticle(particle:CombineParticle):void{
			var timeLineAry:Vector.<TimeLine> = particle.timeLineAry;
			for(var i:int;i<timeLineAry.length;i++){
				var display3d:Display3DParticle = timeLineAry[i].display3D;
				var index:int;
				if(display3d.distortion){
					
					index = _distortionList.indexOf(display3d);
					if(index != -1){
						_distortionList.splice(index,1);
					}
					
				}else{
					
					index = _showList.indexOf(display3d);
					if(index != -1){
						_showList.splice(index,1);
					}
					
				}
				
			}
		}
		
		public function update():void{
			for(var i:int;i<_showList.length;i++){
				_showList[i].update();
			}
		}
		
		public function updateDistortion():void{
			for(var i:int;i<_distortionList.length;i++){
				_distortionList[i].update();
			}
		}
		
		
		
	}
}