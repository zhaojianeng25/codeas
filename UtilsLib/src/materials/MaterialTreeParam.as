package materials
{
	import flash.display3D.Program3D;

	public class MaterialTreeParam extends Material
	{
		public var material:MaterialTree;
		public var materialUrl:String;
		
		public var program:Program3D
		public var dynamicTexList:Vector.<DynamicTexItem>;
		public var dynamicConstList:Vector.<DynamicConstItem>;
		
		public function MaterialTreeParam()
		{
			super();
		}
		
		public function init():void{
			dynamicTexList = new Vector.<DynamicTexItem>;
			dynamicConstList = new Vector.<DynamicConstItem>;
		}
		
		public function setMaterial($materialTree:MaterialTree):void{
			material = $materialTree;
			materialUrl = $materialTree.url;
			
			dynamicTexList = new Vector.<DynamicTexItem>;
			dynamicConstList = new Vector.<DynamicConstItem>;
			setTexList();
			setConstList();
		}
		
		public function setLife($life:int):void{
			for(var i:int=0;i<dynamicTexList.length;i++){
				if(dynamicTexList[i].isParticleColor){
					dynamicTexList[i].life = $life;
				}
			}
		}
		
		
		
		public function setTexList():void{
			var texList:Vector.<TexItem> = material.texList;
			for(var i:int;i<texList.length;i++){
				var dyTex:DynamicTexItem;
				if(texList[i].isParticleColor){
					dyTex = new DynamicTexItem;
					dyTex.target = texList[i];
					dyTex.paramName = texList[i].paramName;
					dyTex.initCurve(4);
					dynamicTexList.push(dyTex);
					dyTex.isParticleColor = true;
				}else if(texList[i].isDynamic){
					dyTex = new DynamicTexItem;
					dyTex.target = texList[i];
					dyTex.paramName = texList[i].paramName;
					dynamicTexList.push(dyTex);
				} 
				
			}
		}
		
		public function setTextObj(ary:Array):void{
			for(var i:int;i<ary.length;i++){
				var obj:Object = ary[i];
				for(var j:int=0;j<dynamicTexList.length;j++){
					if(dynamicTexList[j].paramName == obj.paramName){
						if(dynamicTexList[j].isParticleColor){
							dynamicTexList[j].curve.setData(obj.curve);
						}else{
							dynamicTexList[j].url = obj.url;
						}
						break;
					}
				}
			}
			
		}
		
		public function setConstObj(ary:Array):void{
			for(var i:int;i<ary.length;i++){
				var obj:Object = ary[i];
				for(var j:int=0;j<dynamicConstList.length;j++){
					if(dynamicConstList[j].paramName == obj.paramName){
						dynamicConstList[j].curve.setData(obj.curve)
						break;
					}
				}
			}
		}
		
		public function setConstList():void{
			var constList:Vector.<ConstItem> = material.constList;
			for(var i:int;i<constList.length;i++){
				var constItem:ConstItem = constList[i];
				var dyCon:DynamicConstItem;
				if(constItem.param0Type != 0){
					dyCon = new DynamicConstItem;
					dyCon.target = constItem;
					dyCon.paramName = constItem.paramName0;
					dyCon.indexID = constItem.param0Index;
					dyCon.type = constItem.param0Type;
					dynamicConstList.push(dyCon);
				}
				
				if(constItem.param1Type != 0){
					dyCon = new DynamicConstItem;
					dyCon.target = constItem;
					dyCon.paramName = constItem.paramName1;
					dyCon.indexID = constItem.param1Index;
					dyCon.type = constItem.param1Type;
					dynamicConstList.push(dyCon);
				}
				
				if(constItem.param2Type != 0){
					dyCon = new DynamicConstItem;
					dyCon.target = constItem;
					dyCon.paramName = constItem.paramName2;
					dyCon.indexID = constItem.param2Index;
					dyCon.type = constItem.param2Type;
					dynamicConstList.push(dyCon);
				}
				
				if(constItem.param3Type != 0){
					dyCon = new DynamicConstItem;
					dyCon.target = constItem;
					dyCon.paramName = constItem.paramName3;
					dyCon.indexID = constItem.param3Index;
					dyCon.type = constItem.param3Type;
					dynamicConstList.push(dyCon);
				}
			}
		}
		
		public function getData():Object{
			var obj:Object = new Object;
			var ary:Array = new Array;
			for(var i:int;i<dynamicTexList.length;i++){
				ary.push(dynamicTexList[i].getData());
			}
			obj.texAry = ary;
			
			ary = new Array;
			for(i=0;i<dynamicConstList.length;i++){
				ary.push(dynamicConstList[i].getData());
			}
			obj.conAry = ary;
			obj.materialUrl = this.materialUrl;
			
			return obj;
		} 
		
		public function setData(obj:Object,$material:MaterialTree):void{
			this.materialUrl = obj.materialUrl;
			this.material = $material;
			
			dynamicTexList = new Vector.<DynamicTexItem>;
			dynamicConstList = new Vector.<DynamicConstItem>;
			
			
			var ary:Array = obj.texAry;
			for(var i:int;i<ary.length;i++){
				var dyTex:DynamicTexItem = new DynamicTexItem;
				dyTex.setData(ary[i]);
				getTexTarget(dyTex);
				dynamicTexList.push(dyTex);
			}
			
			ary = obj.conAry;
			for(i=0;i<ary.length;i++){
				var dyCon:DynamicConstItem = new DynamicConstItem;
				dyCon.setData(ary[i]);
				getConTarget(dyCon);
				dynamicConstList.push(dyCon);
			}
			
		}
		
		public function getTexTarget(dyTex:DynamicTexItem):void{
			for(var i:int;i<material.texList.length;i++){
				if(material.texList[i].paramName == dyTex.paramName){
					dyTex.target = material.texList[i];
					return;
				}
			}
		}
		
		public function getConTarget(dyCon:DynamicConstItem):void{
			for(var i:int;i<material.constList.length;i++){
				var constItem:ConstItem = material.constList[i];
				if(constItem.paramName0 == dyCon.paramName || constItem.paramName1 == dyCon.paramName
					|| constItem.paramName2 == dyCon.paramName || constItem.paramName3 == dyCon.paramName){
					dyCon.target = constItem;
					return;
				}
			}
		}
		
		
	}
}