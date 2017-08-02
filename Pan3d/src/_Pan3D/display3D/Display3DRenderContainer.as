package _Pan3D.display3D
{
	import _Pan3D.display3D.analysis.ObjAnalysis;
	import _Pan3D.display3D.interfaces.IDisplay3D;
	import _Pan3D.role.Role;
	
	import _me.Scene_data;
	
	import flash.display3D.Context3D;

	public class Display3DRenderContainer extends Display3DContainer
	{
		public var renderList:Vector.<Role>;
		protected var logicList:Vector.<Role>;
		public var compareFun:Function;
		public var context3D:Context3D;
		
		public function Display3DRenderContainer()
		{
			super();
		}
		
		public function refreshRenderlist(target:Object,camera:Object = null):void{
			renderList = new Vector.<Role>;
			logicList = new Vector.<Role>;
			for each(var display:Display3D in _childrenList){
				if(compareFun(target,display)){
					renderList.push(display);
					Role(display).inRender = true;
				}else{
					logicList.push(display);
					Role(display).inRender = false;
				}
			}
		}
		
		override public function update():void{
			for(var i:int;i<renderList.length;i++){
				renderList[i].update();
			}
			for(i=0;i<logicList.length;i++){
				logicList[i].doLogic();
			}
		}
		
	}
}