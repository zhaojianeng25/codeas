package modules.materials.view.mathNode
{
	import com.zcp.frame.event.ModuleEventManager;
	
	import flash.events.Event;
	
	import common.msg.event.materials.MEvent_Material_Connect;
	
	import modules.materials.view.BaseMaterialNodeUI;
	import modules.materials.view.ItemMaterialUI;
	import modules.materials.view.MaterialItemType;
	
	public class MathDynamicNodeUI extends BaseMaterialNodeUI
	{
		private var intAItem:ItemMaterialUI;
		private var intBItem:ItemMaterialUI;
		private var outItem:ItemMaterialUI;
		private var outRItem:ItemMaterialUI;
		private var outGItem:ItemMaterialUI;
		private var outBItem:ItemMaterialUI;
		private var outXYItem:ItemMaterialUI;
		private var outRGBItem:ItemMaterialUI;
		private var outAItem:ItemMaterialUI;
		public function MathDynamicNodeUI()
		{
			super();
			titleBitmap = new phys_marterialCls3;
			addTitleImg();
			this.gap = 20;
			this.width = 162;
			this.height = 80;
		}
		
		protected function initItem():void{
			intAItem = new ItemMaterialUI("a",MaterialItemType.UNDEFINE);
			intBItem = new ItemMaterialUI("b",MaterialItemType.UNDEFINE);
			outItem = new ItemMaterialUI("out",MaterialItemType.UNDEFINE,false);
			outRItem = new ItemMaterialUI("r",MaterialItemType.FLOAT,false);
			outGItem = new ItemMaterialUI("g",MaterialItemType.FLOAT,false);
			outBItem = new ItemMaterialUI("b",MaterialItemType.FLOAT,false);
			outXYItem = new ItemMaterialUI("xy",MaterialItemType.VEC2,false);
			outRGBItem = new ItemMaterialUI("rgb",MaterialItemType.VEC3,false);
			outAItem = new ItemMaterialUI("a",MaterialItemType.FLOAT,false);
			
			addItems(intAItem);
			addItems(intBItem);
			addItems(outItem);
			
			addEvents(intAItem);
			addEvents(intBItem);
			addEvents(outItem);
			
			
			addDisEvent(intAItem);
			addDisEvent(intBItem);
			addDisEvent(outItem);
			addDisEvent(outRItem);
			addDisEvent(outGItem);
			addDisEvent(outBItem);
			addDisEvent(outXYItem);
			addDisEvent(outRGBItem);
			addDisEvent(outAItem);
		}
		
		
		public function addEvents($nodeUI:ItemMaterialUI):void{
			$nodeUI.addEventListener("Connect",onConnect);
		}
		
		public function addDisEvent($nodeUI:ItemMaterialUI):void{
			$nodeUI.addEventListener("DisConnect",disConnect);
		}
		
		
		
		public function disConnect(event:Event):void{
			checkItem();
		}
		
		protected function onConnect(event:Event):void
		{
			var target:ItemMaterialUI = event.target as ItemMaterialUI;
			var type:String = target.type;
			target.changeType(type);
			
			checkItem();
			
			if(intAItem.type != MaterialItemType.UNDEFINE && intBItem.type != MaterialItemType.UNDEFINE){
				if(intAItem.type != MaterialItemType.FLOAT && intBItem.type != MaterialItemType.FLOAT){
					if(intAItem.type != intBItem.type){
						target.removeAllLine();
					}
				}
			}
		}
		
		public function checkItem():void{
			if(!intAItem.hasConnet){
				intAItem.changeType(MaterialItemType.UNDEFINE);
			}
			if(!intBItem.hasConnet){
				intBItem.changeType(MaterialItemType.UNDEFINE);
			}
			if(!outItem.hasConnet){
				outItem.changeType(MaterialItemType.UNDEFINE);
			}

			if(outItem.type == MaterialItemType.VEC3){
				if(intAItem.type == MaterialItemType.FLOAT){
					if(intBItem.type == MaterialItemType.UNDEFINE){
						intBItem.changeType(MaterialItemType.VEC3);
					}
				}
				if(intBItem.type == MaterialItemType.FLOAT){
					if(intAItem.type == MaterialItemType.UNDEFINE){
						intAItem.changeType(MaterialItemType.VEC3);
					}
				}
			}else if(outItem.type == MaterialItemType.VEC4){
				if(intAItem.type == MaterialItemType.FLOAT){
					if(intBItem.type == MaterialItemType.UNDEFINE){
						intBItem.changeType(MaterialItemType.VEC4);
					}
				}
				if(intBItem.type == MaterialItemType.FLOAT){
					if(intAItem.type == MaterialItemType.UNDEFINE){
						intAItem.changeType(MaterialItemType.VEC4);
					}
				}
			}else if(outItem.type == MaterialItemType.VEC2){
				if(intAItem.type == MaterialItemType.FLOAT){
					if(intBItem.type == MaterialItemType.UNDEFINE){
						intBItem.changeType(MaterialItemType.VEC2);
					}
				}
				if(intBItem.type == MaterialItemType.FLOAT){
					if(intAItem.type == MaterialItemType.UNDEFINE){
						intAItem.changeType(MaterialItemType.VEC2);
					}
				}
			}else if(outItem.type == MaterialItemType.FLOAT){
				if(intAItem.type == MaterialItemType.UNDEFINE){
					intAItem.changeType(MaterialItemType.FLOAT);
				}
				if(intBItem.type == MaterialItemType.UNDEFINE){
					intBItem.changeType(MaterialItemType.FLOAT);
				}
			}else if(outItem.type == MaterialItemType.UNDEFINE){
				if(intAItem.type == MaterialItemType.VEC4 || intBItem.type == MaterialItemType.VEC4){
					outItem.changeType(MaterialItemType.VEC4);
				}else if(intAItem.type == MaterialItemType.VEC3 || intBItem.type == MaterialItemType.VEC3){
					outItem.changeType(MaterialItemType.VEC3);
				}else if(intAItem.type == MaterialItemType.VEC2 || intBItem.type == MaterialItemType.VEC2){
					outItem.changeType(MaterialItemType.VEC2);
				}else if(intAItem.type == MaterialItemType.FLOAT && intBItem.type == MaterialItemType.FLOAT){
					outItem.changeType(MaterialItemType.FLOAT);
				}
			}
			
			if(outItem.type == MaterialItemType.VEC4){
				addItems(outRItem);
				addItems(outGItem);
				addItems(outBItem);
				addItems(outXYItem);
				addItems(outRGBItem);
				addItems(outAItem);
				this.height = 180;
			}else if(outItem.type == MaterialItemType.VEC3){
				addItems(outRItem);
				addItems(outGItem);
				addItems(outBItem);
				addItems(outXYItem);
				this.height = 140;
				removeItem(outRGBItem);
				outRGBItem.removeAllLine();
				removeItem(outAItem);
				outAItem.removeAllLine();
			}else{
				removeItem(outRItem);
				outRItem.removeAllLine();
				removeItem(outGItem);
				outGItem.removeAllLine();
				removeItem(outBItem)
				outBItem.removeAllLine();
				removeItem(outXYItem);
				outXYItem.removeAllLine();
				removeItem(outRGBItem);
				outRGBItem.removeAllLine();
				removeItem(outAItem);
				outAItem.removeAllLine();
				this.height = 80;
			}
			
		}
		
		override public function setInItemByData(ary:Array):void{
			super.setInItemByData(ary);
			intAItem.changeType(ary[0].type);
			intBItem.changeType(ary[1].type);
			
		}
		
		override public function setOutItemByData(ary:Array):void{
			super.setOutItemByData(ary);
			outItem.changeType(ary[0].type);
			if(ary.length >= 2){
				addItems(outRItem);
				addItems(outGItem);
				addItems(outBItem);
				addItems(outXYItem);
			}
			if(ary.length >= 6){
				addItems(outRGBItem);
				addItems(outAItem);
			}
			
		}
		
	}
}