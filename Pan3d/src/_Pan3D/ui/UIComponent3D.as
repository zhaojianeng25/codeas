package _Pan3D.ui
{
	import _Pan3D.display3D.Display3DContainer;
	import _Pan3D.display3D.Display3dGameMovie;
	import _Pan3D.particle.ctrl.CombineParticle;
	import _Pan3D.particle.ctrl.ParticleManager;
	import _Pan3D.program.Program3DManager;
	
	import _me.Scene_data;
	
	import flash.display.BitmapData;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Program3D;
	import flash.events.Event;
	import flash.events.KeyboardEvent;

	/**
	 * 3D中的UI组件（用于在2D界面中显示3D对象） 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class UIComponent3D extends Display3DContainer
	{
		protected var _bg:Display3DBoard;
		protected var _bgProgram3D:Program3D;
		private var _role:Display3dGameMovie;
		protected var _particleContainer:Display3DContainer;
		protected var _roleList:Vector.<Display3dGameMovie>;
		private var _alpha:Number = 1;
		
		private static var dicContainer:Object = new Object;
		
		public function UIComponent3D()
		{
			super();
			_roleList = new Vector.<Display3dGameMovie>;
		}
		/**
		 * 添加背景图片 
		 * @param bitmapdata 图片
		 * @param xpos x位置
		 * @param ypos y位置
		 * 
		 */		
		public function addBgImg(bitmapdata:BitmapData,xpos:int=0,ypos:int=0):void{
			if(!_bg){
				_bg = new Display3DBoard(Scene_data.context3D);
			}
			if(!_bgProgram3D){
				Program3DManager.getInstance().registe(Display3DBoardShader.DISPLAY3DBOARDSHADER,Display3DBoardShader);
				_bgProgram3D = Program3DManager.getInstance().getProgram(Display3DBoardShader.DISPLAY3DBOARDSHADER);
			}
			
			_bg.setProgram3D(_bgProgram3D);
			
			_bg.x = xpos;
			_bg.y = ypos;
			 
			_bg.setBitmapdata(bitmapdata);
			
			_bg.alpha = _alpha;
			
			this.addChild(_bg);
		}
		/**
		 * 添加角色 
		 * @param role 角色对象
		 * 
		 */		
		public function addGameMovie(role:Display3dGameMovie):void{
			//this.addChild(role);
			role.addRender(this);
			_role = role;
			_roleList.push(role);
			_role.alpha = _alpha;
		}
		/**
		 * 比例 
		 * @param value
		 * 
		 */		
		override public function set scale(value:Number):void{
			super.scale = value;
			
			if(scale == 0){
				scale == 0.00001; 
			}
			
			if(_hasDispose){
				return;
			}
			
			for(var i:int;i<_roleList.length;i++){
				if(_roleList[i] is Display3dGameMovie){
					Display3dGameMovie(_roleList[i]).updataPos();
					
					Display3dGameMovie(_roleList[i]).updateScale();
				}
			}
			
			if(_bg){
				_bg.updataPos();
			}
			
		}
		/**
		 * 透明度 
		 * @param value
		 * 
		 */		
		public function set alpha(value:Number):void{
			_alpha = value;
			for(var i:int;i<_roleList.length;i++){
				if(_roleList[i] is Display3dGameMovie){
					Display3dGameMovie(_roleList[i]).alpha = value;
				}
			}
			if(_bg){
				_bg.alpha = value;
			}
			
		}
		
		public function get alpha():Number{
			return _alpha
		}
		
		/**
		 * 移除角色 
		 * @param role
		 * 
		 */		
		public function removeGameMovie(role:Display3dGameMovie):void{
			var index:int = _roleList.indexOf(role);
			_roleList.splice(index,1);
			role.removeRender();
		}
		
		public function addEffect(combine:CombineParticle):void{
			
		}
		
		public function get particleContainer():Display3DContainer
		{
			return _particleContainer;
		}
		/**
		 * 设置粒子的显示容器
		 * @param value
		 * 
		 */		
		public function set particleContainer(value:Display3DContainer):void
		{
			_particleContainer = value;
		}
		/**
		 * 移除渲染（从3d显示列表中移除） 
		 * 
		 */		
		override public function removeRender():void{
			if(this.parent){
				this.parent.removeChild(this);
			}
			//将人物身上附带的粒子去除
			/*for(var i:int;i<_childrenList.length;i++){
				if(_childrenList[i] is Display3dGameMovie){
					//Display3dGameMovie(_childrenList[i]).removeExtra();
					Display3dGameMovie(_childrenList[i]).removeRender();
				}
			}*/
			
			for(var i:int;i<_roleList.length;i++){
				if(_roleList[i] is Display3dGameMovie){
					//只有没被释放的  才调用remove函数
					if(Display3dGameMovie(_roleList[i]) && !Display3dGameMovie(_roleList[i]).hasDispose)
					{
						Display3dGameMovie(_roleList[i]).removeRender();
					}
				}
			}
			
		}
		/**
		 * 添加渲染 
		 * @param container
		 * 
		 */		
		public function addRender(container:Display3DContainer):void{
			container.addChild(this);
			//将人物身上附带的粒子添加
			for(var i:int;i<_roleList.length;i++){
				if(_roleList[i] is Display3dGameMovie){
					//Display3dGameMovie(_childrenList[i]).addExtra();
					Display3dGameMovie(_roleList[i]).addRender(this);
				}
			}
			
			ParticleManager.getInstance().resetCam();
		}
		
		//private var t:int;
		/**
		 * 逻辑驱动 （时间驱动机制）
		 * @param time
		 * 
		 */		
		public function run(time:int):void{
			for(var i:int;i<_childrenList.length;i++){
				if(_childrenList[i] is Display3dGameMovie){
					Display3dGameMovie(_childrenList[i]).updateFrame(time);
				}
			}
			//t++;
			//_role.angle3d = t;
			//_role.rotationY++;
		}
		
		override public function update():void{
			//super.update();
			if(_bg){
				Scene_data.context3D.setDepthTest(false, Context3DCompareMode.LESS);
				_bg.update();
				Scene_data.context3D.setDepthTest(true, Context3DCompareMode.LESS);
			}
			for(var i:int;i<_roleList.length;i++){
				_roleList[i].update();
			}
		}
			
		override public function reload():void{
			if(_bg)
				_bg.reload()
			for(var i:int;i<_roleList.length;i++){
				_roleList[i].reload();
			}
		}
		
		public static function regContainer($type:int,$container:Display3DContainer):void{
			if(dicContainer[$type]){
				throw new Error("已经注册过此容器！");
			}
			dicContainer[$type] = $container;
		}
		
		public static function getRegContainer($type:int):Display3DContainer{
			return dicContainer[$type];
		}
		
		private var _hasDispose:Boolean;
		override public function dispose():void{
			_hasDispose = true;
			for(var i:int;i<_roleList.length;i++){
				_roleList[i].dispose();
			}
			if(_bg){
				_bg.dispose();
			}
		}
		
		public function resize():void{
			
		}
		

	}
}