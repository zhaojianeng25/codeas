package common.utils.ui.file
{
	import mx.collections.ArrayCollection;
	import mx.controls.Tree;
	
	import modules.hierarchy.HierarchyFileNode;
	

	public class FileNodeManage
	{
		public function FileNodeManage()
		{
		}
		
		public static function getChildeFileNode($node:FileNode):Vector.<FileNode>
		{
			var arr:Vector.<FileNode>=new Vector.<FileNode>
			arr.push($node)
			for(var i:uint=0;$node.children&&i<$node.children.length;i++)
			{
				arr=arr.concat(getChildeFileNode($node.children[i]))
			}
			return arr;
		}
		public static function getListAllFileNode($childItem:ArrayCollection):Vector.<FileNode>
		{
			var $arr:Vector.<FileNode>=new Vector.<FileNode>
			for(var i:uint=0;$childItem&&i<$childItem.length;i++){
				var $fileNode:FileNode=$childItem[i] 
				$arr.push($fileNode)
				$arr=$arr.concat(getListAllFileNode($fileNode.children))
				
			}
			return $arr
		}
		public static function getFileNodeInOpenId($node:FileNode,$arr:ArrayCollection,$tree:Tree):Number
		{
			var num:Number=0
			var $item:Vector.<FileNode>=getListAllFileNode($arr)
			for(var i:uint=0;i<$item.length;i++){
				if($item[i]==$node){
					return num
				}else{
					if($item[i].parentNode){
						if($tree.isItemOpen($item[i].parentNode)){
							num++
						}
					}else{
						num++
					}
				}
			}
			return num;
		}
		public static function getFileNodeNextId($arr:ArrayCollection):uint
		{
			var $item:Vector.<FileNode>=getListAllFileNode($arr)
			var $maxId:int=-1
			for(var i:uint=0;i<$item.length;i++){
				if($item[i].id>$maxId){
					$maxId=$item[i].id
				}
				
			}
			return ($maxId+1)
			
		}
		public static function addNewHierarchyFileNode($arr:ArrayCollection):HierarchyFileNode
		{
			var $temp:HierarchyFileNode=new HierarchyFileNode
			$temp.id=getFileNodeNextId($arr)
			return $temp
		}
		public static function getFileName(fullFileName:String):String{
			
			var indexStart:int = 0;														//文件指针置0
			var indexOld:int = 0;														//文件指针置0
			var indexDot:int = 0;														//文件指针置0
			var searchReg:RegExp = new RegExp;											//正则表达式
			var searchReg2:RegExp = new RegExp;											//正则表达式
			var indexObj:Object = new Object;											//取得指针，其实indexObj一点用都没有，就为了取指针
			var fileName:String = new String;											//返回的文件名
			
			searchReg = /\//g;															//取第一个"/"前的数据，目录标志
			searchReg2 = /\\/g;															//取第一个"\"前的数据，目录标志
			
			if (searchReg.test(fullFileName)){											//测试完整文件名里的斜杠是否是“/”左斜杠，如果有
				
				searchReg = /\//g;														//取第一个"/"前的数据，目录标志
				searchReg.lastIndex = 0
				indexObj = searchReg.exec(fullFileName);									
				indexStart = indexObj.index;											//记住找到"/"的位置
				
				do{																		//循环找"/"
					indexOld = indexObj.index;
					searchReg = /\//g;														
					searchReg.lastIndex = indexObj.index+1;
					indexObj = searchReg.exec(fullFileName);
					
				}while (indexObj != null)												//如果找不到"/"了，则上一次找到的就是离文件名最近的"/"
				
				indexObj = new Object;
				
				do{																		//循环找"/"
					indexDot = indexObj.index;
					searchReg = /\./g													//找"."														
					searchReg.lastIndex = indexObj.index+1;
					indexObj = searchReg.exec(fullFileName);
					
				}while (indexObj != null)												//如果找不到"/"了，则上一次找到的就是离文件名最近的"/"	
				
				fileName = fullFileName.substring(indexOld+1,indexDot)			//获得”.“之前，所有"/"之后的字符串
				
			}else if (searchReg2.test(fullFileName)){									//测试完整文件名里的斜杠是否是“\”右斜杠，如果没有
				
				searchReg = /\\/g;														//取第一个"/"前的数据，目录标志
				searchReg.lastIndex = 0
				indexObj = searchReg.exec(fullFileName);									
				indexStart = indexObj.index;											//记住找到"/"的位置
				
				do{																		//循环找"/"
					indexOld = indexObj.index;
					searchReg = /\\/g;														
					searchReg.lastIndex = indexObj.index+1;
					indexObj = searchReg.exec(fullFileName);
					
				}while (indexObj != null)												//如果找不到"/"了，则上一次找到的就是离文件名最近的"/"
				
				indexObj = new Object;	
				
				do{																		//循环找"/"
					indexDot = indexObj.index;
					searchReg = /\./g													//找"."														
					searchReg.lastIndex = indexObj.index+1;
					indexObj = searchReg.exec(fullFileName);
					
				}while (indexObj != null)												//如果找不到"/"了，则上一次找到的就是离文件名最近的"/"	
				
				fileName = fullFileName.substring(indexOld+1,indexDot)			//获得”.“之前，所有"/"之后的字符串
				
			}else{
				
				indexObj = new Object;
				
				do{																		//循环找"/"
					indexDot = indexObj.index;
					searchReg = /\./g													//找"."														
					searchReg.lastIndex = indexObj.index+1;
					indexObj = searchReg.exec(fullFileName);
					
				}while (indexObj != null)												//如果找不到"/"了，则上一次找到的就是离文件名最近的"/"	
				
				//				fileName = fullFileName.substring(indexOld+1,indexDot)			//获得”.“之前，所有"/"之后的字符串
				fileName = fullFileName.substring(0,indexDot)			//获得”.“之前，所有"/"之后的字符串
				
			}
			
			return fileName;															//返回不带路径，不带扩展名的字符串
		}
	}
}