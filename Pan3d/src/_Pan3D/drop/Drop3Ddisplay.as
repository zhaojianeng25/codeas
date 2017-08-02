package _Pan3D.drop
{
	import flash.display.BitmapData;
	
	import _Pan3D.particle.ctrl.CombineParticle;
	import _Pan3D.particle.ctrl.ParticleManager;
	import _Pan3D.skill.SkillManager;
	import _Pan3D.text.Text3Dynamic;
	import _Pan3D.text.TextFieldManager;

	/**
	 * 掉落物显示类 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class Drop3Ddisplay
	{
		/**
		 * x位置 
		 */		
		private var _x:int;
		/**
		 * y位置 
		 */		
		private var _y:int;
		private var _nameBitmapdata:BitmapData;
		private var _particleUrl:String;
		private var _bitmapdata:BitmapData;
		private var _particle:CombineParticle;
		/**
		 * 掉落图片的3D控制对象 
		 */		
		private var _dropView:Text3Dynamic;
		/**
		 * 名字的3d控制对象 
		 */		
		private var _nameView:Text3Dynamic;
		
		public function Drop3Ddisplay()
		{
			
		}

		/**
		 * 显示掉落物的图片 
		 */
		public function get bitmapdata():BitmapData
		{
			return _bitmapdata;
		}

		/**
		 * @private
		 */
		public function set bitmapdata($img:BitmapData):void
		{
			if(_dropView){
				_dropView.dispose();
			}
			_dropView = TextFieldManager.getInstance().getText3Dynamic($img.width,$img.height,0.9);
			_dropView.bitmapdata = $img;
			//_dropView.add();
			_bitmapdata = $img;
			_dropView.setXY(_x,_y);
		}
		
		public function setXY($x:int,$y:int):void{
			_x = $x;
			_y = $y;
			if(_dropView)
				_dropView.setXY($x,$y);
			if(_nameView)
				_nameView.setXY($x-(_nameBitmapdata.width-_bitmapdata.width)/2,$y-_nameBitmapdata.height);
			if(_particle)
				_particle.setXY(_x+_bitmapdata.width/2,_y+_bitmapdata.height/2);
		}

		/**
		 * 名称的位图 
		 */
		public function set nameBitmapdata($img:BitmapData):void
		{
			if(_nameView){
				_nameView.dispose();
			}
			_nameView = TextFieldManager.getInstance().getText3Dynamic($img.width,$img.height,0.8);
			_nameView.bitmapdata = $img;
			//_nameView.add();
			_nameBitmapdata = $img;
			_nameView.setXY(_x,_y);
		}

		/**
		 * 粒子的路径 
		 */
		public function get particleUrl():String
		{
			return _particleUrl;
		}

		/**
		 * @private
		 */
		public function set particleUrl(value:String):void
		{
			_particleUrl = value;
			_particle = ParticleManager.getInstance().addSceneParticle(value,SkillManager.priority);
			//ParticleManager.getInstance().addParticle(_particle);
			_particle.setXY(_x,_y);
		}
		/**
		 * 添加显示 
		 * 
		 */
		public function add():void{
			if(_dropView)
				_dropView.add();
			if(_nameView)
				_nameView.add();
			if(_particle)
				ParticleManager.getInstance().addParticle(_particle);
		}
		/**
		 * 移除显示 
		 * 
		 */		
		public function remove():void{
			if(_dropView)
				_dropView.remove()
			if(_nameView)
				_nameView.remove()
			if(_particle)
				ParticleManager.getInstance().removeParticle(_particle);
		}
		/**
		 * 释放资源 
		 * 
		 */		
		public function dispose():void{
			if(_dropView)
				_dropView.dispose();
			if(_nameView)
				_nameView.dispose();
		}
		
		


	}
}