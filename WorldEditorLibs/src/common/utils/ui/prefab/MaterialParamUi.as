package common.utils.ui.prefab
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	import common.utils.frame.BaseComponent;
	import common.utils.ui.btn.LButton;
	import common.utils.ui.txt.TextCtrlInput;
	import common.utils.ui.txt.TextVec2Input;
	import common.utils.ui.txt.TextVec3Input;
	
	import materials.MaterialTree;
	
	public class MaterialParamUi extends BaseComponent
	{
		public function MaterialParamUi()
		{
			super();
		}
		private var _prefabStaticMesh:Object
		private function getDataByName($name:String):Object
		{
			for(var i:Number=0;_prefabStaticMesh.materialInfoArr&&i<_prefabStaticMesh.materialInfoArr.length;i++){
				if(_prefabStaticMesh.materialInfoArr[i].name==$name){
				
					return _prefabStaticMesh.materialInfoArr[i];
				}
			}

			return null
		}
		private function changeDataEvtFun(temp:Object):void
		{
			this.changeData()
		}
		

		override public function refreshViewValue():void{
			for(var i:Number=0;i<this.numChildren;i++){
				var $dis:Object=this.getChildAt(i)
				var dataInfo:Object=getDataByName($dis.target.paramName);

				if(dataInfo){
					if( $dis as PreFabModelPic){
						PreFabModelPic($dis).refreshViewValue()
					}	
					if($dis as TextVec3Input){
						TextVec3Input($dis).ve3Data=new Vector3D(dataInfo.x,dataInfo.y,dataInfo.z)
					}	
					if($dis as TextVec2Input){
						TextVec2Input($dis).ve2Data=new Point(dataInfo.x,dataInfo.y)
					}	
					if($dis as TextCtrlInput){
						TextCtrlInput($dis).text=String(dataInfo.x)
					}
				}else{
				
					trace("MaterialParamUi有异常")
					
					this.changeData()
				}
			
				
			}
			
		}
		private var lastMaterialTree:MaterialTree
		public function setData($materialTree:MaterialTree,$prefabStaticMesh:Object):void
		{
			
			if(_prefabStaticMesh==$prefabStaticMesh&&$materialTree==lastMaterialTree){
				this.refreshViewValue()
				return ;
			}
			lastMaterialTree=$materialTree
			while(this.numChildren){
				this.removeChildAt(0)
			}
			_prefabStaticMesh=$prefabStaticMesh;
			var $ty:Number=0
			for(var i:uint=0;i<$materialTree.data.length;i++){
				if($materialTree.data[i].data.isDynamic){  //是动态
					
					var dataInfo:Object=getDataByName($materialTree.data[i].data.paramName);
				    if($materialTree.data[i].type=="tex"){  //是纹理
						$materialTree.data[i].data.url
						var $preFabModelPic:PreFabModelPic=new PreFabModelPic();
						$preFabModelPic.FunKey="url"
						$preFabModelPic.changFun=changeDataEvtFun
						if(!dataInfo){
							dataInfo=new Object
							dataInfo.url=$materialTree.data[i].data.url
						}
						dataInfo.paramName=$materialTree.data[i].data.paramName
				
						$preFabModelPic.target=dataInfo
			
						$preFabModelPic.hasCloseBut=0
						$preFabModelPic.extensinonStr="jpg|png"
						$preFabModelPic.donotDubleClik =0
						$preFabModelPic.titleLabel =$materialTree.data[i].data.paramName
						$preFabModelPic.height=100
							
				
	
						this.addChild($preFabModelPic)
						$preFabModelPic.refreshViewValue()
						$preFabModelPic.y=$ty
						$ty=$ty+100
					}
					
					
					if($materialTree.data[i].type=="vec3"){  //Vector3d
						var $textVec3Input:TextVec3Input = new TextVec3Input;
									
						if(dataInfo){
							$textVec3Input.ve3Data=new Vector3D(dataInfo.x,dataInfo.y,dataInfo.z)
						}else{
							$textVec3Input.ve3Data=new Vector3D($materialTree.data[i].data.constValue.x,$materialTree.data[i].data.constValue.y,$materialTree.data[i].data.constValue.z,$materialTree.data[i].data.constValue.w)
								
						}
						
						$textVec3Input.label =$materialTree.data[i].data.paramName
						$textVec3Input.target=$materialTree.data[i].data
						$textVec3Input.step=0.01
						$textVec3Input.changFun=changeDataEvtFun
						this.addChild($textVec3Input)
						$textVec3Input.y=$ty
						$ty=$ty+25
					}
					if($materialTree.data[i].type=="vec2"){  //Vector2d
						var $TextVec2Input:TextVec2Input = new TextVec2Input;
						if(dataInfo){
							$TextVec2Input.ve2Data=new Point(dataInfo.x,dataInfo.y)
						}else{
							$TextVec2Input.ve2Data=new Point($materialTree.data[i].data.constValue.x,$materialTree.data[i].data.constValue.y)
						}
						
						$TextVec2Input.label =$materialTree.data[i].data.paramName
						$TextVec2Input.target=$materialTree.data[i].data
						$TextVec2Input.changFun=changeDataEvtFun
						$TextVec2Input.step=0.01;
						this.addChild($TextVec2Input)
						$TextVec2Input.y=$ty
						$ty=$ty+25
					}
					if($materialTree.data[i].type=="float"){  //浮点

						var $textCtrlInput:TextCtrlInput = new TextCtrlInput;
						$textCtrlInput.center = true;
						$textCtrlInput.height = 18;
						if(dataInfo){
							$textCtrlInput.text=String(dataInfo.x)
						}else{
							$textCtrlInput.text=String($materialTree.data[i].data.constValue)
						}
			
						$textCtrlInput.label = $materialTree.data[i].data.paramName
						$textCtrlInput.target=$materialTree.data[i].data
						$textCtrlInput.changFun=changeDataEvtFun
						$textCtrlInput.step=0.01;
						this.addChild($textCtrlInput)
						$textCtrlInput.y=$ty
						$ty=$ty+25
						
					}
						
				}
				
			}
			
			var btn:LButton = new LButton;
			btn.label = "确认更改"
			btn.changFun =this.changeData
			btn.y=$ty
			$ty=$ty+25
		//	this.addChild(btn)
			btn.refreshViewValue();
		
			this.height=$ty
		}
		public function changeData():void
		{
			
			
			var $arr:Array=new Array()
	        for(var i:Number=0;i<this.numChildren;i++){
				var $dis:DisplayObject=this.getChildAt(i)
				var $obj:Object=new Object
				if( $dis as PreFabModelPic){
					$obj.type=0//"tex"
					$obj.name=PreFabModelPic($dis).target.paramName
					$obj.url=PreFabModelPic($dis).target.url
					$arr.push($obj)
				}	
				if($dis as TextVec3Input){
					$obj.type=3//"vec3"
					$obj.name=TextVec3Input($dis).target.paramName
					$obj.x=TextVec3Input($dis).ve3Data.x;
					$obj.y=TextVec3Input($dis).ve3Data.y;
					$obj.z=TextVec3Input($dis).ve3Data.z;
					$arr.push($obj)
				}	
				if($dis as TextVec2Input){
					$obj.type=2//"vec2"
					$obj.name=TextVec2Input($dis).target.paramName
					$obj.x=TextVec2Input($dis).ve2Data.x;
					$obj.y=TextVec2Input($dis).ve2Data.y;
					$arr.push($obj)
				}	
				if($dis as TextCtrlInput){
					$obj.type=1//"float"
					$obj.name=TextCtrlInput($dis).target.paramName
					$obj.x=Number(TextCtrlInput($dis).text)
					$arr.push($obj)
				}
	
			}
			
			_prefabStaticMesh.materialInfoArr=$arr
				
			return ;
			Alert.show("更新材质内容","提示",Alert.YES | Alert.NO,null,	function onClose(evt:CloseEvent):void
			{
				if(evt.detail == Alert.YES){
					_prefabStaticMesh.materialInfoArr=$arr

				}
			});
	
			

		}
		
	}
}