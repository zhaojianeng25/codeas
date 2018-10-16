package  _Pan3D.utils
{
	import flash.geom.Vector3D;
	
	import _Pan3D.texture.TextureManager;
	import _Pan3D.vo.texture.TextureVo;
	
	import _me.Scene_data;
	
	import materials.ConstItem;
	import materials.DynamicConstItem;
	import materials.DynamicTexItem;
	import materials.Material;
	import materials.MaterialTree;
	

	public class MaterialBaseParam
	{
		public var dynamicTexList:Vector.<DynamicTexItem>;
		public var dynamicConstList:Vector.<DynamicConstItem>;
		
		private var _material:MaterialTree;
		
		public var hasData:Boolean = false;
		
		public function MaterialBaseParam()
		{
			
			
		}
		
		public function setMaterial($material:MaterialTree):void{
			this._material = $material;
			
			this.applyMaterial();
		}
		
		public function update():void{
			if(this._material && this.dynamicConstList){
				for(var i:int=0;i<this.dynamicConstList.length;i++){
					this.dynamicConstList[i].updateBase();
				}
			}
			
		}
		
		private function addParamTexture(textureVo : TextureVo, info : Object):void{
			DynamicTexItem(info).texture = textureVo.texture;
		}
		
		public function applyMaterial():void{
			if(this._material && this.dynamicConstList){
				var constList:Vector.<ConstItem> = _material.constList;
				
				for(var i:int=0;i<this.dynamicConstList.length;i++){
					for(var j:int=0;j<constList.length;j++){
						
						if(this.dynamicConstList[i].paramName == constList[j].paramName0
						|| this.dynamicConstList[i].paramName == constList[j].paramName1
						|| this.dynamicConstList[i].paramName == constList[j].paramName2
						|| this.dynamicConstList[i].paramName == constList[j].paramName3){
							
							this.dynamicConstList[i].target = constList[j];
							
							break;
							
						}
						
					}
				}
				
				for(i=0;i<this.dynamicTexList.length;i++){
				
					for(j=0;j<_material.texList.length;j++){
						if(dynamicTexList[i].paramName == _material.texList[j].paramName){
							dynamicTexList[i].target = _material.texList[j];
						}
					}
					
				}
				
				this.hasData = true;
				
			}
		}
		
		public function setData($ary:Array):void{
			
			dynamicTexList = new Vector.<DynamicTexItem>;
			dynamicConstList = new Vector.<DynamicConstItem>;
			
			for(var i:int=0;i<$ary.length;i++){
				var obj:Object = $ary[i];
				if(obj.type == 0){
					var texItem:DynamicTexItem = new DynamicTexItem();
					texItem.paramName = obj.name;
					TextureManager.getInstance().addTexture(Scene_data.fileRoot + obj.url,this.addParamTexture,texItem);
					this.dynamicTexList.push(texItem);
				}else{
					var constItem:DynamicConstItem = new DynamicConstItem();
					constItem.paramName = obj.name;
					constItem.currentValue = new Vector3D();
					
					if(obj.type == 1){
						constItem.currentValue.x = obj.x;
					}else if(obj.type == 2){
						constItem.currentValue.x = obj.x;
						constItem.currentValue.y = obj.y;
					}else{
						constItem.currentValue.x = obj.x;
						constItem.currentValue.y = obj.y;
						constItem.currentValue.z = obj.z;
					}
					
					this.dynamicConstList.push(constItem);
					
					
				}
			}
			
			this.applyMaterial();
		}
		
	}
	
	
	
	
}