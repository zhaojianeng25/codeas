package _Pan3D.shadow.staticShadow
{
	import _Pan3D.display3D.Display3DContainer;
	import _Pan3D.display3D.Display3dGameMovie;
	import _Pan3D.program.Program3DManager;
	import _Pan3D.texture.TextureManager;
	
	import _me.Scene_data;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display3D.Program3D;
	import flash.display3D.textures.Texture;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;

	public class StaticShadowManager
	{
		private var _contaniner:Display3DContainer;
		private var displayAry:Vector.<Display3DStaticShadow>;

		private var texture:Texture;

		private var shadowProgram3d:Program3D;
		public function StaticShadowManager()
		{
			displayAry = new Vector.<Display3DStaticShadow>;
		}
		public function init($container:Display3DContainer):void{
			_contaniner = $container;
			
			initTexture();
			
			Program3DManager.getInstance().registe(Display3DStaticShadowShader.DISPLAY3DSTATICSHADOWSHADER,Display3DStaticShadowShader);
			shadowProgram3d=Program3DManager.getInstance().getProgram(Display3DStaticShadowShader.DISPLAY3DSTATICSHADOWSHADER)
		}
		
		private function initTexture():void{
			var bitmapdata:BitmapData = new BitmapData(128,128,true,0);
			var sp:Shape = new Shape;
			sp.graphics.beginFill(0x000000,0.5);
			sp.graphics.drawCircle(0,0,40);
			sp.graphics.endFill();
			sp.filters = [new BlurFilter(15,15,15)]
			
			var ma:Matrix = new Matrix;
			ma.tx = 64;
			ma.ty = 64;
			bitmapdata.draw(sp,ma);
			
			texture = TextureManager.getInstance().bitmapToTexture(bitmapdata);
		}
		
		public function showShadow(ary:Array):void{
			var index:int;
			var remove:Boolean;
			for(var i:int;i<displayAry.length;i++){
				if(remove){
					displayAry[i].removeRender();
					continue;
				}
				var flag:int = displayAry[i].setData(ary,index);
				if(flag == -1){
					remove = true;
				}
				if(!displayAry[i].parent){
					_contaniner.addChild(displayAry[i]);
				}
				index = flag;
				
			}
			
			if(index != -1){
				var display:Display3DStaticShadow = new Display3DStaticShadow(Scene_data.context3D);
				display.setProgram3D(shadowProgram3d);
				display.texture = texture;
				display.setData(ary,index);
				_contaniner.addChild(display);
				displayAry.push(display);
			}
			
		} 
		
		public function remove():void{
			for(var i:int;i<displayAry.length;i++){
				displayAry[i].removeRender();
			}
		}
		
		public function add():void{
			
		}
		
		public function reload():void{
			
			initTexture();
			shadowProgram3d=Program3DManager.getInstance().getProgram(Display3DStaticShadowShader.DISPLAY3DSTATICSHADOWSHADER);
			
			for(var i:int;i<displayAry.length;i++){
				displayAry[i].reload();
				displayAry[i].setProgram3D(shadowProgram3d);
				displayAry[i].texture = texture;
			}
			
			
		}
		
		
	}
}