package materials
{
	import flash.geom.Vector3D;
	/**
	 * 
	 * 
	 * pramaType 0 表示无类型 1表示 float 2表示 vec2 3表示vec3
	 */
	public class ConstItem
	{
		public var id:int;
		public var value:Vector3D = new Vector3D;
		public var vecNum:Vector.<Number> = new Vector.<Number>;
		
		public var paramName0:String;
		public var param0Type:int;
		public var param0Index:int;
		
		public var paramName1:String;
		public var param1Type:int;
		public var param1Index:int;
		
		public var paramName2:String;
		public var param2Type:int;
		public var param2Index:int;
		
		public var paramName3:String;
		public var param3Type:int;
		public var param3Index:int;
		
		public var isDynamic:Boolean;
		
		public function ConstItem()
		{
			
		}
		
		public function creat():void{
			vecNum[0] = value.x;
			vecNum[1] = value.y;
			vecNum[2] = value.z;
			vecNum[3] = value.w;
		}
		
		public function getData():Object{
			var obj:Object = new Object;
			obj.id = this.id;
			obj.value = this.value;
			
			obj.paramName0 = this.paramName0;
			obj.param0Type = this.param0Type;
			obj.param0Index = this.param0Index;
			
			obj.paramName1 = this.paramName1;
			obj.param1Type = this.param1Type;
			obj.param1Index = this.param1Index;
			
			obj.paramName2 = this.paramName2;
			obj.param2Type = this.param2Type;
			obj.param2Index = this.param2Index;
			
			obj.paramName3 = this.paramName3;
			obj.param3Type = this.param3Type;
			obj.param3Index = this.param3Index;
			
			
			return obj;
		}
		
		public function setData(obj:Object):void{
			this.id = obj.id;
			this.value = new Vector3D(obj.value.x,obj.value.y,obj.value.z,obj.value.w);
			
			this.paramName0 = obj.paramName0;
			this.param0Type = obj.param0Type;
			this.param0Index = obj.param0Index;
			
			this.paramName1 = obj.paramName1;
			this.param1Type = obj.param1Type;
			this.param1Index = obj.param1Index;
			
			this.paramName2 = obj.paramName2;
			this.param2Type = obj.param2Type;
			this.param2Index = obj.param2Index;
			
			this.paramName3 = obj.paramName3;
			this.param3Type = obj.param3Type;
			this.param3Index = obj.param3Index;
			
			creat();
			
		}
		
		public function setDynamic($dynamic:DynamicConstItem):void{
			
			if(this.paramName0 == $dynamic.paramName){
				if(param0Type == 1){
					vecNum[param0Index] = $dynamic.currentValue.x;
				}else if(param0Type == 2){
					vecNum[param0Index] = $dynamic.currentValue.x;
					vecNum[param0Index+1] = $dynamic.currentValue.y;
				}else if(param0Type == 3){
					vecNum[param0Index] = $dynamic.currentValue.x;
					vecNum[param0Index+1] = $dynamic.currentValue.y;
					vecNum[param0Index+2] = $dynamic.currentValue.z;
				}else if(param0Type == 4){
					vecNum[param0Index] = $dynamic.currentValue.x;
					vecNum[param0Index+1] = $dynamic.currentValue.y;
					vecNum[param0Index+2] = $dynamic.currentValue.z;
					vecNum[param0Index+3] = $dynamic.currentValue.w;
				}
			}else if(this.paramName1 == $dynamic.paramName){
				if(param1Type == 1){
					vecNum[param1Index] = $dynamic.currentValue.x;
				}else if(param1Type == 2){
					vecNum[param1Index] = $dynamic.currentValue.x;
					vecNum[param1Index+1] = $dynamic.currentValue.y;
				}else if(param1Type == 3){
					vecNum[param1Index] = $dynamic.currentValue.x;
					vecNum[param1Index+1] = $dynamic.currentValue.y;
					vecNum[param1Index+2] = $dynamic.currentValue.z;
				}else if(param1Type == 4){
					vecNum[param1Index] = $dynamic.currentValue.x;
					vecNum[param1Index+1] = $dynamic.currentValue.y;
					vecNum[param1Index+2] = $dynamic.currentValue.z;
					vecNum[param1Index+3] = $dynamic.currentValue.w;
				}
			}else if(this.paramName2 == $dynamic.paramName){
				if(param2Type == 1){
					vecNum[param2Index] = $dynamic.currentValue.x;
				}else if(param2Type == 2){
					vecNum[param2Index] = $dynamic.currentValue.x;
					vecNum[param2Index+1] = $dynamic.currentValue.y;
				}else if(param2Type == 3){
					vecNum[param2Index] = $dynamic.currentValue.x;
					vecNum[param2Index+1] = $dynamic.currentValue.y;
					vecNum[param2Index+2] = $dynamic.currentValue.z;
				}else if(param2Type == 4){
					vecNum[param2Index] = $dynamic.currentValue.x;
					vecNum[param2Index+1] = $dynamic.currentValue.y;
					vecNum[param2Index+2] = $dynamic.currentValue.z;
					vecNum[param2Index+3] = $dynamic.currentValue.w;
				}
			}else if(this.paramName3 == $dynamic.paramName){
				if(param3Type == 1){
					vecNum[param3Index] = $dynamic.currentValue.x;
				}else if(param3Type == 2){
					vecNum[param3Index] = $dynamic.currentValue.x;
					vecNum[param3Index+1] = $dynamic.currentValue.y;
				}else if(param3Type == 3){
					vecNum[param3Index] = $dynamic.currentValue.x;
					vecNum[param3Index+1] = $dynamic.currentValue.y;
					vecNum[param3Index+2] = $dynamic.currentValue.z;
				}else if(param3Type == 4){
					vecNum[param3Index] = $dynamic.currentValue.x;
					vecNum[param3Index+1] = $dynamic.currentValue.y;
					vecNum[param3Index+2] = $dynamic.currentValue.z;
					vecNum[param3Index+3] = $dynamic.currentValue.w;
				}
				
			}
			
		}
		
		
	}
}