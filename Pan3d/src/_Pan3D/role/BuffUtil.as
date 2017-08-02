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

	public class BuffUtil
	{
		private var _data:Object;
		private var _buffRoot:String;
		private var _bindTarget:Display3dGameMovie;
		private var _apd:AvatarParamData;
		private var _obj:Object;
		private var _isCancle:Boolean;
		private var _priority:int;
		/**
		 * 是否为调试模式（调试模式单独加载资源） 
		 */		
		public static var isDebug:Boolean;
		
		public function BuffUtil()
		{
			_buffRoot = Scene_data.particleRoot; 		//"../res/data/res3d/particle/";
		}
		
		public function addBuff($apd:AvatarParamData,obj:Object,bindTarget:Display3dGameMovie,$priority:int):void{
			_apd = $apd;
			_obj = obj;
			_obj.apd = $apd;
			_bindTarget = bindTarget;
			_priority = $priority;
			obj.buffUtil = this;
			
			if(isDebug){
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
			
			if(_isCancle){
				return;
			}
			
			_data = byte.readObject();
			
			_obj.bindIndex = _data.bindIndex;
			
			if(_data.bindOffset){
				_obj.bindOffset = objToV3d(_data.bindOffset);
			}
			
			if(_data.bindRatation){
				_obj.bindRatation = objToV3d(_data.bindRatation);
			}
			
			var particle:CombineParticle = ParticleManager.getInstance().loadParticle(_buffRoot + "lid" + _data.id +".lyf",_obj,_priority,_bindTarget.isInUI,_bindTarget.uiParticleContaniner);
			particle.bindTarget = _bindTarget;
			
			if(_data.nonrotation){
				particle.bindNonRotation = true;
			}
			
			if(!_bindTarget.hasDispose && getShow() && !_isCancle && _bindTarget.parent){
				if(_apd.repeatType){//如果添加buff的重复类型为1 则需要播放玩成后移除
					particle.addEventListener(Event.COMPLETE,onPlayCom);
				}
				ParticleManager.getInstance().addParticle(particle);
			}
			
			if(_bindTarget.hasDispose){
				particle.dispose();
			}
			
			//buff 的显示和角色保持一致
			particle.visible = _bindTarget.visible;
			
			particle.setPos(_bindTarget.absoluteX,_bindTarget.absoluteY,_bindTarget.absoluteZ);
			
			if(_bindTarget.isInUI){
				particle.scale = _bindTarget.scale/(Scene_data.mainScale/2);
			}
			
		}
		
		private function getShow():Boolean{
			if(_apd.id == null){
				return true;
			}else if(!_bindTarget.buffDic){
				return false;
			}else if(_bindTarget.buffDic[_apd.id]){
				return true;
			}
			return false;
		}
		
		private function onInfoNewCom(obj:Object):void{
			
			if(_isCancle){
				return;
			}
			
			_data = obj;
			
			_obj.bindIndex = _data.bindIndex;
			
			if(_data.bindOffset){
				_obj.bindOffset = objToV3d(_data.bindOffset);
			}
			
			if(_data.bindRatation){
				_obj.bindRatation = objToV3d(_data.bindRatation);
			}
			
			var particle:CombineParticle = ParticleManager.getInstance().loadParticle(_buffRoot + "lid" + _data.id +".lyf",_obj,_priority,_bindTarget.isInUI,_bindTarget.uiParticleContaniner);
			particle.bindTarget = _bindTarget;
			
			if(_data.nonrotation){
				particle.bindNonRotation = true;
			}
			
			if(!_bindTarget.hasDispose && getShow() && !_isCancle && _bindTarget.parent){
				if(_apd.repeatType){//如果添加buff的重复类型为1 则需要播放玩成后移除
					particle.addEventListener(Event.COMPLETE,onPlayCom);
				}
				ParticleManager.getInstance().addParticle(particle);
			}
			
			if(_bindTarget.hasDispose){
				particle.dispose();
			}
			//buff 的显示和角色保持一致
			particle.visible = _bindTarget.visible;
			particle.is3D = true;
			setInitPos(_obj.bindOffset,_obj.bindIndex,particle);
			
			if(_bindTarget.isInUI){
				particle.scale = _bindTarget.scale/(Scene_data.mainScale/2);
			}
			
		}
		
		private function setInitPos($bindOffset:Vector3D,$bindIndex:int,$particle:CombineParticle):void{
			var bindVecter3d:Vector3D = new Vector3D;
			if($bindOffset){
				bindVecter3d = _bindTarget.getOffsetPos($bindOffset,$bindIndex);
			}else{
				_bindTarget.getPosV3d($bindIndex,bindVecter3d);
			}
			$particle.setPos(bindVecter3d.x,bindVecter3d.y,bindVecter3d.z);
		}
		
		private function objToV3d(value:Object):Vector3D{
			return new Vector3D(value.x,value.y,value.z);
		}
		
		public function cancle():void{
			_isCancle = true;
			//dispose();
		}
		
		private function onPlayCom(event:Event):void{
			ParticleManager.getInstance().removeParticle(event.target as CombineParticle);
			if(Boolean(_apd)){
				_bindTarget.removeAvatarPart(_apd.id);
				
				if(Boolean(_apd.playCompleteFun)){
					var fun:Function = _apd.playCompleteFun;
					fun();
				}
				
			}
			
		}
		
		public function dispose():void{
			_data = null;
			_buffRoot = null;
			_bindTarget = null;
			_apd = null;
			_obj = null;
		}
		
		
		
	}
}