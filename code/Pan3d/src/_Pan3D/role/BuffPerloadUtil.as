package _Pan3D.role
{
	import _Pan3D.display3D.Display3dGameMovie;
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	import _Pan3D.particle.ctrl.CombineParticle;
	import _Pan3D.particle.ctrl.ParticleManager;
	
	import _me.Scene_data;
	
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;

	public class BuffPerloadUtil
	{
		private var _data:Object;
		private var _buffRoot:String;
		private var _apd:AvatarParamData;
		private var _priority:int;
		
		public function BuffPerloadUtil()
		{
			_buffRoot = Scene_data.particleRoot; 		//"../res/data/res3d/particle/";
		}
		
		public function addBuff($apd:AvatarParamData,$priority:int):void{
			_apd = $apd;
			_priority = $priority;
			
			if(BuffUtil.isDebug){
				var loaderinfo : LoadInfo = new LoadInfo($apd.source, LoadInfo.BYTE, onInfoCom,_priority);
				LoadManager.getInstance().addSingleLoad(loaderinfo);	
			}else{
				var newKey:String = $apd.source;
				newKey = newKey.replace(/^.*?bid(\d*?)(\~\~\d+){0,1}\.lyfb(\?.*)*$/,"$1");
				newKey = "bid" + newKey +　".lyfb";
				BuffManager.getInstance().loadBuff(newKey,onInfoNewCom);
			}

			
		}
		
		private function onInfoCom(byte:ByteArray):void{
			
			
			_data = byte.readObject();
			
			var particle:CombineParticle = ParticleManager.getInstance().loadParticle(_buffRoot + "lid" + _data.id +".lyf",new Object);
			
			setTimeout(function():void{
				particle.dispose();
			},120000);
		
		}
		
		private function onInfoNewCom(obj:Object):void{
			_data = obj;
			
			var particle:CombineParticle = ParticleManager.getInstance().loadParticle(_buffRoot + "lid" + _data.id +".lyf",new Object);
			
			setTimeout(function():void{
				particle.dispose();
			},120000);

		}
		
		private function objToV3d(value:Object):Vector3D{
			return new Vector3D(value.x,value.y,value.z);
		}
		
		
		
		
	}
}