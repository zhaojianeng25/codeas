package light
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Vector3D;
	
	import interfaces.ITile;
	
	public class LightProbeTempStaticMesh extends EventDispatcher implements ITile
	{
		private var _isUse:Boolean
		private var _postion:Vector3D=new Vector3D;
		private var _resultSHVec:Vector.<Vector3D>
		public function LightProbeTempStaticMesh()
		{
			super();
		}
		
		public function get resultSHVec():Vector.<Vector3D>
		{
			return _resultSHVec;
		}

		public function set resultSHVec(value:Vector.<Vector3D>):void
		{
			_resultSHVec = value;
		}

		public function get postion():Vector3D
		{
			return _postion
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

		public function get isUse():Boolean
		{
			return _isUse;
		}
		[Editor(type="ComboBox",Label="是否起用",sort="10",Category="属性",Data="{name:false,data:false}{name:true,data:true}",Tip="是否当地形用来扫描高度")]
		public function set isUse(value:Boolean):void
		{
			_isUse = value;
			change()
		}
		
		public function readObject():Object
		{
			var $obj:Object=new Object
			$obj.isUse=_isUse
			$obj.postion=postion
				
			var arr:Array=new Array
			for(var i:uint=0;_resultSHVec&&i<_resultSHVec.length;i++){
				var dddd:Object=new Object
				dddd.x=_resultSHVec[i].x
				dddd.y=_resultSHVec[i].y
				dddd.z=_resultSHVec[i].z
				arr.push(dddd)
			}
				
			$obj.resultSHVec=arr
	
			return $obj
		}
		public function objToMesh($obj:Object):void
		{
			isUse=$obj.isUse
			postion=new Vector3D($obj.postion.x,$obj.postion.y,$obj.postion.z)
			_resultSHVec=new Vector.<Vector3D>
				
			for(var i:uint=0;i<9;i++){
				var $vec:Vector3D=new Vector3D
				if($obj.resultSHVec&&$obj.resultSHVec.length==9){
					$vec.x=$obj.resultSHVec[i].x
					$vec.y=$obj.resultSHVec[i].y
					$vec.z=$obj.resultSHVec[i].z
				}
				_resultSHVec.push($vec)
			}
		
				
		}
		public function change():void{
			this.dispatchEvent(new Event(Event.CHANGE));
			
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
			return null;
		}
		
	}
}