package pack
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Vector3D;
	
	import interfaces.ITile;

	public class ModePropertyMesh extends EventDispatcher implements ITile
	{



		private var _postion:Vector3D=new Vector3D;
		private var _scaleVec:Vector3D=new Vector3D;
		private var _rotationVec:Vector3D=new Vector3D;
		private var _nodeName:String
		private var _taget:Object
		private var _data:Object
		
	

		public function get fileNode():Object
		{
			return _data;
		}
		
		public function set fileNode(value:Object):void
		{
			_data = value;
		}
		public function ModePropertyMesh()
		{
		}
		public function get nodeName():String
		{
			return _nodeName;
		}

		public function set nodeName(value:String):void
		{
			_nodeName = value;
		}

		public function get taget():Object
		{
			return _taget;
		}

		public function set taget(value:Object):void
		{
			_taget = value;
		}

		public function get postion():Vector3D
		{
			return _postion.clone()
		}
		[Editor(type="Vec3",Label="位置:",Step="1",sort="1",Category="位置",Tip="x")]
		public function set postion(value:Vector3D):void
		{
		
			if(value.x==_postion.x&&value.y==_postion.y&&value.z==_postion.z){
				
			}else{
				_postion = value
				change();
			}
		
		}
		public function get scaleVec():Vector3D
		{
			return _scaleVec.clone()
		}
		[Editor(type="Vec3",Label="缩放:",Step="0.01",sort="2",Category="位置",Tip="x")]
		public function set scaleVec(value:Vector3D):void
		{
			
			if(value.x==_scaleVec.x&&value.y==_scaleVec.y&&value.z==_scaleVec.z){
				
			}else{
				_scaleVec =  value

				change();
			}
		
		}
		
		public function get rotationVec():Vector3D
		{
			return _rotationVec.clone()
		}
		[Editor(type="Vec3",Label="旋转:",Step="1",sort="3",Category="位置",Tip="x")]
		public function set rotationVec(value:Vector3D):void
		{
		
			if(value.x==_rotationVec.x&&value.y==_rotationVec.y&&value.z==_rotationVec.z){
				
			}else{
				_rotationVec =  value;
				change();
			}
		
		}

		

		public function acceptPath():String
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		public function getBitmapData():BitmapData
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		public function getName():String
		{
			// TODO Auto Generated method stub
			return _nodeName;
		}
		public function change():void{
			this.dispatchEvent(new Event(Event.CHANGE));

		}
		
	}
}