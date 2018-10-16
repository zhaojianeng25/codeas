package modules.materials.view.preview
{
	import mx.containers.Canvas;
	
	import modules.materials.view.prop.NodeTreePropManager;
	
	public class MaterialPrejectView extends Canvas
	{
		private var _container:Canvas;

		
		public function MaterialPrejectView()
		{
			super();
			_container=new Canvas;
			this.addChild(_container)
			_container.width=200
			_container.height=0
				
				
			NodeTreePropManager.getInstance().container=_container

			this.horizontalScrollPolicy="off"
			this.verticalScrollPolicy="off";


		
		}
		public function resetSize($w:Number,$h:Number):void
		{
			this.width=$w
			this.height=$h
			_container.width=$w
			
		}

	}
}