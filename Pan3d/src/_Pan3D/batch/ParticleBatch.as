package _Pan3D.batch
{
	import _Pan3D.particle.Display3DParticle;
	import _Pan3D.particle.ctrl.CombineParticle;
	import _Pan3D.particle.ctrl.TimeLine;
	
	import _me.Scene_data;
	
	import flash.display3D.Context3D;

	/**
	 * 粒子批处理类 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class ParticleBatch
	{
		/**
		 * 贴图对应显卡资源 
		 */		
		private var _textureDic:Object;
		/**
		 * 按等级划分贴图渲染顺序
		 */		
		private var _textureList:Vector.<Vector.<String>>;
		/**
		 * 贴图的渲染等级 
		 */		
		private var _texturePriority:Object;
		
		private var _display3DList:Object;
		
		private static var _instance:ParticleBatch;
		
		private var _context3D:Context3D;
		
		private var list:Vector.<CombineParticle>;
		
		public function ParticleBatch()
		{
			_textureDic = new Object;
			_texturePriority = new Object;
			initTexturePriority();
			_display3DList = new Object;
			_context3D = Scene_data.context3D;
			
			list = new Vector.<CombineParticle>;
		}
		
		public static function getInstance():ParticleBatch{
			if(!_instance){
				_instance = new ParticleBatch;
			}
			return _instance;
		}
		
		private function initTexturePriority():void{
			_textureList = new Vector.<Vector.<String>>;
			for(var i:int;i<100;i++){
				_textureList.push(new Vector.<String>);
			}
		}
		
		public function addParticle(particle:CombineParticle):void{
			if(particle.isInUI){
				return;
			}
			//return;
			var timeLineAry:Vector.<TimeLine> = particle.timeLineAry;
			for(var i:int;i<timeLineAry.length;i++){
				var url:String = timeLineAry[i].display3D.textureUrl;
				if(!_textureDic[url]){
					_textureDic[url] = timeLineAry[i].display3D.particleData;
				}
				
				if(_texturePriority.hasOwnProperty(url)){
//					if(int(_texturePriority[url]) > i){
//						var priority:int = _texturePriority[url];
//						var index:int = _textureList[priority].indexOf(url);
//						if(index != -1){
//							_textureList[priority].splice(index,1);
//						}
//						
//						index = _textureList[i].indexOf(url);
//						if(index != -1){
//							_textureList[i].push(url);
//						}
//						_texturePriority[url] = i;
//					}
				}else{
					_textureList[i].push(url);
					_texturePriority[url] = i;
				}
				
				if(!_display3DList[url]){
					_display3DList[url] = new Vector.<Display3DParticle>;
				}
				var index:int = _display3DList[url].indexOf(timeLineAry[i].display3D);
				if(index == -1){
					_display3DList[url].push(timeLineAry[i].display3D);
				}
			}
			index = list.indexOf(particle);
			if(index == -1){
				list.push(particle);
			}
		}
		public function removeParticle(particle:CombineParticle):void{
			//return;
			var timeLineAry:Vector.<TimeLine> = particle.timeLineAry;
			for(var i:int;i<timeLineAry.length;i++){
				var url:String = timeLineAry[i].display3D.textureUrl;
				var vec:Vector.<Display3DParticle> = _display3DList[url];
				if(!vec){
					continue;
				}
				var index:int = vec.indexOf(timeLineAry[i].display3D);
				if(index != -1){
					vec.splice(index,1);
				}
				if(vec.length == 0){
					delete _display3DList[url];
					delete _textureDic[url];
					index = _texturePriority[url];
					var strVec:Vector.<String> = _textureList[index];
					index = strVec.indexOf(url);
					if(index != -1){
						strVec.splice(index,1);
					}
					delete _texturePriority[url];
				}
			}
			index = list.indexOf(particle);
			if(index != -1){
				list.splice(index,1);
			}
		}
		public function update():void{
			//return;
			//trace(_display3DList);
			for(var i:int;i<_textureList.length;i++){
				var strVec:Vector.<String> = _textureList[i];
				for(var j:int=0;j<strVec.length;j++){
					var url:String = strVec[j];
					updateTexture(url);
				}
			}
			_context3D.setTextureAt(1,null);
		}
		
		public function updateTexture(url:String):void{
			_context3D.setTextureAt(1,_textureDic[url].texture);
			updateDisplayList(_display3DList[url]);
		}
		
		public function updateDisplayList(vec:Vector.<Display3DParticle>):void{
			for(var i:int;i<vec.length;i++){
				vec[i].updateBatch();
			}
		}
		
		public function reload():void{
			_context3D = Scene_data.context3D;
		}
		
		
	}
}