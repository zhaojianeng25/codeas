package _Pan3D.shadow.dynamicShadow
{
	import _Pan3D.display3D.Display3DContainer;
	import _Pan3D.display3D.Display3dGameMovie;
	import _Pan3D.program.Program3DManager;
	
	import _me.Scene_data;
	
	import flash.display3D.Context3DTextureFormat;

	public class DynamicShadowManager
	{
		private var _display3DynamicShadow:Display3DynamicShadow;
		private var _contaniner:Display3DContainer;
		
		public function DynamicShadowManager()
		{
			
		}
		public function showShadow(ary:Array):void{
			return;
			var hitVec:Vector.<Display3dGameMovie> = new Vector.<Display3dGameMovie>();
			for each(var sc:Display3dGameMovie in ary)
			{
				hitVec.push(sc);
			}
			DynamicShadowUtil.getInstance().scanNpcShadow(hitVec)
		}
		
		public function init($container:Display3DContainer):void{
			_contaniner = $container;
			
			_display3DynamicShadow=new Display3DynamicShadow(Scene_data.context3D);
			_contaniner.addChild(_display3DynamicShadow);
			Program3DManager.getInstance().registe( Display3DynamicShadowShader.DISPLAY3D_YNAMIC_SHADOW_SHADER,Display3DynamicShadowShader)
			_display3DynamicShadow.program=Program3DManager.getInstance().getProgram(Display3DynamicShadowShader.DISPLAY3D_YNAMIC_SHADOW_SHADER);
			
			//Display3DynamicShadow.npcShadowText=Scene_data.context3D.createTexture(2048,2048, Context3DTextureFormat.BGRA,true);
			
		}
		public function resetSize():void
		{
			if(_display3DynamicShadow){
				_display3DynamicShadow.resetSize();
			}
		}
		
		public function remove():void{
			_display3DynamicShadow.removeRender();
		}
		public function add():void{
			_contaniner.addChild(_display3DynamicShadow);
		}
		public function reload():void{
			_display3DynamicShadow.reload();
		}
	}
}