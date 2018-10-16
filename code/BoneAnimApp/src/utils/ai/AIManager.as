package utils.ai
{
	import flash.display3D.Context3D;
	import flash.display3D.Program3D;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	import _Pan3D.base.Object3D;
	import _Pan3D.core.Groundposition;
	import _Pan3D.display3D.Display3DContainer;
	import _Pan3D.display3D.Display3DMovie;
	import _Pan3D.display3D.Display3dGameMovie;
	import _Pan3D.display3D.MovieAction;
	import _Pan3D.program.Program3DManager;
	import _Pan3D.program.shaders.Md5Shader;
	import _Pan3D.role.AvatarParamData;
	
	import _me.Scene_data;
	
	import renderLevel.Display3DMovieLocal;
	
	import view.ridepos.RidePosUtils;

	/**
	 * Ai角色控制类 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class AIManager
	{
		private var _container:Display3DContainer;

		private var _context3D:Context3D;
		
		private var _targetRole:Display3DMovieLocal;
		
		private var _targetPos:Vector3D = new Vector3D;
		
		public var dic:Object = new Object;
		
		private static var instance:AIManager;

		private var _currentDirect:Vector3D = new Vector3D;
		
		private var _speed:Number = 5;
		
		private var _runState:Boolean;
		
		public function AIManager()
		{
			
		}
		
		public static function getInstance():AIManager{
			if(!instance){
				instance = new AIManager;
			}
			return instance;
		}
		/**
		 * 初始化系统 
		 * @param container
		 * 
		 */		
		public function init(container:Display3DContainer):void{
			_container = container;
			_context3D = Scene_data.context3D;
			Scene_data.stage.addEventListener(MouseEvent.CLICK,onStageClick);
			Scene_data.stage.addEventListener(MouseEvent.MOUSE_WHEEL,onSpeedChang);
		}
		
		protected function onSpeedChang(event:MouseEvent):void
		{
			if(event.ctrlKey){
				_speed += event.delta * 0.1;
			}
		}
		
		protected function onStageClick(event:MouseEvent):void
		{
			var obj:Object3D = Groundposition.getScene3DPoint();
			
			_targetPos.setTo(obj.x,obj.y,obj.z);
			
			if(_targetRole){
				_runState = true;
				_targetRole.play("walk");
			}

		}
		
		public function addRole($url:String):void{
			
			if(dic[$url]){
				_container.addChild(dic[$url]);
				return;
			}
			
			var file:File = new File(Scene_data.fileRoot + $url);
			if(!file.exists){
				return;
			}
			var fs:FileStream = new FileStream;
			fs.open(file,FileMode.READ);
			var roleData:Object = fs.readObject();
			fs.close();
			
			var meshAry:Array = new Array;
			
			for(var i:int;i<roleData.mesh.length;i++){
				var children:ArrayCollection = roleData.mesh[i].children;
				for(var j:int=0;j<children.length;j++){
					meshAry.push(children[j]);
				}
			}
			
			var obj:Object = new Object;
			obj.bone = roleData.bone;
			obj.mesh = meshAry;
			obj.socket = roleData.socket;
			
			var role:Display3DMovieLocal = new RidePosUtils(obj).getRide();
			role.name = file.name;
			role.fileScale = roleData.scale;
			obj.role = role; 
			
			_targetRole = role;
			
			dic[$url] = role;
			
			_container.addChild(role);
			
		}
		
		
		/**
		 * 清理所有Ai和角色 
		 * 
		 */		
		public function clear():void{
			_container.removeChild(_targetRole);
		}
		
		/**
		 * 逻辑刷帧 
		 * 
		 */		
		public function update():void{
			 
			if(_runState && _targetRole){
				_currentDirect.x = _targetPos.x - _targetRole.x;
				_currentDirect.y = _targetPos.y - _targetRole.y;
				_currentDirect.z = _targetPos.z - _targetRole.z;
				
				_currentDirect.normalize();
				_currentDirect.scaleBy(_speed);
				
				var currentDistance:Number = _currentDirect.length;
				
				var _rotationY:Number = - Math.atan2(_currentDirect.z,_currentDirect.x)/Math.PI * 180 + 90;
				
				_targetRole.rotationY = _rotationY;
				
				var _currentPos:Vector3D = new Vector3D(_targetRole.x,_targetRole.y,_targetRole.z)
				
				var targetDistance:Number = Vector3D.distance(_currentPos,_targetPos);
				
				if(currentDistance > targetDistance){
					_runState = false;
					_targetRole.x = _targetPos.x;
					_targetRole.y = _targetPos.y;
					_targetRole.z = _targetPos.z;
					_targetRole.play("stand");
				}else{
					_targetRole.x += _currentDirect.x;
					_targetRole.y += _currentDirect.y;
					_targetRole.z += _currentDirect.z;
				}
				
			}
			
			
		}
		
		public function getRole():Display3DMovieLocal{
			return _targetRole;
		}
		
		
		
	}
}