package materials
{
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;

	public class MaterialBaseData
	{
		public var baseColorUrl:String;
		public var normalUrl:String;
		public var url:String
		public var baseColor:Vector3D=new Vector3D;
		public var roughness:Number=0;
		public var specular:Number=0;
		public var metallic:Number=0;

		public var usePbr:Boolean=false;

		
		public function MaterialBaseData()
		{
			
		}
		
		public function setData(obj:Object):void{
			if(!obj){
				return;
			}
			
			this.baseColorUrl = obj.baseColorUrl;
			if(obj.baseColor){
				this.baseColor = new Vector3D(obj.baseColor.x,obj.baseColor.y,obj.baseColor.z);
			}
			this.roughness = obj.roughness;
			this.specular = obj.specular;
			this.metallic = obj.metallic;
			this.normalUrl = obj.normalUrl;
			this.usePbr = obj.usePbr;

			this.url = obj.url;

		}
		
		public function getData():Object{
			var obj:Object = new Object;
			obj.baseColorUrl = this.baseColorUrl;
			obj.baseColor = this.baseColor;
			obj.roughness = this.roughness;
			obj.specular = this.specular;
			obj.metallic = this.metallic;
			obj.normalUrl = this.normalUrl;
			obj.usePbr = this.usePbr;
			obj.url = this.url;
			return obj;
		}
		public function writeToByte($byte:ByteArray):void
		{
		
			if(this.baseColorUrl){
				$byte.writeUTF(this.baseColorUrl)
			}else{
				$byte.writeUTF("")
			}
			if(this.normalUrl){
				$byte.writeUTF(this.normalUrl)
			}else{
				$byte.writeUTF("")
			}
			if(this.url){
				$byte.writeUTF(this.url)
			}else{
				$byte.writeUTF("")
			}
			
			$byte.writeFloat(this.baseColor.x);
			$byte.writeFloat(this.baseColor.y);
			$byte.writeFloat(this.baseColor.z);
			$byte.writeFloat(this.baseColor.w);
				
				
			$byte.writeFloat(this.roughness);
			$byte.writeFloat(this.specular);
			$byte.writeFloat(this.metallic);
			$byte.writeBoolean(this.usePbr);
				
				
	
			
		}
		
	}
}