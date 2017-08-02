package _Pan3D.display3D
{
	
	import flash.display3D.Program3D;
	import flash.geom.Matrix3D;
	
	import _Pan3D.display3D.interfaces.IDisplay3D;
	import _Pan3D.display3D.interfaces.IDisplay3DContainer;
	
	import _me.Scene_data;
	
	/**
	 * @author liuyanfei  QQ: 421537900
	 */
	public class Display3DContainer extends Display3D implements IDisplay3DContainer
	{
		protected var _childrenList:Vector.<IDisplay3D>;
		public function Display3DContainer()
		{
			_childrenList = new Vector.<IDisplay3D>;
		}
		
		public function get childrenList():Vector.<IDisplay3D>
		{
			return _childrenList;
		}

		public function set childrenList(value:Vector.<IDisplay3D>):void
		{
			_childrenList = value;
		}
		
		public function get numChildren():int{
			return _childrenList.length;
		}

//		public function play(action:String):void{
//			for(var i:int;i<_childrenList.length;i++){
//				if(_childrenList[i] is IDisplay3DMovie){
//					IDisplay3DMovie(_childrenList[i]).play(action);
//				}
//			}
//		}
		
		public function update():void
		{
			if (!this._visible) {
				return;
			}
			for(var i:int;i<_childrenList.length;i++){
				_childrenList[i].update();
			}
		}


		
		public function setMatrix(modelMatrix:Matrix3D):void
		{
			for(var i:int;i<_childrenList.length;i++){
				_childrenList[i].setMatrix(modelMatrix);
			}
		}
		
		public function addChild(display3D:IDisplay3D):void{
			if(display3D.parent){
//				trace("子对象已经有父对象");
				return;
			}
			_childrenList.push(display3D);
			display3D.parent = this;
		}
		
		public function removeChild(display3D:IDisplay3D):void{
			//display3D.removeRender();
			var index:int = _childrenList.indexOf(display3D);
			if(index == -1){
				return;
			}
			_childrenList.splice(index,1);
			display3D.parent = null;
		}
		
//		public function delChild(display3D:IDisplay3D):void{
//			var index:int = _childrenList.indexOf(display3D);
//			if(index == -1){
//				return;
//			}
//			_childrenList.splice(index,1);
//			display3D.parent = null;
//		}
		
		public function removeAllChildren():void{
			//_childrenList = new Vector.<IDisplay3D>;
			_childrenList.length = 0;
		}
		
		public function setChildIndex(display3D:IDisplay3D,index:int):void{
			if(_childrenList.indexOf(display3D) == -1){
				throw new Error("要更改的子对象不是该对象的子级！");
				return;
			}else if(index < 0 || index > _childrenList.length){
				throw new Error("超出索引范围");
				return;
			}
			
			var removeIndex:int = _childrenList.indexOf(display3D);
			_childrenList.splice(removeIndex,1);
			_childrenList.splice(index,0,display3D);
			
		}
		
		public function exchageChild(child1:IDisplay3D,child2:IDisplay3D):void{
			var index1:int = _childrenList.indexOf(child1);
			var index2:int = _childrenList.indexOf(child2);
			
			if(index1 < 0 || index1 > _childrenList.length || index2 < 0 || index2 > _childrenList.length){
				throw new Error("超出索引范围");
				return;
			}
			
			_childrenList[index1] = child2;
			_childrenList[index2] = child1;
		}
		
		override public function updateMatrix():void{
			this.x = this.parent.x + this.x;
			this.y = this.parent.y + this.y;
			this.z = this.parent.z + this.z;
		}
		
		override public function updataPos():void{
			if(this._parent){
				this._absoluteX = this._x*Scene_data.mainRelateScale + this._parent.absoluteX;
				this._absoluteY = this._y*Scene_data.mainRelateScale + this._parent.absoluteY;
				this._absoluteZ = this._z*Scene_data.mainRelateScale + this._parent.absoluteZ;
			}else{
				this._absoluteX = this._x*Scene_data.mainRelateScale;
				this._absoluteY = this._y*Scene_data.mainRelateScale;
				this._absoluteZ = this._z*Scene_data.mainRelateScale;
			}
			for(var i:int;i<_childrenList.length;i++){
				_childrenList[i].updataPos();
				//_childrenList[i].update();
			}
		}
		
		override public function setProgram3D(value:Program3D):void{
			program = value;
			for(var i:int;i<_childrenList.length;i++){
				_childrenList[i].setProgram3D(program);
			}
		}
		/**
		 * 窗口改变，更新所有子对象的坐标 
		 * 
		 */		
		public function chageSize():void{
			for(var i:int;i<_childrenList.length;i++){
				_childrenList[i].updataPos();
			}
		}
		
		public function removeRender():void{
			if(this.parent){
				this.parent.removeChild(this);
			}
		}
		/**
		 * 排列时需要对比的属性 
		 */		
		private var _compareAttribute:String;
		/**
		 * 对显示对象进行排序 
		 * @param attribute 要对比的属性
		 * @param isDescending 是否为降序
		 * 
		 */		
		public function sort(attribute:String,isDescending:Boolean=false):void{
			_compareAttribute = attribute;
			if(isDescending){
				_childrenList.sort(compareDes);
			}else{
				_childrenList.sort(compare);
			}
			_compareAttribute = null;
		}
		
		private function compare(obj1:Object,obj2:Object):int{
			if(obj1[_compareAttribute] > obj2[_compareAttribute]){
				return 1;
			}else if(obj1[_compareAttribute] == obj2[_compareAttribute]){
				return 0;
			}
			return -1;
		}
		
		private function compareDes(obj1:Object,obj2:Object):int{
			if(obj1[_compareAttribute] < obj2[_compareAttribute]){
				return 1;
			}else if(obj1[_compareAttribute] == obj2[_compareAttribute]){
				return 0;
			}
			return -1;
		}
		
		public function reload():void{
			
		}
	}
}