/***********************************/
/*http://www.layabox.com 2015/12/20*/
/***********************************/
window.Laya=(function(window,document){
	var Laya={
		__internals:[],
		__packages:{},
		__classmap:{'Object':Object,'Function':Function,'Array':Array,'String':String},
		__sysClass:{'object':'Object','array':'Array','string':'String','dictionary':'Dictionary'},
		__propun:{writable: true,enumerable: false,configurable: true},
		__presubstr:String.prototype.substr,
		__substr:function(ofs,sz){return arguments.length==1?Laya.__presubstr.call(this,ofs):Laya.__presubstr.call(this,ofs,sz>0?sz:(this.length+sz));},
		__init:function(_classs){_classs.forEach(function(o){o.__init$ && o.__init$();});},
		__parseInt:function(value){return !value?0:parseInt(value);},
		__isClass:function(o){return o && (o.__isclass || o==Object || o==String || o==Array);},
		__newvec:function(sz,value){
			var d=[];
			d.length=sz;
			for(var i=0;i<sz;i++) d[i]=value;
			return d;
		},
		__extend:function(d,b){
			for (var p in b){
				if (!b.hasOwnProperty(p)) continue;
				var g = b.__lookupGetter__(p), s = b.__lookupSetter__(p); 
				if ( g || s ) {
					g && d.__defineGetter__(p, g);
					s && d.__defineSetter__(p, s);
				} 
				else d[p] = b[p];
			}
			function __() { Laya.un(this,'constructor',d); }__.prototype=b.prototype;d.prototype=new __();Laya.un(d.prototype,'__imps',Laya.__copy({},b.prototype.__imps));
		},
		__copy:function(dec,src){
			if(!src) return null;
			dec=dec||{};
			for(var i in src) dec[i]=src[i];
			return dec;
		},
		__package:function(name,o){
			if(Laya.__packages[name]) return;
			Laya.__packages[name]=true;
			var p=window,strs=name.split('.');
			if(strs.length>1){
				for(var i=0,sz=strs.length-1;i<sz;i++){
					var c=p[strs[i]];
					p=c?c:(p[strs[i]]={});
				}
			}
			p[strs[strs.length-1]] || (p[strs[strs.length-1]]=o||{});
		},
		__hasOwnProperty:function(name,o){
			o=o ||this;
		    function classHas(name,o){
				if(Object.hasOwnProperty.call(o.prototype,name)) return true;
				var s=o.prototype.__super;
				return s==null?null:classHas(name,s);
			}
			return (Object.hasOwnProperty.call(o,name)) || classHas(name,o.__class);
		},
		__typeof:function(o,value){
			if(!o || !value) return false;
			if(value==String) return (typeof o=='string');
			if(value==Number) return (typeof o=='number');
			if(value.__interface__) value=value.__interface__;
			else if(typeof value!='string')  return (o instanceof value);
			return (o.__imps && o.__imps[value]) || (o.__class==value);
		},
		__as:function(value,type){
			return (this.__typeof(value,type))?value:null;
		},		
		interface:function(name,_super){
			Laya.__package(name,{});
			var ins=Laya.__internals;
			var a=ins[name]=ins[name] || {};
			a.self=name;
			if(_super)a.extend=ins[_super]=ins[_super] || {};
			var o=window,words=name.split('.');
			for(var i=0;i<words.length-1;i++) o=o[words[i]];o[words[words.length-1]]={__interface__:name};
		},
		class:function(o,fullName,dic,_super,miniName){
			dic && (Laya.un(o.prototype,'toString',LAYABOX.toStringForDic));
			_super && Laya.__extend(o,_super);
			if(fullName){
				Laya.__package(fullName,o);
				Laya.__classmap[fullName]=o;
				if(fullName.indexOf('.')>0){
					if(fullName.indexOf('laya.')==0){
						var paths=fullName.split('.');
						miniName=miniName || paths[paths.length-1];
						if(Laya[miniName]) debugger;
						Laya[miniName]=o;
					}					
				}
				else {
					if(fullName=="Main")
						window.Main=o;
					else{
						if(Laya[fullName]){
							console.log("Err!,Same class:"+fullName,Laya[fullName]);
							debugger;
						}
						Laya[fullName]=o;
					}
				}
			}
			var un=Laya.un,p=o.prototype;
			un(p,'hasOwnProperty',Laya.__hasOwnProperty);
			un(p,'__class',o);
			un(p,'__super',_super);
			un(p,'__className',fullName);
			un(o,'__super',_super);
			un(o,'__className',fullName);
			un(o,'__isclass',true);
			un(o,'super',function(o){this.__super.call(o);});
		},
		imps:function(dec,src){
			if(!src) return null;
			var d=dec.__imps|| Laya.un(dec,'__imps',{});
			for(var i in src){
				d[i]=src[i];
				var c=i;
				while((c=this.__internals[c]) && (c=c.extend) ){
					c=c.self;d[c]=true;
				}
			}
		},		
		getset:function(isStatic,o,name,getfn,setfn){
			if(!isStatic){
				getfn && Laya.un(o,'_$get_'+name,getfn);
				setfn && Laya.un(o,'_$set_'+name,setfn);
			}
			else{
				getfn && (o['_$GET_'+name]=getfn);
				setfn && (o['_$SET_'+name]=setfn);
			}
			if(getfn && setfn) 
				Object.defineProperty(o,name,{get:getfn,set:setfn,enumerable:false});
			else{
				getfn && Object.defineProperty(o,name,{get:getfn,enumerable:false});
				setfn && Object.defineProperty(o,name,{set:setfn,enumerable:false});
			}
		},
		static:function(_class,def){
				for(var i=0,sz=def.length;i<sz;i+=2){
					if(def[i]=='length') 
						_class.length=def[i+1].call(_class);
					else{
						function tmp(){
							var name=def[i];
							var getfn=def[i+1];
							Object.defineProperty(_class,name,{
								get:function(){delete this[name];return this[name]=getfn.call(this);},
								set:function(v){delete this[name];this[name]=v;},enumerable: true,configurable: true});
						}
						tmp();
					}
				}
		},		
		un:function(obj,name,value){
			arguments.length<3 &&(value=obj[name]);
			Laya.__propun.value=value;
			Object.defineProperty(obj, name, Laya.__propun);
			return value;
		},
		uns:function(obj,names){
			names.forEach(function(o){Laya.un(obj,o)});
		}
	};

	window.console=window.console || ({log:function(){}});
	window.trace=window.console.log;
	Error.prototype.throwError=function(){throw arguments;};
	String.prototype.substr=Laya.__substr;
	Object.defineProperty(Array.prototype,'fixed',{enumerable: false});
	var iflash=window.iflash={utils:{}};
	var LAYABOX=window.LAYABOX=window.LAYABOX || {
		classmap:Laya.__classmap,
		systemClass:Laya.__sysClass,
	};
	Function.prototype.BIND$ = function(o) {
			this.__$BiD___ || (this.__$BiD___ = LAYABOX.__bindid++);
			o.BIND$__ || (o.BIND$__={});
			var fn=o.BIND$__[this.__$BiD___];
			if(fn) return fn;
			return o.BIND$__[this.__$BiD___]=this.bind(o);
	};
	Array.CASEINSENSITIVE = 1;
	Array.DESCENDING = 2;
	Array.NUMERIC = 16;
	Array.RETURNINDEXEDARRAY = 8;
	Array.UNIQUESORT = 4;
	Object.defineProperty(Array.prototype,'fixed',{enumerable: false});
	(function(defs){
		var p=Date.prototype;
		Object.defineProperty(p,'millisecondsUTC',{get:p.getUTCMilliseconds,enumerable: false});
		Object.defineProperty(p,'minutesUTC',{get:p.getUTCMinutes,enumerable: false});
		Object.defineProperty(p,'mouthUTC',{get:p.getUTCMonth,enumerable: false});
		for(var i=0;i<defs.length;i++)
			Object.defineProperty(p,defs[i],{get:p['get'+defs[i].charAt(0).toUpperCase()+defs[i].substr(1)]})
	})(['date','day','fullYear','hours','millseconds','minutes','month','seconds','time','timezoneOffset','dateUTC','dayUTC','fullYearUTC','hoursUTC']);
	LAYABOX.__bindid=1;	
	LAYABOX.sortonNameArray2=function(array,name,options){
		(options===void 0)&& (options=0);
		var name0=name[0],name1=name[1],type=1;
		if (options==(16 | 2))type=-1;
		return array.sort(function(a,b){
			if (b[name0]==a[name0]){
				 return type *(a[name1]-b[name1]);
			}else return type *(a[name0]-b[name0]);
		});
	};
	LAYABOX.sortonNameArray=function(array,name,options){
		(options===void 0)&& (options=0);
		var name0=name[0],type=1;
		(options==(16 | 2)) && (type=-1);
		return array.sort(function(a,b){
			if (b[name0]==a[name0]){
				for (var i=1,sz=name.length;i < sz;i++){
					var tmp=name[i];
					if (b[tmp]!=a[tmp])return type *(a[tmp]-b[tmp]);
				}
				return 0;
			}
			else return type *(a[name0]-b[name0]);
		});
	};
	LAYABOX.arraypresort=Array.prototype.sort;
	Laya.un(Array.prototype,'sortOn',function(name,options){
		if(name instanceof Function) return this.sort(name);
		if((name instanceof Array)){
			if(name.length==0)return this;
			if(name.length==2)return LAYABOX.sortonNameArray2(this,name,options);
			if(name.length>2)return LAYABOX.sortonNameArray(this,name,options);name=name[0];
		}
		if (options==16)return this.sort(function(a,b){return a[name]-b[name];});
		if (options==2)return this.sort(function(a,b){return b[name]-a[name];});
		if (options==(16 | 2))return this.sort(function(a,b){return b[name]-a[name];});
		if (options==1) return this.sort();
		return this.sort(function(a,b){return a[name]-b[name];});
	});
	Laya.un(Array.prototype,'sort',function(value){
		if(value==16) return LAYABOX.arraypresort.call(this,function (a, b) {return a - b;});
		if(value==(16|2)) return LAYABOX.arraypresort.call(this,function (a, b) {return b - a;});
		if(value==1) return LAYABOX.arraypresort.call(this);
		return LAYABOX.arraypresort.call(this,value);
	});
	LAYABOX.bind=function(obj,fn){
		return obj==null || fn==null?null:fn.BIND$(obj);
	};
	var Dictionary=window.Dictionary=iflash.utils.Dictionary=function(){};	window.Dictionary.prototype=Object.prototype;
	Laya.__classmap['Dictionary']=Dictionary;
	LAYABOX.DICKEY=0;
	LAYABOX.DICKEYS=[];
	LAYABOX.toStringForDic=function(){(!this.__DICKEY__) && (Laya.un(this,'__DICKEY__',--LAYABOX.DICKEY),LAYABOX.DICKEYS['&layadic_'+this.__DICKEY__]=this);return '&layadic_'+this.__DICKEY__;};

	return Laya;
})(window,document);

	var __un=Laya.un,__uns=Laya.uns,__static=Laya.static,__class=Laya.class,__getset=Laya.getset,__newvec=Laya.__newvec,__bind=LAYABOX.bind;
	var LAYAFNVOID=function(){};
	var LAYAFNSTR=function(){return '';}
	var LAYAFNNULL=function(){return null;}
	var LAYAFNTRUE=function(){return true;}
	var LAYAFNFALSE=function(){return false;}
	var LAYAFN0=function(){return 0;}
	var LAYAFNARRAY = function() { return []; }
	var GETEACH = function(a) { return a?a:[]; }

	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/ibitmapdrawable.as
	Laya.interface('iflash.display.IBitmapDrawable');
	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/igraphicsdata.as
	Laya.interface('iflash.display.IGraphicsData');
	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/xml/ixmlelement.as
	Laya.interface('iflash.xml.IXMLElement');
	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/net/idynamicpropertywriter.as
	Laya.interface('iflash.net.IDynamicPropertyWriter');
	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/igraphicspath.as
	Laya.interface('iflash.display.IGraphicsPath');
	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/igraphicsstroke.as
	Laya.interface('iflash.display.IGraphicsStroke');
	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/system/iobject.as
	Laya.interface('iflash.laya.system.IObject');
	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/igraphicsfill.as
	Laya.interface('iflash.display.IGraphicsFill');
	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/net/idynamicpropertyoutput.as
	Laya.interface('iflash.net.IDynamicPropertyOutput');
	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/utils/iexternalizable.as
	Laya.interface('iflash.utils.IExternalizable');
	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/ieventdispatcher.as
	Laya.interface('iflash.events.IEventDispatcher');
	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/utils/idataoutput.as
	Laya.interface('iflash.utils.IDataOutput');
	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/utils/idatainput.as
	Laya.interface('iflash.utils.IDataInput');
	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/utils/idatainput.jas
	Laya.interface('iflash.utils.IDataInput');
	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/utils/idataoutput.jas
	Laya.interface('iflash.utils.IDataOutput');
	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/browser.as
	//class Browser
	var Browser=(function(){
		function Browser(){};
		__class(Browser,'Browser',true);
		__getset(1,Browser,'frameRate',function(){
			return Browser._driver_.frameRate;
			},function(num){
			Browser._driver_.frameRate=num;
		});

		Browser.__init__=function(sprite){
			/*__JS__ */Browser._driver_=new iflash.laya.driver.Driver(sprite);
		}

		Browser.__start__=function(){
			Browser._driver_.start();
			Browser._driver_.regEvent();
		}

		Browser.eval=function(str,target){
			target=target || Browser.window;
			/*__JS__ */return target.eval(str);
		}

		Browser.err=function(e){
			console.log("err:"+e);
		}

		Browser._createRootCanvas_=function(){
			var canvas=Browser._driver_.getRootCanvas();
			canvas["id"]="canvas";
			canvas.size(Browser.window.innerWidth,Browser.window.innerHeight);
			if (Laya.HTMLVER){
				Browser.document.body.appendChild(canvas);
				/*__JS__ */if(!Laya.CONCHVER){canvas.style.position='absolute';canvas.style.left=canvas.style.top=0;};
			}
			return canvas;
		}

		Browser.addToBody=function(htmlElement){
			Browser.document.body.appendChild(htmlElement);
		}

		Browser.removeFromBody=function(htmlElement){
			if(htmlElement&&htmlElement.parentNode){
				htmlElement.parentNode.removeChild(htmlElement);
			}
		}

		Browser._createWebGLCanvas_=function(){
			if (Laya.CONCHVER)return Browser._createRootCanvas_();
			var canvas=Browser.document.createElement("canvas");
			canvas.size(Browser.window.innerWidth,Browser.window.innerHeight);
			if (Laya.HTMLVER){
				Browser.document.body.appendChild(canvas);
				/*__JS__ */if(!Laya.CONCHVER){canvas.style.position='absolute';canvas.style.left=canvas.style.top=0;canvas.style.zIndex=-1000;};
			}
			return canvas;
		}

		Browser._debugger_=function(){
			/*__JS__ */debugger;
		}

		Browser.alert=function(e){
			/*__JS__ */alert(e);
		}

		Browser._createModle_=function(type,id,node){
			return Browser._driver_.createModle(type,id,node);
		}

		Browser.createHttpRequest=function(){
			return Browser._driver_.createHttpRequest();
		}

		Browser.setCursor=function(cursor){
			Browser._driver_.cursor(cursor);
			Browser._cursors_.push(cursor);
		}

		Browser.restoreCursor=function(){
			if (Browser._cursors_.length==0)return;
			Browser._cursors_.pop();
			Browser._driver_.cursor(Browser._cursors_.length>0?Browser._cursors_[Browser._cursors_.length-1]:"default");
		}

		Browser.hideSystemLoading=function(){
			if (Laya.CONCHVER){
				Browser.window.conchMarket&&Browser.window.conchMarket.sendMessageToPlatform('{"type":"ge_load_game_end"}',function(){});
				/*__JS__ */conch.showLoadingView(false);
			}
		}

		Browser.refresh=function(){
			Browser.location.reload();
		}

		Browser.window=null;
		Browser.document=null;
		Browser.location=null
		Browser.navigator=null
		Browser.input=null
		Browser._driver_=null
		Browser._cursors_=[];
		Browser.__init$=function(){
			/*__JS__ */window.Browser=Browser;
		}

		return Browser;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/method/importjs.as
	Laya.__package('iflash.method');
	iflash.method.importJS=function(jsFile,callback,evalJs){
		(evalJs===void 0)&& (evalJs=true);
		LAYABOX.importsJS=LAYABOX.importsJS || [];
		if ((jsFile instanceof Array)){
			var s=jsFile.length;
			for (var i=0;i < jsFile.length;i++){
				jsFile[i]=Method.formatUrl(jsFile[i]);
				iflash.method.importJS(jsFile[i],function(){
					s--;
					if (s==0)callback();
				},false);
			}
			return;
		}

		jsFile=Method.formatUrl(jsFile);
		console.log("import JavaScript:"+jsFile);
		if (LAYABOX.importsJS[jsFile]){
			callback();
			return;
		};

		var xhr=/*__JS__ */new XMLHttpRequest();
		xhr.onload=function (e){
			/*__JS__ */window.eval(xhr.responseText);
			LAYABOX.importsJS[jsFile]=true;
			callback();
		}

		xhr.onerror=function (e){
			throw "下载js"+jsFile+"失败";
		}

		xhr.open("GET",jsFile,true);
		xhr.send();
	}


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/utils/clearinterval.as
	Laya.__package('iflash.utils');
	iflash.utils.clearInterval=function(id){
		SetIntervalTimer.clearInterval(id);
	}


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/utils/regclass.as
	Laya.__package('iflash.utils');
	iflash.utils.regClass=function(name,_class){
		/*__JS__ */LAYABOX.classmap[name]=_class;
	}


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/fns.as
	/*__JS__ */LAYABOX.getInterfaceDefinitionByName=function (name){var words=name.split('.');var o=Laya;for (var i=0;i < words.length;i++){o=o[words[i]];if(!o){return null}}return o;};
	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/utils/getqualifiedsuperclassname.as
	Laya.__package('iflash.utils');
	iflash.utils.getQualifiedSuperclassName=function(value){
		/*__JS__ */return iflash.utils.getQualifiedClassName(value.__super);
	}


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/net/navigatetourl.as
	Laya.__package('iflash.net');
	iflash.net.navigateToURL=function(request,_window){
		/*__JS__ */window.open(request.url || request,_window?_window:'_blank');
	}


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/net/getclassbyalias.as
	Laya.__package('iflash.net');
	iflash.net.getClassByAlias=function(aliasName){
		return iflash.net.classDic[aliasName];
	}


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/utils/flash_proxy.as
	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/utils/getaliasname.as
	Laya.__package('iflash.utils');
	iflash.utils.getAliasName=function(param1){return ""}
		
	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/utils/describetype.as
	Laya.__package('iflash.utils');
	iflash.utils.describeType=function(value){
		var name=iflash.utils.getQualifiedClassName(value);
		while(name.indexOf('.')!=-1){
			name=name.replace('.','');
		}

		name='dst'+name.replace('::','_');
		return new XML(iflash.utils.getDefinitionByName('DescribeTypeClass')[name]());
	}


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/system/fscommand.as
	Laya.__package('iflash.system');
	iflash.system.fscommand=function(command,args){
		(args===void 0)&& (args="");
	}


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/utils/cleartimeout.as
	Laya.__package('iflash.utils');
	iflash.utils.clearTimeout=function(id){
		SetIntervalTimer.clearInterval(id);
	}


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/utils/formatstring.as
	Laya.__package('iflash.utils');
	iflash.utils.formatString=function(format,__args){
		var args=[];for(var i=1,sz=arguments.length;i<sz;i++)args.push(arguments[i]);
		for (var i=0;i<args.length;++i)
		format=format.replace(new RegExp("\\{"+i+"\\}","g"),args[i]);
		return format;
	}


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/utils/settimeout.as
	Laya.__package('iflash.utils');
	iflash.utils.setTimeout=function(closure,delay,____){
		var __=[];for(var i=2,sz=arguments.length;i<sz;i++)__.push(arguments[i]);arguments=__;
		return new SetIntervalTimer(closure,delay,false,arguments).id;
	}


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/utils/escapemultibyte.as
	Laya.__package('iflash.utils');
	iflash.utils.escapeMultiByte=function(source){
		return /*__JS__ */encodeURIComponent(source).replace('_','%5F').replace('.','%2E');
	}


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/utils/getqualifiedclassname.as
	Laya.__package('iflash.utils');
	iflash.utils.getQualifiedClassName=function(value){
		if(!value)return null;
		if((typeof value=='string'))
			return "String";
		else if((value instanceof Array))
		return "Array";
		else {
			if(typeof(value)=="function"){
				if(value.__className){
					/*__JS__ */var index=value.__className.lastIndexOf(".");
					return /*__JS__ */index !=-1 ? value.__className.substr(0,index)+"::"+value.__className.substr(index+1,value.__className.length):value.__className;
					}else{
					return value.name||value.lin;
				}
			}
			if(value.__interface__){
				/*__JS__ */var index=value.__interface__.lastIndexOf(".");
				return /*__JS__ */index !=-1 ? value.__interface__.substr(0,index)+"::"+value.__interface__.substr(index+1,value.__interface__.length):value.__interface__;
			}
			/*__JS__ */var _value=value.__className?value.__className:LAYABOX.systemClass[(typeof value)];
			/*__JS__ */var index=_value.lastIndexOf(".");
			return /*__JS__ */index !=-1 ? _value.substr(0,index)+"::"+_value.substr(index+1,_value.length):_value;
		}

	}


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/method/dic.as
	Laya.__package('iflash.method');
	iflash.method.DIC=function(o){
		/*__JS__ */if(!o || o.__DICKEY__)return o;
		/*__JS__ */if(typeof o=='string' || typeof o=='number')return o;
		/*__JS__ */o.toString=LAYABOX.toStringForDic;
		/*__JS__ */o.toString();return o;
	}


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/utils/gettimer.as
	Laya.__package('iflash.utils');
	iflash.utils.getTimer=function(){
		return (/*__JS__ */Date.now()-Timer.__STARTTIME__)*Timer.__SPEED__;
	}


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/utils/setinterval.as
	Laya.__package('iflash.utils');
	iflash.utils.setInterval=function(closure,delay,____){
		var __=[];for(var i=2,sz=arguments.length;i<sz;i++)__.push(arguments[i]);arguments=__;
		return new SetIntervalTimer(closure,delay,true,arguments).id;
	}


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/net/registerclassalias.as
	Laya.__package('iflash.net');
	iflash.net.registerClassAlias=function(aliasName,classObject){
		iflash.net.classDic[aliasName]=classObject;
	}


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/net/classdic.as
	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/utils/regxmlattr.as
	Laya.__package('iflash.laya.utils');
	iflash.laya.utils.regXmlAttr=function(_class,fndef,set_get,htmlNeed){
		(htmlNeed===void 0)&& (htmlNeed=true);
		DynamicProperties.reg(_class,fndef,set_get,htmlNeed);
		return 1;
	}


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/utils/getdefinitionbyname.as
	Laya.__package('iflash.utils');
	iflash.utils.getDefinitionByName=function(param1){
		param1=param1.replace("::",".");
		return /*__JS__ */LAYABOX.classmap[param1];
	}


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/method/getnetworktype.as
	Laya.__package('iflash.method');
	iflash.method.getNetworkType=function(){
		var nt=-1;
		if(Laya.CONCHVER)
			nt=/*__JS__ */window.conchConfig.getNetworkType();
		return nt;
	}


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/method/xmllength.as
	Laya.__package('iflash.method');
	iflash.method.xmlLength=function(xml){
		return xml?xml.lengths():0;
	}


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/method/bind.as
	Laya.__package('iflash.method');
	iflash.method.bind=function(context,fun,nothing){
		(nothing===void 0)&& (nothing=true);
		return (fun==null)?null:fun.BIND$(context);
	}


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/method/byteat.as
	Laya.__package('iflash.method');
	iflash.method.byteAt=function(byteArray,index){
		return byteArray._byteAt_(index);
	}


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/method/byteset.as
	Laya.__package('iflash.method');
	iflash.method.byteSet=function(byteArray,index,value){
		byteArray._byteSet_(index,value);
	}


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/method/dicclear.as
	Laya.__package('iflash.method');
	iflash.method.DICCLEAR=function(dic,dickey){
		(LAYABOX.DICKEYS[dickey] !=null)&& (delete LAYABOX.DICKEYS[dickey]);
	}


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/method/dickey.as
	Laya.__package('iflash.method');
	iflash.method.DICKEY=function(o){
		/*__JS__ */if(typeof o!='string' || o.indexOf('&layadic_')!=0)return o;
		/*__JS__ */return LAYABOX.DICKEYS[o.toString()];
	}


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/method/typeas.as
	Laya.__package('iflash.method');
	iflash.method.typeAs=function(value,type){
		/*__JS__ */return (Laya.__typeof(value,type))?value:null;
	}


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/net/sendtourl.as
	Laya.__package('iflash.net');
	iflash.net.sendToURL=function(request){}
		
	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/utils/bytearray.jas
	//class iflash.utils.ByteArray
	var ByteArray=(function(){
		function ByteArray(){
			this._length=0;
			this._objectEncoding_=0;
			this._position_=0;
			this._allocated_=8;
			this._data_=null;
			this._littleEndian_=false;
			this._byteView_=null;
			this._strTable=null;
			this._objTable=null;
			this._traitsTable=null;
			/*__JS__ */this.___resizeBuffer(this._allocated_);
		}

		__class(ByteArray,'iflash.utils.ByteArray',false);
		var __proto=ByteArray.prototype;
		__proto.clear=function(){
			this._strTable=[];
			this._objTable=[];
			this._traitsTable=[];
			this._position_=0;
			this.length=0;
		}

		__proto.ensureWrite=function(lengthToEnsure){
			if (this._length < lengthToEnsure)this.length=lengthToEnsure;
		}

		__proto.readBoolean=function(){
			return (this.readByte ()!=0);
		}

		__proto.readByte=function(){
			return this._data_.getInt8 (this._position_++);
		}

		__proto.readBytes=function(bytes,offset,length){
			(offset===void 0)&& (offset=0);
			(length===void 0)&& (length=0);
			if (offset < 0 || length < 0){
				throw "Read error - Out of bounds";
			}
			if (length==0)length=this._length-this._position_;
			bytes.ensureWrite (offset+length);
			bytes._byteView_.set (this._byteView_.subarray(this._position_,this._position_+length),offset);
			bytes.position=offset;
			this._position_+=length;
			if (bytes.position+length > bytes.length)bytes.length=bytes.position+length;
		}

		__proto.readDouble=function(){
			var double=this._data_.getFloat64 (this._position_,this._littleEndian_);
			this._position_+=8;
			return double;
		}

		__proto.readFloat=function(){
			var float=this._data_.getFloat32 (this._position_,this._littleEndian_);
			this._position_+=4;
			return float;
		}

		__proto.readFullBytes=function(bytes,pos,len){
			this.ensureWrite (len);
			for(var i=pos;i < pos+len;i++){
				this._data_.setInt8 (this._position_++,bytes.get(i));
			}
		}

		__proto.readInt=function(){
			var tInt=this._data_.getInt32 (this._position_,this._littleEndian_);
			this._position_+=4;
			return tInt;
		}

		__proto.readShort=function(){
			var short=this._data_.getInt16 (this._position_,this._littleEndian_);
			this._position_+=2;
			return short;
		}

		__proto.readUnsignedByte=function(){
			return this._data_.getUint8 (this._position_++);
		}

		__proto.readUnsignedInt=function(){
			var uInt=this._data_.getUint32 (this._position_,this._littleEndian_);
			this._position_+=4;
			return int(uInt);
		}

		__proto.readUnsignedShort=function(){
			var uShort=this._data_.getUint16 (this._position_,this._littleEndian_);
			this._position_+=2;
			return uShort;
		}

		__proto.readUTF=function(){
			return this.readUTFBytes (this.readUnsignedShort ());
		}

		__proto.readUnicode=function(length){
			var value="";
			var max=this._position_+length;
			var c1=0,c2=0;
			while (this._position_ < max){
				c2=this._byteView_[this._position_++];
				c1=this._byteView_[this._position_++];
				value+=String.fromCharCode(c1<<8 | c2);
			}
			return value;
		}

		__proto.readMultiByte=function(length,charSet){
			if(charSet=="UNICODE" || charSet=="unicode"){
				return this.readUnicode(length);
			}
			return this.readUTFBytes (length);
		}

		__proto.readUTFBytes=function(len){
			var value="";
			var max=this._position_+len;
			var c=0,c2=0,c3=0;
			while (this._position_ < max){
				c=this._data_.getUint8 (this._position_++);
				if (c < 0x80){
					if (c !=0){
						value+=String.fromCharCode (c);
					}
					}else if (c < 0xE0){
					value+=String.fromCharCode (((c & 0x3F)<< 6)| (this._data_.getUint8 (this._position_++)& 0x7F));
					}else if (c < 0xF0){
					c2=this._data_.getUint8 (this._position_++);
					value+=String.fromCharCode (((c & 0x1F)<< 12)| ((c2 & 0x7F)<< 6)| (this._data_.getUint8 (this._position_++)& 0x7F));
					}else {
					c2=this._data_.getUint8 (this._position_++);
					c3=this._data_.getUint8 (this._position_++);
					value+=String.fromCharCode (((c & 0x0F)<< 18)| ((c2 & 0x7F)<< 12)| ((c3 << 6)& 0x7F)| (this._data_.getUint8 (this._position_++)& 0x7F));
				}
			}
			return value;
		}

		__proto.toString=function(){
			var cachePosition=this._position_;
			this._position_=0;
			var value=this.readUTFBytes (this.length);
			this._position_=cachePosition;
			return value;
		}

		__proto.writeBoolean=function(value){
			this.writeByte (value ? 1 :0);
		}

		__proto.writeByte=function(value){
			this.ensureWrite (this._position_+1);
			this._data_.setInt8 (this._position_,value);
			this._position_+=1;
		}

		__proto.writeBytes=function(bytes,offset,length){
			(offset===void 0)&& (offset=0);
			(length===void 0)&& (length=0);
			if (offset < 0 || length < 0)throw "writeBytes error - Out of bounds";
			if(length==0)length=bytes.length-offset;
			this.ensureWrite (this._position_+length);
			/*__JS__ */this._byteView_.set(bytes._byteView_.subarray (offset,offset+length),this._position_);
			this._position_+=length;
		}

		__proto.writeArrayBuffer=function(arraybuffer,offset,length){
			(offset===void 0)&& (offset=0);
			(length===void 0)&& (length=0);
			if (offset < 0 || length < 0)throw "writeArrayBuffer error - Out of bounds";
			if(length==0)length=arraybuffer.byteLength-offset;
			this.ensureWrite (this._position_+length);
			var uint8array=/*__JS__ */new Uint8Array(arraybuffer);
			/*__JS__ */this._byteView_.set(uint8array.subarray (offset,offset+length),this._position_);
			this._position_+=length;
		}

		__proto.writeDouble=function(x){
			this.ensureWrite (this._position_+8);
			this._data_.setFloat64 (this._position_,x,this._littleEndian_);
			this._position_+=8;
		}

		__proto.writeFloat=function(x){
			this.ensureWrite (this._position_+4);
			this._data_.setFloat32 (this._position_,x,this._littleEndian_);
			this._position_+=4;
		}

		__proto.writeInt=function(value){
			/*__JS__ */this.ensureWrite (this._position_+4);
			/*__JS__ */this._data_.setInt32 (this._position_,value,this._littleEndian_);
			this._position_+=4;
		}

		__proto.writeShort=function(value){
			this.ensureWrite (this._position_+2);
			this._data_.setInt16 (this._position_,value,this._littleEndian_);
			this._position_+=2;
		}

		__proto.writeUnsignedInt=function(value){
			this.ensureWrite (this._position_+4);
			this._data_.setUint32 (this._position_,value,this._littleEndian_);
			this._position_+=4;
		}

		__proto.writeUnsignedShort=function(value){
			this.ensureWrite (this._position_+2);
			this._data_.setUint16 (this._position_,value,this._littleEndian_);
			this._position_+=2;
		}

		__proto.writeUTF=function(value){
			value=value+"";
			this.writeUnsignedShort (this._getUTFBytesCount(value));this.writeUTFBytes (value);
		}

		__proto.writeUnicode=function(value){
			value=value+"";
			this.ensureWrite (this._position_+value.length*2);
			var c=0;
			for(var i=0,sz=value.length;i<sz;i++){
				c=value.charCodeAt(i);
				this._byteView_[this._position_++]=c&0xff;
				this._byteView_[this._position_++]=c>>8;
			}
		}

		__proto.writeMultiByte=function(value,charSet){
			value=value+"";
			if(charSet=="UNICODE" || charSet=="unicode"){
				return this.writeUnicode(value);
			}
			this.writeUTFBytes(value);
		}

		__proto.writeUTFBytes=function(value){
			value=value+"";
			this.ensureWrite(this._position_+value.length*4);
			for (var i=0,sz=value.length;i < sz;i++){
				var c=value.charCodeAt(i);
				if (c <=0x7F){
					this.writeByte (c);
					}else if (c <=0x7FF){
					this.writeByte (0xC0 | (c >> 6));
					this.writeByte (0x80 | (c & 63));
					}else if (c <=0xFFFF){
					this.writeByte(0xE0 | (c >> 12));
					this.writeByte(0x80 | ((c >> 6)& 63));
					this.writeByte(0x80 | (c & 63));
					}else {
					this.writeByte(0xF0 | (c >> 18));
					this.writeByte(0x80 | ((c >> 12)& 63));
					this.writeByte(0x80 | ((c >> 6)& 63));
					this.writeByte(0x80 | (c & 63));
				}
			}
			this.length=this._position_;
		}

		__proto.__fromBytes=function(inBytes){
			this._byteView_=/*__JS__ */new Uint8Array(inBytes.getData ());
			this.length=this._byteView_.length;
			this._allocated_=this.length;
		}

		__proto.__get=function(pos){
			return this._data_.getUint8(pos);
		}

		__proto._getUTFBytesCount=function(value){
			var count=0;
			value=value+"";
			for (var i=0,sz=value.length;i < sz;i++){
				var c=value.charCodeAt(i);
				if (c <=0x7F){
					count+=1;
					}else if (c <=0x7FF){
					count+=2;
					}else if (c <=0xFFFF){
					count+=3;
					}else {
					count+=4;
				}
			}
			return count;
		}

		__proto._byteAt_=function(index){
			return this._byteView_[index];
		}

		__proto._byteSet_=function(index,value){
			this.ensureWrite (index+1);
			this._byteView_[index]=value;
		}

		__proto.uncompress=function(algorithm){
			(algorithm===void 0)&& (algorithm="zlib");
			/*__JS__ */var inflate=new Zlib.Inflate(this._byteView_);
			/*__JS__ */this._byteView_=inflate.decompress();
			/*__JS__ */this._data_=new DataView(this._byteView_ .buffer);;
			this._allocated_=this._length=this._byteView_.byteLength;
			this._position_=0;
		}

		__proto.compress=function(algorithm){
			(algorithm===void 0)&& (algorithm="zlib");
			/*__JS__ */var deflate=new Zlib.Deflate(this._byteView_);
			/*__JS__ */this._byteView_=deflate.compress();
			/*__JS__ */this._data_=new DataView(this._byteView_.buffer);;
			this._position_=this._allocated_=this._length=this._byteView_.byteLength;
		}

		__proto.___resizeBuffer=function(len){
			try{
				var newByteView=/*__JS__ */new Uint8Array(len);
				if (this._byteView_!=null){
					if (this._byteView_.length <=len)newByteView.set (this._byteView_);
					else newByteView.set (this._byteView_.subarray (0,len));
				}
				this._byteView_=newByteView;
				this._data_=/*__JS__ */new DataView(newByteView.buffer);
			}
			catch (err){
				throw "___resizeBuffer err:"+len;
			}
		}

		__proto.__getBuffer=function(){
			this._data_.buffer.byteLength=this.length;
			return this._data_.buffer;
		}

		__proto.__set=function(pos,v){
			this._data_.setUint8 (pos,v);
		}

		__proto.setUint8Array=function(data){
			this._byteView_=data;
			this._data_=/*__JS__ */new DataView(data.buffer);
			this._length=data.byteLength;
			this._position_=0;
		}

		__proto.readObject=function(){
			this._strTable=[];
			this._objTable=[];
			this._traitsTable=[];
			return this.readObject2();
		}

		__proto.readObject2=function(){
			var type=this.readByte();
			return this.readObjectValue(type);
		}

		__proto.readObjectValue=function(type){
			var value;
			switch (type){
				case 1:
					break ;
				case 6:
					value=this.__readString();
					break ;
				case 4:
					value=this.readInterger();
					break ;
				case 2:
					value=false;
					break ;
				case 3:
					value=true;
					break ;
				case 10:
					value=this.readScriptObject();
					break ;
				case 9:
					value=this.readArray();
					break ;
				case 5:
					value=this.readDouble();
					break ;
				case 12:
					value=this.readByteArray();
					break ;
				default :
					console.log("Unknown object type tag!!!"+type);
				}
			return value;
		}

		__proto.readByteArray=function(){
			var ref=this.readUInt29();
			if ((ref & 1)==0){
				return this.getObjRef(ref >> 1);
			}
			else{
				var len=(ref >> 1);
				var ba=new ByteArray();
				this._objTable.push(ba);
				this.readBytes(ba,0,len);
				return ba;
			}
		}

		__proto.readInterger=function(){
			var i=this.readUInt29();
			i=(i << 3)>> 3;
			return int(i);
		}

		__proto.getStrRef=function(ref){
			return this._strTable[ref];
		}

		__proto.getObjRef=function(ref){
			return this._objTable[ref];
		}

		__proto.__readString=function(){
			var ref=this.readUInt29();
			if ((ref & 1)==0){
				return this.getStrRef(ref >> 1);
			};
			var len=(ref >> 1);
			if (0==len){
				return "";
			};
			var str=this.readUTFBytes(len);
			this._strTable.push(str);
			return str;
		}

		__proto.readTraits=function(ref){
			var ti;
			if ((ref & 3)==1){
				ti=this.getTraitReference(ref >> 2);
				return ti.propoties?ti:{obj:{}};
			}
			else{
				var externalizable=((ref & 4)==4);
				var isDynamic=((ref & 8)==8);
				var count=(ref >> 4);
				var className=this.__readString();
				ti={};
				ti.className=className;
				ti.propoties=[];
				ti.dynamic=isDynamic;
				ti.externalizable=externalizable;
				if(count>0){
					for(var i=0;i<count;i++){
						var propName=this.__readString();
						ti.propoties.push(propName);
					}
				}
				this._traitsTable.push(ti);
				return ti;
			}
		}

		__proto.readScriptObject=function(){
			var ref=this.readUInt29();
			if ((ref & 1)==0){
				return this.getObjRef(ref >> 1);
			}
			else{
				var objref=this.readTraits(ref);
				var className=objref.className;
				var externalizable=objref.externalizable;
				var obj;
				var propName;
				var pros=objref.propoties;
				if(className&&className!=""){
					var rst=iflash.net.getClassByAlias(className);
					if(rst){
						obj=new rst();
						}else{
						obj={};
					}
					}else{
					obj={};
				}
				this._objTable.push(obj);
				if(pros){
					for(var d=0;d<pros.length;d++){
						obj[pros[d]]=this.readObject2();
					}
				}
				if(objref.dynamic){
					for (;;){
						propName=this.__readString();
						if (propName==null || propName.length==0)break ;
						obj[propName]=this.readObject2();
					}
				}
				return obj;
			}
		}

		__proto.readArray=function(){
			var ref=this.readUInt29();
			if ((ref & 1)==0){
				return this.getObjRef(ref >> 1);
			};
			var obj=null;
			var count=(ref >> 1);
			var propName;
			for (;;){
				propName=this.__readString();
				if (propName==null || propName.length==0)break ;
				if (obj==null){
					obj={};
					this._objTable.push(obj);
				}
				obj[propName]=this.readObject2();
			}
			if (obj==null){
				obj=[];
				this._objTable.push(obj);
				var i=0;
				for (i=0;i < count;i++){
					obj.push(this.readObject2());
				}
				}else {
				for (i=0;i < count;i++){
					obj[i.toString()]=this.readObject2();
				}
			}
			return obj;
		}

		__proto.readUInt29=function(){
			var value=0;
			var b=this.readByte()& 0xFF;
			if (b < 128){
				return b;
			}
			value=(b & 0x7F)<< 7;
			b=this.readByte()& 0xFF;
			if (b < 128){
				return (value | b);
			}
			value=(value | (b & 0x7F))<< 7;
			b=this.readByte()& 0xFF;
			if (b < 128){
				return (value | b);
			}
			value=(value | (b & 0x7F))<< 8;
			b=this.readByte()& 0xFF;
			return (value | b);
		}

		__proto.writeObject=function(o){
			this._strTable=[];
			this._objTable=[];
			this._traitsTable=[];
			this.writeObject2(o);
		}

		__proto.writeObject2=function(o){
			if(o==null){
				this.writeAMFNull();
				return;
			};
			var type=typeof(o);
			if("string"==type){
				this.writeAMFString(o);
			}
			else if("boolean"==type){
				this.writeAMFBoolean(o);
			}
			else if("number"==type){
				if(String(o).indexOf(".")!=-1){
					this.writeAMFDouble(o);
				}
				else{
					this.writeAMFInt(o);
				}
			}
			else if("object"==type){
				if((o instanceof Array)){
					this.writeArray(o);
				}
				else if((o instanceof iflash.utils.ByteArray )){
					this.writeAMFByteArray(o);
				}
				else{
					this.writeCustomObject(o);
				}
			}
		}

		__proto.writeAMFNull=function(){
			this.writeByte(1);
		}

		__proto.writeAMFString=function(s){
			this.writeByte(6);
			this.writeStringWithoutType(s);
		}

		__proto.writeStringWithoutType=function(s){
			if (s.length==0){
				this.writeUInt29(1);
				return;
			};
			var ref=this._strTable.indexOf(s);
			if(ref>=0){
				this.writeUInt29(ref << 1);
				}else{
				var utflen=this._getUTFBytesCount(s);
				this.writeUInt29((utflen << 1)| 1);
				this.writeUTFBytes(s);
				this._strTable.push(s);
			}
		}

		__proto.writeAMFInt=function(i){
			if (i >=ByteArray.INT28_MIN_VALUE && i <=0x0FFFFFFF){
				i=i & 0x1FFFFFFF;
				this.writeByte(4);
				this.writeUInt29(i);
				}else {
				this.writeAMFDouble(i);
			}
		}

		__proto.writeAMFDouble=function(d){
			this.writeByte(5);
			this.writeDouble(d);
		}

		__proto.writeAMFBoolean=function(b){
			if (b)
				this.writeByte(3);
			else
			this.writeByte(2);
		}

		__proto.writeCustomObject=function(o){
			this.writeByte(10);
			var refNum=this._objTable.indexOf(o);
			if(refNum!=-1){
				this.writeUInt29(refNum << 1);
			}
			else{
				this._objTable.push(o);
				var traitsInfo=new Object();
				traitsInfo.className=this.getAliasByObj(o);
				traitsInfo.dynamic=false;
				traitsInfo.externalizable=false;
				traitsInfo.properties=[];
				for(var prop in o){
					if((typeof (o[prop])=='function'))continue ;
					traitsInfo.properties.push(prop);
					traitsInfo.properties.sort();
				};
				var tRef=ByteArray.getTraitsInfoRef(this._traitsTable,traitsInfo);
				var count=traitsInfo.properties.length;
				var i=0;
				if(tRef>=0){
					this.writeUInt29((tRef << 2)| 1);
					}else{
					this._traitsTable.push(traitsInfo);
					this.writeUInt29(3 | (traitsInfo.externalizable ? 4 :0)| (traitsInfo.dynamic ? 8 :0)| (count << 4));
					this.writeStringWithoutType(traitsInfo.className);
					for(i=0;i<count;i++){
						this.writeStringWithoutType(traitsInfo.properties[i]);
					}
				}
				for(i=0;i<count;i++){
					this.writeObject2(o[traitsInfo.properties[i]]);
				}
			}
		}

		__proto.getAliasByObj=function(obj){
			var tClassName=iflash.utils.getQualifiedClassName(obj);
			if(tClassName==null || tClassName=="")return "";
			var tClass=iflash.utils.getDefinitionByName(tClassName);
			if(tClass==null)return "";
			var tkey;
			for(tkey in iflash.net.classDic){
				if(iflash.net.classDic[tkey]==tClass){
					return tkey;
				}
			}
			return "";
		}

		__proto.writeArray=function(value){
			this.writeByte(9);
			var len=value.length;
			var ref=this._objTable.indexOf(value);
			if(ref>-1){
				this.writeUInt29(len<<1);
			}
			else{
				this.writeUInt29((len << 1)| 1);
				this.writeStringWithoutType("");
				for (var i=0;i < len;i++){
					this.writeObject2(value[i]);
				}
				this._objTable.push(value);
			}
		}

		__proto.writeAMFByteArray=function(ba){
			this.writeByte(12);
			var ref=this._objTable.indexOf(ba);
			if(ref>=0){
				this.writeUInt29(ref << 1);
				}else{
				var len=ba.length;
				this.writeUInt29((len << 1)| 1);
				this.writeBytes(ba,0,len);
			}
		}

		__proto.writeMapAsECMAArray=function(o){
			this.writeByte(9);
			this.writeUInt29((0 << 1)| 1);
			var count=0,key;
			for (key in o){
				count++;
				this.writeStringWithoutType(key);
				this.writeObject2(o[key]);
			}
			this.writeStringWithoutType("");
		}

		__proto.writeUInt29=function(ref){
			if (ref < 0x80){
				this.writeByte(ref);
				}else if (ref < 0x4000){
				this.writeByte(((ref >> 7)& 0x7F)| 0x80);
				this.writeByte(ref & 0x7F);
				}else if (ref < 0x200000){
				this.writeByte(((ref >> 14)& 0x7F)| 0x80);
				this.writeByte(((ref >> 7)& 0x7F)| 0x80);
				this.writeByte(ref & 0x7F);
				}else if (ref < 0x40000000){
				this.writeByte(((ref >> 22)& 0x7F)| 0x80);
				this.writeByte(((ref >> 15)& 0x7F)| 0x80);
				this.writeByte(((ref >> 8)& 0x7F)| 0x80);
				this.writeByte(ref & 0xFF);
				}else {
				console.log("Integer out of range: "+ref);
			}
		}

		__proto.getTraitReference=function(ref){
			return this._traitsTable[ref];
		}

		__getset(0,__proto,'bytesAvailable',function(){
			return this.length-this._position_;
		});

		__getset(0,__proto,'length',function(){
			return this._length;
			},function(value){
			if (this._allocated_ < value)
				this.___resizeBuffer (this._allocated_=Math.floor (Math.max (value,this._allocated_ *2)));
			else if (this._allocated_ > value)
			this.___resizeBuffer (this._allocated_=value);
			this._length=value;
		});

		__getset(0,__proto,'endian',function(){
			return this._littleEndian_ ? "littleEndian" :"bigEndian";
			},function(endianStr){
			this._littleEndian_=(endianStr=="littleEndian");
		});

		__getset(0,__proto,'position',function(){
			return this._position_;
			},function(pos){
			if (pos < this._length)
				this._position_=pos < 0?0:pos;
			else{
				this._position_=pos;
				this.length=pos;
			}
		});

		ByteArray.__ofBuffer=function(buffer){
			var bytes=/*__JS__ */new ByteArray ();
			bytes.length=bytes.allocated=buffer.byteLength;
			bytes.data=/*__JS__ */new DataView(buffer);
			bytes.byteView=/*__JS__ */new Uint8Array(buffer);
			return bytes;
		}

		ByteArray.getTraitsInfoRef=function(arr,ti){
			var i=0,len=arr.length;
			for(i=0;i<len;i++){
				if (ByteArray.equalsTraitsInfo(ti,arr[i]))return i;
			}
			return-1;
		}

		ByteArray.equalsTraitsInfo=function(ti1,ti2){
			if (ti1==ti2){
				return true;
			}
			if (!ti1.className===ti2.className){
				return false;
			}
			if(ti1.properties.length !=ti2.properties.length){
				return false;
			};
			var len=ti1.properties.length;
			var prop;
			ti1.properties.sort();ti2.properties.sort();
			for(var i=0;i<len;i++){
				if(ti1.properties[i] !=ti2.properties[i]){
					return false;
				}
			}
			return true;
		}

		ByteArray.BIG_ENDIAN="bigEndian";
		ByteArray.LITTLE_ENDIAN="littleEndian";
		ByteArray.UNDEFINED_TYPE=0;
		ByteArray.NULL_TYPE=1;
		ByteArray.FALSE_TYPE=2;
		ByteArray.TRUE_TYPE=3;
		ByteArray.INTEGER_TYPE=4;
		ByteArray.DOUBLE_TYPE=5;
		ByteArray.STRING_TYPE=6;
		ByteArray.XML_TYPE=7;
		ByteArray.DATE_TYPE=8;
		ByteArray.ARRAY_TYPE=9;
		ByteArray.OBJECT_TYPE=10;
		ByteArray.AVMPLUSXML_TYPE=11;
		ByteArray.BYTEARRAY_TYPE=12;
		ByteArray.EMPTY_STRING="";
		ByteArray.UINT29_MASK=0x1FFFFFFF;
		ByteArray.INT28_MAX_VALUE=0x0FFFFFFF;
		ByteArray.INT28_MIN_VALUE=-268435456;
		return ByteArray;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/int.jas
	//class int
	var int=(function(){
		function int(value){
			this.pattern=/^.?[0-9]*(\.|E)?[0-9]*$/;
			(value===void 0)&& (value=0);
			if(value==true)return 1;
			if(!this.pattern.test(value))
			{return 0}
			return !value?0:int.safe_int(Laya.__parseInt(value));
		}

		__class(int,'int',false);
		var __proto=int.prototype;
		__proto.toString=function(radix){
			(radix===void 0)&& (radix=10);
			return Number(this).toString(radix);
		}

		__proto.valueOf=function(){
			return this;
		}

		__proto.toExponential=function(p){
			(p===void 0)&& (p=0);
			return Number(this).toExponential(p);
		}

		__proto.toPrecision=function(p){
			(p===void 0)&& (p=0);
			return Number(this).toPrecision(p);
		}

		__proto.toFixed=function(p){
			(p===void 0)&& (p=0);
			return Number(this).toFixed(p);
		}

		int.safe_int=function(x){
			var lsw=(x & 0xFFFF);
			var msw=(x >> 16)+(lsw >> 16);
			return (msw << 16)| (lsw & 0xFFFF);
		}

		int.MIN_VALUE=-2147483648;
		int.MAX_VALUE=2147483647;
		int.length=1;
		return int;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/eventdispatcher.as
	//class iflash.events.EventDispatcher
	var EventDispatcher=(function(){
		function EventDispatcher(target){
			this._eventListener_=null;
			this._type_=0;
			this.hidden=2;
			this._repaint_=0;
			this._modle_=null;
			this._private_={};
			this._id_=(++EventDispatcher.__LASTID__);
			this._deepIndex=0;
		}

		__class(EventDispatcher,'iflash.events.EventDispatcher',true);
		var __proto=EventDispatcher.prototype;
		Laya.imps(__proto,{"iflash.events.IEventDispatcher":true,"iflash.laya.system.IObject":true})
		__proto.checkType=function(type){
			return (this._type_ & type)!=0;
		}

		__proto.addType=function(type){
			this._type_|=type;
		}

		__proto.removeType=function(type){
			this._type_&=(~type);
		}

		__proto.lyAddEventListener=function(type,listener,useCapture,priority,useWeakReference){
			(useCapture===void 0)&& (useCapture=false);
			(priority===void 0)&& (priority=0);
			(useWeakReference===void 0)&& (useWeakReference=false);
			if (listener==null){
				return null;
			}
			if (type==/*iflash.events.Event.ADDED*/"added")
				EventDispatcher._useCountADDED++;
			if (this !=Laya.window && type==/*iflash.events.Event.ENTER_FRAME*/"enterFrame"){
				var l=Laya.window.lyAddEventListener(type,listener,useCapture,priority,useWeakReference);
				l._target_=this;
				return l;
			}
			listener=Method.jsToEventFun(listener);
			if (this._eventListener_==null)
				this._eventListener_=[];
			var thisType=this._eventListener_[type];
			if (!thisType)
				thisType=this._eventListener_[type]=[];
			else{
				if (thisType.length > 0){
					for (var i=0,sz=thisType.length;i < sz;i++){
						if (thisType[i] && thisType[i].listener==listener)
							return thisType[i];
					}
				}
			};
			var e=EventListener.__create__(listener,useCapture,priority,useWeakReference,this);
			thisType.push(e);
			return e;
		}

		__proto.addEventListener=function(type,listener,useCapture,priority,useWeakReference){
			(useCapture===void 0)&& (useCapture=false);
			(priority===void 0)&& (priority=0);
			(useWeakReference===void 0)&& (useWeakReference=false);
			this.lyAddEventListener(type,listener,useCapture,priority,useWeakReference);
		}

		__proto.dispatchEvent=function(event){
			if (event.bubbles){
				event._lytarget=this;
				var target=this;
				var ret=false;
				while (target){
					if (target.lyDispatchEvent(event)){
						ret=true;
					}
					target=target.parent;
				}
				return ret;
			}
			else{
				return this.lyDispatchEvent2(event);
			}
		}

		__proto.addOneEventListener=function(type,listener){
			if (this._eventListener_==null)
				this._eventListener_=[];
			var thisType=this._eventListener_[type];
			if (!thisType)
				thisType=this._eventListener_[type]=[];
			thisType.push(listener);
		}

		__proto.lyDispatchEvent=function(event){
			if (this._eventListener_==null)
				return false;
			var thisType;
			if ((typeof event=='string')){
				thisType=this._eventListener_[ event];
				if (!thisType)
					return false;
				event=new Event(event);
			}
			else{
				thisType=this._eventListener_[event.type];
				if (!thisType)
					return false;
			}
			(thisType[-1]==null)&& (thisType[-1]=0);
			thisType[-1]++;
			var sz=thisType.length+0,bremove=false;
			event._lytarget=event._lytarget ? event._lytarget :this;
			event._currentTarget_=this;
			var tmepType=thisType.concat();
			for (var i=0;i < sz;i++){
				if (!tmepType[i] || tmepType[i].run(this,event)==false)
					bremove=true;
			}
			if (bremove && thisType[-1]==1){
				var tsz=0;
				for (i=0,sz=thisType.length;i < sz;i++){
					var oe=thisType[i];
					if (oe==null || oe._deleted_)
						continue ;
					thisType[tsz]=thisType[i];
					tsz++;
				}
				thisType.length=tsz;
				if (thisType.length==0)
					this._eventListener_[event.type]=null;
			}
			thisType[-1]--;
			return true;
		}

		__proto.lyDispatchEvent2=function(event){
			if (this._eventListener_==null)
				return false;
			var thisType;
			if ((typeof event=='string')){
				thisType=this._eventListener_[ event];
				if (!thisType)
					return false;
				event=new Event(event);
			}
			else{
				thisType=this._eventListener_[event.type];
				if (!thisType)
					return false;
			}
			(thisType[-1]==null)&& (thisType[-1]=0);
			thisType[-1]++;
			var sz=thisType.length+0,bremove=false;
			event._lytarget=this;
			event._currentTarget_=this;
			var tmepType=thisType.concat();
			for (var i=0;i < sz;i++){
				if (event._type_==8){
					event._type_=0;
					break ;
				}
				else{
					if (!tmepType[i] || tmepType[i].run(this,event)==false)
						bremove=true;
				}
			}
			if (bremove && thisType[-1]==1){
				var tsz=0;
				for (i=0,sz=thisType.length;i < sz;i++){
					var oe=thisType[i];
					if (oe==null || oe._deleted_)
						continue ;
					thisType[tsz]=thisType[i];
					tsz++;
				}
				thisType.length=tsz;
				if (thisType.length==0)
					this._eventListener_[event.type]=null;
			}
			thisType[-1]--;
			return true;
		}

		__proto.hasEventListener=function(type){
			var b=this._eventListener_ && this._eventListener_[type] !=null && this._eventListener_[type].length > 0;
			if(b){
				var arr=this._eventListener_[type];
				var len=arr.length;
				for(var i=0;i<len;i++){
					b=arr[i] !=null;
					if(b){
						break ;
					}
				}
				if(!b)arr.length=0;
			}
			return b;
		}

		__proto.removeEventListener=function(type,listener,useCapture){
			(useCapture===void 0)&& (useCapture=false);
			var thisType;
			if (type==/*iflash.events.Event.ENTER_FRAME*/"enterFrame" && this !=Laya.window){
				Laya.window.removeEventListener(type,listener,useCapture);
				return;
			}
			if (!this._eventListener_)
				return;
			thisType=this._eventListener_[type];
			if (thisType){
				var len=thisType.length-1
				for (var i=len;i >-1;i--){
					var oe=thisType[i];
					if (oe && (oe.listener==listener)){
						oe.destroy();
						thisType.splice(i,1);
					}
				}
			}
			else{
				if (type==/*iflash.events.Event.ADDED*/"added")
					EventDispatcher._useCountADDED--;
			}
		}

		__proto.willTrigger=function(type){
			return false;
		}

		__proto.evalEvent=function(event){
			var listeners=this._eventListener_ ? this._eventListener_[event.type] :null;
			var numListeners=listeners==null ? 0 :listeners.length;
			if (numListeners){
				var tmp=listeners.concat();
				for (var i=0;i < numListeners;++i){
					var listener=tmp[i];
					if (!listener)
						continue ;
					event._currentTarget_=this;
					listener.run(this,event);
					if (event.stopsImmediatePropagation)
						return true;
				}
				return event.stopsPropagation;
			}
			else{
				return false;
			}
		}

		__proto._removeEvents_=function(){
			this._eventListener_=null;
		}

		__getset(0,__proto,'deleted',function(){
			return (this._type_ & 0x1)!=0;
			},function(b){
			if ((this._type_ & 0x1)==0){
				this._type_|=0x1;
				this._eventListener_=null;
			}
		});

		__getset(1,EventDispatcher,'_isOpenTypeAdded',function(){
			return EventDispatcher._useCountADDED !=0;
		});

		EventDispatcher._useCountADDED=0;
		EventDispatcher.TYPE_DELETED=0x1;
		EventDispatcher.document=null
		EventDispatcher.window=null
		EventDispatcher.__NULLARRAY__=[];
		EventDispatcher.__LASTID__=0;
		return EventDispatcher;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/event.as
	//class iflash.events.Event
	var Event=(function(){
		function Event(type,bubbles,cancelable,_d){
			this.type=null;
			this._lytarget=null;
			this._currentTarget_=null;
			this._type_=0;
			this._lyData=null;
			(bubbles===void 0)&& (bubbles=false);
			(cancelable===void 0)&& (cancelable=false);
			this._type_=0;
			this.bubbles=bubbles;
			this.type=type;
			this.cancelable=cancelable;
			!this._lyData && (this._lyData=_d);
		}

		__class(Event,'iflash.events.Event',false);
		var __proto=Event.prototype;
		__proto._lysetTarget=function(obj){
			this._lytarget=obj;
		}

		__proto.clone=function(){
			return new Event(this.type,this.bubbles,this.cancelable,this._lyData);
		}

		__proto.stopPropagation=function(){
			this.stopsPropagation=this.returnValue=true;
		}

		__proto.stopImmediatePropagation=function(){
			this.stopsImmediatePropagation=true;
		}

		__proto.formatToString=function(className,__rest){
			var rest=[];for(var i=1,sz=arguments.length;i<sz;i++)rest.push(arguments[i]);
			return null;
		}

		__proto.isDefaultPrevented=function(){
			return false;
		}

		__proto.preventDefault=function(){}
		__proto.toString=function(){
			return "event:"+this._type_;
		}

		__proto.destory=function(){
			this._lytarget=null;
			this._currentTarget_=null;
		}

		__proto.toMouseEvent=function(){
			if (Event.__helpMouseEvt__==null){
				Event.__helpMouseEvt__=new MouseEvent("");
			}
			return Event.__helpMouseEvt__;
		}

		__proto.dispatch=function(chain){
			if (chain && chain.length){
				this.resetStops();
				var chainLength=this.bubbles ? chain.length :1;
				var endIndex=chain.length-1;
				var chainElement=chain [endIndex];
				var i=0;
				this._lysetTarget(chainElement);
				this.dispatchTargetsEvt(this.toMouseEvent(),chain,chainLength,endIndex);
				if ((this instanceof iflash.events.TouchEvent )){
					if(Multitouch.inputMode !=/*iflash.ui.MultitouchInputMode.GESTURE*/"gesture"){
						this.dispatchTargetsEvt(this,chain,chainLength,endIndex);
					}
					else{
						var gestureEvt=TouchInfo.dealGestrueHandler(this);
						if(gestureEvt){
							this.dispatchTargetsEvt(gestureEvt,chain,chainLength,endIndex);
						}
					}
				}
			}
		}

		__proto.dispatchTargetsEvt=function(evt,chain,chainLength,endIndex){
			for (var i=0;i < chainLength;i++){
				if (evt.stopsImmediatePropagation)
					break ;
				chain[endIndex-i].evalEvent(evt);
				if (evt.stopsPropagation)
					break ;
			}
		}

		__proto.resetStops=function(){
			this.stopsImmediatePropagation=false;
			this.stopsPropagation=false;
		}

		__proto.checkType=function(type){
			return (this._type_ & type)!=0;
		}

		__proto.addType=function(type){
			this._type_|=type;
		}

		__proto.removeType=function(type){
			(this._type_&=~type);
		}

		__getset(0,__proto,'eventPhase',function(){
			return 0;
		});

		__getset(0,__proto,'stopsPropagation',function(){
			return (this._type_ & 0x10)!=0;
			},function(value){
			if (value)
				this._type_|=0x10;
			else
			this._type_&=~0x10;
		});

		__getset(0,__proto,'returnValue',function(){
			return this.checkType(0x4);
			},function(b){
			if (b)
				this.addType(0x4);
			else
			this.removeType(0x4);
		});

		__getset(0,__proto,'stopsImmediatePropagation',function(){
			return (this._type_ & 0x8)!=0;
			},function(value){
			if (value)
				this._type_|=0x8;
			else
			this._type_&=~0x8;
		});

		__getset(0,__proto,'currentTarget',function(){
			return this._currentTarget_;
		});

		__getset(0,__proto,'target',function(){
			return this._lytarget;
		});

		__getset(0,__proto,'bubbles',function(){
			return this.checkType(0x1);
			},function(b){
			if (b)
				this.addType(0x1);
			else
			this.removeType(0x1);
		});

		__getset(0,__proto,'cancelable',function(){
			return this.checkType(0x2);
			},function(b){
			if (b)
				this.addType(0x2);
			else
			this.removeType(0x2);
		});

		__getset(0,__proto,'lyData',function(){
			return this._lyData;
			},function(value){
			this._lyData=value;
		});

		Event.copyFromByObj=function(dstO,srcO,namesO){
			if (!namesO)
				return;
			var tKey;
			for (tKey in namesO){
				dstO[tKey]=srcO[namesO[tKey]];
			}
		}

		Event.ACTIVATE="activate";
		Event.ADDED="added";
		Event.ADDED_TO_STAGE="addedToStage";
		Event.CANCEL="cancel";
		Event.CHANGE="change";
		Event.DESTROY="destroy";
		Event.CLEAR="clear";
		Event.CLOSE="close";
		Event.COMPLETE="complete";
		Event.CONNECT="connect";
		Event.CONTEXT3D_CREATE="context3DCreate";
		Event.COPY="copy";
		Event.CUT="cut";
		Event.DEACTIVATE="deactivate";
		Event.ENTER_FRAME="enterFrame";
		Event.EXIT_FRAME="exitFrame";
		Event.FRAME_CONSTRUCTED="frameConstructed";
		Event.FULLSCREEN="fullScreen";
		Event.ID3="id3";
		Event.INIT="init";
		Event.MOUSE_LEAVE="mouseLeave";
		Event.OPEN="open";
		Event.LOADED="loaded";
		Event.PASTE="paste";
		Event.ONRESHOW="onreshow";
		Event.REMOVED="removed";
		Event.REMOVED_FROM_STAGE="removedFromStage";
		Event.RENDER="render";
		Event.RESIZE="resize";
		Event.REPOS="repos";
		Event.SCROLL="scroll";
		Event.SCROLLSIZE="scrollsize";
		Event.SELECT="select";
		Event.SELECT_ALL="selectAll";
		Event.SOUND_COMPLETE="soundComplete";
		Event.TAB_CHILDREN_CHANGE="tabChildrenChange";
		Event.TAB_ENABLED_CHANGE="tabEnabledChange";
		Event.TAB_INDEX_CHANGE="tabIndexChange";
		Event.TEXT_INTERACTION_MODE_CHANGE="textInteractionModeChange";
		Event.UNLOAD="unload";
		Event.ONPARENT="onparent";
		Event.TODOCUMENT="todocument";
		Event.ERROR="error";
		Event.MESSAGE="message";
		Event.TYPE_BUBBLES=0x1;
		Event.TYPE_CANCELABLE=0x2;
		Event.TYPE_RETURNVALUE=0x4;
		Event.TYPE_STOPSIMMEDIATEPROPAGATION=0x8;
		Event.TYPE_STOPSPROPAGATION=0x10;
		Event.__helpMouseEvt__=null
		__static(Event,
		['INPUT_EVENT_TYPE_MAP',function(){return this.INPUT_EVENT_TYPE_MAP={"mousedown":"touchstart","mouseup":"touchend","mousemove":"touchmove"};}
		]);
		return Event;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/eventlistener.as
	//class iflash.events.EventListener
	var EventListener=(function(){
		function EventListener(listener,useCapture,priority,useWeakReference,ower){
			this.listener=null;
			this.useCapture=false;
			this.priority=0;
			this.useWeakReference=false;
			this._ower_=null;
			this._deleted_=false;
			this.data=null;
			this._target_=null;
			this.reset(listener,useCapture,priority,useWeakReference ,ower);
		}

		__class(EventListener,'iflash.events.EventListener',true);
		var __proto=EventListener.prototype;
		__proto.setOwer=function(o){
			this._ower_=o;
		}

		__proto.run=function(o,event){
			if ((this._ower_ && this._ower_.deleted)|| this.listener==null){
				this.destroy();
				return false;
			};
			var isfalse=true;
			if (this._target_){
				event._lytarget=this._target_;
				event._currentTarget_=this._target_;
				isfalse=this.callListener(event);
				event._lytarget=o;
			}
			else{
				isfalse=this.callListener(event);
			}
			if(isfalse)this.destroy();
			return !isfalse;
		}

		__proto.callListener=function(event){
			var isfalse=true;
			isfalse=this.listener.call(this._ower_,event)==false;
			return isfalse;
		}

		__proto.reset=function(listener,useCapture,priority,useWeakReference,ower){
			this.listener=listener;
			this.useCapture=useCapture;
			this.priority=priority;
			this.useWeakReference=useWeakReference;
			this._ower_=ower;
			this._deleted_=false;
			this.data=null;
		}

		__proto.destroy=function(){
			if (!this._deleted_){
				this._ower_=null;
				this.listener=null;
				this._target_=null;
				this._deleted_=true;
				this.data=null;
			}
		}

		EventListener.__create__=function(listener,useCapture,priority,useWeakReference,ower){
			return new EventListener(listener,useCapture,priority,useWeakReference ,ower);
		}

		return EventListener;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/eventmanager.as
	//class iflash.events.EventManager
	var EventManager=(function(){
		function EventManager(){
			this._curid_=0;
			this._mouseOverNodes_=[];
			this._currentSysEvent=null;
			this._keyEvents_=[];
			this._delayTime_=100;
			this.DT_RD=50;
			this._chainTop=null;
			this._clientX=0;
			this._clientY=0;
			this._mouseDownTarget=null;
			this._curChainTop=null;
			this.enableTouch=false;
			this._isMoveUpdated=false;
			this.dealAccepInput=this.dealAcceptSysMouseInput;
			this._bubbleChain=[];
		}

		__class(EventManager,'iflash.events.EventManager',true);
		var __proto=EventManager.prototype;
		__proto.acceptSystemKeyEvent=function(event){
			this._keyEvents_.push(event);
		}

		__proto._dispatchKeyEvent_=function(event){
			switch(event.type){
				case /*iflash.events.KeyboardEvent.KEY_DOWN*/"keyDown":
					Laya.document.onkeydown && Laya.document.onkeydown(event);
					break ;
				case /*iflash.events.KeyboardEvent.KEY_UP*/"keyUp":
					Laya.document.onkeyup&&Laya.document.onkeyup(event);
				}
			event.currentTarget && event.currentTarget.lyDispatchEvent(event);
			event._currentTarget_=Laya.document.activeElement;
			Laya.document.lyDispatchEvent(event);
		}

		__proto.dispatchSystemEvent=function(delay){
			(delay===void 0)&& (delay=0);
			var i=0;
			if(this._currentSysEvent){
				this.dealAccepInput();
			}
			if(!this._keyEvents_.length)return;
			var ks=this._keyEvents_,sz=ks.length;this._keyEvents_=[];
			for (i=0;i < sz;i++){
				var keyevent=new iflash.events.KeyboardEvent(ks[i].type);
				keyevent.changeEvent(ks[i])
				EventManager.stage.lyDispatchEvent(keyevent);
			}
		}

		__proto.dealAcceptSysMouseInput=function(){
			EventManager.clientToStage(this._currentSysEvent.clientX,this._currentSysEvent.clientY);
			if(this._currentSysEvent.type !="mousemove")return;
			EventManager._mouseEvent=MouseEvent.copyFromSysEvent(this._currentSysEvent);
			if(EventManager._mouseEvent.button!=0)return;
			this._curChainTop=EventManager.stage._hitTest_(EventManager._stageX,EventManager._stageY);
			var curBubbleChain=[];
			if(this._chainTop !=this._curChainTop){
				curBubbleChain=this.getTargetBubbleChain(this._curChainTop);
				var common=-1;
				var len=curBubbleChain.length;
				for(var i=0;i<len;i++){
					if(this._bubbleChain.length <=i || curBubbleChain[i] !=this._bubbleChain[i])break ;
					common=i;
				};
				var mouseOutEvt=EventManager._mouseEvent;
				mouseOutEvt.type=/*iflash.events.MouseEvent.MOUSE_OUT*/"mouseOut";
				mouseOutEvt.bubbles=true;
				mouseOutEvt.relatedObject=this._curChainTop;
				mouseOutEvt.dispatch(this._bubbleChain);
				var tempChain=[];
				for(i=this._bubbleChain.length-1;i>common;i--){
					var rolloutEvt=EventManager._mouseEvent;
					rolloutEvt.type=/*iflash.events.MouseEvent.ROLL_OUT*/"rollOut";
					rolloutEvt.bubbles=false;
					rolloutEvt.relatedObject=this._curChainTop;
					tempChain.length=0;
					tempChain.push(this._bubbleChain[i]);
					rolloutEvt.dispatch(tempChain);
				}
				for(i=curBubbleChain.length-1;i>common;i--){
					var rolloverEvt=EventManager._mouseEvent;
					rolloverEvt.type=/*iflash.events.MouseEvent.ROLL_OVER*/"rollOver";
					rolloverEvt.bubbles=false;
					rolloverEvt.relatedObject=this._chainTop;
					tempChain.length=0;
					tempChain.push(curBubbleChain[i]);
					rolloverEvt.dispatch(tempChain);
				};
				var mouseoverEvt=EventManager._mouseEvent;
				mouseoverEvt.type=/*iflash.events.MouseEvent.MOUSE_OVER*/"mouseOver";
				mouseoverEvt.bubbles=true;
				mouseoverEvt.relatedObject=this._chainTop;
				mouseoverEvt.dispatch(curBubbleChain);
				this._chainTop=this._curChainTop;
				this._bubbleChain=curBubbleChain;
			}
			if(EventManager._stageX !=this._clientX || EventManager._stageY!=this._clientY){
				this._clientX=EventManager._stageX;this._clientY=EventManager._stageY;
				var mousemoveEvt=EventManager._mouseEvent;
				mousemoveEvt.bubbles=true;
				mousemoveEvt.relatedObject=this._chainTop;
				mousemoveEvt.type=/*iflash.events.MouseEvent.MOUSE_MOVE*/"mouseMove";
				if(this._bubbleChain){
					mousemoveEvt.dispatch(this._bubbleChain);
				}
			}
			if(EventManager._mouseEvent)EventManager._mouseEvent.destory();
			this._currentSysEvent=null;
		}

		__proto.dealAcceptTouchInput=function(){
			if(this._currentSysEvent.touches.length !=0){
				if(this._currentSysEvent.type !="touchmove" || !this._isMoveUpdated)return;
				this._isMoveUpdated=false;
				TouchEvent.touchSysEvent(this._currentSysEvent,__bind(this,this.touchMoveInterval));
			}
			else{
				this._currentSysEvent=null;
			}
		}

		__proto.touchMoveInterval=function(event){
			var touchInfo=TouchInfo.getTouchInfo(event);
			touchInfo.curChainTop=EventManager.stage._hitTest_(event.stageX,event.stageY);
			if(touchInfo.chainTop !=touchInfo.curChainTop){
				var curBubbleChain=this.getTargetBubbleChain(touchInfo.curChainTop);
				var common=-1;
				var len=curBubbleChain.length;
				for(var i=0;i<len;i++){
					if(touchInfo.bubbleChain.length <=i || curBubbleChain[i] !=touchInfo.bubbleChain[i])break ;
					common=i;
				}
				event.type=/*iflash.events.TouchEvent.TOUCH_OUT*/"touchOut";
				event.bubbles=true;
				event.relatedObject=touchInfo.curChainTop;
				event.dispatch(touchInfo.bubbleChain);
				var tempChain=[];
				for(i=touchInfo.bubbleChain.length-1;i>common;i--){
					event.type=/*iflash.events.TouchEvent.TOUCH_ROLL_OUT*/"touchRollOut";
					event.bubbles=false;
					event.relatedObject=touchInfo.curChainTop;
					tempChain.length=0;
					tempChain.push(touchInfo.bubbleChain[i]);
					event.dispatch(tempChain);
				}
				for(i=curBubbleChain.length-1;i>common;i--){
					event.type=/*iflash.events.TouchEvent.TOUCH_ROLL_OVER*/"touchRollOver";
					event.bubbles=false;
					event.relatedObject=touchInfo.chainTop;
					tempChain.length=0;
					tempChain.push(curBubbleChain[i]);
					event.dispatch(tempChain);
				}
				event.type=/*iflash.events.TouchEvent.TOUCH_OVER*/"touchOver";
				event.bubbles=true;
				event.relatedObject=touchInfo.chainTop;
				event.dispatch(curBubbleChain);
				touchInfo.chainTop=touchInfo.curChainTop;
				touchInfo.bubbleChain=curBubbleChain;
			}
			if(event.stageX!=touchInfo.stageX || event.stageY !=touchInfo.stageY){
				event.bubbles=true;
				event.type=/*iflash.events.TouchEvent.TOUCH_MOVE*/"touchMove";
				event.relatedObject=touchInfo.chainTop;
				if(touchInfo.bubbleChain){
					event.dispatch(touchInfo.bubbleChain);
				}
				touchInfo.touchMove(event);
			}
			if(event)event.destory();
		}

		__proto.getTargetBubbleChain=function(target){
			var bubbleChain=[];
			var p=target;
			while(p){
				bubbleChain.unshift(p);
				p=p.parent;
			}
			return bubbleChain;
		}

		__proto.dispatchTargetEvent=function(target,event){
			event.dispatch(this.getTargetBubbleChain(target));
		}

		__proto.acceptSystemMouseEvent=function(event){
			this._currentSysEvent=event;
			if(TouchEvent.isTypeMove(this._currentSysEvent.type)){
				this._isMoveUpdated=true;
				return;
			}
			if(!this.enableTouch){
				EventManager._mouseEvent=MouseEvent.copyFromSysEvent(this._currentSysEvent);
				if(EventManager._mouseEvent.button!=0)return;
				this._curChainTop=EventManager.stage._hitTest_(EventManager._stageX,EventManager._stageY);
				this.dispatchTargetEvent(this._curChainTop,EventManager._mouseEvent);
				if(this._currentSysEvent.type=="mousedown"){
					this._mouseDownTarget=this._curChainTop;
				}
				else if(this._currentSysEvent.type=="mouseup"){
					if(this._curChainTop==this._mouseDownTarget){
						EventManager._mouseEvent.bubbles=true;
						EventManager._mouseEvent.type=/*iflash.events.MouseEvent.CLICK*/"click";
						this.dispatchTargetEvent(this._curChainTop,EventManager._mouseEvent);
					}
					this._mouseDownTarget=null;
				}
				if(EventManager._mouseEvent)EventManager._mouseEvent.destory();
			}
			else{
				TouchEvent.touchSysEvent(event,__bind(this,this.touchMomentHandler));
			}
		}

		__proto.touchMomentHandler=function(event){
			var touchInfo=TouchInfo.getTouchInfo(event);
			touchInfo.curChainTop=EventManager.stage._hitTest_(EventManager._stageX,EventManager._stageY);
			touchInfo.stageX=EventManager._stageX;touchInfo.stageY=EventManager._stageY;
			if(event.type==/*iflash.events.TouchEvent.TOUCH_BEGIN*/"touchBegin"){
				touchInfo.touchBegin(event);
				this.dispatchTargetEvent(touchInfo.curChainTop,event);
			}
			else if(event.type==/*iflash.events.TouchEvent.TOUCH_END*/"touchEnd"){
				touchInfo.touchEnd(event);
				this.dispatchTargetEvent(touchInfo.curChainTop,event);
				if(touchInfo.curChainTop==touchInfo.touchDownTarget){
					event.type=/*iflash.events.TouchEvent.TOUCH_TAP*/"touchTap";
					this.dispatchTargetEvent(touchInfo.curChainTop,event);
				}
				touchInfo.destory();
			}
			if(event)event.destory();
		}

		EventManager.clientToStage=function(x,y){
			if(Laya.window.mouseX==x && Laya.window.mouseY==y)return;
			var tempX=x;
			if (Laya.document.adapter.screenRotate !=0){
				x=y;
				y=Laya.window.innerHeight-tempX;
			}
			EventManager._stageX=(x-Laya.document.body._left_)/Laya.window.scale.x;
			EventManager._stageY=(y-Laya.document.body._top_)/Laya.window.scale.y;
			Laya.document.mouseX=EventManager._stageX;
			Laya.document.mouseY=EventManager._stageY;
			Laya.window.mouseX=x;
			Laya.window.mouseY=y;
		}

		EventManager.mgr=new EventManager();
		EventManager.stage=null
		EventManager._stageX=0;
		EventManager._stageY=0;
		EventManager._mouseEvent=null
		__static(EventManager,
		['HELPER_POINT',function(){return this.HELPER_POINT=new Point();}
		]);
		return EventManager;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/eventphase.as
	//class iflash.events.EventPhase
	var EventPhase=(function(){
		function EventPhase(){}
		__class(EventPhase,'iflash.events.EventPhase',true);
		EventPhase.AT_TARGET=2;
		EventPhase.BUBBLING_PHASE=3;
		EventPhase.CAPTURING_PHASE=1;
		return EventPhase;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/gesturephase.as
	//class iflash.events.GesturePhase
	var GesturePhase=(function(){
		function GesturePhase(){}
		__class(GesturePhase,'iflash.events.GesturePhase',true);
		GesturePhase.ALL="all";
		GesturePhase.BEGIN="begin";
		GesturePhase.END="end";
		GesturePhase.UPDATE="update";
		__static(GesturePhase,
		['GESTURE_PHASE_MAP_TOUCH',function(){return this.GESTURE_PHASE_MAP_TOUCH={
				"touchBegin":"begin",
				"touchEnd":"end",
				"touchMove":"update",
				"touchOut":"all",
				"touchOver":"all",
				"touchRollOut":"all",
				"touchRollOver":"all",
				"touchTap":"end"
		};}

		]);
		return GesturePhase;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/throttletype.as
	//class iflash.events.ThrottleType
	var ThrottleType=(function(){
		function ThrottleType(){};
		__class(ThrottleType,'iflash.events.ThrottleType',true);
		ThrottleType.PAUSE="pause";
		ThrottleType.RESUME="resume";
		ThrottleType.THROTTLE="throttle";
		return ThrottleType;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/touch.as
	//class iflash.events.Touch
	var Touch=(function(){
		function Touch(id){
			this._id_=0;
			this._globalX_=NaN;
			this._globalY_=NaN;
			this._previousGlobalX_=NaN;
			this._previousGlobalY_=NaN;
			this._tapCount_=0;
			this._phase_=null;
			this._target_=null;
			this._timestamp_=NaN;
			this._pressure_=NaN;
			this._width_=NaN;
			this._height_=NaN;
			this._bubbleChain_=null;
			this.touchType=null;
			this.nativeEvent=null;
			this._id_=id;
			this._tapCount_=0;
			this._phase_=/*iflash.events.TouchPhase.HOVER*/"hover";
			this._pressure_=this._width_=this._height_=1.0;
			this._bubbleChain_=/*new vector.<>*/[];
		}

		__class(Touch,'iflash.events.Touch',true);
		var __proto=Touch.prototype;
		__proto.getLocation=function(space,resultPoint){
			Touch.SHELPER_POINT.setTo(this._globalX_,this._globalY_);
			space.globalToLocal(Touch.SHELPER_POINT,resultPoint);
			return resultPoint;
		}

		__proto.getPreviousLocation=function(space,resultPoint){
			Touch.SHELPER_POINT.setTo(this._previousGlobalX_,this._previousGlobalY_);
			return space.globalToLocal(Touch.SHELPER_POINT,resultPoint);
		}

		__proto.getMovement=function(space,resultPoint){
			if (resultPoint==null)resultPoint=new Point();
			this.getLocation(space,resultPoint);
			var x=resultPoint.x;
			var y=resultPoint.y;
			this.getPreviousLocation(space,resultPoint);
			resultPoint.setTo(x-resultPoint.x,y-resultPoint.y);
			return resultPoint;
		}

		__proto.isTouching=function(target){
			return this._bubbleChain_.indexOf(target)!=-1;
		}

		__proto.clone=function(){
			var result=new Touch(this._id_);
			result._globalX_=this._globalX_;
			result._globalY_=this._globalY_;
			result._previousGlobalX_=this._previousGlobalX_;
			result._previousGlobalY_=this._previousGlobalY_;
			result._phase_=this._phase_;
			result._tapCount_=this._tapCount_;
			result._timestamp_=this._timestamp_;
			result._pressure_=this._pressure_;
			result._width_=this._width_;
			result._height_=this._height_;
			result.target=this._target_;
			result.touchType=this.touchType;
			result.nativeEvent=this.nativeEvent;
			return result;
		}

		__proto.updateBubbleChain=function(){
			if (this._target_){
				var length=1;
				var element=this._target_;
				this._bubbleChain_.length=1;
				this._bubbleChain_[0]=element;
				while ((element=element.parent)!=null)
				this._bubbleChain_[int(length++)]=element;
			}else this._bubbleChain_.length=0;
		}

		__proto.dispatchEvent=function(event){this._target_&&event.dispatch(this._bubbleChain_);}
		__getset(0,__proto,'id',function(){return this._id_;});
		__getset(0,__proto,'previousGlobalX',function(){return this._previousGlobalX_;});
		__getset(0,__proto,'previousGlobalY',function(){return this._previousGlobalY_;});
		__getset(0,__proto,'globalX',function(){return this._globalX_;},function(value){
			this._previousGlobalX_=this._globalX_ !=this._globalX_ ? value :this._globalX_;
			this._globalX_=value;
		});

		__getset(0,__proto,'globalY',function(){return this._globalY_;},function(value){
			this._previousGlobalY_=this._globalY_ !=this._globalY_ ? value :this._globalY_;
			this._globalY_=value;
		});

		__getset(0,__proto,'target',function(){return this._target_;},function(value){
			if (this._target_ !=value){
				this._target_=value;
				this.updateBubbleChain();
			}
		});

		__getset(0,__proto,'bubbleChain',function(){return this._bubbleChain_.concat();});
		__static(Touch,
		['SHELPER_MATRIX',function(){return this.SHELPER_MATRIX=new Matrix();},'SHELPER_POINT',function(){return this.SHELPER_POINT=new Point();}
		]);
		return Touch;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/toucheventintent.as
	//class iflash.events.TouchEventIntent
	var TouchEventIntent=(function(){
		function TouchEventIntent(){}
		__class(TouchEventIntent,'iflash.events.TouchEventIntent',true);
		TouchEventIntent.ERASER="eraser";
		TouchEventIntent.PEN="pen";
		TouchEventIntent.UNKNOWN="unknown";
		return TouchEventIntent;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/touchinfo.as
	//class iflash.events.TouchInfo
	var TouchInfo=(function(){
		function TouchInfo(evt){
			this.touchPointID=0;
			this.startTimestamp=0;
			this.endTimestamp=0;
			this.chainTop=null;
			this.stageX=0;
			this.stageY=0;
			this.startX=0;
			this.startY=0;
			this.endX=0;
			this.endY=0;
			this.curChainTop=null;
			this.touchDownTarget=null;
			this.touchEvent=null;
			this.bubbleChain=[];
			this.touchEvent=evt;
			this.touchPointID=evt.touchPointID;
		}

		__class(TouchInfo,'iflash.events.TouchInfo',true);
		var __proto=TouchInfo.prototype;
		__proto.touchBegin=function(event){
			this.startTimestamp=event.timestamp;
			this.startX=event.stageX;
			this.startY=event.stageY;
			this.stageX=this.startX;
			this.stageY=this.startY;
			this.endX=this.startX;
			this.endY=this.startY;
			this.touchDownTarget=this.curChainTop;
		}

		__proto.touchEnd=function(event){
			this.endTimestamp=event.timestamp;
			this.endX=event.stageX;
			this.endY=event.stageY;
			this.stageX=this.endX;
			this.stageY=this.endY;
		}

		__proto.touchMove=function(event){
			this.stageX=event.stageX;
			this.stageY=event.stageY;
		}

		__proto.destory=function(){
			for (var i=0;i < TouchInfo.touchs.length;i++){
				if (this.touchPointID==TouchInfo.touchs[i].touchPointID){
					TouchInfo.touchs.splice(i,1);
					break ;
				}
			}
			delete TouchInfo.touchInfos[this.touchPointID];
			this.bubbleChain=null;
			this.chainTop=null;
			this.curChainTop=null;
			this.touchDownTarget=null;
			this.touchEvent=null;
		}

		__getset(0,__proto,'localX',function(){
			return this.curChainTop.mouseX;
		});

		__getset(0,__proto,'localY',function(){
			return this.curChainTop.mouseY;
		});

		TouchInfo.getTouchInfo=function(touchEvent){
			var touchInfo=iflash.events.TouchInfo.touchInfos[touchEvent.touchPointID];
			if (touchInfo==null){
				touchInfo=iflash.events.TouchInfo.touchInfos[touchEvent.touchPointID]=new TouchInfo(touchEvent);
				TouchInfo.touchs.push(touchInfo);
			}
			return touchInfo;
		}

		TouchInfo.dealGestrueHandler=function(touchEvent){
			var tLen=TouchInfo.touchs.length;
			if(tLen==2 && touchEvent.type==/*iflash.events.TouchEvent.TOUCH_BEGIN*/"touchBegin"){
				TouchInfo.twoFingerGapTime=Math.abs(TouchInfo.touchs[1].startTimestamp-TouchInfo.touchs[0].startTimestamp);
				TouchInfo.twoFignerDownTime=TouchInfo.touchs[0].startTimestamp;
				TouchInfo.isTwoFingerDown=true;
				TouchInfo.twoFignerDownCount=1;
			}
			else if(tLen!=2 && touchEvent.type==/*iflash.events.TouchEvent.TOUCH_END*/"touchEnd"){
				TouchInfo.isTwoFingerDown=false;
				TouchInfo.twoFignerDownCount=0;
			}
			if(touchEvent.type==/*iflash.events.TouchEvent.TOUCH_TAP*/"touchTap"){
				if(tLen==2 && TouchInfo.twoFingerGapTime<100){
					var twoFingerTapTime=touchEvent.timestamp-TouchInfo.twoFignerDownTime;
					if(twoFingerTapTime-100<50){
						var ge=GestureEvent.getGestureEvent();
						ge._lytarget=touchEvent.target;
						return ge;
					}
				}
			};
			var twoFingerTapTime2=touchEvent.timestamp-TouchInfo.twoFignerDownTime;
			if(tLen==2 && twoFingerTapTime2>120 && (touchEvent.type==/*iflash.events.TouchEvent.TOUCH_MOVE*/"touchMove" || touchEvent.type==/*iflash.events.TouchEvent.TOUCH_END*/"touchEnd")){
				var transformTouchInfo=TouchInfo.touchInfos[touchEvent.touchPointID];
				var t0=TouchInfo.touchInfos[0];
				var t1=TouchInfo.touchInfos[1];
				var transformTouchEvt=new TransformGestureEvent("",true,false,GesturePhase.GESTURE_PHASE_MAP_TOUCH[touchEvent.type]);
				transformTouchEvt.localX=touchEvent.localX;
				transformTouchEvt.localY=touchEvent.localY;
				transformTouchEvt._lytarget=touchEvent._lytarget;
				transformTouchEvt.shiftKey=touchEvent.shiftKey;
				transformTouchEvt.ctrlKey=touchEvent.ctrlKey;
				transformTouchEvt.altKey=touchEvent.altKey;
				transformTouchEvt.offsetX=touchEvent.stageX-transformTouchInfo.stageX;
				transformTouchEvt.offsetY=touchEvent.stageY-transformTouchInfo.stageY;
				if(TouchInfo.twoFignerTouchType==/*iflash.events.TouchEvent.TOUCH_END*/"touchEnd"){
					TouchInfo.twoFignerTouchType="";
					return null;
				}
				TouchInfo.twoFignerTouchType=touchEvent.type;
				if((t0.stageX-t0.startX)*(t1.stageX-t1.startX)>10 && (t0.stageY-t0.startY)*(t1.stageY-t1.startY)>10){
					transformTouchEvt.type=/*iflash.events.TransformGestureEvent.GESTURE_PAN*/"gesturePan";
				}
				else{
					if(TouchInfo.twoFignerDownCount>0){
						transformTouchEvt.phase=/*iflash.events.GesturePhase.BEGIN*/"begin";
						TouchInfo.twoFignerDownCount=0;
					};
					var startVectorX=t1.startX-t0.startX;
					var startVectorY=t1.startY-t0.startY;
					var startDis=Math.sqrt(startVectorX *startVectorX+startVectorY *startVectorY);
					var nowVectorX=t1.stageX-t0.stageX;
					var nowVectorY=t1.stageY-t0.stageY;
					var nowDis=Math.sqrt(nowVectorX *nowVectorX+nowVectorY *nowVectorY);
					var cos=Math.acos((startVectorX *nowVectorX+startVectorY *nowVectorY)/(startDis *nowDis));
					var endVectorX=t1.endX-t0.endX;
					var endVectorY=t1.endY-t0.endY;
					nowVectorX=Math.abs(nowVectorX)<1 ? 1:nowVectorX;
					nowVectorY=Math.abs(nowVectorY)<1 ? 1:nowVectorY;
					endVectorX=Math.abs(endVectorX)<1 ? 1:endVectorX;
					endVectorY=Math.abs(endVectorY)<1 ? 1:endVectorY;
					var nex=nowVectorX/endVectorX;
					var ney=nowVectorY/endVectorY;
					nex=nex>1.1?1.1:nex;nex=nex<0.9?0.9:nex;
					ney=ney>1.1?1.1:ney;ney=ney<0.9?0.9:ney;
					transformTouchEvt.scaleX=nex;
					transformTouchEvt.scaleY=ney;
					transformTouchEvt.type=/*iflash.events.TransformGestureEvent.GESTURE_ZOOM*/"gestureZoom";
					if(cos > 20 *TouchInfo.RAD_UNIT){
						var endDis=Math.sqrt(endVectorX *endVectorX+endVectorY *endVectorY);
						var dir=(endVectorX *nowVectorY-endVectorY *nowVectorX)>=0?1:-1;
						var changeRotation=dir *Math.acos((endVectorX *nowVectorX+endVectorY *nowVectorY)/(endDis *nowDis));
						transformTouchEvt.rotation=changeRotation / TouchInfo.RAD_UNIT;
						transformTouchEvt.type=/*iflash.events.TransformGestureEvent.GESTURE_ROTATE*/"gestureRotate";
					}
					t1.endX=t1.stageX;t0.endX=t0.stageX;
					t1.endY=t1.stageY;t0.endY=t0.stageY;
				}
				return transformTouchEvt;
			}
			if(tLen==1 && touchEvent.type==/*iflash.events.TouchEvent.TOUCH_BEGIN*/"touchBegin"){
				TouchInfo.isSingleFingerDown=true;
				TouchInfo.singleFignerDownTime=touchEvent.timestamp;
			}
			else if(tLen==1 && touchEvent.type==/*iflash.events.TouchEvent.TOUCH_END*/"touchEnd"){
				TouchInfo.isSingleFingerDown=false;
				TouchInfo.singleFignerDownTime=0;
			}
			if(tLen==2 && touchEvent.type==/*iflash.events.TouchEvent.TOUCH_END*/"touchEnd" && TouchInfo.twoFingerGapTime>=100){
				var patge=PressAndTapGestureEvent.getInstance();
				patge._lytarget=touchEvent.target;
				patge.tapLocalX=touchEvent.localX;
				patge.tapLocalY=touchEvent.localY;
				patge.tapStageX=touchEvent.stageX;
				patge.tapStageY=touchEvent.stageY;
				return patge;
			}
			if(tLen==1 && TouchInfo.isSingleFingerDown && touchEvent.type==/*iflash.events.TouchEvent.TOUCH_MOVE*/"touchMove" && TouchInfo.singleFignerDownTime!=0 && (touchEvent.timestamp-TouchInfo.singleFignerDownTime>80)){
				TouchInfo.singleFignerDownTime=0;
				var swipeTouchInfo=TouchInfo.touchs[0];
				var swipeTouchEvt=new TransformGestureEvent(/*iflash.events.TransformGestureEvent.GESTURE_SWIPE*/"gestureSwipe",true,false,GesturePhase.GESTURE_PHASE_MAP_TOUCH[touchEvent.type]);
				swipeTouchEvt.localX=touchEvent.localX;
				swipeTouchEvt.localY=touchEvent.localY;
				swipeTouchEvt._lytarget=touchEvent._lytarget;
				swipeTouchEvt.shiftKey=touchEvent.shiftKey;
				swipeTouchEvt.ctrlKey=touchEvent.ctrlKey;
				swipeTouchEvt.altKey=touchEvent.altKey;
				swipeTouchEvt.offsetX=touchEvent.stageX-swipeTouchInfo.startX>0?1:-1;
				swipeTouchEvt.offsetY=touchEvent.stageY-swipeTouchInfo.startY>0?1:-1;
				return swipeTouchEvt;
			}
			return null;
		}

		TouchInfo.touchInfos={};
		TouchInfo.touchs=[];
		TouchInfo.TWO_FINGER_GAP_MIN_TIME=100;
		TouchInfo.GESTURE_SWIPE_MIN_TIME=80;
		TouchInfo.TRANSFORM_MIN_SIZE=10;
		TouchInfo.MIN_ROTATION_NUM=20;
		TouchInfo.twoFingerGapTime=0;
		TouchInfo.twoFignerDownTime=0;
		TouchInfo.singleFignerDownTime=0;
		TouchInfo.isSingleFingerDown=false;
		TouchInfo.isTwoFingerDown=false;
		TouchInfo.twoFignerDownCount=0;
		TouchInfo.twoFignerTouchType="";
		__static(TouchInfo,
		['RAD_UNIT',function(){return this.RAD_UNIT=Math.PI/180;}
		]);
		return TouchInfo;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/touchphase.as
	//class iflash.events.TouchPhase
	var TouchPhase=(function(){
		function TouchPhase(){};
		__class(TouchPhase,'iflash.events.TouchPhase',true);
		TouchPhase.HOVER="hover";
		TouchPhase.BEGAN="began";
		TouchPhase.MOVED="moved";
		TouchPhase.STATIONARY="stationary";
		TouchPhase.ENDED="ended";
		return TouchPhase;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/utils/documentadapter.as
	//class iflash.laya.utils.DocumentAdapter
	var DocumentAdapter=(function(){
		function DocumentAdapter(){
			this.autoScaleDifference=0;
			this._screenRotate_=0;
			this._autorotate_="rotator";
			this._onWindows=/*__JS__ */navigator.userAgent.indexOf("Windows")>-1;
			Laya.window.lyAddEventListener(/*iflash.events.Event.RESIZE*/"resize",__bind(this,this.onResize));
		}

		__class(DocumentAdapter,'iflash.laya.utils.DocumentAdapter',true);
		var __proto=DocumentAdapter.prototype;
		__proto.onResize=function(__args){
			var args=arguments;
			if(!this._onWindows && (Stage.stage.focus instanceof iflash.text.TextField )){
				return;
			};
			var body=Laya.document.body;
			if(!body)return;
			var window=Laya.window;
			var sx=window.innerWidth / Stage.stage.width;
			var sy=window.innerHeight / Stage.stage.height;
			body.width=Stage.stage.width;
			body.height=Stage.stage.height;
			if (Math.abs(sx-1)< 0.02)sx=1;
			if (Math.abs(sy-1)< 0.02)sy=1;
			if(Stage.stage.scaleMode==/*iflash.display.StageScaleMode.NO_SCALE*/"noScale"){
				sx=1;
				sy=1;
			}
			else if(Stage.stage.scaleMode==/*iflash.display.StageScaleMode.NO_BORDER*/"noBorder"){
				if (sx < sy){
					sx=sy;
				}
				else{
					sy=sx;
				}
			}
			else if(Stage.stage.scaleMode==/*iflash.display.StageScaleMode.SHOW_ALL*/"showAll"){
				if (sx > sy){
					sx=sy;
				}
				else{
					sy=sx;
				}
			}
			window.scale.x=sx;
			window.scale.y=sy;
			body.scaleX=sx;
			body.scaleY=sy;
			var bodyPosX=Math.floor((window.innerWidth-Stage.stage.width *sx)/ 2);
			var bodyPosY=Math.floor((window.innerHeight-Stage.stage.height *sy)/ 2);
			if(Stage.stage.align !=""){
				if(StageAlign.isTop(Stage.stage.align)){
					bodyPosY=0;
				}
				if(StageAlign.isBottom(Stage.stage.align)){
					bodyPosY=Math.floor(window.innerHeight-Stage.stage.height *sy);
				}
				if(StageAlign.isLeft(Stage.stage.align)){
					bodyPosX=0;
				}
				if(StageAlign.isRight(Stage.stage.align)){
					bodyPosX=Math.floor(window.innerWidth-Stage.stage.width *sx);
				}
			}
			body.x=bodyPosX;
			body.y=bodyPosY;
		}

		__getset(0,__proto,'autorotate',function(){
			return this._autorotate_;
			},function(type){
			this._autorotate_=type.toLowerCase();
			Laya.window.lyDispatchEvent(/*iflash.events.Event.RESIZE*/"resize");
		});

		__getset(0,__proto,'screenRotate',function(){
			return this._screenRotate_;
		});

		return DocumentAdapter;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/utils/dynamicproperties.as
	//class iflash.laya.utils.DynamicProperties
	var DynamicProperties=(function(){
		function DynamicProperties(_class,fndef,set_get,htmlNeed){
			this.nameWith=null;
			this.valueTo=null;
			this.htmlNeed=false;
			(htmlNeed===void 0)&& (htmlNeed=true);
			this.htmlNeed=htmlNeed;
			if (_class==null)return;
			var strs=DynamicProperties._regProperties.exec(fndef);
			var name=strs[2];
			this.valueTo=strs[4]?DynamicProperties.__CALCULATORTYPE__[strs[4]]:StringMethod.strToStr;
			this.nameWith=set_get==null?name:(set_get);
			_class.prototype["??"+name]=this;
		}

		__class(DynamicProperties,'iflash.laya.utils.DynamicProperties',true);
		var __proto=DynamicProperties.prototype;
		__proto.setValue=function(obj,data){
			obj[this.nameWith]=this.valueTo(data);
		}

		__proto.getValue=function(obj){
			if(!((obj instanceof iflash.media.AudioElement ))&&this.nameWith=="autoplay")
				return null;
			return obj[this.nameWith];
		}

		__proto.toHTML=function(){
			return this.htmlNeed;
		}

		DynamicProperties.reg=function(_class,fndef,set_get,htmlNeed){
			(htmlNeed===void 0)&& (htmlNeed=true);
			if (fndef.indexOf('(')<0)return new DynamicProperties(_class,fndef,set_get,htmlNeed);
			else return new DynamicMethods(_class,fndef,set_get,htmlNeed);
		}

		DynamicProperties._regProperties=new RegExp("(\\s*)([\\w-]+)\\s*(=\\s*(\\w))?");
		__static(DynamicProperties,
		['__CALCULATORTYPE__',function(){return this.__CALCULATORTYPE__={'s':StringMethod.strToStr,'i':StringMethod.toInt,'I':StringMethod.strToBigInt,'d':StringMethod.toFloat,'b':StringMethod.toBool,'t':StringMethod.strToTime};}
		]);
		return DynamicProperties;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/utils/matrixutil.as
	//class iflash.laya.utils.MatrixUtil
	var MatrixUtil=(function(){
		function MatrixUtil(){throw new Error("can not new MatrixUtil");}
		__class(MatrixUtil,'iflash.laya.utils.MatrixUtil',true);
		MatrixUtil.transformPoint=function(matrix,point,resultPoint){
			return MatrixUtil.transformCoords(matrix,point.x,point.y,resultPoint);
		}

		MatrixUtil.transformCoords=function(matrix,x,y,resultPoint){
			if (resultPoint==null)resultPoint=new Point();
			resultPoint.x=matrix.a *x+matrix.c *y+matrix.tx;
			resultPoint.y=matrix.d *y+matrix.b *x+matrix.ty;
			return resultPoint;
		}

		MatrixUtil.skew=function(matrix,skewX,skewY){
			var sinX=Math.sin(skewX);
			var cosX=Math.cos(skewX);
			var sinY=Math.sin(skewY);
			var cosY=Math.cos(skewY);
			matrix.setTransform(matrix.a *cosY-matrix.b *sinX,
			matrix.a *sinY+matrix.b *cosX,
			matrix.c *cosY-matrix.d *sinX,
			matrix.c *sinY+matrix.d *cosX,
			matrix.tx *cosY-matrix.ty *sinX,
			matrix.tx *sinY+matrix.ty *cosX);
		}

		MatrixUtil.prependMatrix=function(base,prep){
			base.setTransform(base.a *prep.a+base.c *prep.b,
			base.b *prep.a+base.d *prep.b,
			base.a *prep.c+base.c *prep.d,
			base.b *prep.c+base.d *prep.d,
			base.tx+base.a *prep.tx+base.c *prep.ty,
			base.ty+base.b *prep.tx+base.d *prep.ty);
		}

		MatrixUtil.prependTranslation=function(matrix,tx,ty){
			matrix.tx+=matrix.a *tx+matrix.c *ty;
			matrix.ty+=matrix.b *tx+matrix.d *ty;
		}

		MatrixUtil.prependScale=function(matrix,sx,sy){
			matrix.setTransform(matrix.a *sx,matrix.b *sx,
			matrix.c *sy,matrix.d *sy,
			matrix.tx,matrix.ty);
		}

		MatrixUtil.prependRotation=function(matrix,angle){
			var sin=Math.sin(angle);
			var cos=Math.cos(angle);
			matrix.setTransform(matrix.a *cos+matrix.c *sin,matrix.b *cos+matrix.d *sin,
			matrix.c *cos-matrix.a *sin,matrix.d *cos-matrix.b *sin,
			matrix.tx,matrix.ty);
		}

		MatrixUtil.prependSkew=function(matrix,skewX,skewY){
			var sinX=Math.sin(skewX);
			var cosX=Math.cos(skewX);
			var sinY=Math.sin(skewY);
			var cosY=Math.cos(skewY);
			matrix.setTransform(matrix.a *cosY+matrix.c *sinY,
			matrix.b *cosY+matrix.d *sinY,
			matrix.c *cosX-matrix.a *sinX,
			matrix.d *cosX-matrix.b *sinX,
			matrix.tx,matrix.ty);
		}

		__static(MatrixUtil,
		['sRawData',function(){return this.sRawData=
			/*new vector.<>*/[1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1];},'sRawData2',function(){return this.sRawData2=__newvec(16,0);}
		]);
		return MatrixUtil;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/utils/method.as
	//class iflash.laya.utils.Method
	var Method=(function(){
		function Method(){}
		__class(Method,'iflash.laya.utils.Method',true);
		Method.getPath=function(url){
			if(url==null || url=="")return "";
			var index=url.indexOf("?");
			if(index<0)index=url.indexOf("#");
			index=url.lastIndexOf("/");
			if (index >=0)url=url.substring(0,index+1);
			else url="/";
			if (url.charAt(0)=='/')url="file://"+url;
			return url;
		}

		Method.formatUrl=function(fileName,basePath){
			if (Laya.config.urlToLower)fileName=fileName.toLowerCase();
			var urlcache=Method.__urlCache__[fileName];
			if (urlcache !=null)return urlcache;
			if (fileName==null){
				return "";
			}
			if ((fileName.charAt(1)==':' && fileName.charAt(2)=='/'))
				fileName="file://"+fileName;
			if (fileName.charAt(0)=="/"){
				return Laya.window.location.fullPath+fileName.substring(1,fileName.length);
			}
			if (basePath==null)basePath=Laya.window.location.fullPath;
			var urlfull=basePath+"/"+fileName;
			urlcache=Method.__urlCache__[urlfull];
			if (urlcache !=null)return urlcache;
			if (fileName.indexOf("://")< 0)
				fileName=basePath+"/"+fileName;
			var urls=fileName.split("/");
			urls[1]="";
			var str,i=2,size=urls.length;
			while (i < size){
				str=urls[i];
				if (str==null)break ;
				if (str=='' || str=='.'){
					urls.splice(i,1);
					continue ;
				}
				if (str==".."){
					urls.splice(i-1,2);
					i-=1;
					continue ;
				}
				i+=1;
			}
			fileName=urls.join("/");
			return fileName;
		}

		Method.isNullOrEmpty=function(txt){
			return txt==null || txt=='';
		}

		Method.removeFromeArray=function(array,o){
			var index=array.indexOf(o);
			if (index >=0)array.splice(index);
		}

		Method.InitAttributesToHTML=function(initTxt,_class){
			var i=0,sz=0,def,strs,onestrs,out=[],j=0,str;
			strs=initTxt.split(';');
			for (i=0,sz=strs.length;i < sz;i++){
				onestrs=strs[i].split(':');
				if (onestrs[0].length < 1)continue ;
				def={name:onestrs[0],defaultv:onestrs[1],namenew:onestrs[2] };
				if (def.namenew==null)def.namenew=def.name;
				out.push(def);
				if (_class!=null && def.namenew !=def.name)
					iflash.laya.utils.regXmlAttr(_class,def.namenew,def.name);
			}
			return out;
		}

		Method.jsonParse=function(txt,reviver){
			try{
				return JSON.parse(txt,reviver);
			}
			catch(e){
			}
			return null;
		}

		Method.JsFunctionErr=LAYAFNVOID/*function(){}*/
		Method.jsToEventFun=function(s){
			return (((typeof s=='string'))?Browser.eval("(function(event){"+s+";})"):s);
		}

		Method.insert=function(arr,index,c){
			if (index < 0)throw "insert less than 0";
			if (index>=arr.length){
				arr.push(c);
				return;
			}
			else if (index==0){
				arr.unshift(c);
				return;
			};
			var len=arr.length;
			for (var i=len;i > index;i--){
				arr[i]=arr[i-1];
			}
			arr[index]=c;
		}

		Method.forseInsert=function(arr,index,c){
			if (index < 0)throw "insert less than 0";
			if (index >=arr.length){
				arr.length=index+1;
			}
			arr[index]=c;
		}

		Method.execScript=function(str,url){
			if (Laya.CONCHVER){
				Browser.eval(str,null);
				return;
			}
			try {
				Log.log("execScript:"+url);
				var a=Browser.document.createElement ("script");
				a.type="text/javascript";
				a.text=str;
				var o=Browser.document.getElementsByTagName("head");
				o[0].appendChild(a);
			}
			catch (err){
				/*__JS__ */debugger;
			}
		}

		Method._JpgToPng=function(img){
			var src=Canvas.create();
			var w=img.width,h=int((img.height-1)/2);
			src.size(w,h);
			src.context.drawImage(img,0,0,w,h,0,0,w,h);
			var imageDataSrc=src.context.getImageData(0,0,w,h);
			var pixelsSrc=imageDataSrc.data;
			if (pixelsSrc==null)Browser.alert("JpgToPng err:"+img.src);
			if (Method.__tmpCanvas__==null)Method.__tmpCanvas__=Canvas.create();
			Method.__tmpCanvas__.active();
			var alpha=Method.__tmpCanvas__;
			alpha.size(w,h);
			alpha.context.drawImage(img,0,h+2,w,h,0,0,w,h);
			var imageDataAlpha=alpha.context.getImageData(0,0,w,h);
			var pixelsAlpha=imageDataAlpha.data;
			var i=0,x=0;
			for (var y=0;y < h;y++){
				i=(y *w)<< 2;
				x=0;
				while (x < w){
					i+=4;
					x++;
					pixelsSrc[i+3]=pixelsAlpha[i];
				}
			}
			src.context.putImageData(imageDataSrc,0,0);
			return src;
		}

		Method.formatUrlType=function(url){
			var question=url.split ("?").length <=1;
			if(!question){
				url=url.slice(0,url.indexOf("?"));
			};
			var _formatUrlType_="";
			var extension="";
			var arr=url.split("/");
			url=arr[arr.length-1];
			var parts=url.split (".");
			if (parts.length > 1){
				extension=parts[parts.length-1].toLowerCase ();
			}else extension=".";
			return extension;
		}

		Method.__tmpCanvas__=null;
		Method._TEMP_FUN_=null
		Method.__urlCache__=[];
		return Method;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/utils/stringmethod.as
	//class iflash.laya.utils.StringMethod
	var StringMethod=(function(){
		function StringMethod(){}
		__class(StringMethod,'iflash.laya.utils.StringMethod',true);
		StringMethod.nChar=function(chr,n){
			if (n < 1)return "";
			var str="";
			for (var i=0;i < n;i++)str+=chr;
			return str;
		}

		StringMethod.strToStr=function(value){
			return value;
		}

		StringMethod.toInt=function(d){
			return ((typeof d=='string'))?Laya.__parseInt(d):(d);
		}

		StringMethod.toFloat=function(d){
			return ((typeof d=='string'))?d:(d);
		}

		StringMethod.toBool=function(str){
			return (str==true || str=='true');
		}

		StringMethod.strToBigInt=function(value){
			if (value=="infinite")return /*int.MAX_VALUE*/2147483647;
			else return Laya.__parseInt(value);
		}

		StringMethod.strToTime=function(tm){
			if (tm==null)return 0;
			var n=1,sz=tm.length;
			if (tm.charAt(sz-1)=='s'){
				if (tm.substring(0,sz-2)=='ms')
					sz-=2;
				else{
					sz--;
					n=1000;
				}
			}
			return Math.floor(parseFloat(tm.substring(0,sz))*n);
		}

		StringMethod.strTrim=function(str){
			return str.replace(StringMethod._string_Trim_,"");
		}

		StringMethod.replaceBlankChar=function(str,dec){
			return str.replace(StringMethod._string_Trim_,'').replace(StringMethod._removeBlankChar_,dec?dec:' ');
		}

		StringMethod.subString=function(str,headstr,endstr,nullrtn,pos){
			if(str==null)return nullrtn;
			var b=str.indexOf(headstr),e=0;
			if(b<0)return nullrtn;
			b+=headstr.length;
			if (endstr==null)return str.substring(b,str.length);
			((e=str.indexOf(endstr,b))< 0)&& (e=str.length);
			if (pos !=null){
				pos.x=b;
				pos.y=e;
			}
			return str.substring(b,e);
		}

		StringMethod.getColorString=function(value){
			if(!value && value !=0)
				return null;
			var s;
			s=value.toString(16).toUpperCase();
			s=s.replace(/0x|0X/,'');
			var len=6-s.length,str="";
			if(s.length<6){
				for(var i=0;i<len;i++){
					str+=0;
				}
			}
			s="#"+str+s;
			return s;
		}

		StringMethod._string_Trim_=new RegExp("(^\\s*)|(\\s*$)","g");
		StringMethod._string_LTrim_=new RegExp("(^\\s*)","g");
		StringMethod._string_RTrim_=new RegExp("(\\s*$)","g");
		StringMethod._removeBlankChar_=new RegExp("\\s+","g");
		StringMethod._WORDSIZEMAP_=[];
		return StringMethod;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/utils/timerobject.as
	//class iflash.laya.utils.TimerObject
	var TimerObject=(function(){
		function TimerObject(time,listener,owner,delay,repeatCount){
			this._listener_=null;
			this.owner=null;
			this.isdel=false;
			this.startTime=NaN;
			this.nextTime=NaN;
			this.delay=NaN;
			this.repeatCount=NaN;
			this.runCount=NaN;
			this.data=null;
			this.name="";
			(delay===void 0)&& (delay=0);
			(repeatCount===void 0)&& (repeatCount=0);
			this.isdel=false;
			this.delay=delay;
			this.repeatCount=repeatCount;
			this._reset_(time,listener,owner);
			this.name=""+TimerObject.NameConut++;
		}

		__class(TimerObject,'iflash.laya.utils.TimerObject',true);
		var __proto=TimerObject.prototype;
		Laya.imps(__proto,{"iflash.laya.system.IObject":true})
		__proto._reset_=function(time,listener,owner){
			this.deleted=false;
			this.data=null;
			this._listener_=listener;
			this.owner=owner;
			this.startTime=time;
			this.isdel=false;
			this.runCount=0;
			this.nextTime=this.startTime+this.delay;
			return this;
		}

		__proto.run=function(time){
			if (this.isdel)return false;
			if (this.delay==0){
				return (this.owner && this.owner.deleted)|| (this._listener_&&this._listener_.call(this.owner,time,time-this.startTime,this));
			}
			if (this.nextTime==time)return true;
			while (this.nextTime <=time){
				if (this.owner && this.owner.deleted){
					return !(this.deleted=true);
				}
				if (this._listener_ !=null && (this._listener_.call(this.owner,time,time-this.startTime,this)==false)){
					return !(this.deleted=true);
				}
				this.nextTime+=this.delay;
				this.runCount++;
				if(this.repeatCount>0 && this.runCount>=this.repeatCount){
					return !(this.deleted=true);
				}
			}
			return true;
		}

		__getset(0,__proto,'listener',function(){
			return this._listener_;
		});

		__getset(0,__proto,'deleted',function(){
			return this.isdel;
			},function(b){
			this.isdel=b;
			if (b){
				this._listener_=null;
				this.owner=null;
				this.data=null;
			}
		});

		TimerObject.NameConut=0;
		return TimerObject;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/utils/uri.as
	//class iflash.laya.utils.URI
	var URI=(function(){
		function URI(_url){
			this.url=null;
			this.path=null;
			this.url=_url;
			this.path=Method.getPath(_url);
		}

		__class(URI,'iflash.laya.utils.URI',false);
		var __proto=URI.prototype;
		__proto.toString=function(){
			return this.url;
		}

		return URI;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/utils/bytearraycontextcmd.as
	//class iflash.utils.byteArrayContextCMD
	var byteArrayContextCMD=(function(){
		function byteArrayContextCMD(){
			this.result=null;
			this.result=new ByteArray();
		}

		__class(byteArrayContextCMD,'iflash.utils.byteArrayContextCMD',true);
		var __proto=byteArrayContextCMD.prototype;
		__proto.clear=function(){
			this.result.clear();
		}

		__proto.getBuffer=function(){
			return this.result;
		}

		__proto.save=function(){
			this.result.writeShort(/*iflash.utils.ConchRenderVCanvas.CMD_SAVE*/0);
		}

		__proto.restore=function(){
			this.result.writeShort(/*iflash.utils.ConchRenderVCanvas.CMD_RESTORE*/1);
		}

		__proto.beginPath=function(){
			this.result.writeShort(/*iflash.utils.ConchRenderVCanvas.CMD_BEGINPATH*/2);
		}

		__proto.drawImage=function(__args){
			var args=[];for(var i=0,sz=arguments.length;i<sz;i++)args.push(arguments[i]);
			if (args.length==3){
				this.result.writeShort(/*iflash.utils.ConchRenderVCanvas.CMD_DRAWIMAGE3*/3);
				this.result.writeFloat(args[1]);
				this.result.writeFloat(args[2]);
			}
			else if (args.length==5){
				this.result.writeShort(/*iflash.utils.ConchRenderVCanvas.CMD_DRAWIMAGE5*/4);
				this.result.writeDouble(args[0].id);
				this.result.writeFloat(args[1]);
				this.result.writeFloat(args[2]);
				this.result.writeFloat(args[3]);
				this.result.writeFloat(args[4]);
			}
			else{
				this.result.writeShort(/*iflash.utils.ConchRenderVCanvas.CMD_DRAWIMAGE9*/5);
				this.result.writeDouble(args[0].id);
				this.result.writeFloat(args[1]);
				this.result.writeFloat(args[2]);
				this.result.writeFloat(args[3]);
				this.result.writeFloat(args[4]);
				this.result.writeFloat(args[5]);
				this.result.writeFloat(args[6]);
				this.result.writeFloat(args[7]);
				this.result.writeFloat(args[8]);
			}
		}

		__proto.rect=function(x,y,w,h){
			this.result.writeShort(/*iflash.utils.ConchRenderVCanvas.CMD_RECT*/6);
			this.result.writeInt(x);
			this.result.writeInt(y);
			this.result.writeInt(w);
			this.result.writeInt(h);
		}

		__proto.clip=function(){
			this.result.writeShort(/*iflash.utils.ConchRenderVCanvas.CMD_CLIP*/7);
			return true;
		}

		__proto.scale=function(x,y){
			this.result.writeShort(/*iflash.utils.ConchRenderVCanvas.CMD_SCALE*/8);
			this.result.writeFloat(x);
			this.result.writeFloat(y);
		}

		__proto.translate=function(x,y){
			this.result.writeShort(/*iflash.utils.ConchRenderVCanvas.CMD_TRANSLATE*/9);
			this.result.writeFloat(x);
			this.result.writeFloat(y);
		}

		__proto.transform=function(a,b,c,d,tx,ty){
			this.result.writeShort(/*iflash.utils.ConchRenderVCanvas.CMD_TRANSFORM*/10);
			this.result.writeFloat(a);
			this.result.writeFloat(b);
			this.result.writeFloat(c);
			this.result.writeFloat(d);
			this.result.writeFloat(tx);
			this.result.writeFloat(ty);
		}

		__proto.clearRect=function(x,y,w,h){
			this.result.writeShort(/*iflash.utils.ConchRenderVCanvas.CMD_CLEARRECT*/12);
			this.result.writeInt(x);
			this.result.writeInt(y);
			this.result.writeInt(w);
			this.result.writeInt(h);
		}

		__proto.closePath=function(){
			this.result.writeShort(/*iflash.utils.ConchRenderVCanvas.CMD_CLOSEPATH*/13);
		}

		__proto.fillRect=function(x,y,w,h){
			this.result.writeShort(/*iflash.utils.ConchRenderVCanvas.CMD_FILLRECT*/15);
			this.result.writeInt(x);
			this.result.writeInt(y);
			this.result.writeInt(w);
			this.result.writeInt(h);
		}

		__proto.stroke=function(){
			this.result.writeShort(/*iflash.utils.ConchRenderVCanvas.CMD_STROKE*/17);
		}

		__proto.strokeRect=function(x,y,w,h){
			this.result.writeShort(/*iflash.utils.ConchRenderVCanvas.CMD_STROKERECT*/18);
			this.result.writeInt(x);
			this.result.writeInt(y);
			this.result.writeInt(w);
			this.result.writeInt(h);
		}

		__proto.fillText=function(word,x,y){
			this.result.writeShort(/*iflash.utils.ConchRenderVCanvas.CMD_FILLTEXT*/19);
			this.result.writeUTF(word);
			this.result.writeFloat(x);
			this.result.writeFloat(y);
		}

		__proto.fill=function(){
			this.result.writeShort(/*iflash.utils.ConchRenderVCanvas.CMD_FILL*/20);
		}

		__proto.moveTo=function(x,y){
			this.result.writeShort(/*iflash.utils.ConchRenderVCanvas.CMD_MOVETO*/24);
			this.result.writeFloat(x);
			this.result.writeFloat(y);
		}

		__proto.lineTo=function(x,y){
			this.result.writeShort(/*iflash.utils.ConchRenderVCanvas.CMD_LINETO*/25);
			this.result.writeFloat(x);
			this.result.writeFloat(y);
		}

		__proto.arc=function(x,y,r,sAngle,eAngle,bCounterclockwise){
			this.result.writeShort(/*iflash.utils.ConchRenderVCanvas.CMD_ARC*/26);
			this.result.writeInt(x);
			this.result.writeInt(y);
		}

		__proto.arcTo=LAYAFNVOID/*function(x1,y1,x2,y2,radium){}*/
		__proto.bezierCurveTo=LAYAFNVOID/*function(nCPX,nCPY,nCPX2,nCPY2,nEndX,nEndY){}*/
		__proto.quadraticCurveTo=LAYAFNVOID/*function(left,top,width,height){}*/
		__getset(0,__proto,'globalAlpha',null,function(n){
			this.result.writeShort(/*iflash.utils.ConchRenderVCanvas.CMD_GLOBALALPHA*/11);
			this.result.writeFloat(n);
		});

		__getset(0,__proto,'fillStyle',null,function(style){
			this.result.writeShort(/*iflash.utils.ConchRenderVCanvas.CMD_FILLSTYLE*/14);
			this.result.writeUTF(style);
		});

		__getset(0,__proto,'lineJoin',null,function(s){
			this.result.writeShort(/*iflash.utils.ConchRenderVCanvas.CMD_LINEJOIN*/23);
			this.result.writeUTF(s);
		});

		__getset(0,__proto,'strokeStyle',null,function(color){
			this.result.writeShort(/*iflash.utils.ConchRenderVCanvas.CMD_STROKESTYLE*/16);
			this.result.writeUTF(color);
		});

		__getset(0,__proto,'lineCap',null,function(s){
			this.result.writeShort(/*iflash.utils.ConchRenderVCanvas.CMD_LINECAP*/21);
			this.result.writeUTF(s);
		});

		__getset(0,__proto,'lineWidth',null,function(n){
			this.result.writeShort(/*iflash.utils.ConchRenderVCanvas.CMD_LINEWIDTH*/22);
			this.result.writeInt(n);
		});

		__static(byteArrayContextCMD,
		['INSTANCE',function(){return this.INSTANCE=new byteArrayContextCMD();}
		]);
		return byteArrayContextCMD;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/utils/conchrendervcanvas.as
	//class iflash.utils.ConchRenderVCanvas
	var ConchRenderVCanvas=(function(){
		function ConchRenderVCanvas(){}
		__class(ConchRenderVCanvas,'iflash.utils.ConchRenderVCanvas',true);
		var __proto=ConchRenderVCanvas.prototype;
		__proto.uploadConch=function(){
			var instance=stringContextCMD.INSTANCE;
			ConchRenderVCanvas.cmdArray.length=0;
			var temp;
			for (var i=0,sz=ConchRenderVCanvas.maps.length;i < sz;i++){
				var canvas=ConchRenderVCanvas.maps[i];
				var d=VirtualCanvas.getConchSring(canvas._cmds_);
				ConchRenderVCanvas.cmdArray.push(canvas.conchVirtualBitmap.id+"\6"+d||"");
				temp=canvas.conchVirtualBitmap;
				ConchRenderVCanvas.maps.splice(i,1);
				canvas.inMap=false;
				i--;
				sz--;
			};
			var buffer=ConchRenderVCanvas.cmdArray.join("\3");
			temp && temp.setAllBuffer(buffer);
		}

		ConchRenderVCanvas.CMD_SAVE=0;
		ConchRenderVCanvas.CMD_RESTORE=1;
		ConchRenderVCanvas.CMD_BEGINPATH=2;
		ConchRenderVCanvas.CMD_DRAWIMAGE3=3;
		ConchRenderVCanvas.CMD_DRAWIMAGE5=4;
		ConchRenderVCanvas.CMD_DRAWIMAGE9=5;
		ConchRenderVCanvas.CMD_RECT=6;
		ConchRenderVCanvas.CMD_CLIP=7;
		ConchRenderVCanvas.CMD_SCALE=8;
		ConchRenderVCanvas.CMD_TRANSLATE=9;
		ConchRenderVCanvas.CMD_TRANSFORM=10;
		ConchRenderVCanvas.CMD_GLOBALALPHA=11;
		ConchRenderVCanvas.CMD_CLEARRECT=12;
		ConchRenderVCanvas.CMD_CLOSEPATH=13;
		ConchRenderVCanvas.CMD_FILLSTYLE=14;
		ConchRenderVCanvas.CMD_FILLRECT=15;
		ConchRenderVCanvas.CMD_STROKESTYLE=16;
		ConchRenderVCanvas.CMD_STROKE=17;
		ConchRenderVCanvas.CMD_STROKERECT=18;
		ConchRenderVCanvas.CMD_FILLTEXT=19;
		ConchRenderVCanvas.CMD_FILL=20;
		ConchRenderVCanvas.CMD_LINECAP=21;
		ConchRenderVCanvas.CMD_LINEWIDTH=22;
		ConchRenderVCanvas.CMD_LINEJOIN=23;
		ConchRenderVCanvas.CMD_MOVETO=24;
		ConchRenderVCanvas.CMD_LINETO=25;
		ConchRenderVCanvas.CMD_ARC=26;
		ConchRenderVCanvas.CMD_ARCTO=27;
		ConchRenderVCanvas.CMD_BEZIERCURVETO=28;
		ConchRenderVCanvas.CMD_QUADRATICCURVETO=29;
		ConchRenderVCanvas.CMD_DRAWCANVAS3=30;
		ConchRenderVCanvas.CMD_DRAWCANCAS5=31;
		ConchRenderVCanvas.CMD_DRAWCANCAS9=32;
		ConchRenderVCanvas.CMD_FONT=33;
		ConchRenderVCanvas.CMD_DRAWREPEAT=34;
		ConchRenderVCanvas.CMD_GLOBALCOMPOSITEOPERATION=35;
		ConchRenderVCanvas.CMD_TEXTBASELINE=36;
		ConchRenderVCanvas.maps=[];
		ConchRenderVCanvas.INSTANCE=new ConchRenderVCanvas();
		ConchRenderVCanvas.cmdArray=[];
		__static(ConchRenderVCanvas,
		['CMDMAP',function(){return this.CMDMAP={
				"_drawVCanvas_":-1,
				"_save_":0,
				"_restore_":1,
				"_beginPath_":2,
				"_drawImage3_":3,
				"_drawImage5_":4,
				"_drawImage9_":5,
				"_rect_":6,
				"_clip_":7,
				"_scale_":8,
				"_translate_":9,
				"_transform_":10,
				"_globalAlpha_":11,
				"_clearRect_":12,
				"_closePath_":13,
				"_fillStyle_":14,
				"_fillRect_":15,
				"_strokeStyle_":16,
				"_stroke_":17,
				"_strokeRect_":18,
				"_fillText_":19,
				"_fill_":20,
				"_lineCap_":21,
				"_lineWidth_":22,
				"_lineJoin_":23,
				"_moveTo_":24,
				"_lineTo_":25,
				"_arc_":26,
				"_arcTo_":27,
				"_bezierCurveTo_":28,
				"_quadraticCurveTo_":29,
				"_drawCanvas3_":30,
				"_drawCanvas5_":31,
				"_drawCanvas9_":32,
				"_font_":33,
				"_drawRepeat_":34,
				"_globalCompositeOperation_":35,
				"_textBaseline_":36
		};}

		]);
		return ConchRenderVCanvas;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/utils/datas.as
	//class iflash.utils.Datas
	var Datas=(function(){
		function Datas(){}
		__class(Datas,'iflash.utils.Datas',true);
		Datas.DICKEY=0;
		Datas.DICKEYS=[];
		return Datas;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/utils/debugtools.as
	//class iflash.utils.DebugTools
	var DebugTools=(function(){
		function DebugTools(){}
		__class(DebugTools,'iflash.utils.DebugTools',true);
		DebugTools.getTTime=function(){
			return (new Date()).time;
		}

		DebugTools.startTime=function(sign){
			DebugTools.timeSignPreTimeDic[sign]=DebugTools.getTTime();
		}

		DebugTools.endTime=function(sign){
			var dtime=0;
			dtime=DebugTools.getTTime()-DebugTools.timeSignPreTimeDic[sign];
			DebugTools.timeSignDic[sign]=int(DebugTools.timeSignDic[sign])+dtime;
		}

		DebugTools.resetTime=function(sign){
			DebugTools.timeSignDic[sign]=0;
		}

		DebugTools.getTime=function(sign){
			return DebugTools.timeSignDic[sign];
		}

		DebugTools.timeSignDic={};
		DebugTools.timeSignPreTimeDic={};
		return DebugTools;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/utils/distools.as
	//class iflash.utils.DisTools
	var DisTools=(function(){
		function DisTools(){}
		__class(DisTools,'iflash.utils.DisTools',true);
		return DisTools;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/utils/endian.as
	//class iflash.utils.Endian
	var Endian=(function(){
		function Endian(){};
		__class(Endian,'iflash.utils.Endian',true);
		Endian.BIG_ENDIAN="bigEndian";
		Endian.LITTLE_ENDIAN="littleEndian";
		return Endian;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/utils/fileparse.as
	//class iflash.utils.FileParse
	var FileParse=(function(){
		function FileParse(){}
		__class(FileParse,'iflash.utils.FileParse',true);
		FileParse.getFile=function(url){
			return FileParse.fileContentObj[url];
		}

		FileParse.parse=function(bytes){
			var len=0;
			for(var i=0;;i++){
				if(bytes[i]==0){
					len=i;
					break ;
				}
			};
			var header=bytes.readUTFBytes(len);
			var fileArr=header.split('\n');
			var dataOfs=len+1;
			var bytesTmp;
			var filename;
			var filesize=0;
			var fileBody;
			bytes.position=len+1;
			for(var ii=0;ii<fileArr.length;ii+=2){
				filename=fileArr[ii];
				filesize=Laya.__parseInt(fileArr[ii+1]);
				bytesTmp=new ByteArray();
				bytes.readBytes(bytesTmp,0,filesize);
				FileParse.fileContentObj[filename]=bytesTmp;
				dataOfs+=filesize;
				bytesTmp=null;
			}
		}

		FileParse.fileContentObj={};
		return FileParse;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/utils/layadictionary.as
	//class iflash.utils.LayaDictionary
	var LayaDictionary=(function(){
		function LayaDictionary(){
			this._elements=[];
			this._keys=[];
		}

		__class(LayaDictionary,'iflash.utils.LayaDictionary',true);
		var __proto=LayaDictionary.prototype;
		__proto.set=function(key,value){
			var index=this.indexOf(key);
			if (index >=0){
				this._elements[index]=value;
				return;
			}
			this._keys.push(key);
			this._elements.push(value);
		}

		__proto.contains=function(key){
			return this._keys.indexOf(key)>-1;
		}

		__proto.indexOf=function(key){
			var index=this._keys.indexOf(key);
			if (index >=0)return index;
			key=((typeof key=='string'))?Number(key):(((typeof key=='number'))?key.toString():key);
			return this._keys.indexOf(key);
		}

		__proto.get=function(key){
			var index=this.indexOf(key);
			return index < 0?null:this._elements[index];
		}

		__proto.remove=function(key){
			var index=this.indexOf(key);
			if (index >=0){
				this._keys.splice(index,1);
				this._elements.splice(index,1);
				return true;
			}
			return false;
		}

		__proto.clear=function(){
			this._elements.length=0;
			this._keys.length=0;
		}

		__getset(0,__proto,'elements',function(){
			return this._elements;
		});

		__getset(0,__proto,'keys',function(){
			return this._keys;
		});

		return LayaDictionary;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/utils/log.as
	//class iflash.utils.Log
	var Log=(function(){
		function Log(){}
		__class(Log,'iflash.utils.Log',true);
		Log.log=function(str){
			if(Log.isLog)console.log("[layaLog]:"+str);
		}

		Log.error=function(str){
			if(!Log.isError)console.log("[error]:"+str);
		}

		Log.warming=function(str){
			if(!Log.isWarMing)console.log("[warming]:"+str);
		}

		Log.unfinished=function(className,functionName){
			if(Log.isOpen)console.log("[unfinished]:"+className+"--"+functionName);
		}

		Log.isOpen=false;
		Log.isLog=false;
		Log.isWarMing=false;
		Log.isError=false;
		return Log;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/utils/proxy.as
	//class iflash.utils.Proxy
	var Proxy=(function(){
		function Proxy(){}
		__class(Proxy,'iflash.utils.Proxy',true);
		var __proto=Proxy.prototype;
		__proto.getProperty=function(name){
			Error.throwError(IllegalOperationError,2088);
			return null;
		}

		__proto.setProperty=function(name,value){
			Error.throwError(IllegalOperationError,2089);
		}

		__proto.callProperty=function(name,__rest){
			var rest=[];for(var i=1,sz=arguments.length;i<sz;i++)rest.push(arguments[i]);
			Error.throwError(IllegalOperationError,2090);
			return null;
		}

		__proto.hasProperty=function(name){
			Error.throwError(IllegalOperationError,2091);
			return false;
		}

		__proto.deleteProperty=function(name){
			Error.throwError(IllegalOperationError,2092);
			return false;
		}

		__proto.getDescendants=function(name){
			Error.throwError(IllegalOperationError,2093);
			return false;
		}

		__proto.nextNameIndex=function(index){
			Error.throwError(IllegalOperationError,2105);
			return 0;
		}

		__proto.nextName=function(index){
			Error.throwError(IllegalOperationError,2106);
			return null;
		}

		__proto.nextValue=function(index){
			Error.throwError(IllegalOperationError,2107);
			return null;
		}

		__proto.isAttribute=LAYAFNFALSE/*function(param1){return false}*/
		return Proxy;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/utils/stringcontextcmd.as
	//class iflash.utils.stringContextCMD
	var stringContextCMD=(function(){
		function stringContextCMD(){
			this.result=null;
			this._cmds_=null;
			this.result="";
			this._cmds_=[];
		}

		__class(stringContextCMD,'iflash.utils.stringContextCMD',true);
		var __proto=stringContextCMD.prototype;
		__proto.clear=function(){
			this.result="";
			this._cmds_=[];
		}

		__proto.getBuffer=function(){
			this.result=this._cmds_.join('\5');
			return this.result;
		}

		__proto.save=function(){
			this._cmds_.push(/*iflash.utils.ConchRenderVCanvas.CMD_SAVE*/0);
		}

		__proto.restore=function(){
			this._cmds_.push(/*iflash.utils.ConchRenderVCanvas.CMD_RESTORE*/1);
		}

		__proto.beginPath=function(){
			this._cmds_.push(/*iflash.utils.ConchRenderVCanvas.CMD_BEGINPATH*/2);
		}

		__proto.drawImage=function(__args){
			var args=[];for(var i=0,sz=arguments.length;i<sz;i++)args.push(arguments[i]);
			if (args.length==3){
				this._cmds_.push(/*iflash.utils.ConchRenderVCanvas.CMD_DRAWIMAGE3*/3+'\4'+args[0].imgId+'\4'+args[1]+'\4'+args[2]);
			}
			else if (args.length==5){
				this._cmds_.push(/*iflash.utils.ConchRenderVCanvas.CMD_DRAWIMAGE5*/4+'\4'+args[0].imgId+'\4'+args[1]+'\4'+args[2]+'\4'+args[3]+'\4'+args[4]);
			}
			else{
				this._cmds_.push(/*iflash.utils.ConchRenderVCanvas.CMD_DRAWIMAGE9*/5+'\4'+args[0].imgId+'\4'+args[1]+'\4'+args[2]+'\4'+args[3]+'\4'+args[4]+'\4'+args[5]+'\4'+args[6]+'\4'+args[7]+'\4'+args[8]);
			}
		}

		__proto.rect=function(x,y,w,h){
			this._cmds_.push(/*iflash.utils.ConchRenderVCanvas.CMD_RECT*/6+'\4'+x+'\4'+y+'\4'+w+'\4'+h);
		}

		__proto.clip=function(){
			this._cmds_.push(/*iflash.utils.ConchRenderVCanvas.CMD_CLIP*/7);
			return true;
		}

		__proto.scale=function(x,y){
			this._cmds_.push(/*iflash.utils.ConchRenderVCanvas.CMD_SCALE*/8+'\4'+x+'\4'+y);
		}

		__proto.translate=function(x,y){
			this._cmds_.push(/*iflash.utils.ConchRenderVCanvas.CMD_TRANSLATE*/9+'\4'+x+'\4'+y);
		}

		__proto.transform=function(a,b,c,d,tx,ty){
			this._cmds_.push(/*iflash.utils.ConchRenderVCanvas.CMD_TRANSFORM*/10+'\4'+a+'\4'+b+'\4'+c+'\4'+d+'\4'+tx+'\4'+ty);
		}

		__proto.clearRect=function(x,y,w,h){
			this._cmds_.push(/*iflash.utils.ConchRenderVCanvas.CMD_CLEARRECT*/12+'\4'+x+'\4'+y+'\4'+w+'\4'+h);
		}

		__proto.closePath=function(){
			this._cmds_.push(/*iflash.utils.ConchRenderVCanvas.CMD_CLOSEPATH*/13);
		}

		__proto.fillRect=function(x,y,w,h){
			this._cmds_.push(/*iflash.utils.ConchRenderVCanvas.CMD_FILLRECT*/15+'\4'+x+'\4'+y+'\4'+w+'\4'+h);
		}

		__proto.stroke=function(){
			this._cmds_.push(/*iflash.utils.ConchRenderVCanvas.CMD_STROKE*/17);
		}

		__proto.strokeRect=function(x,y,w,h){
			this._cmds_.push(/*iflash.utils.ConchRenderVCanvas.CMD_STROKERECT*/18+'\4'+x+'\4'+y+'\4'+w+'\4'+h);
		}

		__proto.fillText=function(word,x,y){
			this._cmds_.push(/*iflash.utils.ConchRenderVCanvas.CMD_FILLTEXT*/19+'\4'+word+'\4'+x+'\4'+y);
		}

		__proto.fill=function(){
			this._cmds_.push(/*iflash.utils.ConchRenderVCanvas.CMD_FILL*/20);
		}

		__proto.moveTo=function(x,y){
			this._cmds_.push(/*iflash.utils.ConchRenderVCanvas.CMD_MOVETO*/24+'\4'+x+'\4'+y);
		}

		__proto.lineTo=function(x,y){
			this._cmds_.push(/*iflash.utils.ConchRenderVCanvas.CMD_LINETO*/25+'\4'+x+'\4'+y);
		}

		__proto.arc=function(x,y,r,sAngle,eAngle,bCounterclockwise){
			this._cmds_.push(/*iflash.utils.ConchRenderVCanvas.CMD_ARC*/26+'\4'+x+'\4'+y+'\4'+r+'\4'+sAngle+'\4'+eAngle+'\4'+(bCounterclockwise?1:0));
		}

		__proto.arcTo=function(x1,y1,x2,y2,radium){
			this._cmds_.push(/*iflash.utils.ConchRenderVCanvas.CMD_ARCTO*/27+'\4'+x1+'\4'+y1+'\4'+x2+'\4'+y2+'\4'+radium);
		}

		__proto.bezierCurveTo=function(nCPX,nCPY,nCPX2,nCPY2,nEndX,nEndY){
			this._cmds_.push(/*iflash.utils.ConchRenderVCanvas.CMD_BEZIERCURVETO*/28+'\4'+nCPX+'\4'+nCPY+'\4'+nCPX2+'\4'+nCPY2+'\4'+nEndX+'\4'+nEndY);
		}

		__proto.quadraticCurveTo=function(left,top,width,height){
			this._cmds_.push(/*iflash.utils.ConchRenderVCanvas.CMD_QUADRATICCURVETO*/29+'\4'+left+'\4'+top+'\4'+width+'\4'+height);
		}

		__getset(0,__proto,'globalAlpha',null,function(n){
			this._cmds_.push(/*iflash.utils.ConchRenderVCanvas.CMD_GLOBALALPHA*/11+'\4'+n);
		});

		__getset(0,__proto,'fillStyle',null,function(style){
			this._cmds_.push(/*iflash.utils.ConchRenderVCanvas.CMD_FILLSTYLE*/14+'\4'+style);
		});

		__getset(0,__proto,'font',null,function(f){
			this._cmds_.push(/*iflash.utils.ConchRenderVCanvas.CMD_FONT*/33+'\4'+f);
		});

		__getset(0,__proto,'lineJoin',null,function(s){
			this._cmds_.push(/*iflash.utils.ConchRenderVCanvas.CMD_LINEJOIN*/23+'\4'+s);
		});

		__getset(0,__proto,'strokeStyle',null,function(color){
			this._cmds_.push(/*iflash.utils.ConchRenderVCanvas.CMD_STROKESTYLE*/16+'\4'+color);
		});

		__getset(0,__proto,'lineCap',null,function(s){
			this._cmds_.push(/*iflash.utils.ConchRenderVCanvas.CMD_LINECAP*/21+'\4'+s);
		});

		__getset(0,__proto,'lineWidth',null,function(n){
			this._cmds_.push(/*iflash.utils.ConchRenderVCanvas.CMD_LINEWIDTH*/22+'\4'+n);
		});

		stringContextCMD.COMMA='\4';
		stringContextCMD.SEMICOLON='\5';
		stringContextCMD.INSTANCE=new stringContextCMD();
		return stringContextCMD;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/utils/texturemanager.as
	//class iflash.utils.TextureManager
	var TextureManager=(function(){
		function TextureManager(){
			this._textureDic={};
		}

		__class(TextureManager,'iflash.utils.TextureManager',true);
		var __proto=TextureManager.prototype;
		__proto.getTexture=function(textureUrl){
			return this._textureDic[textureUrl];
		}

		__proto.addTexture=function(textureUrl,data){
			this._textureDic[textureUrl]=data;
		}

		TextureManager.getInstance=function(){
			if(!TextureManager._instance)TextureManager._instance=new TextureManager();
			return TextureManager._instance;
		}

		TextureManager._instance=null
		return TextureManager;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/utils/toolutils.as
	//class iflash.utils.ToolUtils
	var ToolUtils=(function(){
		function ToolUtils(){}
		__class(ToolUtils,'iflash.utils.ToolUtils',true);
		ToolUtils.formatUrlType=function(url){
			var question=url.split ("?").length <=1;
			if(!question){
				url=((url.split ("?"))[0]).toString();
			};
			var _formatUrlType_="";
			var extension="";
			var parts=url.split (".");
			if (parts.length > 0){
				extension=parts[parts.length-1].toLowerCase ();
			}
			return extension;
		}

		ToolUtils.getColor=function(value){
			var s=value.toString(16).toUpperCase();
			var len=6-s.length,str="";
			if(s.length<6){
				for(var i=0;i<len;i++){
					str+=0;
				}
			}
			s="#"+str+s;
			return s;
		}

		return ToolUtils;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/laya.as
	//class Laya
	var ___Laya=(function(){
		//function Laya(sprite){}
		Laya.Main=function(sprite){
			if ((typeof sprite=='function')){
				Laya._startCallBack_=sprite;
				sprite=null;
			}
			if (Laya.config)return;
			/*__JS__ */window.Laya=Laya;
			Laya.config=new iflash.laya.system.Config();
			Laya.root=sprite;
			Browser.__init__(sprite);
			/*__JS__ */Laya.CONCHVER && (conch.disableMultiTouch=true);
			if(Laya.CONCHVER){
				Laya.RENDERBYCANVAS=false;
			}
			else{
				Laya.RENDERBYCANVAS=/*__JS__ */!LAYABOX.runOnlyPlayer;
			}
			DisplayObject.TYPE2DEFAULT=Laya.RENDERBYCANVAS?0:/*iflash.display.DisplayObject.TYPE2_DRAW_CHILDS*/0x800;
			(Laya.process==null)&& Laya.onConchReady();
		}

		Laya.onConchReady=function(){
			Laya.process && Laya.process.active();
			Laya.window=new Window3();
			Browser.__start__();
			if (Boolean(Laya._startCallBack_))Laya._startCallBack_();
			Laya.ilaya.onStart();
		}

		Laya.setIf=function(name,value){
			Laya.ifdef[name]=value;
		}

		Laya.getIfdef=function(name){
			return Laya.ifdef[name] !=null;
		}

		Laya.window=null
		Laya.document=null
		Laya.root=null
		Laya.config=null
		Laya.ifdef={};
		Laya.NULLFLOAT=NaN
		Laya.SHOW_FPS=true;
		Laya.conch=null
		Laya.process=null
		Laya.ilaya=null;
		Laya._startCallBack_=null
		Laya.RENDERBYCANVAS=false;
		Laya.FLASHVER=0;
		__static(Laya,
		['ENABLE3D',function(){return this.ENABLE3D=/*__JS__ */LAYABOX.ENABLE3D;},'CONCHVER',function(){return this.CONCHVER=/*__JS__ */window.conch?1:0;},'HTMLVER',function(){return this.HTMLVER=/*__JS__ */1;}
		]);
		return Laya;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/uncaughterrorevents.as
	//class iflash.events.UncaughtErrorEvents extends iflash.events.EventDispatcher
	var UncaughtErrorEvents=(function(_super){
		function UncaughtErrorEvents(target){
			UncaughtErrorEvents.__super.call(this,target);
		}

		__class(UncaughtErrorEvents,'iflash.events.UncaughtErrorEvents',false,_super);
		return UncaughtErrorEvents;
	})(EventDispatcher)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/accelerometerevent.as
	//class iflash.events.AccelerometerEvent extends iflash.events.Event
	var AccelerometerEvent=(function(_super){
		function AccelerometerEvent(type,bubbles,cancelable,_d){
			this.accelerationX=0;
			this.accelerationY=0;
			this.accelerationZ=0;
			this.timestamp=0;
			(bubbles===void 0)&& (bubbles=false);
			(cancelable===void 0)&& (cancelable=false);
			AccelerometerEvent.__super.call(this,type,bubbles,cancelable,_d);
		}

		__class(AccelerometerEvent,'iflash.events.AccelerometerEvent',false,_super);
		var __proto=AccelerometerEvent.prototype;
		__proto.clone=function(){
			var ae=new AccelerometerEvent(this.type,this.bubbles,this.cancelable,this._lyData);
			ae.accelerationX=this.accelerationX;
			ae.accelerationY=this.accelerationY;
			ae.accelerationZ=this.accelerationZ;
			return ae;
		}

		AccelerometerEvent.copySysEvent=function(e){
			var ae=new AccelerometerEvent(/*CLASS CONST:iflash.events.AccelerometerEvent.UPDATE*/"update",e.bubbles,e.cancelable,null);
			ae.accelerationX=-e.accelerationIncludingGravity.y;
			ae.accelerationY=e.accelerationIncludingGravity.x;
			ae.accelerationZ=e.accelerationIncludingGravity.z;
			ae.timestamp=e.timeStamp;
			return ae;
		}

		AccelerometerEvent.UPDATE="update";
		return AccelerometerEvent;
	})(Event)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/activityevent.as
	//class iflash.events.ActivityEvent extends iflash.events.Event
	var ActivityEvent=(function(_super){
		function ActivityEvent(type,bubbles,cancelable,_d){
			(bubbles===void 0)&& (bubbles=false);
			(cancelable===void 0)&& (cancelable=false);
			ActivityEvent.__super.call(this,type,bubbles,cancelable,_d);
		}

		__class(ActivityEvent,'iflash.events.ActivityEvent',false,_super);
		var __proto=ActivityEvent.prototype;
		__getset(0,__proto,'activating',LAYAFNFALSE/*function(){return false}*/,LAYAFNVOID/*function(value){}*/);
		ActivityEvent.ACTIVITY="activity";
		return ActivityEvent;
	})(Event)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/textevent.as
	//class iflash.events.TextEvent extends iflash.events.Event
	var TextEvent=(function(_super){
		function TextEvent(type,bubbles,cancelable,text){
			this.m_text=null;
			(bubbles===void 0)&& (bubbles=false);
			(cancelable===void 0)&& (cancelable=false);
			(text===void 0)&& (text="");
			TextEvent.__super.call(this,type,bubbles,cancelable);
			this.m_text=text;
		}

		__class(TextEvent,'iflash.events.TextEvent',false,_super);
		var __proto=TextEvent.prototype;
		__proto.clone=function(){
			var te=new TextEvent(this.type,this.bubbles,this.cancelable,this.m_text);
			te.copyNativeData(this);
			return te;
		}

		__proto.copyNativeData=LAYAFNVOID/*function(param1){}*/
		__getset(0,__proto,'text',function(){
			return this.m_text;
			},function(value){
			this.m_text=value;
		});

		TextEvent.LINK="link";
		TextEvent.TEXT_INPUT="textInput";
		return TextEvent;
	})(Event)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/contextmenuevent.as
	//class iflash.events.ContextMenuEvent extends iflash.events.Event
	var ContextMenuEvent=(function(_super){
		function ContextMenuEvent(type,bubbles,cancelable,_d){
			(bubbles===void 0)&& (bubbles=false);
			(cancelable===void 0)&& (cancelable=false);
			ContextMenuEvent.__super.call(this,type,bubbles,cancelable,_d);
		}

		__class(ContextMenuEvent,'iflash.events.ContextMenuEvent',false,_super);
		var __proto=ContextMenuEvent.prototype;
		__getset(0,__proto,'contextMenuOwner',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'isMouseTargetInaccessible',LAYAFNFALSE/*function(){return false}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'mouseTarget',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(value){}*/);
		ContextMenuEvent.MENU_ITEM_SELECT="menuItemSelect";
		ContextMenuEvent.MENU_SELECT="menuSelect";
		return ContextMenuEvent;
	})(Event)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/focusevent.as
	//class iflash.events.FocusEvent extends iflash.events.Event
	var FocusEvent=(function(_super){
		function FocusEvent(type,bubbles,cancelable,relatedObject,shiftKey,keyCode){
			this._keyCode=0;
			this._shiftKey=false;
			(bubbles===void 0)&& (bubbles=true);
			(cancelable===void 0)&& (cancelable=false);
			(shiftKey===void 0)&& (shiftKey=false);
			(keyCode===void 0)&& (keyCode=0);
			FocusEvent.__super.call(this,type,bubbles,cancelable,relatedObject);
			this._shiftKey=shiftKey;
			this._keyCode=keyCode;
		}

		__class(FocusEvent,'iflash.events.FocusEvent',false,_super);
		var __proto=FocusEvent.prototype;
		__proto.clone=function(){
			return this;
		}

		__getset(0,__proto,'isRelatedObjectInaccessible',LAYAFNFALSE/*function(){return false}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'keyCode',function(){
			return this._keyCode;
			},function(value){
			this._keyCode=value;
		});

		__getset(0,__proto,'relatedObject',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'shiftKey',function(){
			return this._shiftKey;
			},function(value){
			this._shiftKey=value;
		});

		FocusEvent.FOCUS_IN="focusIn";
		FocusEvent.FOCUS_OUT="focusOut";
		FocusEvent.KEY_FOCUS_CHANGE="keyFocusChange";
		FocusEvent.MOUSE_FOCUS_CHANGE="mouseFocusChange";
		return FocusEvent;
	})(Event)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/geolocationevent.as
	//class iflash.events.GeolocationEvent extends iflash.events.Event
	var GeolocationEvent=(function(_super){
		function GeolocationEvent(type,bubbles,cancelable,latitude,longitude,altitude,hAccuracy,vAccuracy,speed,heading,timestamp){
			this._altitude=NaN;
			this._heading=NaN;
			this._horizontalAccuracy=NaN;
			this._latitude=NaN;
			this._longitude=NaN;
			this._speed=NaN;
			this._timestamp=NaN;
			this._verticalAccuracy=NaN;
			(bubbles===void 0)&& (bubbles=false);
			(cancelable===void 0)&& (cancelable=false);
			(latitude===void 0)&& (latitude=0);
			(longitude===void 0)&& (longitude=0);
			(altitude===void 0)&& (altitude=0);
			(hAccuracy===void 0)&& (hAccuracy=0);
			(vAccuracy===void 0)&& (vAccuracy=0);
			(speed===void 0)&& (speed=0);
			(heading===void 0)&& (heading=0);
			(timestamp===void 0)&& (timestamp=0);
			GeolocationEvent.__super.call(this,type,bubbles,cancelable,null);
			this.latitude=latitude;
			this.longitude=longitude;
			this.altitude=altitude;
			this.horizontalAccuracy=hAccuracy;
			this.verticalAccuracy=vAccuracy;
			this.speed=speed;
			this.heading=heading;
			this.timestamp=timestamp;
		}

		__class(GeolocationEvent,'iflash.events.GeolocationEvent',false,_super);
		var __proto=GeolocationEvent.prototype;
		__getset(0,__proto,'altitude',function(){
			return this._altitude;
			},function(value){
			this._altitude=value;
		});

		__getset(0,__proto,'speed',function(){
			return this._speed;
			},function(value){
			this._speed=value;
		});

		__getset(0,__proto,'heading',function(){
			return this._heading;
			},function(value){
			this._heading=value;
		});

		__getset(0,__proto,'horizontalAccuracy',function(){
			return this._horizontalAccuracy;
			},function(value){
			this._horizontalAccuracy=value;
		});

		__getset(0,__proto,'latitude',function(){
			return this._latitude;
			},function(value){
			this._latitude=value;
		});

		__getset(0,__proto,'timestamp',function(){
			return this._timestamp;
			},function(value){
			this._timestamp=value;
		});

		__getset(0,__proto,'longitude',function(){
			return this._longitude;
			},function(value){
			this._longitude=value;
		});

		__getset(0,__proto,'verticalAccuracy',function(){
			return this._timestamp;
			},function(value){
			this._verticalAccuracy=value;
		});

		GeolocationEvent.getFromH5Event=function(evt){
			var rst=new GeolocationEvent("update");
			Event.copyFromByObj(rst,evt,GeolocationEvent.NAME_MAP);
			return rst;
		}

		GeolocationEvent.UPDATE="update";
		__static(GeolocationEvent,
		['NAME_MAP',function(){return this.NAME_MAP={
				"latitude":"latitude",
				"longitude":"longitude",
				"altitude":"altitude",
				"speed":"speed",
				"horizontalAccuracy":"accuracy",
				"verticalAccuracy":"altitudeAccuracy",
				"heading":"heading"
		};}

		]);
		return GeolocationEvent;
	})(Event)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/gestureevent.as
	//class iflash.events.GestureEvent extends iflash.events.Event
	var GestureEvent=(function(_super){
		function GestureEvent(type,bubbles,cancelable,phase,localX,localY,ctrlKey,altKey,shiftKey,commandKey,controlKey,_d){
			this.altKey=false;
			this.controlKey=false;
			this.ctrlKey=false;
			this.commandKey=false;
			this.shiftKey=false;
			this.localX=0;
			this.localY=0;
			this.phase=null;
			this.__stageX__=0;
			this.__stageY__=0;
			(bubbles===void 0)&& (bubbles=false);
			(cancelable===void 0)&& (cancelable=false);
			(localX===void 0)&& (localX=0);
			(localY===void 0)&& (localY=0);
			(ctrlKey===void 0)&& (ctrlKey=false);
			(altKey===void 0)&& (altKey=false);
			(shiftKey===void 0)&& (shiftKey=false);
			(commandKey===void 0)&& (commandKey=false);
			(controlKey===void 0)&& (controlKey=false);
			GestureEvent.__super.call(this,type,bubbles,cancelable,_d);
			this.altKey=altKey;
			this.controlKey=controlKey;
			this.ctrlKey=ctrlKey;
			this.commandKey=commandKey;
			this.shiftKey=shiftKey;
			this.localX=localX;
			this.localY=localY;
			this.phase=phase;
		}

		__class(GestureEvent,'iflash.events.GestureEvent',false,_super);
		var __proto=GestureEvent.prototype;
		__proto.toMouseEvent=function(){
			_super.prototype.toMouseEvent.call(this);
			Event.__helpMouseEvt__.type=/*iflash.events.MouseEvent.CLICK*/"click";
			Event.__helpMouseEvt__.bubbles=this.bubbles;
			Event.__helpMouseEvt__.cancelable=this.cancelable;
			Event.__helpMouseEvt__.relatedObject=null;
			Event.__helpMouseEvt__.mCtrlKey=this.ctrlKey;
			Event.__helpMouseEvt__.mAltKey=this.altKey;
			Event.__helpMouseEvt__.mShiftKey=this.shiftKey;
			Event.__helpMouseEvt__.buttonDown=false;
			Event.__helpMouseEvt__._lytarget=this._lytarget;
			Event.__helpMouseEvt__.lyData=this.lyData;
			Event.__helpMouseEvt__._type_=this._type_;
			return Event.__helpMouseEvt__;
		}

		__proto.updateAfterEvent=function(){}
		__getset(0,__proto,'stageX',function(){
			return this.__stageX__;
		});

		__getset(0,__proto,'stageY',function(){
			return this.__stageY__;
		});

		GestureEvent.getGestureEvent=function(){
			if(GestureEvent._gestrueEvt==null)
				GestureEvent._gestrueEvt=new GestureEvent("gestureTwoFingerTap",true,false,/*iflash.events.GesturePhase.END*/"end");
			return GestureEvent._gestrueEvt;
		}

		GestureEvent.GESTURE_TWO_FINGER_TAP="gestureTwoFingerTap";
		GestureEvent._gestrueEvt=null
		return GestureEvent;
	})(Event)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/httpstatusevent.as
	//class iflash.events.HTTPStatusEvent extends iflash.events.Event
	var HTTPStatusEvent=(function(_super){
		function HTTPStatusEvent(type,bubbles,cancelable,_d){
			this.m_responseHeaders=null;
			this.m_responseURL=null;
			this.m_status=0;
			(bubbles===void 0)&& (bubbles=false);
			(cancelable===void 0)&& (cancelable=false);
			HTTPStatusEvent.__super.call(this,type,bubbles,cancelable,_d);
		}

		__class(HTTPStatusEvent,'iflash.events.HTTPStatusEvent',false,_super);
		var __proto=HTTPStatusEvent.prototype;
		__getset(0,__proto,'responseHeaders',function(){
			return this.m_responseHeaders;
			},function(value){
			this.m_responseHeaders=value;
		});

		__getset(0,__proto,'responseURL',function(){
			return this.m_responseURL;
			},function(value){
			this.m_responseURL=value;
		});

		__getset(0,__proto,'status',function(){
			return this.m_status;
		});

		HTTPStatusEvent.HTTP_RESPONSE_STATUS="httpResponseStatus";
		HTTPStatusEvent.HTTP_STATUS="httpStatus";
		return HTTPStatusEvent;
	})(Event)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/keyboardevent.as
	//class iflash.events.KeyboardEvent extends iflash.events.Event
	var KeyboardEvent=(function(_super){
		function KeyboardEvent(type,bubbles,cancelable,charCodeValue,keyCodeValue,keyLocationValue,ctrlKeyValue,altKeyValue,shiftKeyValue){
			this._altKey=false;
			this._charCode=0;
			this._ctrlKey=false;
			this._keyCode=0;
			this._keyLocation=0;
			this._shiftKey=false;
			(bubbles===void 0)&& (bubbles=true);
			(cancelable===void 0)&& (cancelable=false);
			(charCodeValue===void 0)&& (charCodeValue=0);
			(keyCodeValue===void 0)&& (keyCodeValue=0);
			(keyLocationValue===void 0)&& (keyLocationValue=0);
			(ctrlKeyValue===void 0)&& (ctrlKeyValue=false);
			(altKeyValue===void 0)&& (altKeyValue=false);
			(shiftKeyValue===void 0)&& (shiftKeyValue=false);
			KeyboardEvent.__super.call(this,type,bubbles,cancelable);
		}

		__class(KeyboardEvent,'iflash.events.KeyboardEvent',false,_super);
		var __proto=KeyboardEvent.prototype;
		__proto.clone=LAYAFNNULL/*function(){return null}*/
		__proto.updateAfterEvent=LAYAFNVOID/*function(){}*/
		__proto.changeEvent=function(e){
			this._currentTarget_=e._currentTarget_;
			this.keyCode=e.keyCode;
			this._type_=e._type_;
			this._lytarget=e._lytarget;
			this.cancelable=e.cancelable;
			this.charCode=e.charCode;
			this.ctrlKey=e.ctrlKey;
			this.altKey=e.altKey;
			this.shiftKey=e.shiftKey;
		}

		__getset(0,__proto,'altKey',function(){
			return this._altKey;
			},function(value){
			this._altKey=value;
		});

		__getset(0,__proto,'charCode',function(){
			return this._charCode;
			},function(value){
			this._charCode=value;
		});

		__getset(0,__proto,'ctrlKey',function(){
			return this._ctrlKey;
			},function(value){
			this._ctrlKey=value;
		});

		__getset(0,__proto,'keyLocation',function(){
			return this._keyLocation;
			},function(value){
			this._keyLocation=value;
		});

		__getset(0,__proto,'keyCode',function(){
			return this._keyCode;
			},function(value){
			this._keyCode=value;
		});

		__getset(0,__proto,'shiftKey',function(){
			return this._shiftKey;
			},function(value){
			this._shiftKey=value;
		});

		KeyboardEvent.KEY_DOWN="keyDown";
		KeyboardEvent.KEY_UP="keyUp";
		return KeyboardEvent;
	})(Event)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/mouseevent.as
	//class iflash.events.MouseEvent extends iflash.events.Event
	var MouseEvent=(function(_super){
		function MouseEvent(type,bubbles,cancelable,localX,localY,relatedObject,ctrlKey,altKey,shiftKey,buttonDown,delta){
			this.mShiftKey=false;
			this.mCtrlKey=false;
			this._buttonDown=false;
			this._timestamp_=NaN;
			this.mAltKey=false;
			this.relatedObject=null;
			this._localX=0;
			this._localY=0;
			this._delta=0;
			this.nativeEvent=null;
			this.touchEvent=null;
			this.clientX=NaN;
			this.clientY=NaN;
			this.offsetX=NaN;
			this.offsetY=NaN;
			this.button=0;
			(bubbles===void 0)&& (bubbles=true);
			(cancelable===void 0)&& (cancelable=false);
			(localX===void 0)&& (localX=NaN);
			(localY===void 0)&& (localY=NaN);
			(ctrlKey===void 0)&& (ctrlKey=false);
			(altKey===void 0)&& (altKey=false);
			(shiftKey===void 0)&& (shiftKey=false);
			(buttonDown===void 0)&& (buttonDown=false);
			(delta===void 0)&& (delta=0);
			MouseEvent.__super.call(this,type,bubbles);
			this._timestamp_=-1.0;
			this.mShiftKey=shiftKey;
			this.mCtrlKey=ctrlKey;
			this.mAltKey=altKey;
			this._buttonDown=buttonDown;
			this.relatedObject=relatedObject;
			this._localX=localX;
			this._localY=localY;
			this.delta=delta;
		}

		__class(MouseEvent,'iflash.events.MouseEvent',false,_super);
		var __proto=MouseEvent.prototype;
		__proto.getTouches=function(target,phase,result){
			if (result==null)result=/*new vector.<>*/[];
			var allTouches=this.lyData;
			var numTouches=allTouches.length;
			for (var i=0;i<numTouches;++i){
				var touch=allTouches [i];
				var correctTarget=touch.isTouching(target);
				var correctPhase=(phase==null || phase==touch._phase_);
				if (correctTarget && correctPhase)result[result.length]=touch;
			}
			return result;
		}

		__proto.getTouch=function(target,phase,id){
			(id===void 0)&& (id=-1);
			this.getTouches(target,phase,MouseEvent.sTouches);
			var numTouches=MouseEvent.sTouches.length;
			if (numTouches > 0){
				var touch=null;
				if (id < 0)touch=MouseEvent.sTouches[0];
				else{
					for (var i=0;i<numTouches;++i)
					if (MouseEvent.sTouches[i].id==id){touch=MouseEvent.sTouches[i];break ;}
						}
				MouseEvent.sTouches.length=0;
				return touch;
			}
			else return null;
		}

		__proto.interactsWith=function(target){
			var result=false;
			this.getTouches(target,null,MouseEvent.sTouches);
			for (var i=MouseEvent.sTouches.length-1;i>=0;--i)
			{if (MouseEvent.sTouches[i]._phase_ !=/*iflash.events.TouchPhase.ENDED*/"ended"){result=true;break ;}}
			MouseEvent.sTouches.length=0;
			return result;
		}

		__proto.updateAfterEvent=LAYAFNVOID/*function(){}*/
		__proto.toMouseEvent=function(){
			return this;
		}

		__proto.clone=function(){
			var e=new MouseEvent(this.type,this.bubbles,this.cancelable,this.localX,this.localY,null,this.ctrlKey,this.altKey,this.shiftKey,this.buttonDown,this.delta);
			e.clientX=this.clientX;
			e.clientY=this.clientY;
			e.offsetX=this.offsetX;
			e.offsetY=this.offsetY;
			e._localX=this._localX;
			e._localY=this._localY;
			e.nativeEvent=this.nativeEvent;
			e.touchEvent=this.touchEvent;
			return e;
		}

		__proto.destory=function(){
			this.nativeEvent=null;
			this._lyData=null;
			this._lytarget=null;
			this.touchEvent=null;
			this.relatedObject=null;
			_super.prototype.destory.call(this);
		}

		__getset(0,__proto,'stageX',function(){
			return EventManager._stageX;
		});

		__getset(0,__proto,'stageY',function(){
			return EventManager._stageY;
		});

		__getset(0,__proto,'localY',function(){
			if(this._lytarget==null){
				return this._localY;
			}
			return this._lytarget.mouseY;
		});

		__getset(0,__proto,'localX',function(){
			if(this._lytarget==null){
				return this._localX;
			}
			return this._lytarget.mouseX;
		});

		__getset(0,__proto,'buttonDown',function(){
			return this._buttonDown;
			},function(value){
			this._buttonDown=value;
		});

		__getset(0,__proto,'delta',function(){
			return this._delta;
			},function(value){
			this._delta=value;
		});

		__getset(0,__proto,'lyData',_super.prototype._$get_lyData,function(value){
			_super.prototype._$set_lyData.call(this,value);
			if(!value)return;
			var numTouches=this._lyData.length;
			for (var i=0;i<numTouches;++i)
			if (this._lyData[i]._timestamp_ > this._timestamp_)
				this._timestamp_=this._lyData[i]._timestamp_;
		});

		__getset(0,__proto,'shiftKey',function(){return this.mShiftKey;});
		__getset(0,__proto,'touches',function(){return (this.lyData).concat();});
		__getset(0,__proto,'timestamp',function(){return this._timestamp_;});
		__getset(0,__proto,'altKey',function(){return this.mAltKey;});
		__getset(0,__proto,'ctrlKey',function(){return this.mCtrlKey;});
		MouseEvent.getSignType=function(type){
			type=type.toLowerCase();
			if(type=="mouseOver" || type===/*iflash.events.TouchEvent.TOUCH_OVER*/"touchOver"){
				return "mouseOver";
			}
			else if(type=="mouseOut" || type===/*iflash.events.TouchEvent.TOUCH_OUT*/"touchOut"){
				return "mouseOut";
			}
			else if(type=="mouseDown" || type===/*iflash.events.TouchEvent.TOUCH_BEGIN*/"touchBegin"){
				return "mouseDown";
			}
			else if(type=="mouseUp" || type===/*iflash.events.TouchEvent.TOUCH_END*/"touchEnd"){
				return "mouseUp";
			}
			else if(type=="click" || type===/*iflash.events.TouchEvent.TOUCH_TAP*/"touchTap"){
				return "click";
			}
			else if(type=="mouseMove" || type===/*iflash.events.TouchEvent.TOUCH_MOVE*/"touchMove"){
				return "mouseMove";
			}
			else if(type=="rollOut" || type===/*iflash.events.TouchEvent.TOUCH_ROLL_OUT*/"touchRollOut"){
				return "rollOut";
			}
			else if(type=="rollOver" || type===/*iflash.events.TouchEvent.TOUCH_ROLL_OVER*/"touchRollOver"){
				return "rollOver";
			}
			return type;
		}

		MouseEvent.copyFromSysEvent=function(e){
			var event=new MouseEvent(iflash.events.MouseEvent.SYS_MOUSE_INPUT_MAP[e.type],e.bubbles,e.cancelable,NaN,NaN,null,e.ctrlKey,e.altKey,e.shiftKey,e.buttons!=0,0);
			event.button=e.button||0;
			if(e["delta"] !=undefined){
				event.delta=e.delta;
			}
			else{
				event.delta=e.wheelDeltaY?e.wheelDeltaY/40:0;
			}
			event.nativeEvent=e;
			return event;
		}

		MouseEvent.CLICK="click";
		MouseEvent.DOUBLE_CLICK="doubleClick";
		MouseEvent.MOUSE_DOWN="mouseDown";
		MouseEvent.MOUSE_MOVE="mouseMove";
		MouseEvent.MOUSE_OUT="mouseOut";
		MouseEvent.MOUSE_OVER="mouseOver";
		MouseEvent.MOUSE_UP="mouseUp";
		MouseEvent.MOUSE_WHEEL="mouseWheel";
		MouseEvent.ROLL_OUT="rollOut";
		MouseEvent.ROLL_OVER="rollOver";
		MouseEvent.MIDDLE_CLICK="middleClick";
		MouseEvent.MIDDLE_MOUSE_DOWN="middleMouseDown";
		MouseEvent.MIDDLE_MOUSE_UP="middleMouseUp";
		MouseEvent.RIGHT_CLICK="rightClick";
		MouseEvent.RIGHT_MOUSE_DOWN="rightMouseDown";
		MouseEvent.RIGHT_MOUSE_UP="rightMouseUp";
		MouseEvent.FOCUS="focus";
		MouseEvent.BLUR="blur";
		MouseEvent.MOUSE_DRAG="drag";
		MouseEvent.MOUSE_DRAG_START="dragstart";
		MouseEvent.MOUSE_DRAG_END="dragend";
		__static(MouseEvent,
		['SYS_MOUSE_INPUT_MAP',function(){return this.SYS_MOUSE_INPUT_MAP={
				"mousedown":"mouseDown",
				"mouseup":"mouseUp",
				"mousemove":"mouseMove",
				"mousewheel":"mouseWheel"
		};},'sTouches',function(){return this.sTouches=/*new vector.<>*/[];}

		]);
		return MouseEvent;
	})(Event)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/netstatusevent.as
	//class iflash.events.NetStatusEvent extends iflash.events.Event
	var NetStatusEvent=(function(_super){
		function NetStatusEvent(type,bubbles,cancelable,info){
			this.info=null;
			(bubbles===void 0)&& (bubbles=false);
			(cancelable===void 0)&& (cancelable=false);
			this.info=info;
			NetStatusEvent.__super.call(this,type,bubbles,cancelable);
		}

		__class(NetStatusEvent,'iflash.events.NetStatusEvent',false,_super);
		NetStatusEvent.NET_STATUS="netStatus";
		return NetStatusEvent;
	})(Event)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/progressevent.as
	//class iflash.events.ProgressEvent extends iflash.events.Event
	var ProgressEvent=(function(_super){
		function ProgressEvent(type,bubbles,cancelable,bytesLoaded,bytesTotal){
			this._bytesLoaded=NaN;
			this._bytesTotal=NaN;
			(bubbles===void 0)&& (bubbles=false);
			(cancelable===void 0)&& (cancelable=false);
			(bytesLoaded===void 0)&& (bytesLoaded=0);
			(bytesTotal===void 0)&& (bytesTotal=0);
			ProgressEvent.__super.call(this,type,bubbles,cancelable);
			this._bytesLoaded=bytesLoaded;
			this._bytesTotal=bytesTotal;
		}

		__class(ProgressEvent,'iflash.events.ProgressEvent',false,_super);
		var __proto=ProgressEvent.prototype;
		__getset(0,__proto,'bytesLoaded',function(){
			return this._bytesLoaded;
			},function(value){
			this._bytesLoaded=value;
		});

		__getset(0,__proto,'bytesTotal',function(){
			return this._bytesTotal;
			},function(value){
			this._bytesTotal=value;
		});

		ProgressEvent.PROGRESS="progress";
		ProgressEvent.SOCKET_DATA="socketData";
		return ProgressEvent;
	})(Event)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/sampledataevent.as
	//class iflash.events.SampleDataEvent extends iflash.events.Event
	var SampleDataEvent=(function(_super){
		function SampleDataEvent(type,bubbles,cancelable,theposition,thedata){
			(bubbles===void 0)&& (bubbles=false);
			(cancelable===void 0)&& (cancelable=false);
			(theposition===void 0)&& (theposition=0);
			SampleDataEvent.__super.call(this,type,bubbles);
		}

		__class(SampleDataEvent,'iflash.events.SampleDataEvent',false,_super);
		var __proto=SampleDataEvent.prototype;
		__getset(0,__proto,'data',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(thedata){}*/);
		__getset(0,__proto,'position',LAYAFN0/*function(){return 0}*/,LAYAFNVOID/*function(theposition){}*/);
		SampleDataEvent.SAMPLE_DATA="sampleData";
		return SampleDataEvent;
	})(Event)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/shaderevent.as
	//class iflash.events.ShaderEvent extends iflash.events.Event
	var ShaderEvent=(function(_super){
		function ShaderEvent(type,bubbles,cancelable,bitmap,array,vector){
			(bubbles===void 0)&& (bubbles=false);
			(cancelable===void 0)&& (cancelable=false);
			ShaderEvent.__super.call(this,type);
		}

		__class(ShaderEvent,'iflash.events.ShaderEvent',false,_super);
		var __proto=ShaderEvent.prototype;
		__proto.clone=LAYAFNNULL/*function(){return null}*/
		__getset(0,__proto,'bitmapData',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(bmpData){}*/);
		__getset(0,__proto,'byteArray',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(bArray){}*/);
		__getset(0,__proto,'vector',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(v){}*/);
		ShaderEvent.COMPLETE="complete";
		return ShaderEvent;
	})(Event)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/stageorientationevent.as
	//class iflash.events.StageOrientationEvent extends iflash.events.Event
	var StageOrientationEvent=(function(_super){
		function StageOrientationEvent(type,bubbles,cancelable,beforeOrientation,afterOrientation){
			this.beforeOrientation=null;
			this.afterOrientation=null;
			(bubbles===void 0)&& (bubbles=false);
			(cancelable===void 0)&& (cancelable=false);
			this.beforeOrientation=beforeOrientation;
			this.afterOrientation=afterOrientation;
			StageOrientationEvent.__super.call(this,type,bubbles,cancelable,null);
		}

		__class(StageOrientationEvent,'iflash.events.StageOrientationEvent',false,_super);
		StageOrientationEvent.ORIENTATION_CHANGE="orientationChange";
		StageOrientationEvent.ORIENTATION_CHANGING="orientationChanging";
		return StageOrientationEvent;
	})(Event)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/statusevent.as
	//class iflash.events.StatusEvent extends iflash.events.Event
	var StatusEvent=(function(_super){
		function StatusEvent(type,bubbles,cancelable,code,level){
			this._code=null;
			this._level=null;
			(bubbles===void 0)&& (bubbles=false);
			(cancelable===void 0)&& (cancelable=false);
			(level===void 0)&& (level="");
			StatusEvent.__super.call(this,type,bubbles,cancelable);
			this._code=code;
			this._level=level;
		}

		__class(StatusEvent,'iflash.events.StatusEvent',false,_super);
		var __proto=StatusEvent.prototype;
		__getset(0,__proto,'code',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'level',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(value){}*/);
		StatusEvent.STATUS="status";
		return StatusEvent;
	})(Event)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/syncevent.as
	//class iflash.events.SyncEvent extends iflash.events.Event
	var SyncEvent=(function(_super){
		function SyncEvent(type,bubbles,cancelable,_d){
			(bubbles===void 0)&& (bubbles=false);
			(cancelable===void 0)&& (cancelable=false);
			SyncEvent.__super.call(this,type,bubbles,cancelable,_d);
		}

		__class(SyncEvent,'iflash.events.SyncEvent',false,_super);
		var __proto=SyncEvent.prototype;
		__proto.clone=LAYAFNNULL/*function(){return null}*/
		__getset(0,__proto,'changeList',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(value){}*/);
		SyncEvent.SYNC="sync";
		return SyncEvent;
	})(Event)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/throttleevent.as
	//class iflash.events.ThrottleEvent extends iflash.events.Event
	var ThrottleEvent=(function(_super){
		function ThrottleEvent(type,bubbles,cancelable,state,targetFrameRate){
			this._targetFrameRate=0.0
			this._state=/*iflash.events.ThrottleType.RESUME*/"resume";
			(bubbles===void 0)&& (bubbles=false);
			(cancelable===void 0)&& (cancelable=false);
			(targetFrameRate===void 0)&& (targetFrameRate=0);
			ThrottleEvent.__super.call(this,type,bubbles,cancelable);
			this._state=state;
			this._targetFrameRate=targetFrameRate;
		}

		__class(ThrottleEvent,'iflash.events.ThrottleEvent',false,_super);
		var __proto=ThrottleEvent.prototype;
		__proto.clone=function(){
			return new ThrottleEvent(/*iflash.events.ThrottleType.THROTTLE*/"throttle")
		}

		__getset(0,__proto,'state',function(){
			return this._state;
		});

		__getset(0,__proto,'targetFrameRate',function(){
			if (this._state==/*iflash.events.ThrottleType.PAUSE*/"pause")
				return 0.0
			else if (this._state==/*iflash.events.ThrottleType.THROTTLE*/"throttle")
			return 2.0;
			else
			return this._targetFrameRate
		});

		ThrottleEvent.THROTTLE="throttle";
		return ThrottleEvent;
	})(Event)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/timerevent.as
	//class iflash.events.TimerEvent extends iflash.events.Event
	var TimerEvent=(function(_super){
		function TimerEvent(type,bubbles,cancelable){
			(bubbles===void 0)&& (bubbles=false);
			(cancelable===void 0)&& (cancelable=false);
			TimerEvent.__super.call(this,type,bubbles,cancelable);
		}

		__class(TimerEvent,'iflash.events.TimerEvent',false,_super);
		var __proto=TimerEvent.prototype;
		__proto.clone=LAYAFNNULL/*function(){return null;}*/
		__proto.updateAfterEvent=LAYAFNVOID/*function(){}*/
		TimerEvent.TIMER="timer";
		TimerEvent.TIMER_COMPLETE="timerComplete";
		return TimerEvent;
	})(Event)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/touchevent.as
	//class iflash.events.TouchEvent extends iflash.events.Event
	var TouchEvent=(function(_super){
		function TouchEvent(type,bubbles,cancelable,touchPointID,isPrimaryTouchPoint,localX,localY,sizeX,sizeY,pressure,relatedObject,ctrlKey,altKey,shiftKey,commandKey,controlKey,timestamp,touchIntent,samples,isTouchPointCanceled,_d){
			this.altKey=false;
			this.commandKey=false;
			this.controlKey=false;
			this.ctrlKey=false;
			this.shiftKey=false;
			this.isPrimaryTouchPoint=false;
			this.timestamp=0;
			this.touchIntent=null;
			this.samples=null;
			this.isTouchPointCanceled=false;
			this._localX=0.0;
			this._localY=0.0;
			this.sizeX=0.0;
			this.sizeY=0.0;
			this.pressure=0.0;
			this.touchPointID=0;
			this.relatedObject=null;
			(bubbles===void 0)&& (bubbles=true);
			(cancelable===void 0)&& (cancelable=false);
			(touchPointID===void 0)&& (touchPointID=0);
			(isPrimaryTouchPoint===void 0)&& (isPrimaryTouchPoint=false);
			(localX===void 0)&& (localX=NaN);
			(localY===void 0)&& (localY=NaN);
			(sizeX===void 0)&& (sizeX=NaN);
			(sizeY===void 0)&& (sizeY=NaN);
			(pressure===void 0)&& (pressure=NaN);
			(ctrlKey===void 0)&& (ctrlKey=false);
			(altKey===void 0)&& (altKey=false);
			(shiftKey===void 0)&& (shiftKey=false);
			(commandKey===void 0)&& (commandKey=false);
			(controlKey===void 0)&& (controlKey=false);
			(timestamp===void 0)&& (timestamp=NaN);
			(touchIntent===void 0)&& (touchIntent="unknown");
			(isTouchPointCanceled===void 0)&& (isTouchPointCanceled=false);
			TouchEvent.__super.call(this,type,bubbles,cancelable,_d);
			this.touchPointID=touchPointID;
			this.isPrimaryTouchPoint=isPrimaryTouchPoint;
			this._localX=localX;
			this._localY=localY;
			this.sizeX=sizeX;
			this.sizeY=sizeY;
			this.pressure=pressure;
			this.relatedObject=relatedObject;
			this.ctrlKey=ctrlKey;
			this.altKey=altKey;
			this.shiftKey=shiftKey;
			this.commandKey=commandKey;
			this.controlKey=controlKey;
			this.timestamp=timestamp;
			this.touchIntent=touchIntent;
			this.samples=samples;
			this.isTouchPointCanceled=isTouchPointCanceled;
		}

		__class(TouchEvent,'iflash.events.TouchEvent',false,_super);
		var __proto=TouchEvent.prototype;
		__proto.updateAfterEvent=function(){}
		__proto.toMouseEvent=function(){
			_super.prototype.toMouseEvent.call(this);
			Event.__helpMouseEvt__.type=TouchEvent.MOUSE_INPUT_TO_TOUCH_MAP[this.type];
			Event.__helpMouseEvt__.bubbles=this.bubbles;
			Event.__helpMouseEvt__.cancelable=this.cancelable;
			Event.__helpMouseEvt__.relatedObject=this.relatedObject;
			Event.__helpMouseEvt__.mCtrlKey=this.ctrlKey;
			Event.__helpMouseEvt__.mAltKey=this.altKey;
			Event.__helpMouseEvt__.mShiftKey=this.shiftKey;
			Event.__helpMouseEvt__.buttonDown=true;
			Event.__helpMouseEvt__._lytarget=this._lytarget;
			Event.__helpMouseEvt__.lyData=this.lyData;
			Event.__helpMouseEvt__._type_=this._type_;
			Event.__helpMouseEvt__.touchEvent=this;
			return Event.__helpMouseEvt__;
		}

		__proto.clone=function(){
			var tEvt=new TouchEvent(this.type,this.bubbles,this.cancelable,this.touchPointID,this.isPrimaryTouchPoint,this._localX,this._localY
			,this.sizeX,this.sizeY,this.pressure,this.relatedObject,this.ctrlKey,this.altKey,this.shiftKey,this.commandKey
			,this.controlKey,this.timestamp,this.touchIntent,this.samples,this.isTouchPointCanceled,this.lyData);
			return tEvt;
		}

		__proto.destory=function(){
			this.samples=null;
			this.relatedObject=null;
			_super.prototype.destory.call(this);
		}

		__getset(0,__proto,'localY',function(){
			if(this._lytarget){
				this._localY=this._lytarget.mouseY;
			}
			return this._localY;
		});

		__getset(0,__proto,'localX',function(){
			if(this._lytarget){
				this._localX=this._lytarget.mouseX;
			}
			return this._localX;
		});

		__getset(0,__proto,'stageX',function(){
			return EventManager._stageX;
		});

		__getset(0,__proto,'stageY',function(){
			return EventManager._stageY;
		});

		TouchEvent.isTypeMove=function(type){
			return type=="touchmove" || type=="mousemove";
		}

		TouchEvent.isTouchType=function(type){
			return type.indexOf("touch")!=-1;
		}

		TouchEvent.touchSysEvent=function(touchEvent,callbackFunc){
			var len=touchEvent.changedTouches.length;
			var evt,changedTouch=null,touch;
			for(var i=0;i<len;i++){
				changedTouch=touchEvent.changedTouches[i];
				evt=new TouchEvent(iflash.events.TouchEvent.SYS_TOUCH_INPUT_MAP[touchEvent.type],touchEvent.bubbles,touchEvent.cancelable,
				changedTouch.identifier,i==0,0.0,0.0,changedTouch.radiusX,changedTouch.radiusY,changedTouch.force,null,touchEvent.ctrlKey,touchEvent.altKey
				,touchEvent.shiftKey,false,false,touchEvent.timeStamp,"unknown",null,false,null);
				EventManager.clientToStage(changedTouch.clientX,changedTouch.clientY);
				if(callbackFunc!=null)callbackFunc(evt);
			}
		}

		TouchEvent.TOUCH_BEGIN="touchBegin";
		TouchEvent.TOUCH_END="touchEnd";
		TouchEvent.TOUCH_MOVE="touchMove";
		TouchEvent.TOUCH_OUT="touchOut";
		TouchEvent.TOUCH_OVER="touchOver";
		TouchEvent.TOUCH_ROLL_OUT="touchRollOut";
		TouchEvent.TOUCH_ROLL_OVER="touchRollOver";
		TouchEvent.TOUCH_TAP="touchTap";
		__static(TouchEvent,
		['MOUSE_INPUT_TO_TOUCH_MAP',function(){return this.MOUSE_INPUT_TO_TOUCH_MAP={
				"mouseDown":"touchBegin",
				"mouseUp":"touchEnd",
				"mouseMove":"touchMove",
				"mouseOut":"touchOut",
				"mouseOver":"touchOver",
				"rollOut":"touchRollOut",
				"rollOver":"touchRollOver",
				"click":"touchTap",
				"touchBegin":"mouseDown",
				"touchEnd":"mouseUp",
				"touchMove":"mouseMove",
				"touchOut":"mouseOut",
				"touchOver":"mouseOver",
				"touchRollOut":"rollOut",
				"touchRollOver":"rollOver",
				"touchTap":"click"
				};},'SYS_TOUCH_INPUT_MAP',function(){return this.SYS_TOUCH_INPUT_MAP={
				"touchstart":"touchBegin",
				"touchmove":"touchMove",
				"touchend":"touchEnd",
				"touchcancel":"touchEnd"
		};}

		]);
		return TouchEvent;
	})(Event)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/utils/timer.as
	//class iflash.utils.Timer extends iflash.events.EventDispatcher
	var Timer=(function(_super){
		function Timer(delay,repeatCount){
			this._timeobj=null;
			this._delay=NaN;
			this._repeatCount=0;
			this._running=false;
			Timer.__super.call(this);
			(repeatCount===void 0)&& (repeatCount=0);
			this.delay=delay;
			this.repeatCount=repeatCount;
			this._running=false;
		}

		__class(Timer,'iflash.utils.Timer',false,_super);
		var __proto=Timer.prototype;
		__proto._ontimer_=function(tm,m,obj){
			this.lyDispatchEvent(new TimerEvent(/*iflash.events.TimerEvent.TIMER*/"timer"));
			if (this.currentCount >=this.repeatCount && this._running==true){
				if (this.repeatCount !=0){
					this._running=false;
					this.lyDispatchEvent(new TimerEvent(/*iflash.events.TimerEvent.TIMER_COMPLETE*/"timerComplete"));
				}
			}
		}

		__proto.reset=function(){
			if (this._timeobj !=null){
				if(this._timeobj.runCount<(this.repeatCount-1))
					this._timeobj.runCount=0;
				else{
					this.stop();
				}
			}
		}

		__proto.start=function(){
			this.stop();
			this._timeobj=this._timeobj || TimerCtrl.__DEFAULT__.addTimer(this,__bind(this,this._ontimer_),this.delay,this.repeatCount);
			this._running=true;
		}

		__proto.stop=function(){
			if (this._timeobj !=null){
				this._timeobj.deleted=true;
				this._timeobj=null;
			}
			this._running=false;
		}

		__getset(0,__proto,'currentCount',function(){
			if(this._timeobj!=null)
				return this._timeobj.runCount+1;
			return 0;
		});

		__getset(0,__proto,'delay',function(){
			return this._delay;
			},function(value){
			this._delay=value;
			this._timeobj && (this._timeobj.delay=value);
		});

		__getset(0,__proto,'repeatCount',function(){
			return this._repeatCount;
			},function(value){
			this._repeatCount=value;
		});

		__getset(0,__proto,'running',function(){
			return this._running;
		});

		Timer.__SPEED__=1;
		__static(Timer,
		['__STARTTIME__',function(){return this.__STARTTIME__=/*__JS__ */Date.now();}
		]);
		return Timer;
	})(EventDispatcher)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/utils/dynamicmethods.as
	//class iflash.laya.utils.DynamicMethods extends iflash.laya.utils.DynamicProperties
	var DynamicMethods=(function(_super){
		function DynamicMethods(_class,fndef,set_get,htmlNeed){
			this.args=null;
			this.setName=null;
			this.getName=null;
			this.argsClipChr=null;
			(htmlNeed===void 0)&& (htmlNeed=true);
			DynamicMethods.__super.call(this,null,null,set_get,htmlNeed);
			var strs=DynamicMethods._regMethoed.exec(fndef);
			this.setName=this.getName=strs[2];
			if (set_get){
				if ((typeof set_get=='string'))this.setName=this.getName=set_get;
				else {
					this.setName=set_get['set'];
					this.getName=set_get['get'];
				}
			}
			strs[3]=strs[3].replace(DynamicMethods._string_Trim_,'');
			var str=strs[3].split(DynamicMethods._argsClip);
			this.args=[];
			for (var i=0;i < str.length;i++){
				this.args.push(DynamicProperties.__CALCULATORTYPE__[str[i]]);
			}
			_class.prototype["??"+strs[2]]=this;
		}

		__class(DynamicMethods,'iflash.laya.utils.DynamicMethods',false,_super);
		var __proto=DynamicMethods.prototype;
		__proto.setValue=function(obj,data){
			data=data.replace(DynamicMethods._string_Trim_,'');
			var strs=data.split(DynamicMethods._argsClip);
			var max=this.args.length>strs.length?this.args.length:strs.length;
			var min=this.args.length+strs.length-max;
			for (var i=0,sz=min;i < sz;i++)
			strs[i]=this.args[i](strs[i]);
			strs.splice(i,max-min);
			obj[this.setName].apply(obj,strs);
		}

		__proto.getValue=function(obj){
			return obj[this.getName].call(obj);
		}

		__proto.toHTML=LAYAFNFALSE/*function(){return false}*/
		DynamicMethods._regMethoed=new RegExp("(\\s*)([\\w-]+)\\s*[(]\\s*((\\w\\s*)+)[)]");
		DynamicMethods._argsClip=new RegExp("\\s+");
		DynamicMethods._string_Trim_=new RegExp("(^\\s*)|(\\s*$)","g");
		return DynamicMethods;
	})(DynamicProperties)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/errorevent.as
	//class iflash.events.ErrorEvent extends iflash.events.TextEvent
	var ErrorEvent=(function(_super){
		function ErrorEvent(type,bubbles,cancelable,text,id){
			this.m_errorID=0;
			(bubbles===void 0)&& (bubbles=false);
			(cancelable===void 0)&& (cancelable=false);
			(text===void 0)&& (text="");
			(id===void 0)&& (id=0);
			ErrorEvent.__super.call(this,type,bubbles,cancelable,text);
			this.m_errorID=id;
		}

		__class(ErrorEvent,'iflash.events.ErrorEvent',false,_super);
		var __proto=ErrorEvent.prototype;
		__proto.clone=function(){
			return new ErrorEvent(this.type,this.bubbles,this.cancelable,this.text,this.m_errorID);
		}

		__proto.toString=function(){
			return this.formatToString("ErrorEvent","type","bubbles","cancelable","eventPhase","text","errorID");
		}

		__getset(0,__proto,'errorID',function(){
			return this.m_errorID;
		});

		ErrorEvent.ERROR="error";
		return ErrorEvent;
	})(TextEvent)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/dataevent.as
	//class iflash.events.DataEvent extends iflash.events.TextEvent
	var DataEvent=(function(_super){
		function DataEvent(type,bubbles,cancelable,data){
			(bubbles===void 0)&& (bubbles=false);
			(cancelable===void 0)&& (cancelable=false);
			(data===void 0)&& (data="");
			DataEvent.__super.call(this,type,bubbles,cancelable);
		}

		__class(DataEvent,'iflash.events.DataEvent',false,_super);
		var __proto=DataEvent.prototype;
		__getset(0,__proto,'data',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(value){}*/);
		DataEvent.DATA="data";
		DataEvent.UPLOAD_COMPLETE_DATA="uploadCompleteData";
		return DataEvent;
	})(TextEvent)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/fullscreenevent.as
	//class iflash.events.FullScreenEvent extends iflash.events.ActivityEvent
	var FullScreenEvent=(function(_super){
		function FullScreenEvent(type,bubbles,cancelable,activating){
			(bubbles===void 0)&& (bubbles=false);
			(cancelable===void 0)&& (cancelable=false);
			(activating===void 0)&& (activating=false);
			FullScreenEvent.__super.call(this,type,bubbles,cancelable,activating);
		}

		__class(FullScreenEvent,'iflash.events.FullScreenEvent',false,_super);
		var __proto=FullScreenEvent.prototype;
		__getset(0,__proto,'fullScreen',LAYAFNFALSE/*function(){return false}*/);
		FullScreenEvent.FULL_SCREEN="fullScreen";
		return FullScreenEvent;
	})(ActivityEvent)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/imeevent.as
	//class iflash.events.IMEEvent extends iflash.events.TextEvent
	var IMEEvent=(function(_super){
		function IMEEvent(type,bubbles,cancelable,text){
			(bubbles===void 0)&& (bubbles=false);
			(cancelable===void 0)&& (cancelable=false);
			(text===void 0)&& (text="");
			IMEEvent.__super.call(this,type,bubbles,cancelable,text);
		}

		__class(IMEEvent,'iflash.events.IMEEvent',false,_super);
		var __proto=IMEEvent.prototype;
		__proto.clone=function(){
			return null;
		}

		__getset(0,__proto,'imeClient',function(){
			return null;
			},function(value){;
		});

		IMEEvent.IME_COMPOSITION="imeComposition";
		IMEEvent.IME_START_COMPOSITION="imeStartComposition";
		return IMEEvent;
	})(TextEvent)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/pressandtapgestureevent.as
	//class iflash.events.PressAndTapGestureEvent extends iflash.events.GestureEvent
	var PressAndTapGestureEvent=(function(_super){
		function PressAndTapGestureEvent(type,bubbles,cancelable,phase,localX,localY,ctrlKey,altKey,shiftKey,commandKey,controlKey,_d){
			this.tapLocalX=0;
			this.tapLocalY=0;
			this.tapStageX=0;
			this.tapStageY=0;
			(bubbles===void 0)&& (bubbles=false);
			(cancelable===void 0)&& (cancelable=false);
			(localX===void 0)&& (localX=0);
			(localY===void 0)&& (localY=0);
			(ctrlKey===void 0)&& (ctrlKey=false);
			(altKey===void 0)&& (altKey=false);
			(shiftKey===void 0)&& (shiftKey=false);
			(commandKey===void 0)&& (commandKey=false);
			(controlKey===void 0)&& (controlKey=false);
			PressAndTapGestureEvent.__super.call(this,type,bubbles,cancelable,phase,localX,localY,ctrlKey,altKey,shiftKey,commandKey,controlKey,_d);
		}

		__class(PressAndTapGestureEvent,'iflash.events.PressAndTapGestureEvent',false,_super);
		PressAndTapGestureEvent.getInstance=function(){
			if(PressAndTapGestureEvent._instance==null)
				PressAndTapGestureEvent._instance=new PressAndTapGestureEvent(/*CLASS CONST:iflash.events.PressAndTapGestureEvent.GESTURE_PRESS_AND_TAP*/"gesturePressAndTap",true,false,/*iflash.events.GesturePhase.ALL*/"all");
			return PressAndTapGestureEvent._instance;
		}

		PressAndTapGestureEvent.GESTURE_PRESS_AND_TAP="gesturePressAndTap";
		PressAndTapGestureEvent._instance=null
		return PressAndTapGestureEvent;
	})(GestureEvent)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/transformgestureevent.as
	//class iflash.events.TransformGestureEvent extends iflash.events.GestureEvent
	var TransformGestureEvent=(function(_super){
		function TransformGestureEvent(type,bubbles,cancelable,phase,localX,localY,scaleX,scaleY,rotation,offsetX,offsetY,ctrlKey,altKey,shiftKey,commandKey,controlKey,_d){
			this.offsetX=0;
			this.offsetY=0;
			this.rotation=0;
			this.scaleX=0;
			this.scaleY=0;
			(bubbles===void 0)&& (bubbles=false);
			(cancelable===void 0)&& (cancelable=false);
			(localX===void 0)&& (localX=0);
			(localY===void 0)&& (localY=0);
			(scaleX===void 0)&& (scaleX=1);
			(scaleY===void 0)&& (scaleY=1);
			(rotation===void 0)&& (rotation=0);
			(offsetX===void 0)&& (offsetX=0);
			(offsetY===void 0)&& (offsetY=0);
			(ctrlKey===void 0)&& (ctrlKey=false);
			(altKey===void 0)&& (altKey=false);
			(shiftKey===void 0)&& (shiftKey=false);
			(commandKey===void 0)&& (commandKey=false);
			(controlKey===void 0)&& (controlKey=false);
			TransformGestureEvent.__super.call(this,type,bubbles,cancelable,phase,localX,localY,ctrlKey,altKey,shiftKey,commandKey,controlKey,_d);
			this.offsetX=offsetX;
			this.offsetY=offsetY;
			this.rotation=rotation;
			this.scaleX=scaleX;
			this.scaleY=scaleY;
		}

		__class(TransformGestureEvent,'iflash.events.TransformGestureEvent',false,_super);
		var __proto=TransformGestureEvent.prototype;
		__proto.toMouseEvent=function(){
			_super.prototype.toMouseEvent.call(this);
			Event.__helpMouseEvt__.type=/*iflash.events.MouseEvent.MOUSE_MOVE*/"mouseMove";
			Event.__helpMouseEvt__.buttonDown=true;
			return Event.__helpMouseEvt__;
		}

		TransformGestureEvent.GESTURE_PAN="gesturePan";
		TransformGestureEvent.GESTURE_ROTATE="gestureRotate";
		TransformGestureEvent.GESTURE_SWIPE="gestureSwipe";
		TransformGestureEvent.GESTURE_ZOOM="gestureZoom";
		return TransformGestureEvent;
	})(GestureEvent)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/utils/setintervaltimer.as
	//class iflash.utils.SetIntervalTimer extends iflash.utils.Timer
	var SetIntervalTimer=(function(_super){
		function SetIntervalTimer(closure,delay,repeats,rest){
			this.id=0;
			this.closure=null;
			this.rest=null;
			SetIntervalTimer.__super.call(this,delay,repeats?0:1);
			this.closure=closure;
			this.rest=rest;
			this.addEventListener(repeats? /*iflash.events.TimerEvent.TIMER*/"timer":/*iflash.events.TimerEvent.TIMER_COMPLETE*/"timerComplete",__bind(this,this.onTimer));
			this.start();
			this.id=SetIntervalTimer.intervals.length+1;
			SetIntervalTimer.intervals.push(this);
		}

		__class(SetIntervalTimer,'iflash.utils.SetIntervalTimer',false,_super);
		var __proto=SetIntervalTimer.prototype;
		__proto.onTimer=function(event){
			this.closure.apply(null,this.rest);
			if(this.repeatCount==1){
				if(SetIntervalTimer.intervals[this.id-1]==this){
					delete SetIntervalTimer.intervals[this.id-1];
					true;
				}
			}
		}

		SetIntervalTimer.clearInterval=function(id_to_clear){
			id_to_clear--;
			if(((SetIntervalTimer.intervals[id_to_clear])instanceof iflash.utils.SetIntervalTimer )){
				SetIntervalTimer.intervals[id_to_clear].stop();
				delete SetIntervalTimer.intervals[id_to_clear];
				true;
			}
		}

		SetIntervalTimer.intervals=[];
		return SetIntervalTimer;
	})(Timer)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/asyncerrorevent.as
	//class iflash.events.AsyncErrorEvent extends iflash.events.ErrorEvent
	var AsyncErrorEvent=(function(_super){
		function AsyncErrorEvent(type,bubbles,cancelable,text,error){
			this.error=null;
			(bubbles===void 0)&& (bubbles=false);
			(cancelable===void 0)&& (cancelable=false);
			(text===void 0)&& (text="");
			AsyncErrorEvent.__super.call(this,type,bubbles,cancelable,text);
		}

		__class(AsyncErrorEvent,'iflash.events.AsyncErrorEvent',false,_super);
		var __proto=AsyncErrorEvent.prototype;
		__proto.clone=LAYAFNNULL/*function(){return null}*/
		AsyncErrorEvent.ASYNC_ERROR="asyncError";
		return AsyncErrorEvent;
	})(ErrorEvent)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/ioerrorevent.as
	//class iflash.events.IOErrorEvent extends iflash.events.ErrorEvent
	var IOErrorEvent=(function(_super){
		function IOErrorEvent(type,bubbles,cancelable,text,id){
			(bubbles===void 0)&& (bubbles=false);
			(cancelable===void 0)&& (cancelable=false);
			(text===void 0)&& (text="");
			(id===void 0)&& (id=0);
			IOErrorEvent.__super.call(this,type,bubbles,cancelable,text,id);
		}

		__class(IOErrorEvent,'iflash.events.IOErrorEvent',false,_super);
		IOErrorEvent.DISK_ERROR="disk_error";
		IOErrorEvent.IO_ERROR="ioError";
		IOErrorEvent.NETWORK_ERROR="network_error";
		IOErrorEvent.VERIFY_ERROR="verify_error";
		return IOErrorEvent;
	})(ErrorEvent)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/securityerrorevent.as
	//class iflash.events.SecurityErrorEvent extends iflash.events.ErrorEvent
	var SecurityErrorEvent=(function(_super){
		function SecurityErrorEvent(type,bubbles,cancelable,text,id){
			(bubbles===void 0)&& (bubbles=false);
			(cancelable===void 0)&& (cancelable=false);
			(text===void 0)&& (text="");
			(id===void 0)&& (id=0);
			SecurityErrorEvent.__super.call(this,type,bubbles,cancelable,text,id);
		}

		__class(SecurityErrorEvent,'iflash.events.SecurityErrorEvent',false,_super);
		SecurityErrorEvent.SECURITY_ERROR="securityError";
		return SecurityErrorEvent;
	})(ErrorEvent)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/events/uncaughterrorevent.as
	//class iflash.events.UncaughtErrorEvent extends iflash.events.ErrorEvent
	var UncaughtErrorEvent=(function(_super){
		function UncaughtErrorEvent(type,bubbles,cancelable,error_in,id){
			(type===void 0)&& (type="uncaughtError");
			(bubbles===void 0)&& (bubbles=true);
			(cancelable===void 0)&& (cancelable=true);
			(id===void 0)&& (id=0);
			UncaughtErrorEvent.__super.call(this,type,bubbles,cancelable,error_in,id);
		}

		__class(UncaughtErrorEvent,'iflash.events.UncaughtErrorEvent',false,_super);
		var __proto=UncaughtErrorEvent.prototype;
		__getset(0,__proto,'error',LAYAFNSTR/*function(){return ""}*/);
		UncaughtErrorEvent.UNCAUGHT_ERROR="uncaughtError";
		return UncaughtErrorEvent;
	})(ErrorEvent)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/accessibility/accessibilityimplementation.as
	//class iflash.accessibility.AccessibilityImplementation
	var AccessibilityImplementation=(function(){
		function AccessibilityImplementation(){
			this.errno=0;
			this.stub=false;
		}

		__class(AccessibilityImplementation,'iflash.accessibility.AccessibilityImplementation',true);
		var __proto=AccessibilityImplementation.prototype;
		__proto.accDoDefaultAction=LAYAFNVOID/*function(childID){}*/
		__proto.accLocation=LAYAFNNULL/*function(childID){return null}*/
		__proto.accSelect=LAYAFNVOID/*function(operation,childID){}*/
		__proto.get_accDefaultAction=LAYAFNSTR/*function(childID){return ""}*/
		__proto.get_accFocus=LAYAFN0/*function(){return 0}*/
		__proto.get_accName=LAYAFNSTR/*function(childID){return ""}*/
		__proto.get_accRole=LAYAFN0/*function(childID){return 0}*/
		__proto.get_accSelection=LAYAFNARRAY/*function(){return []}*/
		__proto.get_accState=LAYAFN0/*function(childID){return 0}*/
		__proto.get_accValue=LAYAFNSTR/*function(childID){return ""}*/
		__proto.getChildIDArray=LAYAFNARRAY/*function(){return []}*/
		__proto.isLabeledBy=LAYAFNFALSE/*function(labelBounds){return false}*/
		return AccessibilityImplementation;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/bitmapdata.as
	//class iflash.display.BitmapData
	var BitmapData=(function(){
		function BitmapData(w,h,transparent,color){
			this.paint=null;
			this._canvas_=null;
			this._type_=0;
			this._context_=null;
			this._width_=NaN;
			this._height_=NaN;
			this.transparent=false;
			this._url=null;
			this._rect_=new Rectangle();
			(w===void 0)&& (w=0);
			(h===void 0)&& (h=0);
			(transparent===void 0)&& (transparent=true);
			(color===void 0)&& (color=0xFFFFFF);
			this.transparent=transparent;
			this._rect_.x=this._rect_.y=0;
			this._rect_.width=this._width_=w;
			this._rect_.height=this._height_=h;
			this.setType(2);
			if (!this.transparent){
				this._createCMD_();
				this._fillRect_(new Rectangle(0,0,w,h),color);
			}
		}

		__class(BitmapData,'iflash.display.BitmapData',true);
		var __proto=BitmapData.prototype;
		__proto.paintCanvas=function(ctx,x,y,w,h){
			if(ctx.width !=0 && ctx.height !=0 && this._canvas_ && this._canvas_.width !=0 && this._canvas_.height !=0){
				this._canvas_&&ctx.drawImage(this._canvas_,0,0,this._canvas_.width,this._canvas_.height,x,y,w,h);
			}
		}

		__proto.paintCmd=function(ctx,x,y,w,h){
			this._canvas_ && this._canvas_.paint(ctx,x,y,w,h);
		}

		__proto.setType=function(value){
			this._type_=value;
			this.paint=this._type_==1 ? this.paintCanvas:this.paintCmd;
		}

		__proto.clone=function(){
			return this.copyTo(new BitmapData());
		}

		__proto.size=function(w,h){
			this._width_=w;
			this._height_=h;
		}

		__proto.copyTo=function(dec){
			dec._height_=this._height_;
			dec._width_=this._width_;
			dec._rect_=this._rect_.clone();
			this._canvas_&&(dec._canvas_=this._canvas_.clone());
			dec._context_=dec.type==1?dec._canvas_.getContext("2d"):dec._canvas_;
			return dec;
		}

		__proto.initBitmapdata=function(src){
			var __image=Browser.document.createElement("image");
			__image.onload=function (){
				this.setImage(__image);
			};
			__image.src=src;
			if(Laya.RENDERBYCANVAS)DisplayUnit._insertUnit_(this,DrawBitmapData._DEFAULT_);
			return false;
		}

		__proto.destroy=function(){
			this._canvas_=null;
			this._context_=null;
		}

		__proto.setCanvas=function(data){
			this._canvas_=data;
			this._context_=this._canvas_.getContext('2d');
			if(this._width_==0||this._height_==0){
				this._width_=data.width;
				this._height_=data.height;
			}
		}

		__proto.setImage=function(data){
			if(this._width_==0||this._height_==0){
				this._width_=data.width;
				this._height_=data.height;
			}
			if (!this._canvas_){
				if (this._type_==2){
					this._canvas_=new VirtualCanvas();
					this._canvas_.size(this._width_,this._height_);
					this._canvas_.setImage(data);
					this._context_=this._canvas_.getContext("2d");
				}
				else{
					this._canvas_=this._canvas_||Canvas.create();
					this._canvas_.size(this._width_,this._height_);
					this._context_=this._canvas_.getContext("2d");
					this._context_.drawImage(data,0,0);
				}
			}
			else{
				if (this._type_==2)
					this._canvas_.changeImage(data);
				else
				this._context_.drawImage(data,0,0);
			}
		}

		__proto.fillRect=function(rect,color){
			this._createCMD_();
			if(color==0){
				this._context_.clearRect(rect.left,rect.top,rect.width,rect.height);
			}
			else{
				this._fillRect_(rect,color);
			}
		}

		__proto._fillRect_=function(rect,color){
			this._context_.save();
			var s,len=0,str="";
			if(color<=0xffffff){
				s=color.toString(16).toUpperCase();
				len=6-s.length;
				}else {
				var newColor=color % 0x1000000;
				var alpha=Laya.__parseInt(color / 0x1000000+"");
				this._context_.globalAlpha=alpha / 255;
				s=newColor.toString(16);
			}
			if(s.length<6){
				for(var i=0;i<len;i++){
					str+=0;
				}
			}
			s="#"+str+s;
			this._context_.fillStyle=s;
			this._context_.fillRect(rect.left,rect.top,rect.width,rect.height);
			this._context_.restore();
		}

		__proto._createCMD_=function(){
			if (this._canvas_)return this._canvas_;
			this._canvas_=this._type_==2? Browser.document.createElement("virtualBitmap"):Canvas.create();
			this._context_=this.type==1? this._canvas_.getContext("2d"):this._canvas_;
			this._canvas_.size(this.width,this.height);
			return this._canvas_;
		}

		__proto.isOk=function(){
			if (this._canvas_ && this._canvas_.isReady())
				return true;
			return false;
		}

		__proto.setComplete=function(callback){
			this._canvas_.onComplete=callback;
		}

		__proto.draw=function(source,matrix,colorTransform,blendMode,clipRect,smoothing){
			(smoothing===void 0)&& (smoothing=false);
			var tempCanvas;
			if (clipRect==null)clipRect=new Rectangle(0,0,this.width,this.height);
			if(clipRect.right > this.width)
				clipRect.width=this.width-clipRect.x;
			if(clipRect.bottom>this.height)
				clipRect.height=this.height-clipRect.y;
			this._createCMD_();
			if ((source instanceof iflash.display.BitmapData )){
				tempCanvas=source._canvas_;
			}
			else{
				tempCanvas=new VirtualCanvas();
				tempCanvas.size(source.width,source.height);
				source._lyToBody_();
				source.conchPaint(tempCanvas,0,0,true);
			}
			if(this._context_){
				if (matrix){
					this._context_.drawMartixImage(tempCanvas,matrix,clipRect);
				}
				else{
					this._context_.drawImage(tempCanvas,clipRect.x,clipRect.y,clipRect.width,clipRect.height,clipRect.x,clipRect.y,clipRect.width,clipRect.height);
				}
			}
		}

		__proto.scroll=LAYAFNVOID/*function(x,y){}*/
		__proto.dispose=function(){
			this._canvas_=null;
			this._context_=null;
		}

		__proto.isReady=function(){
			return this._canvas_!=null;
		}

		__proto.setPixels=function(rect,inputData,url){
			this._width_=rect.width;
			this._height_=rect.height;
			var imgdata={};
			imgdata.data=inputData;
			imgdata.width=rect.width;
			imgdata.height=rect.height;
			if (Laya.CONCHVER || Laya.FLASHVER){
				var img=Browser.document.createElement('img');
				this.setImage(img);
				img.putImageData(url,imgdata,0,0,null);
			}
			this._url=url;
			return;
		}

		__proto.getPixel=LAYAFN0/*function(x,y){return 0}*/
		__proto.clear=function(){
			this._context_ && this._context_.clearRect(0,0,this._width_,this._height_);
		}

		__proto.copyPixels=function(sourceBitmapData,sourceRect,destPoint,alphaBitmapData,alphaPoint,mergeAlpha){
			(mergeAlpha===void 0)&& (mergeAlpha=false);
			var w=this._width_;
			var h=this._height_;
			destPoint=destPoint || Point.__DEFAULT__;
			var dx=destPoint.x,dy=destPoint.y,sx=sourceRect.left,sy=sourceRect.top,sw=sourceRect.width,sh=sourceRect.height;
			if (dx < 0){
				sx-=dx;sw+=dx;
				dx=0;
			}
			if (dy < 0){
				sy-=dy;sh+=dy;
				dy=0;
			}
			if(sw+dx > this.width)
				sw=this.width-dx;
			if(sh+dy>this.height)
				sh=this.height-dy;
			if (sourceBitmapData.width < sw)
				sw=sourceBitmapData.width;
			else if(sourceBitmapData.height < sh)
			sh=sourceBitmapData.height;
			if (this._canvas_==null){this.size(w||sw,h||sh);this._createCMD_();}
				!mergeAlpha&& this._canvas_.clearRect(dx,dy,sw,sh);
			sourceBitmapData._canvas_&&this._canvas_.drawImage(sourceBitmapData._canvas_,sx,sy,Math.min(sw,this._width_),Math.min(this._height_,sh),dx,dy,Math.min(sw,this._width_),Math.min(this._height_,sh));
		}

		__proto.getPixel32=function(x,y){
			return 0xff9900;;
		}

		__proto.lock=LAYAFNVOID/*function(){}*/
		__proto.unlock=LAYAFNVOID/*function(){}*/
		__proto.setPixel=LAYAFNVOID/*function(x,y,color){}*/
		__proto.getCanvas=function(){
			if (this._type_==1)return this._canvas_;
			else{
				if (this._canvas_.isNormal())
					return this._canvas_.getImage();
				var canvas=Canvas.create();
				canvas.size(this._width_,this._height_);
				var context=canvas.getContext("2d");
				canvas.context=context;
				this.paintCmd(context,0,0,this._width_,this._height_);
				return canvas;
			}
		}

		__proto.getCanvasII=function(){
			if (this._canvas_.isNormal())
				return this._canvas_.getImage();
			else{
				return null;
			}
		}

		__proto.getColorBoundsRect=function(mask,color,findColor){
			(findColor===void 0)&& (findColor=true);
			return this.rect;
		}

		__proto.copyChannel=LAYAFNVOID/*function(sourceBitmapData,sourceRect,destPoint,sourceChannel,destChannel){}*/
		__proto.colorTransform=LAYAFNVOID/*function(rect,colorTransform){}*/
		__proto.applyFilter=LAYAFNVOID/*function(sourceBitmapData,sourceRect,destPoint,filter){}*/
		__proto.setPixel32=LAYAFNVOID/*function(x,y,color){}*/
		__proto.threshold=function(sourceBitmapData,sourceRect,destPoint,operation,threshold,color,mask,copySource){
			(color===void 0)&& (color=0);
			(mask===void 0)&& (mask=0xFFFFFFFF);
			(copySource===void 0)&& (copySource=false);
			return 0}
		__proto.getPixels=LAYAFNNULL/*function(rect){return null}*/
		__proto.histogram=function(hRect){
			return new Array
		}

		__proto.hitTest=function(firstPoint,firstAlphaThreshold,secondObject,secondBitmapDataPoint,secondAlphaThreshold){
			(secondAlphaThreshold===void 0)&& (secondAlphaThreshold=1);
			return false}
		__proto.compare=LAYAFNNULL/*function(otherBitmapData){return null}*/
		__proto.generateFilterRect=LAYAFNNULL/*function(sourceRect,filter){return null}*/
		__getset(0,__proto,'type',function(){
			return this._type_;
		});

		__getset(0,__proto,'width',function(){
			return this._width_;
			},function(w){
			this.size(w,this._height_);
		});

		__getset(0,__proto,'rect',function(){
			this._rect_.width=this._width_;
			this._rect_.height=this._height_;
			return this._rect_;
		});

		__getset(0,__proto,'height',function(){
			return this._height_;
			},function(h){
			this.size(this._width_,h);
		});

		__getset(0,__proto,'url',function(){
			return this._url;
		});

		BitmapData.CANVAS=1;
		BitmapData.CMD=2;
		return BitmapData;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/bitmapdatachannel.as
	//class iflash.display.BitmapDataChannel
	var BitmapDataChannel=(function(){
		function BitmapDataChannel(){}
		__class(BitmapDataChannel,'iflash.display.BitmapDataChannel',true);
		BitmapDataChannel.ALPHA=8;
		BitmapDataChannel.BLUE=4;
		BitmapDataChannel.GREEN=2;
		BitmapDataChannel.RED=1;
		return BitmapDataChannel;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/blendmode.as
	//class iflash.display.BlendMode
	var BlendMode=(function(){
		function BlendMode(){
			;
		}

		__class(BlendMode,'iflash.display.BlendMode',true);
		BlendMode.NORMAL="normal";
		BlendMode.LAYER="layer";
		BlendMode.MULTIPLY="multiply";
		BlendMode.SCREEN="screen";
		BlendMode.LIGHTEN="lighten";
		BlendMode.DARKEN="darken";
		BlendMode.ADD="add";
		BlendMode.SUBTRACT="subtract";
		BlendMode.DIFFERENCE="difference";
		BlendMode.INVERT="invert";
		BlendMode.OVERLAY="overlay";
		BlendMode.HARDLIGHT="hardlight";
		BlendMode.ALPHA="alpha";
		BlendMode.ERASE="erase";
		BlendMode.SHADER="shader";
		return BlendMode;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/capsstyle.as
	//class iflash.display.CapsStyle
	var CapsStyle=(function(){
		function CapsStyle(){}
		__class(CapsStyle,'iflash.display.CapsStyle',true);
		CapsStyle.ROUND="round";
		CapsStyle.NONE="none";
		CapsStyle.SQUARE="square";
		return CapsStyle;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/framelabel.as
	//class iflash.display.FrameLabel
	var FrameLabel=(function(){
		function FrameLabel(){
			this.frame=0;
			this.name=null;
		}

		__class(FrameLabel,'iflash.display.FrameLabel',true);
		return FrameLabel;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/gradienttype.as
	//class iflash.display.GradientType
	var GradientType=(function(){
		function GradientType(){}
		__class(GradientType,'iflash.display.GradientType',true);
		GradientType.LINEAR="linear";
		GradientType.RADIAL="radial";
		return GradientType;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/graphics.as
	//class iflash.display.Graphics
	var Graphics=(function(){
		function Graphics(ower){
			this.ower=null;
			this._canvas_=null;
			this._context_=null;
			this._rendercomds_=[];
			this._rendercomdsOffset_=0;
			this.width=0;
			this.height=0;
			this.bitmapFlag=false;
			this.x=0;
			this.y=0;
			this._rectArea=null;
			this.isFill=false;
			this._oddeven=0;
			this._beginPos=null;
			this.prefill=null;
			this.isDrawGraphic=false;
			this.lythickness=0;
			this.lystorkeStyle=false;
			this.lystroke=false;
			this.isMoveto=false;
			this._minX=0;
			this._minY=0;
			this._maxX=0;
			this._maxY=0;
			this._lastX=0;
			this._lastY=0;
			this._helprec=new Rectangle();
			this._pointMove=new Point();
			this.ower=ower;
			this._createCanvas_();
		}

		__class(Graphics,'iflash.display.Graphics',true);
		var __proto=Graphics.prototype;
		__proto._createCanvas_=function(){
			if(!this._canvas_){
				this._canvas_=new VirtualCanvas();
				this._context_=this._canvas_.getContext("2d");
				this._rectArea=new Rectangle();
			}
		}

		__proto.hasUse=function(){
			return this._rendercomds_.length > 0;
		}

		__proto._expandSize_=function(rect){
			if(!this._rectArea){
				this._rectArea=rect.clone();
			}
			else{
				this._rectArea=this._rectArea.union(rect);
			}
			this.width=Math.max(this.width,this._rectArea.width+this.lythickness);
			this.height=Math.max(this.height,this._rectArea.height+this.lythickness);
			this.ower._height_=this.height;
			this.ower._width_=this.width;
			this.x=this._rectArea.x;
			this.y=this._rectArea.y;
			this._canvas_.size(this.width,this.height);
		}

		__proto.isReady=function(){
			return this._canvas_&&((this.width>0&&this.height>0)||this.lystroke);
		}

		__proto.beginBitmapFill=function(bitmap,matrix,repeat,smooth){
			(repeat===void 0)&& (repeat=true);
			(smooth===void 0)&& (smooth=false);
			this._rendercomds_.push([null,3,[bitmap,matrix,repeat,smooth]]);
			this.bitmapFlag=true;
		}

		__proto.beginFill=function(color,alpha){
			(alpha===void 0)&& (alpha=1);
			this._oddeven=0;
			this.isFill=true;
			var s=color.toString(16).toUpperCase();
			var len=6-s.length,str="";
			if(s.length<6){
				for(var i=0;i<len;i++){
					str+=0;
				}
			};
			var al
			al=(Laya.__parseInt(alpha*0xff+"")).toString(16);
			if(al.length<2){
				al="0"+al;
			}
			s=str+s;
			var r=color>>16;
			var g=(color&0x00ff00)>>8;
			var b=color&0x0000ff;
			var fillStyle='rgba('+r+','+g+','+b+','+alpha+')';
			if (Laya.CONCHVER)fillStyle="#"+al+s;
			this._context_.fillStyle=fillStyle;
			this.bitmapFlag=false;
		}

		__proto.beginGradientFill=function(type,colors,alphas,ratios,matrix,spreadMethod,interpolationMethod,focalPointRatio){
			(spreadMethod===void 0)&& (spreadMethod="pad");
			(interpolationMethod===void 0)&& (interpolationMethod="rgb");
			(focalPointRatio===void 0)&& (focalPointRatio=0);
		}

		__proto.beginShaderFill=LAYAFNVOID/*function(shader,matrix){}*/
		__proto.clear=function(){
			this.width=this.height=this.x=this.y=0;
			this.lystroke=this.isFill=false;
			this.lystorkeStyle=false;
			this._rectArea=null;
			this.lythickness=0;
			this._context_.globalCompositeOperation="source-over";
			this._oddeven=0;
			this._minX=0;
			this._minY=0;
			this._maxX=0;
			this._maxY=0;
			this.isMoveto=false;
			this._rendercomds_.length=0;
			this._rendercomdsOffset_=0;
			this._canvas_&&this._canvas_.clearRect(0,0,this._canvas_.width,this._canvas_.height);
		}

		__proto.copyFrom=LAYAFNVOID/*function(sourceGraphics){}*/
		__proto.cubicCurveTo=function(controlX1,controlY1,controlX2,controlY2,anchorX,anchorY){
			this.setxy(controlX1,controlY1);
			this._addplug_();
			this._context_.bezierCurveTo(controlX1,controlY1,controlX2,controlY2,anchorX,anchorY);
			if (this.lystorkeStyle)this._context_.stroke();
			if (this.isFill)this._context_.fill();
		}

		__proto.curveTo=function(controlX,controlY,anchorX,anchorY){
			this._addplug_()
			this.setxy(controlX,controlY);
			this._context_.quadraticCurveTo(controlX,controlY,anchorX,anchorY);
			if (this.isFill)this._context_.fill();
			this._context_.stroke();
		}

		__proto.drawCircle=function(x,y,r){
			this._oddeven++;
			var w=x+r;
			var h=y+r;
			this._addplug_();
			this.setxy(x-r,y-r);
			this._helprec.x=x-r;
			this._helprec.y=y-r;
			this._helprec.width=this._helprec.height=r*2;
			this._expandSize_(this._helprec);
			this._context_.beginPath();
			this._context_.arc(x,y,r,0,Math.PI *2,true);
			this._context_.closePath();
			if (this.isFill)this._context_.fill();
			if (this.lystorkeStyle)this._context_.stroke();
		}

		__proto.drawEllipse=function(x,y,a,b){
			this._addplug_();
			this.setxy(x,y);
			this._helprec.x=x-a;
			this._helprec.y=y-b;
			this._helprec.width=a;this._helprec.height=b;
			this._expandSize_(this._helprec);
			this._context_.save();
			var r=(a > b)? a :b;
			var ratioX=a / r*0.5;
			var ratioY=b / r*0.5;
			this._context_.scale(ratioX,ratioY);
			this._context_.beginPath();
			this._context_.arc((x+a*0.5)/ ratioX,(y+b*0.5)/ ratioY,r,0,2 *Math.PI,true);
			this._context_.closePath();
			if (this.isFill)this._context_.fill();
			if (this.lystorkeStyle)this._context_.stroke();
			this._context_.restore();
		}

		__proto.drawGraphicsData=LAYAFNVOID/*function(graphicsData){}*/
		__proto.drawPath=function(commands,data,winding){
			(winding===void 0)&& (winding="evenOdd");
		}

		__proto._addplug_=function(){
			if(this._oddeven>1){
				this._context_.globalCompositeOperation="xor";
			}
			if (!this.isDrawGraphic){
				if(Laya.RENDERBYCANVAS)
					DisplayUnit._insertUnit_(this.ower,DrawGraphics._DEFAULT_);
				else{
					this.ower._modle_.vcanvas(this._canvas_);
				}
				this.isDrawGraphic=true;
			}
		}

		__proto.drawRect=function(x,y,w,h){
			this._oddeven++;
			/*__JS__ */x=parseFloat(x);y=parseFloat(y);w=parseFloat(w);h=parseFloat(h);
			this._addplug_();
			this.setxy(x,y);
			!this._beginPos && (this._beginPos=new Point());
			this._beginPos.x=x;
			this._beginPos.y=y;
			this._helprec.x=x;this._helprec.y=y;this._helprec.width=w;this._helprec.height=h;
			this._expandSize_(this._helprec);
			if (!this.bitmapFlag){
				if (this.lystorkeStyle){
					if (this.isFill)this._context_.fillRect(x,y,w,h);
					this._context_.strokeRect(x+0.5,y+0.5,w,h);
				}
				else if(this.isFill)
				this._context_.fillRect(x-1,y-1,w+1,h+1);
				else return;
				this._context_.closePath();
			}
			else{
				if(this._rendercomds_[this._rendercomds_.length-1][1]==3){
					var arr=this._rendercomds_.pop();
					var m=arr[2] [1];
					var bitmapdata=arr[2][0];
					var canvas=bitmapdata.getCanvasII();
					var repeat=arr[2][2];
					if(repeat && m && !m.isTransform()&&canvas&&(bitmapdata.width<w||bitmapdata.height<h))
						this._context_.fillImage(canvas,x,y,w,h);
					else{
						if(m){
							this._context_.drawMartixImage(bitmapdata._canvas_,m,new Rectangle(x,y,w,h));
							}else{
							this._context_.drawImage(bitmapdata._canvas_,x,y,w,h,x,y,w,h);
						}
					}
					this.prefill=[this._context_.drawImage,canvas];
				}
				else if(this.prefill){
					this._context_.drawImage(this.prefill[1],x,y,w,h,x,y,w,h);
				}
			}
			this._context_.globalCompositeOperation="source-over";
		}

		__proto.drawRoundRect=function(x,y,width,height,ellipseWidth,ellipseHeight){
			(ellipseHeight===void 0)&& (ellipseHeight=0);
			this._addplug_();
			this.setxy(x,y);
			ellipseWidth /=2;
			this._context_.beginPath();
			this._context_.moveTo(x+ellipseWidth,y);
			this._context_.arcTo(x+width,y,x+width,y+height,ellipseWidth);
			this._context_.arcTo(x+width,y+height,x,y+height,ellipseWidth);
			this._context_.arcTo(x,y+height,x,y,ellipseWidth);
			this._context_.arcTo(x,y,x+width,y,ellipseWidth);
			if (this.isFill)this._context_.fill();
			if (this.lystorkeStyle)this._context_.stroke();
			this._context_.closePath();
			this._helprec.x=x;this._helprec.y=y;this._helprec.width=width;this._helprec.height=height;
			this._expandSize_(this._helprec);
		}

		__proto.drawRoundRectComplex=LAYAFNVOID/*function(x,y,width,height,topLeftRadius,topRightRadius,bottomLeftRadius,bottomRightRadius){}*/
		__proto.drawTriangles=function(vertices,indices,uvtData,culling){
			(culling===void 0)&& (culling="none");
		}

		__proto.endFill=function(){
			this.lystroke=this.isFill=false;
			this.lystorkeStyle=false;
			this.lythickness=0;
		}

		__proto.setxy=function(x,y){
			(x===void 0)&& (x=0);
			(y===void 0)&& (y=0);
		}

		__proto.lineBitmapStyle=function(bitmap,matrix,repeat,smooth){
			(repeat===void 0)&& (repeat=true);
			(smooth===void 0)&& (smooth=false);
		}

		__proto.lineGradientStyle=function(type,colors,alphas,ratios,matrix,spreadMethod,interpolationMethod,focalPointRatio){
			(spreadMethod===void 0)&& (spreadMethod="pad");
			(interpolationMethod===void 0)&& (interpolationMethod="rgb");
			(focalPointRatio===void 0)&& (focalPointRatio=0);
		}

		__proto.lineShaderStyle=LAYAFNVOID/*function(shader,matrix){}*/
		__proto.lineStyle=function(thickness,color,alpha,pixelHinting,scaleMode,caps,joints,miterLimit){
			(thickness===void 0)&& (thickness=0);
			(color===void 0)&& (color=0);
			(alpha===void 0)&& (alpha=1);
			(pixelHinting===void 0)&& (pixelHinting=false);
			(scaleMode===void 0)&& (scaleMode="normal");
			(miterLimit===void 0)&& (miterLimit=3);
			if(!thickness)return
				this.bitmapFlag=false;
			this.lystorkeStyle=true;
			this.lystroke=true;
			this.lythickness=thickness;
			color=Laya.__parseInt(color+"");
			var s=color.toString(16).toUpperCase();
			var len=6-s.length,str="";
			if(s.length<6){
				for(var i=0;i<len;i++){
					str+=0;
				}
			}
			s=str+s;
			this._context_.lineWidth=thickness;
			this._context_.strokeStyle="#"+s;
			this._context_.lineCap="round";
			this._context_.lineJoin="round";
			this._context_.globalAlpha=alpha;
		}

		__proto.lineTo=function(x,y){
			if(this.isMoveto==false){
				this.moveTo(0,0);
			}
			this._addplug_();
			this._helprec.width=Math.abs(x-this._pointMove.x);
			this._helprec.height=Math.abs(y-this._pointMove.y);
			this._helprec.x=this._pointMove.x;
			this._helprec.y=this._pointMove.y;
			this._expandSize_(this._helprec);
			this._context_.lineTo(x,y);
			this._context_.stroke();
			if (this.isFill)this._context_.fill();
		}

		__proto.moveTo=function(x,y){
			this._addplug_();
			this.setxy(x,y);
			this.lystroke=true;
			this._pointMove.x=x;
			this._pointMove.y=y;
			this._context_.beginPath();
			this._context_.moveTo(x,y);
			this.isMoveto=true;
		}

		__proto.checkRect=function(x,y,w,h){
			this._minX=Math.min(this._minX,x);
			this._minY=Math.min(this._minY,y);
			this._maxX=Math.max(this._maxX,x+w);
			this._maxY=Math.max(this._maxY,y+h);
		}

		__proto.checkPoint=function(x,y){
			this._minX=Math.min(this._minX,x);
			this._minY=Math.min(this._minY,y);
			this._maxX=Math.max(this._maxX,x);
			this._maxY=Math.max(this._maxY,y);
			this._lastX=x;
			this._lastY=y;
		}

		__proto.getBounds=function(targetSpace){
			return this._getBounds_(targetSpace);
		}

		__proto._getBounds_=function(targetSpace,resultRect){
			if(!resultRect)
				resultRect=new Rectangle();
			if(targetSpace==this.ower){
				resultRect.setTo(this.x,this.y,this.width,this.height);
			}
			else{
				var p=targetSpace.globalToLocal(this.ower.localToGlobal(new Point(this.x,this.y)));
				resultRect.setTo(p.x,p.y,this.width,this.height);
			}
			return resultRect;
		}

		__getset(0,__proto,'beginPos',function(){
			return this._beginPos;
		});

		return Graphics;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/graphicsendfill.as
	//class iflash.display.GraphicsEndFill
	var GraphicsEndFill=(function(){
		function GraphicsEndFill(){
			;
		}

		__class(GraphicsEndFill,'iflash.display.GraphicsEndFill',true);
		var __proto=GraphicsEndFill.prototype;
		Laya.imps(__proto,{"iflash.display.IGraphicsFill":true,"iflash.display.IGraphicsData":true})
		return GraphicsEndFill;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/graphicsgradientfill.as
	//class iflash.display.GraphicsGradientFill
	var GraphicsGradientFill=(function(){
		function GraphicsGradientFill(__args){
			this.alphas=null;
			this.colors=null;
			this.focalPointRatio=NaN;
			this.matrix=null;
			this.ratios=null;
		}

		__class(GraphicsGradientFill,'iflash.display.GraphicsGradientFill',true);
		var __proto=GraphicsGradientFill.prototype;
		Laya.imps(__proto,{"iflash.display.IGraphicsFill":true,"iflash.display.IGraphicsData":true})
		__getset(0,__proto,'interpolationMethod',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'spreadMethod',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'type',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(value){}*/);
		return GraphicsGradientFill;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/graphicspath.as
	//class iflash.display.GraphicsPath
	var GraphicsPath=(function(){
		function GraphicsPath(commands,data,winding){
			this.commands=null;
			this.data=null;
			(winding===void 0)&& (winding="evenOdd");
		}

		__class(GraphicsPath,'iflash.display.GraphicsPath',true);
		var __proto=GraphicsPath.prototype;
		Laya.imps(__proto,{"iflash.display.IGraphicsPath":true,"iflash.display.IGraphicsData":true})
		__proto.cubicCurveTo=LAYAFNVOID/*function(controlX1,controlY1,controlX2,controlY2,anchorX,anchorY){}*/
		__proto.curveTo=LAYAFNVOID/*function(controlX,controlY,anchorX,anchorY){}*/
		__proto.lineTo=LAYAFNVOID/*function(x,y){}*/
		__proto.moveTo=LAYAFNVOID/*function(x,y){}*/
		__proto.wideLineTo=LAYAFNVOID/*function(x,y){}*/
		__proto.wideMoveTo=LAYAFNVOID/*function(x,y){}*/
		__getset(0,__proto,'winding',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(value){}*/);
		return GraphicsPath;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/graphicspathcommand.as
	//class iflash.display.GraphicsPathCommand
	var GraphicsPathCommand=(function(){
		function GraphicsPathCommand(){}
		__class(GraphicsPathCommand,'iflash.display.GraphicsPathCommand',true);
		GraphicsPathCommand.CUBIC_CURVE_TO=0;
		GraphicsPathCommand.CURVE_TO=3;
		GraphicsPathCommand.LINE_TO=2;
		GraphicsPathCommand.MOVE_TO=1;
		GraphicsPathCommand.NO_OP=0;
		GraphicsPathCommand.WIDE_LINE_TO=5;
		GraphicsPathCommand.WIDE_MOVE_TO=4;
		return GraphicsPathCommand;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/graphicssolidfill.as
	//class iflash.display.GraphicsSolidFill
	var GraphicsSolidFill=(function(){
		function GraphicsSolidFill(__args){
			this.alpha=NaN;
			this.color=0;
		}

		__class(GraphicsSolidFill,'iflash.display.GraphicsSolidFill',true);
		var __proto=GraphicsSolidFill.prototype;
		Laya.imps(__proto,{"iflash.display.IGraphicsFill":true,"iflash.display.IGraphicsData":true})
		return GraphicsSolidFill;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/graphicsstroke.as
	//class iflash.display.GraphicsStroke
	var GraphicsStroke=(function(){
		function GraphicsStroke(__args){
			this.fill=null;
			this.miterLimit=NaN;
			this.pixelHinting=false;
			this.thickness=NaN;
		}

		__class(GraphicsStroke,'iflash.display.GraphicsStroke',true);
		var __proto=GraphicsStroke.prototype;
		Laya.imps(__proto,{"iflash.display.IGraphicsStroke":true,"iflash.display.IGraphicsData":true})
		__getset(0,__proto,'caps',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'joints',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'scaleMode',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(value){}*/);
		return GraphicsStroke;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/interpolationmethod.as
	//class iflash.display.InterpolationMethod
	var InterpolationMethod=(function(){
		function InterpolationMethod(){}
		__class(InterpolationMethod,'iflash.display.InterpolationMethod',true);
		InterpolationMethod.LINEAR_RGB="linearRGB";
		InterpolationMethod.RGB="rgb";
		return InterpolationMethod;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/jointstyle.as
	//class iflash.display.JointStyle
	var JointStyle=(function(){
		function JointStyle(){
			;
		}

		__class(JointStyle,'iflash.display.JointStyle',true);
		JointStyle.ROUND="round";
		JointStyle.BEVEL="bevel";
		JointStyle.MITER="miter";
		return JointStyle;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/linescalemode.as
	//class iflash.display.LineScaleMode
	var LineScaleMode=(function(){
		function LineScaleMode(){}
		__class(LineScaleMode,'iflash.display.LineScaleMode',true);
		LineScaleMode.HORIZONTAL="horizontal";
		LineScaleMode.NONE="none";
		LineScaleMode.NORMAL="normal";
		LineScaleMode.VERTICAL="vertical";
		return LineScaleMode;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/pixelsnapping.as
	//class iflash.display.PixelSnapping
	var PixelSnapping=(function(){
		function PixelSnapping(){}
		__class(PixelSnapping,'iflash.display.PixelSnapping',true);
		PixelSnapping.ALWAYS="always";
		PixelSnapping.AUTO="auto";
		PixelSnapping.NEVER="never";
		return PixelSnapping;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/plug/displayunit.as
	//class iflash.display.plug.DisplayUnit
	var DisplayUnit=(function(){
		function DisplayUnit(){
			this.next=null;
			this.pre=null;
		}

		__class(DisplayUnit,'iflash.display.plug.DisplayUnit',true);
		var __proto=DisplayUnit.prototype;
		__proto.clone=LAYAFNNULL/*function(node){return null}*/
		__proto.destroy=LAYAFNVOID/*function(){}*/
		__proto.paint=function(context,x,y,node,w,h){
			if (this.next)this.next.paint(context,x,y,node,w,h);
		}

		__getset(0,__proto,'place',function(){
			return-1;
		});

		__getset(0,__proto,'id',function(){
			return-1;
		});

		DisplayUnit._insertUnit_=function(node,tempt){
			if (!Laya.RENDERBYCANVAS)return null;
			if (node._firstDisplayUnit_==null){
				return node._firstDisplayUnit_=tempt.clone(node);
			};
			var _pre=node._firstDisplayUnit_,last;
			var _place=tempt.place,_id=tempt.id;
			do{
				last=_pre;
				if (_pre.id==_id)return _pre;
				if (_pre.place >=_place)
					break ;
				_pre=_pre.next;
			}
			while (_pre);
			if (last.place==_place){
				_pre=tempt.clone(node);
				_pre.pre=last.pre;
				_pre.next=last.next;
				(_pre.pre==null)&& (node._firstDisplayUnit_=_pre);
				last.destroy();
				return _pre;
			}
			if (last.place < _place){
				_pre=last.next;
				last.next=tempt.clone(node);
				last.next.pre=last;
				last.next.next=_pre;
				return last.next;
			}
			_pre=tempt.clone(node);
			last.pre && (last.pre.next=_pre);
			_pre.pre=last.pre;
			_pre.next=last;
			last.pre=_pre;
			(_pre.pre==null)&& (node._firstDisplayUnit_=_pre);
			return _pre;
		}

		DisplayUnit.removeUnit=function(node,unit){
			if (unit.pre)
				unit.pre.next=unit.next;
			if (unit.next)
				unit.next.pre=unit.pre;
			unit.destroy();
		}

		DisplayUnit._DEFAULT_=new DisplayUnit();
		return DisplayUnit;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/scene.as
	//class iflash.display.Scene
	var Scene=(function(){
		function Scene(__a){}
		__class(Scene,'iflash.display.Scene',true);
		var __proto=Scene.prototype;
		__getset(0,__proto,'labels',LAYAFNNULL/*function(){return null}*/);
		__getset(0,__proto,'name',LAYAFNNULL/*function(){return null}*/);
		__getset(0,__proto,'numFrames',LAYAFN0/*function(){return 0}*/);
		return Scene;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/shader.as
	//class iflash.display.Shader
	var Shader=(function(){
		function Shader(code){
			this._data
			;
			if(code){
				this.byteCode=code;
			}
		}

		__class(Shader,'iflash.display.Shader',true);
		var __proto=Shader.prototype;
		__getset(0,__proto,'byteCode',null,function(code){
			this.data=new ShaderData(code);
		});

		__getset(0,__proto,'data',function(){return this._data},function(value){this._data=value});
		__getset(0,__proto,'precisionHint',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(value){}*/);
		return Shader;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/shaderdata.as
	//class iflash.display.ShaderData
	var ShaderData=(function(){
		function ShaderData(byteCode){
			;
		}

		__class(ShaderData,'iflash.display.ShaderData',true);
		return ShaderData;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/spreadmethod.as
	//class iflash.display.SpreadMethod
	var SpreadMethod=(function(){
		function SpreadMethod(){
			;
		}

		__class(SpreadMethod,'iflash.display.SpreadMethod',true);
		SpreadMethod.PAD="pad";
		SpreadMethod.REFLECT="reflect";
		SpreadMethod.REPEAT="repeat";
		return SpreadMethod;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/stagealign.as
	//class iflash.display.StageAlign
	var StageAlign=(function(){
		function StageAlign(){}
		__class(StageAlign,'iflash.display.StageAlign',true);
		StageAlign.isTop=function(align){
			return (StageAlign.ALIGN_SIGN[align] & StageAlign.NUM_T)==StageAlign.NUM_T;
		}

		StageAlign.isBottom=function(align){
			return (StageAlign.ALIGN_SIGN[align] & StageAlign.NUM_B)==StageAlign.NUM_B;
		}

		StageAlign.isLeft=function(align){
			return (StageAlign.ALIGN_SIGN[align] & StageAlign.NUM_L)==StageAlign.NUM_L;
		}

		StageAlign.isRight=function(align){
			return (StageAlign.ALIGN_SIGN[align] & StageAlign.NUM_R)==StageAlign.NUM_R;
		}

		StageAlign.NUM_T=1;
		StageAlign.NUM_L=2;
		StageAlign.NUM_R=4;
		StageAlign.NUM_B=8;
		StageAlign.BOTTOM="B";
		StageAlign.BOTTOM_LEFT="BL";
		StageAlign.BOTTOM_RIGHT="BR";
		StageAlign.LEFT="L";
		StageAlign.RIGHT="R";
		StageAlign.TOP="T";
		StageAlign.TOP_LEFT="TL";
		StageAlign.TOP_RIGHT="TR";
		__static(StageAlign,
		['ALIGN_SIGN',function(){return this.ALIGN_SIGN={
				"T":1,
				"L":2,
				"R":4,
				"B":8,
				"BL":10,
				"BR":12,
				"TL":3,
				"TR":5
		};}

		]);
		return StageAlign;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/stageaspectratio.as
	//class iflash.display.StageAspectRatio
	var StageAspectRatio=(function(){
		function StageAspectRatio(){}
		__class(StageAspectRatio,'iflash.display.StageAspectRatio',true);
		StageAspectRatio.ANY="any";
		StageAspectRatio.LANDSCAPE="landscape";
		StageAspectRatio.PORTRAIT="portrait";
		return StageAspectRatio;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/stagedisplaystate.as
	//class iflash.display.StageDisplayState
	var StageDisplayState=(function(){
		function StageDisplayState(){
			;
		}

		__class(StageDisplayState,'iflash.display.StageDisplayState',true);
		StageDisplayState.FULL_SCREEN="fullScreen";
		StageDisplayState.FULL_SCREEN_INTERACTIVE="fullScreenInteractive";
		StageDisplayState.NORMAL="normal";
		return StageDisplayState;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/stageorientation.as
	//class iflash.display.StageOrientation
	var StageOrientation=(function(){
		function StageOrientation(){}
		__class(StageOrientation,'iflash.display.StageOrientation',true);
		StageOrientation.DEFAULT="default";
		StageOrientation.ROTATED_LEFT="rotatedLeft";
		StageOrientation.ROTATED_RIGHT="rotatedRight";
		StageOrientation.UNKNOWN="unknown";
		StageOrientation.UPSIDE_DOWN="upsideDown";
		return StageOrientation;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/stagequality.as
	//class iflash.display.StageQuality
	var StageQuality=(function(){
		function StageQuality(){
			;
		}

		__class(StageQuality,'iflash.display.StageQuality',true);
		StageQuality.LOW="low";
		StageQuality.MEDIUM="medium";
		StageQuality.HIGH="high";
		StageQuality.BEST="best";
		return StageQuality;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/stagescalemode.as
	//class iflash.display.StageScaleMode
	var StageScaleMode=(function(){
		function StageScaleMode(){
			;
		}

		__class(StageScaleMode,'iflash.display.StageScaleMode',true);
		StageScaleMode.SHOW_ALL="showAll";
		StageScaleMode.EXACT_FIT="exactFit";
		StageScaleMode.NO_BORDER="noBorder";
		StageScaleMode.NO_SCALE="noScale";
		return StageScaleMode;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/swfversion.as
	//class iflash.display.SWFVersion
	var SWFVersion=(function(){
		function SWFVersion(){}
		__class(SWFVersion,'iflash.display.SWFVersion',true);
		SWFVersion.FLASH1=1;
		SWFVersion.FLASH10=10;
		SWFVersion.FLASH11=11;
		SWFVersion.FLASH12=0;
		SWFVersion.FLASH2=2;
		SWFVersion.FLASH3=3;
		SWFVersion.FLASH4=4;
		SWFVersion.FLASH5=5;
		SWFVersion.FLASH6=6;
		SWFVersion.FLASH7=7;
		SWFVersion.FLASH8=8;
		SWFVersion.FLASH9=9;
		return SWFVersion;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/utils/filters.as
	//class iflash.display.utils.Filters
	var Filters=(function(){
		function Filters(){
			this._alpha_=1;
			this.key=0;
		}

		__class(Filters,'iflash.display.utils.Filters',true);
		var __proto=Filters.prototype;
		__proto.alpha=function(d,value){
			Laya.RENDERBYCANVAS && UseFilter.insertUnit(d);
			this._alpha_=value;
			d._modle_.alpha(value);
		}

		Filters.__DEFAULT__=new Filters();
		return Filters;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/utils/point3d.as
	//class iflash.display.utils.Point3d
	var Point3d=(function(){
		function Point3d(_x,_y,_z){
			this.x=NaN;
			this.y=NaN;
			this.z=NaN;
			this.x=_x;
			this.y=_y;
			this.z=_z;
		}

		__class(Point3d,'iflash.display.utils.Point3d',true);
		return Point3d;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/external/externalinterface.as
	//class iflash.external.ExternalInterface
	var ExternalInterface=(function(){
		function ExternalInterface(){}
		__class(ExternalInterface,'iflash.external.ExternalInterface',true);
		__getset(1,ExternalInterface,'available',LAYAFNFALSE/*function(){return false}*/);
		__getset(1,ExternalInterface,'objectID',LAYAFNSTR/*function(){return ""}*/);
		ExternalInterface.addCallback=LAYAFNVOID/*function(functionName,closure){}*/
		ExternalInterface.call=function(functionName,__rest){
			var rest=[];for(var i=1,sz=arguments.length;i<sz;i++)rest.push(arguments[i]);
			return null}
		ExternalInterface.marshallExceptions=false;
		return ExternalInterface;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/filesystem/base64.as
	//class iflash.filesystem.Base64
	var Base64=(function(){
		function Base64(){}
		__class(Base64,'iflash.filesystem.Base64',true);
		Base64.encode=function(data){
			var bytes=new ByteArray();
			bytes.writeUTFBytes(data);
			return Base64.encodeByteArray(bytes);
		}

		Base64.encodeByteArray=function(data){
			var output="";
			var dataBuffer;
			var outputBuffer=new Array(4);
			data.position=0;
			while (data.bytesAvailable > 0){
				dataBuffer=[];
				for (var i=0;i < 3 && data.bytesAvailable > 0;i++){
					dataBuffer[i]=data.readUnsignedByte();
				}
				outputBuffer[0]=(dataBuffer[0] & 0xfc)>> 2;
				outputBuffer[1]=((dataBuffer[0] & 0x03)<< 4)| ((dataBuffer[1])>> 4);
				outputBuffer[2]=((dataBuffer[1] & 0x0f)<< 2)| ((dataBuffer[2])>> 6);
				outputBuffer[3]=dataBuffer[2] & 0x3f;
				for (var j=dataBuffer.length;j < 3;j++){
					outputBuffer[j+1]=64;
				}
				for (var k=0;k < outputBuffer.length;k++){
					output+=Base64.BASE64_CHARS.charAt(outputBuffer[k]);
				}
			}
			return output;
		}

		Base64.decode=function(data){
			var bytes=Base64.decodeToByteArray(data);
			return bytes.readUTFBytes(bytes.length);
		}

		Base64.decodeToByteArray=function(data){
			var output=new ByteArray();
			var dataBuffer=new Array(4);
			var outputBuffer=new Array(3);
			for (var i=0;i < data.length;i+=4){
				for (var j=0;j < 4 && i+j < data.length;j++){
					dataBuffer[j]=Base64.BASE64_CHARS.indexOf(data.charAt(i+j));
				}
				outputBuffer[0]=(dataBuffer[0] << 2)+((dataBuffer[1] & 0x30)>> 4);
				outputBuffer[1]=((dataBuffer[1] & 0x0f)<< 4)+((dataBuffer[2] & 0x3c)>> 2);
				outputBuffer[2]=((dataBuffer[2] & 0x03)<< 6)+dataBuffer[3];
				for (var k=0;k < outputBuffer.length;k++){
					if (dataBuffer[k+1]==64)break ;
					output.writeByte(outputBuffer[k]);
				}
			}
			output.position=0;
			return output;
		}

		Base64.BASE64_CHARS="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
		Base64.version="1.0.0";
		return Base64;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/filesystem/filemode.as
	//class iflash.filesystem.FileMode
	var FileMode=(function(){
		function FileMode(){};
		__class(FileMode,'iflash.filesystem.FileMode',true);
		FileMode.APPEND="append";
		FileMode.READ="read";
		FileMode.UPDATE="update";
		FileMode.WRITE="write";
		return FileMode;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/filesystem/filestorage.as
	//class iflash.filesystem.FileStorage
	var FileStorage=(function(){
		function FileStorage(){
			this.layaFileSystem=null;
			this.so=null;
			this.lastId=0;
			var localUrl=/*__JS__ */location.href;
			this.so=SharedObject.getLocal("LayaAirApplicationStorage_"+encodeURIComponent(localUrl));
			this.layaFileSystem=this.so.data;
			this.lastId=Laya.__parseInt(this.layaFileSystem["LAYA_FS_ID"]);
		}

		__class(FileStorage,'iflash.filesystem.FileStorage',true);
		var __proto=FileStorage.prototype;
		__proto.createFile=function(path){
			var arr=path.split("/").filter(function(item,index,array){
				return curr !=""
			});
			var obj=this.layaFileSystem;
			for (var index=0;index < arr.length;index++){
				var curr=arr[index];
				if (curr==null || curr=="")
					continue ;
				if (obj[curr]==null){
					this.lastId=Laya.__parseInt(this.layaFileSystem["LAYA_FS_ID"]);
					if (index < arr.length-1){
						obj[curr]={"LAYA_FS_TYPE":"D"};
						obj=obj[curr]
						this.so.flush();
					}
					else{
						++this.lastId;
						obj[curr]={"LAYA_FS_ID":this.lastId};
						this.layaFileSystem["LAYA_FS_CONTENT"+this.lastId]="";
						this.layaFileSystem["LAYA_FS_ID"]=this.lastId;
						obj=obj[curr];
						this.so.flush();
					}
				}
				else{
					obj=obj[curr];
				}
			}
		}

		__proto.getList=function(path){
			var arr=path.split("/").filter(function(item,index,array){
				return curr !=""
			});
			var obj=this.layaFileSystem;
			for (var index=0;index < arr.length;index++){
				var curr=arr[index];
				if (curr==null || curr=="")
					continue ;
				if (obj[curr] !=null)
					obj=obj[curr]
			};
			var list=[];
			for (var item in obj){
				if (item.indexOf("LAYA_FS_CONTENT")==0 || item.indexOf("LAYA_FS_ID")==0 || item.indexOf("LAYA_FS_TYPE")==0)
					continue ;
				var file=new File("app-storage:/"+(path=="" ? "" :path+"/")+item)
				if (obj[item].LAYA_FS_TYPE=="D")
					file._isDirectory=true;
				list.push(file);
			}
			return list;
		}

		__proto.fileExist=function(path){
			var arr=path.split("/").filter(function(item,index,array){
				return curr !=""
			});
			var obj=this.layaFileSystem;
			for (var index=0;index < arr.length;index++){
				var curr=arr[index];
				if (curr==null || curr=="")
					continue ;
				if (obj[curr]==null){
					return false
				}
				else
				obj=obj[curr]
			}
			return true;
		}

		__proto.fileWrite=function(path,fileContent){
			(fileContent===void 0)&& (fileContent="");
			var arr=path.split("/").filter(function(item,index,array){
				return curr !=""
			});
			var obj=this.layaFileSystem;
			for (var index=0;index < arr.length;index++){
				var curr=arr[index];
				if (curr==null || curr=="")
					continue ;
				if (obj[curr]==null && index < arr.length-1){
					this.createFile(arr.slice(0,index).join("/"))
				}
				else
				obj=obj[curr]
			}
			this.layaFileSystem["LAYA_FS_CONTENT"+obj.LAYA_FS_ID]=escape(fileContent);
			this.so.flush();
		}

		__proto.fileWriteBinary=function(path,fileContent){
			var arr=path.split("/").filter(function(item,index,array){
				return curr !=""
			});
			var obj=this.layaFileSystem;
			for (var index=0;index < arr.length;index++){
				var curr=arr[index];
				if (curr==null || curr=="")
					continue ;
				if (obj[curr]==null && index < arr.length-1){
					this.createFile(arr.slice(0,index).join("/"))
				}
				else
				obj=obj[curr]
			}
			this.layaFileSystem["LAYA_FS_CONTENT"+obj.LAYA_FS_ID]=Base64.encodeByteArray(fileContent);
			this.so.flush();
		}

		__proto.getBinaryFile=function(path){
			if (path=="" || path==null)
				return null;
			var arr=path.split("/").filter(function(item,index,array){
				return curr !=""
			});
			var obj=this.layaFileSystem;
			for (var index=0;index < arr.length;index++){
				var curr=arr[index];
				if (curr==null || curr=="" || curr=="app:" || curr=="app-storage:")
					continue ;
				if (obj[curr]==null){
					this.lastId=Laya.__parseInt(this.layaFileSystem["LAYA_FS_ID"]);
					if (index < arr.length-1){
						obj[curr]={"LAYA_FS_TYPE":"D"};
						obj=obj[curr]
						this.so.flush();
					}
					else{
						++this.lastId;
						obj[curr]={"LAYA_FS_ID":this.lastId};
						this.layaFileSystem["LAYA_FS_CONTENT"+this.lastId]="";
						this.layaFileSystem["LAYA_FS_ID"]=this.lastId;
						obj=obj[curr];
						this.so.flush();
					}
				}
				else
				obj=obj[curr]
			}
			if (obj.LAYA_FS_TYPE !="D"){
				return Base64.decodeToByteArray(this.layaFileSystem["LAYA_FS_CONTENT"+obj["LAYA_FS_ID"]]);
			}
			return null;
		}

		__proto.getFile=function(path){
			if (path=="" || path==null)
				return null;
			var arr=path.split("/").filter(function(item,index,array){
				return curr !=""
			});
			var obj=this.layaFileSystem;
			for (var index=0;index < arr.length;index++){
				var curr=arr[index];
				if (curr==null || curr=="" || curr=="app:" || curr=="app-storage:")
					continue ;
				if (obj[curr]==null){
					this.lastId=Laya.__parseInt(this.layaFileSystem["LAYA_FS_ID"]);
					if (index < arr.length-1){
						obj[curr]={"LAYA_FS_TYPE":"D"};
						obj=obj[curr]
						this.so.flush();
					}
					else{
						++this.lastId;
						obj[curr]={"LAYA_FS_ID":this.lastId};
						this.layaFileSystem["LAYA_FS_CONTENT"+this.lastId]="";
						this.layaFileSystem["LAYA_FS_ID"]=this.lastId;
						obj=obj[curr];
						this.so.flush();
					}
				}
				else
				obj=obj[curr]
			}
			if (obj.LAYA_FS_TYPE !="D"){
				return unescape(this.layaFileSystem["LAYA_FS_CONTENT"+obj["LAYA_FS_ID"]]);
			}
			return null;
		}

		__getset(1,FileStorage,'instance',function(){
			if (FileStorage.fileStorage==null)
				FileStorage.fileStorage=new FileStorage();
			return FileStorage.fileStorage
		});

		FileStorage.fileStorage=null
		return FileStorage;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/filters/bitmapfilter.as
	//class iflash.filters.BitmapFilter
	var BitmapFilter=(function(){
		function BitmapFilter(inType){
			this._mType=null;
			this.___cached=false;
			this.passes=0;
			this._mType=inType;
		}

		__class(BitmapFilter,'iflash.filters.BitmapFilter',true);
		var __proto=BitmapFilter.prototype;
		__proto.clone=function(){
			return new BitmapFilter(this._mType);
		}

		__proto.__preApplyFilter=LAYAFNVOID/*function(dec){}*/
		__proto.__applyFilter=LAYAFNVOID/*function(dec){}*/
		return BitmapFilter;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/filters/bitmapfilterquality.as
	//class iflash.filters.BitmapFilterQuality
	var BitmapFilterQuality=(function(){
		function BitmapFilterQuality(){
			;
		}

		__class(BitmapFilterQuality,'iflash.filters.BitmapFilterQuality',true);
		BitmapFilterQuality.HIGH=3;
		BitmapFilterQuality.LOW=1;
		BitmapFilterQuality.MEDIUM=2;
		return BitmapFilterQuality;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/filters/bitmapfiltertype.as
	//class iflash.filters.BitmapFilterType
	var BitmapFilterType=(function(){
		function BitmapFilterType(){};
		__class(BitmapFilterType,'iflash.filters.BitmapFilterType',true);
		BitmapFilterType.FULL="full";
		BitmapFilterType.INNER="inner";
		BitmapFilterType.OUTER="outer";
		return BitmapFilterType;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/filters/displacementmapfiltermode.as
	//class iflash.filters.DisplacementMapFilterMode
	var DisplacementMapFilterMode=(function(){
		function DisplacementMapFilterMode(){
			this.CLAMP=null;
			this.COLOR=null;
			this.IGNORE=null;
			this.WRAP=null;
		}

		__class(DisplacementMapFilterMode,'iflash.filters.DisplacementMapFilterMode',true);
		return DisplacementMapFilterMode;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/geom/colortransform.as
	//class iflash.geom.ColorTransform
	var ColorTransform=(function(){
		function ColorTransform(redMultiplier,greenMultiplier,blueMultiplier,alphaMultiplier,redOffset,greenOffset,blueOffset,alphaOffset){
			this.redMultiplier=NaN;
			this.greenMultiplier=NaN;
			this.blueMultiplier=NaN;
			this.alphaMultiplier=NaN;
			this.redOffset=NaN;
			this.greenOffset=NaN;
			this.blueOffset=NaN;
			this.alphaOffset=NaN;
			(redMultiplier===void 0)&& (redMultiplier=1.0);
			(greenMultiplier===void 0)&& (greenMultiplier=1.0);
			(blueMultiplier===void 0)&& (blueMultiplier=1.0);
			(alphaMultiplier===void 0)&& (alphaMultiplier=1.0);
			(redOffset===void 0)&& (redOffset=0);
			(greenOffset===void 0)&& (greenOffset=0);
			(blueOffset===void 0)&& (blueOffset=0);
			(alphaOffset===void 0)&& (alphaOffset=0);
			;
			this.redMultiplier=redMultiplier;
			this.greenMultiplier=greenMultiplier;
			this.blueMultiplier=blueMultiplier;
			this.alphaMultiplier=alphaMultiplier;
			this.redOffset=redOffset;
			this.greenOffset=greenOffset;
			this.blueOffset=blueOffset;
			this.alphaOffset=alphaOffset;
		}

		__class(ColorTransform,'iflash.geom.ColorTransform',false);
		var __proto=ColorTransform.prototype;
		__proto.concat=function(second){
			this.alphaOffset=this.alphaOffset+this.alphaMultiplier *second.alphaOffset;
			this.alphaMultiplier=this.alphaMultiplier *second.alphaMultiplier;
			this.redOffset=this.redOffset+this.redMultiplier *second.redOffset;
			this.redMultiplier=this.redMultiplier *second.redMultiplier;
			this.greenOffset=this.greenOffset+this.greenMultiplier *second.greenOffset;
			this.greenMultiplier=this.greenMultiplier *second.greenMultiplier;
			this.blueOffset=this.blueOffset+this.blueMultiplier *second.blueOffset;
			this.blueMultiplier=this.blueMultiplier *second.blueMultiplier;
		}

		__proto.toString=function(){
			return "(redMultiplier="+this.redMultiplier+", greenMultiplier="+this.greenMultiplier+", blueMultiplier="+this.blueMultiplier+", alphaMultiplier="+this.alphaMultiplier+", redOffset="+this.redOffset+", greenOffset="+this.greenOffset+", blueOffset="+this.blueOffset+", alphaOffset="+this.alphaOffset+")";
		}

		__getset(0,__proto,'color',function(){
			return this.redOffset << 16 | this.greenOffset << 8 | this.blueOffset;
			},function(newColor){
			this.redMultiplier=this.greenMultiplier=this.blueMultiplier=0;
			this.redOffset=newColor >> 16 & 255;
			this.greenOffset=newColor >> 8 & 255;
			this.blueOffset=newColor & 255;
		});

		ColorTransform._DEFAULT_=new ColorTransform();
		return ColorTransform;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/geom/matrix.as
	//class iflash.geom.Matrix
	var Matrix=(function(){
		function Matrix(a,b,c,d,tx,ty){
			this.a=1;
			this.b=0;
			this.c=0;
			this.d=1;
			this.tx=0;
			this.ty=0;
			(a===void 0)&& (a=1);
			(b===void 0)&& (b=0);
			(c===void 0)&& (c=0);
			(d===void 0)&& (d=1);
			(tx===void 0)&& (tx=0);
			(ty===void 0)&& (ty=0);
			this.a=a;
			this.b=b;
			this.c=c;
			this.d=d;
			this.tx=tx;
			this.ty=ty;
		}

		__class(Matrix,'iflash.geom.Matrix',true);
		var __proto=Matrix.prototype;
		__proto.isTransform=function(){
			return this.a !=1 || this.b !=0 || this.c !=0 || this.d !=1;
		}

		__proto.clone=function(){
			return new Matrix(this.a,this.b,this.c,this.d,this.tx,this.ty);
		}

		__proto.createGradientBox=function(in_width,in_height,rotation,in_tx,in_ty){
			(rotation===void 0)&& (rotation=0);
			(in_tx===void 0)&& (in_tx=0);
			(in_ty===void 0)&& (in_ty=0);
			this.a=in_width / 1638.4;
			this.d=in_height / 1638.4;
			if (rotation !=0 && rotation !=0.0){
				var cos=Math.cos(rotation);
				var sin=Math.sin(rotation);
				this.b=sin *this.d;
				this.c=-sin *this.a;
				this.a*=cos;
				this.d*=cos;
			}
			else{
				this.b=0;
				this.c=0;
			}
			this.tx=(in_tx !=0 ? in_tx+in_width / 2 :in_width / 2);
			this.ty=(in_ty !=0 ? in_ty+in_height / 2 :in_height / 2);
		}

		__proto.transformPoint=function(point){
			return new Point(this.a *point.x+this.c *point.y+this.tx,this.d *point.y+this.b *point.x+this.ty);
		}

		__proto.identity=function(){
			this.a=this.d=1;
			this.b=this.c=this.tx=this.ty=0;
		}

		__proto.copy=function(src){
			this.a=src.a;
			this.b=src.b;
			this.c=src.c;
			this.d=src.d;
			this.tx=src.tx;
			this.ty=src.ty;
			return this;
		}

		__proto.copyFrom=function(src){
			this.a=src.a;
			this.b=src.b;
			this.c=src.c;
			this.d=src.d;
			this.tx=src.tx;
			this.ty=src.ty;
		}

		__proto.IsEqual=function(p_pOther){
			if (this.a !=p_pOther.a || this.b !=p_pOther.b || this.c !=p_pOther.c || this.d !=p_pOther.d || this.tx !=p_pOther.tx || this.ty !=p_pOther.ty){
				return false;
			}
			return true;
		}

		__proto.translate=function(x,y){
			this.tx=x+this.tx;
			this.ty=y+this.ty;
		}

		__proto.rotate=function(angle){
			if (Math.abs(angle-0)<0.0000001)
				return;
			var cos=Math.cos(angle);
			var sin=Math.sin(angle);
			var tm11=this.a *cos-this.b *sin;
			var tm12=this.a *sin+this.b *cos;
			var tm21=this.c *cos-this.d *sin;
			var tm22=this.c *sin+this.d *cos;
			var tx1=this.tx *cos-this.ty *sin;
			var ty1=this.tx *sin+this.ty *cos;
			this.a=tm11;
			this.b=tm12;
			this.c=tm21;
			this.d=tm22;
			this.tx=tx1;
			this.ty=ty1;
		}

		__proto.scale=function(sx,sy){
			if (sx==1 && sy==1)
				return;
			this.a*=sx;
			this.b*=sy;
			this.c*=sx;
			this.d *=sy;
			this.tx *=sx;
			this.ty *=sy;
		}

		__proto.setTransform=function(n11,n12,n21,n22,n31,n32){
			this.a=n11;
			this.b=n12;
			this.c=n21;
			this.d=n22;
			this.tx=n31;
			this.ty=n32;
		}

		__proto.transform=function(n11,n12,n21,n22,n31,n32){
			var k11=n11 *this.a+n12 *this.c+0 *this.tx;
			var k12=n11 *this.b+n12 *this.d+0 *this.ty;
			var k21=n21 *this.a+n22 *this.c+0 *this.tx;
			var k22=n21 *this.b+n22 *this.d+0 *this.ty;
			var k31=n31 *this.a+n32 *this.c+1 *this.tx;
			var k32=n31 *this.b+n32 *this.d+1 *this.ty;
			this.a=k11;
			this.b=k12;
			this.c=k21;
			this.d=k22;
			this.tx=k31;
			this.ty=k32;
		}

		__proto.invert=function(){
			var a=this.a;
			var b=this.b;
			var c=this.c;
			var d=this.d;
			var tx=this.tx;
			var i=a *d-b *c;
			this.a=d / i;
			this.b=-b / i;
			this.c=-c / i;
			this.d=a / i;
			this.tx=(c *this.ty-d *tx)/ i;
			this.ty=-(a *this.ty-b *tx)/ i;
			return this;
		}

		__proto.concat=function(mtx){
			var a=this.a;
			var c=this.c;
			var tx=this.tx;
			this.a=a *mtx.a+this.b *mtx.c;
			this.b=a *mtx.b+this.b *mtx.d;
			this.c=c *mtx.a+this.d *mtx.c;
			this.d=c *mtx.b+this.d *mtx.d;
			this.tx=tx *mtx.a+this.ty *mtx.c+mtx.tx;
			this.ty=tx *mtx.b+this.ty *mtx.d+mtx.ty;
			return this;
		}

		__proto.preMultiplyInto=function(other,target){
			var n=other,t=target;
			var a=n.a *this.a;
			var b=0.0;
			var c=0.0;
			var d=n.d *this.d;
			var tx=n.tx *this.a+this.tx;
			var ty=n.ty *this.d+this.ty;
			if (n.b!=0.0 || n.c!=0.0 || this.b!==0.0 || this.c!=0.0){
				a+=n.b *this.c;
				d+=n.c *this.b;
				b+=n.a *this.b+n.b *this.d;
				c+=n.c *this.a+n.d *this.c;
				tx+=n.ty *this.c;
				ty+=n.tx *this.b;
			}
			t.a=a;
			t.b=b;
			t.c=c;
			t.d=d;
			t.tx=tx;
			t.ty=ty;
		}

		__proto.concatSix=function(a1,b1,c1,d1,tx1,ty1){
			var a=this.a;
			var c=this.c;
			var tx=this.tx;
			this.a=a *a1+this.b *c1;
			this.b=a *b1+this.b *d1;
			this.c=c *a1+this.d *c1;
			this.d=c *b1+this.d *d1;
			this.tx=tx *a1+this.ty *c1+tx1;
			this.ty=tx *b1+this.ty *d1+ty1;
		}

		__proto.deltaTransformPoint=function(point){
			return new Point(point.x *this.a+point.y *this.c,point.x *this.b+point.y *this.d);
		}

		__proto.createBox=function(scaleX,scaleY,rotation,tx,ty){
			(rotation===void 0)&& (rotation=0);
			(tx===void 0)&& (tx=0);
			(ty===void 0)&& (ty=0);
			this.a=scaleX;
			this.d=scaleY;
			this.b=rotation;
			this.tx=tx;
			this.ty=ty;
		}

		__proto.setTo=function(a1,b1,c1,d1,tx1,ty1){
			this.a=a1;
			this.b=b1;
			this.c=c1;
			this.d=d1;
			this.tx=tx1;
			this.ty=ty1;
		}

		__proto.transformPointInPlace=function(source,out){
			out.setTo(this.a *source.x+this.c *source.y+this.tx,
			this.b *source.x+this.d *source.y+this.ty);
			return out;
		}

		__proto.transformBounds=function(bounds){
			if(!bounds)return bounds;
			var x=bounds.x;
			var y=bounds.y;
			var w=Math.abs(bounds.width);
			var h=Math.abs(bounds.height);
			x=bounds.width<0?x-w:x;
			y=bounds.height<0?y-h:y;
			var x0=this.a *x+this.c *y+this.tx;
			var y0=this.b *x+this.d *y+this.ty;
			var x1=this.a *(x+w)+this.c *y+this.tx;
			var y1=this.b *(x+w)+this.d *y+this.ty;
			var x2=this.a *(x+w)+this.c *(y+h)+this.tx;
			var y2=this.b *(x+w)+this.d *(y+h)+this.ty;
			var x3=this.a *x+this.c *(y+h)+this.tx;
			var y3=this.b *x+this.d *(y+h)+this.ty;
			bounds.x=Math.min(x0,x1,x2,x3);
			bounds.width=Math.max(x0,x1,x2,x3)-bounds.x;
			bounds.y=Math.min(y0,y1,y2,y3);
			bounds.height=Math.max(y0,y1,y2,y3)-bounds.y;
			return bounds;
		}

		Matrix.lerp=function(mo,m1,m2,f){
			mo.a=m1.a+(m2.a-m1.a)*f;
			mo.b=m1.b+(m2.b-m1.b)*f;
			mo.c=m1.c+(m2.c-m1.c)*f;
			mo.d=m1.d+(m2.d-m1.d)*f;
			mo.tx=m1.tx+(m2.tx-m1.tx)*f;
			mo.ty=m1.ty+(m2.ty-m1.ty)*f;
		}

		Matrix.lerp1=function(mo,m1,m2,f){
			mo.a=m1[0]+(m2[0]-m1[0])*f;
			mo.b=m1[1]+(m2[1]-m1[1])*f;
			mo.c=m1[2]+(m2[2]-m1[2])*f;
			mo.d=m1[3]+(m2[3]-m1[3])*f;
			mo.tx=m1[4]+(m2[4]-m1[4])*f;
			mo.ty=m1[5]+(m2[5]-m1[5])*f;
		}

		Matrix.fromSRT=function(mo,sx,sy,r,tx,ty){
			var st=Math.sin(r);
			var ct=Math.cos(r);
			mo.a=sx *ct;
			mo.b=sx *st;
			mo.c=-sy *st;
			mo.d=sy *ct;
			mo.tx=tx;
			mo.ty=ty;
		}

		Matrix.fromRST=function(mo,sx,sy,r,tx,ty){
			var st=Math.sin(r);
			var ct=Math.cos(r);
			mo.a=sx *ct;
			mo.b=sy *st;
			mo.c=-sx *st;
			mo.d=sy *ct;
			mo.tx=tx;
			mo.ty=ty;
		}

		Matrix.fromTransformInfo=function(mo,sx,sy,sr,r,tx,ty){
			if (sr==0.0)
				Matrix.fromSRT(mo,sx,sy,r,tx,ty);
			else if (Math.abs(sr-r)< 0.0001)
			Matrix.fromRST(mo,sx,sy,r,tx,ty);
			else{
				var st=Math.sin(sr);
				var ct=Math.cos(sr);
				mo.a=sx *ct;
				mo.b=sy *st;
				mo.c=-sx *st;
				mo.d=sy *ct;
				mo.tx=0;
				mo.ty=0;
				var mt=new Matrix();
				mt.a=ct;
				mt.b=-st;
				mt.c=st;
				mt.d=ct;
				mt.tx=0;
				mt.ty=0;
				Matrix.mul(mo,mo,mt);
				st=Math.sin(r);
				ct=Math.cos(r);
				mt.a=ct;
				mt.b=st;
				mt.c=-st;
				mt.d=ct;
				mt.tx=0;
				mt.ty=0;
				Matrix.mul(mo,mo,mt);
				mo.tx=tx;
				mo.ty=ty;
			}
		}

		Matrix.mul=function(mo,m1,m2){
			var aa=m1.a,ab=m1.b,ac=m1.c,ad=m1.d,atx=m1.tx,aty=m1.ty,ba=m2.a,bb=m2.b,bc=m2.c,bd=m2.d,btx=m2.tx,bty=m2.ty;
			mo.a=aa *ba+ab *bc;
			mo.b=aa *bb+ab *bd;
			mo.c=ac *ba+ad *bc;
			mo.d=ac *bb+ad *bd;
			mo.tx=ba *atx+bc *aty+btx;
			mo.ty=bb *atx+bd *aty+bty;
		}

		__static(Matrix,
		['__DEFAULT__',function(){return this.__DEFAULT__=new Matrix();},'__SMALL__',function(){return this.__SMALL__=new Matrix(0.00001,0,0,0.000001,0,0);}
		]);
		return Matrix;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/geom/matrix3d.as
	//class iflash.geom.Matrix3D
	var Matrix3D=(function(){
		function Matrix3D(v){
			this.$vec=[1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1];
			this.$transposeTransform=[0,4,8,12,1,5,9,13,2,6,10,14,3,7,11,15];
			if (v !=null){
				if (v.length !=this.$vec.length){
					throw new Error("Not equal length!");
				}
				for (var i=0;i < this.$vec.length;i++){
					this.$vec[i]=v[i];
				}
			}
		}

		__class(Matrix3D,'iflash.geom.Matrix3D',true);
		var __proto=Matrix3D.prototype;
		__proto.append=function(lhs){
			var ma=lhs.rawData,mb=this.$vec;
			var ma11=ma[0],ma12=ma[4],ma13=ma[8],ma14=ma[12];
			var ma21=ma[1],ma22=ma[5],ma23=ma[9],ma24=ma[13];
			var ma31=ma[2],ma32=ma[6],ma33=ma[10],ma34=ma[14];
			var ma41=ma[3],ma42=ma[7],ma43=ma[11],ma44=ma[15];
			var mb11=mb[0],mb12=mb[4],mb13=mb[8],mb14=mb[12];
			var mb21=mb[1],mb22=mb[5],mb23=mb[9],mb24=mb[13];
			var mb31=mb[2],mb32=mb[6],mb33=mb[10],mb34=mb[14];
			var mb41=mb[3],mb42=mb[7],mb43=mb[11],mb44=mb[15];
			this.$vec[0]=ma11 *mb11+ma12 *mb21+ma13 *mb31+ma14 *mb41;
			this.$vec[1]=ma21 *mb11+ma22 *mb21+ma23 *mb31+ma24 *mb41;
			this.$vec[2]=ma31 *mb11+ma32 *mb21+ma33 *mb31+ma34 *mb41;
			this.$vec[3]=ma41 *mb11+ma42 *mb21+ma43 *mb31+ma44 *mb41;
			this.$vec[4]=ma11 *mb12+ma12 *mb22+ma13 *mb32+ma14 *mb42;
			this.$vec[5]=ma21 *mb12+ma22 *mb22+ma23 *mb32+ma24 *mb42;
			this.$vec[6]=ma31 *mb12+ma32 *mb22+ma33 *mb32+ma34 *mb42;
			this.$vec[7]=ma41 *mb12+ma42 *mb22+ma43 *mb32+ma44 *mb42;
			this.$vec[8]=ma11 *mb13+ma12 *mb23+ma13 *mb33+ma14 *mb43;
			this.$vec[9]=ma21 *mb13+ma22 *mb23+ma23 *mb33+ma24 *mb43;
			this.$vec[10]=ma31 *mb13+ma32 *mb23+ma33 *mb33+ma34 *mb43;
			this.$vec[11]=ma41 *mb13+ma42 *mb23+ma43 *mb33+ma44 *mb43;
			this.$vec[12]=ma11 *mb14+ma12 *mb24+ma13 *mb34+ma14 *mb44;
			this.$vec[13]=ma21 *mb14+ma22 *mb24+ma23 *mb34+ma24 *mb44;
			this.$vec[14]=ma31 *mb14+ma32 *mb24+ma33 *mb34+ma34 *mb44;
			this.$vec[15]=ma41 *mb14+ma42 *mb24+ma43 *mb34+ma44 *mb44;
		}

		__proto.appendRotation=function(degrees,axis,pivotPoint){
			this.append(this.getRotationMatrix(degrees / 180 *Math.PI,axis.x,axis.y,axis.z,pivotPoint ? pivotPoint.x :0,pivotPoint ? pivotPoint.y :0,pivotPoint ? pivotPoint.z :0));
		}

		__proto.appendScale=function(xScale,yScale,zScale){
			this.$vec[0]*=xScale;
			this.$vec[1]*=yScale;
			this.$vec[2]*=zScale;
			this.$vec[4]*=xScale;
			this.$vec[5]*=yScale;
			this.$vec[6]*=zScale;
			this.$vec[8]*=xScale;
			this.$vec[9]*=yScale;
			this.$vec[10]*=zScale;
			this.$vec[12]*=xScale;
			this.$vec[13]*=yScale;
			this.$vec[14]*=zScale;
		}

		__proto.appendTranslation=function(x,y,z){
			var m=this.$vec;
			var m41=m[3],m42=m[7],m43=m[11],m44=m[15];
			m[0]+=x *m41;
			m[1]+=y *m41;
			m[2]+=z *m41;
			m[4]+=x *m42;
			m[5]+=y *m42;
			m[6]+=z *m42;
			m[8]+=x *m43;
			m[9]+=y *m43;
			m[10]+=z *m43;
			m[12]+=x *m44;
			m[13]+=y *m44;
			m[14]+=z *m44;
		}

		__proto.clone=function(){
			return new iflash.geom.Matrix3D(this.$vec);
		}

		__proto.copyColumnFrom=function(column,vector3D){
			if (column > 3)
				throw new Error("column number too bigger");
			var offset=column << 2;
			this.$vec[offset]=vector3D.x;
			this.$vec[offset+1]=vector3D.y;
			this.$vec[offset+2]=vector3D.z;
			this.$vec[offset+3]=vector3D.w;
		}

		__proto.copyColumnTo=function(column,vector3D){
			if (column > 3)
				throw new Error("column number too bigger");
			var offset=column << 2;
			vector3D.x=this.$vec[offset];
			vector3D.y=this.$vec[offset+1];
			vector3D.z=this.$vec[offset+2];
			vector3D.w=this.$vec[offset+3];
		}

		__proto.copyFrom=function(sourceMatrix3D){
			for (var i=0;i < this.$vec.length;i++){
				this.$vec[i]=sourceMatrix3D.$vec[i];
			}
		}

		__proto.copyRawDataFrom=function(vector,index,transpose){
			(index===void 0)&& (index=0);
			(transpose===void 0)&& (transpose=false);
			var i=0,j=index | 0
			if (transpose){
				for (;i < 16;i++,j++){
					this.$vec[this.$transposeTransform[i]]=vector[j] || 0;
				}
			}
			else{
				for (;i < 16;i++,j++){
					this.$vec[i]=vector[j] || 0;
				}
			}
		}

		__proto.copyRawDataTo=function(vector,index,transpose){
			(index===void 0)&& (index=0);
			(transpose===void 0)&& (transpose=false);
			var i=0,j=index | 0;
			if (transpose){
				for (;i < 16;i++,j++){
					vector[j]=this.$vec[this.$transposeTransform[i]];
				}
			}
			else{
				for (;i < 16;i++,j++){
					vector[j]=this.$vec[i];
				}
			}
		}

		__proto.copyRowFrom=function(row,vector3D){
			if (row > 3)
				throw new Error("row number too bigger",0);
			var offset=row | 0;
			this.$vec[offset]=vector3D.x;
			this.$vec[offset+4]=vector3D.y;
			this.$vec[offset+8]=vector3D.z;
			this.$vec[offset+12]=vector3D.w;
		}

		__proto.copyRowTo=function(row,vector3D){
			var offset=row | 0;
			vector3D.x=this.$vec[offset];
			vector3D.y=this.$vec[offset+4];
			vector3D.z=this.$vec[offset+8];
			vector3D.w=this.$vec[offset+12];
		}

		__proto.copyToMatrix3D=function(dest){
			for (var i=0;i < 16;i++){
				dest.rawData[i]=this.$vec[i];
			}
		}

		__proto.decompose=function(orientationStyle){
			(orientationStyle===void 0)&& (orientationStyle="eulerAngles");
			throw new Error("decompose");
			var t_mat=this.original;
			var t_vec3D=t_mat.decompose(orientationStyle);
			var t_resVec=new Array(t_vec3D.length);
			for (var i=0;i < t_resVec.length;i++){
				t_resVec[i].x=t_vec3D[i].x;
				t_resVec[i].y=t_vec3D[i].y;
				t_resVec[i].z=t_vec3D[i].z;
				t_resVec[i].w=t_vec3D[i].w;
			}
			return t_resVec;
		}

		__proto.deltaTransformVector=function(v){
			var x=v.x,y=v.y,z=v.z;
			return new Vector3D(this.$vec[0] *x+this.$vec[4] *y+this.$vec[8] *z,this.$vec[1] *x+this.$vec[5] *y+this.$vec[9] *z,this.$vec[2] *x+this.$vec[6] *y+this.$vec[10] *z);
		}

		__proto.identity=function(){
			this.$vec[0]=this.$vec[5]=this.$vec[10]=this.$vec[15]=1;
			this.$vec[1]=this.$vec[2]=this.$vec[3]=this.$vec[4]=this.$vec[6]=this.$vec[7]=this.$vec[8]=this.$vec[9]=this.$vec[11]=this.$vec[12]=this.$vec[13]=this.$vec[14]=0;
		}

		__proto.interpolateTo=function(toMat,percent){
			throw new Error("NOT REAL FUNCTION!!!",0);
		}

		__proto.invert=function(){
			var m=this.$vec;
			var m00=m[0],m01=m[4],m02=m[8],m03=m[12];
			var m10=m[1],m11=m[5],m12=m[9],m13=m[13];
			var m20=m[2],m21=m[6],m22=m[10],m23=m[14];
			var m30=m[3],m31=m[7],m32=m[11],m33=m[15];
			var v0=m20 *m31-m21 *m30;
			var v1=m20 *m32-m22 *m30;
			var v2=m20 *m33-m23 *m30;
			var v3=m21 *m32-m22 *m31;
			var v4=m21 *m33-m23 *m31;
			var v5=m22 *m33-m23 *m32;
			var t00=+(v5 *m11-v4 *m12+v3 *m13);
			var t10=-(v5 *m10-v2 *m12+v1 *m13);
			var t20=+(v4 *m10-v2 *m11+v0 *m13);
			var t30=-(v3 *m10-v1 *m11+v0 *m12);
			var invDet=1 / (t00 *m00+t10 *m01+t20 *m02+t30 *m03);
			var d00=t00 *invDet;
			var d10=t10 *invDet;
			var d20=t20 *invDet;
			var d30=t30 *invDet;
			var d01=-(v5 *m01-v4 *m02+v3 *m03)*invDet;
			var d11=+(v5 *m00-v2 *m02+v1 *m03)*invDet;
			var d21=-(v4 *m00-v2 *m01+v0 *m03)*invDet;
			var d31=+(v3 *m00-v1 *m01+v0 *m02)*invDet;
			v0=m10 *m31-m11 *m30;
			v1=m10 *m32-m12 *m30;
			v2=m10 *m33-m13 *m30;
			v3=m11 *m32-m12 *m31;
			v4=m11 *m33-m13 *m31;
			v5=m12 *m33-m13 *m32;
			var d02=+(v5 *m01-v4 *m02+v3 *m03)*invDet;
			var d12=-(v5 *m00-v2 *m02+v1 *m03)*invDet;
			var d22=+(v4 *m00-v2 *m01+v0 *m03)*invDet;
			var d32=-(v3 *m00-v1 *m01+v0 *m02)*invDet;
			v0=m21 *m10-m20 *m11;
			v1=m22 *m10-m20 *m12;
			v2=m23 *m10-m20 *m13;
			v3=m22 *m11-m21 *m12;
			v4=m23 *m11-m21 *m13;
			v5=m23 *m12-m22 *m13;
			var d03=-(v5 *m01-v4 *m02+v3 *m03)*invDet;
			var d13=+(v5 *m00-v2 *m02+v1 *m03)*invDet;
			var d23=-(v4 *m00-v2 *m01+v0 *m03)*invDet;
			var d33=+(v3 *m00-v1 *m01+v0 *m02)*invDet;
			var mat3D=new iflash.geom.Matrix3D([d00,d01,d02,d03,d10,d11,d12,d13,d20,d21,d22,d23,d30,d31,d32,d33]);
			if (Math.abs(mat3D.determinant)< 0.000001)
				return false;
			else{
				for (var i=0;i < this.$vec.length;i++){
					this.$vec[i]=mat3D.rawData[i];
				}
				return true;
			}
		}

		__proto.pointAt=LAYAFNVOID/*function(pos,at,up){}*/
		__proto.prepend=function(rhs){
			var ma=this.$vec,mb=rhs.rawData;
			var ma11=ma[0],ma12=ma[4],ma13=ma[8],ma14=ma[12];
			var ma21=ma[1],ma22=ma[5],ma23=ma[9],ma24=ma[13];
			var ma31=ma[2],ma32=ma[6],ma33=ma[10],ma34=ma[14];
			var ma41=ma[3],ma42=ma[7],ma43=ma[11],ma44=ma[15];
			var mb11=mb[0],mb12=mb[4],mb13=mb[8],mb14=mb[12];
			var mb21=mb[1],mb22=mb[5],mb23=mb[9],mb24=mb[13];
			var mb31=mb[2],mb32=mb[6],mb33=mb[10],mb34=mb[14];
			var mb41=mb[3],mb42=mb[7],mb43=mb[11],mb44=mb[15];
			this.$vec[0]=ma11 *mb11+ma12 *mb21+ma13 *mb31+ma14 *mb41;
			this.$vec[1]=ma21 *mb11+ma22 *mb21+ma23 *mb31+ma24 *mb41;
			this.$vec[2]=ma31 *mb11+ma32 *mb21+ma33 *mb31+ma34 *mb41;
			this.$vec[3]=ma41 *mb11+ma42 *mb21+ma43 *mb31+ma44 *mb41;
			this.$vec[4]=ma11 *mb12+ma12 *mb22+ma13 *mb32+ma14 *mb42;
			this.$vec[5]=ma21 *mb12+ma22 *mb22+ma23 *mb32+ma24 *mb42;
			this.$vec[6]=ma31 *mb12+ma32 *mb22+ma33 *mb32+ma34 *mb42;
			this.$vec[7]=ma41 *mb12+ma42 *mb22+ma43 *mb32+ma44 *mb42;
			this.$vec[8]=ma11 *mb13+ma12 *mb23+ma13 *mb33+ma14 *mb43;
			this.$vec[9]=ma21 *mb13+ma22 *mb23+ma23 *mb33+ma24 *mb43;
			this.$vec[10]=ma31 *mb13+ma32 *mb23+ma33 *mb33+ma34 *mb43;
			this.$vec[11]=ma41 *mb13+ma42 *mb23+ma43 *mb33+ma44 *mb43;
			this.$vec[12]=ma11 *mb14+ma12 *mb24+ma13 *mb34+ma14 *mb44;
			this.$vec[13]=ma21 *mb14+ma22 *mb24+ma23 *mb34+ma24 *mb44;
			this.$vec[14]=ma31 *mb14+ma32 *mb24+ma33 *mb34+ma34 *mb44;
			this.$vec[15]=ma41 *mb14+ma42 *mb24+ma43 *mb34+ma44 *mb44;
		}

		__proto.prependRotation=function(degrees,axis,pivotPoint){
			this.prepend(this.getRotationMatrix(degrees / 180 *Math.PI,axis.x,axis.y,axis.z,pivotPoint ? pivotPoint.x :0,pivotPoint ? pivotPoint.y :0,pivotPoint ? pivotPoint.z :0));
		}

		__proto.prependScale=function(xScale,yScale,zScale){
			this.$vec[0]*=xScale;
			this.$vec[1]*=xScale;
			this.$vec[2]*=xScale;
			this.$vec[3]*=xScale;
			this.$vec[4]*=yScale;
			this.$vec[5]*=yScale;
			this.$vec[6]*=yScale;
			this.$vec[7]*=yScale;
			this.$vec[8]*=zScale;
			this.$vec[9]*=zScale;
			this.$vec[10]*=zScale;
			this.$vec[11]*=zScale;
		}

		__proto.prependTranslation=function(x,y,z){
			var m=this.$vec;
			var m11=m[0],m12=m[4],m13=m[8];
			var m21=m[1],m22=m[5],m23=m[9];
			var m31=m[2],m32=m[6],m33=m[10];
			var m41=m[3],m42=m[7],m43=m[11];
			m[12]+=m11 *x+m12 *y+m13 *z;
			m[13]+=m21 *x+m22 *y+m23 *z;
			m[14]+=m31 *x+m32 *y+m33 *z;
			m[15]+=m41 *x+m42 *y+m43 *z;
		}

		__proto.recompose=function(components,orientationStyle){
			(orientationStyle===void 0)&& (orientationStyle="eulerAngles");
			return false}
		__proto.transformVector=function(v){
			var x=v.x,y=v.y,z=v.z;
			return new Vector3D(this.$vec[0] *x+this.$vec[4] *y+this.$vec[8] *z+this.$vec[12],this.$vec[1] *x+this.$vec[5] *y+this.$vec[9] *z+this.$vec[13],this.$vec[2] *x+this.$vec[6] *y+this.$vec[10] *z+this.$vec[14]);
		}

		__proto.transformVectors=function(vin,vout){
			var m11=this.$vec[0],m12=this.$vec[4],m13=this.$vec[8],m14=this.$vec[12];
			var m21=this.$vec[1],m22=this.$vec[5],m23=this.$vec[9],m24=this.$vec[13];
			var m31=this.$vec[2],m32=this.$vec[6],m33=this.$vec[10],m34=this.$vec[14];
			var m41=this.$vec[3],m42=this.$vec[7],m43=this.$vec[11],m44=this.$vec[15];
			for (var i=0;i < vin.length-2;i+=3){
				var x=vin[i],y=vin[i+1],z=vin[i+2];
				vout[i]=m11 *x+m12 *y+m13 *z+m14;
				vout[i+1]=m21 *x+m22 *y+m23 *z+m24;
				vout[i+2]=m31 *x+m32 *y+m33 *z+m34;
			}
		}

		__proto.transpose=function(){
			var tmp=NaN;
			tmp=this.$vec[1];
			this.$vec[1]=this.$vec[4];
			this.$vec[4]=tmp;
			tmp=this.$vec[2];
			this.$vec[2]=this.$vec[8];
			this.$vec[5]=tmp;
			tmp=this.$vec[3];
			this.$vec[3]=this.$vec[12];
			this.$vec[12]=tmp;
			tmp=this.$vec[6];
			this.$vec[6]=this.$vec[9];
			this.$vec[9]=tmp;
			tmp=this.$vec[7];
			this.$vec[7]=this.$vec[13];
			this.$vec[13]=tmp;
			tmp=this.$vec[11];
			this.$vec[11]=this.$vec[14];
			this.$vec[14]=tmp;
		}

		__proto.getRotationMatrix=function(theta,u,v,w,a,b,c){
			var u2=u *u,v2=v *v,w2=w *w;
			var L2=u2+v2+w2,L=Math.sqrt(L2);
			u/=L;
			v/=L;
			w/=L;
			u2/=L2;
			v2/=L2;
			w2/=L2;
			var cos=Math.cos(theta),sin=Math.sin(theta);
			var vec=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ,1];
			vec[0]=u2+(v2+w2)*cos;
			vec[1]=u *v *(1-cos)+w *sin;
			vec[2]=u *w *(1-cos)-v *sin;
			vec[3]=0;
			vec[4]=u *v *(1-cos)-w *sin;
			vec[5]=v2+(u2+w2)*cos;
			vec[6]=v *w *(1-cos)+u *sin;
			vec[7]=0;
			vec[8]=u *w *(1-cos)+v *sin;
			vec[9]=v *w *(1-cos)-u *sin;
			vec[10]=w2+(u2+v2)*cos;
			vec[11]=0;
			vec[12]=(a *(v2+w2)-u *(b *v+c *w))*(1-cos)+(b *w-c *v)*sin;
			vec[13]=(b *(u2+w2)-v *(a *u+c *w))*(1-cos)+(c *u-a *w)*sin;
			vec[14]=(c *(u2+v2)-w *(a *u+b *v))*(1-cos)+(a *v-b *u)*sin;
			return new iflash.geom.Matrix3D(vec);
		}

		__getset(0,__proto,'determinant',function(){
			var m11=this.$vec[0],m12=this.$vec[4],m13=this.$vec[8],m14=this.$vec[12];
			var m21=this.$vec[1],m22=this.$vec[5],m23=this.$vec[9],m24=this.$vec[13];
			var m31=this.$vec[2],m32=this.$vec[6],m33=this.$vec[10],m34=this.$vec[14];
			var m41=this.$vec[3],m42=this.$vec[7],m43=this.$vec[11],m44=this.$vec[15];
			return m11 *(m22 *(m33 *m44-m43 *m34)-m32 *(m23 *m44-m43 *m24)+m42 *(m23 *m34-m33 *m24))-m21 *(m12 *(m33 *m44-m43 *m34)-m32 *(m13 *m44-m43 *m14)+m42 *(m13 *m34-m33 *m14))+m31 *(m12 *(m23 *m44-m43 *m24)-m22 *(m13 *m44-m43 *m14)+m42 *(m13 *m24-m23 *m14))-m41 *(m12 *(m23 *m34-m33 *m24)-m22 *(m13 *m34-m33 *m14)+m32 *(m13 *m24-m23 *m14));
		});

		__getset(0,__proto,'position',function(){
			return new Vector3D(this.$vec[12],this.$vec[13],this.$vec[14]);
			},function(pos){
			this.$vec[12]=pos.x;
			this.$vec[13]=pos.y;
			this.$vec[14]=pos.z;
		});

		__getset(0,__proto,'rawData',function(){
			return this.$vec;
			},function(v){
			if (v.length !=this.$vec.length){
				throw new Error("Data Error");
			}
			for (var i=0;i < v.length;i++){
				this.$vec[i]=v[i];
			}
		});

		Matrix3D.interpolate=LAYAFNNULL/*function(thisMat,toMat,percent){return null}*/
		return Matrix3D;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/geom/perspectiveprojection.as
	//class iflash.geom.PerspectiveProjection
	var PerspectiveProjection=(function(){
		function PerspectiveProjection(){}
		__class(PerspectiveProjection,'iflash.geom.PerspectiveProjection',true);
		var __proto=PerspectiveProjection.prototype;
		__proto.toMatrix3D=LAYAFNNULL/*function(){return null}*/
		__getset(0,__proto,'fieldOfView',LAYAFN0/*function(){return 0}*/,LAYAFNVOID/*function(fieldOfViewAngleInDegrees){}*/);
		__getset(0,__proto,'focalLength',LAYAFN0/*function(){return 0}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'projectionCenter',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(p){}*/);
		return PerspectiveProjection;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/geom/point.as
	//class iflash.geom.Point
	var Point=(function(){
		function Point(x,y){
			this.x=NaN;
			this.y=NaN;
			(x===void 0)&& (x=0);
			(y===void 0)&& (y=0);
			this.x=x*1;
			this.y=y*1;
		}

		__class(Point,'iflash.geom.Point',false);
		var __proto=Point.prototype;
		__proto.add=function(v){
			var result=new Point();
			result.x=this.x+v.x;
			result.y=this.y+v.y;
			return result;
		}

		__proto.clone=function(){
			var result=new Point();
			result.x=this.x;
			result.y=this.y;
			return result;
		}

		__proto.copyFrom=function(sourcePoint){
			this.x=sourcePoint.x;
			this.y=sourcePoint.y;
			return this;
		}

		__proto.equals=function(toCompare){
			if (toCompare==null)
				return false;
			else{
				if (toCompare.x==this.x && toCompare.y==this.y)
					return true;
				return false;
			}
		}

		__proto.normalize=function(thickness){
			var rate=thickness / this.length;
			this.x=rate *this.x;
			this.y=rate *this.y;
		}

		__proto.offset=function(dx,dy){
			this.x+=dx;
			this.y+=dy;
		}

		__proto.setTo=function(xa,ya){
			this.x=xa;
			this.y=ya;
			return this;
		}

		__proto.subtract=function(v){
			var result=new Point();
			result.x=this.x-v.x;
			result.y=this.y-v.y;
			return result;
		}

		__proto.identity=function(){
			this.x=this.y=0.0;
		}

		__proto.toString=function(){
			return "(x="+this.x+", y="+this.y+")";
		}

		__getset(0,__proto,'length',function(){
			return Math.sqrt(Math.pow(this.x ,2)+Math.pow(this.y,2));
		});

		Point.distance=function(pt1,pt2){
			return Math.sqrt(Math.pow((pt2.x-pt1.x),2)+Math.pow((pt2.y-pt1.y),2));
		}

		Point.interpolate=function(pt1,pt2,f){
			var f1=1-f;
			var result=new Point();
			result.x=pt1.x *f+pt2.x *f1;
			result.y=pt1.y *f+pt2.y *f1;
			return result;
		}

		Point.polar=function(len,angle){
			var result=new Point();
			result.x=len *Math.cos(angle);
			result.y=len *Math.sin(angle);
			return result;
		}

		__static(Point,
		['__DEFAULT__',function(){return this.__DEFAULT__=new Point();}
		]);
		return Point;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/geom/rectangle.as
	//class iflash.geom.Rectangle
	var Rectangle=(function(){
		function Rectangle(x,y,width,height){
			this.height=0;
			this.width=0;
			this.x=0;
			this.y=0;
			(x===void 0)&& (x=0);
			(y===void 0)&& (y=0);
			(width===void 0)&& (width=0);
			(height===void 0)&& (height=0);
			this.x=Number(x);
			this.y=Number(y);
			this.width=Number(width);
			this.height=Number(height);
		}

		__class(Rectangle,'iflash.geom.Rectangle',false);
		var __proto=Rectangle.prototype;
		__proto.clone=function(){
			return new Rectangle(this.x,this.y,this.width,this.height);
		}

		__proto.contains=function(_x,_y){
			if(_x<this.x||_y<this.y){
				return false;
			}
			return (_x<(this.x+this.width)&&_y<(this.y+this.height))
		}

		__proto.containsPoint=function(point){
			return this.contains(point.x,point.y);
		}

		__proto.containsRect=function(rect){
			return this.contains(rect.x,rect.y)&& this.contains(rect.x+rect.width,rect.y+rect.height);
		}

		__proto.copyFrom=function(sourceRect){
			this.x=sourceRect.x;
			this.y=sourceRect.y;
			this.width=sourceRect.width;
			this.height=sourceRect.height;
		}

		__proto.equals=function(toCompare){
			return this.x==toCompare.x && this.y==toCompare.y && this.width==toCompare.width && this.height==toCompare.height;
		}

		__proto.inflate=function(dx,dy){
			this.x-=dx;
			this.y-=dy;
			this.width+=dx*2;
			this.height+=dy*2;
		}

		__proto.inflatePoint=function(point){
			this.inflate(point.x,point.y);
		}

		__proto.intersection=function(toIntersect){
			var minr=Math.min(this.x+this.width,toIntersect.right);
			var minb=Math.min(this.y+this.height,toIntersect.bottom);
			var maxx=Math.max(this.x,toIntersect.x);
			var maxy=Math.max(this.y,toIntersect.y);
			return new Rectangle(maxx,maxy,minr-maxx,minb-maxy);
		}

		__proto.intersectionThis=function(toIntersect){
			var minr=Math.min(this.x+this.width,toIntersect.right);
			var minb=Math.min(this.y+this.height,toIntersect.bottom);
			this.x=Math.max(this.x,toIntersect.x);
			this.y=Math.max(this.y,toIntersect.y);
			this.width=minr-this.x;
			this.height=minb-this.y;
		}

		__proto.intersects=function(toIntersect){
			var minr=Math.min(this.x+this.width,toIntersect.right);
			var minb=Math.min(this.y+this.height,toIntersect.bottom);
			var maxx=Math.max(this.x,toIntersect.x);
			var maxy=Math.max(this.y,toIntersect.y);
			return minr > maxx && minb > maxy;
		}

		__proto.isEmpty=function(){
			return this.width<1 || this.height<1;
		}

		__proto.offset=function(dx,dy){
			this.x+=dx;
			this.y+=dy;
		}

		__proto.offsetPoint=function(point){
			this.x+=point.x;
			this.y+=point.y;
		}

		__proto.setEmpty=function(){
			this.x=this.y=this.width=this.height=0;
		}

		__proto.setTo=function(xa,ya,widtha,heighta){
			this.x=xa;
			this.y=ya;
			this.width=widtha;
			this.height=heighta;
			return this;
		}

		__proto.toString=function(){
			return "(x="+this.x+", y="+this.y+", w="+this.width+", h="+this.height+")";
		}

		__proto.union=function(toUnion){
			if (toUnion==null)return this;
			if(this.width==0 || this.height==0){
				return new Rectangle(toUnion.x,toUnion.y,toUnion.width,toUnion.height);
			}
			if(toUnion.width==0 || toUnion.height==0){
				return new Rectangle(this.x,this.y,this.width,this.height);
			};
			var maxr=Math.max(this.x+this.width,toUnion.right);
			var maxb=Math.max(this.y+this.height,toUnion.bottom);
			var minx=Math.min(this.x,toUnion.x);
			var miny=Math.min(this.y,toUnion.y);
			return new Rectangle(minx,miny,maxr-minx,maxb-miny);
		}

		__proto._union_=function(toUnion){
			if (toUnion==null)return this;
			if(this.width==0 || this.height==0){
				return this.setTo(toUnion.x,toUnion.y,toUnion.width,toUnion.height);
			}
			if(toUnion.width==0 || toUnion.height==0){
				return this.setTo(this.x,this.y,this.width,this.height);
			};
			var maxr=Math.max(this.x+this.width,toUnion.right);
			var maxb=Math.max(this.y+this.height,toUnion.bottom);
			var minx=Math.min(this.x,toUnion.x);
			var miny=Math.min(this.y,toUnion.y);
			return this.setTo(minx,miny,maxr-minx,maxb-miny);
		}

		__getset(0,__proto,'bottom',function(){
			return this.height+this.y;
			},function(value){
			this.height=value-this.y;
		});

		__getset(0,__proto,'top',function(){
			return this.y;
			},function(value){
			this.height-=value-this.y;
			this.y=value;
		});

		__getset(0,__proto,'bottomRight',function(){
			return new Point(this.x+this.width,this.height+this.y);
			},function(value){
			this.right=value.x;
			this.bottom=value.y;
		});

		__getset(0,__proto,'left',function(){
			return this.x;
			},function(value){
			this.width-=value-this.x;
			this.x=value;
		});

		__getset(0,__proto,'right',function(){
			return this.x+this.width;
			},function(value){
			this.width=value-this.x;
		});

		__getset(0,__proto,'size',function(){
			return new Point(this.width,this.height);
			},function(value){
			this.width=value.x;
			this.height=value.y;
		});

		__getset(0,__proto,'topLeft',function(){
			return new Point(this.x,this.y);
			},function(value){
			this.left=value.x;
			this.top=value.y;
		});

		__static(Rectangle,
		['__DEFAULT__',function(){return this.__DEFAULT__=new Rectangle;}
		]);
		return Rectangle;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/geom/transform.as
	//class iflash.geom.Transform
	var Transform=(function(){
		function Transform(){
			this._colorTransform_=null;
			this._rotate_=0;
			this.__node__=null;
			this._scale_=Transform.__SCALE__;
			this._skew_=Point.__DEFAULT__;
			this._matrix_=new Matrix();
		}

		__class(Transform,'iflash.geom.Transform',true);
		var __proto=Transform.prototype;
		__proto._setNode_=function(d){
			this.__node__=d;
			this._colorTransform_=ColorTransform._DEFAULT_;
			Laya.RENDERBYCANVAS && d && DrawTransform.insertUnit(d);
			return this;
		}

		__proto._setRotation_=function(value){
			if (value==this._rotate_)
				return;
			this._rotate_=value;
			this.__node__._type_ |=/*iflash.display.DisplayObject.TYPE_MATRIX_CHG*/0x20000;
			this.__node__._modle_.rotate2d(value);
			this.__node__._propagateFlagsDown_(/*iflash.display.DisplayObject.TYPE2_CONCATENATEDMATRIX_CHG*/0x1 | /*iflash.display.DisplayObject.TYPE2_BOUNDS_CHG*/0x4);
		}

		__proto._setScaleX_=function(value){
			if (value==this._scale_.x)
				return;
			(this._scale_ !=Transform.__SCALE__)?(this._scale_.x=value):(this._scale_=new Point(value,1));
			this.__node__._type_ |=/*iflash.display.DisplayObject.TYPE_MATRIX_CHG*/0x20000;
			this.__node__._modle_.scale2dEx(this._scale_.x,this._scale_.y);
			this.__node__._propagateFlagsDown_(/*iflash.display.DisplayObject.TYPE2_CONCATENATEDMATRIX_CHG*/0x1 | /*iflash.display.DisplayObject.TYPE2_BOUNDS_CHG*/0x4);
		}

		__proto._setScaleY_=function(value){
			if (value==this._scale_.y)return;
			(this._scale_ !=Transform.__SCALE__)?(this._scale_.y=value):(this._scale_=new Point(1,value));
			this.__node__._type_ |=/*iflash.display.DisplayObject.TYPE_MATRIX_CHG*/0x20000;
			this.__node__._modle_.scale2dEx(this._scale_.x,this._scale_.y);
			this.__node__._propagateFlagsDown_(/*iflash.display.DisplayObject.TYPE2_CONCATENATEDMATRIX_CHG*/0x1 | /*iflash.display.DisplayObject.TYPE2_BOUNDS_CHG*/0x4);
		}

		__proto._setSkewX_=function(value){
			if (value==this._skew_.x)
				return;
			(this._skew_ !=Point.__DEFAULT__)?(this._skew_.x=value):(this._skew_=new Point(value,0));
			this.__node__._type_ |=/*iflash.display.DisplayObject.TYPE_MATRIX_CHG*/0x20000;
			if (Laya.CONCHVER){
				var martix=this.matrix;
				this.__node__._modle_.matrix(martix.a,martix.b,martix.c,martix.d,0,0);
			}
			this.__node__._propagateFlagsDown_(/*iflash.display.DisplayObject.TYPE2_CONCATENATEDMATRIX_CHG*/0x1 | /*iflash.display.DisplayObject.TYPE2_BOUNDS_CHG*/0x4);
		}

		__proto._setSkewY_=function(value){
			if (value==this._skew_.y)
				return;
			(this._skew_ !=Point.__DEFAULT__)?(this._skew_.y=value):(this._skew_=new Point(0,value));
			this.__node__._type_ |=/*iflash.display.DisplayObject.TYPE_MATRIX_CHG*/0x20000;
			if (Laya.CONCHVER){
				var martix=this.matrix;
				this.__node__._modle_.matrix(martix.a,martix.b,martix.c,martix.d,0,0);
			}
			this.__node__._propagateFlagsDown_(/*iflash.display.DisplayObject.TYPE2_CONCATENATEDMATRIX_CHG*/0x1 | /*iflash.display.DisplayObject.TYPE2_BOUNDS_CHG*/0x4);
		}

		__getset(0,__proto,'matrix',function(){
			if ((this.__node__._type_ & /*iflash.display.DisplayObject.TYPE_MATRIX_CHG*/0x20000)==0)return this._matrix_.clone();
			this.__node__._type_ &=~ /*iflash.display.DisplayObject.TYPE_MATRIX_CHG*/0x20000;
			if (this._skew_.x==0.0 && this._skew_.y==0.0){
				if (this._rotate_==0.0){
					this._matrix_.setTo(this._scale_.x,0.0,0.0,this._scale_.y,this.__node__._left_,this.__node__._top_);
				}
				else{
					var cos=Math.cos(this._rotate_*Transform.ATOR);
					var sin=Math.sin(this._rotate_*Transform.ATOR);
					this._matrix_.a=this._scale_.x *cos;
					this._matrix_.b=this._scale_.x *sin;
					this._matrix_.c=this._scale_.y *-sin;
					this._matrix_.d=this._scale_.y *cos;
					this._matrix_.tx=this.__node__._left_;
					this._matrix_.ty=this.__node__._top_;
				}
			}
			else{
				this._matrix_.identity();
				this._matrix_.a=this._scale_.x;
				this._matrix_.d=this._scale_.y;
				Transform.__skew__(this._matrix_,this._skew_.x,this._skew_.y);
				this._matrix_.translate(this.__node__._left_,this.__node__._top_);
			}
			return this._matrix_.clone();
			},function(value){
			if(this._matrix_.IsEqual(value))return;
			this._matrix_.copy(value);
			this.__node__.x=this._matrix_.tx;
			this.__node__.y=this._matrix_.ty;
			this._skew_=(this._skew_!=Point.__DEFAULT__)?this._skew_:new Point();
			this._skew_.x=Math.atan(-this._matrix_.c / this._matrix_.d);
			this._skew_.y=Math.atan(this._matrix_.b / this._matrix_.a);
			if (this._skew_.x !=this._skew_.x)this._skew_.x=0.0;
			if (this._skew_.y !=this._skew_.y)this._skew_.y=0.0;
			this._scale_=(this._scale_!=Transform.__SCALE__)?this._scale_:new Point();
			this._scale_.y=(this._skew_.x >-Transform.PI_4 && this._skew_.x < Transform.PI_4)? this._matrix_.d / Math.cos(this._skew_.x)
			:-this._matrix_.c / Math.sin(this._skew_.y);
			this._scale_.x=(this._skew_.y >-Transform.PI_4 && this._skew_.y < Transform.PI_4)? this._matrix_.a / Math.cos(this._skew_.y)
			:this._matrix_.b / Math.sin(this._skew_.y);
			if(Math.abs(value.a*value.b)==Math.abs(value.c*value.d)){
				this._rotate_=Math.min(this._skew_.x*Transform.RTOA,this._skew_.y*Transform.RTOA);
				this._scale_.y=this._scale_.x=Math.min(this._scale_.y,this._scale_.x);
			}
			else{
				if ((this._skew_.x-0.0001 < this._skew_.y)&& (this._skew_.x+0.0001 > this._skew_.y)){
					this._rotate_=this._skew_.x*Transform.RTOA;
					this._skew_.x=this._skew_.y=0.0;
				}
				else this._rotate_=0.0;
			}
			if(value.a!=1|| value.b!=0|| value.c!=0|| value.d!=1)
				this.__node__._modle_.matrix(value.a,value.b,value.c,value.d,0,0);
			this.__node__._propagateFlagsDown_(/*iflash.display.DisplayObject.TYPE2_CONCATENATEDMATRIX_CHG*/0x1 | /*iflash.display.DisplayObject.TYPE2_BOUNDS_CHG*/0x4);
		});

		__getset(0,__proto,'colorTransform',function(){
			return this._colorTransform_==null?(this._colorTransform_=new ColorTransform()):this._colorTransform_;
			},function(value){
			this._colorTransform_=value;
		});

		__getset(0,__proto,'concatenatedMatrix',LAYAFNNULL/*function(){return null}*/);
		Transform.__skew__=function(matrix,skewX,skewY){
			var sinX=Math.sin(skewX);
			var cosX=Math.cos(skewX);
			var sinY=Math.sin(skewY);
			var cosY=Math.cos(skewY);
			matrix.setTransform(
			matrix.a *cosY-matrix.b *sinX,
			matrix.a *sinY+matrix.b *cosX,
			matrix.c *cosY-matrix.d *sinX,
			matrix.c *sinY+matrix.d *cosX,
			matrix.tx *cosY-matrix.ty *sinX,
			matrix.tx *sinY+matrix.ty *cosX);
			matrix;
		}

		Transform.__SCALE__=new Point(1,1);
		Transform.__DEFAULT__=new Transform();
		__static(Transform,
		['PI2',function(){return this.PI2=(Math.PI*2);},'PI_4',function(){return this.PI_4=(Math.PI/4);},'RTOA',function(){return this.RTOA=(180/Math.PI);},'ATOR',function(){return this.ATOR=(Math.PI/180);}
		]);
		return Transform;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/geom/vector3d.as
	//class iflash.geom.Vector3D
	var Vector3D=(function(){
		function Vector3D(x,y,z,w){
			this.$x=0;
			this.$y=0;
			this.$z=0;
			this.$w=0;
			(x===void 0)&& (x=0);
			(y===void 0)&& (y=0);
			(z===void 0)&& (z=0);
			(w===void 0)&& (w=0);
			this.$x=x;
			this.$y=y;
			this.$z=z;
			this.$w=w;
		}

		__class(Vector3D,'iflash.geom.Vector3D',false);
		var __proto=Vector3D.prototype;
		__proto.add=function(a){
			return new Vector3D(this.$x+a.x,this.$y+a.y,this.$z+a.z);
		}

		__proto.clone=function(){
			return new Vector3D(this.$x,this.$y,this.$z,this.$w);
		}

		__proto.copyFrom=function(sourceVector3D){
			this.$x=sourceVector3D.x;
			this.$y=sourceVector3D.y;
			this.$z=sourceVector3D.z;
		}

		__proto.crossProduct=function(a){
			return new Vector3D(this.$y *a.z-this.$z *a.y,this.$z *a.x-this.$x *a.z,this.$x *a.y-this.$y *a.x,1.0);
		}

		__proto.decrementBy=function(a){
			this.$x-=a.x;
			this.$y-=a.y;
			this.$z-=a.z;
		}

		__proto.dotProduct=function(a){
			return (this.$x *a.x+this.$y *a.y+this.$z *a.z);
		}

		__proto.equals=function(toCompare,allFour){
			(allFour===void 0)&& (allFour=false);
			return (this.$x==toCompare.x)&& (this.$y==toCompare.y)&& (this.$z==toCompare.z)&& (!allFour || (this.$w==toCompare.w));
		}

		__proto.incrementBy=function(a){
			this.$x+=a.x;
			this.$y+=a.y;
			this.$z+=a.z;
		}

		__proto.nearEquals=function(toCompare,tolerance,allFour){
			(allFour===void 0)&& (allFour=false);
			return (Math.abs(this.$x-toCompare.x)< tolerance)&& (Math.abs(this.$y-toCompare.y)< tolerance)&& (Math.abs(this.$z-toCompare.z)< tolerance)&& (!allFour || (Math.abs(this.$w-toCompare.w)< tolerance));
		}

		__proto.negate=function(){
			this.$x=-this.$x;
			this.$y=-this.$y;
			this.$z=-this.$z;
		}

		__proto.normalize=function(){
			var length=length;
			if (length!=0){
				this.$x/=length;
				this.$y/=length;
				this.$z/=length;
			}
			else{
				this.$x=this.$y=this.$z=0;
			}
			return length;
		}

		__proto.project=function(){
			this.$x/=this.$w;
			this.$y/=this.$w;
			this.$z/=this.$w;
		}

		__proto.scaleBy=function(s){
			this.$x*=s;
			this.$y*=s;
			this.$z*=s;
		}

		__proto.setTo=function(xa,ya,za){
			this.$x=xa;
			this.$y=ya;
			this.$z=za;
		}

		__proto.subtract=function(a){
			return new Vector3D(this.$x-a.x,this.$y-a.y,this.$z-a.z);
		}

		__proto.toString=function(){
			return "Vector3D("+this.$x+", "+this.$y+", "+this.$z+")";
		}

		__getset(0,__proto,'x',function(){
			return this.$x;
			},function(val){
			this.$x=val;
		});

		__getset(0,__proto,'y',function(){
			return this.$y;
			},function(val){
			this.$y=val;
		});

		__getset(0,__proto,'z',function(){
			return this.$z;
			},function(val){
			this.$z=val;
		});

		__getset(0,__proto,'w',function(){
			return this.$w;
			},function(val){
			this.$w=val;
		});

		__getset(0,__proto,'length',function(){
			return Math.sqrt(this.lengthSquared);
		});

		__getset(0,__proto,'lengthSquared',function(){
			return (this.$x *this.$x+this.$y *this.$y+this.$z *this.$z);
		});

		Vector3D.angleBetween=function(a,b){
			return Math.acos(a.dotProduct(b)/ (a.length *b.length));
		}

		Vector3D.distance=function(pt1,pt2){
			return pt1.subtract(pt2).length;
		}

		__static(Vector3D,
		['X_AXIS',function(){return this.X_AXIS=new Vector3D(1,0,0);},'Y_AXIS',function(){return this.Y_AXIS=new Vector3D(0,1,0);},'Z_AXIS',function(){return this.Z_AXIS=new Vector3D(0,0,1);}
		]);
		return Vector3D;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/display/canvas.as
	//class iflash.laya.display.Canvas
	var Canvas=(function(){
		function Canvas(){
			this.context=null;
			this.context3D=null;
			this.activTime=NaN;
			this._active_=0;
			this.decX=0;
			this.decY=0;
			this._width_=0;
			this._height_=0;
			this.left=0;
			this.top=0;
			this.style=null;
		}

		__class(Canvas,'iflash.laya.display.Canvas',true);
		var __proto=Canvas.prototype;
		__proto.getContext=function(type,vars){
			switch(type){
				case '2d':
					return this.context;
				case "experimental-webgl":
					return this.context3D;
				}
		}

		__proto.size=function(w,h){
			if (w !=this._width_ || h !=this._height_){
				this._width_=w;
				this._height_=h;
				this.width=w;
				this.height=h;
				if(this.context){
					this.context.widthMe=w;
					this.context.heightMe=h;
				}
			}
		}

		__proto.active=function(){
			this.activTime=Laya.window.updateTime;
			if (this._active_ > 0)return true;
			Canvas.enable(this);
			return false;
		}

		__proto.reset=function(){
			this.context.filter=null;
			this.context.textAlign="left";
			this.context.textBaseline="top";
		}

		__proto._getType_=function(){
			return 3;
		}

		__proto.isReady=function(){
			return true;
		}

		__proto.getContent=function(){
			return this;
		}

		__proto.clone=function(){
			var canvas=Canvas.create();
			canvas.context=canvas.getContext("2d");
			canvas.size(this.width,this.height);
			canvas.context.drawImage(this,0,0,this.width,this.height);
			return canvas;
		}

		__proto.setCanvasType=LAYAFNVOID/*function(type){}*/
		__getset(0,__proto,'width',function(){
			return this._width_;
			},function(w){
			if (w !=this._width_)this.size(w,this._height_);
		});

		__getset(0,__proto,'height',function(){
			return this._height_;
			},function(h){
			if (h !=this._height_)this.size(this._width_,h);
		});

		Canvas.getTempCanvas=function(){
			return Canvas._TEMP_=Canvas._TEMP_ || Canvas.create();
		}

		Canvas.create=function(){
			return Browser.document.createElement('canvas');
		}

		Canvas.__on_new__=function(c){
			if (!c.size){
				c.size=Canvas._DEFAULT_.size;
				c.active=Canvas._DEFAULT_.active;
				c.isReady=Canvas._DEFAULT_.isReady;
				c._getType_=Canvas._DEFAULT_._getType_;
				c.left=Canvas._DEFAULT_.left;
				c.top=Canvas._DEFAULT_.top;
				c.decX=c.decY=0;
				c.getContent=Canvas._DEFAULT_.getContent;
				c.clone=Canvas._DEFAULT_.clone;
			}
			/*__JS__ */if(iflash.laya.display.Canvas._bIs3D){iflash.laya.display.Canvas._Canvas3DInited=true;this.enable3D(c);}else this.enable(c);
		}

		Canvas.enableTimeoutRelease=function(c,b){
			if (b)c._active_=c._active_<0?c._active_:1;
			else c._active_=Canvas._DISABLETIMEOUTRELEASE_;
		}

		Canvas.disable=function(c){
			if (c.context){
				c.context.canvas=null;
				c.context=null;
			}
		}

		Canvas.destroy=function(c){
			Canvas.disable(c);
		}

		Canvas.enable=function(c){
			c.context=c.getContext('2d');
			c.context.canvas=c;
		}

		Canvas.enable3D=function(c){
			c.context3D=c.getContext("webgl",{alpha:false,stencil:true })|| c.getContext("experimental-webgl",{alpha:false,stencil:true });
			/*__JS__ */try{if(WebGLDebugUtils ){c.context3D=WebGLDebugUtils.makeDebugContext(c.context3D );}}catch(error ){};
			c.context3D && (c.context3D.canvas=c);
			/*__JS__ */if(window.conch ){SetupWebglContext(c.context3D);};
		}

		Canvas._DISABLETIMEOUTRELEASE_=10000;
		Canvas._Canvas3DInited=false;
		Canvas._TEMP_=null
		Canvas._bIs3D=false;
		__static(Canvas,
		['_DEFAULT_',function(){return this._DEFAULT_=new Canvas();}
		]);
		return Canvas;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/display/context.as
	//class iflash.laya.display.Context
	var Context=(function(){
		function Context(){}
		__class(Context,'iflash.laya.display.Context',true);
		var __proto=Context.prototype;
		__proto.getBitMap=function(){
			return null;
		}

		return Context;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/display/displaymethod.as
	//class iflash.laya.display.DisplayMethod
	var DisplayMethod=(function(){
		function DisplayMethod(){}
		__class(DisplayMethod,'iflash.laya.display.DisplayMethod',true);
		DisplayMethod.JpgToPng=function(img){
			var i=0,x=0,y=0,w=0,h=0,imageDataSrc,pixelsSrc,imageDataAlpha,pixelsAlpha,alpha;
			var src=Canvas.create();
			w=img.width;
			h=Math.floor((img.height-1)/ 2);
			src.size(w,h);
			src.context.drawImage(img,0,0,w,h,0,0,w,h);
			imageDataSrc=src.context.getImageData(0,0,w,h);
			pixelsSrc=imageDataSrc.data;
			alpha=Canvas.getTempCanvas();;
			alpha.active();
			alpha.size(w,h);
			alpha.context.drawImage(img,0,h+2,w,h,0,0,w,h);
			imageDataAlpha=alpha.context.getImageData(0,0,w,h);
			pixelsAlpha=imageDataAlpha.data;
			for (y=0;y < h;y++){
				i=(y *w)<< 2;
				x=0;
				while (x < w){
					i+=4;
					x++;
					pixelsSrc[i+3]=pixelsAlpha[i];
				}
			}
			src.context.putImageData(imageDataSrc,0,0);
			return src;
		}

		return DisplayMethod;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/display/imodel.as
	//class iflash.laya.display.IModel
	var IModel=(function(){
		function IModel(n){
			this.jnode=null;
			this.jnode=n;}
		__class(IModel,'iflash.laya.display.IModel',true);
		var __proto=IModel.prototype;
		__proto.setHideText=LAYAFNVOID/*function(b){}*/
		__proto.vcanvas=LAYAFNVOID/*function(vcanvas){}*/
		__proto.reset=LAYAFNVOID/*function(id,jnode){}*/
		__proto.uploadCmd=LAYAFNVOID/*function(d){}*/
		__proto.pos=LAYAFNVOID/*function(x,y){}*/
		__proto.zIndex=LAYAFNVOID/*function(d){}*/
		__proto.size=LAYAFNVOID/*function(w,h){}*/
		__proto.scale2d=LAYAFNVOID/*function(x,y){}*/
		__proto.scale2dEx=LAYAFNVOID/*function(x,y){}*/
		__proto.rotate2d=LAYAFNVOID/*function(r){}*/
		__proto.bgcolor=LAYAFNVOID/*function(rgb){}*/
		__proto.bgimg=LAYAFNVOID/*function(_img,repeat){}*/
		__proto.position=LAYAFNVOID/*function(type){}*/
		__proto.image=function(img,b){
			(b===void 0)&& (b=false);
		}

		__proto.bitmapdataContent=LAYAFNVOID/*function(bitmapdataContent){}*/
		__proto.border=LAYAFNVOID/*function(type){}*/
		__proto.font=LAYAFNVOID/*function(f){}*/
		__proto.text=LAYAFNVOID/*function(txt){}*/
		__proto.textStrs=LAYAFNVOID/*function(txt){}*/
		__proto.clip=LAYAFNVOID/*function(b){}*/
		__proto.insert=LAYAFNVOID/*function(c,index,sz){}*/
		__proto.flip=LAYAFNVOID/*function(f){}*/
		__proto.padding=LAYAFNVOID/*function(l,t,r,b){}*/
		__proto.margin=LAYAFNVOID/*function(l,t,r,b){}*/
		__proto.scroll=LAYAFNVOID/*function(x,y){}*/
		__proto.alpha=LAYAFNVOID/*function(a){}*/
		__proto.filter=LAYAFNVOID/*function(r,g,b,gray){}*/
		__proto.globalCompositeOperation=LAYAFNVOID/*function(nType){}*/
		__proto.show=LAYAFNVOID/*function(b){}*/
		__proto.destroy=LAYAFNVOID/*function(){}*/
		__proto.destroyAllChild=LAYAFNVOID/*function(){}*/
		__proto.swap=LAYAFNVOID/*function(frome,to){}*/
		__proto.removeAt=LAYAFNVOID/*function(i,c,sz){}*/
		__proto.setOrigin=LAYAFNVOID/*function(x,y,xtype,ytype){}*/
		__proto.color=LAYAFNVOID/*function(rgb){}*/
		__proto.setToCanvas=LAYAFNVOID/*function(canvas){}*/
		__proto.quote=LAYAFNVOID/*function(m){}*/
		__proto.quoteEx=LAYAFNVOID/*function(m,bool){}*/
		__proto.matrix=LAYAFNVOID/*function(a,b,c,d,tx,ty){}*/
		__proto.virtualBitmap=LAYAFNVOID/*function(virtualBitmap){}*/
		__proto.drawImage9=LAYAFNVOID/*function(img,sx,sy,sw,sh,dx,dy,dw,dh){}*/
		__proto.drawImage3=LAYAFNVOID/*function(img,x,y){}*/
		__proto.flashClip=LAYAFNVOID/*function(x,y,w,h){}*/
		__proto.removeClip=LAYAFNVOID/*function(){}*/
		__proto.mask=LAYAFNVOID/*function(d){}*/
		__proto.textView=LAYAFNVOID/*function(x,y){}*/
		__static(IModel,
		['__DEFAULT__',function(){return this.__DEFAULT__=new IModel(null);}
		]);
		return IModel;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/display/virtualcanvas.as
	//class iflash.laya.display.VirtualCanvas
	var VirtualCanvas=(function(){
		function VirtualCanvas(){
			this._cmds_=[];
			this.imageNum=0;
			this.loaded=0;
			this.width=0;
			this.height=0;
			this.baseImage=null;
			this.onComplete=null;
			this.conchVirtualBitmap=null;
			this.widthScale=1;
			this.heightScale=1;
			this.inMap=false;
			if(Laya.CONCHVER){
			}
		}

		__class(VirtualCanvas,'iflash.laya.display.VirtualCanvas',true);
		var __proto=VirtualCanvas.prototype;
		__proto._check_=function(){
			if(this.conchVirtualBitmap&&!this.inMap){
				ConchRenderVCanvas.maps.push(this);
				this.inMap=true;
			}
		}

		__proto._conchResize_=function(){
			if (Laya.CONCHVER){
				if (!this.conchVirtualBitmap)this.conchVirtualBitmap=/*__JS__ */new ConchVirtualBitmap();
				this.conchVirtualBitmap.size(this.width,this.height);
			}
		}

		__proto.size=function(w,h){
			this.width=w;
			this.height=h;
			this._conchResize_();
		}

		__proto.setImage=function(data){
			this.clear();
			this.baseImage=data;
			this.drawImage(data,0,0);
			this._check_();
		}

		__proto.changeImage=function(img){
			if(this.baseImage!=img)
				this.setImage(img);
		}

		__proto.isNormal=function(){
			return (this.baseImage && this._cmds_.length==1);
		}

		__proto.getImage=function(){
			return this.baseImage;
		}

		__proto.removeImage=function(){
			this.baseImage=null;
		}

		__proto.checkCMDfull=function(){
			if (this._cmds_.length > VirtualCanvas.MAXCMDNUM){
			}
		}

		__proto.drawMartixImage=function(souce,m,clipRect){
			if (souce._cmds_.length==0)
				return;
			if (m.b==0 && m.c==0&&m.a>0&&m.d>0&&souce.isNormal()){
				this.drawImage(souce.baseImage,(clipRect.x-m.tx)/ m.a,
				(clipRect.y-m.ty)/m.d,
				clipRect.width/m.a,
				clipRect.height/m.d,
				clipRect.x,
				clipRect.y,
				clipRect.width,
				clipRect.height);
			}
			else{
				VirtualCanvas._DEFAULT_.clear();
				VirtualCanvas._DEFAULT_.save();
				VirtualCanvas._DEFAULT_.beginPath();
				VirtualCanvas._DEFAULT_.rect(clipRect.x,clipRect.y,clipRect.width,clipRect.height);
				VirtualCanvas._DEFAULT_.clip();
				VirtualCanvas._DEFAULT_.transform(m.a,m.b,m.c,m.d,m.tx,m.ty);
				souce.copyTo(VirtualCanvas._DEFAULT_);
				VirtualCanvas._DEFAULT_.restore();
				this.drawVCanvas([VirtualCanvas._DEFAULT_._cmds_,clipRect.x,clipRect.y,clipRect.width,clipRect.height,clipRect.x,clipRect.y,clipRect.width,clipRect.height]);
			}
		}

		__proto.drawVCanvas=function(args){
			this._cmds_.push(["_drawVCanvas_",args]);
			var cmds=args[0];
			for (var i=0,n=cmds.length;i < n;i++){
				if (cmds[i][0].indexOf("_drawImage")!=-1){
					this._loadImg_(cmds[i][1][0]);
				}
			}
			this._check_();
		}

		__proto.save=function(){
			this._cmds_.push(["_save_",null]);
			this._check_();
		}

		__proto.restore=function(){
			this.checkCMDfull();
			this._cmds_.push(["_restore_",null]);
			this._check_();
		}

		__proto.beginPath=function(){
			this._cmds_.push(["_beginPath_",null]);
			this._check_();
		}

		__proto.drawImage=function(__args){
			var args=arguments;
			this.checkCMDfull();
			var obj=args[0];
			var soucecmd=obj._cmds_;
			if(obj.width > 0 && obj.width < args[3])args[3]=obj.width;
			if(obj.width > 0 && obj.height < args[4])args[4]=obj.height;
			if (soucecmd){
				if (soucecmd.length==1&&soucecmd[0][1].length==3){
					args[0]=soucecmd[0][1][0];
					this.drawImage.apply(this,args);
					return;
				};
				var scalex=args[7] / args[3];
				var scaley=args[8] / args[4];
				VirtualCanvas._DEFAULT_.clear();
				VirtualCanvas._DEFAULT_.save();
				VirtualCanvas._DEFAULT_.translate(args[5],args[6]);
				if (args[3] < obj.width || args[4] < obj.height){
					VirtualCanvas._DEFAULT_.beginPath();
					VirtualCanvas._DEFAULT_.rect(0,0,args[7],args[8]);
					VirtualCanvas._DEFAULT_.clip();
				}
				VirtualCanvas._DEFAULT_.scale(scalex,scaley);
				VirtualCanvas._DEFAULT_.translate(-args[1],-args[2]);
				obj.copyTo(VirtualCanvas._DEFAULT_);
				VirtualCanvas._DEFAULT_.restore();
				args[0]=VirtualCanvas._DEFAULT_._cmds_;
				this.drawVCanvas(args);
			}
			else{
				if(args.length==3)
					this._cmds_.push(["_drawImage3_",args]);
				else if (args.length==5)
				this._cmds_.push(["_drawImage5_",args]);
				else
				this._cmds_.push(["_drawImage9_",args]);
				this._loadImg_(obj);
				this._check_();
			}
		}

		__proto.rect=function(x,y,w,h){
			this._cmds_.push(["_rect_",[x,y,w,h]]);
			this._check_();
		}

		__proto.clip=function(){
			this._cmds_.push(["_clip_",null]);
			this._check_();
			return true;
		}

		__proto.scale=function(x,y){
			if (x==1 && y==1)return;
			this._cmds_.push(["_scale_",[x,y]]);
			this._check_();
		}

		__proto.translate=function(x,y){
			if (x==0 && y==0)return;
			this._cmds_.push(["_translate_",[x,y]]);
			this._check_();
		}

		__proto.transform=function(a,b,c,d,tx,ty){
			this._cmds_.push(["_transform_",[a,b,c,d,tx,ty]]);
			this._check_();
		}

		__proto.clearRect=function(x,y,w,h){
			if (x==0 && y==0 && w==this.width && h==this.height){
				this.clear();
				return;
			};
			var cmd1;
			var ex=x+w,ey=y+h;
			for (var i=0,sz=this._cmds_.length;i < sz;i++){
				var cmd=this._cmds_[i];
				if ((cmd[0]=="_drawVCanvas_"||cmd[0]=="_drawImage9_")&& (cmd1=cmd[1])[5] >=x && cmd1[6] >=y && (cmd1[5]+cmd1[7])<=ex && (cmd1[6]+cmd1[8])<=ey){
					this._cmds_.splice(i,1);
					i--;
					sz--;
				}
			}
			this._check_();
		}

		__proto.closePath=function(){
			this._cmds_.push(["_closePath_",null]);
			this._check_();
		}

		__proto.fillRect=function(x,y,w,h){
			this._cmds_.push(["_fillRect_",[x,y,w,h]]);
			this._check_();
		}

		__proto.stroke=function(){
			this._cmds_.push(["_stroke_",null]);
			this._check_();
		}

		__proto.strokeRect=function(x,y,w,h){
			this._cmds_.push(["_strokeRect_",[x,y,w,h]]);
			this._check_();
		}

		__proto.strokeText=function(word,x,y){
			if (!Laya.CONCHVER){
				this._cmds_.push(["_strokeText_",[word,x,y]]);
				this._check_();
			}
		}

		__proto.fillText=function(word,x,y){
			word=word.replace(VirtualCanvas.pre,function(){
				var charMap={
					"\0":"0",
					"\1":"1",
					"\2":"2",
					"\3":"3",
					"\4":"4",
					"\5":"5",
					"\6":"6",
					"\7":"7"
				};
				return charMap[arguments[0]] || arguments[0];
			});
			this._cmds_.push(["_fillText_",[word,x,y]]);
			this._check_();
		}

		__proto.fill=function(){
			this._cmds_.push(["_fill_",null]);
			this._check_();
		}

		__proto.moveTo=function(x,y){
			this._cmds_.push(["_moveTo_",[x,y]]);
			this._check_();
		}

		__proto.lineTo=function(x,y){
			this._cmds_.push(["_lineTo_",[x,y]]);
			this._check_();
		}

		__proto.arc=function(x,y,r,sAngle,eAngle,bCounterclockwise){
			this._cmds_.push(["_arc_",[x,y,r,sAngle,eAngle,bCounterclockwise]]);
			this._check_();
		}

		__proto.arcTo=function(x1,y1,x2,y2,radium){
			this._cmds_.push(["_arcTo_",[x1,y1,x2,y2,radium]]);
			this._check_();
		}

		__proto.bezierCurveTo=function(nCPX,nCPY,nCPX2,nCPY2,nEndX,nEndY){
			this._cmds_.push(["_bezierCurveTo_",[nCPX,nCPY,nCPX2,nCPY2,nEndX,nEndY]]);
			this._check_();
		}

		__proto.quadraticCurveTo=function(left,top,width,height){
			this._cmds_.push(["_quadraticCurveTo_",[left,top,width,height]]);
			this._check_();
		}

		__proto.fillImage=function(img,x,y,w,h){
			this._cmds_.push(["_drawRepeat_",[img,x,y,w,h]]);
			this._check_();
		}

		__proto._drawRepeat_=function(context,args){
			if ((context instanceof iflash.laya.display.VirtualCanvas )){
				(context).fillImage.apply(context,args);
				return
			};
			var myPattern=context.createPattern(args[0],'repeat');
			context.fillStyle=myPattern;
			context.fillRect(args[1],args[2],args[3],args[4]);
		}

		__proto._transform_=function(context,args){
			context.transform.apply(context,args);
		}

		__proto._beginPath_=function(context,args){
			context.beginPath();
		}

		__proto._closePath_=function(context,args){
			context.closePath();
		}

		__proto._fillStyle_=function(context,args){
			context.fillStyle=args[0];
		}

		__proto._globalAlpha_=function(context,args){
			context.globalAlpha=args[0];
		}

		__proto._globalCompositeOperation_=function(context,args){
			context.globalCompositeOperation=args[0];
		}

		__proto._lineCap_=function(context,args){
			context.lineCap=args[0];
		}

		__proto._lineWidth_=function(context,args){
			context.lineWidth=args[0];
		}

		__proto._lineJoin_=function(context,args){
			context.lineJoin=args[0];
		}

		__proto._strokeStyle_=function(context,args){
			context.strokeStyle=args[0];
		}

		__proto._stroke_=function(context,args){
			context.stroke();
		}

		__proto._strokeRect_=function(context,args){
			context.strokeRect.apply(context,args);
		}

		__proto._translate_=function(context,args){
			context.translate.apply(context,args);
		}

		__proto._scale_=function(context,args){
			context.scale.apply(context,args);
		}

		__proto._save_=function(context,args){
			context.save();
		}

		__proto._restore_=function(context,args){
			context.restore();
		}

		__proto._strokeText_=function(context,args){
			context.strokeText.apply(context,args);
		}

		__proto._fillText_=function(context,args){
			context.fillText.apply(context,args);
		}

		__proto._fill_=function(context,args){
			context.fill();
		}

		__proto._moveTo_=function(context,args){
			context.moveTo.apply(context,args);
		}

		__proto._lineTo_=function(context,args){
			context.lineTo.apply(context,args);
		}

		__proto._arc_=function(context,array){
			context.arc.apply(context,array);
		}

		__proto._arcTo_=function(context,args){
			context.arcTo.apply(context,args);
		}

		__proto._bezierCurveTo_=function(context,args){
			context.bezierCurveTo.apply(context,args);
		}

		__proto._quadraticCurveTo_=function(context,args){
			context.quadraticCurveTo.apply(context,args);
		}

		__proto._clip_=function(context,args){
			context.clip();
		}

		__proto._rect_=function(context,args){
			context.rect.apply(context,args);
		}

		__proto._drawImage3_=function(context,args){
			context.drawImage.apply(context,args);
		}

		__proto._drawImage5_=function(context,args){
			context.drawImage.apply(context,args);
		}

		__proto._drawImage9_=function(context,args){
			context.drawImage.apply(context,args);
		}

		__proto._drawVCanvas_=function(context,args){
			var cmds=args[0];
			for (var i=0,n=cmds.length;i < n;i++){
				this[cmds[i][0]].call(this,context,cmds[i][1]);
			}
		}

		__proto._font_=function(context,args){
			context.font=args[0];
		}

		__proto._textBaseline_=function(context,args){
			context.textBaseline=args[0];
		}

		__proto._loadImg_=function(obj){
			var _$this=this;
			return;
			this.imageNum++;
			if (obj.isReady()){
				this.loaded++;
				this._checkloadComplete();
			}
			else{
				obj.addEventListener("load",function(e){
					_$this.loaded++;
					_$this._checkloadComplete();
				});
			}
		}

		__proto._checkloadComplete=function(){
			if (this.imageNum==this.loaded)
				this.onComplete && this.onComplete();
		}

		__proto.isReady=function(){
			return(this.imageNum==this.loaded);
		}

		__proto.copyTo=function(to){
			for (var i=0,n=this._cmds_.length;i < n;i++){
				this[this._cmds_[i][0]].call(this,to,this._cmds_[i][1]);
			}
		}

		__proto.paint=function(context,x,y,w,h){
			var hasScale=false;
			if (w > 0 && h > 0){
				this.widthScale=w / this.width;
				this.heightScale=h / this.height;
				hasScale=(this.widthScale !=1 || this.heightScale !=1);
			};
			var len=this._cmds_.length;
			var b=(x==0 && y==0);
			switch(len){
				case 0:return;
				case 1:
					if (hasScale)
						context.save();
					if (!b){
						context.translate(x,y);
						hasScale&&context.scale(this.widthScale,this.heightScale);
						this[this._cmds_[0][0]].call(this,context,this._cmds_[0][1]);
						context.translate(-x,-y);
					}
					else{
						hasScale&&context.scale(this.widthScale,this.heightScale);
						this[this._cmds_[0][0]].call(this,context,this._cmds_[0][1]);
					}
					if (hasScale)
						context.restore();
					break ;
				default :
					context.save();
					!b && context.translate(x,y);
					if (this.widthScale !=1 || this.heightScale !=1)
						context.scale(this.widthScale,this.heightScale);
					for (var i=0,n=this._cmds_.length;i < n;i++){
						this[this._cmds_[i][0]].call(this,context,this._cmds_[i][1]);
					}
					context.restore();
				}
		}

		__proto._fillRect_=function(context,args){
			context.fillRect.apply(context,args);
		}

		__proto.getContext=function(type){
			return this;
		}

		__proto.clear=function(){
			this._cmds_=[];
			this.baseImage=null;
			this._check_();
		}

		__proto.clone=function(){
			var result=new VirtualCanvas();
			this.copyTo(result);
			result.baseImage=this.baseImage;
			result.width=this.width;
			result.height=this.height;
			result._conchResize_();
			return result;
		}

		__getset(0,__proto,'context',function(){
			return this;
		});

		__getset(0,__proto,'font',null,function(f){
			this._cmds_.push(["_font_",[f]]);
			this._check_();
		});

		__getset(0,__proto,'lineJoin',null,function(s){
			this._cmds_.push(["_lineJoin_",[s]]);
			this._check_();
		});

		__getset(0,__proto,'strokeStyle',null,function(color){
			this._cmds_.push(["_strokeStyle_",[color]]);
			this._check_();
		});

		__getset(0,__proto,'globalAlpha',null,function(n){
			if (n==1)return;
			this._cmds_.push(["_globalAlpha_",[n]]);
			this._check_();
		});

		__getset(0,__proto,'fillStyle',null,function(style){
			this._cmds_.push(["_fillStyle_",[style]]);
			this._check_();
		});

		__getset(0,__proto,'globalCompositeOperation',null,function(value){
			this._cmds_.push(["_globalCompositeOperation_",[value]]);
			this._check_();
		});

		__getset(0,__proto,'lineCap',null,function(s){
			this._cmds_.push(["_lineCap_",[s]]);
			this._check_();
		});

		__getset(0,__proto,'lineWidth',null,function(n){
			this._cmds_.push(["_lineWidth_",[n]]);
			this._check_();
		});

		__getset(0,__proto,'textBaseline',null,function(f){
			this._cmds_.push(["_textBaseline_",[f]]);
			this._check_();
		});

		VirtualCanvas.getConchSring=function(p_cmd){
			var temp="";
			for (var i=0,len=p_cmd.length;i < len;i++){
				var cmd=p_cmd[i];
				var funId=ConchRenderVCanvas.CMDMAP[cmd[0]];
				if (funId==-1){
					temp+=VirtualCanvas.getConchSring(cmd[1][0]);
				}
				else if (cmd[0].indexOf("draw")!=-1){
					var s=Array.prototype.slice.call(cmd[1]);
					s[0]=s[0].imgId;
					temp+=(funId+/*iflash.utils.stringContextCMD.COMMA*/'\4'+s.join(/*iflash.utils.stringContextCMD.COMMA*/'\4'));
				}
				else{
					if (cmd[1]==null){
						temp+=funId;
					}
					else{
						temp+=(funId+/*iflash.utils.stringContextCMD.COMMA*/'\4'+cmd[1].join(/*iflash.utils.stringContextCMD.COMMA*/'\4'));
					}
				}
				if (i !=len-1){
					temp+=/*iflash.utils.stringContextCMD.SEMICOLON*/'\5';
				}
			}
			return temp;
		}

		VirtualCanvas._DEFAULT_=new VirtualCanvas();
		VirtualCanvas.MAXCMDNUM=200;
		__static(VirtualCanvas,
		['pre',function(){return this.pre=new RegExp("[\0\1\2\3\4\5\6\7\8\9]","g");}
		]);
		return VirtualCanvas;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/driver/document.as
	//class iflash.laya.driver.Document
	var Document3=(function(){
		function Document(){
			this.body=null;
			this.head=null;
			this.onselectstart=null;
			this.ontouchmove=null;
			this.onmousewheel=null;
			this.onscroll=null;
			this._addEventListener_=null;
			this._createElement_=null;
		}

		__class(Document,'iflash.laya.driver.Document',true,null,'Document3');
		var __proto=Document.prototype;
		__proto.addEventListener=function(type,callBack,useCapture){
			if(this._addEventListener_!=null)
				this._addEventListener_.call(this,type,callBack,useCapture);
			else
			this.attachEvent("on"+type,callBack);
		}

		__proto.getElementsByTagName=LAYAFNNULL/*function(value){return null}*/
		__proto.attachEvent=function(type,callBack){}
		__proto.createElement=function(tagName){
			var _$this=this;
			switch(tagName){
				case 'virtualBitmap':
					return new VirtualCanvas();
				case 'canvas':;
					var o=this._createElement_.call(this,tagName);
					Canvas.__on_new__(o);
					return o;
				case 'img':
				case 'image':;
					var img=this._createElement_.call(this,"img");
					img.left=img.top=0;
					if (img._getType_==null){
						img._getType_=function (){return 1;};
						img.getContent=function (){return this;};
						img.isReady=function (){return this.width > 0;};
						img.rect=function (x,y,w,h){
							this.left=x;
							this.top=y;
							this.width=w;
							this.height=h;
						}
						if (!img.clone){
							var _this=this;
							img.clone=function (){
								var nimg=_$this.createElement("img");
								nimg.width=this.width;
								nimg.height=this.height;
								nimg.left=this.left;
								nimg.top=this.top;
								nimg.src=this.src;
								return nimg;
							}
						}
					}
					return img;
				}
			return this._createElement_.call(this,tagName);
		}

		__getset(0,__proto,'title',null,function(t){
		});

		Document.__init__=function(doc){
			doc._addEventListener_=doc.addEventListener;
			doc.addEventListener=Document.__TMP__.addEventListener;
			doc._createElement_=doc.createElement;
			doc.createElement=Document.__TMP__.createElement;
		}

		__static(Document,
		['__TMP__',function(){return this.__TMP__=new Document;}
		]);
		return Document;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/driver/driver.as
	//class iflash.laya.driver.Driver
	var Driver=(function(){
		function Driver(sprite){
			this._frameRate_=NaN;
			this.tempId=null;
			this.buttonDown=false;
			this.create(sprite);
			this._init_(sprite);
		}

		__class(Driver,'iflash.laya.driver.Driver',true);
		var __proto=Driver.prototype;
		__proto.create=function(sprite){
			Browser.document=/*__JS__ */document;
			Browser.window=/*__JS__ */window;
			Browser.location=/*__JS__ */location;
			Browser.navigator=/*__JS__ */navigator;
			Document3.__init__(Browser.document);
		}

		__proto._init_=function(sprite){
			if (Driver._input)return;
			if(Laya.CONCHVER){
				Browser.input=Browser.document.createElement("input");
			}
			else{
				Browser.input=Driver._input=/*__JS__ */window.document.createElement("input");
				Driver._textarea=/*__JS__ */window.document.createElement("textArea");
			}
			if(!Laya.CONCHVER){
				Driver._input.setPos=Driver._textarea.setPos=function (x,y){
					Browser.input.style.left=x+"px";
					Browser.input.style.top=y+"px";
				};
				Driver._input.setSize=Driver._textarea.setSize=function (w,h){
					Browser.input.style.width=w+"px";
					Browser.input.style.height=h+"px";
				};
				Driver._input.setStyle=Driver._textarea.setStyle=function (style){
					Browser.input.style.cssText=style;
				}
				Driver._input.setFont=Driver._textarea.setFont=function (fontInfo){
					Browser.input.style.fontFamily=fontInfo;
				};
				Driver._input.setColor=Driver._textarea.setColor=function (color){
					Browser.input.style.color=color;
				};
				Driver._input.setOpacity=Driver._textarea.setOpacity=function (opacity){
					Browser.input.style.opacity=opacity;
				};
				Driver._input.setFontSize=Driver._textarea.setFontSize=function (sz){
					Browser.input.style.fontSize=sz+"px";
				};
				Driver._input.setScale=Driver._textarea.setScale=function (scalex,scaley){
					Browser.input.style.webkitTransform="scale("+scalex+','+scaley+')';
					Browser.input.style.mozTransform="scale("+scalex+','+scaley+')';
					Browser.input.style.oTransform="scale("+scalex+','+scaley+')';
					Browser.input.style.msTransform="scale("+scalex+','+scaley+')';
				};
				Driver._input.setRotate=Driver._textarea.setRotate=function (s){
					Browser.input.style.webkitTransform+="rotate("+s+'deg)';
					Browser.input.style.mozTransform+="rotate("+s+'deg)';
					Browser.input.style.oTransform+="rotate("+s+'deg)';
					Driver._textarea.style.msTransform+="rotate("+s+'deg)';
				};
				Driver._input.setType=Driver._textarea.setType=function (type,multiline){
					(multiline===void 0)&& (multiline=false);
					if(iflash.laya.driver.Driver.enableTouch()&& !Laya.CONCHVER){
						if(!multiline || type=="password"){
							Driver._input.type=type;
							Browser.input=Driver._input;
						}
						else
						Browser.input=Driver._textarea;
					}
					else{
						Browser.input=(type=="password")? Driver._input :Driver._textarea;
					}
				}
				Driver._input.setRegular=Driver._textarea.setRegular=function (value){
					Driver._textarea.onkeyup=value;
				};
				Driver._input.setAlign=Driver._textarea.setAlign=function (align){
					Browser.input.style.textAlign=align;
				}
				Driver._input.clear=Driver._textarea.clear=function (){
					Driver._input.value="";
					Driver._textarea.value="";
				}
			}
			else{
				Browser.input.setSelectionRange=function (a,b){
					var maxIndex=Browser.input.value.length;
					if(a < 0)a=0;
					else if(a >=maxIndex)a=maxIndex;
					Browser.input.setCursorPosition(a);
				};
				Browser.input.setFontSize(60);
			};
			var style=
			"-webkit-transform-origin:left top;"+
			"-moz-transform-origin:left top;"+
			"transform-origin:left top;"+
			"-ms-transform-origin:left top;"+
			"position:absolute;"+
			"top:-2000;"+
			"border:none;"+
			"z-index:9999;";
			if(!Driver.enableTouch()){
				style+=
				"background:transparent;"+
				"outline:none;"+
				"overflow:hidden;";
			}
			Browser.input.setStyle(style);
			if(!Laya.CONCHVER){
				Driver._textarea.style.cssText=style;
				Driver._textarea.style.resize="none";
				!Driver.enableTouch()&& (Driver._input.type="password");
			}
			else
			Browser.document.body.appendChild(Driver._textarea);
		}

		__proto.err=LAYAFNVOID/*function(e){}*/
		__proto.alert=function(e){
			/*__JS__ */alert(e);
		}

		__proto.onEnterFrame=function(evt){
			if (Laya.window==null)return;
			var wnd=Browser.window;
			if (Laya.window !=null){
				Laya.window.resizeTo(wnd.innerWidth,wnd.innerHeight);
				Laya.window.enterFrame();
				Laya.RENDERBYCANVAS&&this.onDomRender();
			}
		}

		__proto.onDomRender=function(){
			(Laya.window !=null)&& Laya.document.render();
		}

		__proto.onResize=LAYAFNVOID/*function(){}*/
		__proto.start=function(){
			if (Laya.HTMLVER){
				Browser.document.body.style.cssText+='overflow:hidden;margin:0;padding:0'
			}
		}

		__proto._debugger_=function(){
			/*__JS__ */debugger;
		}

		__proto.eval=function(str,target){
			target=target || Browser.window;
			target.eval(str);
		}

		__proto.getRootCanvas=function(){
			return Browser.document.createElement("canvas");
		}

		__proto.createModle=function(type,id,node){
			if (Driver.__DOMCACHE__.length > 0){
				var o=Driver.__DOMCACHE__.pop();
				o.reset(id,node);
				return o;
			}
			return (Laya.CONCHVER&&!Laya.RENDERBYCANVAS)?/*__JS__ */new ConchNode():IModel.__DEFAULT__;
		}

		__proto.attachBrowserMouseEvent=function(name,fn,type){
			name=name.toLowerCase();
			(Laya.CONCHVER ? Browser.document :Laya.document.canvas).addEventListener(name.substring(2,name.length),fn,false);
		}

		__proto.attachBrowserKeyEvent=function(name,fn){
			var fnnew=function (event){
				var keyboaderEvent=new KeyboardEvent(name.substring(2));
				keyboaderEvent.keyCode=event.keyCode;
				keyboaderEvent.shiftKey=event.shiftKey;
				keyboaderEvent.ctrlKey=event.ctrlKey;
				fn(keyboaderEvent);
			};
			Browser.document[ name.toLowerCase()]=fnnew;
		}

		__proto.createHttpRequest=function(){
			return new HttpRequest();
		}

		__proto.regEvent=function(){
			var esys=EventManager.mgr;
			if (Driver.enableTouch()){
				Driver.activateTouchEvent();
				esys.dealAccepInput=esys.dealAcceptTouchInput;
				esys.enableTouch=true;
			}
			else{
				this.attachBrowserMouseEvent("onmouseDown",function(e){esys.acceptSystemMouseEvent(e);});
				this.attachBrowserMouseEvent("onmouseMove",function(e){esys.acceptSystemMouseEvent(e);});
				this.attachBrowserMouseEvent("onmouseUp",function(e){esys.acceptSystemMouseEvent(e);});
				Browser.window.onmousewheel=Browser.document.onmousewheel=function (e){esys.acceptSystemMouseEvent(e);};
			}
			this.attachBrowserKeyEvent("onkeyDown",function(e){esys.acceptSystemKeyEvent(e);});
			this.attachBrowserKeyEvent("onkeyUp",function(e){esys.acceptSystemKeyEvent(e);});
		}

		__proto.cursor=function(cursor){
			Browser.document.body.style.cursor=cursor;
		}

		__getset(0,__proto,'frameRate',function(){
			return this._frameRate_;
			},function(num){
			this._frameRate_=num;
			/*__JS__ */Driver.interval &&(clearInterval(Driver.interval));
			var _this=this;
			/*__JS__ */Driver.interval=setInterval(function(){_this.onEnterFrame()},1000/num);
		});

		Driver.enableTouch=function(){
			if (!Laya.CONCHVER)
				/*__JS__ */return ('ontouchstart' in window)|| window.DocumentTouch && (document instanceof DocumentTouch);
			else
			/*__JS__ */return window.enableTouch;;
			return false;
		}

		Driver.activateTouchEvent=function(){
			Driver.touchActive=true;
			var target=(Laya.CONCHVER ? Browser.document :Laya.document.canvas);
			target.addEventListener("touchstart",Driver.touchstartHandler);
			target.addEventListener("touchmove",Driver.touchmoveHandler);
			target.addEventListener("touchend",Driver.touchendHandler);
			target.addEventListener("touchcancel",Driver.touchcancelHandler);
		}

		Driver.deactivateTouchEvent=function(){
			Driver.touchActive=false;
			var target=(Laya.CONCHVER ? Browser.document :Laya.document.canvas);
			target.removeEventListener("touchstart",Driver.touchstartHandler);
			target.removeEventListener("touchend",Driver.touchendHandler);
			target.removeEventListener("touchmove",Driver.touchmoveHandler);
			target.removeEventListener("touchcancel",Driver.touchcancelHandler);
		}

		Driver.touchstartHandler=function(e){
			EventManager.mgr.acceptSystemMouseEvent(e);
		}

		Driver.touchmoveHandler=function(e){
			e.type="touchmove";
			EventManager.mgr.acceptSystemMouseEvent(e)
		}

		Driver.touchendHandler=function(e){
			e.type="touchend";
			EventManager.mgr.acceptSystemMouseEvent(e)
		}

		Driver.touchcancelHandler=function(e){
			e.type="touchcancel";
			EventManager.mgr.acceptSystemMouseEvent(e)
		}

		Driver.__DOMCACHE__=[];
		Driver.__ID__=100000;
		Driver.interval=null;
		Driver._textarea=null
		Driver._input=null
		Driver.touchActive=false;
		return Driver;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/driver/location.as
	//class iflash.laya.driver.Location
	var Location=(function(){
		function Location(){
			this.href=null;
		}

		__class(Location,'iflash.laya.driver.Location',true);
		var __proto=Location.prototype;
		__proto.reload=LAYAFNVOID/*function(){}*/
		return Location;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/driver/navigator.as
	//class iflash.laya.driver.Navigator
	var Navigator=(function(){
		function Navigator(){}
		__class(Navigator,'iflash.laya.driver.Navigator',true);
		return Navigator;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/driver/window.as
	//class iflash.laya.driver.Window
	var Window2=(function(){
		function Window(){
			this.innerWidth=0;
			this.innerHeight=0;
			this.XMLHttpRequest=null;
			this.ActiveXObject=null;
			this.onmousewheel=null;
			this._title_=null;
			this.event=null;
			this.onscroll=null;
			this.scrollTop=0;
			this.scrollLeft=0;
			this.conchConfig=null;
			this.conchMarket=null;
			this.DeviceMotionEvent=null;
			this._ConchMask=null;
		}

		__class(Window,'iflash.laya.driver.Window',true,null,'Window2');
		var __proto=Window.prototype;
		__proto.eval=LAYAFNNULL/*function(str){return null}*/
		__proto.setTimeout=LAYAFNVOID/*function(fn,delay){}*/
		__proto.clearInterval=LAYAFNVOID/*function(id){}*/
		__proto.setInterval=LAYAFN0/*function(fn,d){return 0}*/
		__getset(0,__proto,'title',function(){
			return this._title_;
			},function(str){
			this._title_=str;
		});

		return Window;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/ilaya.as
	//class iflash.laya.ILaya
	var ILaya=(function(){
		function ILaya(sprite,htmlUrl){
			this._html_=null;
			Laya.ilaya=this;
			Laya.Main(sprite);
			this._html_=htmlUrl;
			if (!this._html_ && Laya.CONCHVER && Browser.location && Browser.location.href)
				this._html_=Browser.location.href;
		}

		__class(ILaya,'iflash.laya.ILaya',true);
		var __proto=ILaya.prototype;
		__proto._onInit_=LAYAFNVOID/*function(){}*/
		__proto.onStart=function(){
			Browser.hideSystemLoading();
			return;
		}

		return ILaya;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/net/ajax.as
	//class iflash.laya.net.Ajax
	var Ajax=(function(){
		function Ajax(){}
		__class(Ajax,'iflash.laya.net.Ajax',true);
		Ajax.onJSONDone=function(callbackFn,response,onerr){
			if (response==null){
				onerr();
				return;
			}
			callbackFn(response);
		}

		Ajax.GetJSONInBrowser=function(url,callbackFn,splitChar,onerr){
			(splitChar===void 0)&& (splitChar='&');
			var response;
			var jsoncb=function (args){
				response=args;
			};
			var tm='';
			if (callbackFn !=null){
				tm=iflash.utils.getTimer()+"";
				Browser.window['layacallback'+tm]=jsoncb;
			};
			var script=Browser.document.createElement('script');
			script.type="text/javascript";
			if (onerr !=null){
				script.onerror=onerr;
				}else{
				script.onerror=callbackFn;
			}
			script.onload=script.onreadystatechange=function (e,isAbort){
				var reg=new RegExp("loaded|complete");
				if (isAbort || !script.readyState || reg.test(script.readyState+"")){
					script.onload=script.onreadystatechange=null;
					if (script.parentNode !=null){}
						if (!isAbort){
						Ajax.onJSONDone(callbackFn,response,script.onerror);
					}
				}
			};
			script.src=url+(tm!=''?(splitChar+'callback=layacallback'+tm):'');
			Browser.document.getElementsByTagName('head')[0].appendChild(script);
		}

		Ajax.GetJSONInApp=function(url,callbackFn,splitChar,onerr){
			(splitChar===void 0)&& (splitChar='&');
			var response="";
			var tm="";
			if(callbackFn !=null){
				tm=iflash.utils.getTimer()+"";
				Browser.window["layacallback"+tm]=function (args){response=args;};
			};
			var nurl=url+(tm !=""?(splitChar+"callback=layacallback"+tm):"");
			Browser.window["downloadfile"](nurl,true,function(data){
				console.log('getJson onload:'+data);
				Browser.eval(data);
				Ajax.onJSONDone(callbackFn,response,null);
				},function(){
				console.log('getjson error');
				Ajax.onJSONDone(null,null,onerr !=null?onerr:callbackFn);
			});
		}

		Ajax.GetJSON=function(url,callbackFn,splitChar,onerr){
			(splitChar===void 0)&& (splitChar='&');
			if (!Laya.CONCHVER)
				return Ajax.GetJSONInBrowser(url,callbackFn,splitChar,onerr);
			else
			return Ajax.GetJSONInApp(url,callbackFn,splitChar,onerr);
		}

		return Ajax;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/net/cookie.as
	//class iflash.laya.net.Cookie
	var Cookie=(function(){
		function Cookie(name){
			this._name=null;
			this._data=null;
			this._name=name;
		}

		__class(Cookie,'iflash.laya.net.Cookie',true);
		var __proto=Cookie.prototype;
		__proto.clear=function(){
			this._data={};
			/*__JS__ */localStorage.removeItem(this._name);
		}

		__proto.close=LAYAFNVOID/*function(){}*/
		__proto.flush=function(minDiskSpace){
			(minDiskSpace===void 0)&& (minDiskSpace=0);
			/*__JS__ */localStorage.setItem(this._name,window.JSON.stringify(this._data));
			return this._name;
		}

		__proto.send=function(__rest){}
		__proto.setDirty=LAYAFNVOID/*function(propertyName){}*/
		__proto.setProperty=function(propertyName,value){
			this._data.propertyName=value;
		}

		__getset(0,__proto,'data',function(){
			return this._data;
		});

		__getset(0,__proto,'objectEncoding',LAYAFN0/*function(){return 0}*/,LAYAFNVOID/*function(version){}*/);
		__getset(0,__proto,'fps',null,LAYAFNVOID/*function(updatesPerSecond){}*/);
		__getset(0,__proto,'client',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(object){}*/);
		__getset(0,__proto,'size',LAYAFN0/*function(){return 0}*/);
		__getset(1,Cookie,'defaultObjectEncoding',LAYAFN0/*function(){return 0}*/,LAYAFNVOID/*function(version){}*/);
		Cookie.deleteAll=LAYAFN0/*function(url){return 0}*/
		Cookie.getDiskUsage=LAYAFN0/*function(url){return 0}*/
		Cookie.getLocal=function(name,localPath,secure){
			(secure===void 0)&& (secure=false);
			var result=new Cookie(name);
			result._data=/*__JS__ */localStorage.getItem(name)?window.JSON.parse(localStorage.getItem(name)):{};
			return result;
		}

		Cookie.getRemote=function(name,remotePath,persistence,secure){
			(persistence===void 0)&& (persistence=false);
			(secure===void 0)&& (secure=false);
			return null}
		return Cookie;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/net/filedata.as
	//class iflash.laya.net.FileData
	var FileData=(function(){
		function FileData(url,type,mirroringWith){
			this.contentType=null;
			this.contentdata=null;
			this.quoteFile=null;
			this.state=0;
			this._fileRead_=null;
			this._type_=null;
			this.baseURI=null;
			this.state=0;
			this._type_=type || FileData.TYPE_TEXT;
			this.baseURI=new URI(Method.formatUrl(url));
			if (mirroringWith){
				if ((typeof mirroringWith=='string'))mirroringWith=FileData.getFileData(mirroringWith);
				this.quoteFile=mirroringWith;
				this.contentdata=mirroringWith.contentdata;
			}
			this._fileRead_=[];
		}

		__class(FileData,'iflash.laya.net.FileData',true);
		var __proto=FileData.prototype;
		__proto.unload=function(){
			this.contentdata=null;
			delete FileData._files[this.baseURI.url];
			this._fileRead_=null;
		}

		__proto.addFileRead=function(file){
			if (this.state==3)
				file.onload(this.contentdata);
			else this._fileRead_.push(file);
		}

		__proto.onload=function(value){{
				if (Laya.HTMLVER && this._type_==FileData.TYPE_ARRAYBUFFER){
					/*__JS__ */if(!value)return;;
					var b=new ByteArray();
					b.endian=value.endian;
					/*__JS__ */b.writeArrayBuffer(value);
					b.position=0;
					value=b;
				}
				this.contentdata=value;
				this.state=3;
				this._disposeLoaded_();
			}
		}

		__proto.onerror=function(e){
			delete FileData._files[this.baseURI.url];
			this.state=FileData.LOAD_STATE_ERR;
			this.onerrorLoaded();
		}

		__proto.getData=function(urlrequest){
			if (this.state==3)return this.contentdata;
			if (this.quoteFile){
				if (this.quoteFile.state==3){
					return this.onload(this.quoteFile.getData());
				}
				this.quoteFile.addFileRead(this);
				return null;
			}
			if (this.state==0 || this.state==FileData.LOAD_STATE_ERR){
				this.state=2;
				var request=Browser.createHttpRequest();
				var _this=this;
				request.onload=function (d){
					_this.onload(d);
				}
				request.onerror=function (d){
					_this.onerror(d);
				}
				if (this._type_=="binary" && Laya.HTMLVER){
					this._type_=FileData.TYPE_ARRAYBUFFER;
				}
				if (this._type_=="binary" && Laya.FLASHVER){
					if(urlrequest){
						request.open(this.baseURI.url,this._type_,null,true,urlrequest.method,urlrequest.data,urlrequest.requestHeaders);
					}
					else{
						request.open(this.baseURI.url,this._type_);
					}
				}
				else{
					if(urlrequest){
						request.open(this.baseURI.url,this._type_==FileData.TYPE_ARRAYBUFFER?FileData.TYPE_ARRAYBUFFER:null,null,true,urlrequest.method,urlrequest.data,urlrequest.requestHeaders);
					}
					else{
						request.open(this.baseURI.url,this._type_==FileData.TYPE_ARRAYBUFFER?FileData.TYPE_ARRAYBUFFER:null);
					}
				}
				return null;
			}
		}

		__proto.onerrorLoaded=function(){
			this.state=3;
			if(!this._fileRead_)return;
			for (var i=0,sz=this._fileRead_.length;i < sz;i++){
				this._fileRead_[i].loadError(this.contentdata);
			}
			this._fileRead_=null;
		}

		__proto._disposeLoaded_=function(){
			this.state=3;
			for (var i=0,sz=this._fileRead_.length;i < sz;i++){
				this._fileRead_[i].onload(this.contentdata);
			}
			this._fileRead_=null;
		}

		FileData.setFileIsLoaded=function(url,file){
			url=Method.formatUrl(url);
		}

		FileData.fileIsLoaded=function(url){
			url=Method.formatUrl(url);
			return FileData._files[url]!=null;
		}

		FileData.getFileData=function(url){
			url=Method.formatUrl(url);
			return FileData._files[url];
		}

		FileData._files=[];
		FileData.LOAD_STATE_ERR=-1;
		FileData.LOAD_STATE_NO=0;
		FileData.LOAD_STATE_RELEASE=1;
		FileData.LOAD_STATE_LOADING=2;
		FileData.LOAD_STATE_LOADED=3;
		FileData.TYPE_IMAGE="image";
		FileData.TYPE_TEXT="text";
		FileData.TYPE_ARRAYBUFFER="arraybuffer";
		return FileData;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/net/fileread.as
	//class iflash.laya.net.FileRead
	var FileRead=(function(){
		function FileRead(url,callback,type,urlRequest){
			this.data=null;
			this._callBack_=null;
			this._contentType_=null;
			this._callBack_=callback;
			this._createFileData_(url,type);
			this.data.getData(urlRequest);
		}

		__class(FileRead,'iflash.laya.net.FileRead',true);
		var __proto=FileRead.prototype;
		__proto._createFileData_=function(url,type){
			!this.data && (this.data=new FileData(url,type,null),this.data.contentType=Method.formatUrlType(url));
			this.data.addFileRead(this);
		}

		__proto.onload=function(value){
			if (this._callBack_){
				this._callBack_.onload.call(this._callBack_.reader,this);
				this._callBack_=null;
				this.unload();
			}
		}

		__proto.loadError=function(value){
			if (this._callBack_){
				this._callBack_.unOnload.call(this._callBack_.reader,this);
				this._callBack_=null;
			}
		}

		__proto.unload=function(){
			this.data && this.data.unload();
			this.data=null;
		}

		__proto.load=function(){
			return this.data.getData();
		}

		__getset(0,__proto,'baseURI',function(){
			return this.data.baseURI;
		});

		__getset(0,__proto,'contentType',function(){
			if(this.data)
				return this.data.contentType;
			return null;
			},function(type){
			this.data&&(this.data.contentType=type);
		});

		__getset(0,__proto,'loaded',function(){
			return this.data.state==/*iflash.laya.net.FileData.LOAD_STATE_LOADED*/3;
		});

		__getset(0,__proto,'url',function(){
			return this.data.baseURI.url;
		});

		__getset(0,__proto,'contentdata',function(){
			this.data.getData();
			return this.data.contentdata;
		});

		return FileRead;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/net/location.as
	//class iflash.laya.net.Location
	var Location1=(function(){
		function Location(){
			this._href_=null;
			this._fullPath_=null;
			this._protocol=null;
			this._host=null;
			this._rootPath=null;
			this._conchConfig=null;
			Laya.window.location=this;
			this.href=Browser.location.href;
		}

		__class(Location,'iflash.laya.net.Location',true,null,'Location1');
		var __proto=Location.prototype;
		__getset(0,__proto,'href',function(){
			return this._href_;
			},function(url){
			this._href_=url;
			this._fullPath_=Method.getPath(this._href_);
		});

		__getset(0,__proto,'rootPath',function(){
			return this._rootPath;
			},function(value){
			this._rootPath=value;
		});

		__getset(0,__proto,'fullPath',function(){
			return this._fullPath_;
		});

		__getset(0,__proto,'host',function(){
			return this._host;
		});

		__getset(0,__proto,'protocol',function(){
			return this._protocol;
		});

		__getset(0,__proto,'conchConfig',function(){
			return this._conchConfig;
		});

		return Location;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/runner/datatype.as
	//class iflash.laya.runner.DataType
	var DataType=(function(){
		function DataType(){};
		__class(DataType,'iflash.laya.runner.DataType',true);
		DataType.initKeyMap=function(){
			DataType.MAP=[];
			var arr=["NULL","ID","CHAR","SHORT","FLOAT","STRING","INT","BYTE",
			"CURRENT","HOST","TEMPLATE_ID","ARRAY","MATRIX","BOOL","RESOURCE",
			"TEMPLET","FRAME","INTERPOLATION","NEWID","END","FRAME_END","POP",
			"PUSH","SYMBOL_CLASS","LYIMAGELEMENT","SHAPE","BITMAPDATA","BITMAP",
			"SPRITE","MOVIECLIP","TEXTFIELD","BUTTON","REMOVE_ALL","SET_INSTANCE_NAME",
			"REMOVE_INSTANCE_NAME","NEW_OBJECT","ADD_CHILD","REMOVE_CHILD","SET_TRANSFORM",
			"POS","EMPTY","SET_ALPHA","SET_VISIBLE","INIT_LYIMAGELEMENT_CMD","INIT_SHAPE_CMD",
			"INIT_MOVIECLIP_CMD","INIT_TEXTFIELD_CMD","INIT_BUTTON_CMD","INIT_STATICTEXTFIELDCMD"];
			var i;
			/*for each*/for(var $each_i in arr){
				i=arr[$each_i];
				DataType.MAP[DataType[i]]=i;
			}
			return DataType.MAP;
		}

		DataType.NULL=0;
		DataType.ID=1;
		DataType.CHAR=3;
		DataType.SHORT=4;
		DataType.FLOAT=5;
		DataType.STRING=6;
		DataType.INT=7;
		DataType.BYTE=8;
		DataType.CURRENT=9;
		DataType.HOST=10;
		DataType.TEMPLATE_ID=11;
		DataType.ARRAY=12;
		DataType.MATRIX=13;
		DataType.BOOL=14;
		DataType.RESOURCE=21;
		DataType.TEMPLET=22;
		DataType.FRAME=23;
		DataType.INTERPOLATION=24;
		DataType.NEWID=25;
		DataType.END=26;
		DataType.FRAME_END=27;
		DataType.POP=28;
		DataType.PUSH=29;
		DataType.SYMBOL_CLASS=30;
		DataType.LYIMAGELEMENT=51;
		DataType.SHAPE=52;
		DataType.BITMAPDATA=53;
		DataType.BITMAP=54;
		DataType.SPRITE=55;
		DataType.MOVIECLIP=56;
		DataType.TEXTFIELD=57;
		DataType.BUTTON=58;
		DataType.STATICTEXTFIELD=59;
		DataType.REMOVE_ALL=151;
		DataType.SET_INSTANCE_NAME=152;
		DataType.REMOVE_INSTANCE_NAME=153;
		DataType.NEW_OBJECT=154;
		DataType.ADD_CHILD=155;
		DataType.REMOVE_CHILD=156;
		DataType.SET_TRANSFORM=157;
		DataType.POS=158;
		DataType.EMPTY=159;
		DataType.SET_ALPHA=160;
		DataType.SET_VISIBLE=161;
		DataType.INIT_LYIMAGELEMENT_CMD=162;
		DataType.INIT_SHAPE_CMD=163;
		DataType.INIT_MOVIECLIP_CMD=164;
		DataType.INIT_TEXTFIELD_CMD=165;
		DataType.INIT_BUTTON_CMD=166;
		DataType.INIT_SHAPE2ADDCMD=167;
		DataType.INIT_STATICTEXTFIELDCMD=168;
		DataType.MAP=null
		return DataType;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/runner/defines/animationcreate.as
	//class iflash.laya.runner.defines.AnimationCreate
	var AnimationCreate=(function(){
		function AnimationCreate(){
			this.commands={};
		}

		__class(AnimationCreate,'iflash.laya.runner.defines.AnimationCreate',true);
		AnimationCreate.removeAll=function(target,key){
			(key===void 0)&& (key=0);
			while(target.numChildren){
				target.removeChildAt(0);
			}
		}

		AnimationCreate.setInstanceName=function(target,key,name){
			var obj=target._animData_.objes[key];
			try{obj.name=name;target[name]=obj;}catch(e){}
		}

		AnimationCreate.removeInstanceName=LAYAFNVOID/*function(target,key,name){}*/
		AnimationCreate.newObject=function(target,key,characterID,symblName){
			var res;
			if (target._animData_.objes[key]&&target._animData_.objes[key].v==true)return;
			else if(target._animData_.objes[key])
			{target.removeChild(target._animData_.objes[key]);return;}
			if(symblName){
				var c=iflash.utils.getDefinitionByName(symblName);
				if(!c){
					res=target.loaderInfo.applicationDomain.newInstance(symblName);
					if((res instanceof iflash.display.BitmapData )){
						res=new Bitmap(res);
						target._animData_.objes[key]=res;
						return;
					}
					res&&(target._animData_.objes[key]=res);
					return;
				};
				var cc=new c();
				if((cc instanceof iflash.display.BitmapData )){
					var b=new Bitmap(cc);
					target._animData_.objes[key]=b;
					}else{
					target._animData_.objes[key]=cc;
				}
				}else{
				res=target.loaderInfo.getResource(String(characterID));
				res&&(target._animData_.objes[key]=res.lyclone());
			}
		}

		AnimationCreate.addChild=function(target,key,depth){
			if(target._animData_.objes[key]&&target._animData_.objes[key].parent)return;
			if(!target._animData_.objes[key])return;
			target.addChild(target._animData_.objes[key]);
			target._animData_.objes[key].zIndex=depth;
		}

		AnimationCreate.removeChild=function(target,key){
			(key===void 0)&& (key=0);
			if(target._animData_.objes[key] && target._animData_.objes[key].v==true)return
				if(target._animData_.objes[key]){
				target.removeChild(target._animData_.objes[key])
				target._animData_.objes[key].alpha=true
			}
			return;
		}

		AnimationCreate.setTransform=function(target,f32){
			var obj=target._animData_.objes[f32[0]];
			if(obj && !obj.v)
				obj&&(obj.x=f32[1],obj.y=f32[2],obj.scaleX=f32[3],obj.scaleY=f32[4],obj.skewX=f32[6],obj.skewY=f32[7],obj.rotation=f32[5])
		}

		AnimationCreate.pos=function(target,key,x,y){
			var obj=target._animData_.objes[key];
			obj&&(obj.x=x,obj.y=y);
		}

		AnimationCreate.empty=function(target,key){
			(key===void 0)&& (key=0);
		}

		AnimationCreate.setAlpha=function(target,key,value){
			var o=target._animData_.objes[key];
			o&&(o.alpha=value);
		}

		AnimationCreate.setVisible=function(target,key,value){
			if(target._animData_.objes[key])target._animData_.objes[key].visible=value;
		}

		AnimationCreate.getCurrentKey=function(target){return target._animData_.baseKey;}
		AnimationCreate.getKey=function(target){return++(target._animData_.baseKey);}
		AnimationCreate.initLyImage=function(target,src,w,h){
			target.width=w;
			target.height=h;
			target.src=target.loaderInfo.__imageUrl__+String(src)+".png";
			var len=target.loaderInfo.temp.length;
			target.loaderInfo.temp[len]=target;
			return target;
		}

		AnimationCreate.initShap=function(target,image,matrix){
			target._init_({data:image,matrix:matrix});
			return target;
		}

		AnimationCreate.initShape2Add=function(target,id,w,h,matrix){
			DisplayObject.initModule=false;
			var img=new LyImageElement();
			img.src=target.loaderInfo.__imageUrl__+id+".png";
			if(target.loaderInfo.config){
				img.assetUr=target.loaderInfo.__imageUrl__+/*iflash.display.LoaderInfo.TextureSign*/"a"+target.loaderInfo.config[id+".png"].tid+".png";
				img.assetConfig=target.loaderInfo.config[id+".png"];
			}
			img.width=w;
			img.height=h;
			img.orgH=h;
			img.orgW=w;
			img.scale9Data=target.loaderInfo.argData?target.loaderInfo.argData[id+1]:null;
			var len=target.loaderInfo.temp.length;
			target.loaderInfo.temp[len]=img;
			target._init_({data:img,matrix:matrix});
			DisplayObject.initModule=true;
			return target;
		}

		AnimationCreate.initStaticText=function(target,x,y,posx,posy,w,h,wordWrap,multiline,readOnly,align,textColor,fontHeight,initialText){
			target._width=w+5;
			target._height=h+5;
			target.tempBound={x:x,y:-2};
			target.x=x;
			target.y=y;
			target._autoSize='left';
			target._multiline=multiline;
			target._wordWrap=wordWrap;
			target._type="static";
			var tf=new TextFormat();
			tf.size=fontHeight/20;
			if(align==2){tf.align="center";};
			var index=textColor.lastIndexOf("*");
			if(index!=-1){
				var temp=textColor.substring(index+1);
				if(temp.indexOf('Bold')>-1)
					tf.bold=true;
				if(temp.indexOf('Italic')>-1)
					tf.italic=true;
				tf.font=temp.replace(/\s*(Bold|Italic)\s*/g,'');
				tf.color=Number("0x"+textColor.substring(0,index));
				}else{
				tf.color=Number(textColor.replace("#","0x"));
			}
			if (initialText){
				target.htmlText=initialText;
			}
			target.defaultTextFormat=tf;
		}

		AnimationCreate.initText=function(target,x,y,posx,posy,w,h,wordWrap,multiline,readOnly,align,textColor,fontHeight,initialText){
			target.width=w;
			target.height=h;
			target.tempBound={x:x,y:0};
			target.x=x;
			target.y=y;
			target.multiline=multiline;
			target.wordWrap=wordWrap;
			(!readOnly)&&(target.type="input");
			var tf=new TextFormat();
			tf.size=fontHeight/20;
			if(align==0)
				tf.align="left";
			else if(align==1)
			tf.align="right";
			else if(align==2)
			tf.align="center";
			var index=textColor.lastIndexOf("*");
			if(index!=-1){
				var temp=textColor.substring(index+1);
				if(temp.indexOf('Bold')>-1)
					tf.bold=true;
				if(temp.indexOf('Italic')>-1)
					tf.italic=true;
				tf.font=temp.replace(/\s*(Bold|Italic)\s*/g,'');
				tf.color=Number("0x"+textColor.substring(0,index));
				}else{
				tf.color=Number(textColor.replace("#","0x"));
			}
			if (initialText){
				if(initialText.indexOf("<p")==-1){
					target.text=initialText;
					}else{
					target.htmlText=initialText;
				}
			}
			target.defaultTextFormat=tf;
		}

		AnimationCreate.initButton=function(target,runner,w,h,totalFrame,labs){
			var aniData=new AnimationData(),len=labs.length,labData={};
			for(var i=0;i<len;i+=2)
			{labData[labs[i]]=labs[i+1];}
			aniData.totalFrame=totalFrame;
			aniData.labs=labData;
			target._animData_=aniData;
			target._interval_=60;
			target.runner=runner;
			target.width=w;
			target.height=h;
			target._type_|=/*iflash.display.DisplayObject.TYPE_CREATE_FROM_TAG*/0x10;
			return target;
		}

		AnimationCreate.initMovie=function(target,runner,w,h,totalFrame,labs){
			var aniData=new AnimationData(),len=labs?labs.length:0,labData={};
			for(var i=0;i<len;i+=2)
			{labData[labs[i]]=labs[i+1];}
			aniData.totalFrame=totalFrame;
			aniData.labs=labData;
			target._animData_=aniData;
			target._interval_=60;
			target.runner=runner;
			target.width=w;
			target.height=h;
			if(target.loaderInfo.argData && target.loaderInfo.argData.hasOwnProperty(target.charId))
				target.scale9Data=target.loaderInfo.argData[target.charId].scale9Data;
			target._type_|=/*iflash.display.DisplayObject.TYPE_CREATE_FROM_TAG*/0x10;
			return target;
		}

		return AnimationCreate;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/runner/onecmddata.as
	//class iflash.laya.runner.OneCmdData
	var OneCmdData=(function(){
		function OneCmdData(){
			this.oneFun=null;
			this.args=null;
		}

		__class(OneCmdData,'iflash.laya.runner.OneCmdData',true);
		var __proto=OneCmdData.prototype;
		__proto.applyTo=function(who,one){
			return this.oneFun._fun_.apply(who,this.args);
		}

		OneCmdData.CreateOneCmdData=function(ctype,data,infoId){
			var fnid=ctype;
			var oneFun=Register._functions_[fnid];
			if(!oneFun){
				throw new Error("此函数未注册id("+fnid+"),ctype("+ctype+")");
			};
			var onecmddata;
			if (oneFun.useID){
				onecmddata=new OneCmdDataUseId();
				(onecmddata).id=data.readUnsignedByte();
			}
			else onecmddata=new OneCmdData();
			onecmddata.oneFun=oneFun;
			onecmddata.args=oneFun.readParams(data,infoId);
			var args=onecmddata.args;
			switch(fnid){
				case /*iflash.laya.runner.DataType.SET_TRANSFORM*/157:
					onecmddata.args=[args[0],/*__JS__ */new Float32Array(args.slice(1))];
					args=null;
					break ;
				}
			return onecmddata;
		}

		return OneCmdData;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/runner/onefunction.as
	//class iflash.laya.runner.OneFunction
	var OneFunction=(function(){
		function OneFunction(fun,argCount,_useID,paramTypes){
			this._fun_=null;
			this._argsType_=[];
			this.useID=false;
			this.argCount=0;
			this._fun_=fun;
			this._argsType_=paramTypes;
			this.useID=_useID;
		}

		__class(OneFunction,'iflash.laya.runner.OneFunction',true);
		var __proto=OneFunction.prototype;
		__proto.readParams=function(data,infoid){
			var args=[],len=this._argsType_.length;
			for (var i=0;i < len;i++){
				args.push(OneFunction.readParam(this._argsType_[i],data,infoid));
			}
			return args;
		}

		OneFunction.readParam=function(type,data,infoid){
			var value;
			var id=0;
			var i=0;
			var arr;
			var len=0;
			switch(type){
				case /*iflash.laya.runner.DataType.BYTE*/8:
				case /*iflash.laya.runner.DataType.CHAR*/3:
					value=data.readByte();
					break ;
				case /*iflash.laya.runner.DataType.FLOAT*/5:
					value=data.readFloat();
					break ;
				case /*iflash.laya.runner.DataType.INT*/7:
					value=data.readInt();
					break ;
				case /*iflash.laya.runner.DataType.SHORT*/4:
					value=data.readShort();
					break ;
				case /*iflash.laya.runner.DataType.BOOL*/14:
					value=data.readBoolean();
					break ;
				case /*iflash.laya.runner.DataType.STRING*/6:
					value=data.readUTF();
					break ;
				case /*iflash.laya.runner.DataType.CURRENT*/9:
					value=Runnner.getCurrentObj();
					break ;
				case /*iflash.laya.runner.DataType.ID*/1:
					id=data.readShort();
					value=LoaderInfo.getLoaderInfo(infoid).getResource(id.toString());
					break ;
				case /*iflash.laya.runner.DataType.HOST*/10:
					value="HOST";
					break ;
				case /*iflash.laya.runner.DataType.NULL*/0:
					value=null;
					break ;
				case /*iflash.laya.runner.DataType.TEMPLATE_ID*/11:
					id=data.readShort();
					value=Runnner.template[id];
					break ;
				case /*iflash.laya.runner.DataType.ARRAY*/12:
					len=data.readByte();
					if(!len)
					{value=[];break }
					type=data.readByte();
					arr=[];
					for(i=0;i<len;i++){
						arr.push(OneFunction.readParam(type,data,infoid));
					}
					value=arr;
					break ;
				case /*iflash.laya.runner.DataType.MATRIX*/13:
					len=data.readShort();
					arr=[null,null,null,null,null,null];
					for(i=0;i<len;i++){
						arr[i]=OneFunction.readParam(/*iflash.laya.runner.DataType.FLOAT*/5,data,infoid);
					}
					value=new Matrix(arr[0],arr[1],arr[2],arr[3],arr[4],arr[5]);
					break ;
				}
			return value;
		}

		OneFunction.loaderId=0;
		return OneFunction;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/runner/register.as
	//class iflash.laya.runner.Register
	var Register=(function(){
		function Register(){}
		__class(Register,'iflash.laya.runner.Register',true);
		Register.regFunction=function(id,fun,argCount,useID,__args){
			var args=[];for(var i=4,sz=arguments.length;i<sz;i++)args.push(arguments[i]);
			if (id < 10)throw "regFunction id must>10,id:"+id;
			Register._functions_[id]=new OneFunction(fun,argCount,useID,args);
		}

		Register.regClass=function(id,clazz){
			if (id < 10)throw "regClass id must>10,id:"+id;
			Register._class_[id]=clazz;
		}

		Register._functions_=[];
		Register._class_=[];
		Register._id_=0;
		return Register;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/runner/runnner.as
	//class iflash.laya.runner.Runnner
	var Runnner=(function(){
		function Runnner(p,id){
			this.parent=null;
			this._comm_=[];
			this._functions_=[];
			this._id_=-1;
			(id===void 0)&& (id=-1);
			this._id_=id;
		}

		__class(Runnner,'iflash.laya.runner.Runnner',true);
		var __proto=Runnner.prototype;
		__proto.deleteLoaderInfo=function(){
			Runnner._info=null;
			Runnner.currentObj=null;
		}

		__proto.interpolation=function(data){
			var findex=data.readUnsignedShort();
			var index=data.readUnsignedShort();
			var selfindex=this._comm_.length;
			this._comm_.push(null);
		}

		__proto.compile=function(data,info){
			Runnner._info=info;
			while (data.bytesAvailable){
				var ctype=data.readUnsignedByte()
				var n,resId
				switch(ctype){
					case 0:continue ;
					case DataType.RESOURCE:
						resId=data.readShort();
						var cid=data.readByte();
						this.res(resId,cid);
						n=new Runnner(this,resId);
						n.compile(data,info);
						n.run(Runnner.getCurrentObj(),new RunOne());
						break ;
					case DataType.TEMPLET:
						resId=data.readShort();
						n=new Runnner(this,resId);
						iflash.laya.runner.Runnner.template[resId]=n;
						n.compile(data,info);
						break ;
					case DataType.END:
						return 0;
					case DataType.FRAME:
						n=new Runnner(this,-1);
						this._comm_.push(n);
						n.compile(data,info);
						break ;
					case DataType.INTERPOLATION:
						this.interpolation(data);
						break ;
					case DataType.FRAME_END:
						return 0;
						break ;
					case /*iflash.laya.runner.DataType.SYMBOL_CLASS*/30:;
						var tagId=data.readShort();
						var name=data.readUTF();
						if(tagId==0){
							tagId=32767;
							info["mainClass"]=name;
						}
						info.pushResource(info.getResource(tagId.toString()),name);
						SWFTools.connect(name);
						iflash.laya.runner.Runnner.symbolClass.push({tagId:tagId,name:name,loadInfo:"infoId"});
						break ;
					default :
						this._comm_.push(OneCmdData.CreateOneCmdData(ctype,data,info.__id__));
					}
			}
			Runnner.currentObj=null;
			return-1;
		}

		__proto.res=function(id,classId){
			DisplayObject.initModule=false;
			var obj=new (Register._class_[classId]);
			DisplayObject.initModule=true;
			obj.__id__=Runnner._info.__id__;
			obj.charId=id;
			Runnner._info.pushResource(obj,id.toString());
			Runnner.currentObj=obj;
		}

		__proto.run=function(who,one){
			for (var i=0,sz=this._comm_.length;i < sz;i++){
				this._comm_[i] && this._comm_[i].applyTo(who,one);
			}
			return-1;
		}

		__proto.run2=function(who){
			for (var i=0,sz=this._comm_.length;i < sz;i++){
				this._comm_[i] && (this._comm_[i].args[0]=who,this._comm_[i].applyTo(who),this._comm_[i].args[0]=null);
			}
			Runnner.currentObj=null;
		}

		__proto.runCMDList=function(who,one,index){
			return-1;
		}

		__proto.newObject=function(index,runId){
			(runId===void 0)&& (runId=-1);
			var o=new (Register._class_[index]);
			if(runId>0)
				o.runner=this._comm_[runId];
			return o;
		}

		__proto.getPreRes=function(info){
			for (var i=0;i < this._comm_.length;i++){
				var obj=this._comm_[i];
				for (var j=0;j < obj._comm_.length;j++){
					var o=obj._comm_[j];
					if((o instanceof iflash.laya.runner.OneCmdData )){
						if(o.oneFun._fun_==AnimationCreate.newObject){
							var res=info.getResource(o.args[2]+"");
							if((res instanceof iflash.display.MovieClip )){
								res.runner.getPreRes(info);
							}
							if((res instanceof iflash.display.Shape )&& Runnner.preResCollection.indexOf(res)<0){
								Runnner.preResCollection.push(res);
							}
						}
					}
				}
			}
		}

		__proto.clone=function(){
			var runner=new Runnner();
			runner._comm_=this._comm_.concat();
			runner._functions_=this._functions_;
			return runner;
		}

		__proto.gotoAndStop=function(frameNum,target){target._animData_.isStop=true;this._goto(frameNum,target);}
		__proto.gotoAndPlay=function(frameNum,target){target._animData_.isStop=false;this._goto(frameNum,target);}
		__proto.play=function(target){target._animData_.isStop=false;}
		__proto.stop=function(target){target._animData_.isStop=true;}
		__proto._updata_=function(target){
			if (target._animData_.isStop)return;
			var frame=target._animData_.currentFrame+1;
			if(frame>target._animData_.totalFrame||frame<0)frame=0;
			this.tick(frame,target);
			if (target._animData_.totalFrame==1)this.stop(target);
		}

		__proto.tick=function(frameNum,target){
			if(target._animData_.isStop)return;
			target._animData_.currentFrame=int(frameNum);
			if (target==null)return;
			if(target._animData_.totalFrame<1)return;
			var cmd=this._comm_[frameNum];
			if(!cmd)return;
			cmd.run2(target);
		}

		__proto._goto=function(frame,target){
			if(frame>=target._animData_.totalFrame)frame=0;
			if(frame==target._animData_.currentFrame)return;
			var i=target._animData_.currentFrame;
			if(target._animData_.currentFrame>frame)i=0;(i<0)&&(i=0);
			for(i;i<=frame;++i){
				var cmd=this._comm_[i];
				cmd&&(cmd.run2(target));
				if(!cmd)continue ;
			}
			target._animData_.currentFrame=frame;
		}

		__proto.getSysbomData=function(info){
			for(var i=0;i<iflash.laya.runner.Runnner.symbolClass.length;i++){
				var res=info.getResource(iflash.laya.runner.Runnner.symbolClass[i].name);
				if (!res)continue ;
				if ((res instanceof iflash.display.MovieClip )){
					this.regclass(iflash.laya.runner.Runnner.symbolClass[i].name,res,info.applicationDomain);
				}
				else if ((res instanceof iflash.display.LyImageElement )){
					this.regclass(iflash.laya.runner.Runnner.symbolClass[i].name,res,info.applicationDomain);
				}
				else info.applicationDomain._resMapDic_[iflash.laya.runner.Runnner.symbolClass[i].name]=res,res.__id__=info.__id__;
			}
		}

		__proto.regclass=function(name,data,dom){
			var _class=
			function (){
				if((data instanceof iflash.display.LyImageElement )){
					data._init_();data._lyToBody_();
					if (!data.miniBitmapData._canvas_&&data._image_){
						data.miniBitmapData.setImage(data._image_);
					}
					data.miniBitmapData._canvas_.size(data.width,data.height);
					data.miniBitmapData.width=data.width;
					data.miniBitmapData.height=data.height;
					return data.miniBitmapData.clone();
				}
				return data.lyclone();
			}
			dom._resMapDic_[name]=_class;
			_class&&(_class.__id__=data.__id__);
		}

		__proto.destory=function(){
			this.parent=null;
			this._comm_=null;
			this._functions_=null;
		}

		Runnner.getCurrentObj=function(){
			return Runnner.currentObj;
		}

		Runnner.createRunerForClass=function(classId){
			var runner=new Runnner();
			return runner;
		}

		Runnner.preResCollection=[];
		Runnner.runSpace=[];
		Runnner.specialRunners=[];
		Runnner.symbolClass=[];
		Runnner.template=[];
		Runnner.currentObj=null
		Runnner._info=null
		return Runnner;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/runner/runone.as
	//class iflash.laya.runner.RunOne
	var RunOne=(function(){
		function RunOne(){
			this.ids=[];
		}

		__class(RunOne,'iflash.laya.runner.RunOne',true);
		return RunOne;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/system/config.as
	//class iflash.laya.system.Config
	var Config=(function(){
		function Config(){
			this.urlToLower=false;
			this.showInfo=false;
			this.urlToLower=false;
			this.showInfo=true;
		}

		__class(Config,'iflash.laya.system.Config',true);
		return Config;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/system/timerctrl.as
	//class iflash.laya.system.TimerCtrl
	var TimerCtrl=(function(){
		function TimerCtrl(){
			this._nowTime_=NaN;
			this._frameTimer_=null;
			this.ids=0;
			this._timers_=null;
			this._frameTimer_=[];
			this.ids=1;
			this._timers_=[];
			this._nowTime_=iflash.utils.getTimer();
		}

		__class(TimerCtrl,'iflash.laya.system.TimerCtrl',true);
		var __proto=TimerCtrl.prototype;
		__proto.addFrameTimer=function(listener,owner){
			var o;
			for (var i=0,sz=this._frameTimer_.length;i < sz;i++){
				o=this._frameTimer_[i];
				if (o.deleted){
					return o._reset_(this._nowTime_,listener,owner);
				}
			}
			o=new TimerObject(this._nowTime_,listener,owner);
			this._frameTimer_.push(o);
			return o;
		}

		__proto.removeFrameTimer=function(listener,owner){
			var o;
			for (var i=0,sz=this._frameTimer_.length;i < sz;i++){
				o=this._frameTimer_[i];
				if (o.listener==listener){
					this._frameTimer_.splice(i,1);
					i--;
					o.deleted=true;
					return;
				}
			}
		}

		__proto.addTimer=function(ower,fn,delay,repeartCount){
			var timer;
			if ((typeof fn=='string')){
			}
			else{
				timer=new TimerObject(this._nowTime_,fn,ower,delay,repeartCount);
			}
			this._timers_.push(timer);
			return timer;
		}

		__proto._update_=function(tm){
			this._nowTime_=tm;
			this._updateFrameTimer_(tm);
			this._updateTimer_(tm);
		}

		__proto._updateFrameTimer_=function(time){
			for (var i=0;i <this._frameTimer_.length;i++){
				if (!this._frameTimer_[i].run(time)){
					this._frameTimer_.splice(i,1);
					i--;
				};
			}
		}

		__proto._updateTimer_=function(time){
			var hasDeleted=false,i=0;
			for (i=0;i < this._timers_.length;i++){
				if (!this._timers_[i].run(time)){
					hasDeleted=true;
					this._timers_.splice(i,1);
					i--;
				};
			}
			if (!hasDeleted)return;
			var tsz=0;
			for (i=0;i < this._timers_.length;i++){
				if (this._timers_[i].deleted){
					continue ;
				}
				this._timers_[tsz]=this._timers_[i];
				tsz++;
			}
			this._timers_.length=tsz;
		}

		__static(TimerCtrl,
		['__DEFAULT__',function(){return this.__DEFAULT__=new TimerCtrl();}
		]);
		return TimerCtrl;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/media/id3info.as
	//class iflash.media.ID3Info
	var ID3Info=(function(){
		function ID3Info(){
			this.album=null;
			this.artist=null;
			this.comment=null;
			this.genre=null;
			this.songName=null;
			this.track=null;
			this.year=null;
		}

		__class(ID3Info,'iflash.media.ID3Info',true);
		return ID3Info;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/media/soundloadercontext.as
	//class iflash.media.SoundLoaderContext
	var SoundLoaderContext=(function(){
		function SoundLoaderContext(__args){
			this.bufferTime=NaN;
			this.checkPolicyFile=false;
		}

		__class(SoundLoaderContext,'iflash.media.SoundLoaderContext',true);
		return SoundLoaderContext;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/media/soundmixer.as
	//class iflash.media.SoundMixer
	var SoundMixer=(function(){
		function SoundMixer(){};
		__class(SoundMixer,'iflash.media.SoundMixer',true);
		SoundMixer.areSoundsInaccessible=LAYAFNFALSE/*function(){return false}*/
		SoundMixer.computeSpectrum=function(outputArray,FFTMode,stretchFactor){
			(FFTMode===void 0)&& (FFTMode=false);
			(stretchFactor===void 0)&& (stretchFactor=0);
		}

		SoundMixer.stopAll=LAYAFNVOID/*function(){}*/
		SoundMixer.bufferTime=0;
		SoundMixer.soundTransform=null;
		return SoundMixer;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/media/soundtransform.as
	//class iflash.media.SoundTransform
	var SoundTransform=(function(){
		function SoundTransform(vol,panning){
			this._sound_=null;
			this._volume_=NaN;
			(vol===void 0)&& (vol=1);
			(panning===void 0)&& (panning=0);
			this.volume=vol;
		}

		__class(SoundTransform,'iflash.media.SoundTransform',true);
		var __proto=SoundTransform.prototype;
		__getset(0,__proto,'leftToLeft',LAYAFN0/*function(){return 0}*/,LAYAFNVOID/*function(leftToLeft){}*/);
		__getset(0,__proto,'leftToRight',LAYAFN0/*function(){return 0}*/,LAYAFNVOID/*function(leftToRight){}*/);
		__getset(0,__proto,'pan',LAYAFN0/*function(){return 0}*/,LAYAFNVOID/*function(panning){}*/);
		__getset(0,__proto,'rightToLeft',LAYAFN0/*function(){return 0}*/,LAYAFNVOID/*function(rightToLeft){}*/);
		__getset(0,__proto,'rightToRight',LAYAFN0/*function(){return 0}*/,LAYAFNVOID/*function(rightToRight){}*/);
		__getset(0,__proto,'volume',function(){
			return this._volume_;
			},function(vol){
			this._sound_ && (this._sound_.volume=vol);
			this._volume_=vol;
		});

		return SoundTransform;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/net/filefilter.as
	//class iflash.net.FileFilter
	var FileFilter=(function(){
		function FileFilter(description,extension,macType){}
		__class(FileFilter,'iflash.net.FileFilter',true);
		var __proto=FileFilter.prototype;
		__getset(0,__proto,'description',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'extension',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'macType',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(value){}*/);
		return FileFilter;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/net/objectencoding.as
	//class iflash.net.ObjectEncoding
	var ObjectEncoding=(function(){
		function ObjectEncoding(){}
		__class(ObjectEncoding,'iflash.net.ObjectEncoding',true);
		__getset(1,ObjectEncoding,'dynamicPropertyWriter',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(object){}*/);
		ObjectEncoding.AMF0=0;
		ObjectEncoding.AMF3=3;
		ObjectEncoding.DEFAULT=3;
		return ObjectEncoding;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/net/responder.as
	//class iflash.net.Responder
	var Responder=(function(){
		function Responder(result,status){
			this._resp=null;
			this._resp=new iflash.net.Responder(result,status);
		}

		__class(Responder,'iflash.net.Responder',true);
		var __proto=Responder.prototype;
		__getset(0,__proto,'resp',function(){
			return this._resp;
		});

		return Responder;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/net/securitypanel.as
	//class iflash.net.SecurityPanel
	var SecurityPanel=(function(){
		function SecurityPanel(){}
		__class(SecurityPanel,'iflash.net.SecurityPanel',true);
		SecurityPanel.CAMERA="camera";
		SecurityPanel.DEFAULT="default";
		SecurityPanel.DISPLAY="display";
		SecurityPanel.LOCAL_STORAGE="localStorage";
		SecurityPanel.MICROPHONE="microphone";
		SecurityPanel.PRIVACY="privacy";
		SecurityPanel.SETTINGS_MANAGER="settingsManager";
		return SecurityPanel;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/net/sharedobjectflushstatus.as
	//class iflash.net.SharedObjectFlushStatus
	var SharedObjectFlushStatus=(function(){
		function SharedObjectFlushStatus(){}
		__class(SharedObjectFlushStatus,'iflash.net.SharedObjectFlushStatus',true);
		SharedObjectFlushStatus.FLUSHED="flushed";
		SharedObjectFlushStatus.PENDING="pending";
		return SharedObjectFlushStatus;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/net/urlloaderdataformat.as
	//class iflash.net.URLLoaderDataFormat
	var URLLoaderDataFormat=(function(){
		function URLLoaderDataFormat(){}
		__class(URLLoaderDataFormat,'iflash.net.URLLoaderDataFormat',true);
		URLLoaderDataFormat.BINARY="binary";
		URLLoaderDataFormat.TEXT="text";
		URLLoaderDataFormat.VARIABLES="variables";
		return URLLoaderDataFormat;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/net/urlrequest.as
	//class iflash.net.URLRequest
	var URLRequest=(function(){
		function URLRequest(url){
			this._contentType=null;
			this._data=null;
			this._digest=null;
			this._requestHeaders=[];
			this._url=null;
			this._method=/*iflash.net.URLRequestMethod.GET*/"GET";
			this._url=url;
		}

		__class(URLRequest,'iflash.net.URLRequest',true);
		var __proto=URLRequest.prototype;
		__getset(0,__proto,'contentType',function(){
			return this._contentType;
			},function(value){
			this._contentType=value;
		});

		__getset(0,__proto,'data',function(){
			return this._data;
			},function(value){
			this._data=value;
		});

		__getset(0,__proto,'url',function(){
			return this._url;
			},function(value){
			this._url=value;
		});

		__getset(0,__proto,'digest',function(){
			return this._digest;
			},function(value){
			this._digest=value;
		});

		__getset(0,__proto,'method',function(){
			return this._method;
			},function(value){
			this._method=value;
		});

		__getset(0,__proto,'requestHeaders',function(){
			return this._requestHeaders;
			},function(value){
			this._requestHeaders=value;
		});

		return URLRequest;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/net/urlrequestheader.as
	//class iflash.net.URLRequestHeader
	var URLRequestHeader=(function(){
		function URLRequestHeader(name,value){
			this.name="Content-Type";
			this.value="application/x-www-form-urlencoded";
			(name===void 0)&& (name="");
			(value===void 0)&& (value="");
			;
			this.name=name;
			this.value=value;
		}

		__class(URLRequestHeader,'iflash.net.URLRequestHeader',true);
		return URLRequestHeader;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/net/urlrequestmethod.as
	//class iflash.net.URLRequestMethod
	var URLRequestMethod=(function(){
		function URLRequestMethod(){}
		__class(URLRequestMethod,'iflash.net.URLRequestMethod',true);
		URLRequestMethod.DELETE="DELETE";
		URLRequestMethod.GET="GET";
		URLRequestMethod.HEAD="HEAD";
		URLRequestMethod.OPTIONS="OPTIONS";
		URLRequestMethod.POST="POST";
		URLRequestMethod.PUT="PUT";
		return URLRequestMethod;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/net/urlvariables.as
	//class iflash.net.URLVariables
	var URLVariables=(function(){
		function URLVariables(source){
			this.__decodeRegExp__=new RegExp("[?&]?([^=]+)=([^&]*)","g");
			__uns(this,['__decodeRegExp__']);
			source !=null && this.decode(source);
		}

		__class(URLVariables,'iflash.net.URLVariables',false);
		var __proto=URLVariables.prototype;
		__proto.decode=function(source){
			if(!source)return;
			if(!this.variables){
				this.variables={};
			}
			source=source.split("+").join(" ");
			var tokens,re=this.__decodeRegExp__;
			while (tokens=re.exec(source)){
				Log.unfinished("URLVariables","decode");
				this.variables[tokens[1]]=tokens[2];
			}
		}

		__proto.toString=function(){
			var variables={};
			var str="";
			var isFirst=true;
			if (!this.variables){
				for (var key in this){
					if(key=="variables"||key=="decode"||key=="__decodeRegExp__"||key=="toString")continue ;
					if(isFirst){
						isFirst=false;
					}
					else{
						str+="&";
					}
					str+=key+"="+this[key];
				}
				return str;
			}
			for(key in variables){
				if(isFirst){
					isFirst=false;
				}
				else{
					str+="&";
				}
				str+=key+"="+variables[key];
			}
			return str;
		}

		__uns(__proto,['decode','toString']);
		return URLVariables;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/swf/animation/animationdata.as
	//class iflash.swf.animation.AnimationData
	var AnimationData=(function(){
		function AnimationData(){
			this.objes={};
			this._parent=null;
			this.baseKey=-1;
			this.currentFrame=-1;
			this.labs={};
			this.isStop=false;
			this.totalFrame=0;
		}

		__class(AnimationData,'iflash.swf.animation.AnimationData',true);
		var __proto=AnimationData.prototype;
		__proto.lyclone=function(){
			var ani=new AnimationData()
			ani.totalFrame=this.totalFrame;
			ani.labs=this.labs;
			return ani;
		}

		__proto.destory=function(){
			this.objes=null;
			this._parent=null;
			this.labs=null;
		}

		return AnimationData;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/swf/utils/swftools.as
	//class iflash.swf.utils.SWFTools
	var SWFTools=(function(){
		function SWFTools(){}
		__class(SWFTools,'iflash.swf.utils.SWFTools',true);
		SWFTools.connect=function(cla){
			if ((typeof cla=='string'))cla=ApplicationDomain.currentDomain.getDefinition2(cla);
			if(!cla||cla.f)return;
			var pre=cla.__super;
			cla.f=true;
			cla.__super=function (ex){
				(ex===void 0)&& (ex=true);
				pre.apply(this,arguments);
				if(ex)iflash.swf.utils.SWFTools._initClass_(cla,this);
			}
		}

		SWFTools.initClass=function(cla,obj,sourceMc){}
		SWFTools._initClass_=function(cla,obj,sourceMc){
			if((obj instanceof iflash.media.Sound ))return;
			var app=ApplicationDomain.currentDomain;
			var b;
			if ((obj instanceof iflash.display.BitmapData )){
				b=app.newInstance(iflash.utils.getQualifiedClassName(obj));
				obj._canvas_=b._canvas_.clone();
				obj._context_=obj._canvas_;
				obj.width=b.width;
				obj.height=b.height;
				return;
			}
			if((obj instanceof iflash.display.Bitmap )){
				b=app.newInstance(iflash.utils.getQualifiedClassName(obj));
				obj.bitmapData=new BitmapData(b.width,b.height);
				obj.bitmapData._canvas_=b._canvas_.clone();
				obj._modle_.vcanvas(obj.bitmapData._canvas_);
				obj.bitmapData.width=b.width;
				obj.bitmapData.height=b.height;
				obj.width=b.width;
				obj.height=b.height;
				return;
			};
			var mc
			if(cla!=null){
				var cName=iflash.utils.getQualifiedClassName(obj);
				mc=app.newDefinition(cName);
			}else mc=sourceMc;
			if(!mc)mc=new cla();
			if((obj instanceof iflash.display.MovieClip )){
				obj._interval_=mc._interval_=60;
				obj._animData_=mc._animData_.lyclone();
				obj.runner=mc.runner;
				obj._type_|=/*iflash.display.DisplayObject.TYPE_CREATE_FROM_TAG*/0x10;
				obj.__id__=mc.__id__;
				obj._type_|=/*iflash.display.DisplayObject.TYPE_CREATE_FROM_TAG*/0x10;
				if((obj instanceof iflash.display.SimpleButton ))obj.gotoAndStop(1);
				else obj._gotoAndPlay_(1);
				return
			}
			else if(((obj instanceof iflash.display.Sprite ))&&mc){
				var arrar=mc._childs_.concat();
				for(var j=0;j<arrar.length;j++){
					obj.addChild(arrar[j]);
				}
				for(var i in mc){
					if(i !='_childs_'&& mc[i]&&i!="runner")obj[i]=mc[i];
				}
				mc.stop();
				mc=null;
			}
		}

		return SWFTools;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/system/applicationdomain.as
	//class iflash.system.ApplicationDomain
	var ApplicationDomain=(function(){
		function ApplicationDomain(parentDomain){
			this._domainMemory=null;
			this._parentDomain_=null;
			this._resMapDic_={};
			this._id__=0;
			this._parentDomain_=parentDomain;
		}

		__class(ApplicationDomain,'iflash.system.ApplicationDomain',true);
		var __proto=ApplicationDomain.prototype;
		__proto.getDefinition=function(name){
			if(!name){
				throw new Error(name+' Variable a is not defined.');
				return;
			}
			name=(name.toString()).replace("::",".");
			if(name.split(".")[0]=="flash"){
				name=name.replace("flash" ,"iflash");
			};
			var result=iflash.utils.getDefinitionByName(name);
			if(result==null){
				result=this._resMapDic_[name];
				result&&(result.lin=name);
			}
			if (result==null){
				result=LAYABOX.getInterfaceDefinitionByName(name);
			}
			if(!result)
				throw new Error(name+' Variable a is not defined.')
			result.__isclass=true;
			return result;
		}

		__proto.getDefinition2=function(name){
			name=(name.toString()).replace("::",".");
			var result=iflash.utils.getDefinitionByName(name);
			if(result==null){
				result=this._resMapDic_[name];
			}
			return result;
		}

		__proto.newDefinition=function(name){
			name=name.replace("::",".");
			var ret;
			var cls=(this._resMapDic_[name]);
			if(!cls){
				var info;
				/*for each*/for(var $each_info in LoaderInfo._loaderInfos_){
					info=LoaderInfo._loaderInfos_[$each_info];
					if(info.applicationDomain==this)continue ;
					cls=(info.applicationDomain._resMapDic_[name]);
					if(cls)break ;
				}
			}
			if(cls){ret=new cls();ret.__id__=cls.__id__}
				return ret;
		}

		__proto.newInstance=function(name){
			name=name.replace("::",".");
			var result=this._resMapDic_[name];
			if(result==null)return null;
			result=new result();
			return result;
		}

		__proto.hasDefinition=function(name){
			if(!name)return false;
			name=name.replace("::",".");
			var boolean=false;
			this.getDefinition2(name)? boolean=true :boolean=false;
			if(!boolean){
				try{
					var obj=iflash.utils.getDefinitionByName(name);
					obj && (boolean=true);
				}catch(error){boolean=false;}
			}
			return boolean;
		}

		__proto.addResToMap=function(name,data){
			this._resMapDic_[name]=data;return;
			if(this._resMapDic_[name])return
				else this._resMapDic_[name]=data;
		}

		__getset(0,__proto,'__id__',function(){
			return this._id__;
			},function(value){
			this._id__=value;
		});

		__getset(0,__proto,'currentDomain',null,function(value){
			ApplicationDomain._currentDomain=value;
		});

		__getset(0,__proto,'domainMemory',function(){
			return this._domainMemory;
			},function(mem){
			this._domainMemory=mem;
		});

		__getset(0,__proto,'parentDomain',function(){
			return this._parentDomain_;
		});

		__getset(1,ApplicationDomain,'currentDomain',function(){
			if(ApplicationDomain._currentDomain==null){
				ApplicationDomain._currentDomain=new ApplicationDomain();
			}
			return ApplicationDomain._currentDomain;
		});

		__getset(1,ApplicationDomain,'MIN_DOMAIN_MEMORY_LENGTH',function(){
			return 0;
		});

		ApplicationDomain._currentDomain=null;
		return ApplicationDomain;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/system/capabilities.as
	//class iflash.system.Capabilities
	var Capabilities=(function(){
		function Capabilities(){}
		__class(Capabilities,'iflash.system.Capabilities',true);
		__getset(1,Capabilities,'isDebugger',function(){
			return Laya.FLASHVER ? Capabilities.isDebugger :"false";
		});

		__getset(1,Capabilities,'os',function(){
			if(Capabilities._os !=null)
				return Capabilities._os;
			/*__JS__ */var sUserAgent=navigator.userAgent;
			/*__JS__ */if ((navigator.platform=="Mac68K")|| (navigator.platform=="MacPPC")|| (navigator.platform=="Macintosh")|| (navigator.platform=="MacIntel"))Capabilities._os="Mac";
			/*__JS__ */if ((navigator.platform=="X11")&& !isWin && !isMac)Capabilities._os="Mac";
			/*__JS__ */if (navigator.platform.indexOf("Linux")>-1)Capabilities._os="Linux";
			/*__JS__ */if ((navigator.platform=="Win32")|| (navigator.platform=="Windows")){;
				/*__JS__ */ if (sUserAgent.indexOf("Windows NT 5.0")>-1 || sUserAgent.indexOf("Windows 2000")>-1)Capabilities._os="Windows 2000";
				/*__JS__ */ else if (sUserAgent.indexOf("Windows NT 5.1")>-1 || sUserAgent.indexOf("Windows XP")>-1)Capabilities._os="Windows XP";
				/*__JS__ */ else if (sUserAgent.indexOf("Windows NT 5.2")>-1 || sUserAgent.indexOf("Windows 2003")>-1)Capabilities._os="Win2003";
				/*__JS__ */ else if (sUserAgent.indexOf("Windows NT 6.0")>-1 || sUserAgent.indexOf("Windows Vista")>-1)Capabilities._os="Windows Vista";
				/*__JS__ */ else if (sUserAgent.indexOf("Windows NT 6.1")>-1 || sUserAgent.indexOf("Windows 7")>-1)Capabilities._os="Windows 7";
				/*__JS__ */ else Capabilities._os="Windows";
				/*__JS__ */};
			return Capabilities._os;
		});

		__getset(1,Capabilities,'playerType',function(){
			return null;
		});

		__getset(1,Capabilities,'screenDPI',function(){
			var dpi=240;
			if(Laya.CONCHVER){
				/*__JS__ */if(window.layabox&&window.layabox.getDeviceInfo){di=window.layabox.getDeviceInfo();dpi=di.dpi};
			}
			if(!dpi)
				dpi=240;
			return dpi;
		});

		__getset(1,Capabilities,'version',function(){
			return "";
		});

		__getset(1,Capabilities,'language',function(){
			return Laya.FLASHVER ? Capabilities.language :/*__JS__ */window.navigator.language;
		});

		__getset(1,Capabilities,'serverString',function(){
			return "";
		});

		__getset(1,Capabilities,'screenResolutionX',function(){
			return Capabilities._screenResolutionX;
		});

		__getset(1,Capabilities,'screenResolutionY',function(){
			return Capabilities._screenResolutionY;
		});

		Capabilities.initScreenResolutionXY=function(){
			Capabilities._screenResolutionX=/*__JS__ */window.screen.width;
			Capabilities._screenResolutionY=/*__JS__ */window.screen.height;
		}

		Capabilities._os=null;
		Capabilities._screenResolutionX=0;
		Capabilities._screenResolutionY=0;
		return Capabilities;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/system/imagedecodingpolicy.as
	//class iflash.system.ImageDecodingPolicy
	var ImageDecodingPolicy=(function(){
		function ImageDecodingPolicy(){}
		__class(ImageDecodingPolicy,'iflash.system.ImageDecodingPolicy',true);
		ImageDecodingPolicy.ON_DEMAND="onDemand";
		ImageDecodingPolicy.ON_LOAD="onLoad";
		return ImageDecodingPolicy;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/system/loadercontext.as
	//class iflash.system.LoaderContext
	var LoaderContext=(function(){
		function LoaderContext(checkPolicyFile,applicationDomain,securityDomain){
			this.applicationDomain=null;
			this.securityDomain=null;
			this.checkPolicyFile=false;
			this.allowCodeImport=false;
			this.imageDecodingPolicy=/*iflash.system.ImageDecodingPolicy.ON_LOAD*/"onLoad";
			(checkPolicyFile===void 0)&& (checkPolicyFile=false);
			this.applicationDomain=applicationDomain;
		}

		__class(LoaderContext,'iflash.system.LoaderContext',true);
		var __proto=LoaderContext.prototype;
		__getset(0,__proto,'allowLoadBytesCodeExecution',LAYAFNFALSE/*function(){return false}*/,LAYAFNVOID/*function(allow){}*/);
		return LoaderContext;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/system/security.as
	//class iflash.system.Security
	var Security=(function(){
		function Security(){};
		__class(Security,'iflash.system.Security',true);
		__getset(1,Security,'sandboxType',LAYAFNSTR/*function(){return ""}*/);
		Security.allowDomain=function(__rest){}
		Security.allowInsecureDomain=function(__rest){}
		Security.loadPolicyFile=LAYAFNVOID/*function(url){}*/
		Security.showSettings=function(panel){
			(panel===void 0)&& (panel="default");
		}

		Security.disableAVM1Loading=false;
		Security.exactSettings=false;
		Security.APPLICATION="application";
		Security.LOCAL_TRUSTED="localTrusted";
		Security.LOCAL_WITH_FILE="localWithFile";
		Security.LOCAL_WITH_NETWORK="localWithNetwork";
		Security.REMOTE="remote";
		return Security;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/system/securitydomain.as
	//class iflash.system.SecurityDomain
	var SecurityDomain=(function(){
		function SecurityDomain(){}
		__class(SecurityDomain,'iflash.system.SecurityDomain',true);
		__getset(1,SecurityDomain,'currentDomain',function(){
			return new SecurityDomain();
		});

		return SecurityDomain;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/system/system.as
	//class iflash.system.System
	var System=(function(){
		function System(){}
		__class(System,'iflash.system.System',true);
		__getset(1,System,'freeMemory',LAYAFN0/*function(){return 0}*/);
		__getset(1,System,'privateMemory',LAYAFN0/*function(){return 0}*/);
		__getset(1,System,'totalMemory',function(){
			return 0;
		});

		__getset(1,System,'totalMemoryNumber',LAYAFN0/*function(){return 0}*/);
		__getset(1,System,'useCodePage',function(){
			return System._useCodePage;
			},function(value){
			System._useCodePage=value;
		});

		__getset(1,System,'vmVersion',function(){
			return "ilaya-hello";
		});

		System.disposeXML=function(node){
			if(!((node instanceof iflash.xml.XMLElement ))){}
				}
		System.exit=LAYAFNVOID/*function(code){}*/
		System.gc=LAYAFNVOID/*function(){}*/
		System.nativeConstructionOnly=LAYAFNVOID/*function(object){}*/
		System.pause=LAYAFNVOID/*function(){}*/
		System.pauseForGCIfCollectionImminent=function(imminence){
			(imminence===void 0)&& (imminence=0.75);
		}

		System.resume=LAYAFNVOID/*function(){}*/
		System.setClipboard=LAYAFNVOID/*function(string){}*/
		System._useCodePage=false;
		return System;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/text/antialiastype.as
	//class iflash.text.AntiAliasType
	var AntiAliasType=(function(){
		function AntiAliasType(){}
		__class(AntiAliasType,'iflash.text.AntiAliasType',true);
		AntiAliasType.ADVANCED="advanced";
		AntiAliasType.NORMAL="normal";
		return AntiAliasType;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/text/engine/contentelement.as
	//class iflash.text.engine.ContentElement
	var ContentElement=(function(){
		function ContentElement(elementFormat,eventMirror,textRotation){
			this.userData=null;
			(textRotation===void 0)&& (textRotation="rotate0");
		}

		__class(ContentElement,'iflash.text.engine.ContentElement',true);
		var __proto=ContentElement.prototype;
		__getset(0,__proto,'elementFormat',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'eventMirror',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'textBlock',LAYAFNNULL/*function(){return null}*/);
		__getset(0,__proto,'groupElement',LAYAFNNULL/*function(){return null}*/);
		__getset(0,__proto,'rawText',LAYAFNSTR/*function(){return ""}*/);
		__getset(0,__proto,'text',LAYAFNSTR/*function(){return ""}*/);
		__getset(0,__proto,'textBlockBeginIndex',LAYAFN0/*function(){return 0}*/);
		__getset(0,__proto,'textRotation',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(value){}*/);
		ContentElement.GRAPHIC_ELEMENT=0xFDEF;
		return ContentElement;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/text/engine/elementformat.as
	//class iflash.text.engine.ElementFormat
	var ElementFormat=(function(){
		function ElementFormat(__args){
			var args=arguments;return }
		__class(ElementFormat,'iflash.text.engine.ElementFormat',true);
		var __proto=ElementFormat.prototype;
		__proto.clone=LAYAFNNULL/*function(){return null}*/
		__proto.getFontMetrics=LAYAFNNULL/*function(){return null}*/
		__getset(0,__proto,'alignmentBaseline',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(alignmentBaseline){}*/);
		__getset(0,__proto,'alpha',LAYAFN0/*function(){return 0}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'dominantBaseline',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(dominantBaseline){}*/);
		__getset(0,__proto,'baselineShift',LAYAFN0/*function(){return 0}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'breakOpportunity',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(opportunityType){}*/);
		__getset(0,__proto,'color',LAYAFN0/*function(){return 0}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'locked',LAYAFNFALSE/*function(){return false}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'digitCase',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(digitCaseType){}*/);
		__getset(0,__proto,'digitWidth',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(digitWidthType){}*/);
		__getset(0,__proto,'fontDescription',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'fontSize',LAYAFN0/*function(){return 0}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'kerning',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'ligatureLevel',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(ligatureLevelType){}*/);
		__getset(0,__proto,'locale',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'textRotation',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'trackingLeft',LAYAFN0/*function(){return 0}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'trackingRight',LAYAFN0/*function(){return 0}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'typographicCase',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(typographicCaseType){}*/);
		return ElementFormat;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/text/engine/fontdescription.as
	//class iflash.text.engine.FontDescription
	var FontDescription=(function(){
		function FontDescription(__args){
			var args=arguments;return }
		__class(FontDescription,'iflash.text.engine.FontDescription',true);
		var __proto=FontDescription.prototype;
		__proto.clone=LAYAFNNULL/*function(){return null}*/
		__getset(0,__proto,'cffHinting',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'fontLookup',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'fontName',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'fontPosture',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'fontWeight',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'locked',LAYAFNFALSE/*function(){return false}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'renderingMode',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(value){}*/);
		FontDescription.isDeviceFontCompatible=LAYAFNFALSE/*function(fontName,fontWeight,fontPosture){return false}*/
		FontDescription.isFontCompatible=LAYAFNFALSE/*function(fontName,fontWeight,fontPosture){return false}*/
		return FontDescription;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/text/engine/fontlookup.as
	//class iflash.text.engine.FontLookup
	var FontLookup=(function(){
		function FontLookup(){}
		__class(FontLookup,'iflash.text.engine.FontLookup',true);
		FontLookup.DEVICE="device";
		FontLookup.EMBEDDED_CFF="embeddedCFF";
		return FontLookup;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/text/engine/fontmetrics.as
	//class iflash.text.engine.FontMetrics
	var FontMetrics=(function(){
		function FontMetrics(__args){
			this.emBox=null;
			this.lineGap=NaN;
			this.strikethroughOffset=NaN;
			this.strikethroughThickness=NaN;
			this.subscriptOffset=NaN;
			this.subscriptScale=NaN;
			this.superscriptOffset=NaN;
			this.superscriptScale=NaN;
			this.underlineOffset=NaN;
			var args=arguments;return }
		__class(FontMetrics,'iflash.text.engine.FontMetrics',true);
		return FontMetrics;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/text/engine/textjustifier.as
	//class iflash.text.engine.TextJustifier
	var TextJustifier=(function(){
		function TextJustifier(locale,lineJustification){}
		__class(TextJustifier,'iflash.text.engine.TextJustifier',true);
		var __proto=TextJustifier.prototype;
		__proto.clone=LAYAFNNULL/*function(){return null}*/
		__getset(0,__proto,'lineJustification',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'locale',LAYAFNSTR/*function(){return ""}*/);
		TextJustifier.getJustifierForLocale=LAYAFNNULL/*function(locale){return null}*/
		return TextJustifier;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/text/engine/tabstop.as
	//class iflash.text.engine.TabStop
	var TabStop=(function(){
		function TabStop(__a){}
		__class(TabStop,'iflash.text.engine.TabStop',true);
		var __proto=TabStop.prototype;
		__getset(0,__proto,'alignment',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'position',LAYAFN0/*function(){return 0}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'decimalAlignmentToken',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(value){}*/);
		return TabStop;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/text/engine/textbaseline.as
	//class iflash.text.engine.TextBaseline
	var TextBaseline=(function(){
		function TextBaseline(){}
		__class(TextBaseline,'iflash.text.engine.TextBaseline',true);
		TextBaseline.ASCENT="ascent";
		TextBaseline.DESCENT="descent";
		TextBaseline.IDEOGRAPHIC_BOTTOM="ideographicBottom";
		TextBaseline.IDEOGRAPHIC_CENTER="ideographicCenter";
		TextBaseline.IDEOGRAPHIC_TOP="ideographicTop";
		TextBaseline.ROMAN="roman";
		TextBaseline.USE_DOMINANT_BASELINE="useDominantBaseline";
		return TextBaseline;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/text/engine/textblock.as
	//class iflash.text.engine.TextBlock
	var TextBlock=(function(){
		function TextBlock(__a){
			this.userData=null;
			var a=arguments;return }
		__class(TextBlock,'iflash.text.engine.TextBlock',true);
		var __proto=TextBlock.prototype;
		__proto.createTextLine=function(previousLine,width,lineOffset,fitSomething){
			(width===void 0)&& (width=1000000);
			(lineOffset===void 0)&& (lineOffset=0);
			(fitSomething===void 0)&& (fitSomething=false);
			return null}
		__proto.dump=LAYAFNSTR/*function(){return ""}*/
		__proto.findNextAtomBoundary=LAYAFN0/*function(afterCharIndex){return 0}*/
		__proto.findNextWordBoundary=LAYAFN0/*function(afterCharIndex){return 0}*/
		__proto.findPreviousAtomBoundary=LAYAFN0/*function(beforeCharIndex){return 0}*/
		__proto.findPreviousWordBoundary=LAYAFN0/*function(beforeCharIndex){return 0}*/
		__proto.getTextLineAtCharIndex=LAYAFNNULL/*function(charIndex){return null}*/
		__proto.recreateTextLine=function(textLine,previousLine,width,lineOffset,fitSomething){
			(width===void 0)&& (width=1000000);
			(lineOffset===void 0)&& (lineOffset=0);
			(fitSomething===void 0)&& (fitSomething=false);
			return null}
		__proto.releaseLineCreationData=LAYAFNVOID/*function(){}*/
		__proto.releaseLines=LAYAFNVOID/*function(firstLine,lastLine){}*/
		__getset(0,__proto,'applyNonLinearFontScaling',LAYAFNFALSE/*function(){return false}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'content',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'firstInvalidLine',LAYAFNNULL/*function(){return null}*/);
		__getset(0,__proto,'baselineFontDescription',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'baselineFontSize',LAYAFN0/*function(){return 0}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'baselineZero',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'bidiLevel',LAYAFN0/*function(){return 0}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'firstLine',LAYAFNNULL/*function(){return null}*/);
		__getset(0,__proto,'lastLine',LAYAFNNULL/*function(){return null}*/);
		__getset(0,__proto,'lineRotation',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'tabStops',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'textLineCreationResult',LAYAFNSTR/*function(){return ""}*/);
		__getset(0,__proto,'textJustifier',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(value){}*/);
		return TextBlock;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/text/engine/textlinemirrorregion.as
	//class iflash.text.engine.TextLineMirrorRegion
	var TextLineMirrorRegion=(function(){
		function TextLineMirrorRegion(){}
		__class(TextLineMirrorRegion,'iflash.text.engine.TextLineMirrorRegion',true);
		var __proto=TextLineMirrorRegion.prototype;
		__getset(0,__proto,'bounds',LAYAFNNULL/*function(){return null}*/);
		__getset(0,__proto,'element',LAYAFNNULL/*function(){return null}*/);
		__getset(0,__proto,'mirror',LAYAFNNULL/*function(){return null}*/);
		__getset(0,__proto,'previousRegion',LAYAFNNULL/*function(){return null}*/);
		__getset(0,__proto,'nextRegion',LAYAFNNULL/*function(){return null}*/);
		__getset(0,__proto,'textLine',LAYAFNNULL/*function(){return null}*/);
		return TextLineMirrorRegion;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/text/font.as
	//class iflash.text.Font
	var Font=(function(){
		function Font(){}
		__class(Font,'iflash.text.Font',true);
		var __proto=Font.prototype;
		__proto.hasGlyphs=LAYAFNFALSE/*function(str){return false}*/
		__getset(0,__proto,'fontName',LAYAFNSTR/*function(){return ""}*/);
		__getset(0,__proto,'fontStyle',LAYAFNSTR/*function(){return ""}*/);
		__getset(0,__proto,'fontType',LAYAFNSTR/*function(){return ""}*/);
		Font.enumerateFonts=function(enumerateDeviceFonts){
			(enumerateDeviceFonts===void 0)&& (enumerateDeviceFonts=false);
			return []}
		Font.registerFont=LAYAFNVOID/*function(font){}*/
		return Font;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/text/fonttype.as
	//class iflash.text.FontType
	var FontType=(function(){
		function FontType(){}
		__class(FontType,'iflash.text.FontType',true);
		FontType.DEVICE="device";
		FontType.EMBEDDED="embedded";
		FontType.EMBEDDED_CFF="embeddedCFF";
		return FontType;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/text/gridfittype.as
	//class iflash.text.GridFitType
	var GridFitType=(function(){
		function GridFitType(){;
		}

		__class(GridFitType,'iflash.text.GridFitType',true);
		GridFitType.NONE="none";
		GridFitType.PIXEL="pixel";
		GridFitType.SUBPIXEL="subpixel";
		return GridFitType;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/text/stagetextinitoptions.as
	//class iflash.text.StageTextInitOptions
	var StageTextInitOptions=(function(){
		function StageTextInitOptions(multiline){
			this._multiline=false;
			(multiline===void 0)&& (multiline=false);
			;
			this.multiline=multiline;
		}

		__class(StageTextInitOptions,'iflash.text.StageTextInitOptions',true);
		var __proto=StageTextInitOptions.prototype;
		__getset(0,__proto,'multiline',function(){
			return this._multiline;
			},function(value){
			this._multiline=value;
		});

		return StageTextInitOptions;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/text/textcolortype.as
	//class iflash.text.TextColorType
	var TextColorType=(function(){
		function TextColorType(){}
		__class(TextColorType,'iflash.text.TextColorType',true);
		TextColorType.DARK_COLOR="dark";
		TextColorType.LIGHT_COLOR="light";
		return TextColorType;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/text/textfieldautosize.as
	//class iflash.text.TextFieldAutoSize
	var TextFieldAutoSize=(function(){
		function TextFieldAutoSize(){
			;
		}

		__class(TextFieldAutoSize,'iflash.text.TextFieldAutoSize',true);
		TextFieldAutoSize.NONE="none";
		TextFieldAutoSize.LEFT="left";
		TextFieldAutoSize.CENTER="center";
		TextFieldAutoSize.RIGHT="right";
		return TextFieldAutoSize;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/text/textfieldtype.as
	//class iflash.text.TextFieldType
	var TextFieldType=(function(){
		function TextFieldType(){
			;
		}

		__class(TextFieldType,'iflash.text.TextFieldType',true);
		TextFieldType.INPUT="input";
		TextFieldType.DYNAMIC="dynamic";
		return TextFieldType;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/text/textformat/fontstyle.as
	//class iflash.text.textformat.FontStyle
	var FontStyle=(function(){
		function FontStyle(){}
		__class(FontStyle,'iflash.text.textformat.FontStyle',true);
		return FontStyle;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/text/textformat/imgtext.as
	//class iflash.text.textformat.ImgText
	var ImgText=(function(){
		function ImgText(){}
		__class(ImgText,'iflash.text.textformat.ImgText',true);
		var __proto=ImgText.prototype;
		__proto.getInstance=function(){
			if(iflash.text.textformat.ImgText.instance==null)
				iflash.text.textformat.ImgText.instance=new ImgText();
			return iflash.text.textformat.ImgText.instance;
		}

		__proto.formatFont=function(text,textFontObj){
			var textRect=new Rectangle();
			if(text.length <=0)
				return textRect;
			return null
		}

		ImgText.instance=null
		return ImgText;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/text/textformat.as
	//class iflash.text.TextFormat
	var TextFormat=(function(){
		function TextFormat(font,size,color,bold,italic,underline,url,target,align,leftMargin,rightMargin,indent,leading){
			if(font)this.font=font;
			if(size)this.size=size;
			if(color)this.color=color;
			if(bold)this.bold=bold;
			if(italic)this.italic=italic;
			if(underline)this.underline=underline;
			if(align)this.align=align;
			if(leftMargin)this.leftMargin=leftMargin;
			if(rightMargin)this.rightMargin=rightMargin;
			if(indent)this.indent=indent;
			if(leading)this.leading=leading;
		}

		__class(TextFormat,'iflash.text.TextFormat',true);
		var __proto=TextFormat.prototype;
		__proto.measureText=function(text){
			var result={width:0,height:0};
			if (!text || !text.length)
				return result;
			if(text=="\n"){
				result={width:0,height:this._size+3};
				return result;
			}
			text=text.replace(/\n/g,"");
			TextFormat.ctx.font=this.getFont();
			var mRes=TextFormat.ctx.measureText(text);
			result.width=mRes.width1 || mRes.width;
			this._letterSpacing && (result.width+=this._letterSpacing *text.length);
			if(Laya.CONCHVER)
				result.height=mRes.height;
			else
			result.height=(int(this._size)|| 12)+TextFormat.HEI_OFF;
			return result;
		}

		__proto.getFont=function(){
			var result="";
			if (!Laya.CONCHVER){
				result+=this._italic ? "italic" :"normal";
				result+=" ";
				result+=this._bold ? "bold" :"normal";
				result+=" ";
				result+=(this._size ? this._size :12)+"px";
				result+=" ";
				if(this._font){
					if(/\d/.test(this._font.charAt(0)))
						result+="Microsoft YaHei";
					else
					result+=this._font;
				}
				else
				result+="Times New Roman";
			}
			else{
				result+=this._italic ? "italic" :"normal";
				result+=" ";
				result+=this._bold ? "700" :"100";
				result+=" ";
				result+=(this._size ? this._size :12)+"px";
				result+=" ";
				result+=this._font ? this._font.replace(/\x20/g,"_"):"Arial";
				result+=" ";
				result+=this._strokeColor ? "1 "+this._strokeColor :"0 0";
				result+=" ";
				result+=this._underline ? "1" :"0";
				result+=this._underline ? (this._color || "#000000"):"";
			}
			return result;
		}

		__proto.clone=function(){
			var result=new TextFormat();
			result._align=this._align;
			result._blockIndent=this._blockIndent;
			result._bold=this._bold;
			result._bullet=this._bullet;
			result._color=this._color;
			result._font=this._font;
			result._indent=this._indent;
			result._italic=this._italic;
			result._leading=this._leading;
			result._leftMargin=this._leftMargin;
			result._letterSpacing=this._letterSpacing;
			result._rightMargin=this._rightMargin;
			result._size=this._size;
			result._underline=this._underline;
			return result;
		}

		__getset(0,__proto,'align',function(){
			return this._align;
			},function(value){
			this._align=value;
		});

		__getset(0,__proto,'bold',function(){
			return this._bold;
			},function(value){
			this._bold=value;
		});

		__getset(0,__proto,'blockIndent',function(){
			return this._blockIndent;
			},function(value){
			this._blockIndent=Laya.__parseInt(value);
		});

		__getset(0,__proto,'display',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'bullet',function(){
			return this._bullet;
			},function(value){
			this._bullet=value;
		});

		__getset(0,__proto,'color',function(){
			return this._color;
			},function(value){
			this._color=value;
		});

		__getset(0,__proto,'font',function(){
			return this._font;
			},function(value){
			this._font=value;
		});

		__getset(0,__proto,'indent',function(){
			return this._indent;
			},function(value){
			this._indent=Laya.__parseInt(value);
		});

		__getset(0,__proto,'italic',function(){
			return this._italic;
			},function(value){
			this._italic=value;
		});

		__getset(0,__proto,'leading',function(){
			return this._leading;
			},function(value){
			this._leading=Laya.__parseInt(value);
		});

		__getset(0,__proto,'leftMargin',function(){
			return this._leftMargin;
			},function(value){
			this._leftMargin=value;
		});

		__getset(0,__proto,'letterSpacing',function(){
			return this._letterSpacing;
			},function(value){
			this._letterSpacing=Laya.__parseInt(value);
		});

		__getset(0,__proto,'rightMargin',function(){
			return this._rightMargin;
			},function(value){
			this._rightMargin=Laya.__parseInt(value);
		});

		__getset(0,__proto,'size',function(){
			return this._size;
			},function(value){
			this._size=Laya.__parseInt(value);
		});

		__getset(0,__proto,'kerning',LAYAFNVOID/*function(){}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'tabStops',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'target',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'url',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'underline',function(){
			return this._underline;
			},function(value){
			this._underline=value;
		});

		TextFormat.BULLET_INDENT=50;
		TextFormat.BULLET_RADIUS=2;
		TextFormat.HEI_OFF=3;
		__static(TextFormat,
		['canvas',function(){return this.canvas=Canvas.create();},'ctx',function(){return this.ctx=TextFormat.canvas.context;}
		]);
		return TextFormat;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/text/textformatalign.as
	//class iflash.text.TextFormatAlign
	var TextFormatAlign=(function(){
		function TextFormatAlign(){}
		__class(TextFormatAlign,'iflash.text.TextFormatAlign',true);
		TextFormatAlign.CENTER="center";
		TextFormatAlign.JUSTIFY="justify";
		TextFormatAlign.LEFT="left";
		TextFormatAlign.RIGHT="right";
		return TextFormatAlign;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/text/textlinemetrics.as
	//class iflash.text.TextLineMetrics
	var TextLineMetrics=(function(){
		function TextLineMetrics(x,width,height,ascent,descent,leading){
			this.ascent=NaN;
			this.descent=NaN;
			this.height=NaN;
			this.leading=NaN;
			this.width=NaN;
			this.x=NaN;
			this.x=x;
			this.width=width;
			this.height=height;
			this.ascent=ascent;
			this.descent=descent;
			this.leading=leading;
		}

		__class(TextLineMetrics,'iflash.text.TextLineMetrics',true);
		return TextLineMetrics;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/text/textnodelist.as
	//class iflash.text.TextNodeList
	var TextNodeList=(function(){
		function TextNodeList(){
			this._source=null;
			this._source=[];
		}

		__class(TextNodeList,'iflash.text.TextNodeList',true);
		var __proto=TextNodeList.prototype;
		__proto.clear=function(){
			this._source.length=0;
		}

		__proto.getElem=function(index){
			return this._source[index];
		}

		__proto.push=function(value){
			this._source.push(value);
		}

		__proto.clone=function(){
			var result=new TextNodeList();
			var obj;
			for(var i=0,len=this._source.length;i<len;i++){
				obj={};
				for(var key in this._source[i]){
					obj[key]=this._source[i][key];
				}
				result.push(obj);
			}
			return result;
		}

		__getset(0,__proto,'length',function(){
			return this._source.length;
		});

		__getset(0,__proto,'source',function(){
			return this._source;
		});

		return TextNodeList;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/text/textsnapshot.as
	//class iflash.text.TextSnapshot
	var TextSnapshot=(function(){
		function TextSnapshot(){}
		__class(TextSnapshot,'iflash.text.TextSnapshot',true);
		var __proto=TextSnapshot.prototype;
		__proto.findText=LAYAFN0/*function(beginIndex,textToFind,caseSensitive){return 0}*/
		__proto.getSelected=LAYAFNFALSE/*function(beginIndex,endIndex){return false}*/
		__proto.getSelectedText=function(includeLineEndings){
			(includeLineEndings===void 0)&& (includeLineEndings=false);
			return null}
		__proto.getText=function(beginIndex,endIndex,includeLineEndings){
			(includeLineEndings===void 0)&& (includeLineEndings=false);
			return null}
		__proto.getTextRunInfo=LAYAFNNULL/*function(beginIndex,endIndex){return null}*/
		__proto.hitTestTextNearPos=function(x,y,maxDistance){
			(maxDistance===void 0)&& (maxDistance=0);
			return 0}
		__proto.setSelectColor=function(hexColor){
			(hexColor===void 0)&& (hexColor=16776960);
		}

		__proto.setSelected=LAYAFNVOID/*function(beginIndex,endIndex,select){}*/
		__getset(0,__proto,'charCount',LAYAFN0/*function(){return 0}*/);
		return TextSnapshot;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/ui/contextmenubuiltinitems.as
	//class iflash.ui.ContextMenuBuiltInItems
	var ContextMenuBuiltInItems=(function(){
		function ContextMenuBuiltInItems(){}
		__class(ContextMenuBuiltInItems,'iflash.ui.ContextMenuBuiltInItems',true);
		var __proto=ContextMenuBuiltInItems.prototype;
		__proto.clone=function(){
			return new ContextMenuBuiltInItems();
		}

		__getset(0,__proto,'forwardAndBack',LAYAFNFALSE/*function(){return false}*/,LAYAFNVOID/*function(val){}*/);
		__getset(0,__proto,'loop',LAYAFNFALSE/*function(){return false}*/,LAYAFNVOID/*function(val){}*/);
		__getset(0,__proto,'zoom',LAYAFNFALSE/*function(){return false}*/,LAYAFNVOID/*function(val){}*/);
		__getset(0,__proto,'play',LAYAFNFALSE/*function(){return false}*/,LAYAFNVOID/*function(val){}*/);
		__getset(0,__proto,'print',LAYAFNFALSE/*function(){return false}*/,LAYAFNVOID/*function(val){}*/);
		__getset(0,__proto,'quality',LAYAFNFALSE/*function(){return false}*/,LAYAFNVOID/*function(val){}*/);
		__getset(0,__proto,'rewind',LAYAFNFALSE/*function(){return false}*/,LAYAFNVOID/*function(val){}*/);
		__getset(0,__proto,'save',LAYAFNFALSE/*function(){return false}*/,LAYAFNVOID/*function(val){}*/);
		return ContextMenuBuiltInItems;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/ui/contextmenuclipboarditems.as
	//class iflash.ui.ContextMenuClipboardItems
	var ContextMenuClipboardItems=(function(){
		function ContextMenuClipboardItems(){}
		__class(ContextMenuClipboardItems,'iflash.ui.ContextMenuClipboardItems',true);
		var __proto=ContextMenuClipboardItems.prototype;
		__proto.clone=function(){
			return new ContextMenuClipboardItems();
		}

		__getset(0,__proto,'clear',LAYAFNFALSE/*function(){return false}*/,LAYAFNVOID/*function(val){}*/);
		__getset(0,__proto,'copy',LAYAFNFALSE/*function(){return false}*/,LAYAFNVOID/*function(val){}*/);
		__getset(0,__proto,'selectAll',LAYAFNFALSE/*function(){return false}*/,LAYAFNVOID/*function(val){}*/);
		__getset(0,__proto,'cut',LAYAFNFALSE/*function(){return false}*/,LAYAFNVOID/*function(val){}*/);
		__getset(0,__proto,'paste',LAYAFNFALSE/*function(){return false}*/,LAYAFNVOID/*function(val){}*/);
		return ContextMenuClipboardItems;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/ui/keyboard.as
	//class iflash.ui.Keyboard
	var Keyboard=(function(){
		function Keyboard(){
			;
		}

		__class(Keyboard,'iflash.ui.Keyboard',true);
		__getset(1,Keyboard,'capsLock',LAYAFNFALSE/*function(){return false}*/);
		__getset(1,Keyboard,'physicalKeyboardType',LAYAFNSTR/*function(){return ""}*/);
		__getset(1,Keyboard,'numLock',LAYAFNFALSE/*function(){return false}*/);
		__getset(1,Keyboard,'hasVirtualKeyboard',LAYAFNFALSE/*function(){return false}*/);
		Keyboard.isAccessible=LAYAFNFALSE/*function(){return false}*/
		Keyboard.KEYNAME_UPARROW="Up";
		Keyboard.KEYNAME_DOWNARROW="Down";
		Keyboard.KEYNAME_LEFTARROW="Left";
		Keyboard.KEYNAME_RIGHTARROW="Right";
		Keyboard.KEYNAME_F1="F1";
		Keyboard.KEYNAME_F2="F2";
		Keyboard.KEYNAME_F3="F3";
		Keyboard.KEYNAME_F4="F4";
		Keyboard.KEYNAME_F5="F5";
		Keyboard.KEYNAME_F6="F6";
		Keyboard.KEYNAME_F7="F7";
		Keyboard.KEYNAME_F8="F8";
		Keyboard.KEYNAME_F9="F9";
		Keyboard.KEYNAME_F10="F10";
		Keyboard.KEYNAME_F11="F11";
		Keyboard.KEYNAME_F12="F12";
		Keyboard.KEYNAME_F13="F13";
		Keyboard.KEYNAME_F14="F14";
		Keyboard.KEYNAME_F15="F15";
		Keyboard.KEYNAME_F16="F16";
		Keyboard.KEYNAME_F17="F17";
		Keyboard.KEYNAME_F18="F18";
		Keyboard.KEYNAME_F19="F19";
		Keyboard.KEYNAME_F20="F20";
		Keyboard.KEYNAME_F21="F21";
		Keyboard.KEYNAME_F22="F22";
		Keyboard.KEYNAME_F23="F23";
		Keyboard.KEYNAME_F24="F24";
		Keyboard.KEYNAME_F25="F25";
		Keyboard.KEYNAME_F26="F26";
		Keyboard.KEYNAME_F27="F27";
		Keyboard.KEYNAME_F28="F28";
		Keyboard.KEYNAME_F29="F29";
		Keyboard.KEYNAME_F30="F30";
		Keyboard.KEYNAME_F31="F31";
		Keyboard.KEYNAME_F32="F32";
		Keyboard.KEYNAME_F33="F33";
		Keyboard.KEYNAME_F34="F34";
		Keyboard.KEYNAME_F35="F35";
		Keyboard.KEYNAME_INSERT="Insert";
		Keyboard.KEYNAME_DELETE="Delete";
		Keyboard.KEYNAME_HOME="Home";
		Keyboard.KEYNAME_BEGIN="Begin";
		Keyboard.KEYNAME_END="End";
		Keyboard.KEYNAME_PAGEUP="PgUp";
		Keyboard.KEYNAME_PAGEDOWN="PgDn";
		Keyboard.KEYNAME_PRINTSCREEN="PrntScrn";
		Keyboard.KEYNAME_SCROLLLOCK="ScrlLck";
		Keyboard.KEYNAME_PAUSE="Pause";
		Keyboard.KEYNAME_SYSREQ="SysReq";
		Keyboard.KEYNAME_BREAK="Break";
		Keyboard.KEYNAME_RESET="Reset";
		Keyboard.KEYNAME_STOP="Stop";
		Keyboard.KEYNAME_MENU="Menu";
		Keyboard.KEYNAME_USER="User";
		Keyboard.KEYNAME_SYSTEM="Sys";
		Keyboard.KEYNAME_PRINT="Print";
		Keyboard.KEYNAME_CLEARLINE="ClrLn";
		Keyboard.KEYNAME_CLEARDISPLAY="ClrDsp";
		Keyboard.KEYNAME_INSERTLINE="InsLn";
		Keyboard.KEYNAME_DELETELINE="DelLn";
		Keyboard.KEYNAME_INSERTCHAR="InsChr";
		Keyboard.KEYNAME_DELETECHAR="DelChr";
		Keyboard.KEYNAME_PREV="Prev";
		Keyboard.KEYNAME_NEXT="Next";
		Keyboard.KEYNAME_SELECT="Select";
		Keyboard.KEYNAME_EXECUTE="Exec";
		Keyboard.KEYNAME_UNDO="Undo";
		Keyboard.KEYNAME_REDO="Redo";
		Keyboard.KEYNAME_FIND="Find";
		Keyboard.KEYNAME_HELP="Help";
		Keyboard.KEYNAME_MODESWITCH="ModeSw";
		Keyboard.NUMBER_0=48;
		Keyboard.NUMBER_1=49;
		Keyboard.NUMBER_2=50;
		Keyboard.NUMBER_3=51;
		Keyboard.NUMBER_4=52;
		Keyboard.NUMBER_5=53;
		Keyboard.NUMBER_6=54;
		Keyboard.NUMBER_7=55;
		Keyboard.NUMBER_8=56;
		Keyboard.NUMBER_9=57;
		Keyboard.A=65;
		Keyboard.B=66;
		Keyboard.C=67;
		Keyboard.D=68;
		Keyboard.E=69;
		Keyboard.F=70;
		Keyboard.G=71;
		Keyboard.H=72;
		Keyboard.I=73;
		Keyboard.J=74;
		Keyboard.K=75;
		Keyboard.L=76;
		Keyboard.M=77;
		Keyboard.N=78;
		Keyboard.O=79;
		Keyboard.P=80;
		Keyboard.Q=81;
		Keyboard.R=82;
		Keyboard.S=83;
		Keyboard.T=84;
		Keyboard.U=85;
		Keyboard.V=86;
		Keyboard.W=87;
		Keyboard.X=88;
		Keyboard.Y=89;
		Keyboard.Z=90;
		Keyboard.SEMICOLON=186;
		Keyboard.EQUAL=187;
		Keyboard.COMMA=188;
		Keyboard.MINUS=189;
		Keyboard.PERIOD=190;
		Keyboard.SLASH=191;
		Keyboard.BACKQUOTE=192;
		Keyboard.LEFTBRACKET=219;
		Keyboard.BACKSLASH=220;
		Keyboard.RIGHTBRACKET=221;
		Keyboard.QUOTE=222;
		Keyboard.ALTERNATE=18;
		Keyboard.BACKSPACE=8;
		Keyboard.CAPS_LOCK=20;
		Keyboard.COMMAND=15;
		Keyboard.CONTROL=17;
		Keyboard.DELETE=46;
		Keyboard.DOWN=40;
		Keyboard.END=35;
		Keyboard.ENTER=13;
		Keyboard.ESCAPE=27;
		Keyboard.F1=112;
		Keyboard.F2=113;
		Keyboard.F3=114;
		Keyboard.F4=115;
		Keyboard.F5=116;
		Keyboard.F6=117;
		Keyboard.F7=118;
		Keyboard.F8=119;
		Keyboard.F9=120;
		Keyboard.F10=121;
		Keyboard.F11=122;
		Keyboard.F12=123;
		Keyboard.F13=124;
		Keyboard.F14=125;
		Keyboard.F15=126;
		Keyboard.HOME=36;
		Keyboard.INSERT=45;
		Keyboard.LEFT=37;
		Keyboard.NUMPAD=21;
		Keyboard.NUMPAD_0=96;
		Keyboard.NUMPAD_1=97;
		Keyboard.NUMPAD_2=98;
		Keyboard.NUMPAD_3=99;
		Keyboard.NUMPAD_4=100;
		Keyboard.NUMPAD_5=101;
		Keyboard.NUMPAD_6=102;
		Keyboard.NUMPAD_7=103;
		Keyboard.NUMPAD_8=104;
		Keyboard.NUMPAD_9=105;
		Keyboard.NUMPAD_ADD=107;
		Keyboard.NUMPAD_DECIMAL=110;
		Keyboard.NUMPAD_DIVIDE=111;
		Keyboard.NUMPAD_ENTER=108;
		Keyboard.NUMPAD_MULTIPLY=106;
		Keyboard.NUMPAD_SUBTRACT=109;
		Keyboard.PAGE_DOWN=34;
		Keyboard.PAGE_UP=33;
		Keyboard.RIGHT=39;
		Keyboard.SHIFT=16;
		Keyboard.SPACE=32;
		Keyboard.TAB=9;
		Keyboard.UP=38;
		Keyboard.RED=16777216;
		Keyboard.GREEN=16777217;
		Keyboard.YELLOW=16777218;
		Keyboard.BLUE=16777219;
		Keyboard.CHANNEL_UP=16777220;
		Keyboard.CHANNEL_DOWN=16777221;
		Keyboard.RECORD=16777222;
		Keyboard.PLAY=16777223;
		Keyboard.PAUSE=16777224;
		Keyboard.STOP=16777225;
		Keyboard.FAST_FORWARD=16777226;
		Keyboard.REWIND=16777227;
		Keyboard.SKIP_FORWARD=16777228;
		Keyboard.SKIP_BACKWARD=16777229;
		Keyboard.NEXT=16777230;
		Keyboard.PREVIOUS=16777231;
		Keyboard.LIVE=16777232;
		Keyboard.LAST=16777233;
		Keyboard.MENU=16777234;
		Keyboard.INFO=16777235;
		Keyboard.GUIDE=16777236;
		Keyboard.EXIT=16777237;
		Keyboard.BACK=16777238;
		Keyboard.AUDIO=16777239;
		Keyboard.SUBTITLE=16777240;
		Keyboard.DVR=16777241;
		Keyboard.VOD=16777242;
		Keyboard.INPUT=16777243;
		Keyboard.SETUP=16777244;
		Keyboard.HELP=16777245;
		Keyboard.MASTER_SHELL=16777246;
		Keyboard.SEARCH=16777247;
		__static(Keyboard,
		['CharCodeStrings',function(){return this.CharCodeStrings=["Up","Down","Left","Right","F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12","F13","F14","F15","F16","F17","F18","F19","F20","F21","F22","F23","F24","F25","F26","F27","F28","F29","F30","F31","F32","F33","F34","F35","Insert","Delete","Home","Begin","End","PgUp","PgDn","PrntScrn","ScrlLck","Pause","SysReq","Break","Reset","Stop","Menu","User","Sys","Print","ClrLn","ClrDsp","InsLn","DelLn","InsChr","DelChr","Prev","Next","Select","Exec","Undo","Redo","Find","Help","ModeSw"];}
		]);
		return Keyboard;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/ui/keyboardtype.as
	//class iflash.ui.KeyboardType
	var KeyboardType=(function(){
		function KeyboardType(){
			;
		}

		__class(KeyboardType,'iflash.ui.KeyboardType',true);
		KeyboardType.ALPHANUMERIC="alphanumeric";
		KeyboardType.KEYPAD="keypad";
		KeyboardType.NONE="none";
		return KeyboardType;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/ui/keylocation.as
	//class iflash.ui.KeyLocation
	var KeyLocation=(function(){
		function KeyLocation(){
			;
		}

		__class(KeyLocation,'iflash.ui.KeyLocation',true);
		KeyLocation.STANDARD=0;
		KeyLocation.LEFT=1;
		KeyLocation.RIGHT=2;
		KeyLocation.NUM_PAD=3;
		KeyLocation.D_PAD=4;
		return KeyLocation;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/ui/mouse.as
	//class iflash.ui.Mouse
	var Mouse=(function(){
		function Mouse(){
			;
		}

		__class(Mouse,'iflash.ui.Mouse',true);
		__getset(1,Mouse,'supportsCursor',LAYAFNFALSE/*function(){return false}*/);
		__getset(1,Mouse,'cursor',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(value){}*/);
		__getset(1,Mouse,'supportsNativeCursor',LAYAFNFALSE/*function(){return false}*/);
		Mouse.hide=LAYAFNVOID/*function(){}*/
		Mouse.show=LAYAFNVOID/*function(){}*/
		Mouse.registerCursor=LAYAFNVOID/*function(value,cursorData){}*/
		Mouse.unregisterCursor=LAYAFNVOID/*function(param1){}*/
		return Mouse;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/ui/mousecursor.as
	//class iflash.ui.MouseCursor
	var MouseCursor=(function(){
		function MouseCursor(){}
		__class(MouseCursor,'iflash.ui.MouseCursor',true);
		MouseCursor.ARROW="arrow";
		MouseCursor.AUTO="auto";
		MouseCursor.BUTTON="button";
		MouseCursor.HAND="hand";
		MouseCursor.IBEAM="ibeam";
		return MouseCursor;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/ui/mousecursordata.as
	//class iflash.ui.MouseCursorData
	var MouseCursorData=(function(){
		function MouseCursorData(){
			;
		}

		__class(MouseCursorData,'iflash.ui.MouseCursorData',true);
		var __proto=MouseCursorData.prototype;
		__getset(0,__proto,'data',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(param1){}*/);
		__getset(0,__proto,'hotSpot',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(param1){}*/);
		__getset(0,__proto,'frameRate',LAYAFN0/*function(){return 0}*/,LAYAFNVOID/*function(param1){}*/);
		return MouseCursorData;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/ui/multitouch.as
	//class iflash.ui.Multitouch
	var Multitouch=(function(){
		function Multitouch(){};
		__class(Multitouch,'iflash.ui.Multitouch',true);
		__getset(1,Multitouch,'inputMode',function(){
			return Multitouch.$inputMode;
			},function(value){
			if(value==/*iflash.ui.MultitouchInputMode.GESTURE*/"gesture")
				Multitouch.implementGesture();
			if(value==/*iflash.ui.MultitouchInputMode.TOUCH_POINT*/"touchPoint")
				Multitouch.implementTouchPoint();
			Multitouch.$inputMode=value;
		});

		__getset(1,Multitouch,'isSupportTouch',function(){
			var doc=Browser.document;
			var isSupportTouch="ontouchend" in doc ? true :false;
			return isSupportTouch;
		});

		__getset(1,Multitouch,'maxTouchPoints',function(){
			Multitouch._$maxTouchPoints=3;
			return Multitouch._$maxTouchPoints;
			},function(value){
			Multitouch._$maxTouchPoints=value;
		});

		__getset(1,Multitouch,'supportedGestures',function(){
			Multitouch._$supportedGestures=[];
			if(Multitouch.isSupportTouch){
				Multitouch._$supportedGestures.push(/*iflash.events.TransformGestureEvent.GESTURE_PAN*/"gesturePan");
				Multitouch._$supportedGestures.push(/*iflash.events.TransformGestureEvent.GESTURE_ROTATE*/"gestureRotate");
				Multitouch._$supportedGestures.push(/*iflash.events.TransformGestureEvent.GESTURE_SWIPE*/"gestureSwipe");
				Multitouch._$supportedGestures.push(/*iflash.events.TransformGestureEvent.GESTURE_ZOOM*/"gestureZoom");
				Multitouch._$supportedGestures.push(/*iflash.events.GestureEvent.GESTURE_TWO_FINGER_TAP*/"gestureTwoFingerTap");
			}
			return Multitouch._$supportedGestures;
		});

		__getset(1,Multitouch,'supportsTouchEvents',function(){
			Multitouch._$supportsTouchEvents=Multitouch.isSupportTouch;
			return Multitouch._$supportsTouchEvents;
		});

		__getset(1,Multitouch,'mapTouchToMouse',function(){
			Multitouch._$mapTouchToMouse=Multitouch.isSupportTouch;
			return Multitouch._$mapTouchToMouse;
		});

		__getset(1,Multitouch,'supportsGestureEvents',function(){
			Multitouch._$supportsGestureEvents=Multitouch.isSupportTouch;
			return Multitouch._$supportsGestureEvents;
		});

		Multitouch.implementTouchPoint=function(){
			var doc=Browser.document;
		}

		Multitouch.implementGesture=function(){
			var doc=Browser.document;
		}

		Multitouch._$mapTouchToMouse=false;
		Multitouch._$maxTouchPoints=0;
		Multitouch._$supportedGestures=null
		Multitouch._$supportsGestureEvents=false;
		Multitouch._$supportsTouchEvents=false;
		__static(Multitouch,
		['$inputMode',function(){return this.$inputMode=/*iflash.ui.MultitouchInputMode.NONE*/"none";}
		]);
		return Multitouch;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/ui/multitouchinputmode.as
	//class iflash.ui.MultitouchInputMode
	var MultitouchInputMode=(function(){
		function MultitouchInputMode(){};
		__class(MultitouchInputMode,'iflash.ui.MultitouchInputMode',true);
		MultitouchInputMode.GESTURE="gesture";
		MultitouchInputMode.NONE="none";
		MultitouchInputMode.TOUCH_POINT="touchPoint";
		return MultitouchInputMode;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/xml/xmlattribute.as
	//class iflash.xml.XMLAttribute
	var XMLAttribute=(function(){
		function XMLAttribute(){
			this._name=null;
			this._value=null;
		}

		__class(XMLAttribute,'iflash.xml.XMLAttribute',false);
		var __proto=XMLAttribute.prototype;
		Laya.imps(__proto,{"iflash.xml.IXMLElement":true})
		__proto.getAttribute=function(aName){
			return null;
		}

		__proto.attribute=function(aName){
			return null;
		}

		__proto.setChildByName=function(nName,value){
			return null;
		}

		__proto.getChildByAttribute=function(attribute,value,equal){
			(equal===void 0)&& (equal=true);
			return null;
		}

		__proto.getChildByName=function(nName){
			return null;
		}

		__proto.setAttribute=function(name,value){
			return null;
		}

		__proto.getAttributes=function(){
			return null;
		}

		__proto.attributes=function(){
			return null;
		}

		__proto.getChildAt=function(index){
			return null;
		}

		__proto.children=function(){
			return null;
		}

		__proto.elements=function(name){
			(name===void 0)&& (name="*");
			return null;
		}

		__proto.setName=function(str){
			this._name=str;
		}

		__proto.lengths=function(){
			return 0;
		}

		__proto.name=function(){
			return this._name;
		}

		__proto.appendChild=function(value){
			return null;
		}

		__proto.toString=function(){
			return this._value;
		}

		__proto.toXMLString=function(){
			return null;
		}

		__proto.parent=LAYAFNNULL/*function(){return null;}*/
		__proto.hasSimpleContent=LAYAFNFALSE/*function(){return false}*/
		__proto.hasComplexContent=LAYAFNFALSE/*function(){return false}*/
		__proto.hasOwnProperty=function(pName){
			return false;
		}

		__proto.copy=function(){
			var xa=new XMLAttribute();
			xa._name=this._name;
			xa._value=this._value;
			return xa;
		}

		__proto.copyFrom=function(source){
			if((source instanceof iflash.xml.XMLAttribute )){
				var value=source;
				this._name=value._name;
				this._value=value._value;
				return this;
			}
			return null;
		}

		__getset(0,__proto,'localName',function(){
			return null;
			},function(str){
			this._name=str;
		});

		__getset(0,__proto,'nodeType',function(){
			return "attribute";
		});

		__getset(0,__proto,'value',function(){
			return this._value;
			},function(str){
			this._value=str;
		});

		__getset(0,__proto,'childNodes',function(){
			return null;
		});

		__getset(0,__proto,'nodeName',function(){
			return null;
		});

		XMLAttribute.create=function(name,value){
			var xa=new XMLAttribute();
			xa._name=name;xa._value=value;
			return xa;
		}

		return XMLAttribute;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/xml/xmlelement.as
	//class iflash.xml.XMLElement
	var XMLElement=(function(){
		function XMLElement(value){
			this._nodeName=null;
			this._nodeType=null;
			this._nodeValue=null;
			this._parentNode=null;
			this._attributes=[];
			this._childNodes=[];
			this._nestCount=0;
			if((value instanceof iflash.xml.XMLElement )){return value}
				else if ((value instanceof iflash.xml.XMLElementList )){if (value.lengths()==1){return value[0]}else {return value;}}
			if (value){
				if(value && value['_data_']){value=value.toString();}
					if (value){
					XMLElement.create(value,this);
				}
			}
		}

		__class(XMLElement,'iflash.xml.XMLElement',false);
		var __proto=XMLElement.prototype;
		Laya.imps(__proto,{"iflash.xml.IXMLElement":true})
		__proto.addNamespace=function(ns){
			return this;
		}

		__proto.setAttribute=function(name,value){
			var o;
			/*for each*/for(var $each_o in this._attributes){
				o=this._attributes[$each_o];
				if (o.key==name){
					o.val=value;
					return value;
				}
			}
			this._attributes.push({key:name,val:value});
			return value;
		}

		__proto.getAttributes=function(){
			return this.attributes();
		}

		__proto.attributes=function(){
			return this.getAttribute("*");
		}

		__proto.getAttribute=function(name){
			var attributes=this._attributes;
			var arr=[];
			for (var j=0;j < attributes.length;j++){
				var value=attributes[j]['key'];
				if (name=="*" || value==name){
					arr.push({"key":attributes[j]['key'],"val":attributes[j]['val']});
				}
			}
			if (name!="*"){
				return arr.length>0?arr[0].val:undefined;
			}
			return XMLElementList.createFromAttribute(arr);
		}

		__proto.getAllAttribute=function(name){
			var arr=[];
			this._getAllAttribute_(arr,this,name);
			return XMLElementList.createFromAttribute(arr);
		}

		__proto._getAllAttribute_=function(arr,xml,name){
			var len=xml._childNodes ? xml._childNodes.length :0;
			for (var i=0;i < len;i++){
				var node=xml._childNodes [i];
				for (var j=0;j < node._attributes.length;j++){
					var key=node._attributes[j]['key'];
					var val=node._attributes[j]['val'];
					if (name=="*"){
						arr.push({"key":key,"val":val});
						}else if (key==name){
						arr.push({"key":key,"val":val});
					}
				}
				this._getAllAttribute_(arr,node,name);
			}
		}

		__proto.attribute=function(name){
			return this.getAttribute(name);
		}

		__proto.getChildByName=function(name){
			return this.child(name);
		}

		__proto.getAllChildByName=function(name){
			var arr=[];
			this._getAllChildByName_(arr,this,name);
			return XMLElementList.create(arr);
		}

		__proto._getAllChildByName_=function(arr,xml,name){
			var len=xml._childNodes ? xml._childNodes.length :0;
			for (var i=0;i < len;i++){
				var node=xml._childNodes [i];
				if(name=="*"){
					arr.push(node);
					}else if (node._nodeName==name){
					arr.push(node);
				}
				this._getAllChildByName_(arr,node,name);
			}
		}

		__proto.nodeKind=function(){
			return this._nodeType;
		}

		__proto.getChildByAttribute=function(attribute,value,equal){
			(equal===void 0)&& (equal=true);
			if (attribute=="" || attribute==null)
				return null;
			if (value=="" || value==null)
				return null;
			var ar=[],len=this._childNodes ? this._childNodes.length :0;
			for (var i=0;i < len;i++){
				var n=this._childNodes [i];
				for (var j=0;j < n._attributes.length;j++){
					if (n._attributes[j]['key']==attribute){
						if (equal && n._attributes[j]['val']==value){
							ar.push(n);
							}else if (!equal && n._attributes[j]['val'] !=value){
							ar.push(n);
						}
					}
				}
			}
			return XMLElementList.create(ar);
		}

		__proto.children=function(){
			var l=XMLElementList.create(this._childNodes);
			if(!l.length)
				if((typeof this._nodeValue=='string')&& this._nodeValue !=""){
				l.push(this._nodeValue);
			}
			return l;
		}

		__proto.getChildAt=function(index){
			if (!this._childNodes || index > this._childNodes.length)
				return null;
			return this._childNodes[index];
		}

		__proto.elements=function(name){
			(name===void 0)&& (name="*");
			if (name=='*')
				return XMLElementList.create(this._childNodes);
			return this.child(name);
		}

		__proto.appendChild=function(value){
			if ((typeof value=='string')){
				value=iflash.xml.XMLElement.create(String(value));
			}
			if ((value instanceof iflash.xml.XMLElement )){
				var name=value._nodeName;
				var list=this[name];
				if (!list){
					this[name]=list=new XMLElementList();
				}
				(((typeof list=='function'))!=true)&&(list.__addChild__(value));
				this._childNodes.push(value);
				}else if ((value instanceof iflash.xml.XMLElementList )){
				var len=value.lengths();
				for (var i=0;i < len;i++){
					this.appendChild(value[i]);
				}
			}
			value._parentNode=this;
			return value;
		}

		__proto.prependChild=function(value){
			var xml=this.appendChild(value);
			var nodes=this._childNodes;
			nodes.pop();
			nodes.splice(0,0,xml);
			return xml;
		}

		__proto.setChildByName=function(nName,value){
			var c=this.getChildByName(nName);
			if (!c)
				return null;
			var spliceIndex=this._childNodes.length;
			for (var i=this._childNodes.length-1;i >=0;i--){
				if (this._childNodes[i].localName==nName){
					this._childNodes.splice(i,1);
					spliceIndex=i;
				}
			}
			if ((value instanceof iflash.xml.XMLElementList )){
				for (i=0;i < value.lengths();i++){
					this._childNodes.splice(spliceIndex,0,value[i]);
					spliceIndex++;
				}
				}else if ((value instanceof iflash.xml.XMLElement )){
				this._childNodes.splice(spliceIndex,0,value);
				}else {
				return null;
			}
			return c;
		}

		__proto.copy=function(){
			var xml=new XMLElement(this.toXMLString());
			return xml;
		}

		__proto.copyFrom=function(source){
			if ((source instanceof iflash.xml.XMLElement )){
				var value=source;
				this._nodeName=value._nodeName;
				this._nodeValue=value._nodeValue;
				this._attributes=value._attributes;
				this._childNodes=value._childNodes;
				return this;
			}
			return null;
		}

		__proto.setName=function(str){
			this._nodeName=str;
		}

		__proto.hasOwnProperty=function(pName){
			var len=0,i=0;
			if(pName.indexOf("@")!=-1){
				var tmpPName=pName.substring(1);
				len=this._attributes.length;
				for (i=0;i < len;i++){
					if (this._attributes[i].key==tmpPName)
						return true;
				}
				}else{
				len=this._childNodes.length;
				for (i=0;i < len;i++){
					if (this._childNodes[i]._nodeName==pName)
						return true;
				}
			}
			return false;
		}

		__proto.hasSimpleContent=function(){
			if (this._childNodes.length > 1){
				return false;
				}else if (this._childNodes.length==1){
				if (!this._childNodes[0].localName)
					return true;
				return false;
			}
			return true;
		}

		__proto.hasComplexContent=function(){
			return this._childNodes.length > 0
		}

		__proto.lengths=function(){
			return 1
		}

		__proto.name=function(){
			return this._nodeName;
		}

		__proto.parent=function(){
			return this._parentNode;
		}

		__proto.toString=function(){
			var str="";
			if (this._childNodes.length){
				str=this.toXMLString();
			}else
			str=this._nodeValue;
			return str;
		}

		__proto.getString=function(){
			var str="";
			str=this.toXMLString();
			return str;
		}

		__proto.toXMLString=function(){
			if (!XMLElement._callee)
				XMLElement._callee=this;
			var str="";
			if (this._nodeName){
				str+="<"+this._nodeName;
				for (var i=0;i < this._attributes.length;i++){
					str+=" "+this._attributes[i]['key']+'="'+this._attributes[i]['val']+'"'
				}
			}
			if (this.hasSimpleContent()&& !this.value)
				str+="/>";
			else {
				str+=this._nodeName ? ">" :"";
				str+=(this._childNodes.length ? "\n" :this._nodeValue);
				this._nestCount=(this._childNodes.length)? this._nestCount+1 :this._nestCount;
				for (i=0;i < this._childNodes.length;i++){
					this._childNodes[i]._nestCount=this._nestCount;
					for (var j=0;j < this._nestCount;j++){
						str+="   ";
					}
					str+=this._childNodes[i].toXMLString();
					for (j=0;j < this._nestCount-1;j++){
						str+="   ";
					}
				}
				if (this._nodeName)
					str+="</"+this._nodeName+">";
			}
			if (XMLElement._callee !=this)
				str+="\n";
			else
			XMLElement._callee=null;
			return str;
		}

		__proto.child=function(nName){
			if((typeof nName=='number')){
				return XMLElementList.create([ this._childNodes[nName]]);
			};
			var ar=[],len=this._childNodes ? this._childNodes.length :0;
			for (var i=0;i < len;i++){
				var n=this._childNodes [i];
				if (n.localName==nName){
					ar.push(n);
				}
			}
			return XMLElementList.create(ar);
		}

		__proto.childIndex=function(){
			var parent=this._parentNode;
			if (parent){
				var nodes=parent._childNodes;
				for (var i=0,n=nodes.length;i < n;i++){
					if (nodes[i]==this){
						return i;
					}
				}
			}
			return-1;
		}

		__proto.insertChildBefore=function(child1,child2){
			if(!child1){
				this.prependChild(child2);
				return;
			}
			if ((child1 instanceof iflash.xml.XMLElementList ))
				child1=child1[0];
			var list=child1.parent().childNodes;
			if(list){
				var idx=list.indexOf(child1);
				list.splice(idx,0,child2);
				var xl=new XMLElementList();
				xl.push(child2);
				child2._parentNode=this;
				child1.parent()[child2.nodeName]=xl;
				return this;
			}
			return undefined;
		}

		__proto.insertChildAfter=function(child1,child2){
			if(!child1){
				this.appendChild(child2);
				return;
			}
			if ((child1 instanceof iflash.xml.XMLElementList ))
				child1=child1[0];
			var list=child1.parent().childNodes;
			if(list){
				var idx=list.indexOf(child1);
				list.splice(idx+1,0,child2);
				var xl=new XMLElementList();
				xl.push(child2);
				child2._parentNode=this;
				child1.parent()[child2.nodeName]=xl;
				return this;
			}
			return undefined;
		}

		__proto.normalize=function(){
			return null;
		}

		__proto.comments=function(){
			return null;
		}

		__proto.contains=function(value){
			return true;
		}

		__proto.defaultSettings=function(){
			return null;
		}

		__proto.descendants=function(name){
			return null;
		}

		__proto.inScopeNamespaces=function(){
			return [];
		}

		__proto.setLocalName=function(name){
			this._nodeName=name;
		}

		__getset(0,__proto,'localName',function(){
			return this._nodeName;
			},function(str){
			this._nodeName=str;
		});

		__getset(0,__proto,'nodeType',function(){
			return this._nodeType;
		});

		__getset(0,__proto,'childNodes',function(){
			return this._childNodes;
		});

		__getset(0,__proto,'nodeName',function(){
			return this._nodeName;
		});

		__getset(0,__proto,'value',function(){
			return this._nodeValue;
			},function(str){
			this._nodeValue=str;
		});

		__getset(0,__proto,'conchValue',function(){
			var temp="";
			if (this._childNodes){
				for (var i=0,len=this._childNodes.length;i < len;i++){
					temp+=this._childNodes[i].conchValue;
				}
				temp+=this.value;
			}
			else
			temp=this.value;
			return temp;
		});

		XMLElement.create=function(value,node){
			node=node ? node :new XMLElement();
			var xmld;
			if (IFlash.isRuningOnAccelerator && !((typeof value=='string'))){
				xmld=value;
				xmld=xmld.childNodes[0];
				}else{
				/*__JS__ */xmld=(new DOMParser()).parseFromString(value,'text/xml');var t_i=0;var t_xmld=null;do{t_xmld=xmld.childNodes[t_i++];if(t_xmld.nodeName !='#comment' ){xmld=t_xmld;break;}}while(t_i<xmld.childNodes.length);;
			}
			XMLElement.cloneXmlFromData(node,xmld);
			return node;
		}

		XMLElement.cloneXmlFromData=function(xml,data){
			xml._nodeName=data.nodeName;
			xml._nodeValue=data.nodeValue==null ? data.textContent :data.nodeValue;
			var attribs=data.attributes;
			var len=attribs ? attribs.length :0;
			var attributes=xml._attributes;
			for (var j=0;j < len;j++){
				var attr=attribs[j];
				attributes.push({key:attr.nodeName,val:attr.nodeValue});
			};
			var nodes=data.childNodes;
			var child;
			for (var i=0;i < nodes.length;i++){
				var node=nodes[i];
				var nodeName=node.nodeName;
				if(nodeName=="#text"){
					if(node.parentNode&&node.parentNode.textContent!=node.textContent){
						var tValue;
						tValue=node.nodeValue.replace(/(^\s*)|(\s*$)/g,'');
						if(tValue.length>1){
							node.nodeValue=tValue;
							child=new XMLElement();
							XMLElement.cloneXmlFromData(child,node);
							xml.appendChild(child);
						}
					}
				}else
				if (nodeName !="#text" && nodeName !="#comment"){
					if (nodeName=="#cdata-section" || nodeName==""){
						xml._nodeValue=node.nodeValue==null ? node.textContent :node.nodeValue;
						continue ;
					}
					child=new XMLElement();
					XMLElement.cloneXmlFromData(child,node);
					xml.appendChild(child);
				}
			}
		}

		XMLElement._callee=null
		return XMLElement;
	})()


	var XML=window.XML=iflash.xml.XMLElement;
	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/mx/core/soundasset.as
	//class mx.core.SoundAsset
	var SoundAsset=(function(){
		function SoundAsset(){}
		__class(SoundAsset,'mx.core.SoundAsset',true);
		return SoundAsset;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/errors/illegaloperationerror.as
	//class iflash.errors.IllegalOperationError extends Error
	var IllegalOperationError=(function(_super){
		function IllegalOperationError(message,id){
			(message===void 0)&& (message="");
			(id===void 0)&& (id=0);
			IllegalOperationError.__super.call(this,message,id);
		}

		__class(IllegalOperationError,'iflash.errors.IllegalOperationError',true,Error);
		return IllegalOperationError;
	})(Error)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/errors/ioerror.as
	//class iflash.errors.IOError extends Error
	var IOError=(function(_super){
		function IOError(message,id){
			(message===void 0)&& (message="");
			(id===void 0)&& (id=0);
			IOError.__super.call(this,message,id);
		}

		__class(IOError,'iflash.errors.IOError',true,Error);
		return IOError;
	})(Error)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/xml/xmlelementlist.as
	//class iflash.xml.XMLElementList extends Array
	var XMLElementList=(function(_super){
		function XMLElementList(value){
			this._value="";
			this._parentNode=null;
			XMLElementList.__super.call(this);
			__uns(this,['_value','_parentNode']);
			if (value){
				value="<data>"+value+"</data>";
				var list=XMLElementList.create(XMLElement.create(value).childNodes);
				for (var i=0;i < list.length;i++){
					this.push(list[i]);
				}
			}
			/*__JS__ */Object.defineProperty(this,'length',{value:this.length,writable:true,enumerable:false,configurable:false});
		}

		__class(XMLElementList,'iflash.xml.XMLElementList',false,Array);
		var __proto=XMLElementList.prototype;
		Laya.imps(__proto,{"iflash.xml.IXMLElement":true})
		__proto.childIndex=function(){
			if (this.lengths()==1){
				var xml=this[0];
				var parent=xml._parentNode;
				if (parent){
					var nodes=parent._childNodes;
					for (var i=0,n=nodes.length;i < n;i++){
						if (nodes[i]==xml){
							return i;
						}
					}
				}
			}
			return-1;
		}

		__proto.getAttributes=function(){
			return this.attributes();
		}

		__proto.attributes=function(){
			return this.getAttribute("*");
		}

		__proto.getAttribute=function(name){
			var arr=[],len=this.length;
			for (var i=0;i < len;i++){
				var attributes=this[i]._attributes;
				for (var j=0;j < attributes.length;j++){
					var value=attributes[j]['key'];
					if (name=="*" || value==name){
						arr.push({"key":attributes[j]['key'],"val":attributes[j]['val']});
					}
				}
			}
			if (name!="*"){
				if(arr && arr.length==1){
					return arr.length>0?arr[0].val:undefined;
				}
			}
			return iflash.xml.XMLElementList.createFromAttribute(arr);
		}

		__proto.attribute=function(name){
			return this.getAttribute(name);
		}

		__proto.setAttribute=function(name,value){
			if (this.length==1){
				var o;
				/*for each*/for(var $each_o in this[0]._attributes){
					o=this[0]._attributes[$each_o];
					if (o['key']==name){
						o['val']=value;
						return value;
					}
				}
				this[0]._attributes.push({key:name,val:value});
			}
			return null;
		}

		__proto.getChildByName=function(name){
			return this.child(name);
		}

		__proto.child=function(name){
			if (!this.length)
				return new XMLElementList();
			var arr=[],len=this.lengths();
			for (var i=0;i < len;i++){
				var nodes=this[i].getChildByName(name);
				(nodes && nodes.length)&& (arr=arr.concat(this[i].getChildByName(name)));
			}
			return XMLElementList.create(arr);
		}

		__proto.getChildByAttribute=function(attribute,value,equal){
			(equal===void 0)&& (equal=true);
			if (attribute=="" || attribute==null)
				return null;
			if (value=="" || value==null)
				return null;
			var ar=[],len=this.length;
			for (var i=0;i < len;i++){
				var n=this [i];
				for (var j=0;j < n._attributes.length;j++){
					if (n._attributes[j]['key']==attribute){
						if (equal && n._attributes[j]['val']==value){
							ar.push(n);
							}else if (!equal && n._attributes[j]['val'] !=value){
							ar.push(n);
						}
					}
				}
			}
			return iflash.xml.XMLElementList.create(ar);
		}

		__proto.getChildAt=function(index){
			if (!this.length || index > this.length)
				return null;
			else
			return this[index];
		}

		__proto.children=function(){
			var xl=new XMLElementList();
			var len=this.lengths();
			for (var i=0;i < len;i++){
				var childs=this[i]._childNodes;
				var n=childs.length;
				for (var j=0;j < n;j++){
					xl.push(childs[j]);
				}
				if(n<1){
					xl.push(this[i]);
				}
			}
			return xl;
		}

		__proto.elements=function(name){
			(name===void 0)&& (name="*");
			if (!this.length)
				return new XMLElementList();
			if (name=="*")
				return this.children();
			return this.child(name);
		}

		__proto.appendChild=function(value){
			if ((typeof value=='string')){
				value=XMLElement.create(String(value));
			}
			this.__doAdd__(value);
			return value;
		}

		__proto.__addChild__=function(value){
			if ((value instanceof iflash.xml.XMLElement )){
				var ixl=value._childNodes,len=ixl.length;
				for (var i=0;i < len;i++){
					this.__doAdd__(ixl[i]);
				}
				this.push(value);
				}else if ((value instanceof iflash.xml.XMLElementList )){
				len=value.lengths();
				for (i=0;i < len;i++){
					this.__addChild__(value[i]);
				}
			}
		}

		__proto.__doAdd__=function(value){
			if (this.indexOf(value)!=-1)
				return;
			var n=value._nodeName;
			var x=this[n];
			if ((x instanceof iflash.xml.XMLElementList )){
				x.__addChild__(value);
				}else if ((x instanceof iflash.xml.XMLElement )){
				var tmp=x;
				x=this[n]=new XMLElementList();
				Object.defineProperty(this,[n],{value:this[n],writable:true,enumerable:false,configurable:false});
				x.__addChild__(tmp);
				x.__addChild__(value);
				}else if (!x){
				x=new XMLElementList();
				if (this.length==1){
					this[0][n]=x;
					this[0]._childNodes=x;
				}
				else
				this[n]=x;
				x.__addChild__(value);
				Object.defineProperty(this,[n],{value:this[n],writable:true,enumerable:false,configurable:false});
			}
		}

		__proto.setName=function(str){
			if (this.length==1){
				this[0]._nodeName=str;
			}
		}

		__proto.copyFrom=function(source){
			if (this.lengths()> 1)
				return null;
			var il=((source instanceof iflash.xml.XMLElementList ));
			if (source.lengths()> 1)
				return null;
			if (il)
				this[0].copyFrom(source.getChildAt(0));
			else
			this[0].copyFrom(source);
			return this [0];
		}

		__proto.hasOwnProperty=function(pName){
			if (this.length==0){
				return this[0].hasOwnProperty(pName);
				}else {
				var x;
				/*for each*/for(var $each_x in this){
					x=this[$each_x];
					if (x['hasOwnProperty'](pName))
						return true;
				}
			}
			return false;
		}

		__proto.setChildByName=function(nName,value){
			return null;
			this.splice(0,/*int.MAX_VALUE*/2147483647);
			if ((value instanceof iflash.xml.XMLElementList )&& value.lengths()==1){
				this.push(value[0]);
				}else if ((value instanceof iflash.xml.XMLElement )){
				this.push(value);
				}else {
				return null;
			}
			return this;
		}

		__proto.hasComplexContent=function(){
			return this.length > 0;
		}

		__proto.hasSimpleContent=function(){
			var len=this.length;
			for (var i=0;i < len;i++){
				if (this['_nodeValue'] !=null){
					return true
				}
			}
			return false
		}

		__proto.name=function(){
			if (this.length==1)
				return this[0].name();
			return null;
		}

		__proto.lengths=function(){
			for (var i=this.length-1;i >=0;i--){
				if (this[i]==undefined)
					this.splice(i,1);
			}
			return this.length;
		}

		__proto.toString=function(){
			var str="";
			if (this.lengths()){
				if (this.length==1){
					str+=this[0].toString();
					}else {
					for (var i=0;i < this.length;i++){
						if (this.length > 1)
							str+=this[i].getString();
					}
				}
			}
			return str;
		}

		__proto.toXMLString=function(){
			var str="";
			for (var i=0;i < this.length;i++){
				str+=this[i].toXMLString();
			}
			return str;
		}

		__proto.parent=function(){
			return this._parentNode;
		}

		__proto.copy=function(){
			var list=new XMLElementList(this.toXMLString());
			return list;
		}

		__proto.getString=function(){
			var str="";
			str=this.toXMLString();
			return str;
		}

		__proto.comments=function(){
			return null;
		}

		__proto.contains=function(value){
			return true;
		}

		__getset(0,__proto,'localName',function(){
			return null
			},function(str){
			if (this.length==1){
				this[0]._nodeName=str;
			}
		});

		__getset(0,__proto,'nodeType',function(){
			return "*";
		});

		__getset(0,__proto,'value',function(){
			if (this.length==1){
				return this[0]._nodeValue;
			}
			return "";
			},function(str){
			if (this.length==1){
				this[0]._nodeValue=str;
			}
		});

		__getset(0,__proto,'childNodes',function(){
			return null;
		});

		__getset(0,__proto,'nodeName',function(){
			return null;
		});

		__uns(__proto,['childIndex','getAttributes','attributes','getAttribute','attribute','setAttribute','getChildByName','child','getChildByAttribute','getChildAt','children','elements','appendChild','__addChild__','__doAdd__','setName','copyFrom','hasOwnProperty','setChildByName','hasComplexContent','hasSimpleContent','name','lengths','toString','toXMLString','parent','copy','getString','comments','contains']);
		XMLElementList.create=function(arr){
			var xl=new XMLElementList();
			for (var i=0;i < arr.length;i++){
				xl.__addChild__(arr[i]);
			}
			return xl;
		}

		XMLElementList.createFromAttribute=function(arr){
			var xl=new XMLElementList();
			for (var i=0;i < arr.length;i++){
				var xml=new XMLElement();
				var obj=arr[i];
				xml._nodeName=obj.key;
				xml._nodeValue=obj.val;
				xl.push(xml);
			}
			return xl;
		}

		return XMLElementList;
	})(Array)


	var XMLList=window.XMLList=iflash.xml.XMLElementList;
	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/displayobject.as
	//class iflash.display.DisplayObject extends iflash.events.EventDispatcher
	var DisplayObject=(function(_super){
		function DisplayObject(){
			this._parent_=null;
			this._firstDisplayUnit_=null;
			this._left_=0;
			this._top_=0;
			this._width_=0;
			this._height_=0;
			this._blend_=null;
			this._zIndex_=0;
			this._sort_d_=-1;
			this._mouseX_=NaN;
			this._mouseY_=NaN;
			this.__id__=0;
			this._type2_=0;
			this._mask_=null;
			this._readyCallBack=null;
			this._readyCallParam=null;
			this._needNotice=false;
			DisplayObject.__super.call(this);
			this._Filters_=Filters.__DEFAULT__;
			this._transform_=Transform.__DEFAULT__;
			this._concatenatedMatrix=new Matrix();
			this._invertedConcatenatedMatrix=new Matrix();
			this._bounds=new Rectangle();
			this.__initModule();
			this._type_ |=0x400;
			this._propagateFlagsDown_(/*CLASS CONST:iflash.display.DisplayObject.TYPE2_CONCATENATEDMATRIX_CHG*/0x1 | /*CLASS CONST:iflash.display.DisplayObject.TYPE2_BOUNDS_CHG*/0x4);
		}

		__class(DisplayObject,'iflash.display.DisplayObject',false,_super);
		var __proto=DisplayObject.prototype;
		__proto.__initModule=function(){
			if(DisplayObject.initModule){
				this._modle_=Browser._createModle_(2,this._id_,this);this._type_|=0x40;
			}else this._modle_=IModel.__DEFAULT__;
			if(Laya.CONCHVER)this._modle_.vcanvas=function (v){
				v.conchVirtualBitmap=v.conchVirtualBitmap || /*__JS__ */new ConchVirtualBitmap();
				this.conchVirtualBitmap=v.conchVirtualBitmap;
				this.virtualBitmap(v.conchVirtualBitmap);
				if(!v.inMap){ConchRenderVCanvas.maps.push(v);v.inMap=true;}
					}
		}

		__proto._lyPaint_=function(context,x,y){
			this._firstDisplayUnit_ && (this._firstDisplayUnit_.paint(context,x+this._left_ ,y+this._top_ ,this,this._width_,this._height_)|| (this._repaint_=0));
		}

		__proto.conchPaint=function(context,x,y,isfirst){
			(isfirst===void 0)&& (isfirst=false);
			this._paintTransform_(context,x,y,this._width_,this._height_,isfirst);
		}

		__proto._paintTransform_=function(context,x,y,w,h,isfirst){
			if (this._transform_ !=Transform.__DEFAULT__&&!isfirst){
				var m=this._transform_.matrix;
				if (!m || !m.isTransform()){
					this._paintclip_(context,x,y,w,h);
					return;
				}
				context.save();
				x-=this._left_;
				y-=this._top_;
				if (x !=0 || y !=0){
					context.translate(x,y);
					context.transform(m.a,m.b,m.c,m.d,m.tx,m.ty);
					context.translate(-x,-y);
				}
				else {
					context.transform(m.a,m.b,m.c,m.d,m.tx,m.ty);
				}
				this._paintclip_(context,x,y,w,h);
				context.restore();
			}
			else
			this._paintclip_(context,x,y,w,h);
		}

		__proto._paintclip_=function(context,x,y,w,h){
			var node=this;
			if ((this._type_ & 0x2)==0x2){
				if (!node._private_._scrollRect_){
					this._paintGraphics_(context,x,y,w,h);
					return;
				};
				var rect=node._private_._scrollRect_;
				context.save();
				context.beginPath();
				context.rect(x,y,rect.width,rect.height);
				context.clip();
				this._paintChild_(context,x,y,w,h);
				context.restore();
			}
			else{
				this._paintGraphics_(context,x,y,w,h);
			}
		}

		__proto._paintMask_=function(context,x,y,w,h){}
		__proto._paintBackground_=function(context,x,y,w,h){
			var fillStyle="#ff0000";
			context.save();
			context.fillStyle=fillStyle;
			context.fillRect(x,y,w,h);
			context.restore();
		}

		__proto._paintGraphics_=function(context,x,y,w,h){
			this._paintChild_(context,x,y,w,h);
		}

		__proto._paintChild_=LAYAFNVOID/*function(context,x,y,w,h){}*/
		__proto.lySize=function(w,h){
			if (w !=this._width_ || h !=this._height_){
				this._width_=(w>0)?w:-1;
				this._height_=(h>0)?h:-1;
				this._modle_.size(w,h);
				this._propagateFlagsDown_(/*CLASS CONST:iflash.display.DisplayObject.TYPE2_CONCATENATEDMATRIX_CHG*/0x1 | /*CLASS CONST:iflash.display.DisplayObject.TYPE2_BOUNDS_CHG*/0x4);
			}
		}

		__proto._lyPos_=function(x,y){
			if (this._left_ !=x || this._top_ !=y){
				this._left_=x;
				this._top_=y;
				this._modle_.pos(x,y);
				this._type_ |=0x20000;
				this._propagateFlagsDown_(/*CLASS CONST:iflash.display.DisplayObject.TYPE2_CONCATENATEDMATRIX_CHG*/0x1 | /*CLASS CONST:iflash.display.DisplayObject.TYPE2_BOUNDS_CHG*/0x4);
			}
		}

		__proto.localToGlobal=function(localPoint,goalPoint){
			if(!goalPoint)goalPoint=new Point();
			return this._getConcatenatedMatrix().transformPointInPlace(localPoint,goalPoint);
		}

		__proto.globalToLocal=function(globalPoint,goalPoint){
			if(!goalPoint)goalPoint=new Point();
			return this._getInvertedConcatenatedMatrix().transformPointInPlace(globalPoint,goalPoint);
		}

		__proto.hitTestPoint=function(globalX,globalY,shapeFlag){
			(shapeFlag===void 0)&& (shapeFlag=false);
			if (!this.visible)return false;
			DisplayObject.HELPER_POINT_ALT=this.root.localToGlobal(DisplayObject.HELPER_POINT.setTo(globalX,globalY),DisplayObject.HELPER_POINT_ALT);
			if (this.getBounds(Stage.stage).containsPoint(DisplayObject.HELPER_POINT_ALT))return true;
			else return false;
		}

		__proto._hitTest_=function(_x,_y){
			if (!this.visible)return null;
			if (!this._checkHitMask(_x,_y)){return null;}
				if (!this._checkHitScrollRect(_x,_y)){return null;}
			if (this._private_._scrollRect_){_x+=this._private_._scrollRect_.x;_y+=this._private_._scrollRect_.y;}
				if (this._getBounds_(this,DisplayObject.HELPER_RECTANGLET).containsPoint(DisplayObject.HELPER_POINT.setTo(_x,_y))){
				return this;
			}
			else{
				return null;
			}
		}

		__proto._checkHitMask=function(_x,_y){
			if(this._mask_){
				this._mask_.getBounds(Stage.stage,DisplayObject.HELPER_RECTANGLET);
				this._getInvertedConcatenatedMatrix().transformBounds(DisplayObject.HELPER_RECTANGLET);
				return DisplayObject.HELPER_RECTANGLET.containsPoint(DisplayObject.HELPER_POINT.setTo(_x,_y));
			}
			return true;
		}

		__proto._checkHitScrollRect=function(_x,_y){
			if (this._private_._scrollRect_ && this._private_._scrollRect_.width!=0 && this._private_._scrollRect_.height!=0){
				var rect=this._private_._scrollRect_.clone ();
				rect.x=0;
				rect.y=0;
				return rect.containsPoint(DisplayObject.HELPER_POINT.setTo(_x,_y));
			}
			return true;
		}

		__proto.hitTestObject=function(value){
			if (this.visible && this.parent !=null && value !=null && value.parent !=null){
				var currentBounds=this.getBounds(Stage.stage);
				var targetBounds=value.getBounds(Stage.stage);
				return currentBounds.intersects(targetBounds);
			}
			return false;
		}

		__proto.getRect=function(value){
			return this.getBounds(value);
		}

		__proto._getBounds_=function(targetSpace,resultRect){
			if(!resultRect)
				resultRect=DisplayObject.HELPER_RECTANGLET;
			DisplayObject.HELPER_POINT.identity();
			return resultRect.setTo(0,0,this._width_,this._height_);
		}

		__proto.getBounds=function(targetSpace,resultRect){
			if ((targetSpace==Stage.stage)&& (this._type2_ & 0x4)==0){
				if(resultRect){
					resultRect.copyFrom(this._bounds);
					return resultRect
				}
				else{return this._bounds};
			};
			if (resultRect==null)resultRect=new Rectangle();
			this._getBounds_(targetSpace,resultRect);
			if(targetSpace!=this){
				if (targetSpace==this._parent_){
					DisplayObject.HELPER_MATRIX.copy(this.matrix);
					}else{
					Matrix.mul(DisplayObject.HELPER_MATRIX,targetSpace._getInvertedConcatenatedMatrix(),this._getConcatenatedMatrix());
				}
				DisplayObject.HELPER_MATRIX.transformBounds(resultRect);
			}
			if (targetSpace==Stage.stage){
				this._bounds.copyFrom(resultRect);
				this._type2_ &=~0x4;
			}
			return resultRect;
		}

		__proto.getTransformMatrix=function(targetSpace,resultMatrix){
			var commonParent;
			var currentObject;
			if (resultMatrix)resultMatrix.identity();
			else resultMatrix=new Matrix();
			if (targetSpace==this){
				return resultMatrix;
			}
			else if (targetSpace==this.parent || (targetSpace==null && this.parent==null)){
				resultMatrix.copy(this.matrix);
				return resultMatrix;
			}
			else if (targetSpace==null || targetSpace==this._root_){
				resultMatrix.copyFrom(this._getConcatenatedMatrix());
				return resultMatrix;
			}
			else if (targetSpace.parent==this){
				targetSpace.getTransformMatrix(this,resultMatrix);
				resultMatrix.invert();
				return resultMatrix;
			}
			Matrix.mul(resultMatrix,targetSpace._getInvertedConcatenatedMatrix(),this._getConcatenatedMatrix());
			return resultMatrix;
		}

		__proto._getConcatenatedMatrix=function(CalculateInvertedmt){
			(CalculateInvertedmt===void 0)&& (CalculateInvertedmt=true);
			if (this._type2_ & 0x1){
				if(this._parent_){
					this._parent_._getConcatenatedMatrix().preMultiplyInto(this.matrix,this._concatenatedMatrix);
				}
				else {return this.matrix };
				if (CalculateInvertedmt==true){
					this._invertedConcatenatedMatrix=this._concatenatedMatrix.clone();
					this._invertedConcatenatedMatrix.invert();
				}
				this._type2_ &=~0x1;
			}
			return this._concatenatedMatrix;
		}

		__proto._getInvertedConcatenatedMatrix=function(){
			if ((this._type2_ & 0x1)){
				this._invertedConcatenatedMatrix=this._getConcatenatedMatrix(false).clone();
				this._invertedConcatenatedMatrix.invert();
				this._type2_ &=~0x1;
			}
			return this._invertedConcatenatedMatrix.clone();
		}

		__proto._propagateFlagsDown_=function(flags){
			this._type2_ |=flags;
		}

		__proto.__addFrameTimer__=function(fn){
			return Stage.stage._tmctr_.addFrameTimer(fn,this);
		}

		__proto.__updatamask__=function(){
			this._mask_.getBounds(Stage.stage,DisplayObject.HELPER_RECTANGLET);
			this._getInvertedConcatenatedMatrix().transformBounds(DisplayObject.HELPER_RECTANGLET);
			var rect=DisplayObject.HELPER_RECTANGLET;
			if(rect.x!=this._private_.mask.x||rect.y!=this._private_.mask.y||rect.width!=this._private_.mask.width||rect.height!=this._private_.mask.height)
				this._private_.mask.setRect(rect.x,rect.y,rect.width,rect.height);
		}

		__proto._addCMask=function(){
			var isRemove=true;
			if (this._private_.mask){
				for (var i=0,n=DisplayObject.ConMasks.length;i < n;i++){
					if (this==DisplayObject.ConMasks[i]){
						isRemove=false;
					}
				}
				if(isRemove)DisplayObject.ConMasks.push(this);
			}
		}

		__proto._lyToBody_=function(){
			this._addCMask();
			this.dispatchEvent(new Event(/*iflash.events.Event.ADDED_TO_STAGE*/"addedToStage"));
		}

		__proto._dispatchAddedEvent=function(target){
			var event=new Event(/*iflash.events.Event.ADDED*/"added");
			event._lytarget=target;
			event.bubbles=true;
			this.dispatchEvent(event);
		}

		__proto._removeCMask=function(){
			if (this._private_.mask){
				for (var i=0,n=DisplayObject.ConMasks.length;i < n;i++){
					if (this==DisplayObject.ConMasks[i]){
						DisplayObject.ConMasks.splice(i,1);
						break ;
					}
				}
			}
		}

		__proto._lyUnToBody_=function(){
			this._removeCMask();
			this.dispatchEvent(new Event(/*iflash.events.Event.REMOVED_FROM_STAGE*/"removedFromStage"));
		}

		__proto.removeFromBody=function(){
			this._parent_=null;
		}

		__proto._dispatchRemovedEvent=function(){
			this.dispatchEvent(new Event(/*iflash.events.Event.REMOVED*/"removed",true));
		}

		__proto.__dispatchEnterFrame__=function(e){
			e._currentTarget_=this;
			e._lytarget=this;
			this.dispatchEvent(e);
		}

		__proto.lyclone=LAYAFNVOID/*function(){}*/
		__proto.setReadyForDrawCall=function(_readyCall,param){
			this._readyCallParam=param;
			this._readyCallBack=_readyCall;
			if(this.isReadyForDraw){
				this.readyDrawCallBack();
				}else{
				this.setupReadyNoticeWork();
			}
		}

		__proto.readyDrawCallBack=function(){
			if(this._readyCallBack!=null){
				this._readyCallBack.apply(this,this._readyCallParam);
				this._readyCallBack=null;
				this._readyCallParam=null;
			}
		}

		__proto.setupReadyNoticeWork=function(ifSelfNotice){
			(ifSelfNotice===void 0)&& (ifSelfNotice=false);
			if(this.isReadyForDraw)return;
			this._needNotice=ifSelfNotice;
		}

		__proto.readyWork=function(){
			if(this._readyCallBack!=null){
				this.readyDrawCallBack();
			}
			this.noticeReadyToParent();
		}

		__proto.noticeReadyToParent=function(){
			if(!this._needNotice)return;
			if(this._parent_){
				this._parent_.oneChildReady();
			}
			this._needNotice=false;
		}

		__proto.layaDestory=function(){
			this._modle_ && this._modle_.destroy();
			this._concatenatedMatrix=null;
			this._invertedConcatenatedMatrix=null;
			this._bounds=null;
			this._modle_=null;
		}

		__getset(0,__proto,'_owidth_',function(){
			return this._width_/this.scaleX;
		});

		__getset(0,__proto,'name',function(){
			return this._private_._name_||(this._private_._name_="instance"+this._id_);
			},function(_name){
			this._private_._name_=_name;
		});

		__getset(0,__proto,'parent',function(){
			return this._parent_;
		});

		__getset(0,__proto,'_oheight_',function(){
			return this._height_/this.scaleY;
		});

		__getset(0,__proto,'y',function(){
			return this._top_;
			},function(value){
			this._lyPos_(this._left_,value);
		});

		__getset(0,__proto,'__onmask__',null,function(fn){
			if(this._private_.onmask)(this._private_.onmask.deleted=true);
			this._private_.onmask=this.__addFrameTimer__(fn);
		});

		__getset(0,__proto,'height',function(){
			return this.matrix.transformBounds(this._getBounds_(this)).height;
			},function(h){
			if(this._height_==h)
				return;
			this.scaleY=1.0;
			var oldH=this.height;
			oldH &&(this.scaleY=h / oldH);
			(this._height_ !=h)&& this.lySize(this._width_,h);
		});

		__getset(0,__proto,'skewX',function(){
			return this._transform_._skew_.x;
			},function(value){
			if (this._transform_==Transform.__DEFAULT__){
				if (value==0)return;
				this._transform_=new Transform()._setNode_(this);
			}
			this._transform_._setSkewX_(value);
		});

		__getset(0,__proto,'width',function(){
			return this.matrix.transformBounds(this._getBounds_(this)).width;
			},function(w){
			if(this._width_==w)
				return;
			this.scaleX=1.0;
			var oldW=this.width;
			oldW &&(this.scaleX=w / oldW);
			(this._width_ !=w)&& this.lySize(w,this._height_);
		});

		__getset(0,__proto,'blendMode',function(){return this._blend_},function(value){
			switch(value){
				case "add":
					value="lighter";
					break ;
				default :
					this._modle_.globalCompositeOperation(1);
					value=null;
					return;
					break ;
				}
			if(this._blend_==value)return;
			this._blend_=value;
			this._modle_.globalCompositeOperation(2);
			((this._type_ & 0x10000)==0)&& (DrawBlend.insertUnit(this),this._type_ |=0x10000);
		});

		__getset(0,__proto,'skewY',function(){
			return this._transform_._skew_.y;
			},function(value){
			if (this._transform_==Transform.__DEFAULT__){
				if (value==0)return;
				this._transform_=new Transform()._setNode_(this);
			}
			this._transform_._setSkewY_(value);
		});

		__getset(0,__proto,'rotation',function(){
			return this._transform_._rotate_;
			},function(value){
			if (this._transform_==Transform.__DEFAULT__){
				if (value==0)return;
				this._transform_=new Transform()._setNode_(this);
			}
			this._transform_._setRotation_(value);
		});

		__getset(0,__proto,'scaleY',function(){
			return this._transform_._scale_.y;
			},function(value){
			if (this._transform_==Transform.__DEFAULT__){
				if (value==1)return;
				this._transform_=new Transform()._setNode_(this);
			}
			this._transform_._setScaleY_(value);
		});

		__getset(0,__proto,'rotationX',LAYAFN0/*function(){return 0}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'transform',function(){
			return this._transform_==Transform.__DEFAULT__?(this._transform_=new Transform()._setNode_(this)):this._transform_;
			},function(value){
			(this._transform_=value)._setNode_(this);
		});

		__getset(0,__proto,'rotationY',LAYAFN0/*function(){return 0}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'rotationZ',function(){
			return this.rotation;
			},function(value){
			this.rotation=value;
		});

		__getset(0,__proto,'scaleX',function(){
			return this._transform_._scale_.x;
			},function(value){
			if (this._transform_==Transform.__DEFAULT__){
				if (value==1)return;
				this._transform_=new Transform()._setNode_(this);
			}
			this._transform_._setScaleX_(value);
		});

		__getset(0,__proto,'scaleZ',LAYAFN0/*function(){return 0}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'matrix',function(){
			return this._transform_!=Transform.__DEFAULT__?this._transform_.matrix:((this._transform_=new Transform())._setNode_(this)).matrix;
			},function(value){
			if (this._transform_==Transform.__DEFAULT__){
				if (!value.isTransform()){
					this._lyPos_(value.tx,value.ty);
					return;
				}
				this._transform_=new Transform()._setNode_(this);
			}
			this._transform_.matrix=value;
		});

		__getset(0,__proto,'visible',function(){
			return (this._type_&0x400)!=0;
			},function(value){
			if(value)
				this._type_|=0x400;
			else
			this._type_ &=~0x400;
			this._modle_.show(value);
		});

		__getset(0,__proto,'x',function(){
			return this._left_;
			},function(value){
			this._lyPos_(value,this._top_);
		});

		__getset(0,__proto,'z',LAYAFN0/*function(){return 0}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'alpha',function(){
			return this._Filters_._alpha_;
			},function(value){
			if(this._Filters_._alpha_ !=value){
				this._Filters_ !=Filters.__DEFAULT__?(this._Filters_.alpha(this,value)):(this._Filters_=new Filters).alpha(this,value);
			}
		});

		__getset(0,__proto,'mouseX',function(){
			DisplayObject.HELPER_POINT.setTo(Laya.document.mouseX,Laya.document.mouseY);
			this.globalToLocal(DisplayObject.HELPER_POINT,DisplayObject.HELPER_POINT_ALT);
			return DisplayObject.HELPER_POINT_ALT.x;
		});

		__getset(0,__proto,'mouseY',function(){
			DisplayObject.HELPER_POINT.setTo(Laya.document.mouseX,Laya.document.mouseY);
			this.globalToLocal(DisplayObject.HELPER_POINT,DisplayObject.HELPER_POINT_ALT);
			return DisplayObject.HELPER_POINT_ALT.y;
		});

		__getset(0,__proto,'loaderInfo',function(){
			return LoaderInfo.getLoaderInfo(this.__id__);
		});

		__getset(0,__proto,'_root_',function(){
			var currentObject=this;
			while (currentObject&&currentObject.parent)currentObject=currentObject.parent;
			return currentObject;
		});

		__getset(0,__proto,'root',function(){
			var currentObject=this;
			while (currentObject&&currentObject.parent&&currentObject.parent!=Stage.stage)currentObject=currentObject.parent;
			return currentObject;
		});

		__getset(0,__proto,'stage',function(){
			if(this._root_==Stage.stage)return Stage.stage;
			return null;
		});

		__getset(0,__proto,'scrollRect',function(){
			return this._private_._scrollRect_
			},function(value){
			if(!value){
				this._private_._scrollRect_=null;
				this._modle_.clip(false);
				this._modle_.scroll(0,0);
				return;
			}
			this._private_._scrollRect_=this._private_._scrollRect_|| new Rectangle();
			this._private_._scrollRect_.setTo(value.x,value.y,value.width,value.height);
			((this._type_ & 0x2)==0)&& (DrawClip.insertUnit(this),this._type_ |=0x2);
			if (Laya.CONCHVER){
				this._modle_.clip(true);
				this._modle_.scroll(-value.x,-value.y);
				this._modle_.size(value.width,value.height);
			}
		});

		__getset(0,__proto,'scale9Grid',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'filters',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(param1){}*/);
		__getset(0,__proto,'mask',function(){
			return this._mask_;
			},function(value){
			if(!value){
				if (this._mask_){
					this._mask_.visible=true;this._mask_=null;this._type_ &=~0x8000;
					this._removeCMask();
					this._private_.mask=null;
					this._modle_.mask(null);
				}
				return;
			};
			var _isChild_=false;
			var temp=value.parent;
			while(temp){
				if(this==temp){
					_isChild_=true;
					break ;
				}
				temp=temp.parent;
			}
			this._mask_=value;this._mask_.visible=false;
			if(_isChild_){
				((this._type_ & 0x8000)==0)&& (DrawMaskC.insertUnit(this));
				((this._type_ & 0x8000)==0)&& (this._type_ |=0x8000)
			}
			else{
				((this._type_ & 0x8000)==0)&& (DrawMask.insertUnit(this));
				((this._type_ & 0x8000)==0)&& (this._type_ |=0x8000);
			}
			if (Laya.CONCHVER){
				var mask=this._private_.mask|| new Browser.window._ConchMask();
				mask.setType(1);
				this._modle_.mask(mask);
				if(!this._private_.mask)DisplayObject.ConMasks.push(this);
				this._private_.mask=mask;
			}
		});

		__getset(0,__proto,'_to_sort_d',function(){
			return this._sort_d_=this.zIndex / 100000;
		});

		__getset(0,__proto,'zIndex',function(){
			return this._zIndex_;
			},function(value){
			this._zIndex_=value;
			this._modle_.zIndex(value);
		});

		__getset(0,__proto,'cacheAsBitmap',LAYAFNFALSE/*function(){return false}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'isReadyForDraw',function(){
			return true;
		});

		DisplayObject.sendMask=function(){
			for (var i=0,n=DisplayObject.ConMasks.length;i < n;i++){
				DisplayObject.ConMasks[i].__updatamask__();
			}
		}

		DisplayObject.ConMasks=[];
		DisplayObject.TYPE_IFLASH=0x400000;
		DisplayObject.TYPE2_DRAW_MASK=0;
		DisplayObject.TYPE2_DRAW_TANSFORM=0x1;
		DisplayObject.TYPE2_DRAW_FILTER=0x2;
		DisplayObject.TYPE2_DRAW_BACKGROUND=0x20;
		DisplayObject.TYPE2_DRAW_CLIP=0x100;
		DisplayObject.TYPE2_DRAW_MASKC=0x200;
		DisplayObject.TYPE2_DRAW_CHILDS=0x800;
		DisplayObject.TYPE2DEFAULT=0;
		DisplayObject.TYPE_CLIP=0x2;
		DisplayObject.TYPE_DRAWSHAP=0x4;
		DisplayObject.TYPE_DRAWCHILD=0x8;
		DisplayObject.TYPE_CREATE_FROM_TAG=0x10;
		DisplayObject.TYPE_MOUSE_CHILDREN=0x20;
		DisplayObject.TYPE_MOUSE_ENABLE=0x40;
		DisplayObject.TYPE_USEHANDCURSOR=0x80;
		DisplayObject.TYPE_MOUSE_DBCLICK_ENABLE=0x100;
		DisplayObject.TYPE_IS_RECT_CHANGE=0x200;
		DisplayObject.TYPE_IS_VISIBLE=0x400;
		DisplayObject.TYPE_IS_LOAD=0x800;
		DisplayObject.TYPE_DRAW_BIMAP_DATA=0x1000;
		DisplayObject.TYPE_DRAW_IMAGEELEMENT=0x2000;
		DisplayObject.TYPE_CHILDREN_SORT=0x4000;
		DisplayObject.TYPE_MASK=0x8000;
		DisplayObject.TYPE_BLEND=0x10000;
		DisplayObject.TYPE_MATRIX_CHG=0x20000;
		DisplayObject.TYPE2_CONCATENATEDMATRIX_CHG=0x1;
		DisplayObject.TYPE2_BOUNDS_CHG=0x4;
		DisplayObject.TYPE2_RECT_CHG=0x2;
		DisplayObject.initModule=true;
		__static(DisplayObject,
		['HELPER_MATRIX',function(){return this.HELPER_MATRIX=new Matrix();},'HELPER_MATRIX_ALT',function(){return this.HELPER_MATRIX_ALT=new Matrix();},'HELPER_POINT',function(){return this.HELPER_POINT=new Point();},'HELPER_POINT_ALT',function(){return this.HELPER_POINT_ALT=new Point();},'HELPER_RECTANGLET',function(){return this.HELPER_RECTANGLET=new Rectangle();},'HELPER_RECTANGLET_ALT',function(){return this.HELPER_RECTANGLET_ALT=new Rectangle();}
		]);
		return DisplayObject;
	})(EventDispatcher)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/loaderinfo.as
	//class iflash.display.LoaderInfo extends iflash.events.EventDispatcher
	var LoaderInfo=(function(_super){
		function LoaderInfo(){
			this._actionScriptVersion_=1;
			this._sameDomain_=false;
			this._contentType="";
			this._applicationDomain=null;
			this._bytes=null;
			this._bytesLoaded=0;
			this._bytesTotal=0;
			this._childAllowsParent=false;
			this.__content__=null;
			this._frameRate=0;
			this._height=0;
			this._isURLInaccessible=false;
			this._loader=null;
			this._loaderURL=null;
			this._lyurl="";
			this._parameters=null;
			this._parentAllowsChild=false;
			this._swfVersion=0;
			this._width=0;
			this.objInfo=null;
			this._resourceDic_=null;
			this._reDomain_=null;
			this.__id__=0;
			this.__imageUrl__="";
			this.__fileurl="";
			this._nextid_=0;
			this.onload=null;
			this.onerror=null;
			this._uncaughtErrorEvents=null;
			this.temp=[];
			this.config=null;
			this.argData=null;
			this.pr=0
			this.countAsset=0;
			LoaderInfo.__super.call(this);
			this._resourceDic_=[];this.objInfo=[];
			this._applicationDomain=new ApplicationDomain();
			this._applicationDomain._parentDomain_=ApplicationDomain.currentDomain;
		}

		__class(LoaderInfo,'iflash.display.LoaderInfo',false,_super);
		var __proto=LoaderInfo.prototype;
		__proto.deleteResourceDic=function(){
			this._resourceDic_=null;
		}

		__proto.deleteLoader=function(){
			for(var key in LoaderInfo._loaderInfos_){
				delete LoaderInfo._loaderInfos_[key];
			}
			LoaderInfo._loaderInfos_=null;
		}

		__proto.pushSymbolClass=function(_name,tag){
			this._resourceDic_[_name]=tag;
		}

		__proto.pushResource=function(r,_name){
			this._resourceDic_[_name]=r;
		}

		__proto.getResource=function(_name){return this._resourceDic_[_name];}
		__proto.cloneByName=function(_name){
			var dec=this.getResource(_name).data.clone();
			return dec;
		}

		__proto.getBitmapData=function(_name,rect,rectSmall,format){
			var img=new LyImageElement();
			return img;
		}

		__proto.onUrlLoaderComplete=function(event){
			var source=event.target.data;
			source.position=0;
			var temp=new ByteArray();
			source.readUTF();
			source.readUTF();
			source.readBytes(temp,0,0);
			this.setByteArray(temp);
			source=null;
			temp=null;
			(event.target).removeEventListener(/*iflash.events.Event.COMPLETE*/"complete",__bind(this,this.onUrlLoaderComplete));
			(event.target).removeEventListener(/*iflash.events.IOErrorEvent.IO_ERROR*/"ioError",__bind(this,this.onUrlError));
		}

		__proto.onUrlError=function(event){
			Log.log(event.toString());
		}

		__proto.setUrl=function(url){
			this.lyurl=url=Method.formatUrl(url);
			if(this.lyurl.lastIndexOf(".swf")!=-1){
				this.__imageUrl__=this.lyurl.substr(0,this.lyurl.lastIndexOf(".swf"))+"/image/"
				}else{
				this.__imageUrl__=this.lyurl+"/image/";
			}
		}

		__proto.saveObjInfo=function(characterId,data){
			if(characterId)
			{this.objInfo[characterId]=data;}
		}

		__proto.getObjInfo=function(characterId){
			if(characterId)
			{return this.objInfo[characterId]
			}else return null;
		}

		__proto._getEvents_=function(obj){
			this._eventListener_=obj._eventListener_;
		}

		__proto._comp_=LAYAFNVOID/*function(){}*/
		__proto.readversion=function(data){
			var version="";
			version+=data.readByte().toString();
			version+=data.readByte().toString();
			version+=data.readByte().toString();
			version+=data.readByte().toString();
			return version;
		}

		__proto.setByteArray=function(data){
			var version=this.readversion(data);
			if(version>"0001"){
				var obj=data.readObject();
				this.config=obj["assets"];
				this.argData=obj['tagInfo'];
			};
			var runner=new Runnner();
			runner.compile(data,this);
			runner.getSysbomData(this);
			this.complete();
			runner.deleteLoaderInfo()
		}

		__proto.complete=function(){
			this.putResInDomain();
			Runnner.symbolClass.length=0;
			if(this.argData){
				for(var ip in this.argData){
					for(var k in this.argData[ip]){
						var obj=this.argData[ip][k];
						var objk=this.getResource(ip);
						objk[k]=obj;
					}
				}
			};
			var mainTime;
			if(this["mainClass"]){
				var main=iflash.utils.getDefinitionByName(this["mainClass"]);
				if(main){
					mainTime=new main();
					}else{
					var mainTime=this.getResource("32767");mainTime=mainTime.lyclone();
					mainTime&&mainTime.gotoAndStop(1);
				}
				}else{
				var mainTime=this.getResource("32767");mainTime=mainTime.lyclone();
				mainTime&&mainTime.gotoAndStop(1);
			}
			this.__content__=mainTime;
			if(!this.__fileurl){
				for(var i=0;i<Loader.preSwf.length;i++){
					if((this._lyurl+".swf").lastIndexOf(Loader.preSwf[i])!=-1){
						if(this.temp.length){
							this.checkHandler();
						}
						return;
					}
				}
			}
			if(Loader.preSwf.indexOf(this.__fileurl)!=-1){
				if(this.temp.length){
					this.checkHandler();
					}else{
					iflash.utils.setTimeout(__bind(this,this.__finish),0.001);
				}
				}else{
				iflash.utils.setTimeout(__bind(this,this.__finish),0.001);
			}
		}

		__proto.checkHandler=function(){
			var ly;
			for(var i=0;i<this.temp.length;i++){
				ly=this.temp[i];
				ly.checkImg();
				ly._image_.onload=iflash.method.bind(this,this.onPreComplete);
				ly._image_.onerror=iflash.method.bind(this,this.onPreComplete);
				ly._image_.src=ly.src;
			}
		}

		__proto.onPreComplete=function(e){
			this.pr++;
			if(this.pr>=this.temp.length){
				iflash.utils.setTimeout(__bind(this,this.__finish),0.001);
				this.temp.length=0;
			}
		}

		__proto.__finish=function(){
			this.temp.length=0;
			if(this.config&&this.config['textureList']&&this.config['textureList'].length){
				this.countAsset=this.config['textureList'].length;
				var ly=Browser.document.createElement("image");
				ly.onload=iflash.method.bind(this,this.onLoadHandler);
				var tUrl=this.__imageUrl__+"a"+this.countAsset+".png";
				ly.src=tUrl;
				TextureManager.getInstance().addTexture(tUrl,ly);
				}else{
				this.onload && this.onload();
			}
		}

		__proto.onLoadHandler=function(){
			this.countAsset--;
			if(this.countAsset){
				var ly=Browser.document.createElement("image");
				ly.onload=iflash.method.bind(this,this.onLoadHandler);
				var tUrl=this.__imageUrl__+"a"+this.countAsset+".png";
				ly.src=tUrl;
				TextureManager.getInstance().addTexture(tUrl,ly);
				}else{
				this.onload && this.onload();
			}
		}

		__proto.putResInDomain=function(){
			if(this._reDomain_){
				for(var key in this.applicationDomain._resMapDic_){
					this._reDomain_.addResToMap(key,this.applicationDomain._resMapDic_[key]);
				}
			}
		}

		__getset(0,__proto,'actionScriptVersion',function(){
			return this._actionScriptVersion_;
			},function(value){
			this._actionScriptVersion_=value;
		});

		__getset(0,__proto,'bytesLoaded',function(){
			return this._bytesLoaded;
			},function(value){
			this._bytesLoaded=value;
		});

		__getset(0,__proto,'width',function(){
			return this._width;
			},function(value){
			this._width=value;
		});

		__getset(0,__proto,'applicationDomain',function(){
			if(!this.__id__)return ApplicationDomain.currentDomain;
			return this._applicationDomain;
		});

		__getset(0,__proto,'bytes',function(){
			return this._bytes;
			},function(value){
			this._bytes=value
		});

		__getset(0,__proto,'content',function(){
			return this.__content__;
		});

		__getset(0,__proto,'bytesTotal',function(){
			return this._bytesTotal;
			},function(value){
			this._bytesTotal=value;
		});

		__getset(0,__proto,'childAllowsParent',function(){
			return this._childAllowsParent;
			},function(value){
			this._childAllowsParent=value;
		});

		__getset(0,__proto,'contentType',function(){
			return this._contentType;
		});

		__getset(0,__proto,'frameRate',function(){
			return this._frameRate;
			},function(value){
			this._frameRate=value;
		});

		__getset(0,__proto,'height',function(){
			return this._height;
			},function(value){
			this._height=value;
		});

		__getset(0,__proto,'isURLInaccessible',function(){
			return this._isURLInaccessible;
			},function(value){
			this._isURLInaccessible=value;
		});

		__getset(0,__proto,'loader',function(){
			if(this._loader==null){
				this._loader=new Loader();
			}
			return this._loader;
			},function(value){
			this._loader=value;
		});

		__getset(0,__proto,'sharedEvents',LAYAFNNULL/*function(){return null}*/);
		__getset(0,__proto,'loaderURL',function(){
			return this._loaderURL;
			},function(value){
			this._loaderURL=value;
		});

		__getset(0,__proto,'parameters',function(){
			return this._parameters;
			},function(value){
			this._parameters=value;
		});

		__getset(0,__proto,'parentAllowsChild',function(){
			return this._parentAllowsChild;
			},function(value){
			this._parentAllowsChild=value;
		});

		__getset(0,__proto,'sameDomain',function(){
			return this._sameDomain_;
		});

		__getset(0,__proto,'swfVersion',function(){
			return this._swfVersion;
			},function(value){
			this._swfVersion=value;
		});

		__getset(0,__proto,'lyurl',function(){
			return this._lyurl;
			},function(value){
			this._lyurl=value;
		});

		__getset(0,__proto,'url',function(){
			return this.lyurl;
		});

		__getset(0,__proto,'src',function(){
			return this.lyurl;
			},function(url){
			this.lyurl=url=Method.formatUrl(url,Laya.document.baseURI.path);
			if(this.lyurl.lastIndexOf(".swf")!=-1){
				this.__imageUrl__=this.lyurl.substr(0,this.lyurl.lastIndexOf(".swf"))+"/image/"
			};
			var _urlLoad=new URLLoader();
			_urlLoad.dataFormat=/*iflash.net.URLLoaderDataFormat.BINARY*/"binary";
			_urlLoad.addEventListener(/*iflash.events.Event.COMPLETE*/"complete",__bind(this,this.onUrlLoaderComplete));
			_urlLoad.addEventListener(/*iflash.events.IOErrorEvent.IO_ERROR*/"ioError",__bind(this,this.onUrlError));
			_urlLoad.load(new URLRequest(url));
		});

		__getset(0,__proto,'uncaughtErrorEvents',function(){
			return this._uncaughtErrorEvents=this._uncaughtErrorEvents|| new UncaughtErrorEvents();
		});

		__getset(1,LoaderInfo,'currentLoadInfo',function(){
			if(!LoaderInfo.__currentLoaderInfo__)
				LoaderInfo.__currentLoaderInfo__=new LoaderInfo();
			return LoaderInfo.__currentLoaderInfo__;
		},iflash.events.EventDispatcher._$SET_currentLoadInfo);

		LoaderInfo.getLoaderInfoByDefinition=function(object){
			return object;
		}

		LoaderInfo.create=function(id){
			var li=new LoaderInfo();li.__id__=id;
			li.applicationDomain.__id__=id;
			return LoaderInfo._loaderInfos_[id]=li;
		}

		LoaderInfo.getLoaderInfo=function(id){
			if(id==0)return LoaderInfo.currentLoadInfo;
			return LoaderInfo._loaderInfos_[id];
		}

		LoaderInfo.__currentLoaderInfo__=null
		LoaderInfo._loaderInfos_={};
		LoaderInfo.minibitmapData=null;
		LoaderInfo.TextureSign="a";
		return LoaderInfo;
	})(EventDispatcher)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/nativemenu.as
	//class iflash.display.NativeMenu extends iflash.events.EventDispatcher
	var NativeMenu=(function(_super){
		function NativeMenu(){
			NativeMenu.__super.call(this);
		}

		__class(NativeMenu,'iflash.display.NativeMenu',false,_super);
		return NativeMenu;
	})(EventDispatcher)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/nativemenuitem.as
	//class iflash.display.NativeMenuItem extends iflash.events.EventDispatcher
	var NativeMenuItem=(function(_super){
		function NativeMenuItem(){
			NativeMenuItem.__super.call(this);
		}

		__class(NativeMenuItem,'iflash.display.NativeMenuItem',false,_super);
		var __proto=NativeMenuItem.prototype;
		__getset(0,__proto,'enabled',LAYAFNFALSE/*function(){return false}*/,LAYAFNVOID/*function(isSeparator){}*/);
		return NativeMenuItem;
	})(EventDispatcher)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/stage3d.as
	//class iflash.display.Stage3D extends iflash.events.EventDispatcher
	var Stage3D=(function(_super){
		function Stage3D(){
			this.context3D=null;
			this._x=0;
			this._y=0;
			this._visible=true;
			Stage3D.__super.call(this);
		}

		__class(Stage3D,'iflash.display.Stage3D',false,_super);
		var __proto=Stage3D.prototype;
		__proto.requestContext3D=function(context3DRenderMode,profile){
			(context3DRenderMode===void 0)&& (context3DRenderMode="auto");
			(profile===void 0)&& (profile="baseline");
			iflash.utils.setTimeout(__bind(this,this.onCreateContext),1000)
				}
		__proto.onCreateContext=function(evt){
			this.context3D=new Context3D();
			this.context3D.webglContext=Laya.document.canvas3D.context3D;
			var event=new iflash.events.Event(/*iflash.events.Event.CONTEXT3D_CREATE*/"context3DCreate");
			this.context3D.webglContext.enableErrorChecking=true;
			this.dispatchEvent(event);
		}

		__getset(0,__proto,'visible',function(){
			return this._visible;
			},function(value){
			this._visible=value;
		});

		__getset(0,__proto,'x',function(){
			return this._x;
			},function(value){
			this._x=value;
		});

		__getset(0,__proto,'y',function(){
			return this._y;
			},function(value){
			this._y=value;
		});

		return Stage3D;
	})(EventDispatcher)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/swf/classs/bdbs.as
	//class iflash.display.swf.classs.BDBS extends iflash.display.BitmapData
	var BDBS=(function(_super){
		function BDBS(width,height,transparent,fillColor){
			(width===void 0)&& (width=0);
			(height===void 0)&& (height=0);
			(transparent===void 0)&& (transparent=true);
			(fillColor===void 0)&& (fillColor=4.294967295E9);
			var ly=this["__data__"];
			var bitmapdata=ly.miniBitmapData;
			BDBS.__super.call(this,ly?ly.width:1,ly?ly.height:1,transparent,fillColor);
			if (ly){
				if(!bitmapdata._canvas_)bitmapdata.draw(LoaderInfo.minibitmapData,Matrix.__DEFAULT__,null,null,new Rectangle(0,0,ly.width,ly.height));
				this._canvas_=bitmapdata._canvas_.clone();
				ly._init_();ly._lyToBody_();
				this.width=ly.width;
				this.height=ly.height;
				this._canvas_.size(ly.width,ly.height);
			}
		}

		__class(BDBS,'iflash.display.swf.classs.BDBS',false,_super);
		return BDBS;
	})(BitmapData)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/plug/drawbitmapdata.as
	//class iflash.display.plug.DrawBitmapData extends iflash.display.plug.DisplayUnit
	var DrawBitmapData=(function(_super){
		function DrawBitmapData(){
			DrawBitmapData.__super.call(this);
		}

		__class(DrawBitmapData,'iflash.display.plug.DrawBitmapData',false,_super);
		var __proto=DrawBitmapData.prototype;
		__proto.clone=function(node){
			return new DrawBitmapData();
		}

		__proto.paint=function(context,x,y,node,w,h){
			var bitmapdata=node.bitmapData;
			bitmapdata && bitmapdata.paint && bitmapdata.paint.call(bitmapdata,context,x,y,w,h);
			if (this.next)this.next.paint(context,x,y,node,w,h);
		}

		__getset(0,__proto,'place',function(){
			return /*iflash.display.DisplayObject.TYPE_DRAW_BIMAP_DATA*/0x1000;
		});

		__getset(0,__proto,'id',function(){
			return /*iflash.display.DisplayObject.TYPE_DRAW_BIMAP_DATA*/0x1000;
		});

		DrawBitmapData._DEFAULT_=new DrawBitmapData();
		DrawBitmapData._cache_=[];
		return DrawBitmapData;
	})(DisplayUnit)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/plug/drawblend.as
	//class iflash.display.plug.DrawBlend extends iflash.display.plug.DisplayUnit
	var DrawBlend=(function(_super){
		function DrawBlend(){
			DrawBlend.__super.call(this);
		}

		__class(DrawBlend,'iflash.display.plug.DrawBlend',false,_super);
		var __proto=DrawBlend.prototype;
		__proto.clone=function(node){
			return new DrawBlend();
		}

		__proto.paint=function(context,x,y,node,w,h){
			var value=node._blend_;
			if(value){
				context.save();
				context.globalCompositeOperation=value;
				this.next && this.next.paint(context,x,y,node,w,h);
				context.restore();
			}
			else{
				this.next && this.next.paint(context,x,y,node,w,h);
			}
		}

		__getset(0,__proto,'place',function(){
			return /*iflash.display.DisplayObject.TYPE2_DRAW_TANSFORM*/0x1;
		});

		__getset(0,__proto,'id',function(){
			return /*iflash.display.DisplayObject.TYPE2_DRAW_TANSFORM*/0x1;
		});

		DrawBlend.insertUnit=function(node){
			return DisplayUnit._insertUnit_(node,DrawBlend._DEFAULT_);
		}

		DrawBlend._DEFAULT_=new DrawBlend();
		return DrawBlend;
	})(DisplayUnit)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/plug/drawchilds.as
	//class iflash.display.plug.DrawChilds extends iflash.display.plug.DisplayUnit
	var DrawChilds=(function(_super){
		function DrawChilds(node){
			DrawChilds.__super.call(this);
		}

		__class(DrawChilds,'iflash.display.plug.DrawChilds',false,_super);
		var __proto=DrawChilds.prototype;
		__proto.clone=function(node){
			return new DrawChilds(node);
		}

		__proto.paint=function(context,x,y,node,w,h){
			if(node._type_& /*iflash.display.DisplayObject.TYPE_CREATE_FROM_TAG*/0x10){
				node.sortChildsByZIndex();
			};
			var sz=0,i=0;
			var c,childs;
			if ((sz=(childs=node._childs_).length)> 0){
				for (i=0;i < sz;i++){
					if ((c=childs[i])==null || !(c._type_& /*iflash.display.DisplayObject.TYPE_IS_VISIBLE*/0x400)||!c.alpha)continue ;
					node.updateScaleData(i);
					c._lyPaint_(context,x,y);
				}
			}
			this.next && this.next.paint(context,x,y,node,w,h);
		}

		__getset(0,__proto,'place',function(){
			return /*iflash.display.DisplayObject.TYPE2_DRAW_CHILDS*/0x800;
		});

		__getset(0,__proto,'id',function(){
			return /*iflash.display.DisplayObject.TYPE2_DRAW_CHILDS*/0x800;
		});

		DrawChilds.insertUnit=function(node){
			return DisplayUnit._insertUnit_(node,DrawChilds._DEFAULT_);
		}

		DrawChilds._DEFAULT_=new DrawChilds(null);
		return DrawChilds;
	})(DisplayUnit)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/plug/drawclip.as
	//class iflash.display.plug.DrawClip extends iflash.display.plug.DisplayUnit
	var DrawClip=(function(_super){
		function DrawClip(node){
			DrawClip.__super.call(this);
		}

		__class(DrawClip,'iflash.display.plug.DrawClip',false,_super);
		var __proto=DrawClip.prototype;
		__proto.clone=function(node){
			return new DrawClip(node);
		}

		__proto.paint=function(context,x,y,node,w,h){
			if (!node._private_._scrollRect_){
				this.next && this.next.paint(context,x,y,node,w,h);
				return;
			};
			var rect=node._private_._scrollRect_;
			context.save();
			context.beginPath();
			context.rect(x,y,rect.width,rect.height);
			context.clip();
			this.next && this.next.paint(context,x-rect.x,y-rect.y,node,w,h);
			context.restore();
		}

		__getset(0,__proto,'place',function(){
			return /*iflash.display.DisplayObject.TYPE2_DRAW_CLIP*/0x100;
		});

		__getset(0,__proto,'id',function(){
			return /*iflash.display.DisplayObject.TYPE2_DRAW_CLIP*/0x100;
		});

		DrawClip.insertUnit=function(node){
			return DisplayUnit._insertUnit_(node,DrawClip._DEFAULT_);
		}

		DrawClip._DEFAULT_=new DrawClip(null);
		return DrawClip;
	})(DisplayUnit)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/plug/drawgraphics.as
	//class iflash.display.plug.DrawGraphics extends iflash.display.plug.DisplayUnit
	var DrawGraphics=(function(_super){
		function DrawGraphics(){
			DrawGraphics.__super.call(this);
		}

		__class(DrawGraphics,'iflash.display.plug.DrawGraphics',false,_super);
		var __proto=DrawGraphics.prototype;
		__proto.clone=function(node){
			var temp=new DrawGraphics();
			return temp;
		}

		__proto.paint=function(context,x,y,node,w,h){
			var grapics=node["graphics"];
			if(grapics.isReady()){
				grapics._canvas_.paint(context,x,y,node._owidth_,node._oheight_);
			}
			if (this.next)this.next.paint(context,x,y,node,w,h);
		}

		__getset(0,__proto,'place',function(){
			return 0x300;
		});

		__getset(0,__proto,'id',function(){
			return 0x300;
		});

		DrawGraphics.insertUnit=function(node){
			return DisplayUnit._insertUnit_(node,DrawGraphics._DEFAULT_);
		}

		DrawGraphics._DEFAULT_=new DrawGraphics();
		return DrawGraphics;
	})(DisplayUnit)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/plug/drawgridimageelement.as
	//class iflash.display.plug.DrawGridImageElement extends iflash.display.plug.DisplayUnit
	var DrawGridImageElement=(function(_super){
		function DrawGridImageElement(imgelement){
			DrawGridImageElement.__super.call(this);
		}

		__class(DrawGridImageElement,'iflash.display.plug.DrawGridImageElement',false,_super);
		var __proto=DrawGridImageElement.prototype;
		__proto.clone=function(node){
			return new DrawImageElement(node);
		}

		__proto.paint=function(context,x,y,node,w,h){
			var bitmapdata=node.miniBitmapData;
			bitmapdata && bitmapdata.paint && bitmapdata.paint.call(bitmapdata,context,x,y,w,h);
			++Laya.document.drawCount;
			this.next && this.next.paint(context,x,y,node,w,h);
		}

		__getset(0,__proto,'place',function(){
			return /*iflash.display.DisplayObject.TYPE2_DRAW_CHILDS*/0x800;
		});

		__getset(0,__proto,'id',function(){
			return /*iflash.display.DisplayObject.TYPE2_DRAW_CHILDS*/0x800;
		});

		DrawGridImageElement.insertUnit=function(node){
			return DisplayUnit._insertUnit_(node,DrawGridImageElement._DEFAULT_);
		}

		__static(DrawGridImageElement,
		['_DEFAULT_',function(){return this._DEFAULT_=new DrawImageElement(null);}
		]);
		return DrawGridImageElement;
	})(DisplayUnit)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/plug/drawimageelement.as
	//class iflash.display.plug.DrawImageElement extends iflash.display.plug.DisplayUnit
	var DrawImageElement=(function(_super){
		function DrawImageElement(imgelement){
			DrawImageElement.__super.call(this);
		}

		__class(DrawImageElement,'iflash.display.plug.DrawImageElement',false,_super);
		var __proto=DrawImageElement.prototype;
		__proto.clone=function(node){
			return new DrawImageElement(node);
		}

		__proto.paint=function(context,x,y,node,w,h){
			w=w<0?0:w;
			h=h<0?0:h;
			var img=node._image_;
			if(node.scale9Data&&node.arrX){
				var arrX=node.arrX;
				var arrY=node.arrY;
				var arrW=node.arrW;
				var arrH=node.arrH;
				var oArrX=node.oArrX;
				var oArrY=node.oArrY;
				var oArrW=node.oArrW;
				var oArrH=node.oArrH;
				for(var i=0;i<3;i++){
					for(var j=0;j<3;j++){
						var u=oArrX[i][j],v=oArrY[i][j],www=oArrW[i][j],hhh=oArrH[i][j],
						xx=arrX[i][j],yy=arrY[i][j],ww=arrW[i][j],hh=arrH[i][j];
						if(www<=0 || hhh<=0 || ww<=0 || hh<=0)continue ;
						if(node.isTexture()){
							var uP=node.assetConfig.x;
							var vP=node.assetConfig.y;
							context.drawImage(node.texture,u+uP,v+vP,www,hhh,xx+x,yy+y,ww,hh);
						}
						else{
							if(img.isReady())context.drawImage(img,u,v,www,hhh,xx+x,yy+y,ww,hh);
						}
					}
				}
			}
			else{
				if(node.isTexture()){
					var tConfig=node.assetConfig;
					context.drawImage(node.texture,tConfig.x,tConfig.y,tConfig.width,tConfig.height,x,y,w,h);
				}
				else
				(img.isReady())&&context.drawImage(img,x,y,w,h);
			}
			++Laya.document.drawCount;
			this.next && this.next.paint(context,x,y,node,w,h);
		}

		__getset(0,__proto,'place',function(){
			return /*iflash.display.DisplayObject.TYPE2_DRAW_CHILDS*/0x800;
		});

		__getset(0,__proto,'id',function(){
			return /*iflash.display.DisplayObject.TYPE2_DRAW_CHILDS*/0x800;
		});

		DrawImageElement.insertUnit=function(node){
			return DisplayUnit._insertUnit_(node,DrawImageElement._DEFAULT_);
		}

		DrawImageElement._DEFAULT_=new DrawImageElement(null);
		return DrawImageElement;
	})(DisplayUnit)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/plug/drawmask.as
	//class iflash.display.plug.DrawMask extends iflash.display.plug.DisplayUnit
	var DrawMask=(function(_super){
		function DrawMask(node){
			DrawMask.__super.call(this);
		}

		__class(DrawMask,'iflash.display.plug.DrawMask',false,_super);
		var __proto=DrawMask.prototype;
		__proto.clone=function(node){
			return new DrawMask(node);
		}

		__proto.paint=function(context,x,y,node,w,h){
			if (!node.parent||!node._mask_){
				this.next && this.next.paint(context,x,y,node,w,h);
				return;
			};
			var m=node._mask_;
			m.getBounds(Stage.stage,DrawMask.HELPER_RECTANGLET);
			node._getInvertedConcatenatedMatrix().transformBounds(DrawMask.HELPER_RECTANGLET);
			context.save();
			context.beginPath();
			context.rect(x+DrawMask.HELPER_RECTANGLET.x,y+DrawMask.HELPER_RECTANGLET.y,DrawMask.HELPER_RECTANGLET.width,DrawMask.HELPER_RECTANGLET.height);
			context.clip();
			this.next && this.next.paint(context,x,y,node,w,h);
			context.restore();
		}

		__getset(0,__proto,'place',function(){
			return /*iflash.display.DisplayObject.TYPE2_DRAW_MASK*/0;
		});

		__getset(0,__proto,'id',function(){
			return /*iflash.display.DisplayObject.TYPE2_DRAW_MASK*/0;
		});

		DrawMask.insertUnit=function(node){
			return DisplayUnit._insertUnit_(node,DrawMask._DEFAULT_);
		}

		DrawMask._DEFAULT_=new DrawMask(null);
		__static(DrawMask,
		['HELPER_RECTANGLET',function(){return this.HELPER_RECTANGLET=new Rectangle();}
		]);
		return DrawMask;
	})(DisplayUnit)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/plug/drawmaskc.as
	//class iflash.display.plug.DrawMaskC extends iflash.display.plug.DisplayUnit
	var DrawMaskC=(function(_super){
		function DrawMaskC(node){
			DrawMaskC.__super.call(this);
		}

		__class(DrawMaskC,'iflash.display.plug.DrawMaskC',false,_super);
		var __proto=DrawMaskC.prototype;
		__proto.clone=function(node){
			return new DrawMaskC(node);
		}

		__proto.paint=function(context,x,y,node,w,h){
			if (!node.parent||!node._mask_){
				this.next && this.next.paint(context,x,y,node,w,h);
				return;
			};
			var m=node._mask_;
			m.getBounds(Stage.stage,DrawMaskC.HELPER_RECTANGLET);
			node._getInvertedConcatenatedMatrix().transformBounds(DrawMaskC.HELPER_RECTANGLET);
			context.save();
			context.beginPath();
			context.rect(x+DrawMaskC.HELPER_RECTANGLET.x,y+DrawMaskC.HELPER_RECTANGLET.y,DrawMaskC.HELPER_RECTANGLET.width,DrawMaskC.HELPER_RECTANGLET.height);
			context.clip();
			this.next && this.next.paint(context,x,y,node,w,h);
			context.restore();
		}

		__getset(0,__proto,'place',function(){
			return /*iflash.display.DisplayObject.TYPE2_DRAW_MASKC*/0x200;
		});

		__getset(0,__proto,'id',function(){
			return /*iflash.display.DisplayObject.TYPE2_DRAW_MASKC*/0x200;
		});

		DrawMaskC.insertUnit=function(node){
			return DisplayUnit._insertUnit_(node,DrawMaskC._DEFAULT_);
		}

		DrawMaskC._DEFAULT_=new DrawMaskC(null);
		__static(DrawMaskC,
		['HELPER_RECTANGLET',function(){return this.HELPER_RECTANGLET=new Rectangle();}
		]);
		return DrawMaskC;
	})(DisplayUnit)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/plug/drawshape.as
	//class iflash.display.plug.DrawShape extends iflash.display.plug.DisplayUnit
	var DrawShape=(function(_super){
		function DrawShape(shape){
			DrawShape.__super.call(this);
		}

		__class(DrawShape,'iflash.display.plug.DrawShape',false,_super);
		var __proto=DrawShape.prototype;
		__proto.clone=function(node){
			return new DrawShape(node);
		}

		__proto.paint=function(context,x,y,node,w,h){
			var data=node._image_;
			data&&(data._lyPaint_(context,x,y));
			this.next && this.next.paint(context,x,y,node,w,h);
		}

		__getset(0,__proto,'place',function(){
			return /*iflash.display.DisplayObject.TYPE2_DRAW_CHILDS*/0x800;
		});

		__getset(0,__proto,'id',function(){
			return /*iflash.display.DisplayObject.TYPE2_DRAW_CHILDS*/0x800;
		});

		DrawShape.insertUnit=function(node){
			return DisplayUnit._insertUnit_(node,DrawShape._DEFAULT_);
		}

		DrawShape._DEFAULT_=new DrawShape(null);
		return DrawShape;
	})(DisplayUnit)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/plug/drawtext.as
	//class iflash.display.plug.DrawText extends iflash.display.plug.DisplayUnit
	var DrawText=(function(_super){
		function DrawText(){
			this.line=null;
			DrawText.__super.call(this);
		}

		__class(DrawText,'iflash.display.plug.DrawText',false,_super);
		var __proto=DrawText.prototype;
		__proto.clone=function(node){
			return new DrawText();
		}

		__proto.paint=function(context,x,y,tf,w,h){
			context.save();
			DrawText.drawBG(context,x,y,tf);
			tf.drawCaret && (DrawText.caret.x < 1+tf.viewport[0]+tf.viewport[2])&& this.drawCaret(context,tf,x,y);
			context.beginPath();
			context.rect(
			x+/*iflash.text.TextField.LEFT_PADDING*/2,
			y,
			tf.viewport[2]-/*iflash.text.TextField.LEFT_PADDING*/2-/*iflash.text.TextField.RIGHT_PADDING*/2,
			tf.viewport[3]);
			context.clip();
			DrawText.printText(tf,context,x,y);
			context.closePath();
			context.restore();
		}

		__proto.drawCaret=function(context,tf,x,y){
			DrawText.caret.count++;
			if (DrawText.caret.count < 25){
				context.strokeStyle=DrawText.caret.color;
				context.lineWidth=1;
				context.beginPath();
				context.moveTo(DrawText.caret.x+x-tf.viewport[0],DrawText.caret.y+y-tf.viewport[1]);
				context.lineTo(DrawText.caret.x+x-tf.viewport[0],DrawText.caret.y+DrawText.caret.height+y-tf.viewport[1]);
				context.stroke();
			}
			else if (DrawText.caret.count > 50)
			DrawText.caret.count=0;
		}

		__getset(0,__proto,'place',function(){
			return /*iflash.display.DisplayObject.TYPE2_DRAW_CHILDS*/0x800;
		});

		__getset(0,__proto,'id',function(){
			return /*iflash.display.DisplayObject.TYPE2_DRAW_CHILDS*/0x800;
		});

		DrawText.insertUnit=function(node){
			return DisplayUnit._insertUnit_(node,DrawText._DEFAULT_);
		}

		DrawText.drawBG=function(context,x,y,tf){
			var w=tf.viewport[2],h=tf.viewport[3];
			if(tf.background){
				context.fillStyle=tf._backgroundColor;
				context.fillRect(x,y,w,h);
			}
			if(tf.border){
				context.strokeStyle=tf._borderColor;
				context.strokeRect(x,y,w,h);
			}
		}

		DrawText.printText=function(tf,context,x,y){
			if(!Driver.enableTouch()&& tf._inputting)
				return;
			var numNodes=tf.nodes.length;
			for (var j=0;j < numNodes;j++){
				var node=tf.nodes.getElem(j);
				context.font=node.font;
				context.textBaseline='top';
				context.fillStyle=node.fillStyle;
				if (node.letterSpacing){
					var len=node.text.length;
					for (var i=0;i < len;i++){
						tf.strokeColor && DrawText.strokeText(
						node.text.charAt(i),
						tf.strokeColor,tf.strokeThickness,context,
						x+node.lettersX[i]-tf.viewport[0],
						node.y+y-tf.viewport[1]);
						context.fillText(
						node.text.charAt(i),
						x+node.lettersX[i]-tf.viewport[0],
						node.y+y-tf.viewport[1]);
					}
				}
				else{
					tf.strokeColor && DrawText.strokeText(node.text,tf.strokeColor,tf.strokeThickness,context,
					node.x+x-tf.viewport[0],
					node.y+y-tf.viewport[1]);
					context.fillText(
					node.text,
					node.x+x-tf.viewport[0],
					node.y+y-tf.viewport[1]);
				}
				if (!Laya.CONCHVER && node.underlineWidth !=0)
					DrawText.drawUnderline(context,node,x,y-tf.viewport[1]);
			}
		}

		DrawText.strokeText=function(text,strokeColor,strokeThickness,context,x,y){
			context.strokeStyle=strokeColor;
			context.lineWidth=strokeThickness;
			context.lineCap="round";
			context.strokeText(text,x,y);
		}

		DrawText.drawUnderline=function(context,node,x,y){
			context.lineWidth=1;
			context.strokeStyle=node.fillStyle;
			context.beginPath();
			context.moveTo(x+node.x,y+node.underlineY);
			context.lineTo(x+node.underlineWidth+node.x,y+node.underlineY);
			context.closePath();
			context.stroke();
		}

		DrawText.drawBullet=function(context,line,tx){}
		DrawText._DEFAULT_=new DrawText();
		DrawText.caret={};
		return DrawText;
	})(DisplayUnit)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/plug/drawtransform.as
	//class iflash.display.plug.DrawTransform extends iflash.display.plug.DisplayUnit
	var DrawTransform=(function(_super){
		function DrawTransform(node){
			DrawTransform.__super.call(this);
		}

		__class(DrawTransform,'iflash.display.plug.DrawTransform',false,_super);
		var __proto=DrawTransform.prototype;
		__proto.clone=function(node){
			return new DrawTransform(node);
		}

		__proto.paint=function(context,x,y,node,w,h){
			var m=node._transform_.matrix;
			if (!m || !m.isTransform()){
				this.next && this.next.paint(context,x,y,node,w,h);
				return;
			}
			context.save();
			x-=node._left_;
			y-=node._top_;
			if (x !=0 || y !=0){
				context.translate(x,y);
				context.transform(m.a,m.b,m.c,m.d,m.tx,m.ty);
				context.translate(-x,-y);
			}
			else {
				context.transform(m.a,m.b,m.c,m.d,m.tx,m.ty);
			}
			this.next && this.next.paint(context,x,y,node,w,h);
			context.restore();
		}

		__getset(0,__proto,'place',function(){
			return /*iflash.display.DisplayObject.TYPE2_DRAW_TANSFORM*/0x1;
		});

		__getset(0,__proto,'id',function(){
			return /*iflash.display.DisplayObject.TYPE2_DRAW_TANSFORM*/0x1;
		});

		DrawTransform.insertUnit=function(node){
			return DisplayUnit._insertUnit_(node,DrawTransform._DEFAULT_);
		}

		DrawTransform._DEFAULT_=new DrawTransform(null);
		return DrawTransform;
	})(DisplayUnit)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/plug/usefilter.as
	//class iflash.display.plug.UseFilter extends iflash.display.plug.DisplayUnit
	var UseFilter=(function(_super){
		function UseFilter(node){
			UseFilter.__super.call(this);
		}

		__class(UseFilter,'iflash.display.plug.UseFilter',false,_super);
		var __proto=UseFilter.prototype;
		__proto.clone=function(node){
			return new UseFilter(node);
		}

		__proto.paint=function(context,x,y,node,w,h){
			var filter=node._Filters_,preFilter;
			var pre=NaN;
			if ((filter._alpha_ < 0.01 && filter.key==0)|| !this.next)return;
			if (filter._alpha_==1){
				this.next.paint(context,x,y,node,w,h);
				return;
			}
			pre=context.globalAlpha;
			context.globalAlpha=filter._alpha_;
			this.next.paint(context,x,y,node,w,h);
			context.globalAlpha=pre;
		}

		__getset(0,__proto,'place',function(){
			return /*iflash.display.DisplayObject.TYPE2_DRAW_FILTER*/0x2;
		});

		__getset(0,__proto,'id',function(){
			return /*iflash.display.DisplayObject.TYPE2_DRAW_FILTER*/0x2;
		});

		UseFilter.insertUnit=function(node){
			return DisplayUnit._insertUnit_(node,UseFilter._DEFAULT_);
		}

		UseFilter._DEFAULT_=new UseFilter(null);
		return UseFilter;
	})(DisplayUnit)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/net/filereference.as
	//class iflash.net.FileReference extends iflash.events.EventDispatcher
	var FileReference=(function(_super){
		function FileReference(){
			FileReference.__super.call(this);
		}

		__class(FileReference,'iflash.net.FileReference',false,_super);
		var __proto=FileReference.prototype;
		__proto.browse=LAYAFNFALSE/*function(typeFilter){return false}*/
		__proto.cancel=LAYAFNVOID/*function(){}*/
		__proto.download=LAYAFNVOID/*function(request,defaultFileName){}*/
		__proto.load=function(){}
		__proto.save=LAYAFNVOID/*function(data,defaultFileName){}*/
		__proto.upload=function(request,uploadDataFieldName,testUpload){
			(uploadDataFieldName===void 0)&& (uploadDataFieldName="Filedata");
			(testUpload===void 0)&& (testUpload=false);
		}

		__getset(0,__proto,'creationDate',LAYAFNNULL/*function(){return null}*/);
		__getset(0,__proto,'name',LAYAFNSTR/*function(){return ""}*/);
		__getset(0,__proto,'size',LAYAFN0/*function(){return 0}*/);
		__getset(0,__proto,'creator',LAYAFNSTR/*function(){return ""}*/);
		__getset(0,__proto,'modificationDate',LAYAFNNULL/*function(){return null}*/);
		__getset(0,__proto,'data',LAYAFNNULL/*function(){return null}*/);
		__getset(0,__proto,'type',LAYAFNSTR/*function(){return ""}*/);
		return FileReference;
	})(EventDispatcher)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/filesystem/filestream.as
	//class iflash.filesystem.FileStream extends iflash.events.EventDispatcher
	var FileStream=(function(_super){
		function FileStream(){
			this._endian=null;
			this._objectEncoding=0;
			this._position=NaN;
			this._readAhead=NaN;
			this.urlLoader=null;
			this.fileBytes=null;
			this.file=null;
			this.fileMode=null;
			FileStream.__super.call(this);
		}

		__class(FileStream,'iflash.filesystem.FileStream',false,_super);
		var __proto=FileStream.prototype;
		__proto.open=function(file,fileMode){
			this.file=file;
			this.fileMode=fileMode;
			if (fileMode==/*iflash.filesystem.FileMode.READ*/"read"){
				if (file._isApplicationStorageDirectory){
					FileStorage.instance.getFile(file.url);
				}
				else if (file._isApplicationDirectory){
				}
				else{
					this.urlLoader=new URLLoader();
					this.urlLoader.dataFormat=/*iflash.net.URLLoaderDataFormat.BINARY*/"binary";
					this.urlLoader.addEventListener(/*iflash.events.Event.COMPLETE*/"complete",__bind(this,this.onLoadComplete));
					this.urlLoader.addEventListener(/*iflash.events.IOErrorEvent.IO_ERROR*/"ioError",__bind(this,this.onIOError));
					this.urlLoader.addEventListener(/*iflash.events.ProgressEvent.PROGRESS*/"progress",__bind(this,this.onLoadProgress));
					this.urlLoader.load(new URLRequest(file.url));
				}
			}
			else if (fileMode==/*iflash.filesystem.FileMode.WRITE*/"write"){
				if (!file._isApplicationStorageDirectory){
					throw new Error("only local file can be writed!")
				}
				this.fileBytes=FileStorage.instance.getBinaryFile(file.url);
			}
		}

		__proto.close=function(){
			var tmp=this.fileBytes.position;
			this.fileBytes.position=0;
			FileStorage.instance.fileWrite(this.file.url.replace("app-storage:/",""),this.fileBytes.readMultiByte(tmp,"utf8"));
			this.fileBytes.position=tmp;
		}

		__proto.openAsync=function(file,fileMode){
			this.file=file;
			this.fileMode=fileMode;
			this.urlLoader=new URLLoader();
			this.urlLoader.dataFormat=/*iflash.net.URLLoaderDataFormat.BINARY*/"binary";
			this.urlLoader.addEventListener(/*iflash.events.Event.COMPLETE*/"complete",__bind(this,this.onLoadComplete));
			this.urlLoader.addEventListener(/*iflash.events.IOErrorEvent.IO_ERROR*/"ioError",__bind(this,this.onIOError));
			this.urlLoader.addEventListener(/*iflash.events.ProgressEvent.PROGRESS*/"progress",__bind(this,this.onLoadProgress));
			this.urlLoader.load(new URLRequest(file.nativePath));
		}

		__proto.onIOError=function(evt){
			this.dispatchEvent(evt);
		}

		__proto.onLoadComplete=function(evt){
			if ((this.urlLoader.data instanceof iflash.utils.ByteArray )){
				this.fileBytes=new ByteArray();
				this.fileBytes.writeBytes(this.urlLoader.data,0,this.urlLoader.data.bytesAvailable)
				this.fileBytes.position=0;
			}
			this.dispatchEvent(evt);
		}

		__proto.onLoadProgress=function(evt){
			this.dispatchEvent(evt);
		}

		__proto.readBytes=function(bytes,offset,length){
			(offset===void 0)&& (offset=0);
			(length===void 0)&& (length=0);
			if (length > this.fileBytes.bytesAvailable){
				throw new Error("no enough data to be read!")
			}
			return this.fileBytes.readBytes(bytes,0,length);
		}

		__proto.readUTFBytes=function(length){
			if (length > this.fileBytes.bytesAvailable){
				throw new Error("no enough data to be read!")
			}
			return this.fileBytes.readUTFBytes(length);
		}

		__proto.writeBytes=function(bytes,offset,length){
			(offset===void 0)&& (offset=0);
			(length===void 0)&& (length=0);
			this.fileBytes.writeBytes(bytes,offset,length);
		}

		__proto.writeMultiByte=function(value,charSet){
			this.fileBytes.writeMultiByte(value,charSet);
		}

		__proto.writeUTFBytes=function(value){
			this.fileBytes.writeUTFBytes(value);
		}

		__getset(0,__proto,'bytesAvailable',function(){
			return this.fileBytes ? this.fileBytes.bytesAvailable :0;
		});

		__getset(0,__proto,'readAhead',function(){
			return this._readAhead;
			},function(value){
			this._readAhead=value;
		});

		__getset(0,__proto,'position',function(){
			return this.fileBytes.position;
			},function(value){
			this.fileBytes.position=value;
		});

		__getset(0,__proto,'endian',function(){
			return this._endian;
			},function(value){
			this._endian=value;
		});

		__getset(0,__proto,'objectEncoding',function(){
			return this._objectEncoding;
			},function(value){
			this._objectEncoding=value;
		});

		return FileStream;
	})(EventDispatcher)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/dom/document.as
	//class iflash.laya.dom.Document extends iflash.events.EventDispatcher
	var Document2=(function(_super){
		function Document(){
			this._element_class_map_=[];
			this._text_id_=[];
			this._baseURI_=null;
			this.canvas=null;
			this.canvas3D=null;
			this.styleSheets=[];
			this.activeElement=null;
			this.all=null;
			this.body=null;
			this.mouseX=NaN;
			this.mouseY=NaN;
			this.onkeydown=null;
			this.onkeyup=null;
			this.drawCount=0;
			this.drawObjectCount=0;
			this.adapter=null;
			this._strDebugMsg_="";
			Document.__super.call(this);
			var _$this=this;
			this.mouseY=this.mouseX=0;
			Laya.document=Laya.window.document=EventDispatcher.document=this;
			if (Laya.CONCHVER > 0){
			}
			this.canvas=Browser._createRootCanvas_();
			if (Laya.ENABLE3D){
				this.enableWebGL();
			}
			this.all=[];
			this.baseURI=new URI(EventDispatcher.window.location.href);
			EventDispatcher.window.lyAddEventListener(/*iflash.events.Event.RESIZE*/"resize",function(__args){
				var args=arguments;
				if (EventDispatcher.document.adapter.screenRotate==90){
					_$this.canvas && _$this.canvas.size(EventDispatcher.window.innerHeight,EventDispatcher.window.innerWidth);
				}
				else{
					_$this.canvas && _$this.canvas.size(EventDispatcher.window.innerWidth,EventDispatcher.window.innerHeight);
				}
			});
		}

		__class(Document,'iflash.laya.dom.Document',false,_super,'Document2');
		var __proto=Document.prototype;
		__proto.enableWebGL=function(){
			if (this.canvas3D)return this.canvas3D;
			Canvas._bIs3D=true;
			this.canvas3D=Browser._createWebGLCanvas_();
			Canvas._bIs3D=false;
			return this.canvas3D;
		}

		__proto.render=function(){
			if(!this.canvas.context)
				return;
			if (!this.canvas)return;
			this._repaint_=this.drawCount=this.drawObjectCount=0;
			this.canvas.context.textBaseline="top";
			this.canvas.context.clearRect(0,0,this.canvas.width,this.canvas.height);
			this.canvas.context.save();
			if (this.adapter.screenRotate !=0){
				this.canvas.context.translate(EventDispatcher.window.innerHeight,0);
				this.canvas.context.rotate(this.adapter.screenRotate *Math.PI / 180);
			}
			if(Laya.RENDERBYCANVAS){
				this.body._lyPaint_(this.canvas.context,0,0);
			}
			if (EventDispatcher.window.updatecount % 6==0)
				EventDispatcher.window.fps=Laya.__parseInt(1000 / EventDispatcher.window.delay[0] *10+"")/ 10;
			this.canvas.context.restore();
			if (Laya.FLASHVER > 1 || !Laya.config.showInfo || Laya.CONCHVER){
				this.canvas.context.restore();
				return;
			};
			var ctx=this.canvas.context;
			ctx.font="normal 100 12px Arial";
			if (EventDispatcher.window.updatecount % 1==0){
				this._strDebugMsg_="FPS:"+EventDispatcher.window.fps+"/"+Browser.frameRate+" draw:"+this.drawObjectCount+"/"+this.drawCount+" "+EventDispatcher.window.updatecount+" "+Browser.window.innerWidth+"/"+Browser.window.innerHeight;
			}
			ctx.fillStyle="#000000";
			ctx.fillText(this._strDebugMsg_,this.body._left_+9,this.body._top_+17);
			ctx.fillStyle="#000000";
			ctx.fillText(this._strDebugMsg_,this.body._left_+11,this.body._top_+19);
			ctx.fillStyle="#FFFF00";
			ctx.fillText(this._strDebugMsg_,this.body._left_+10,this.body._top_+18);
			this.canvas.context.restore();
		}

		__proto.setOrientationEx=function(type){
			if (((typeof type=='number')&& Math.floor(type)==type)){
				type=type==0?'portrait':'rotator';
			}
			if(this.adapter.autorotate !=type){
				this.adapter.autorotate=type;
				EventDispatcher.window.resizeTo(EventDispatcher.window.innerWidth ,EventDispatcher.window.innerHeight,true);
			}
		}

		__proto.init=function(){
			this.adapter=new DocumentAdapter();
			if(Laya.CONCHVER==0||Laya.RENDERBYCANVAS)
				(Laya.process !=null)&& (Laya.process.setRootNode(Stage.stage._modle_));
		}

		__proto.size=function(w,h){
			Stage.stage.width=w;
			Stage.stage.height=h;
			EventDispatcher.window.lyDispatchEvent(/*iflash.events.Event.RESIZE*/"resize");
		}

		__proto.getNodeRegClass=function(nodeName){
			return this._element_class_map_[nodeName.toLowerCase()];
		}

		__proto.regTextWithId=function(id,text){
			this._text_id_[id]=text;
		}

		__proto.getTextById=function(id){
			return this._text_id_[id];
		}

		__getset(0,__proto,'baseURI',function(){
			return this._baseURI_;
			},function(uri){
			this._baseURI_=uri;
		});

		return Document;
	})(EventDispatcher)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/net/httprequest.as
	//class iflash.laya.net.HttpRequest extends iflash.events.EventDispatcher
	var HttpRequest=(function(_super){
		function HttpRequest(){
			this.onload=null;
			this.onerror=null;
			this._req=null;
			this._callBackFunc=null;
			this._responseType_=null;
			HttpRequest.__super.call(this);
			if (Browser.window.XMLHttpRequest){
				this._req=/*__JS__ */new XMLHttpRequest();
			}
			else if (Browser.window.ActiveXObject){
				this._req=/*__JS__ */new ActiveXObject('Microsoft.XMLHTTP');
			}
		}

		__class(HttpRequest,'iflash.laya.net.HttpRequest',false,_super);
		var __proto=HttpRequest.prototype;
		__proto.onRequestHandler=function(_req){
			if (_req.readyState !=4){
				return;
			};
			var data=this._responseType_?_req.response:_req.responseText;
			if (_req.status==200 || (_req.can200&&_req.status==0&&data!=null&&data!="")){
				if (this._callBackFunc !=null)
					this._callBackFunc(data);
				if (this.onload !=null)
					this.onload(data);
			}
			else if (_req.status==404){
				if(this.onerror!=null){
					this.onerror(_req.status);
				}
			}
			else{
				if(this.onerror!=null){
					this.onerror(_req.status);
				}
			}
		}

		__proto.PostData=function(data,requestHeaders){
			if(requestHeaders && requestHeaders.length > 0){
				this._req.setRequestHeader(requestHeaders[0].name,requestHeaders[0].value);
				}else{
				this._req.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
			};
			var temp="";
			if((typeof data=='string')){
				temp=data;
				}else{
				var obj=data;
				if(data&&data.variables){
					obj=data.variables;
				}
				for(var key2 in obj){
					temp+=key2+"="+obj[key2]+"&";
				}
				temp=temp.substring(0,temp.length-1);
			}
			this._req.send(temp);
		}

		__proto.open=function(url,format,callBackFunc,isAsync,requestType,data,requestHeaders){
			var _$this=this;
			(isAsync===void 0)&& (isAsync=true);
			(requestType===void 0)&& (requestType="get");
			this._callBackFunc=callBackFunc;
			if (this._req==null)return false;
			try{
				this._req.onreadystatechange=function (_req){
					_$this.onRequestHandler(this);
				}
				this._req.onerror=function (_req){
					/*__JS__ */_$this.onerror(404);
				}
				if(requestType=="text"){
					requestType='get';
				};
				var r=this._req.open(requestType,url,isAsync);
				if (!Laya.CONCHVER){
					if (url.indexOf("file:")==0){
						this._req.can200=true;
					}
					else if (url.indexOf("http:")==0){
						this._req.can200=false;
					}
				}
				format && (this._responseType_=this._req.responseType=format);
				if (requestType.toLowerCase()=='get'){
					this._req.send();
				}
				else if (requestType.toLowerCase()=='post'){
					if(Laya.CONCHVER){
						if(data && data["_byteView_"]){
							this._req.send(data._byteView_.buffer.slice(0,data._length));
						}
						else{
							this.PostData(data,requestHeaders);
						}
					}
					else{
						if(data && data["_byteView_"]){
							throw ("un support binary post now");
						}
						else{
							this.PostData(data,requestHeaders);
						}
					}
				}
				else {}
			}
			catch(err){
				if(this.onerror!=null){
					this.onerror(-1);
				}
				return false;
			}
			return true;
		}

		return HttpRequest;
	})(EventDispatcher)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/window.as
	//class iflash.laya.Window extends iflash.events.EventDispatcher
	var Window3=(function(_super){
		function Window(){
			this.onScroll=null;
			this.updateTime=NaN;
			this._width=0;
			this._height=0;
			this.event=null;
			this.scale=null;
			this.mouseX=0;
			this.mouseY=0;
			this.left=0;
			this.top=0;
			this.disableMouse=false;
			this.document=null;
			this.location=null;
			this.fps=0;
			this.delay=null;
			this.updatecount=0;
			this.preUpdateTime=0;
			this._no3d_=true;
			this.nowOrientation=null;
			Window.__super.call(this);
			this.preOrientation=/*iflash.display.StageOrientation.DEFAULT*/"default";
			this.scale=new Point(1,1);
			Laya.window=EventDispatcher.window=this;
			this.location=new Location1();
			this.document=Laya.document=new Document2();
			this.init();
			this.resizeTo(Browser.window.innerWidth,Browser.window.innerHeight);
			this.updatecount=0;
			this.delay=[];
			this.updateTime=this.preUpdateTime=iflash.utils.getTimer();
		}

		__class(Window,'iflash.laya.Window',false,_super,'Window3');
		var __proto=Window.prototype;
		__proto.init=function(){
			this.document.init();
			this._no3d_=!iflash.utils.getDefinitionByName("iflash.display3D.Context3D");
		}

		__proto.enterFrame=function(){
			Stage.stage.sendRender();
			this.updateTime=iflash.utils.getTimer();
			this.delay[0]=this.updateTime-this.preUpdateTime;
			this.preUpdateTime=this.updateTime;
			this.lyDispatchEvent(/*iflash.events.Event.ENTER_FRAME*/"enterFrame");
			TimerCtrl.__DEFAULT__._update_(this.updateTime);
			EventManager.mgr.dispatchSystemEvent(this.delay[0]);
			TextField.renderTexts();
			DisplayObject.sendMask();
			Laya.CONCHVER&&ConchRenderVCanvas.INSTANCE.uploadConch();
			this.updatecount++;
		}

		__proto.resizeTo=function(w,h,forceUpdate){
			(forceUpdate===void 0)&& (forceUpdate=false);
			if(!forceUpdate){
				if ((this.document.adapter._screenRotate_==0 &&this._width==w && this._height==h)|| (this.document.adapter._screenRotate_==90 &&this._height==w && this._width==h))
					return;
			}
			this.document.adapter._screenRotate_=0;
			this._width=w;
			this._height=h;
			this.nowOrientation=/*iflash.display.StageOrientation.DEFAULT*/"default";
			if (Laya.HTMLVER&&this._no3d_){
				if(Stage.stage&&Stage.stage.autoOrients){
					if (this.document.adapter.autorotate=="rotator" && this._width < this._height){
						this.document.adapter._screenRotate_=90;
						this._width=h;
						this._height=w;
						this.nowOrientation=/*iflash.display.StageOrientation.ROTATED_RIGHT*/"rotatedRight";
					}
					else if (this.document.adapter.autorotate=="portrait" && this._width > this._height){
						this.document.adapter._screenRotate_=90;
						this._width=h;
						this._height=w;
						this.nowOrientation=/*iflash.display.StageOrientation.ROTATED_RIGHT*/"rotatedRight";
					}
					else{
						this.document.adapter._screenRotate_=0;
						this._width=w;
						this._height=h;
						this.nowOrientation=/*iflash.display.StageOrientation.DEFAULT*/"default";
					}
					}else{
					if (this.document.adapter.autorotate=="portrait"){
						this.document.adapter._screenRotate_=90;
						this._width=h;
						this._height=w;
						this.nowOrientation=/*iflash.display.StageOrientation.ROTATED_RIGHT*/"rotatedRight";
						}else{
						this.document.adapter._screenRotate_=0;
						this._width=w;
						this._height=h;
						this.nowOrientation=/*iflash.display.StageOrientation.DEFAULT*/"default";
					}
				}
			}
			this.lyDispatchEvent(/*iflash.events.Event.RESIZE*/"resize");
			if(this.nowOrientation!=this.preOrientation){
				Stage.stage.dispatchEvent(new StageOrientationEvent(/*iflash.events.StageOrientationEvent.ORIENTATION_CHANGE*/"orientationChange",true,true,this.preOrientation,this.nowOrientation));
				this.preOrientation=this.nowOrientation;
			}
		}

		__getset(0,__proto,'innerWidth',function(){
			return this._width;
			},function(w){
			this.resizeTo(w,this._height);
		});

		__getset(0,__proto,'fullScreenHeight',function(){
			/*__JS__ */return window.screen.height;
		});

		__getset(0,__proto,'fullScreenWidth',function(){
			/*__JS__ */return window.screen.width;
		});

		__getset(0,__proto,'innerHeight',function(){
			return this._height;
			},function(h){
			this.resizeTo(this._width,h);
		});

		return Window;
	})(EventDispatcher)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/media/audioelement.as
	//class iflash.media.AudioElement extends iflash.events.EventDispatcher
	var AudioElement=(function(_super){
		function AudioElement(){
			this._soundNode_=null;
			this._paramex_=0;
			this._enddel_=true;
			this._sound_type_=0;
			this._url_=null;
			this._volume_=1;
			this.onload=null;
			this.onerror=null;
			this.loops=0;
			this._currentTime_=0;
			this._onceLoad_=false;
			AudioElement.__super.call(this);
		}

		__class(AudioElement,'iflash.media.AudioElement',false,_super);
		var __proto=AudioElement.prototype;
		__proto.onAddDocument=function(){
			if (this._url_ !=null){
				var d=this._url_;
				this._url_=null;
				this.src=d;
			}
		}

		__proto.formatUrl=function(url){
			return Method.formatUrl(url,Laya.document.baseURI.path);
		}

		__proto.dispose=function(){
			this._removeevent_()
			delete AudioElement.audioCache[this._url_];
			Browser.removeFromBody(this._soundNode_);
			if(this._soundNode_){
				this._soundNode_=null;
			}
		}

		__proto.isUserEvent=function(param){
			if(!param)return false;
			if(((typeof param=='object'))&&param.hasOwnProperty("type")){
				var tType=param["type"];
				return !!tType && ((tType.indexOf("mouse")>=0)||(tType.indexOf("touch")>=0));
			}
			return false;
		}

		__proto.isUserAction=function(){
			var caller;
			caller=this.isUserAction;
			var triggerByUser=false;
			var limit=100;
			while(caller&&!triggerByUser){
				var arr;
				arr=caller.arguments;
				var callee=caller.arguments.callee;
				if(callee){
				};
				var i=0;
				var len=0;
				len=arr.length;
				for(i=0;i<len;i++){
					if(this.isUserEvent(arr[i])){
						triggerByUser=true;
						break ;
					}
				}
				caller=caller.caller;
				limit--;
				if(limit<0)break ;
			}
			return triggerByUser;
		}

		__proto.play=function(){
			if (this._soundNode_ !=null){
			}
		}

		__proto.restart=function(){
			if (this._soundNode_ !=null){
				try{
					if(this._soundNode_.currentTime < 0){
						/*__JS__ */this._soundNode_.currentTime=0;
					}
				}
				catch (e){
					/*__JS__ */this._soundNode_.src=this._url_;
				}
				if(AudioElement.disableAutoDetect|| !AudioElement.isMobile()||AudioElement.saveToPlayDic[this._url_]||this.isUserAction()){
					if (this._sound_type_==1){
						if (AudioElement.ACTIVEMUSIC&&AudioElement.ACTIVEMUSIC!=this && Laya.CONCHVER){
							Browser.alert("不能同时播放两个MP3"+this._url_);
						}
						else{
							AudioElement.ACTIVEMUSIC=this;
						}
					}
					this._soundNode_.play();
					}else{
					AudioElement.addToPlayList(this);
				}
			}
		}

		__proto.pause=function(){
			if (this._soundNode_ !=null){
				/*__JS__ */ this._soundNode_.pause();
				if (this._sound_type_==1){
					AudioElement.ACTIVEMUSIC=null;
				}
			}
		}

		__proto.muted=function(b){
			if (this._soundNode_ !=null)this._soundNode_.muted=b;
		}

		__proto.onEnded=function(){
			this.loops--;
			if (this.loops>0){
				this.restart();
			}
			else{
				this.lyDispatchEvent(/*iflash.events.Event.SOUND_COMPLETE*/"soundComplete");
			}
			if (this._sound_type_==1){
				AudioElement.ACTIVEMUSIC=null;
			}
		}

		__proto.onTimeUpdate=function(){}
		__proto._setevent_=function(){
			this._soundNode_.addEventListener("canplaythrough",__bind(this,this.onloadComplete));
			this._soundNode_.addEventListener("ended",__bind(this,this.onEnded));
			this._soundNode_.addEventListener("timeupdate",__bind(this,this.onTimeUpdate));
		}

		__proto._removeevent_=function(){
			this._soundNode_.removeEventListener("canplaythrough",__bind(this,this.onloadComplete));
			this._soundNode_.removeEventListener("ended",__bind(this,this.onEnded));
			this._soundNode_.removeEventListener("timeupdate",__bind(this,this.onTimeUpdate));
		}

		__proto.onloadComplete=function(__args){
			var args=arguments;
			!this._onceLoad_&&this.lyDispatchEvent(/*iflash.events.Event.COMPLETE*/"complete");
			this._onceLoad_=true;
		}

		__proto.load=function(){
			this._soundNode_.load();
		}

		__getset(0,__proto,'duration',function(){
			return this._soundNode_?this._soundNode_.duration:0;
		});

		__getset(0,__proto,'src',function(){
			return this._url_;
			},function(url){
			if (AudioElement._muted_==true){
				if ((this._paramex_ & 0x8)!=0){
					return;
				}
			}
			this._url_=this.formatUrl(url);
			var audioType=this._url_.substring(this._url_.lastIndexOf(".")+1,this._url_.length);
			if (audioType=="mp3"){
				this._sound_type_=1;
			}
			this._soundNode_=Browser.document.createElement("audio");
			this._setevent_();
			this.muted(AudioElement._muted_);
			this._soundNode_.src=this._url_;
			if (this.autoplay){
				this._soundNode_.play();
			}
			else{
				this._paramex_ |=0x10;
			}
		});

		__getset(0,__proto,'autoplay',function(){
			return (this._paramex_ & 0x1)!=0;
			},function(b){
			if (b){
				this._paramex_ |=0x1;
				if (this._soundNode_ !=null && (this._paramex_ & 0x10)!=0){
					this._soundNode_.play();
				}
			}
			else this._paramex_&=~0x1;
		});

		__getset(0,__proto,'loop',function(){
			return (this._paramex_ & 0x2)!=0;
			},function(b){
			if (b){
				this._paramex_ |=0x2;
			}
			else this._paramex_&=~0x2;
			this._soundNode_.loop=b;
		});

		__getset(0,__proto,'volume',function(){
			return this._volume_;
			},function(num){
			/*__JS__ */num==null && (num=0);
			var tmp=Math.max(Math.min(1,num),0);
			num=tmp;
			this._soundNode_ && (this._soundNode_.volume=num);
			this._volume_=num;
		});

		__getset(0,__proto,'position',function(){
			return this._soundNode_&&this._soundNode_.currentTime ? this._soundNode_.currentTime :0;
			},function(value){
			this._currentTime_=value;
			this._soundNode_&&(this._soundNode_.currentTime=value);
		});

		AudioElement.isMobile=function(){
			if(AudioElement._deviceType==-1){
				if(Browser.navigator.userAgent.match(/(iPhone|iPod|Android|ios)/i)){
					AudioElement._deviceType=1;
					}else{
					AudioElement._deviceType=0;
				}
			}
			return AudioElement._deviceType==1;
		}

		AudioElement.addToPlayList=function(audio){
			AudioElement._toPlayList.push(audio);
			AudioElement.removeEvents();
			AudioElement.addEvents();
		}

		AudioElement.playToPlayLists=function(evt){
			AudioElement.removeEvents();
			if(AudioElement._toPlayList.length>0){
				var i=0,len=AudioElement._toPlayList.length;
				for(i=0;i<len;i++){
					AudioElement._toPlayList[i].restart();
				}
				AudioElement._toPlayList=[];
			}
		}

		AudioElement.addEvents=function(){
			EventManager.stage.addEventListener(/*iflash.events.MouseEvent.MOUSE_DOWN*/"mouseDown",AudioElement.playToPlayLists);
			EventManager.stage.addEventListener(/*iflash.events.TouchEvent.TOUCH_BEGIN*/"touchBegin",AudioElement.playToPlayLists);
		}

		AudioElement.removeEvents=function(){
			EventManager.stage.removeEventListener(/*iflash.events.MouseEvent.MOUSE_DOWN*/"mouseDown",AudioElement.playToPlayLists);
			EventManager.stage.removeEventListener(/*iflash.events.TouchEvent.TOUCH_BEGIN*/"touchBegin",AudioElement.playToPlayLists);
		}

		AudioElement._muted_=false;
		AudioElement._musicmuted_=false;
		AudioElement._AUTOPLAY_=0x1;
		AudioElement._LOOP_=0x2;
		AudioElement._PRELOAD_=0x4;
		AudioElement._MUSIC_=0x8;
		AudioElement._ISPLAY_=0x10;
		AudioElement.ACTIVEMUSIC=null
		AudioElement.audioCache={};
		AudioElement.disableAutoDetect=false;
		AudioElement._deviceType=-1;
		AudioElement.saveToPlayDic={};
		AudioElement._toPlayList=[];
		return AudioElement;
	})(EventDispatcher)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/media/camera.as
	//class iflash.media.Camera extends iflash.events.EventDispatcher
	var Camera=(function(_super){
		function Camera(){
			this._camera=null;
			Camera.__super.call(this);
		}

		__class(Camera,'iflash.media.Camera',false,_super);
		var __proto=Camera.prototype;
		__proto.setCamera=function(camera){
			this._camera=camera;
			return this;
		}

		__proto.setCursor=function(value){
			this._camera.setCursor(value);
		}

		__proto.setKeyFrameInterval=function(keyFrameInterval){
			this._camera.setKeyFrameInterval (keyFrameInterval);
		}

		__proto.setLoopback=function(compress){
			(compress===void 0)&& (compress=false);
			this._camera.setLoopback(compress);
		}

		__proto.setMode=function(width,height,fps,favorArea){
			(favorArea===void 0)&& (favorArea=true);
			this._camera.setMode(width,height,fps,favorArea);
		}

		__proto.setMotionLevel=function(motionLevel,timeout){
			(timeout===void 0)&& (timeout=2000);
			this._camera.setMotionLevel(motionLevel,timeout);
		}

		__proto.setQuality=function(bandwidth,quality){
			this._camera.setQuality(bandwidth,quality);
		}

		__getset(0,__proto,'activityLevel',function(){
			return this._camera.activityLevel;
		});

		__getset(0,__proto,'bandwidth',function(){
			return this._camera.bandwidth;
		});

		__getset(0,__proto,'currentFPS',function(){
			return this._camera.currentFPS;
		});

		__getset(0,__proto,'fps',function(){
			return this._camera.fps;
		});

		__getset(0,__proto,'keyFrameInterval',function(){
			return this._camera.keyFrameInterval;
		});

		__getset(0,__proto,'quality',function(){
			return this._camera.quality;
		});

		__getset(0,__proto,'motionLevel',function(){
			return this._camera.motionLevel;
		});

		__getset(0,__proto,'height',function(){
			return this._camera.height;
		});

		__getset(0,__proto,'index',function(){
			return this._camera.index;
		});

		__getset(0,__proto,'loopback',function(){
			return this._camera.loopback;
		});

		__getset(0,__proto,'motionTimeout',function(){
			return this._camera.motionTimeout;
		});

		__getset(0,__proto,'muted',function(){
			return this._camera.muted;
		});

		__getset(0,__proto,'name',function(){
			return this._camera.name;
		});

		__getset(0,__proto,'width',function(){
			return this._camera.width;
		});

		__getset(1,Camera,'isSupported',function(){
			return iflash.media.Camera.isSupported;
		},iflash.events.EventDispatcher._$SET_isSupported);

		__getset(1,Camera,'names',function(){
			var result=[];
			var key;
			/*for each*/for(var $each_key in Camera._cameras){
				key=Camera._cameras[$each_key];
				result.push(key);
			}
			return result;
		},iflash.events.EventDispatcher._$SET_names);

		Camera._scanHardware=function(){}
		Camera.getCamera=function(name){
			if (Camera._cameras[name])return Camera._cameras[name];
			var result=new Camera();
			Camera._cameras[name]=result;
			return result.setCamera(iflash.media.Camera.getCamera(name));
		}

		__static(Camera,
		['_cameras',function(){return this._cameras=new Object;}
		]);
		return Camera;
	})(EventDispatcher)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/media/microphone.as
	//class iflash.media.Microphone extends iflash.events.EventDispatcher
	var Microphone=(function(_super){
		function Microphone(){
			this._mic=null;
			Microphone.__super.call(this);
		}

		__class(Microphone,'iflash.media.Microphone',false,_super);
		var __proto=Microphone.prototype;
		__proto.setMicrophone=function(mic){
			this._mic=mic;
			return this;
		}

		__proto.setLoopBack=function(state){
			(state===void 0)&& (state=true);
			this._mic.setLoopBack=state;
		}

		__proto.setSilenceLevel=function(silenceLevel,timeout){
			(timeout===void 0)&& (timeout=-1);
			this._mic.setSilenceLevel(silenceLevel,timeout);
		}

		__proto.setUseEchoSuppression=function(useEchoSuppression){
			this._mic.setUseEchoSuppression(useEchoSuppression);
		}

		__getset(0,__proto,'activityLevel',function(){
			return this._mic.activityLevel;
		});

		__getset(0,__proto,'enableVAD',function(){
			return this._mic.enableVAD;
			},function(enable){
			this._mic.enableVAD=enable;
		});

		__getset(0,__proto,'name',function(){
			return this._mic.activityLevel;
		});

		__getset(0,__proto,'codec',function(){
			return this._mic.codec;
			},function(codec){
			this._mic.codec=codec;
		});

		__getset(0,__proto,'gain',function(){
			return this._mic.gain;
			},function(gain){
			this._mic.gain=gain;
		});

		__getset(0,__proto,'silenceLevel',function(){
			return this._mic.activityLevel;
		});

		__getset(0,__proto,'encodeQuality',function(){
			return this._mic.encodeQuality;
			},function(quality){
			this._mic.encodeQuality=quality;
		});

		__getset(0,__proto,'framesPerPacket',function(){
			return this._mic.framesPerPacket;
			},function(frames){
			this._mic.framesPerPacket=frames;
		});

		__getset(0,__proto,'index',function(){
			return this._mic.activityLevel;
		});

		__getset(0,__proto,'muted',function(){
			return this._mic.activityLevel;
		});

		__getset(0,__proto,'noiseSuppressionLevel',function(){
			return this._mic.noiseSuppressionLevel;
			},function(level){
			this._mic.noiseSuppressionLevel=level;
		});

		__getset(0,__proto,'rate',function(){
			return this._mic.rate;
			},function(rate){
			this._mic.rate=rate;
		});

		__getset(0,__proto,'silenceTimeout',function(){
			return this._mic.activityLevel;
		});

		__getset(0,__proto,'soundTransform',function(){
			return this._mic.soundTransform;
			},function(sndTransform){
			this._mic.soundTransform=sndTransform;
		});

		__getset(0,__proto,'useEchoSuppression',function(){
			return this._mic.activityLevel;
		});

		__getset(1,Microphone,'isSupported',function(){
			return iflash.media.Microphone.isSupported;
		},iflash.events.EventDispatcher._$SET_isSupported);

		__getset(1,Microphone,'names',function(){
			var result=[];
			var mic;
			/*for each*/for(var $each_mic in Microphone._mics){
				mic=Microphone._mics[$each_mic];
				result.push(mic.name);
			}
			return result;
		},iflash.events.EventDispatcher._$SET_names);

		Microphone.getMicrophone=function(index){
			(index===void 0)&& (index=-1);
			if (Microphone._mics[index])return Microphone._mics[index];
			var result=new Microphone();
			Microphone._mics[index]=result;
			return result.setMicrophone(iflash.media.Microphone.getMicrophone(index));
		}

		__static(Microphone,
		['_mics',function(){return this._mics=new Object;}
		]);
		return Microphone;
	})(EventDispatcher)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/media/sound.as
	//class iflash.media.Sound extends iflash.events.EventDispatcher
	var Sound=(function(_super){
		function Sound(stream,context){
			this._soundChannel_=null;
			this.audio=null;
			Sound.__super.call(this);
			this.audio=new AudioElement();
			this.audio.addEventListener(/*iflash.events.Event.COMPLETE*/"complete",__bind(this,this.aodioComplete));
			stream && this.load(stream,context);
		}

		__class(Sound,'iflash.media.Sound',false,_super);
		var __proto=Sound.prototype;
		__proto.close=function(){
			this.audio&&this.audio.pause();
		}

		__proto.dispose=function(){
			this.audio&&this.audio.dispose();
			this.audio=null;
		}

		__proto.extract=function(target,length,startPosition){
			(startPosition===void 0)&& (startPosition=-1);
			return 0}
		__proto.load=function(stream,context){
			this.audio.src=stream.url;
		}

		__proto.play=function(startTime,loops,sndTransform){
			(startTime===void 0)&& (startTime=0);
			(loops===void 0)&& (loops=0);
			this.audio.loop=false;
			if(loops==/*int.MAX_VALUE*/2147483647){
				this.audio.loop=true;
			}
			else if (loops !=0){
				this.audio.loops=loops;
			}
			if(startTime>this.length){
				startTime=0;
			}
			if(startTime<0)startTime=0;
			this.audio.position=startTime/1000;
			!this._soundChannel_ && (this._soundChannel_=new SoundChannel());
			this._soundChannel_._sound_=this.audio;
			if(!this.audio.hasEventListener(/*iflash.events.Event.SOUND_COMPLETE*/"soundComplete")){
				this.audio.addEventListener(/*iflash.events.Event.SOUND_COMPLETE*/"soundComplete",__bind(this,this._soundCompleteH));
			}
			this.audio.restart();
			return this._soundChannel_;
		}

		__proto._soundCompleteH=function(__args){
			var args=arguments;
			this.audio !=null && (this.audio.removeEventListener(/*iflash.events.Event.SOUND_COMPLETE*/"soundComplete",__bind(this,this._soundCompleteH)));
			this._soundChannel_.dispatchEvent(new Event(/*iflash.events.Event.SOUND_COMPLETE*/"soundComplete"));
		}

		__proto.aodioComplete=function(__args){
			var args=arguments;
			this.audio !=null && (this.audio.removeEventListener(/*iflash.events.Event.COMPLETE*/"complete",__bind(this,this.aodioComplete)));
			this.lyDispatchEvent(/*iflash.events.Event.COMPLETE*/"complete");
		}

		__proto.loadCompressedDataFromByteArray=function(bytes,length){}
		__getset(0,__proto,'bytesLoaded',LAYAFN0/*function(){return 0}*/);
		__getset(0,__proto,'isURLInaccessible',LAYAFNFALSE/*function(){return false}*/);
		__getset(0,__proto,'bytesTotal',LAYAFN0/*function(){return 0}*/);
		__getset(0,__proto,'isBuffering',LAYAFNFALSE/*function(){return false}*/);
		__getset(0,__proto,'id3',LAYAFNNULL/*function(){return null}*/);
		__getset(0,__proto,'length',function(){
			return this.audio.duration*1000;
		});

		__getset(0,__proto,'url',LAYAFNSTR/*function(){return ""}*/);
		return Sound;
	})(EventDispatcher)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/media/soundchannel.as
	//class iflash.media.SoundChannel extends iflash.events.EventDispatcher
	var SoundChannel=(function(_super){
		function SoundChannel(){
			this._sound_=null;
			this._soundTransform_=null;
			SoundChannel.__super.call(this);
		}

		__class(SoundChannel,'iflash.media.SoundChannel',false,_super);
		var __proto=SoundChannel.prototype;
		__proto.stop=function(){
			this._sound_ && this._sound_.pause();
		}

		__getset(0,__proto,'leftPeak',LAYAFN0/*function(){return 0}*/);
		__getset(0,__proto,'soundTransform',function(){
			return this._soundTransform_?this._soundTransform_:this._soundTransform_=new SoundTransform();
			},function(sndTransform){
			this._soundTransform_=sndTransform;
			if (!isNaN(this._soundTransform_.volume)){
				if(this._sound_==null)return;
				this._sound_.volume=this._soundTransform_.volume;
			}
			this._soundTransform_._sound_=this._sound_;
		});

		__getset(0,__proto,'position',function(){
			if(this._sound_&&this._sound_.position)return this._sound_.position*1000;
			return 0;
		});

		__getset(0,__proto,'rightPeak',LAYAFN0/*function(){return 0}*/);
		return SoundChannel;
	})(EventDispatcher)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/media/stagewebview.as
	//class iflash.media.StageWebView extends iflash.events.EventDispatcher
	var StageWebView=(function(_super){
		function StageWebView(useNative){
			StageWebView.__super.call(this);
			(useNative===void 0)&& (useNative=false);
		}

		__class(StageWebView,'iflash.media.StageWebView',false,_super);
		var __proto=StageWebView.prototype;
		__proto.stop=LAYAFNVOID/*function(){}*/
		__proto.reload=LAYAFNVOID/*function(){}*/
		__proto.loadURL=LAYAFNVOID/*function(url){}*/
		__proto.loadString=function(text,mimeType){
			(mimeType===void 0)&& (mimeType="text/html");
		}

		__proto.historyForward=LAYAFNVOID/*function(){}*/
		__proto.historyBack=LAYAFNVOID/*function(){}*/
		__proto.drawViewPortToBitmapData=LAYAFNVOID/*function(bitmap){}*/
		__proto.dispose=LAYAFNVOID/*function(){}*/
		__proto.assignFocus=function(direction){
			(direction===void 0)&& (direction="none");
		}

		__getset(0,__proto,'title',LAYAFNSTR/*function(){return ""}*/);
		__getset(0,__proto,'viewPort',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(rect){}*/);
		__getset(0,__proto,'stage',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(rect){}*/);
		__getset(0,__proto,'location',LAYAFNSTR/*function(){return ""}*/);
		__getset(0,__proto,'isHistoryBackEnabled',LAYAFNFALSE/*function(){return false}*/);
		__getset(0,__proto,'isHistoryForwardEnabled',LAYAFNFALSE/*function(){return false}*/);
		__getset(1,StageWebView,'isSupported',LAYAFNFALSE/*function(){return false}*/,iflash.events.EventDispatcher._$SET_isSupported);
		return StageWebView;
	})(EventDispatcher)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/net/localconnection.as
	//class iflash.net.LocalConnection extends iflash.events.EventDispatcher
	var LocalConnection=(function(_super){
		function LocalConnection(){
			LocalConnection.__super.call(this);
		}

		__class(LocalConnection,'iflash.net.LocalConnection',false,_super);
		var __proto=LocalConnection.prototype;
		__proto.allowDomain=function(__rest){}
		__proto.allowInsecureDomain=function(__rest){}
		__proto.close=LAYAFNVOID/*function(){}*/
		__proto.connect=LAYAFNVOID/*function(connectionName){}*/
		__proto.send=function(connectionName,methodName,__rest){}
		__getset(0,__proto,'client',function(){
			return null;
			},function(client){
		});

		__getset(0,__proto,'domain',LAYAFNSTR/*function(){return ""}*/);
		__getset(0,__proto,'isPerUser',LAYAFNFALSE/*function(){return false}*/,LAYAFNVOID/*function(newValue){}*/);
		__getset(1,LocalConnection,'isSupported',LAYAFNFALSE/*function(){return false}*/,iflash.events.EventDispatcher._$SET_isSupported);
		return LocalConnection;
	})(EventDispatcher)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/net/netconnection.as
	//class iflash.net.NetConnection extends iflash.events.EventDispatcher
	var NetConnection=(function(_super){
		function NetConnection(){
			this._version=0;
			this._netConnection=null;
			NetConnection.__super.call(this);
			Log.error("NetConnection no");
			if(this._netConnection==null){
			}
		}

		__class(NetConnection,'iflash.net.NetConnection',false,_super);
		var __proto=NetConnection.prototype;
		__proto.addHeader=function(operation,mustUnderstand,param){
			(mustUnderstand===void 0)&& (mustUnderstand=false);
			this._netConnection.addHeader(operation,mustUnderstand,param);
		}

		__proto.call=function(command,responder,__rest){
			var rest=[];for(var i=2,sz=arguments.length;i<sz;i++)rest.push(arguments[i]);
			var args=[command,responder.resp];
			rest && rest.length>0 && (args=args.concat(rest));
			this._netConnection.call.apply(this._netConnection,args);
		}

		__proto.close=function(){
			this._netConnection.close();
		}

		__proto.connect=function(command,__rest){
			var rest=[];for(var i=1,sz=arguments.length;i<sz;i++)rest.push(arguments[i]);
			if (command==null){
				Log.error("Error: Can only connect in \"HTTP streaming\" mode");
			}
			this._netConnection.connect(command,rest);
		}

		__getset(0,__proto,'client',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(object){}*/);
		__getset(0,__proto,'maxPeerConnections',function(){
			return 8;
		},LAYAFNVOID/*function(maxPeers){}*/);

		__getset(0,__proto,'connected',LAYAFNTRUE/*function(){return true}*/);
		__getset(0,__proto,'objectEncoding',function(){
			return this._version
			},function(version){
			this._version=version;
		});

		__getset(0,__proto,'connectedProxyType',LAYAFNSTR/*function(){return ""}*/);
		__getset(0,__proto,'farID',LAYAFNSTR/*function(){return ""}*/);
		__getset(0,__proto,'nearID',LAYAFNSTR/*function(){return ""}*/);
		__getset(0,__proto,'nearNonce',LAYAFNSTR/*function(){return ""}*/);
		__getset(0,__proto,'unconnectedPeerStreams',LAYAFNARRAY/*function(){return []}*/);
		__getset(0,__proto,'farNonce',LAYAFNSTR/*function(){return ""}*/);
		__getset(0,__proto,'uri',LAYAFNSTR/*function(){return ""}*/);
		__getset(0,__proto,'protocol',LAYAFNSTR/*function(){return ""}*/);
		__getset(0,__proto,'proxyType',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(ptype){}*/);
		__getset(0,__proto,'usingTLS',LAYAFNFALSE/*function(){return false}*/);
		__getset(1,NetConnection,'defaultObjectEncoding',LAYAFN0/*function(){return 0}*/,LAYAFNVOID/*function(version){}*/);
		NetConnection.CONNECT_SUCCESS="connectSuccess";
		return NetConnection;
	})(EventDispatcher)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/net/netstream.as
	//class iflash.net.NetStream extends iflash.events.EventDispatcher
	var NetStream=(function(_super){
		function NetStream(connection,peerID){
			NetStream.__super.call(this);
			(peerID===void 0)&& (peerID="connectToFMS");
		}

		__class(NetStream,'iflash.net.NetStream',false,_super);
		var __proto=NetStream.prototype;
		__proto.close=LAYAFNVOID/*function(){}*/
		__proto.pause=LAYAFNVOID/*function(){}*/
		__proto.play=function(__rest){}
		__proto.seek=LAYAFNVOID/*function(offset){}*/
		__getset(0,__proto,'bufferLength',LAYAFN0/*function(){return 0}*/);
		__getset(0,__proto,'client',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(object){}*/);
		__getset(0,__proto,'bytesLoaded',LAYAFN0/*function(){return 0}*/);
		__getset(0,__proto,'bytesTotal',LAYAFN0/*function(){return 0}*/);
		return NetStream;
	})(EventDispatcher)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/net/sharedobject.as
	//class iflash.net.SharedObject extends iflash.events.EventDispatcher
	var SharedObject=(function(_super){
		function SharedObject(){
			this.cookie=null;
			SharedObject.__super.call(this);
		}

		__class(SharedObject,'iflash.net.SharedObject',false,_super);
		var __proto=SharedObject.prototype;
		__proto.clear=function(){
			this.cookie.clear();
		}

		__proto.close=LAYAFNVOID/*function(){}*/
		__proto.flush=function(minDiskSpace){
			(minDiskSpace===void 0)&& (minDiskSpace=0);
			return this.cookie.flush(minDiskSpace);
		}

		__proto.send=function(__rest){}
		__proto.setDirty=LAYAFNVOID/*function(propertyName){}*/
		__proto.setProperty=function(propertyName,value){
			this.cookie.setProperty(propertyName,value);
		}

		__proto.setCookie=function(value){
			this.cookie=value;
			return this;
		}

		__getset(0,__proto,'client',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(object){}*/);
		__getset(0,__proto,'data',function(){
			return this.cookie.data;
		});

		__getset(0,__proto,'objectEncoding',LAYAFN0/*function(){return 0}*/,LAYAFNVOID/*function(version){}*/);
		__getset(0,__proto,'fps',null,LAYAFNVOID/*function(updatesPerSecond){}*/);
		__getset(0,__proto,'size',function(){
			if(this.data==null)return 0;
			return JSON.stringify(this.data).length;
		});

		__getset(1,SharedObject,'defaultObjectEncoding',LAYAFN0/*function(){return 0}*/,LAYAFNVOID/*function(version){}*/);
		SharedObject.deleteAll=LAYAFN0/*function(url){return 0}*/
		SharedObject.getDiskUsage=LAYAFN0/*function(url){return 0}*/
		SharedObject.getLocal=function(name,localPath,secure){
			(secure===void 0)&& (secure=false);
			if (SharedObject._cookies_[name])return SharedObject._cookies_[name];
			var result=new SharedObject();
			SharedObject._cookies_[name]=result;
			return result.setCookie(Cookie.getLocal(name,localPath,secure));
		}

		SharedObject.getRemote=function(name,remotePath,persistence,secure){
			(persistence===void 0)&& (persistence=false);
			(secure===void 0)&& (secure=false);
			return null}
		SharedObject._cookies_=[];
		return SharedObject;
	})(EventDispatcher)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/net/socket.as
	//class iflash.net.Socket extends iflash.events.EventDispatcher
	var Socket=(function(_super){
		function Socket(host,port){
			this._stamp=NaN;
			this._socket=null;
			this._connected=false;
			this._host=null;
			this._port=0;
			this._addInputPosition=0;
			this._input=null;
			this._output=null;
			this._bytes=null;
			this.timeout=0;
			this.objectEncoding=0;
			this._endian=null;
			(port===void 0)&& (port=0);
			Socket.__super.call(this);
			this._endian="bigEndian";
			this.timeout=20000;
			this._addInputPosition=0;
			if(port > 0 && port < 65535)
				this.connect(host,port);
		}

		__class(Socket,'iflash.net.Socket',false,_super);
		var __proto=Socket.prototype;
		__proto.connect=function(host,port){
			if(this._socket !=null)
				this._socket.onclose=null;
			this.close();
			var url="ws://"+host+":"+port;
			this._host=host;
			this._port=port;
			this._socket=/*__JS__ */new WebSocket(url);
			this._socket.binaryType="arraybuffer";
			this._stamp=iflash.utils.getTimer();
			this._output=new ByteArray();
			this._output.endian=this.endian;
			this._input=new ByteArray();
			this._input.endian=this.endian;
			this._socket.onopen=iflash.method.bind(this,this.onOpenHandler);
			this._socket.onmessage=iflash.method.bind(this,this.onMessageHandler);
			this._socket.onclose=iflash.method.bind(this,this.onCloseHandler);
			this._socket.onerror=iflash.method.bind(this,this.onErrorHandler);
			this._socket.binaryType="arraybuffer";
		}

		__proto.cleanSocket=function(){
			try {
				this._socket.close();
			}catch (e){}
			this._socket=null;
		}

		__proto.close=function(){
			if(this._socket!=null){
				this._connected=false;
				this.cleanSocket();
			}
		}

		__proto.readBoolean=function(){
			return this._input.readBoolean();
		}

		__proto.readByte=function(){
			return this._input.readByte();
		}

		__proto.readDouble=function(){
			return this._input.readDouble();
		}

		__proto.readFloat=function(){
			return this._input.readFloat();
		}

		__proto.readInt=function(){
			return this._input.readInt();
		}

		__proto.readMultiByte=function(length,charSet){
			return this._input.readMultiByte(length,charSet);
		}

		__proto.readObject=function(){
			return this._input.readObject();
		}

		__proto.readShort=function(){
			return this._input.readShort();
		}

		__proto.readUnsignedByte=function(){
			return this._input.readUnsignedByte();
		}

		__proto.readUnsignedInt=function(){
			return this._input.readUnsignedInt();
		}

		__proto.readUnsignedShort=function(){
			return this._input.readUnsignedShort();
		}

		__proto.readUTF=function(){
			return this._input.readUTF();
		}

		__proto.readUTFBytes=function(length){
			return this._input.readUTFBytes(length);
		}

		__proto.readBytes=function(bytes,offset,length){
			(offset===void 0)&& (offset=0);
			(length===void 0)&& (length=0);
			/*__JS__ */this._input.readBytes(bytes,offset,length);
		}

		__proto.writeBoolean=function(value){
			this._output.writeBoolean(value);
		}

		__proto.writeByte=function(value){
			this._output.writeByte(value);
		}

		__proto.writeDouble=function(value){
			this._output.writeDouble(value);
		}

		__proto.writeFloat=function(value){
			this._output.writeFloat(value);
		}

		__proto.writeInt=function(value){
			this._output.writeInt(value);
		}

		__proto.writeMultiByte=function(value,charSet){
			(charSet===void 0)&& (charSet="UTF-8");
			this._output.writeMultiByte(value,charSet);
		}

		__proto.writeShort=function(value){
			this._output.writeShort(value);
		}

		__proto.writeUTF=function(value){
			this._output.writeUTF(value);
		}

		__proto.writeUTFBytes=function(value){
			this._output.writeUTFBytes(value);
		}

		__proto.writeUnsignedInt=function(value){
			this._output.writeUnsignedInt(value);
		}

		__proto.writeBytes=function(bytes,offset,length){
			(offset===void 0)&& (offset=0);
			(length===void 0)&& (length=0);
			/*__JS__ */this._output.writeBytes(bytes,offset,length);
		}

		__proto.onOpenHandler=function(__args){
			var args=arguments;
			this._connected=true;
			this.dispatchEvent (new Event(/*iflash.events.Event.CONNECT*/"connect"));
		}

		__proto.onMessageHandler=function(msg){
			if (this._input.length>=0 && this._input.bytesAvailable<1){
				this._input.clear();
				this._addInputPosition=0;
			};
			var pre=this._input.position;
			!this._addInputPosition && (this._addInputPosition=0);
			this._input.position=this._addInputPosition;
			if(msg){
				if((typeof msg.data=='string')){
					this._input.writeUTFBytes(msg.data);
					}else{
					this._input.writeArrayBuffer(msg.data);
				}
			}
			this._addInputPosition=this._input.position;
			this._input.position=pre;
			this.dispatchEvent(new Event(/*iflash.events.ProgressEvent.SOCKET_DATA*/"socketData"));
		}

		__proto.onflashMessage=function(evt){
			this.dispatchEvent(new ProgressEvent(/*iflash.events.ProgressEvent.SOCKET_DATA*/"socketData"));
		}

		__proto.onCloseHandler=function(__args){
			var args=arguments;
			this._connected=false;
			this.dispatchEvent (new Event(/*iflash.events.Event.CLOSE*/"close"));
		}

		__proto.onErrorHandler=function(__args){
			var args=arguments;
			this.dispatchEvent (new IOErrorEvent (/*iflash.events.IOErrorEvent.IO_ERROR*/"ioError"));
		}

		__proto.flush=function(){
			if(this._output && this._output.length > 0){
				try {
					this._socket && this._socket.send(this._output.__getBuffer());
					this._output.endian=this.endian;
					this._output.clear();
				}catch (e){}
			}
		}

		__getset(0,__proto,'connected',function(){
			return this._connected;
		});

		__getset(0,__proto,'endian',function(){
			return this._endian;
			},function(value){
			this._endian=value;
			if(this._input !=null)this._input.endian=value;
			if (this._output !=null)this._output.endian=value;
		});

		__getset(0,__proto,'bytesAvailable',function(){
			return this._input.bytesAvailable;
		});

		__getset(0,__proto,'bytesPending',function(){
			return this._output.length;
		});

		Socket.LITTLE_ENDIAN="littleEndian";
		Socket.BIG_ENDIAN="bigEndian";
		return Socket;
	})(EventDispatcher)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/net/urlloader.as
	//class iflash.net.URLLoader extends iflash.events.EventDispatcher
	var URLLoader=(function(_super){
		function URLLoader(request){
			this.bytesLoaded=0;
			this.bytesTotal=0;
			this.data=null;
			this.fileData=null;
			this.crossDomain=false;
			this.IsWriteXmlData=true;
			this.file=null;
			this._bitmapData=null;
			URLLoader.__super.call(this);
			this.dataFormat=/*iflash.net.URLLoaderDataFormat.TEXT*/"text";
			if(request !=null){
				this.load(request);
			}
		}

		__class(URLLoader,'iflash.net.URLLoader',false,_super);
		var __proto=URLLoader.prototype;
		__proto.close=LAYAFNVOID/*function(){}*/
		__proto.load=function(request){
			var _$this=this;
			var contentType=Method.formatUrlType(request.url);
			if(this.dataFormat==/*iflash.net.URLLoaderDataFormat.TEXT*/"text"){
				if(contentType=="xml"){
					if(Laya.CONCHVER&& this.IsWriteXmlData){
						/*__JS__ */var domparser=new DOMParser();
						/*__JS__ */domparser.onload=function(xmlData){;
							/*__JS__ */_$this.data=domparser.getResult();;
							/*__JS__ */_$this.dispatchEvent(new Event(Event.COMPLETE));};
						/*__JS__ */domparser._parser.onerror=function(){;
							/*__JS__ */_$this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR,false,false,"ioError"))};
						/*__JS__ */domparser.src=Method.formatUrl(request.url);
					}
					else{
						this.file=new FileRead(request.url,{onload:__bind(this,this._Loader),unOnload:__bind(this,this._LoaderError)},null);
						this.file.contentType=contentType;
					}
				}
				else if(contentType=="fnt"){
					this.file=new FileRead(request.url,{onload:__bind(this,this._Loader),unOnload:__bind(this,this._LoaderError)},null);
					this.file.contentType=contentType;
				}
				else if(request.url.indexOf("?")>-1 && Laya.HTMLVER && this.crossDomain){
					var _this=this;
					var f=function (d){
						var e=new Event(/*iflash.events.Event.COMPLETE*/"complete");
						_this.data=e.lyData=d;
						_this.dispatchEvent(e);
					}
					Ajax.GetJSON(request.url,f);
				}
				else{
					if(request.data !=null){
						var data2=request.data.toString();
						if(data2){
							var method=request.method.toLowerCase();
							if(method!="post"){
								if(request.url.indexOf("?")==-1){
									request.url=request.url+"?"+data2;
									}else{
									request.url=request.url+"&"+data2;
								}
							}
						}
					}
					this.file=new FileRead(request.url,{onload:__bind(this,this._Loader),unOnload:__bind(this,this._LoaderError)},null,request);
					this.file.contentType=contentType;
				}
				}else if(this.dataFormat==/*iflash.net.URLLoaderDataFormat.BINARY*/"binary"){
				if (["jpg","gif","png"].indexOf(contentType)!=-1){
					if (this._bitmapData==null)this._bitmapData=new BitmapData();
					this.data=Browser.document.createElement("image");
					this.data.onload=function (__args){
						var args=arguments;
						if ("tagName" in this){
							}else {
							this.tagName="IMG";
						}
						_$this._bitmapData.setImage(this);
						_$this.dispatchEvent(new Event(/*iflash.events.Event.COMPLETE*/"complete"));
					};
					this.data.onerror=function (){
						_$this.dispatchEvent(new IOErrorEvent(/*iflash.events.IOErrorEvent.IO_ERROR*/"ioError",false,false,"ioError"));
					}
					this.data.src=Method.formatUrl(request.url);
				}
				else{
					this.file=new FileRead(request.url,{onload:__bind(this,this._Loader),unOnload:__bind(this,this._LoaderError)},/*iflash.net.URLLoaderDataFormat.BINARY*/"binary");
					this.file.contentType=Method.formatUrlType(request.url);
				}
				}else{
			}
		}

		__proto._LoaderError=function(fileread){
			this.dispatchEvent(new IOErrorEvent(/*iflash.events.IOErrorEvent.IO_ERROR*/"ioError"));
			this.file=null;
		}

		__proto._Loader=function(fileread){
			if(fileread.contentType=="swf"){
				var bytes=new ByteArray();
				bytes.writeUTF(fileread.contentType);
				bytes.writeUTF(fileread.url);
				fileread.contentdata.readBytes(bytes,bytes.position);
				bytes.position=0;
				this.data=bytes;
				bytes=null;
				}else{
				this.data=fileread.contentdata;
			}
			this.dispatchEvent(new Event(/*iflash.events.Event.COMPLETE*/"complete"));
			this.file=null;
		}

		__getset(0,__proto,'bitmapdata',function(){
			return this._bitmapData;
		});

		URLLoader.isCatchfile=false;
		return URLLoader;
	})(EventDispatcher)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/net/urlstream.as
	//class iflash.net.URLStream extends iflash.events.EventDispatcher
	var URLStream=(function(_super){
		function URLStream(){
			this._input=null;
			this.fileData=null;
			this.file=null;
			URLStream.__super.call(this);
			this._input==null && (this._input=new ByteArray());
		}

		__class(URLStream,'iflash.net.URLStream',false,_super);
		var __proto=URLStream.prototype;
		__proto.close=LAYAFNVOID/*function(){}*/
		__proto.load=function(request){
			var index=(request.url).lastIndexOf("?");
			var contentType=Method.formatUrlType(request.url);
			this.file=new FileRead(request.url,{onload:__bind(this,this._Loader),unOnload:__bind(this,this._LoaderError)},/*iflash.net.URLLoaderDataFormat.BINARY*/"binary",request);
			this.file.contentType=Method.formatUrlType(request.url);
		}

		__proto._LoaderError=function(fileread){
			this.dispatchEvent(new IOErrorEvent(/*iflash.events.IOErrorEvent.IO_ERROR*/"ioError"));
		}

		__proto._Loader=function(fileread){
			if(fileread.contentType=="swf"){
				var bytes=new ByteArray();
				bytes.writeUTF(fileread.contentType);
				bytes.writeUTF(fileread.url);
				fileread.contentdata.readBytes(bytes,bytes.position);
				bytes.position=0;
				this._input=bytes;
				bytes=null;
				}else{
				fileread.contentdata.position=0;
				this._input=fileread.contentdata;
			}
			this.dispatchEvent(new Event(/*iflash.events.Event.COMPLETE*/"complete"));
		}

		__proto.readBoolean=function(){
			return this._input.readBoolean();
		}

		__proto.readByte=function(){
			return this._input.readByte();
		}

		__proto.readBytes=function(bytes,offset,length){
			(offset===void 0)&& (offset=0);
			(length===void 0)&& (length=0);
			return this._input.readBytes(bytes);
		}

		__proto.readDouble=function(){
			return this._input.readDouble();
		}

		__proto.readFloat=function(){
			return this._input.readFloat();
		}

		__proto.readInt=function(){
			return this._input.readInt();
		}

		__proto.readMultiByte=function(length,charSet){
			return this._input.readMultiByte(length,charSet);
		}

		__proto.readObject=function(){
			return this._input.readObject();
		}

		__proto.readShort=function(){
			return this._input.readShort();
		}

		__proto.readUnsignedByte=function(){
			return this._input.readUnsignedByte();
		}

		__proto.readUnsignedInt=function(){
			return this._input.readUnsignedInt();
		}

		__proto.readUnsignedShort=function(){
			return this._input.readUnsignedShort();
		}

		__proto.readUTF=function(){
			return this._input.readUTF();
		}

		__proto.readUTFBytes=function(length){
			return this._input.readUTFBytes(length);
		}

		__getset(0,__proto,'bytesAvailable',function(){
			if(this._input.bytesAvailable==0){
				this._input.position=0;
			}
			return this._input.bytesAvailable;
		});

		__getset(0,__proto,'connected',LAYAFNFALSE/*function(){return false}*/);
		__getset(0,__proto,'endian',function(){
			return this._input.endian;
			},function(type){
			this._input.endian=type;
		});

		__getset(0,__proto,'objectEncoding',function(){
			return this._input.objectEncoding;
			},function(version){
			this._input.objectEncoding=version;
		});

		return URLStream;
	})(EventDispatcher)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/sensors/accelerometer.as
	//class iflash.sensors.Accelerometer extends iflash.events.EventDispatcher
	var Accelerometer=(function(_super){
		function Accelerometer(){
			this._useCount=0;
			this._interval=30;
			this._curTimestamp=0;
			Accelerometer.__super.call(this);
		}

		__class(Accelerometer,'iflash.sensors.Accelerometer',false,_super);
		var __proto=Accelerometer.prototype;
		__proto.setRequestedUpdateInterval=function(interval){
			this._interval=interval;
		}

		__proto.addEventListener=function(type,listener,useCapture,priority,useWeakReference){
			(useCapture===void 0)&& (useCapture=false);
			(priority===void 0)&& (priority=0);
			(useWeakReference===void 0)&& (useWeakReference=false);
			_super.prototype.addEventListener.call(this,type,listener,useCapture,priority,useWeakReference);
			if(this._useCount==0){
				Accelerometer.acceptSysOrientationListener();
			}
			if(Accelerometer._accList.indexOf(this)==-1){
				Accelerometer._accList.push(this);
				this._useCount++;
			}
		}

		__proto.removeEventListener=function(type,listener,useCapture){
			(useCapture===void 0)&& (useCapture=false);
			_super.prototype.removeEventListener.call(this,type,listener,useCapture);
			var index=Accelerometer._accList.indexOf(this);
			if(index!=-1){
				Accelerometer._accList.splice(index,1);
				this._useCount--;
			}
			if(this._useCount==0){
				Accelerometer.removeSysOrientationListener();
			}
		}

		__proto.dispatchAccEvent=function(e){
			if(e.timestamp-this._curTimestamp>this._interval){
				this.dispatchEvent(e);
				this._curTimestamp=e.timestamp;
			}
		}

		__getset(0,__proto,'muted',function(){
			return false;
		});

		__getset(1,Accelerometer,'isSupported',function(){
			if(Browser.window.DeviceMotionEvent)
				return true;
			return false;
		},iflash.events.EventDispatcher._$SET_isSupported);

		Accelerometer.orientationListener=function(e){
			var e=AccelerometerEvent.copySysEvent(e);
			var ar;
			/*for each*/for(var $each_ar in Accelerometer._accList){
				ar=Accelerometer._accList[$each_ar];
				ar.dispatchAccEvent(e);
			}
		}

		Accelerometer.acceptSysOrientationListener=function(){
			Browser.window.addEventListener('devicemotion',Accelerometer.orientationListener,false);
		}

		Accelerometer.removeSysOrientationListener=function(){
			Browser.window.removeEventListener('devicemotion',Accelerometer.orientationListener,false);
		}

		Accelerometer._accList=[];
		return Accelerometer;
	})(EventDispatcher)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/sensors/geolocation.as
	//class iflash.sensors.Geolocation extends iflash.events.EventDispatcher
	var Geolocation=(function(_super){
		function Geolocation(target){
			this.preTime=0;
			this._muted=true;
			this._isFirstStatu=true;
			this._listenID=NaN;
			this._inteval=10;
			Geolocation.__super.call(this,target);
		}

		__class(Geolocation,'iflash.sensors.Geolocation',false,_super);
		var __proto=Geolocation.prototype;
		__proto.positionGet=function(pos){
			this.muteds=false;
			var tTime=DebugTools.getTTime();
			if(tTime-this.preTime>this._inteval){
				var evt;
				evt=GeolocationEvent.getFromH5Event(pos.coords);
				evt.timestamp=pos.timestamp;
				this.dispatchEvent(evt);
				this.preTime=tTime;
				}else{
			}
		}

		__proto.positionFail=function(error){
			switch(error.code){
				case 0:
					break ;
				case 1:
					break ;
				case 2:
					break ;
				case 3:
					break ;
				}
			this.muteds=true;
		}

		__proto.beginGetPosition=function(){
			this.stopGetPostion();
			this._listenID=Browser.navigator.geolocation.watchPosition(__bind(this,this.positionGet),__bind(this,this.positionFail));
		}

		__proto.stopGetPostion=function(){
			Browser.navigator.geolocation.clearWatch(this._listenID);
		}

		__proto.addEventListener=function(type,listener,useCapture,priority,useWeakReference){
			(useCapture===void 0)&& (useCapture=false);
			(priority===void 0)&& (priority=0);
			(useWeakReference===void 0)&& (useWeakReference=false);
			_super.prototype.addEventListener.call(this,type,listener,useCapture,priority,useWeakReference);
			if(type==/*iflash.events.GeolocationEvent.UPDATE*/"update"){
				this.beginGetPosition();
			}
		}

		__proto.removeEventListener=function(type,listener,useCapture){
			(useCapture===void 0)&& (useCapture=false);
			_super.prototype.removeEventListener.call(this,type,listener,useCapture);
			if(type==/*iflash.events.GeolocationEvent.UPDATE*/"update"){
				this.stopGetPostion();
			}
		}

		__proto.setRequestedUpdateInterval=function(interval){
			(interval===void 0)&& (interval=500);
			this._inteval=interval;
			return;
		}

		__getset(0,__proto,'muted',function(){
			return this._muted;
		});

		__getset(0,__proto,'muteds',null,function(value){
			if((value!=this._muted)||this._isFirstStatu){
				var evt=new StatusEvent(/*iflash.events.StatusEvent.STATUS*/"status");
				this._muted=value;
				this.dispatchEvent(evt);
				this._isFirstStatu=false;
			}
		});

		__getset(1,Geolocation,'isSupported',function(){
			return Browser.navigator.geolocation;
		},iflash.events.EventDispatcher._$SET_isSupported);

		return Geolocation;
	})(EventDispatcher)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/filesystem/fileevent.as
	//class iflash.filesystem.FileEvent extends iflash.events.Event
	var FileEvent=(function(_super){
		function FileEvent(type,bubbles,cancelable,_d){
			(bubbles===void 0)&& (bubbles=false);
			(cancelable===void 0)&& (cancelable=false);
			FileEvent.__super.call(this,type,bubbles,cancelable,_d);
		}

		__class(FileEvent,'iflash.filesystem.FileEvent',false,_super);
		FileEvent.FILE_STATUS="fileStatus";
		return FileEvent;
	})(Event)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/system/ime.as
	//class iflash.system.IME extends iflash.events.EventDispatcher
	var IME=(function(_super){
		function IME(target){
			IME.__super.call(this,target);
		}

		__class(IME,'iflash.system.IME',false,_super);
		__getset(1,IME,'conversionMode',function(){
			return "";
			},function(mode){
		});

		__getset(1,IME,'enabled',function(){
			return false;
			},function(enabled){
		});

		__getset(1,IME,'isSupported',function(){
			return false;
		},iflash.events.EventDispatcher._$SET_isSupported);

		return IME;
	})(EventDispatcher)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/text/stylesheet.as
	//class iflash.text.StyleSheet extends iflash.events.EventDispatcher
	var StyleSheet=(function(_super){
		function StyleSheet(){
			StyleSheet.__super.call(this);
		}

		__class(StyleSheet,'iflash.text.StyleSheet',false,_super);
		var __proto=StyleSheet.prototype;
		__proto.clear=LAYAFNVOID/*function(){}*/
		__proto.getStyle=LAYAFNNULL/*function(styleName){return null}*/
		__proto.parseCSS=LAYAFNVOID/*function(CSSText){}*/
		__proto.setStyle=LAYAFNVOID/*function(styleName,styleObject){}*/
		__proto.transform=LAYAFNNULL/*function(formatObject){return null}*/
		__getset(0,__proto,'styleNames',LAYAFNNULL/*function(){return null}*/);
		return StyleSheet;
	})(EventDispatcher)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/filters/bevelfilter.as
	//class iflash.filters.BevelFilter extends iflash.filters.BitmapFilter
	var BevelFilter=(function(_super){
		function BevelFilter(distance,angle,highlightColor,highlightAlpha,shadowColor,shadowAlpha,blurX,blurY,strength,quality,type,knockout){
			this.angle=NaN;
			this.blurX=NaN;
			this.blurY=NaN;
			this.distance=NaN;
			this.highlightAlpha=NaN;
			this.highlightColor=0;
			this.knockout=false;
			this.quality=0;
			this.shadowAlpha=NaN;
			this.shadowColor=0;
			this.strength=NaN;
			this.type=null;
			(distance===void 0)&& (distance=0);
			(angle===void 0)&& (angle=0);
			(highlightColor===void 0)&& (highlightColor=0xFF);
			(highlightAlpha===void 0)&& (highlightAlpha=1);
			(shadowColor===void 0)&& (shadowColor=0);
			(shadowAlpha===void 0)&& (shadowAlpha=1);
			(blurX===void 0)&& (blurX=4);
			(blurY===void 0)&& (blurY=4);
			(strength===void 0)&& (strength=1);
			(quality===void 0)&& (quality=1);
			(type===void 0)&& (type="full");
			(knockout===void 0)&& (knockout=false);
			BevelFilter.__super.call(this,"BevelFilter");
			this.distance=distance;
			this.angle=angle;
			this.highlightColor=highlightColor;
			this.highlightAlpha=highlightAlpha;
			this.shadowColor=shadowColor;
			this.shadowAlpha=shadowAlpha;
			this.blurX=blurX;
			this.blurY=blurY;
			this.strength=strength;
			this.quality=quality;
			this.type=type;
			this.knockout=knockout;
		}

		__class(BevelFilter,'iflash.filters.BevelFilter',false,_super);
		return BevelFilter;
	})(BitmapFilter)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/filters/blurfilter.as
	//class iflash.filters.BlurFilter extends iflash.filters.BitmapFilter
	var BlurFilter=(function(_super){
		function BlurFilter(inBlurX,inBlurY,inQuality){
			this.blurX=NaN;
			this.blurY=NaN;
			this.quality=0;
			this.MAX_BLUR_WIDTH=0;
			this.MAX_BLUR_HEIGHT=0;
			this.__bG=null;
			this.__kernel=null;
			(inBlurX===void 0)&& (inBlurX=4);
			(inBlurY===void 0)&& (inBlurY=4);
			(inQuality===void 0)&& (inQuality=1);
			BlurFilter.__super .call(this,"BlurFilter");
			this.blurX=(inBlurX ? inBlurX :4.0);
			this.blurY=(inBlurY ? inBlurY :4.0);
			this.MAX_BLUR_WIDTH=Laya.window.innerWidth;
			this.MAX_BLUR_HEIGHT=Laya.window.innerHeight;
			this.quality=(inQuality ? inQuality :1);
		}

		__class(BlurFilter,'iflash.filters.BlurFilter',false,_super);
		var __proto=BlurFilter.prototype;
		__proto.applyFilter=function(inBitmapData,inRect,inPoint,inBitmapFilter){}
		__proto.clone=function(){
			return new BlurFilter (this.blurX,this.blurY,this.quality);
		}

		__proto.__applyFilter=function(surface){
			var ctx=surface.context;
			this.__kernel=new Array;
			if (surface.width==0 || surface.height==0)return;
			var width=(surface.width > this.MAX_BLUR_WIDTH)? this.MAX_BLUR_WIDTH :surface.width;
			var height=(surface.height > this.MAX_BLUR_HEIGHT)? this.MAX_BLUR_HEIGHT :surface.height;
		}

		__proto.__buildKernel=function(src,srcW,srcH,dst){
			var i=0,j=0,tot=[],maxW=srcW *4;
			for (var y=0;y < srcH;y++){
				for (var x=0;x < srcW;x++){
					tot[0]=src[j];
					tot[1]=src[j+1];
					tot[2]=src[j+2];
					tot[3]=src[j+3];
					if (x > 0){
						tot[0]+=dst[i-4];
						tot[1]+=dst[i-3];
						tot[2]+=dst[i-2];
						tot[3]+=dst[i-1];
					}
					if (y > 0){
						tot[0]+=dst[i-maxW];
						tot[1]+=dst[i+1-maxW];
						tot[2]+=dst[i+2-maxW];
						tot[3]+=dst[i+3-maxW];
					}
					if (x > 0 && y > 0){
						tot[0]-=dst[i-maxW-4];
						tot[1]-=dst[i-maxW-3];
						tot[2]-=dst[i-maxW-2];
						tot[3]-=dst[i-maxW-1];
					}
					dst[i]=tot[0];
					dst[i+1]=tot[1];
					dst[i+2]=tot[2];
					dst[i+3]=tot[3];
					i+=4;
					j+=4;
				}
			}
		}

		__proto.__boxBlur=function(dst,srcW,srcH,p,boxW,boxH){
			var mul1=1.0 / ((boxW *2+1)*(boxH *2+1)),i=0,tot=[],h1=0,l1=0,h2=0,l2=0;
			var mul2=1.7 / ((boxW *2+1)*(boxH *2+1));
			for (var y=0;y < srcH;y++){
				for (var x=0;x < srcW;x++){
					if (x+boxW >=srcW)h1=srcW-1;else h1=(x+boxW);
					if (y+boxH >=srcH)l1=srcH-1;else l1=(y+boxH);
					if (x-boxW < 0)h2=0;else h2=(x-boxW);
					if (y-boxH < 0)l2=0;else l2=(y-boxH);
					tot[0]=p[(h1+l1 *srcW)*4]+p[(h2+l2 *srcW)*4]-p[(h2+l1 *srcW)*4]-p[(h1+l2 *srcW)*4];
					tot[1]=p[(h1+l1 *srcW)*4+1]+p[(h2+l2 *srcW)*4+1]-p[(h2+l1 *srcW)*4+1]-p[(h1+l2 *srcW)*4+1];
					tot[2]=p[(h1+l1 *srcW)*4+2]+p[(h2+l2 *srcW)*4+2]-p[(h2+l1 *srcW)*4+2]-p[(h1+l2 *srcW)*4+2];
					tot[3]=p[(h1+l1 *srcW)*4+3]+p[(h2+l2 *srcW)*4+3]-p[(h2+l1 *srcW)*4+3]-p[(h1+l2 *srcW)*4+3];
					dst[i]=Math.floor (Math.abs((255-this.__bG[0])-tot[0] *mul1));
					dst[i+1]=Math.floor (Math.abs((255-this.__bG[1])-tot[1] *mul1));
					dst[i+2]=Math.floor (Math.abs((255-this.__bG[2])-tot[2] *mul1));
					dst[i+3]=Math.floor (tot[3] *mul2);
					i+=4;
				}
			}
		}

		return BlurFilter;
	})(BitmapFilter)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/filters/colormatrixfilter.as
	//class iflash.filters.ColorMatrixFilter extends iflash.filters.BitmapFilter
	var ColorMatrixFilter=(function(_super){
		function ColorMatrixFilter(matrix){
			this.matrix=null;
			ColorMatrixFilter.__super.call(this,"ColorMatrixFilter");
			this.matrix=matrix;
		}

		__class(ColorMatrixFilter,'iflash.filters.ColorMatrixFilter',false,_super);
		var __proto=ColorMatrixFilter.prototype;
		__proto.clone=function(){
			return new ColorMatrixFilter(this.matrix);
		}

		__proto.__applyFilter=function(src){
			return;
			var ctx=src.context;
			var imagedata=ctx.getImageData(0,0,src.width,src.height);
			var offsetX=0;
			for (var i=0,sz=imagedata.data.length >> 2;i < sz;i++){
				offsetX=i *4;
				var srcR=imagedata.data[offsetX];
				var srcG=imagedata.data[offsetX+1];
				var srcB=imagedata.data[offsetX+2];
				var srcA=imagedata.data[offsetX+3];
				imagedata.data[offsetX]=int((this.matrix[0] *srcR)+(this.matrix[1] *srcG)+(this.matrix[2] *srcB)+(this.matrix[3] *srcA)+this.matrix[4]);
				imagedata.data[offsetX+1]=int((this.matrix[5] *srcR)+(this.matrix[6] *srcG)+(this.matrix[7] *srcB)+(this.matrix[8] *srcA)+this.matrix[9]);
				imagedata.data[offsetX+2]=int((this.matrix[10] *srcR)+(this.matrix[11] *srcG)+(this.matrix[12] *srcB)+(this.matrix[13] *srcA)+this.matrix[14]);
				imagedata.data[offsetX+3]=int((this.matrix[15] *srcR)+(this.matrix[16] *srcG)+(this.matrix[17] *srcB)+(this.matrix[18] *srcA)+this.matrix[19]);
			}
			ctx.putImageData(imagedata,0,0);
		}

		return ColorMatrixFilter;
	})(BitmapFilter)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/filters/convolutionfilter.as
	//class iflash.filters.ConvolutionFilter extends iflash.filters.BitmapFilter
	var ConvolutionFilter=(function(_super){
		function ConvolutionFilter(matrixX,matrixY,matrix,divisor,bias,preserveAlpha,clamp,color,alpha){
			this.alpha=NaN;
			this.bias=NaN;
			this.clamp=false;
			this.color=0;
			this.divisor=NaN;
			this.matrix=null;
			this.matrixX=NaN;
			this.matrixY=NaN;
			this.preserveAlpha=false;
			(matrixX===void 0)&& (matrixX=0);
			(matrixY===void 0)&& (matrixY=0);
			(divisor===void 0)&& (divisor=1);
			(bias===void 0)&& (bias=0);
			(preserveAlpha===void 0)&& (preserveAlpha=true);
			(clamp===void 0)&& (clamp=true);
			(color===void 0)&& (color=0);
			(alpha===void 0)&& (alpha=0);
			ConvolutionFilter.__super.call(this,"ConvolutionFilter");
			this.matrixX=matrixX;
			this.matrixY=matrixY;
			this.matrix=matrix;
			this.divisor=divisor;
			this.preserveAlpha=preserveAlpha;
			this.clamp=clamp;
			this.color=color;
			this.alpha=alpha;
		}

		__class(ConvolutionFilter,'iflash.filters.ConvolutionFilter',false,_super);
		return ConvolutionFilter;
	})(BitmapFilter)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/filters/displacementmapfilter.as
	//class iflash.filters.DisplacementMapFilter extends iflash.filters.BitmapFilter
	var DisplacementMapFilter=(function(_super){
		function DisplacementMapFilter(mapBitmap,mapPoint,componentX,componentY,scaleX,scaleY,mode,color,alpha){
			this.alpha=NaN;
			this.color=0;
			this.componentX=0;
			this.componentY=0;
			this.mapBitmap=null;
			this.mapPoint=null;
			this.mode=null;
			this.scaleX=NaN;
			this.scaleY=NaN;
			(componentX===void 0)&& (componentX=0);
			(componentY===void 0)&& (componentY=0);
			(scaleX===void 0)&& (scaleX=0);
			(scaleY===void 0)&& (scaleY=0);
			(color===void 0)&& (color=0);
			(alpha===void 0)&& (alpha=0);
			DisplacementMapFilter.__super.call(this,"DisplacementMapFilter");
			this.mapBitmap=mapBitmap;
			this.mapPoint=mapPoint;
			this.componentY=componentY;
			this.scaleX=scaleX;
			this.scaleY=scaleY;
			this.mode=mode;
			this.color=color;
			this.alpha=alpha;
		}

		__class(DisplacementMapFilter,'iflash.filters.DisplacementMapFilter',false,_super);
		return DisplacementMapFilter;
	})(BitmapFilter)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/filters/dropshadowfilter.as
	//class iflash.filters.DropShadowFilter extends iflash.filters.BitmapFilter
	var DropShadowFilter=(function(_super){
		function DropShadowFilter(in_distance,in_angle,in_color,in_alpha,in_blurX,in_blurY,in_strength,in_quality,in_inner,in_knockout,in_hideObject){
			this.alpha=NaN;
			this.angle=NaN;
			this.blurX=NaN;
			this.blurY=NaN;
			this.color=0;
			this.distance=NaN;
			this.hideObject=false;
			this.inner=false;
			this.knockout=false;
			this.quality=0;
			this.strength=NaN;
			(in_distance===void 0)&& (in_distance=4.0);
			(in_angle===void 0)&& (in_angle=45.0);
			(in_color===void 0)&& (in_color=0);
			(in_alpha===void 0)&& (in_alpha=1.0);
			(in_blurX===void 0)&& (in_blurX=4.0);
			(in_blurY===void 0)&& (in_blurY=4.0);
			(in_strength===void 0)&& (in_strength=1.0);
			(in_quality===void 0)&& (in_quality=1);
			(in_inner===void 0)&& (in_inner=false);
			(in_knockout===void 0)&& (in_knockout=false);
			(in_hideObject===void 0)&& (in_hideObject=false);
			DropShadowFilter.__super.call(this,"DropShadowFilter");
			this.distance=in_distance;
			this.angle=in_angle;
			this.color=in_color;
			this.alpha=in_alpha;
			this.blurX=in_blurX;
			this.blurY=in_blurX;
			this.strength=in_strength;
			this.quality=in_quality;
			this.inner=in_inner;
			this.knockout=in_knockout;
			this.hideObject=in_hideObject;
		}

		__class(DropShadowFilter,'iflash.filters.DropShadowFilter',false,_super);
		var __proto=DropShadowFilter.prototype;
		__proto.clone=function(){
			return new DropShadowFilter(this.distance,this.angle,this.color,this.alpha,this.blurX,this.blurY,this.strength,this.quality,this.inner,this.knockout,this.hideObject);
		}

		__proto.__preApplyFilter=function(dec){
			var distanceX=this.distance *Math.sin(2 *Math.PI *this.angle / 360.0);
			var distanceY=this.distance *Math.cos(2 *Math.PI *this.angle / 360.0);
			var blurRadius=Math.max(this.blurX,this.blurY,this.strength);
			dec.shadowOffsetX=distanceX;
			dec.shadowOffsetY=distanceY;
			dec.shadowBlur=blurRadius;
			dec.shadowColor="rgba("+((this.color >> 16)& 0xFF)+","+((this.color >> 8)& 0xFF)+","+(this.color & 0xFF)+","+this.alpha+")";
		}

		DropShadowFilter.DEGREES_FULL_RADIUS=360.0;
		return DropShadowFilter;
	})(BitmapFilter)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/mx/core/bytearrayasset.as
	//class mx.core.ByteArrayAsset extends iflash.utils.ByteArray
	var ByteArrayAsset=(function(_super){
		function ByteArrayAsset(){
			ByteArrayAsset.__super.call(this);
			console.log("ByteArrayAsset");
		}

		__class(ByteArrayAsset,'mx.core.ByteArrayAsset',false,_super);
		return ByteArrayAsset;
	})(ByteArray)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/filters/gradientbevelfilter.as
	//class iflash.filters.GradientBevelFilter extends iflash.filters.BitmapFilter
	var GradientBevelFilter=(function(_super){
		function GradientBevelFilter(distance,angle,colors,alphas,ratios,blurX,blurY,strength,quality,type,knockout){
			this.alphas=null;
			this.angle=NaN;
			this.blurX=NaN;
			this.blurY=NaN;
			this.colors=null;
			this.distance=NaN;
			this.knockout=false;
			this.quality=0;
			this.ratios=null;
			this.strength=NaN;
			this.type=null;
			(distance===void 0)&& (distance=4);
			(angle===void 0)&& (angle=45);
			(blurX===void 0)&& (blurX=4);
			(blurY===void 0)&& (blurY=4);
			(strength===void 0)&& (strength=1);
			(quality===void 0)&& (quality=1);
			(type===void 0)&& (type="inner");
			(knockout===void 0)&& (knockout=false);
			GradientBevelFilter.__super.call(this,"GradientBevelFilter");
			this.distance=distance;
			this.angle=angle;
			this.colors=colors;
			this.alphas=alphas;
			this.ratios=ratios;
			this.blurX=blurX;
			this.blurY=blurY;
			this.strength=strength;
			this.quality=quality;
			this.type=type;
			this.knockout=knockout;
		}

		__class(GradientBevelFilter,'iflash.filters.GradientBevelFilter',false,_super);
		return GradientBevelFilter;
	})(BitmapFilter)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/filters/gradientglowfilter.as
	//class iflash.filters.GradientGlowFilter extends iflash.filters.BitmapFilter
	var GradientGlowFilter=(function(_super){
		function GradientGlowFilter(distance,angle,colors,alphas,ratios,blurX,blurY,strength,quality,type,knockout){
			this.alphas=null;
			this.angle=NaN;
			this.blurX=NaN;
			this.blurY=NaN;
			this.colors=null;
			this.distance=NaN;
			this.knockout=false;
			this.quality=0;
			this.ratios=null;
			this.strength=NaN;
			this.type=null;
			(distance===void 0)&& (distance=4);
			(angle===void 0)&& (angle=45);
			(blurX===void 0)&& (blurX=4);
			(blurY===void 0)&& (blurY=4);
			(strength===void 0)&& (strength=1);
			(quality===void 0)&& (quality=1);
			(type===void 0)&& (type="inner");
			(knockout===void 0)&& (knockout=false);
			GradientGlowFilter.__super.call(this,"GradientGlowFilter");
			this.distance=distance;
			this.colors=colors;
			this.alphas=alphas;
			this.ratios=ratios;
			this.blurX=blurX;
			this.blurY=blurY;
			this.strength=strength;
			this.quality=quality;
			this.type=type;
			this.knockout=knockout;
		}

		__class(GradientGlowFilter,'iflash.filters.GradientGlowFilter',false,_super);
		return GradientGlowFilter;
	})(BitmapFilter)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/runner/onecmddatauseid.as
	//class iflash.laya.runner.OneCmdDataUseId extends iflash.laya.runner.OneCmdData
	var OneCmdDataUseId=(function(_super){
		function OneCmdDataUseId(){
			this.id=null;
			OneCmdDataUseId.__super.call(this);
		}

		__class(OneCmdDataUseId,'iflash.laya.runner.OneCmdDataUseId',false,_super);
		var __proto=OneCmdDataUseId.prototype;
		__proto.applyTo=function(who,one){
			return this.oneFun._fun_.apply(one.ids[this.id],this.args);
		}

		return OneCmdDataUseId;
	})(OneCmdData)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/text/engine/graphicelement.as
	//class iflash.text.engine.GraphicElement extends iflash.text.engine.ContentElement
	var GraphicElement=(function(_super){
		function GraphicElement(__args){
			GraphicElement.__super.call(this);
			var args=arguments;return }
		__class(GraphicElement,'iflash.text.engine.GraphicElement',false,_super);
		var __proto=GraphicElement.prototype;
		__getset(0,__proto,'elementHeight',LAYAFN0/*function(){return 0}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'elementWidth',LAYAFN0/*function(){return 0}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'graphic',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(value){}*/);
		return GraphicElement;
	})(ContentElement)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/text/engine/groupelement.as
	//class iflash.text.engine.GroupElement extends iflash.text.engine.ContentElement
	var GroupElement=(function(_super){
		function GroupElement(__a){
			GroupElement.__super.call(this);
		}

		__class(GroupElement,'iflash.text.engine.GroupElement',false,_super);
		var __proto=GroupElement.prototype;
		__proto.getElementAt=LAYAFNNULL/*function(index){return null}*/
		__proto.getElementAtCharIndex=LAYAFNNULL/*function(charIndex){return null}*/
		__proto.getElementIndex=LAYAFN0/*function(element){return 0}*/
		__proto.groupElements=LAYAFNNULL/*function(beginIndex,endIndex){return null}*/
		__proto.mergeTextElements=LAYAFNNULL/*function(beginIndex,endIndex){return null}*/
		__proto.replaceElements=LAYAFNNULL/*function(beginIndex,endIndex,newElements){return null}*/
		__proto.setElements=LAYAFNVOID/*function(value){}*/
		__proto.splitTextElement=LAYAFNNULL/*function(elementIndex,splitIndex){return null}*/
		__proto.ungroupElements=LAYAFNVOID/*function(groupIndex){}*/
		__getset(0,__proto,'elementCount',LAYAFN0/*function(){return 0}*/);
		return GroupElement;
	})(ContentElement)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/text/engine/textelement.as
	//class iflash.text.engine.TextElement extends iflash.text.engine.ContentElement
	var TextElement=(function(_super){
		function TextElement(__a){
			TextElement.__super.call(this);
		}

		__class(TextElement,'iflash.text.engine.TextElement',false,_super);
		var __proto=TextElement.prototype;
		__proto.replaceText=LAYAFNVOID/*function(beginIndex,endIndex,newText){}*/
		__getset(0,__proto,'text',_super.prototype._$get_text,LAYAFNVOID/*function(value){}*/);
		return TextElement;
	})(ContentElement)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/text/engine/spacejustifier.as
	//class iflash.text.engine.SpaceJustifier extends iflash.text.engine.TextJustifier
	var SpaceJustifier=(function(_super){
		function SpaceJustifier(locale,lineJustification,letterSpacing){
			(locale===void 0)&& (locale="en");
			(lineJustification===void 0)&& (lineJustification="unjustified");
			(letterSpacing===void 0)&& (letterSpacing=false);
			SpaceJustifier.__super.call(this,locale,lineJustification);
		}

		__class(SpaceJustifier,'iflash.text.engine.SpaceJustifier',false,_super);
		var __proto=SpaceJustifier.prototype;
		__proto.clone=LAYAFNNULL/*function(){return null}*/
		__getset(0,__proto,'letterSpacing',LAYAFNFALSE/*function(){return false}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'maximumSpacing',LAYAFN0/*function(){return 0}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'minimumSpacing',LAYAFN0/*function(){return 0}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'optimumSpacing',LAYAFN0/*function(){return 0}*/,LAYAFNVOID/*function(value){}*/);
		return SpaceJustifier;
	})(TextJustifier)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/avm1movie.as
	//class iflash.display.AVM1Movie extends iflash.display.DisplayObject
	var AVM1Movie=(function(_super){
		function AVM1Movie(){
			AVM1Movie.__super.call(this);
		}

		__class(AVM1Movie,'iflash.display.AVM1Movie',false,_super);
		var __proto=AVM1Movie.prototype;
		__proto.addCallback=LAYAFNVOID/*function(functionName,closure){}*/
		__proto.call=function(functionName,__rest){}
		return AVM1Movie;
	})(DisplayObject)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/bitmap.as
	//class iflash.display.Bitmap extends iflash.display.DisplayObject
	var Bitmap=(function(_super){
		function Bitmap(bitmapData,pixelSnapping,smoothing){
			this._bitmapData_=null;
			this._setDraw_=false;
			this._scaleY_=1;
			this._scaleX_=1;
			(pixelSnapping===void 0)&& (pixelSnapping="auto");
			(smoothing===void 0)&& (smoothing=false);
			Bitmap.__super.call(this);
			bitmapData&&(this.bitmapData=bitmapData);
		}

		__class(Bitmap,'iflash.display.Bitmap',false,_super);
		var __proto=Bitmap.prototype;
		__proto._paintChild_=function(context,x,y,w,h){
			this._bitmapData_ && this._bitmapData_.paint(context,x,y,w,h);
		}

		__proto.lyclone=function(){
			var b=new Bitmap(this._bitmapData_);
			return b;
		}

		__getset(0,__proto,'bitmapData',function(){
			return this._bitmapData_;
			},function(value){
			if(value){
				this._bitmapData_=value;
				this._width_=Math.abs(this._bitmapData_.width*this._scaleX_);
				this._height_=Math.abs(this._bitmapData_.height *this._scaleY_);
				this._modle_.size(this._width_ ,this._height_);
				this._type2_ |=(0x1 | 0x4);
				if (Laya.RENDERBYCANVAS && !this._setDraw_){
					this._setDraw_=true;
					DisplayUnit._insertUnit_(this,DrawBitmapData._DEFAULT_);
				}
				else if (!Laya.RENDERBYCANVAS){
					this.bitmapData._createCMD_();
					if(this.bitmapData.type==/*iflash.display.BitmapData.CANVAS*/1){
						this._modle_.virtualBitmap(null);
						this._modle_["conchVirtualBitmap"]=null;
						this._modle_.image(this.bitmapData._canvas_,true)
					}
					else{
						this._modle_.image(null);
						this._modle_.vcanvas(this.bitmapData._canvas_);
					}
				}
			}
			else if(this._bitmapData_){
				this._bitmapData_=value;
				if(!Laya.RENDERBYCANVAS){
					this._modle_.virtualBitmap(null);
					this._modle_["conchVirtualBitmap"]=null;
				}
			}
		});

		__getset(0,__proto,'isReadyForDraw',function(){
			return this.bitmapData!=null;
		});

		__getset(0,__proto,'width',_super.prototype._$get_width,function(w){
			if(this._width_==w)return;
			var oldW=this._width_/this._scaleX_;
			oldW &&(this._scaleX_=w / oldW);
			this._width_=Math.abs(w);
			this._modle_.size(this._width_,this._height_);
			this._type2_ |=(0x1 | 0x4);
		});

		__getset(0,__proto,'height',_super.prototype._$get_height,function(h){
			if(this._height_==h)
				return;
			var oldH=this._height_/this._scaleY_;
			oldH &&(this._scaleY_=h / oldH);
			this._height_=Math.abs(h);
			this._modle_.size(this._width_,this._height_);
			this._type2_ |=(0x1 | 0x4);
		});

		__getset(0,__proto,'pixelSnapping',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'scaleX',function(){
			return this._scaleX_
			},function(value){
			var oldW=NaN;
			if(this._width_*this._scaleX_==0&&this.bitmapData)oldW=this.bitmapData.width;
			else oldW=this._width_/this._scaleX_;
			this._scaleX_=value;
			this._width_=Math.abs(oldW *value);
			this._modle_.size(this._width_,this._height_);
			_super.prototype._$set_scaleX.call(this,this._scaleX_>0?1:-1);
		});

		__getset(0,__proto,'scaleY',function(){
			return this._scaleY_;
			},function(value){
			var oldH=NaN
			if(this._height_*this._scaleY_==0&&this.bitmapData)oldH=this.bitmapData.height;
			else oldH=this._height_/this._scaleY_;
			this._scaleY_=value;
			this._height_=Math.abs(oldH *value);
			this._modle_.size(this._width_,this._height_);
			_super.prototype._$set_scaleY.call(this,this._scaleY_>0?1:-1);
		});

		__getset(0,__proto,'smoothing',LAYAFNFALSE/*function(){return false}*/,LAYAFNVOID/*function(value){}*/);
		return Bitmap;
	})(DisplayObject)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/interactiveobject.as
	//class iflash.display.InteractiveObject extends iflash.display.DisplayObject
	var InteractiveObject=(function(_super){
		function InteractiveObject(){
			InteractiveObject.__super.call(this);
		}

		__class(InteractiveObject,'iflash.display.InteractiveObject',false,_super);
		var __proto=InteractiveObject.prototype;
		__proto.changeFocus=function(){
			if(this.stage==null)return;
			if(this.stage.focus!=this){
				this.repaint();
			}
		}

		__proto.repaint=function(){}
		__proto._hitTest_=function(_x,_y){
			var target=_super.prototype._hitTest_.call(this,_x,_y);
			if(target){
				return this.mouseEnabled?this:this.parent;
			}
			return null;
		}

		__getset(0,__proto,'mouseEnabled',function(){
			return (this._type_&0x40)!=0;
			},function(value){
			if(value)
				this._type_|=0x40;
			else
			this._type_&=~0x40;
		});

		__getset(0,__proto,'tabIndex',LAYAFN0/*function(){return 0}*/,LAYAFNVOID/*function(param1){}*/);
		__getset(0,__proto,'doubleClickEnabled',function(){
			return (this._type_&0x100)!=0;
			},function(value){
			if(value)
				this._type_|=0x100;
			else
			this._type_&=~0x100;
		});

		__getset(0,__proto,'tabEnabled',LAYAFNFALSE/*function(){return false}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'contextMenu',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(cm){}*/);
		return InteractiveObject;
	})(DisplayObject)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/lyimageelement.as
	//class iflash.display.LyImageElement extends iflash.display.DisplayObject
	var LyImageElement=(function(_super){
		function LyImageElement(){
			this.src=null;
			this.assetUr=null;
			this.assetConfig=null;
			this._texture=null;
			this._image_=null
			this._content_=null;
			this.scale9Data=null;
			this.orgW=NaN;
			this.orgH=NaN;
			this.arrX=null;
			this.arrY=null;
			this.arrW=null;
			this.arrH=null;
			this.oArrX=null;
			this.oArrY=null;
			this.oArrW=null;
			this.oArrH=null;
			this.miniBitmapData=new BitmapData();
			this._image_=Browser.document.createElement("image");LyImageElement.__super.call(this);}
		__class(LyImageElement,'iflash.display.LyImageElement',false,_super);
		var __proto=LyImageElement.prototype;
		__proto.checkImg=LAYAFNVOID/*function(){}*/
		__proto._paintChild_=function(context,x,y,w,h){
			var bitmapdata=this.miniBitmapData;
			bitmapdata && bitmapdata.paint && bitmapdata.paint.call(bitmapdata,context,x,y,w,h);
		}

		__proto._init_=function(){
			if ((this._type_ & 0x2000)!=0)return;
			if (Laya.RENDERBYCANVAS){
				DrawImageElement.insertUnit(this);
			}
			else{
				if(this._modle_==IModel.__DEFAULT__){
					this.__initModule();
				}
				this._modle_.size(this._width_,this._height_);
			}
			this.miniBitmapData.size(this._width_,this._height_);
			if (this.scale9Data){
				this.miniBitmapData.setImage(this._image_);
				this.miniBitmapData._canvas_.removeImage();
				this._modle_.vcanvas(this.miniBitmapData._canvas_);
			}
			else if (!this.assetConfig){
				this._modle_.image(this._image_);
				this.miniBitmapData.setImage(this._image_);
			}
			this._type_|=0x2000;
		}

		__proto.onLoad=function(__args){
			var args=arguments;
			this._type_|=0x800;
			this.dispatchEvent(new Event("lyImageLoadedEvent"));
			this.readyWork();
		}

		__proto.isReady=function(readyCallBack){
			if(this.isTexture())return true;
			if(!this._image_)return false;
			return this._image_.isReady();
		}

		__proto.isTexture=function(){
			return this.assetConfig!=null;
		}

		__proto._lyToBody_=function(){
			if(!(this._image_.isReady())){
				this._image_.onload=iflash.method.bind(this,this.onLoad);
			}
			else {
				if (!this.assetConfig){
					this.miniBitmapData&&!this.miniBitmapData._canvas_&&this.miniBitmapData.setImage(this._image_);
				}
				this._type_|=0x800;
			}
			if(this.assetConfig!=null&&this.miniBitmapData&&this._texture==null){
				this.initTexture();
			}
			if(!this.assetConfig&&!(this._image_.isReady())){
				this._image_.src=this.src;
			}
		}

		__proto.initTexture=function(){
			if(this._texture)return;
			var tImg;
			tImg=TextureManager.getInstance().getTexture(this.assetUr);
			this._texture=tImg;
			this.miniBitmapData.destroy();
			this.miniBitmapData._createCMD_();
			this.miniBitmapData._canvas_.drawImage(this.texture,this.assetConfig.x,this.assetConfig.y,this.assetConfig.width,this.assetConfig.height,0,0,this.assetConfig.width,this.assetConfig.height);
			this._modle_.vcanvas (this.miniBitmapData._canvas_);
			this._type_|=0x800;
		}

		__proto.calcScaleData=function(){
			var x1=this.scale9Data.x1-this.x;
			var y1=this.scale9Data.y1-this.y;
			var x2=this.scale9Data.x2-this.x;
			var y2=this.scale9Data.y2-this.y;
			if(this.arrX==null){
				this.arrX=[[],[],[]];
				this.arrY=[[],[],[]];
				this.arrW=[[],[],[]];
				this.arrH=[[],[],[]];
				this.oArrX=[[],[],[]];
				this.oArrY=[[],[],[]];
				this.oArrW=[[],[],[]];
				this.oArrH=[[],[],[]];
			};
			var orgW_x2=this.orgW-x2;
			this.oArrW[2][0]=this.oArrW[1][0]=this.oArrW[0][0]=x1;
			this.oArrW[2][1]=this.oArrW[1][1]=this.oArrW[0][1]=x2-x1;
			this.oArrW[2][2]=this.oArrW[1][2]=this.oArrW[0][2]=orgW_x2;
			var orgH_y2=this.orgH-y2;
			this.oArrH[0][2]=this.oArrH[0][1]=this.oArrH[0][0]=y1;
			this.oArrH[1][2]=this.oArrH[1][1]=this.oArrH[1][0]=y2-y1;
			this.oArrH[2][2]=this.oArrH[2][1]=this.oArrH[2][0]=orgH_y2;
			this.oArrX[2][0]=this.oArrX[1][0]=this.oArrX[0][0]=0;
			this.oArrX[2][1]=this.oArrX[1][1]=this.oArrX[0][1]=x1;
			this.oArrX[2][2]=this.oArrX[1][2]=this.oArrX[0][2]=x2;
			this.oArrY[0][2]=this.oArrY[0][1]=this.oArrY[0][0]=0;
			this.oArrY[1][2]=this.oArrY[1][1]=this.oArrY[1][0]=y1;
			this.oArrY[2][2]=this.oArrY[2][1]=this.oArrY[2][0]=y2;
			var w01_23=this.orgW-this.oArrW[2][1];
			var h01_23=this.orgH-this.oArrH[1][2];
			if(this.width < w01_23){
				var ssw=this.width/w01_23;
				var ssX1=x1 *ssw;
				this.arrX[2][0]=this.arrX[1][0]=this.arrX[0][0]=0;
				this.arrX[2][2]=this.arrX[1][2]=this.arrX[0][2]=this.arrX[2][1]=this.arrX[1][1]=this.arrX[0][1]=ssX1;
				this.arrW[2][0]=this.arrW[1][0]=this.arrW[0][0]=ssX1;
				this.arrW[2][1]=this.arrW[1][1]=this.arrW[0][1]=0;
				this.arrW[2][2]=this.arrW[1][2]=this.arrW[0][2]=this.width-ssX1;
			}
			else{
				this.arrX[2][0]=this.arrX[1][0]=this.arrX[0][0]=0;
				this.arrX[2][1]=this.arrX[1][1]=this.arrX[0][1]=x1;
				this.arrX[2][2]=this.arrX[1][2]=this.arrX[0][2]=this.width-orgW_x2;
				this.arrW[2][0]=this.arrW[1][0]=this.arrW[0][0]=x1;
				this.arrW[2][1]=this.arrW[1][1]=this.arrW[0][1]=this.width-x1-orgW_x2;
				this.arrW[2][2]=this.arrW[1][2]=this.arrW[0][2]=orgW_x2;
			}
			if(this.height < h01_23){
				var ssh=this.height/h01_23;
				var ssY1=y1 *ssh;
				this.arrY[0][2]=this.arrY[0][1]=this.arrY[0][0]=0;
				this.arrY[1][2]=this.arrY[1][1]=this.arrY[1][0]=this.arrY[2][2]=this.arrY[2][1]=this.arrY[2][0]=ssY1;
				this.arrH[0][2]=this.arrH[0][1]=this.arrH[0][0]=ssY1;
				this.arrH[1][2]=this.arrH[1][1]=this.arrH[1][0]=0;
				this.arrH[2][2]=this.arrH[2][1]=this.arrH[2][0]=this.height-ssY1;
			}
			else{
				this.arrY[0][2]=this.arrY[0][1]=this.arrY[0][0]=0;
				this.arrY[1][2]=this.arrY[1][1]=this.arrY[1][0]=y1;
				this.arrY[2][2]=this.arrY[2][1]=this.arrY[2][0]=this.height-orgH_y2;
				this.arrH[0][2]=this.arrH[0][1]=this.arrH[0][0]=y1;
				this.arrH[1][2]=this.arrH[1][1]=this.arrH[1][0]=this.height-y1-orgH_y2;
				this.arrH[2][2]=this.arrH[2][1]=this.arrH[2][0]=orgH_y2;
			}
			if (Laya.CONCHVER){
				var context=this.miniBitmapData._canvas_;
				context.clear();
				for(var i=0;i<3;i++){
					for(var j=0;j<3;j++){
						var u=this.oArrX[i][j],v=this.oArrY[i][j],www=this.oArrW[i][j],hhh=this.oArrH[i][j],
						xx=this.arrX[i][j],yy=this.arrY[i][j],ww=this.arrW[i][j],hh=this.arrH[i][j];
						if(www<1 || hhh<1 || ww<1 || hh<1)continue ;
						if(this.isTexture()){
							var uP=this.assetConfig.x;
							var vP=this.assetConfig.y;
							context.drawImage(this.texture,u+uP,v+vP,www,hhh,xx,yy,ww,hh);
						}
						else{
							context.drawImage(this._image_,u,v,www,hhh,xx,yy,ww,hh);
						}
					}
				}
			}
		}

		__proto.__preload__=function(){
			this._lyToBody_();
		}

		__proto.lyclone=function(){
			var result=new LyImageElement();
			result._image_=this._image_;
			result.orgW=this.orgW;
			result.orgH=this.orgH;
			result._width_=this.orgW;
			result._height_=this.orgH;
			result.src=this.src;
			result.assetConfig=this.assetConfig;
			result.assetUr=this.assetUr;
			return result;
		}

		__proto.layaDestory=function(){
			_super.prototype.layaDestory.call(this);
			this._image_ && (this._image_.onload !=null)&& (this._image_.onload=null);
			this._image_=null;
			this.miniBitmapData&&this.miniBitmapData.clear();
			this.miniBitmapData=null;
			this.scale9Data=null;
			this._texture=null;
		}

		__getset(0,__proto,'isReadyForDraw',function(){
			return this.isReady();
		});

		__getset(0,__proto,'width',function(){
			return this._width_
			},function(w){
			this._width_=w;
			this.scale9Data&&this.calcScaleData();
		});

		__getset(0,__proto,'texture',function(){
			if(this._texture==null){
				this.initTexture();
			}
			return this._texture;
		});

		__getset(0,__proto,'height',function(){
			return this._height_;
			},function(h){
			this._height_=h;
			this.scale9Data&&this.calcScaleData();
		});

		return LyImageElement;
	})(DisplayObject)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/shape.as
	//class iflash.display.Shape extends iflash.display.DisplayObject
	var Shape=(function(_super){
		function Shape(){
			this._sc9Y_=1;
			this._sc9X_=1;
			this._scaleY_=1;
			this._scaleX_=1;
			this._image_=null;
			this._content_=null;
			this._graphics=null;
			this._scale9Data=null;
			Shape.__super.call(this);
		}

		__class(Shape,'iflash.display.Shape',false,_super);
		var __proto=Shape.prototype;
		__proto._paintGraphics_=function(context,x,y,w,h){
			if (this._graphics){
				var grapics=this._graphics;
				if(grapics.isReady()){
					grapics._canvas_.paint(context,x,y,w,h);
				}
				this._paintChild_(context,x,y,w,h);
			}
			else
			this._paintChild_(context,x,y,w,h);
		}

		__proto._paintChild_=function(context,x,y,w,h){
			var data=this._image_;
			data&&(data.conchPaint(context,x+data._left_,y+data._top_));
		}

		__proto._init_=function(content){
			if (!content)
				return;
			this._content_=content;
			if(content.data.scale9Data){
				this._image_=content.data.lyclone();
				this._image_._width_=this._image_.orgW=content.data.width;
				this._image_._height_=this._image_.orgH=content.data.height;
				this.scale9Data=content.data.scale9Data.scale9Data;
			}
			else{
				this._image_=content.data;
			}
			if(DisplayObject.initModule){
				this._image_._init_();
				if(!this.scale9Data&&this._modle_.quoteEx)
					this._modle_.quoteEx(this._image_._modle_,true);
				else
				this._modle_.quote(this._image_._modle_);
				this._image_.matrix=content.matrix;
			}
			this._width_=content.data.width;
			this._height_=content.data.height;
			this._modle_.size(this._width_,this._height_);
			Laya.RENDERBYCANVAS && ((this._type_ & 0x4)==0)&& (DrawShape.insertUnit(this),this._type_ |=0x4);
		}

		__proto._getBounds_=function(targetSpace,resultRect){
			if (!targetSpace)
				targetSpace=this;
			if (!resultRect)
				resultRect=DisplayObject.HELPER_RECTANGLET;
			if (!this._image_){
				resultRect.setTo(0,0,0,0);
				DisplayObject.HELPER_POINT.setTo(0,0);
				resultRect.setTo(0,0,0,0);
			}
			else{
				resultRect.setTo(this._image_.x,this._image_.y,this._image_._width_ ,this._image_._height_);
			}
			if (this._graphics){
				DisplayObject.HELPER_RECTANGLET_ALT.setTo(this._graphics.x,this._graphics.y,this._graphics.width ,this._graphics.height);
				resultRect._union_(DisplayObject.HELPER_RECTANGLET_ALT);
			}
			return resultRect;
		}

		__proto._lyToBody_=function(){
			if(this.scale9Data){
				this._image_ &&(this._image_.scale9Data=this.scale9Data);
			}
			this._image_ && this._image_._lyToBody_();
			_super.prototype._lyToBody_.call(this);
		}

		__proto._lyUnToBody_=function(){
			this._image_ && (this._image_._lyUnToBody_());
			_super.prototype._lyUnToBody_.call(this);
		}

		__proto.lyclone=function(){
			var s=new Shape();
			s._init_(this._content_);
			return s;
		}

		__proto.setupReadyNoticeWork=function(ifSelfNotice){
			(ifSelfNotice===void 0)&& (ifSelfNotice=false);
			if(this.isReadyForDraw)return;
			this._needNotice=ifSelfNotice;
			this._image_.setReadyForDrawCall(__bind(this,this.readyWork));
		}

		__proto.layaDestory=function(){
			_super.prototype.layaDestory.call(this);
			this._content_=null;
			this._image_=null;
			this._scale9Data=null;
		}

		__getset(0,__proto,'isReadyForDraw',function(){
			return this._image_.isReadyForDraw;
		});

		__getset(0,__proto,'scale9Data',function(){
			return this._scale9Data;
			},function(value){
			this._scale9Data=value;
			if (this._image_){
				this._image_.scale9Data=value;
				this._image_._modle_.image(null);
				if(this._image_.miniBitmapData._canvas_)
					this._image_._modle_.vcanvas(this._image_.miniBitmapData._canvas_);
			}
		});

		__getset(0,__proto,'width',function(){
			return this.scale9Data?this._width_:_super.prototype._$get_width.call(this);
			},function(w){
			if (this._width_==w)
				return;
			if(this.scale9Data){
				this._scaleX_=1;
				this._width_=w;
				this._image_&&(this._image_.width=w);
				return;
			};
			var oldW=this._width_ / this._scaleX_;
			if (this._width_ *this._scaleX_==0 && this.graphics)
				oldW=this.graphics.width;
			oldW && (this._scaleX_=w / oldW);
			_super.prototype._$set_scaleX.call(this,this._scaleX_);
			this._modle_.size(this._width_,this._height_);
			this._type2_ |=(0x1 | 0x4);
		});

		__getset(0,__proto,'graphics',function(){
			if (!this._graphics)
				this._graphics=new Graphics(this);
			return this._graphics;
		});

		__getset(0,__proto,'height',function(){
			return this.scale9Data?this._height_:_super.prototype._$get_height.call(this);
			},function(h){
			if (this._height_==h)
				return;
			if(this.scale9Data){
				this._scaleY_=1;
				this._height_=h;
				this._image_&&(this._image_.height=h);
				this._modle_.size(this._width_,this._height_);
				this._type2_ |=(0x1 | 0x4);
				return;
			};
			var oldH=NaN;
			if (this._height_ *this._scaleY_==0 && this.graphics)
				oldH=this.graphics.height;
			else
			oldH=this._height_ / this._scaleY_;
			oldH && (this._scaleY_=h / oldH);
			_super.prototype._$set_scaleY.call(this,this._scaleY_);
			this._modle_.size(this._width_,this._height_);
			this._type2_ |=(0x1 | 0x4);
		});

		__getset(0,__proto,'scaleX',function(){
			return this.scale9Data?this._sc9X_:this._scaleX_;
			},function(value){
			var oldW=NaN;
			if (this._width_ *this._scaleX_==0 && this.graphics)
				oldW=this.graphics.width;
			else
			oldW=this._width_ / this._scaleX_;
			this._width_=Math.abs(oldW *value);
			if(this.scale9Data)
			{_super.prototype._$set_scaleX.call(this,this._scaleX_=1);
				this._image_&&(this._image_.width=this._width_);
				this._sc9X_=value;
				return;
			}
			this._scaleX_=value;
			this._modle_.size(this._width_,this._height_);
			_super.prototype._$set_scaleX.call(this,this._scaleX_);
			this._type2_ |=(0x1 | 0x4);
		});

		__getset(0,__proto,'scaleY',function(){
			return this.scale9Data?this._sc9Y_:this._scaleY_;
			},function(value){
			var oldH=NaN;
			if (this._height_ *this._scaleY_==0 && this.graphics)
				oldH=this.graphics.height;
			else
			oldH=this._height_ / this._scaleY_;
			this._height_=Math.abs(oldH *value);
			if(this.scale9Data){
				_super.prototype._$set_scaleX.call(this,this._scaleY_=1);
				this._image_&&(this._image_.height=this._height_);
				this._sc9Y_=value;
				return;
			}
			this._scaleY_=value;
			this._modle_.size(this._width_,this._height_);
			_super.prototype._$set_scaleY.call(this,this._scaleY_);
			this._type2_ |=(0x1 | 0x4);
		});

		return Shape;
	})(DisplayObject)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/laya/body.as
	//class iflash.laya.Body extends iflash.display.DisplayObject
	var Body=(function(_super){
		function Body(){
			this._stage_=null;
			Body.__super.call(this);
			this._stage_=Stage.stage;
			this._modle_.insert(this._stage_._modle_,0,1);
			if(Laya.CONCHVER){
				var editborder;
				/*__JS__ */conch.editborder=editborder=conch.createNode();
				this._modle_.insert(editborder,1,2);
				editborder.border("#28FFFA");
				editborder.bgcolor("#FFFFFF");
				editborder.show(false);
			}
			Laya.CONCHVER&&/*__JS__ */conch.setRootNode(this._modle_);
		}

		__class(Body,'iflash.laya.Body',false,_super);
		var __proto=Body.prototype;
		__proto._lyPaint_=function(context,x,y){
			var m=this.matrix;
			if (!m || !m.isTransform()){
				context.beginPath();
				if(Stage.stage.scaleMode==/*iflash.display.StageScaleMode.NO_SCALE*/"noScale"){
					context.rect(0,0,Stage.stage.stageWidth,Stage.stage.stageHeight);
				}
				else{
					context.rect(this._left_,this._top_,Stage.stage.width,Stage.stage.height);
				}
				context.clip();
				this._stage_._lyPaint_(context,this._left_,this._top_);
				return;
			}
			context.save();
			x=-this._left_;
			y=-this._top_;
			if (x !=0 || y !=0){
				context.translate(x,y);
				context.transform(m.a,m.b,m.c,m.d,m.tx,m.ty);
				context.translate(-x,-y);
			}
			else {
				context.transform(m.a,m.b,m.c,m.d,m.tx,m.ty);
			}
			context.beginPath();
			var xx=x+this._left_/this.scaleX,yy=y+this._top_/this.scaleY;
			context.rect(xx,yy,Stage.stage.stageWidth,Stage.stage.stageHeight);
			context.clip();
			this._stage_._lyPaint_(context,xx,yy);
			context.restore();
		}

		return Body;
	})(DisplayObject)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/media/video.as
	//class iflash.media.Video extends iflash.display.DisplayObject
	var Video=(function(_super){
		function Video(width,height){
			(width===void 0)&& (width=320);
			(height===void 0)&& (height=240);
			Video.__super.call(this);
		}

		__class(Video,'iflash.media.Video',false,_super);
		var __proto=Video.prototype;
		__proto.attachCamera=LAYAFNVOID/*function(camera){}*/
		__proto.attachNetStream=LAYAFNVOID/*function(netStream){}*/
		__proto.clear=LAYAFNVOID/*function(){}*/
		__getset(0,__proto,'deblocking',LAYAFN0/*function(){return 0}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'smoothing',LAYAFNFALSE/*function(){return false}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'videoHeight',LAYAFN0/*function(){return 0}*/);
		__getset(0,__proto,'videoWidth',LAYAFN0/*function(){return 0}*/);
		return Video;
	})(DisplayObject)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/filesystem/file.as
	//class iflash.filesystem.File extends iflash.net.FileReference
	var File=(function(_super){
		function File(path,statusHandler){
			this._isApplicationDirectory=false;
			this._isApplicationStorageDirectory=false;
			this.downloaded=false;
			this.exists=false;
			this._isDirectory=false;
			this.isHidden=false;
			this.isPackage=false;
			this.isSymbolicLink=false;
			this.lineEnding=null;
			this.nativePath=null;
			this.parent=null;
			this.separator=null;
			this.spaceAvailable=NaN;
			this.systemCharset=null;
			this._url=null;
			this._extension=null;
			this._name=null;
			this._statusHandler=null;
			this.urlLoader=null;
			this._data=null;
			File.__super.call(this);
			var $this=this;
			if (path==null)
				return;
			if (statusHandler !=null)
				this._statusHandler=statusHandler;
			this.url=path;
		}

		__class(File,'iflash.filesystem.File',false,_super);
		var __proto=File.prototype;
		__proto.load=function(){
			if (this.nativePath.lastIndexOf("/")< this.nativePath.length-1){
				this.urlLoader=new URLLoader();
				this.urlLoader.dataFormat=/*iflash.net.URLLoaderDataFormat.BINARY*/"binary";
				this.urlLoader.addEventListener(/*iflash.events.Event.COMPLETE*/"complete",__bind(this,this.onFileStatusComplete));
				this.urlLoader.addEventListener(/*iflash.events.IOErrorEvent.IO_ERROR*/"ioError",__bind(this,this.onFileStatusIOError));
				this.urlLoader.load(new URLRequest(this.nativePath));
			}
		}

		__proto.onFileStatusIOError=function(event){
			this.exists=false;
			this.urlLoader.close();
			this.dispatchEvent(new Event("fileStatusOk",true));
		}

		__proto.onFileStatusComplete=function(event){
			this.exists=true;
			this._data=event.target.data;
			this.urlLoader.close();
			this.dispatchEvent(new Event("fileStatusOk",true));
		}

		__proto.getDirectoryListing=function(){
			if (this._isApplicationStorageDirectory){
				return FileStorage.instance.getList(this._url.replace("app-storage:/",""))
			}
			else if (this._isApplicationDirectory){
				return null;
			}
			else{
				return null;
			}
		}

		__proto.resolvePath=function(path){
			if (this._isApplicationStorageDirectory){
				return new File(this._url+path);
			}
			else if (this._isApplicationDirectory){
				return new File(this._url+path);
			}
			else{
				return null;
			}
		}

		__proto.deleteFile=LAYAFNVOID/*function(){}*/
		__proto.deleteFileAsync=LAYAFNVOID/*function(){}*/
		__proto.deleteDirectory=function(deleteDirectoryContents){
			(deleteDirectoryContents===void 0)&& (deleteDirectoryContents=false);
		}

		__proto.copyTo=function(newLocation,overwrite){
			(overwrite===void 0)&& (overwrite=false);
		}

		__proto.moveTo=function(newLocation,overwrite){
			(overwrite===void 0)&& (overwrite=false);
		}

		__proto.deleteDirectoryAsync=function(deleteDirectoryContents){
			(deleteDirectoryContents===void 0)&& (deleteDirectoryContents=false);
		}

		__getset(0,__proto,'isDirectory',function(){
			return this._isDirectory;
		});

		__getset(0,__proto,'type',function(){
			return this._extension ? "."+this._extension :null;
		});

		__getset(0,__proto,'data',function(){
			return this._data;
		});

		__getset(0,__proto,'extension',function(){
			return this._extension;
		});

		__getset(0,__proto,'url',function(){
			return this._url;
			},function(value){
			var arr;
			if (value.search("[a-zA-Z]:\\/")==0){
				throw new Error("not support local file to read");
			}
			else if (value.indexOf("file:///")==0){
				throw new Error("not support local file to read");
				return;
				this._url=value;
				value=value.replace("file:///","").replace("\\/{2,99}","/");
				if (value.search("[a-zA-Z]:\\/")==0){
					arr=value.split("/");
					this.nativePath=arr.join("\\");
				}
				this._extension=value.lastIndexOf(".")>-1 ? value.substr(value.lastIndexOf(".")+1):null;
				this._name=value.lastIndexOf("/")>-1 ? value.substr(value.lastIndexOf("/")+1):null;
			}
			else if (value.indexOf("app:/")==0){
				this._isApplicationDirectory=true;
				this._isApplicationStorageDirectory=false;
				this._url=value;
				this.nativePath=(/*__JS__ */LAYABOX.APP_ROOT ? /*__JS__ */LAYABOX.APP_ROOT :"")+value.replace("app:/","");
				this._extension=value.lastIndexOf(".")>-1 ? value.substr(value.lastIndexOf(".")+1):null;
				this._name=value.lastIndexOf("/")>-1 ? value.substr(value.lastIndexOf("/")+1):null;
			}
			else if (value.indexOf("app-storage:/")==0){
				this._isApplicationDirectory=false;
				this._isApplicationStorageDirectory=true;
				this._url=value;
				this.nativePath=(/*__JS__ */LAYABOX.APP_ROOT ? /*__JS__ */LAYABOX.APP_ROOT :"")+value.replace("app-storage:/","");
				this._extension=value.lastIndexOf(".")>-1 ? value.substr(value.lastIndexOf(".")+1):null;
				this._name=value.lastIndexOf("/")>-1 ? value.substr(value.lastIndexOf("/")+1):null;
				this.exists=FileStorage.instance.fileExist(this._url.replace("app-storage:/",""));
				this._data=FileStorage.instance.getFile(this._url.replace("app-storage:/",""));
			}
			else{
				throw new Error("file address is invalid");
			}
		});

		__getset(0,__proto,'name',function(){
			return this._name;
		});

		__getset(1,File,'applicationDirectory',function(){
			return File._applicationDirectory;
		},iflash.net.FileReference._$SET_applicationDirectory);

		__getset(1,File,'systemCharset',LAYAFNSTR/*function(){return ""}*/,iflash.net.FileReference._$SET_systemCharset);
		__getset(1,File,'applicationStorageDirectory',function(){
			return File._applicationStorageDirectory;
		},iflash.net.FileReference._$SET_applicationStorageDirectory);

		__getset(1,File,'separator',function(){
			return "\\";
		},iflash.net.FileReference._$SET_separator);

		File.getRootDirectories=LAYAFNNULL/*function(){return null}*/
		File.createTempDirectory=function(){
			return new File();
		}

		File.createTempFile=function(){
			return new File();
		}

		File.lineEnding="\r\n";
		__static(File,
		['_applicationDirectory',function(){return this._applicationDirectory=new File("app:/");},'_applicationStorageDirectory',function(){return this._applicationStorageDirectory=new File("app-storage:/");}
		]);
		return File;
	})(FileReference)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/ui/contextmenu.as
	//class iflash.ui.ContextMenu extends iflash.display.NativeMenu
	var ContextMenu=(function(_super){
		function ContextMenu(){
			ContextMenu.__super.call(this);
		}

		__class(ContextMenu,'iflash.ui.ContextMenu',false,_super);
		var __proto=ContextMenu.prototype;
		__proto.clone=function(){
			return new NativeMenu();
		}

		__proto.hideBuiltInItems=LAYAFNVOID/*function(){}*/
		__getset(0,__proto,'builtInItems',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'clipboardItems',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'clipboardMenu',LAYAFNFALSE/*function(){return false}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'customItems',LAYAFNARRAY/*function(){return []}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'link',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(value){}*/);
		__getset(1,ContextMenu,'isSupported',LAYAFNFALSE/*function(){return false}*/,iflash.display.NativeMenu._$SET_isSupported);
		return ContextMenu;
	})(NativeMenu)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/ui/contextmenuitem.as
	//class iflash.ui.ContextMenuItem extends iflash.display.NativeMenuItem
	var ContextMenuItem=(function(_super){
		function ContextMenuItem(caption,separatorBefore,enabled,visible){
			(separatorBefore===void 0)&& (separatorBefore=false);
			(enabled===void 0)&& (enabled=true);
			(visible===void 0)&& (visible=true);
			ContextMenuItem.__super.call(this);
		}

		__class(ContextMenuItem,'iflash.ui.ContextMenuItem',false,_super);
		var __proto=ContextMenuItem.prototype;
		__proto.clone=LAYAFNNULL/*function(){return null}*/
		__getset(0,__proto,'caption',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'separatorBefore',LAYAFNFALSE/*function(){return false}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'visible',LAYAFNFALSE/*function(){return false}*/,LAYAFNVOID/*function(value){}*/);
		return ContextMenuItem;
	})(NativeMenuItem)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/filters/glowfilter.as
	//class iflash.filters.GlowFilter extends iflash.filters.DropShadowFilter
	var GlowFilter=(function(_super){
		function GlowFilter(in_color,in_alpha,in_blurX,in_blurY,in_strength,in_quality,in_inner,in_knockout){
			(in_color===void 0)&& (in_color=0);
			(in_alpha===void 0)&& (in_alpha=1.0);
			(in_blurX===void 0)&& (in_blurX=6.0);
			(in_blurY===void 0)&& (in_blurY=6.0);
			(in_strength===void 0)&& (in_strength=1.0);
			(in_quality===void 0)&& (in_quality=1);
			(in_inner===void 0)&& (in_inner=false);
			(in_knockout===void 0)&& (in_knockout=false);
			GlowFilter.__super.call(this,0,0,in_color,in_alpha,in_blurX,in_blurY,in_strength,in_quality,in_inner,in_knockout,false);
		}

		__class(GlowFilter,'iflash.filters.GlowFilter',false,_super);
		return GlowFilter;
	})(DropShadowFilter)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/embedimage.as
	//class iflash.display.EmbedImage extends iflash.display.Bitmap
	var EmbedImage=(function(_super){
		function EmbedImage(bitmapData,pixelSnapping,smoothing){
			this._loader=null;
			this._url=null;
			(pixelSnapping===void 0)&& (pixelSnapping="auto");
			(smoothing===void 0)&& (smoothing=false);
			EmbedImage.__super.call(this,bitmapData,pixelSnapping,smoothing);
		}

		__class(EmbedImage,'iflash.display.EmbedImage',false,_super);
		var __proto=EmbedImage.prototype;
		__proto.load=function(url){
			this._url=url;
			if (EmbedImage._imgMap[this._url] !=null){
				this.bitmapData=EmbedImage._imgMap[this._url];
				}else if (Boolean(this._url)){
				this._loader=new Loader();
				this._loader.contentLoaderInfo.addEventListener(/*iflash.events.Event.COMPLETE*/"complete",__bind(this,this.onComplete));
				this._loader.contentLoaderInfo.addEventListener(/*iflash.events.IOErrorEvent.IO_ERROR*/"ioError",__bind(this,this.onError));
				this._loader.load(new URLRequest(this._url),EmbedImage._loaderContent);
			}
		}

		__proto.onComplete=function(e){
			if (this._loader){
				var bmd=(this._loader.content).bitmapData;
				this.bitmapData=EmbedImage._imgMap[this._url]=bmd;
				this.clearLoader();
				this.readyWork();
			}
		}

		__proto.clearLoader=function(){
			this._loader.unloadAndStop();
			this._loader.contentLoaderInfo.removeEventListener(/*iflash.events.Event.COMPLETE*/"complete",__bind(this,this.onComplete));
			this._loader.contentLoaderInfo.removeEventListener(/*iflash.events.IOErrorEvent.IO_ERROR*/"ioError",__bind(this,this.onError));
			this._loader=null;
		}

		__proto.onError=function(e){
			console.log("IO Error:"+this._url);
		}

		EmbedImage._imgMap={};
		__static(EmbedImage,
		['_loaderContent',function(){return this._loaderContent=new LoaderContext(false,ApplicationDomain.currentDomain);}
		]);
		return EmbedImage;
	})(Bitmap)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/displayobjectcontainer.as
	//class iflash.display.DisplayObjectContainer extends iflash.display.InteractiveObject
	var DisplayObjectContainer=(function(_super){
		function DisplayObjectContainer(){
			this.scale9Data=null;
			this._childs_=EventDispatcher.__NULLARRAY__;
			DisplayObjectContainer.__super.call(this);this._type_|=0x20;
		}

		__class(DisplayObjectContainer,'iflash.display.DisplayObjectContainer',false,_super);
		var __proto=DisplayObjectContainer.prototype;
		__proto._paintChild_=function(context,x,y,w,h){
			this._type_& /*iflash.display.DisplayObject.TYPE_CREATE_FROM_TAG*/0x10&&this.sortChildsByZIndex();
			var sz=0,i=0;
			var c,childs;
			if ((sz=(childs=this._childs_).length)> 0){
				for (i=0;i < sz;i++){
					if ((c=childs[i])==null || !(c._type_& /*iflash.display.DisplayObject.TYPE_IS_VISIBLE*/0x400)||!c.alpha)continue ;
					c.conchPaint(context,x+c._left_,y+c._top_);
				}
			}
		}

		__proto.addChild=function(c){
			if(c==null)
				throw new Error("param is null");
			if(c._parent_!=null){
				if (c._parent_==this){
					var pre=this.childIndexOf(c);
					this.lyRemoveChildAt(pre,false);
				}
				else c._parent_.removeChild(c);
			}
			this._childs_==EventDispatcher.__NULLARRAY__ && (this._childs_=[],Laya.RENDERBYCANVAS && (this._type_&0x8)==0 && DrawChilds.insertUnit(this),this._type_|=0x8);
			Method.insert(this._childs_,this._childs_.length,c);
			this._modle_ && this._modle_.insert(c._modle_,this._childs_.length-1,this._childs_.length);
			c._parent_=this;
			if(EventDispatcher._isOpenTypeAdded)c._dispatchAddedEvent(c);
			this._type_|=0x4000;
			c._propagateFlagsDown_(/*iflash.display.DisplayObject.TYPE2_CONCATENATEDMATRIX_CHG*/0x1 | /*iflash.display.DisplayObject.TYPE2_BOUNDS_CHG*/0x4);
			if(this._root_==Stage.stage){
				c._lyToBody_();
			}
			return c;
		}

		__proto.swapAt=function(frome,to){
			if (frome >=0 && to >=0 && frome!=to){
				var fromeNode=this._childs_[frome];
				var toNone=this._childs_[to];
				this._childs_[frome]=toNone;
				this._childs_[to]=fromeNode;
				var tmp=toNone._id_;
				toNone._id_=fromeNode._id_;
				fromeNode._id_=tmp;
				this._modle_ && this._modle_.swap(fromeNode._modle_,toNone._modle_);
			}
		}

		__proto.childIndexOf=function(child){
			return this._childs_.indexOf(child);
		}

		__proto.addChildAt=function(c,index){
			if(!c)return null;
			if (c.deleted==true)return c;
			if(c._parent_!=null){
				if (c._parent_==this){
					var pre=this.childIndexOf(c);
					if (index==pre)return c;
					this.lyRemoveChildAt(pre,false);
				}else c._parent_.removeChild(c);
			}
			this._childs_==EventDispatcher.__NULLARRAY__ && (this._childs_=[],Laya.RENDERBYCANVAS && (this._type_&0x8)==0 && DrawChilds.insertUnit(this),this._type_|=0x8);
			Method.insert(this._childs_,index,c);this._firstDisplayUnit_
			c._parent_=this;
			if(EventDispatcher._isOpenTypeAdded)c._dispatchAddedEvent(c);
			this._type_|=0x4000;
			c._propagateFlagsDown_(/*iflash.display.DisplayObject.TYPE2_CONCATENATEDMATRIX_CHG*/0x1 | /*iflash.display.DisplayObject.TYPE2_BOUNDS_CHG*/0x4);
			if(this._root_==Stage.stage){
				c._lyToBody_();
			}
			c._modle_ && this._modle_ && this._modle_.insert(c._modle_,index,this._childs_.length);
			return c;
		}

		__proto.getObjectsUnderPoint=LAYAFNNULL/*function(point){return null}*/
		__proto.removeChildAt=function(index){
			return this.lyRemoveChildAt(index);
		}

		__proto.lyRemoveChildAt=function(index,isSendEvent){
			(isSendEvent===void 0)&& (isSendEvent=true);
			if (index < 0)return this;
			var c=this._childs_[index];
			this._childs_.splice(index,1);
			this._modle_ && this._modle_.removeAt(index,c._modle_,this._childs_.length);
			if(isSendEvent){
				c._dispatchRemovedEvent();
				if(this._root_==Stage.stage){
					c._lyUnToBody_();
				}
			}
			c._parent_=null;
			c._type2_ &=~ (/*iflash.display.DisplayObject.TYPE2_CONCATENATEDMATRIX_CHG*/0x1 | /*iflash.display.DisplayObject.TYPE2_BOUNDS_CHG*/0x4);
			if(Laya.document.activeElement&&Laya.document.activeElement.__owner__.root!=this.stage)
			{Laya.document.activeElement.blur();Laya.document.activeElement=null;}
			return c;
		}

		__proto.removeChild=function(c){
			this._type_|=0x4000;
			return this.lyRemoveChildAt(this.childIndexOf(c));
		}

		__proto.getChildAt=function(index){
			return this._childs_[index];
		}

		__proto.sortChildsByZIndex=function(){
			this.sortChildren(__bind(this,this._sort_));
		}

		__proto.getBounds=function(targetSpace,resultRect){
			if (!targetSpace)targetSpace=this;
			if (!resultRect)resultRect=new Rectangle();
			this._getBounds_(targetSpace,resultRect);
			if(targetSpace!=this){
				if (targetSpace==this._parent_){
					DisplayObject.HELPER_MATRIX.copy(this.matrix);
					}else{
					Matrix.mul(DisplayObject.HELPER_MATRIX,targetSpace._getInvertedConcatenatedMatrix(),this._getConcatenatedMatrix());
				}
				DisplayObject.HELPER_MATRIX.transformBounds(resultRect);
			}
			this._type2_ &=~0x4;
			return resultRect;
		}

		__proto._getBounds_=function(targetSpace,resultRect){
			if(!targetSpace)targetSpace=this;
			var p=DisplayObject.HELPER_POINT;
			if (resultRect==null)resultRect=new Rectangle();
			var numChildren=this._childs_.length;
			var child;
			if (numChildren==0){
				resultRect.setTo(0,0,0,0);
			}
			else if (numChildren==1){
				child=this._childs_[0];
				child._getBounds_(this,resultRect);
				child.matrix.transformBounds(resultRect);
			}
			else{
				var minX=Number.MAX_VALUE,maxX=-Number.MAX_VALUE;
				var minY=Number.MAX_VALUE,maxY=-Number.MAX_VALUE;
				for (var i=0;i<numChildren;++i){
					child=(this._childs_[i]);
					var r=DisplayObject.HELPER_RECTANGLET.setTo(0,0,0,0);
					child._getBounds_(this,r);
					child.matrix.transformBounds(r);
					if (minX > r.x)minX=r.x;
					if (maxX < r.right)maxX=r.right;
					if (minY > r.y)minY=r.y;
					if (maxY < r.bottom)maxY=r.bottom;
				}
				resultRect.setTo(minX,minY,maxX-minX,maxY-minY);
			}
			if(resultRect.width<0){
				resultRect.x-=resultRect.width;
				resultRect.width=Math.abs(resultRect.width);
			}
			if(resultRect.height<0){
				resultRect.y-=resultRect.height;
				resultRect.height=Math.abs(resultRect.height);
			}
			if(!resultRect){
				resultRect.width *=this.scaleX;
				resultRect.height *=this.scaleY;
			}
			return resultRect;
		}

		__proto._hitTest_=function(x,y){
			if(!this.visible)return null;
			if (!this._checkHitMask(x,y)){return null;}
				if (!this._checkHitScrollRect(x,y)){return null;}
			if (this._private_._scrollRect_){x+=this._private_._scrollRect_.x;y+=this._private_._scrollRect_.y;};
			var target=null,shapes=[],displayObjs=[],i=0,child,numChildren=this._childs_.length;
			var sortArr=[];
			for (i=0;i<numChildren;i++){
				child=this._childs_[i];
				if((child instanceof iflash.display.InteractiveObject )){
					sortArr.push(child);
				}
				else{
					sortArr.unshift(child);
				}
			}
			for(i=numChildren-1;i>=0;i--){
				child=sortArr[i];
				if((child instanceof iflash.display.InteractiveObject )){
					this.getTransformMatrix(child,DisplayObject.HELPER_MATRIX);
					MatrixUtil.transformCoords(DisplayObject.HELPER_MATRIX,x,y,DisplayObject.HELPER_POINT);
					target=child._hitTest_(DisplayObject.HELPER_POINT.x,DisplayObject.HELPER_POINT.y);
					if(target){
						if((target instanceof iflash.display.Sprite )){
							var sp=target;
							if(!sp.mouseChildren && !sp.mouseEnabled){
								if(sp.numChildren==1 && sp.graphicsHited(DisplayObject.HELPER_POINT.x,DisplayObject.HELPER_POINT.y)){
									return this;
								}
								continue ;
							}
							else if(!sp.mouseEnabled && this.mouseChildren){
								if(this.numChildren==1 && this.mouseEnabled){
									return this;
								}
								else{
									continue ;
								}
							}
						}
						return this.mouseChildren?target:this;
					}
				}
				else{
					this.getTransformMatrix(child,DisplayObject.HELPER_MATRIX);
					MatrixUtil.transformCoords(DisplayObject.HELPER_MATRIX,x,y,DisplayObject.HELPER_POINT);
					target=child._hitTest_(DisplayObject.HELPER_POINT.x,DisplayObject.HELPER_POINT.y);
					if(target)return this;
				}
			}
			return null;
		}

		__proto.setChildIndex=function(child,index){this.addChildAt(child,index);}
		__proto.getChildIndex=function(child){return this._childs_.indexOf(child);}
		__proto._sort_=function(a,b){
			return a._to_sort_d-b._to_sort_d;
		}

		__proto.getChildByName=function(value){
			var child;
			/*for each*/for(var $each_child in this._childs_){
				child=this._childs_[$each_child];
				if(child.name==value)return child;
			}
			return null;
		}

		__proto.sortChildren=function(keyOrFunction){
			if((this._type_&0x4000)==0)return;
			var f=keyOrFunction,key;
			if (typeof (f)=="string"){
				key=f;
				f=function (a,b){
					return b[key]-a[key];
				};
			}
			this._childs_.sort(f);
			this._type_&=~0x4000
		}

		__proto.swapChildrenAt=function(index1,index2){
			var c=this._childs_[index1];
			this._modle_.swap(c._modle_,this._childs_[index2]._modle_);
			this._childs_[index1]=this._childs_[index2];
			this._childs_[index2]=c;
			this._type_ |=0x4000;
		}

		__proto.swapChildren=function(child1,child2){
			var index1=this._childs_.indexOf(child1);
			var index2=this._childs_.indexOf(child2);
			this.swapChildrenAt(index1,index2);
		}

		__proto._lyToBody_=function(){
			this.dispatchAdd(this);
			iflash.display.DisplayObject.prototype._lyToBody_.call(this);
		}

		__proto.dispatchAdd=function(child){
			var len=child._childs_.length;
			var i=0;
			while(i<len)
			{child._childs_[i]._lyToBody_();i++;}
		}

		__proto._lyUnToBody_=function(){
			iflash.display.DisplayObject.prototype._lyUnToBody_.call(this);
			this.dispatchUnAdd(this);
		}

		__proto.dispatchUnAdd=function(child){
			var len=child._childs_.length;
			var i=0;
			while(i<len)
			{child._childs_[i]._lyUnToBody_();i++;}
		}

		__proto.contains=function(child){
			if(this._childs_==null){
				return false;
			};
			var result={flag:false};
			this.checkContainsByChild(this,child,result);
			return result.flag;
		}

		__proto.checkContainsByChild=function(display,child,result){
			if(display==child){
				result.flag=true;
				return;
			}
			if((display instanceof iflash.display.DisplayObjectContainer )){
				var box=display;
				for (var i=0,n=box._childs_.length;i <n;i++){
					this.checkContainsByChild(box._childs_[i],child,result);
				}
			}
		}

		__proto.removeChildren=function(beginIndex,endIndex){
			(beginIndex===void 0)&& (beginIndex=0);
			(endIndex===void 0)&& (endIndex=2147483647);
			if(this.numChildren==0)
				return;
			(beginIndex < 0)&& (beginIndex=0);
			(endIndex > this.numChildren)&& (endIndex=this.numChildren-1);
			while(endIndex>=beginIndex){
				this.lyRemoveChildAt(endIndex);
				endIndex--;
			}
		}

		__proto._propagateFlagsDown_=function(flags){
			if ((this._type2_ & flags)==flags)return;
			var child;
			var num=this._childs_.length;
			for (var i=0;i < num;i++){
				child=this._childs_[i];
				child._propagateFlagsDown_(flags);
			}
			this._type2_ |=flags;
		}

		__proto.setupReadyNoticeWork=function(ifSelfNotice){
			(ifSelfNotice===void 0)&& (ifSelfNotice=false);
			iflash.display.DisplayObject.prototype.setupReadyNoticeWork.call(this,ifSelfNotice);
			if(this.isReadyForDraw)return;
			if(!this._childs_||this._childs_.length<1)return;
			var i=0,len=0;
			len=this._childs_.length;
			var tChild;
			for(i=0;i<len;i++){
				tChild=this._childs_ [i];
				tChild.setupReadyNoticeWork(true);
			}
		}

		__proto.oneChildReady=function(){
			if(this.isReadyForDraw){
				this.readyWork();
				}else{
			}
		}

		__proto.updateScaleData=function(index){
			(index===void 0)&& (index=0);
			if(this.scale9Data){
				var c=this._childs_[index];
				(c.scale9Data==null)&& (c.scale9Data={});
				c.scale9Data.x1=this.scale9Data.x1-c.x;
				c.scale9Data.y1=this.scale9Data.y1-c.y;
				c.scale9Data.x2=this.scale9Data.x2-c.x;
				c.scale9Data.y2=this.scale9Data.y2-c.y;
				if(this._width_!=c._width_)c.width=this.width;
				if(this._height_!=c._height_)c.height=this.height;
			}
		}

		__proto.layaDestory=function(){
			iflash.display.DisplayObject.prototype.layaDestory.call(this);
			for (var i=0,sz=this._childs_.length;i < sz;i++){
				this._childs_[i].layaDestory();
			}
			this._childs_.length=0;
		}

		__getset(0,__proto,'numChildren',function(){
			return this._childs_.length;
		});

		__getset(0,__proto,'tabChildren',LAYAFNFALSE/*function(){return false}*/,LAYAFNVOID/*function(param1){}*/);
		__getset(0,__proto,'mouseChildren',function(){
			return (this._type_&0x20)!=0;
			},function(value){
			if(value)
				this._type_|=0x20;
			else
			this._type_&=~0x20;
		});

		__getset(0,__proto,'scaleX',_super.prototype._$get_scaleX,function(value){
			_super.prototype._$set_scaleX.call(this,value);
		});

		__getset(0,__proto,'scaleY',_super.prototype._$get_scaleY,function(value){
			_super.prototype._$set_scaleY.call(this,value);
		});

		__getset(0,__proto,'isReadyForDraw',function(){
			if(!this._childs_||this._childs_.length<1)return true;
			var i=0,len=0;
			len=this._childs_.length;
			var tChild;
			for(i=0;i<len;i++){
				tChild=this._childs_ [i];
				if(tChild&&!tChild.isReadyForDraw){
					return false;
				}
			}
			return true;
		});

		__getset(0,__proto,'width',function(){
			if(this.scale9Data)return this._width_<=0?_super.prototype._$get_width.call(this):this._width_;
			else return _super.prototype._$get_width.call(this);
			},function(w){
			if(this._width_==w)
				return;
			this.scaleX=1.0;
			var oldW=this.getBounds(this).width;
			oldW &&(this.scaleX=w / oldW);
			(this._width_ !=w)&& this.lySize(w,this._height_);
		});

		__getset(0,__proto,'height',function(){
			if(this.scale9Data)return this._height_<=0?_super.prototype._$get_height.call(this):this._height_;
			else return _super.prototype._$get_height.call(this);
			},function(h){
			if(this._height_==h)
				return;
			this.scaleY=1.0;
			var oldH=this.getBounds(this).height;
			oldH &&(this.scaleY=h / oldH);
			(this._height_ !=h)&& this.lySize(this._width_,h);
		});

		return DisplayObjectContainer;
	})(InteractiveObject)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/text/textfield.as
	//class iflash.text.TextField extends iflash.display.InteractiveObject
	var TextField=(function(_super){
		function TextField(){
			this.formatIndices=[];
			this._scroller=null;
			this._inputting=false;
			this._nodeIndex=0;
			TextField.__super.call(this);
			this._lines=[];
			this._originFormats=[];
			this._formats=[];
			this._nodeCoordinate=new Point();
			this.nodes=new TextNodeList()
			this._textWidth=2+2;
			this._textHeight=2+2;
			this._autoSizeWidth=this._width=100;
			this._autoSizeWidth=this._height=100;
			this._modle_.size(this._width,this._height+5);
			this._selectable=true;
			Laya.RENDERBYCANVAS && DrawText.insertUnit(this);
			DrawText.insertUnit(this);
			this.viewport=[0,0,this._width,this._height];
			this._text="";
			this._htmlText="";
			this._type=/*iflash.text.TextFieldType.DYNAMIC*/"dynamic";
			this._df=TextField.DF;
			this.addEventListener(/*iflash.events.Event.ADDED_TO_STAGE*/"addedToStage",__bind(this,this.onTextAdded));
		}

		__class(TextField,'iflash.text.TextField',false,_super);
		var __proto=TextField.prototype;
		__proto.onTextAdded=function(e){
			this.addEventListener(/*iflash.events.MouseEvent.MOUSE_UP*/"mouseUp",__bind(this,this.onTextFocus),false,-99);
			this.addEventListener(/*iflash.events.Event.REMOVED_FROM_STAGE*/"removedFromStage",__bind(this,this.onTextRemoved));
			this.removeEventListener(/*iflash.events.Event.ADDED_TO_STAGE*/"addedToStage",__bind(this,this.onTextAdded));
		}

		__proto.onTextRemoved=function(e){
			this.addEventListener(/*iflash.events.Event.ADDED_TO_STAGE*/"addedToStage",__bind(this,this.onTextAdded));
			this.removeEventListener(/*iflash.events.MouseEvent.CLICK*/"click",__bind(this,this.onTextFocus));
			if (this._scroller)
				this._scroller.removeEventListener(/*iflash.events.TimerEvent.TIMER*/"timer",__bind(this,this.onTextScroll));
		}

		__proto.onBrowserInputKeyDown=function(e){
			if(e.keyCode==/*iflash.ui.Keyboard.ENTER*/13){
				e.returnValue=false;
				e.preventDefault();
			}
		}

		__proto.onMaxCharsLimit=function(e){
			if(Browser.input.value.length > this._maxChars){
				Browser.input.value=Browser.input.value.substr(0,this._maxChars);
			}
		}

		__proto.onTextFocus=function(e){
			if (!this.stage)
				return;
			if (this._links && this._links.length){
				this._caretIndex=this.getCharIndexAtPoint(this.mouseX,this.mouseY,true);
				this.checkLinkEvent(this._caretIndex);
			}
			else if (this._type=="input"){
				if(this._inputting){
					if(Driver.enableTouch())
						this.checkTextFocusout(null);
					return;
				}
				TextField.onMobile && Driver.deactivateTouchEvent();
				this._inputting=true;
				TextField.isInputting=true;
				this._caretIndex=this.getCharIndexAtPoint(this.mouseX,this.mouseY,true);
				if (this.stage.currentFocus !=this){
					var concatedMatrix=this._getConcatenatedMatrix();
					Browser.input.setType(this._disAsPass ? "password" :"text");
					if(Laya.CONCHVER || !Driver.enableTouch()){
						Browser.input.setColor(StringMethod.getColorString(this._df.color)|| "#000000");
						Browser.input.setSize(this._width,this._height);
						Browser.input.setFont(this._df.font || "Times New Roman");
						Browser.input.setFontSize(this._df.size || 12);
						Browser.input.setScale(this.scaleX *Laya.window.scale.x *concatedMatrix.a,this.scaleY *Laya.window.scale.y *concatedMatrix.d);
						if(Laya.CONCHVER){
							this._modle_.setHideText(true);
							this._maxChars ? Browser.input.setMaxLength(this._maxChars):Browser.input.setMaxLength(1e8);
							if (this._restrict && this._restrict !="")
								Browser.input.setRegular("["+this._restrict+"]");
							else
							Browser.input.setRegular(".*");
						}
						Browser.input.value=this._text;
						var pos=new Point(concatedMatrix.tx,concatedMatrix.ty);
						Browser.input.setPos(pos.x *Laya.window.scale.x+Laya.document.body.x,pos.y *Laya.window.scale.y+Laya.document.body.y);
					}
					else{
						Browser.input.setPos(0,0);
						Browser.input.clear();{
							Browser.input.setSize(TextField.initialWindowWidth,(this._multiline ? TextField.textAreaHeight:TextField.inputHeight));
							Browser.input.setFontSize(TextField.inputFontSize);
							Browser.input.style.background="Linen";
							Browser.input.style.borderTop="3px solid orange";
							Browser.input.style.borderBottom="3px solid orange";
							Browser.input.value=this._text;
							/*__JS__ */window.document.body.scrollTop=0;
						}
					}
					if(!Laya.CONCHVER){
						if(!TextField.onMobile){
							Browser.addToBody(Browser.input);
							Browser.input.setAlign(this._df.align || 'left');
						}
						Browser.input.style.whiteSpace=(this._wordWrap || this._multiline)? "normal" :"nowrap";
						Browser.input.onkeydown=this._multiline ? null :this.onBrowserInputKeyDown;
						Browser.input.oninput=this._maxChars > 0 ? /*__JS__ */this.onMaxCharsLimit.bind(this):null;
					}
					Browser.input.target=this;
					TextField.onMobile || Browser.input.focus();
					Stage.stage.addEventListener(/*iflash.events.MouseEvent.MOUSE_DOWN*/"mouseDown",__bind(this,this.checkTextFocusout));
				}
				Browser.input.addEventListener("input",__bind(this,this.dispathInput));
				var caretIndex=this._caretIndex;
				if(caretIndex < 0)caretIndex=0;
				else if(caretIndex > this._text.length)caretIndex=this._text.length;
			}
			if (this.stage && (this.stage.currentFocus !=this && this._selectable)){
				this.dispatchEvent(new FocusEvent(/*iflash.events.FocusEvent.FOCUS_IN*/"focusIn"));
				this.stage.currentFocus=this;
			}
			if(this.type=="input")
				this.setHtmlInputCaret(caretIndex);
		}

		__proto.checkTextFocusout=function(e){
			if(!e || e.target !=this){
				this._inputting=false;
				TextField.isInputting=false;
				this._text=Browser.input.value;
				if(!Laya.CONCHVER){
					if(this._restrict)
						this._text=this._text.replace(this._restrict,"");
				}
				this._formats[0]=this._formats[0]||({begin:0,end:0});
				this._formats[0].format=this._df;
				this._formats[0].end=this._text.length;
				this.engine_updateStyle();
				if(Laya.CONCHVER){
					this._modle_.setHideText(false);
					this.dispathInput();
				}
				Browser.input.removeEventListener("input",__bind(this,this.dispathInput));
				Stage.stage.removeEventListener(/*iflash.events.MouseEvent.MOUSE_DOWN*/"mouseDown",__bind(this,this.checkTextFocusout));
				Browser.removeFromBody(Browser.input);
				Browser.input.setSize(1,1);
				Browser.input.setPos(0,-2000);
				TextField.onMobile && Driver.activateTouchEvent();
			}
			Stage.stage.focus=null;
			this.dispatchEvent(new FocusEvent(/*iflash.events.FocusEvent.FOCUS_OUT*/"focusOut"));
		}

		__proto.checkLinkEvent=function(indexClick){
			var link;
			for (var i=this._links.length-1;i >=0;i--){
				link=this._links[i];
				if (indexClick >=link.begin && indexClick < link.end){
					if ((typeof link.event=='string'))
						iflash.net.navigateToURL(link.event);
					else
					this.dispatchEvent(link.event);
					return;
				}
			}
		}

		__proto.addToRender=function(){
			if (TextField.TextsToRender.indexOf(this)==-1)
				TextField.TextsToRender.push(this);
		}

		__proto.renderThis=function(){
			var idx=TextField.TextsToRender.indexOf(this);
			if (idx !=-1){
				TextField.TextsToRender.splice(idx,1);
				this.engine_updateStyle();
				return true;
			}
			return false;
		}

		__proto.engine_updateStyle=function(){
			if(this._text==""){
				this.engine_clear();
				this.updateViewportSize();
				return;
			}
			this._textWidth=0;
			this._lines.length=0;
			this._currLineInfo=null;
			this._nodeCoordinate.setTo(2,2);
			this._nodeIndex=0;
			if (this._text.length){
				if (this._disAsPass){
					this._charsToRender="";
					for (var i=this._text.length;i > 0;i--)
					this._charsToRender+="*";
				}
				else
				this._charsToRender=this._text;
				var len=this._formats.length;
				var format;
				for (i=0;i < len;i++){
					format=this._formats[i];
					this.createStyleFromTextFormat(format.begin,format.end-1,format.format);
				}
				if (this._type==/*iflash.text.TextFieldType.INPUT*/"input"){
					var textLen=this._text.length;
					if(this._text.charAt(textLen-1)=="\n")
						this.pushNewLineToLines();
				};
				var tempLineIdx=this._lines.length;
				if (tempLineIdx){
					this._textHeight=this._lines[tempLineIdx-1].y+this._lines[tempLineIdx-1].height;
					if ((!this._autoSize || this._autoSize=="none")&& this._textHeight > this._height){
						for (i=tempLineIdx-1;i >=0;i--){
							if (this._textHeight-this._lines[i].y > this._height){
								this._maxScrollV=i+2;
								break ;
							}
						}
						this._bottomScrollV=this.getBottomScrollV(this._scrollV);
					}
					else
					this._bottomScrollV=this._lines.length;
				}
				else{
					this._textHeight=0;
					this._maxScrollV=0;
				}
				this.engine_layout(true);
				this.checkActiveScroll();
				this._charsToRender=null;
			}
			this.updateViewportSize();
			this.autosize();
		}

		__proto.pushNewLineToLines=function(){
			this._lines.push({
				text:"",
				maxLeading:0,
				y:this._lines[this._lines.length-1].y+this._df.size+(this._df.leading ? this._df.leading :0),
				height:this._df.size+3,
				width:0,
				nodes:[{
					x:2,
					firstCharIndex:this._text.length,
					lastCharIndex:this._text.length,
					format:this._df,
					text:""
				}],
				begin:this._text.length-1,
				end:this._text.length-1,
				isFirstLineOfParagraph:false
			});
		}

		__proto.createStyleFromTextFormat=function(startIndex,endIndex,format){
			var text=this._charsToRender.substring(startIndex,endIndex+1);
			if (!this._currLineInfo){
				this._currLineInfo={
					text:"",
					maxLeading:0,
					y:this._nodeCoordinate.y,
					height:0,
					width:0,
					nodes:[],
					begin:startIndex,
					end:startIndex,
					isFirstLineOfParagraph:this._isNextLineNewParagraph};
				this._lines.push(this._currLineInfo);
			}
			this._isNextLineNewParagraph=false;
			var lineBreakIdx=text.indexOf("\n");
			if (lineBreakIdx==-1){
				var textWidth=format.measureText(text).width;
				if (!this._wordWrap || this.stuffEnough(this._nodeCoordinate.x+textWidth,format)|| this._type=='static'){
					this.createNodeStyle(text,this._nodeIndex,format,textWidth);
					this._nodeCoordinate.x+=textWidth;
					this._nodeIndex+=text.length;
				}
				else{
					textWidth=format.measureText(text.charAt(0)).width;
					if(!this.stuffEnough(this._nodeCoordinate.x+textWidth,format)&& this._currLineInfo.text.length > 0){
						this.resetToNewline(format);
						this.createStyleFromTextFormat(startIndex,endIndex,format);
						return;
					};
					var charWidth=0;
					for (var i=1,len=text.length;i < len;i++){
						charWidth=format.measureText(text.charAt(i)).width;
						textWidth+=charWidth;
						if (!this.stuffEnough(((format.indent && this._currLineInfo.isFirstLineOfParagraph)? format.indent :0)+this._nodeCoordinate.x+textWidth,format,false)){
							var execResult=/\b\w+$/.exec(text.substring(0,i));
							if (execResult){
								if (execResult.index==0)
									i=text.length;
								else
								i=execResult.index;
							}
							this.createNodeStyle(text.substring(0,i),this._nodeIndex,format,textWidth-charWidth);
							this._nodeIndex+=i;
							this.resetToNewline(format);
							if (startIndex+1 <=endIndex)
								this.createStyleFromTextFormat(startIndex+i,endIndex,format);
							break ;
						}
					}
				}
			}
			else{
				this._isNextLineNewParagraph=true;
				if (text=="\n"){
					this._currLineInfo.text+="\n";
					if (!this._currLineInfo.height){
						this._currLineInfo.height=format.size ? format.size :12;
					}
					this._currLineInfo.nodes.push({
						x:2,
						firstCharIndex:startIndex,
						lastCharIndex:startIndex,
						format:format,
						text:"\n"
					});
					this.resetToNewline(format);
				}
				else{
					this.createStyleFromTextFormat(startIndex,startIndex+lineBreakIdx-1,format);
					this._currLineInfo.text+="\n";
					if(this._currLineInfo.nodes.length)
						this._currLineInfo.nodes[this._currLineInfo.nodes.length-1].text+="\n";
					if (!this._currLineInfo.height){
						this._currLineInfo.height=format.size ? format.size :12;
					}
					this._currLineInfo.end++;
					this.resetToNewline(format);
					if (startIndex+lineBreakIdx+1 <=endIndex)
						this.createStyleFromTextFormat(startIndex+lineBreakIdx+1,endIndex,format);
				}
			}
		}

		__proto.resetToNewline=function(format){
			this._nodeIndex=0;
			this._nodeCoordinate.x=2;
			this._nodeCoordinate.y+=this._currLineInfo.height+(format.leading ? format.leading :0)+TextField.LINE_LEADING;
			this._currLineInfo=null;
		}

		__proto.createNodeStyle=function(text,startIndex,format,wordWidth){
			var node={};
			node.x=this._nodeCoordinate.x;
			this._currLineInfo.nodes.push(node);
			node.firstCharIndex=startIndex;
			node.lastCharIndex=node.firstCharIndex+text.length-1;
			node.format=format;
			if(Laya.CONCHVER)
				format._strokeColor=this.strokeColor;
			node.text=text;
			this._currLineInfo.text+=text;
			this._currLineInfo.end+=text.length-1;
			this._currLineInfo.height=Math.max(format.measureText(this._currLineInfo.text).height,this._currLineInfo.height);
			this._currLineInfo.width+=wordWidth;
			this._currLineInfo.maxLeading=Math.max(this._currLineInfo.maxLeading,(format.leading ? Number(format.leading):0));
			this._textWidth=Math.max(this._textWidth,this._currLineInfo.width);
		}

		__proto.engine_layout=function(updateNodeX){
			(updateNodeX===void 0)&& (updateNodeX=false);
			if (Laya.CONCHVER){
				this.conchNodes=this.conchNodes || /*__JS__ */new ConchArrayTextStr();
				this.conchNodes.clear();
			}
			this.nodes.clear();
			var line;
			var lineNodes;
			var numNodes=0;
			var node;
			var format;
			var xOffset=0,yOffset=0;
			var actualWidth=(this._autoSize && this._autoSize !="none" && !this._wordWrap)? (2+2+this._textWidth):this._width-2;
			var numLines=this._lines.length;
			for (var li=0;li < numLines;li++){
				if (this._textHeight > this._height && (!this._autoSize || this._autoSize=="none")){
					if (li < this._scrollV-1)
						continue ;
					else if (li >=this._bottomScrollV)
					break ;
				}
				line=this._lines[li];
				lineNodes=line.nodes;
				numNodes=lineNodes.length;
				if (!numNodes)
					continue ;
				node=lineNodes[0];
				format=node.format;
				yOffset=line.y;
				xOffset=node.x;
				var align=format.align;
				if(updateNodeX && (!this._autoSize || this._autoSize=="none" || this._wordWrap)){
					if(align==/*iflash.text.TextFormatAlign.CENTER*/"center"){
						xOffset+=(this._width-line.width)/ 2;
					}
					else if(align==/*iflash.text.TextFormatAlign.RIGHT*/"right"){
						xOffset+=(this._width-line.width-2-2)
					}
				}
				if(updateNodeX){
					if (line.isFirstLineOfParagraph && format.indent)
						xOffset+=format.indent;
					xOffset+=(format.blockIndent ? format.blockIndent :0);
				}
				for (var ni=0;ni < numNodes;ni++){
					node=lineNodes[ni];
					format=node.format;
					var letterSpacing=int(format.letterSpacing);
					var nodeMetrics=format.measureText(node.text);
					var nodeToPush;
					var tempFont=format.getFont();
					var tempFillStyle=StringMethod.getColorString(Number(format.color)|| 0x000000);
					var tempUnderlineWidth=format.underline ? nodeMetrics.width-(format.letterSpacing ? format.letterSpacing :0):0;
					if (Laya.CONCHVER){
						var tempNode=/*__JS__ */new ConchTextStr();
						tempNode.font=tempFont;
						tempNode.fillStyle=tempFillStyle;
						tempNode.x=xOffset;
						tempNode.y=yOffset+line.height-(nodeMetrics.height || format.size);
						tempNode.letterSpacing=letterSpacing;
						tempNode.text=node.text;
						tempNode.underlineWidth=tempUnderlineWidth;
						this.conchNodes.push(tempNode);
					}
					nodeToPush={};
					this.nodes.push(nodeToPush);
					nodeToPush.font=tempFont;
					nodeToPush.fillStyle=tempFillStyle;
					nodeToPush.x=xOffset;
					nodeToPush.y=yOffset+line.height-(nodeMetrics.height || format.size);;
					nodeToPush.letterSpacing=letterSpacing;
					nodeToPush.text=node.text;
					nodeToPush.underlineWidth=tempUnderlineWidth;
					nodeToPush.underlineY=line.y+line.height;
					updateNodeX && (node.x=xOffset);
					if (letterSpacing){
						var lettersX=[];
						var m=node.text.length;
						nodeToPush.lettersX=lettersX;
						for (var j=0;j < m;j++){
							var word=node.text.charAt(j);
							lettersX.push(xOffset);
							xOffset+=format.measureText(word).width;
						}
					}
					else
					xOffset+=nodeMetrics.width;
				}
			}
			Laya.CONCHVER && (this._modle_.textStrs(this.conchNodes));
		}

		__proto.checkActiveScroll=function(){
			if (this._selectable &&
				this._type=="dynamic" &&
			(!this._autoSize || this._autoSize=="none")&&
			(this._textWidth > this._width ||
			this._textHeight > this._height)&& this._type !="static" && !this._scroller){
				this._scrollV=1;
				this._scroller=new Timer(100);
				this._scroller.addEventListener(/*iflash.events.TimerEvent.TIMER*/"timer",__bind(this,this.onTextScroll),false,0,true);
				this.addEventListener(/*iflash.events.MouseEvent.MOUSE_DOWN*/"mouseDown",__bind(this,this.onTextMouseDown),false,0,true);
			}
		}

		__proto.onTextMouseDown=function(e){
			if (this._scroller){
				this._scroller.start();
				this._mouseDownX=this.mouseX;
				this._mouseDownY=this.mouseY;
			}
			Stage.stage.addEventListener(/*iflash.events.MouseEvent.MOUSE_UP*/"mouseUp",__bind(this,this.onTextMouseUp));
		}

		__proto.onTextMouseUp=function(e){
			Stage.stage.removeEventListener(/*iflash.events.MouseEvent.MOUSE_UP*/"mouseUp",__bind(this,this.onTextMouseUp));
			this._scroller && this._scroller.stop();
		}

		__proto.onTextScroll=function(e){
			if (this._lines.length==0)
				return;
			var hSpeed=this.mouseX-this._mouseDownX;
			var vDir=0;
			if (this.mouseY==this._mouseDownY)
				vDir=0;
			else if (this.mouseY < this._mouseDownY)
			vDir=1;
			else
			vDir=-1;
			this.scrollVWithoutRender(this._scrollV+vDir);
			this.scrollHWithoutRender(this.viewport[0]+hSpeed);
			this.engine_layout();
		}

		__proto.autosize=function(){
			if(this._wordWrap)
				return;
			switch(this._autoSize){
				case "center":
					_super.prototype._$set_x.call(this,(this._autoSizeX || 0)-this._textWidth/2);
					break ;
				case "right":
					_super.prototype._$set_x.call(this,(this._autoSizeX || 0)-this._textWidth-2);
					break ;
				case "left":
				case "none":
					_super.prototype._$set_x.call(this,this._autoSizeX||0);
					break ;
				}
		}

		__proto.updateViewportSize=function(){
			var w=0,h=0;
			if(this.autoSize !='none' && this.autoSize){
				w=this._wordWrap ? this._width :this._textWidth+2+2;
				h=(this._textHeight || this._df.size)+2+2;
			}
			else{
				w=this._width;
				h=this._height;
			}
			this.viewport[2]=w;
			this.viewport[3]=h;
			this._modle_.size(this.viewport[2]+5,this.viewport[3]+10);
		}

		__proto.engine_clear=function(clearInputValue){
			(clearInputValue===void 0)&& (clearInputValue=false);
			this.nodes.clear();
			this.conchNodes && this.conchNodes.clear();
			Laya.CONCHVER && this._modle_.textStrs(this.conchNodes);
			this._lines.length=0;
			this._numLines=1;
			this._textWidth=0;
			this._textHeight=0;
			this._text='';
			this._htmlText=null;
			this._charsToRender=null;
			this._nodeIndex=0;
			var idx=TextField.TextsToRender.indexOf(this);
			if (idx >-1)
				TextField.TextsToRender.splice(idx,1);
			if (this._type=='input' && clearInputValue){
				Browser.input.value='';
			}
		}

		__proto.dispathInput=function(){
			this.dispatchEvent(new TextEvent(/*iflash.events.TextEvent.TEXT_INPUT*/"textInput"));
			if(Laya.CONCHVER || !Driver.enableTouch())
				this._text=Browser.input.value;
			else
			this.text=Browser.input.value;
			this.dispatchEvent(new Event(/*iflash.events.Event.CHANGE*/"change"));
		}

		__proto.appendText=function(newText){
			if (this._text)
				newText=this._text+newText;
			this._originFormats.length=0;
			this._text=newText.toString();
			this._nodeIndex=0;
			this._originFormats.push({begin:0,end:this._text.length,format:this._df});
			this.createFormats();
			this.addToRender();
		}

		__proto.getCharBoundaries=function(charIndex,workInternally){
			(workInternally===void 0)&& (workInternally=false);
			if (charIndex >=this._text.length || charIndex < 0)
				return null;
			workInternally || this.renderThis();
			var result=new Rectangle();
			var line=this._lines[this.getLineIndexOfChar(charIndex)];
			charIndex-=line.begin;
			var node=this.getNodeFromLineByIndex(charIndex,line);
			charIndex-=node.firstCharIndex;
			var format=node.format;
			var metrics=format.measureText(node.text.substring(0,charIndex));
			result.x=node.x+metrics.width;
			var char=node.text.charAt(charIndex);
			metrics=format.measureText(char);
			result.y=line.height-metrics.height+line.y;
			result.width=metrics.width;
			result.height=metrics.height;
			return result;
		}

		__proto.getCharIndexAtPoint=function(x,y,workForCaret){
			(workForCaret===void 0)&& (workForCaret=false);
			if (!this._text || this._text=="" || this._text.length==0)
				return 0;
			this.renderThis();
			x+=this.viewport[0];
			y+=this.viewport[1];
			var charIndex=0;
			if (y < this._textHeight){
				var line;
				var i=this._scrollV ? this._scrollV-1 :0;
				for (i;i < this._bottomScrollV;i++){
					line=this._lines[i];
					if (y < line.y+line.height){
						break ;
					}
				}
			}
			if (!line){
				if (workForCaret)
					line=this._lines[this._lines.length-1];
				else
				return-1;
			}
			if (x > line.width+line.nodes[0].x){
				if (workForCaret){
					if (this._text.charAt(line.end)=="\n"){
						return line.end;
					}
					return line.end+1;
				}
				return-1;
			};
			var nodes=line.nodes;
			var node;
			var format;
			var tempX=0;
			var tempWid=0;
			var len=nodes.length;
			var find=false;
			for (i=0;i < len;i++){
				node=nodes[i];
				format=node.format;
				tempX=node.x;
				var numChars=node.text.length;
				if(!numChars)return line.end;
				for (var j=0;j < numChars;j++){
					var char=node.text[j];
					if (char=="\n" && workForCaret)
						return line.end;
					tempWid=format.measureText(char).width;
					tempX+=tempWid;
					charIndex++;
					if (tempX > x){
						find=true;
						tempX-=(format.letterSpacing)? format.letterSpacing :0;
						return workForCaret ? ((tempX-(tempWid >> 1))< x ? charIndex+line.begin :charIndex+line.begin-1):(charIndex+line.begin-1);
					}
				}
			}
			return-1;
		}

		__proto.getFirstCharInParagraph=function(charIndex){
			return 0;
		}

		__proto.getImageReference=function(id){
			return null;
		}

		__proto.getLineIndexAtPoint=function(x,y){
			this.renderThis();
			var charIndex=this.getCharIndexAtPoint(x,y);
			return this.getLineIndexOfChar(charIndex);
		}

		__proto.getLineIndexOfChar=function(charIndex){
			if (charIndex < 0 || charIndex >=this._text.length)
				return-1;
			this.renderThis();
			var len=this._lines.length;
			var line;
			for (var i=0;i < len;i++){
				line=this._lines[i];
				if (charIndex >=line.begin && charIndex <=line.end)
					return i;
			}
			return this._lines.length-1;
		}

		__proto.getLineLength=function(lineIndex){
			this.renderThis();
			return this._lines[lineIndex].text.length;
		}

		__proto.getLineMetrics=function(lineIndex){
			this.renderThis();
			if (lineIndex < 0 || lineIndex >=this._lines.length)
				return new TextLineMetrics(0,0,this._df.size+TextFormat.HEI_OFF,0,0,0);
			var line=this._lines[lineIndex];
			var x=line.nodes ? line.nodes[0].x :0;
			var wid=line.width;
			var hei=line.height;
			var ascent=0;
			var descent=0;
			var leading=line.maxLeading;
			return new TextLineMetrics(x,wid,hei,ascent,descent,leading);
		}

		__proto.getLineOffset=function(lineIndex){
			this.renderThis();
			return this._lines[lineIndex].begin;
		}

		__proto.getLineText=function(lineIndex){
			this.renderThis();
			return this._lines[lineIndex].text;
		}

		__proto.getParagraphLength=function(charIndex){
			return 0;
		}

		__proto.getTextFormat=function(beginIndex,endIndex){
			(beginIndex===void 0)&& (beginIndex=-1);
			(endIndex===void 0)&& (endIndex=-1);
			if (beginIndex==-1 && endIndex==-1)
				return this._df.clone();
			var format;
			if (beginIndex !=-1 && endIndex !=-1){
				for (var i=this._originFormats.length-1;i >=0;i--){
					format=this._originFormats[i];
					if (format.begin==beginIndex && format.end==endIndex)
						return format.format.clone();
				}
				return null;
			}
			if (beginIndex !=-1 && endIndex==-1){
				for (i=this._originFormats.length-1;i >=0;i--){
					format=this._originFormats[i];
					if (beginIndex >=format.begin && beginIndex < format.end)
						return format.format;
				}
			}
			return null;
		}

		__proto.replaceText=function(beginIndex,endIndex,newText){
			var forepart=this._text.substring(0,beginIndex);
			var endpart=this._text.substring(endIndex);
			this._text=forepart+newText+endpart;
			var format;
			for (var i=0,len=this._originFormats.length;i < len;i++){
				format=this._originFormats[i];
				if (format.begin <=beginIndex && format.end >=beginIndex){
					format.end+=newText.length-(endIndex-beginIndex);
				}
			}
			this.createFormats();
			this.addToRender();
		}

		__proto.setSelection=function(beginIndex,endIndex){}
		__proto.setTextFormat=function(format,beginIndex,endIndex){
			if (!this._text || !this._text.length)
				return;
			this._formats=[];
			if (arguments.length==1){
				beginIndex=0;
				endIndex=this.text.length;
			}
			else if (arguments.length==2){
				endIndex=beginIndex+1;
			}
			this.addToRender();
			var tempFormat;
			for (var i=this._originFormats.length-1;i >=0;i--){
				tempFormat=this._originFormats[i];
				if (tempFormat.begin==beginIndex && tempFormat.end==endIndex){
					this._originFormats[i].format=this.mixTextFormats([this._originFormats[i].format,format]);
					this.createFormats();
					return;
				}
			}
			this.insertFormt(format,beginIndex,endIndex);
			this.createFormats();
		}

		__proto.numberSortCallback=function(a,b){
			return a > b ? 1 :-1;
		}

		__proto.createFormats=function(){
			if(!this._originFormats.length)
				this._originFormats.push({begin:0,end:this._text.length,format:this._df});
			this._formats.length=0;
			this.formatIndices.push(0,this._text.length);
			this.formatIndices.sort(__bind(this,this.numberSortCallback));
			var lastValue=this.formatIndices[this.formatIndices.length-1];
			for (var i=this.formatIndices.length-2;i >=0;i--){
				if (this.formatIndices[i]==lastValue || this.formatIndices[i] > this._text.length)
					this.formatIndices.splice(i,1);
				lastValue=this.formatIndices[i];
			}
			if(this.formatIndices[this.formatIndices.length-1] > this._text.length)
				this.formatIndices.pop();
			var end=this.formatIndices.length-1;
			for (i=0;i < end;i++){
				var relateFormats=this.getRelateTextForamts(this.formatIndices[i]);
				this._formats.push({format:this.mixTextFormats(relateFormats),begin:this.formatIndices[i],end:this.formatIndices[i+1]});
			}
			this.addToRender();
		}

		__proto.getBottomScrollV=function(startLine){
			if (this._lines.length==0 || startLine > this._lines.length)
				return 0;
			if (this._lines.length==1)
				return 1;
			if (this._textHeight < this._height)
				return this._lines.length;
			var totalLines=this._lines.length;
			for (var i=startLine-1;i < totalLines;i++){
				if (this._lines[i].y+this._lines[i].height > this._height+this.viewport[1])
					return i;
			}
			return totalLines;
		}

		__proto.getRelateTextForamts=function(index){
			var result=[];
			var len=this._originFormats.length;
			for (var i=0;i < len;i++){
				var format=this._originFormats[i];
				if (index >=format.begin && index < format.end){
					result.push(format.format);
				}
			}
			return result;
		}

		__proto.mixTextFormats=function(formats){
			var format;
			var result=formats[formats.length-1].clone();
			for (var i=formats.length-2;i >=0;i--){
				format=formats[i];
				result._align=(!result._align || result._align=="left")? format._align :result._align;
				result._bold=result._bold || format._bold;
				result._color=result._color || format._color;
				result._font=result._font || format._font;
				result._italic=result._italic || format._italic;
				result._leading=result._leading || format._leading;
				result._leftMargin=result._leftMargin || format._leftMargin;
				result._letterSpacing=result._letterSpacing || format._letterSpacing;
				result._size=result._size || format._size;
				result._underline=result._underline || format._underline;
			}
			result._strokeColor=this.strokeColor;
			return result;
		}

		__proto.stuffEnough=function(value,format,leftMargin){
			(leftMargin===void 0)&& (leftMargin=true);
			return value+(leftMargin && format.leftMargin ? format.leftMargin :0)+(format.blockIndent ? format.blockIndent :0)+(format.rightMargin ? format.rightMargin :0)<=this._width-2;
		}

		__proto.maxCharsLimit=function(text){
			if (this._maxChars > 0 && text.length > this._maxChars){
				if (this._text.length >=this._maxChars){
					if (text.length > this._text.length)
						text=this._text;
					else
					if (this._lastPressKey==/*iflash.ui.Keyboard.BACKSPACE*/8)
						this._caretIndex--;
				}
				else
				text=text.substr(0,this._maxChars);
				Browser.input.value=text;
				this.setHtmlInputCaret(this._caretIndex);
			}
			return text;
		}

		__proto.replaceSelectedText=function(value){}
		__proto.lyclone=function(){
			var result=new TextField();
			this.getTextResult(result);
			return result;
		}

		__proto.getTextResult=function(result){
			result._autoSize=this._autoSize;
			result.maxChars=this.maxChars;
			result.border=this.border;
			result._multiline=this._multiline;
			result._textHeight=this._textHeight;
			result._textWidth=this._textWidth;
			result._width=this._width;
			result._height=this._height;
			if (this._wordWrap)
				result._wordWrap=this._wordWrap;
			result.type=this._type;
			if (this.tempBound)
				result.tempBound=this.tempBound;
			result.x=this.x;
			result.y=this.y;
			if (this._df !=TextField.DF)
				result._df=this._df.clone()
			if (this._htmlText)
				result.htmlText=this._htmlText;
			else
			result.text=this._text;
			result.strokeColor=this.strokeColor;
			result.strokeThickness=this.strokeThickness;
		}

		__proto.parseHTMLText=function(xml){
			if(xml==null)return;
			var tagName=xml.nodeName;
			if (tagName=="#text" || tagName=="#cdata-section")
				this._text+=xml.textContent;
			else if (!xml.length){
				var startIndex=this._text.length;
				var format=new TextFormat();
				if (xml.childNodes && !xml.childNodes.length){
					if (xml.firstChild && xml.firstChild.nodeType==3)
						this._text+=xml.textContent;
				}
				else{
					this.parseHTMLText(xml.childNodes);
				};
				var getAtt=function (name){
					if (Laya.CONCHVER){
						var atts=xml.attributes;
						for (var i=atts.length-1;i >=0;i--){
							if (atts[i].nodeName==name || atts[i].nodeName==name.toUpperCase())
								return atts[i].nodeValue;
						}
					}
					else
					return xml.getAttribute(name)|| xml.getAttribute(name.toUpperCase());
				};
				tagName=tagName.toLowerCase();
				switch (tagName){
					case "b":
						format.bold=true;
						break ;
					case "br":
						this._text+="\n";
						break ;
					case "font":;
						var color=getAtt("color");
						if (color){
							format.color=String(color).replace("#","0x");
							format.color=Laya.__parseInt(format.color,16);
						};
						var face=getAtt("face");
						if (face)
							format.font=face;
						var size=getAtt("size");
						if (size){
							var firstChar=size.charAt(0);
							if (firstChar=="+")
								format.size=Number(format.size)+Laya.__parseInt(size);
							else if (firstChar=="-")
							format.size=Number(format.size)-Laya.__parseInt(size);
							else
							format.size=getAtt("size");
						}
						break ;
					case "i":
						format.italic=true;
						break ;
					case "p":;
						var align=getAtt("align");
						if (align)
							format.align=align;
						this._multiline && (this._text+="\n");
						break ;
					case "textformat":;
						var blockIndent=getAtt("blockindent");
						if (blockIndent)
							format.blockIndent=blockIndent;
						var indent=getAtt("indent");
						if (indent)
							format.indent=indent;
						var leading=getAtt("leading");
						if (leading)
							format.leading=leading;
						var leftmargin=getAtt("leftmargin");
						if (leftmargin)
							format.leftMargin=leftmargin;
						var rightmargin=getAtt("rightmargin");
						if (rightmargin)
							format.rightMargin=rightmargin;
						break ;
					case "u":
						format.underline=true;
						break ;
					case "a":;
						var href=getAtt("href");
						this._links || (this._links=[]);
						href || (href="");
						if (href.indexOf("event:")==0){
							var te=new TextEvent(/*iflash.events.TextEvent.LINK*/"link");
							te.text=href.substr(6);
							this._links.push({event:te});
						}
						else{
							this._links.push({event:href});
						}
						break ;
					case "img":
						break ;
					}
				if (tagName=="a"){
					this._links[this._links.length-1].begin=startIndex;
					this._links[this._links.length-1].end=this._text.length;
				}
				else
				this.insertFormt(format,startIndex,this._text.length,false);
			}
			else{
				var xmlLength=xml.length;
				if (xmlLength==1 && xml[0].nodeType==3){
					this._text+=xml[0].textContent;
				}
				else{
					for (var i=0;i < xmlLength;i++){
						this.parseHTMLText(xml[i]);
					}
				}
			}
		}

		__proto.insertFormt=function(format,beginIndex,endIndex,usePush){
			(usePush===void 0)&& (usePush=true);
			var temp={begin:beginIndex,end:endIndex,format:format.clone()};
			if (usePush)
				this._originFormats.push(temp);
			else
			this._originFormats.unshift(temp);
			this.formatIndices.push(beginIndex,endIndex);
		}

		__proto._getBounds_=function(targetSpace,resultRect){
			if (!resultRect)
				resultRect=new Rectangle();
			if(this._type=="input")
				resultRect.setTo(this.viewport[0],this.viewport[1],this._width,this._height);
			else
			resultRect.setTo(this.viewport[0],this.viewport[1],this.width,this.height);
			return resultRect;
		}

		__proto._hitTest_=function(_x,_y){
			if (!this.visible || !this.mouseEnabled)
				return null;
			if (!this._checkHitMask(_x,_y)){
				return null;
			}
			if (this._getBounds_(this,DisplayObject.HELPER_RECTANGLET).containsPoint(DisplayObject.HELPER_POINT.setTo(_x,_y))){
				return this;
			}
			else{
				return null;
			}
		}

		__proto._paintChild_=function(context,x,y,w,h){
			this.renderThis();
			DrawText.drawBG(context,x,y,this);
			DrawText.printText(this,context,x,y);
		}

		__proto.getLineIndex=function(line){
			for (var i=this._lines.length-1;i >=0;i--){
				if (this._lines[i]==line)
					return i;
			}
			return-1;
		}

		__proto.getNodeFromLineByIndex=function(index,line){
			var nodes=line.nodes;
			var node;
			var len=nodes.length;
			for (var i=0;i < len;i++){
				node=nodes[i];
				if (index >=node.firstCharIndex && index <=node.lastCharIndex)
					return node;
			}
			return nodes[len-1];
		}

		__proto.setHtmlInputCaret=function(caret){
			caret=Math.max(this._text.length,caret);
			Browser.input.setSelectionRange(caret,caret);
		}

		__proto.scrollVWithoutRender=function(value){
			if (value < 0 || value > this._lines.length)
				return;
			if (this._maxScrollV > 1){
				var lastValue=this._scrollV;
				this._scrollV=Math.max(value,1)| 0;
				this._scrollV=Math.min(this._scrollV,this._maxScrollV)| 0;
				if (this._scrollV > this._maxScrollV)
					if (lastValue==this._scrollV)
				return;
				this.viewport[1]=this._lines[this._scrollV-1].y;
				this._bottomScrollV=this.getBottomScrollV(this._scrollV);
				this._modle_.textView(this.viewport[0],this.viewport[1]);
				this.dispatchEvent(new Event(/*iflash.events.Event.SCROLL*/"scroll"));
			}
			else{
				this._bottomScrollV=this._lines.length;
				this._scrollV=1;
				this.viewport[1]=0;
				this._modle_.textView(this.viewport[0],this.viewport[1]);
			}
		}

		__proto.scrollHWithoutRender=function(value){
			if (value < 0)
				value=0;
			else if (value > this.maxScrollH)
			value=this.maxScrollH;
			if (this.viewport[0]==value)
				return;
			this.viewport[0]=value;
			this._modle_.textView(this.viewport[0],this.viewport[1]);
			this.dispatchEvent(new Event(/*iflash.events.Event.SCROLL*/"scroll"));
		}

		__proto.layaDestory=function(){
			this._df=null;
			this.nodes=null;
			if(this._scroller){
				this._scroller.stop();
				this._scroller.removeEventListener(/*iflash.events.TimerEvent.TIMER*/"timer",__bind(this,this.onTextScroll));
				this._scroller=null;
			}
			this._originFormats=null;
			this._formats=null;
			this._lines=null;
			this._currLineInfo=null;
			this._nodeCoordinate=null;
		}

		__getset(0,__proto,'autoSize',function(){
			return this._autoSize;
			},function(value){
			var oldAutoSize=this._autoSize || "none";
			var newAutoSize=value || "none";
			if(oldAutoSize !=newAutoSize && !this._wordWrap){
				this.addToRender();
				this.renderThis();
				if(newAutoSize=='center')
					this._autoSizeX=this["_left_"]+(this._autoSizeWidth)/ 2;
				else if(newAutoSize=='right')
				this._autoSizeX=this["_left_"]+(this._autoSizeWidth-this._textWidth);
				else
				this._autoSizeX=this._originalX || 0;
			}
			this._autoSize=value;
			this.autosize();
		});

		__getset(0,__proto,'displayAsPassword',function(){
			return this._disAsPass;
			},function(value){
			this._disAsPass=value;
			this.addToRender();
		});

		__getset(0,__proto,'background',function(){
			return this._background || false;
			},function(value){
			this._backgroundColor || (this._backgroundColor="#FFFFFF");
			this._background=value;
			(Laya.CONCHVER && value)&& (this._modle_.bgcolor(this._backgroundColor));
		});

		__getset(0,__proto,'backgroundColor',function(){
			if (this._backgroundColor)
				return Laya.__parseInt("0x"+this._backgroundColor.substring(2),16);
			return 0xFFFFFF;
			},function(value){
			this._backgroundColor=StringMethod.getColorString(value);
			(Laya.CONCHVER && this._background)&& (this._modle_.bgcolor(this._backgroundColor));
		});

		__getset(0,__proto,'caretIndex',function(){
			return this._caretIndex;
		});

		__getset(0,__proto,'border',function(){
			return this._border || false;
			},function(value){
			this._borderColor || (this._borderColor="#000000");
			this._border=value;
			(Laya.CONCHVER && value)&& (this._modle_.border(this._borderColor));
		});

		__getset(0,__proto,'embedFonts',function(){
			return false;
			},function(value){
		});

		__getset(0,__proto,'text',function(){
			return this._text;
			},function(value){
			this._htmlText='';
			if(value==undefined){
				throw new Error("Parameter text must be non-null.");
			}
			if (value==""){
				this.engine_clear(true);
				return;
			}
			this._text=value+'';
			this._nodeIndex=0;
			this.addToRender();
			this.viewport[0]=0;
			this._modle_.textView(this.viewport[0],this.viewport[1]);
			this._scrollV=1;
			this._originFormats.length=0;
			this._originFormats.push({begin:0,end:this._text.length,format:this._df});
			this.formatIndices.length=0;
			this.createFormats();
			this._isNextLineNewParagraph=true;
		});

		__getset(0,__proto,'condenseWhite',function(){
			return this._condenseWhite;
			},function(value){
			this._condenseWhite=value;
		});

		__getset(0,__proto,'selectedText',function(){
			return this._selectable;
		});

		__getset(0,__proto,'borderColor',function(){
			return Laya.__parseInt("0x"+this._borderColor.substring(2),16);
			},function(value){
			this._borderColor=StringMethod.getColorString(value);
			(Laya.CONCHVER && this._border)&& (this._modle_.border(this._borderColor));
		});

		__getset(0,__proto,'scrollH',function(){
			return this.viewport[0];
			},function(value){
			this.scrollHWithoutRender(value);
			this.engine_layout();
		});

		__getset(0,__proto,'bottomScrollV',function(){
			this.renderThis();
			return this._bottomScrollV;
		});

		__getset(0,__proto,'defaultTextFormat',function(){
			return this._df.clone();
			},function(format){
			if (this._df==TextField.DF)
				this._df=new TextFormat();
			this._df.align=format.align || this._df.align;
			this._df.blockIndent=format.blockIndent || this._df.blockIndent;
			this._df.bold=format.bold || this._df.bold;
			this._df.bullet=format.bold || this._df.bullet;
			if(format.color !=null)
				this._df.color=format.color;
			else
			this._df.color=this._textColor || this._df.color;
			this._df.display=format.display || this._df.display;
			this._df.font=format.font || this._df.font;
			this._df.indent=format.indent || this._df.indent;
			this._df.italic=format.italic || this._df.italic;
			this._df.leading=format.leading || this._df.leading;
			this._df.leftMargin=format.leftMargin || this._df.leftMargin;
			this._df.letterSpacing=format.letterSpacing || this._df.letterSpacing;
			this._df.rightMargin=format.rightMargin || this._df.rightMargin;
			this._df.size=format.size || this._df.size;
			this._df.tabStops=format.tabStops || this._df.tabStops;
			this._df.target=format.target || this._df.target;
			this._df.underline=format.underline || this._df.underline;
			this._df.url=format.url;
			if (this._type !="input" && this._text && this._text.length){
				this.addToRender();
				this.createFormats();
			}
		});

		__getset(0,__proto,'htmlText',function(){
			return this._htmlText;
			},function(value){
			if (value=="" && this._text)
				this.engine_clear(true);
			this._links && (this._links.length=0);
			this._originFormats.length=0;
			this._htmlText=value;
			this._text="";
			if (!this._htmlText || !this._htmlText.length){
				this.nodes.clear();
				this.conchNodes && this.conchNodes.clear();
				Laya.CONCHVER && (this._modle_.textStrs(this.conchNodes));
				return;
			}
			this.addToRender();
			if(Laya.CONCHVER){
				if(/^\x20+$/g.test(value)){
					this.text=value;
					return;
				}
			}
			value="<data>"+value+"</data>";
			value=value.replace(/(\<br\>|\n)/g,"<br/>");
			if (this._condenseWhite)
				value=value.replace(/(\s)+/g,'$1');
			/*__JS__ */var xml=(new DOMParser()).parseFromString(value,'text/xml');;
			if (!Laya.CONCHVER){
				/*__JS__ */if(!xml.childNodes[0].textContent)return;
			}
			/*__JS__ */var data=xml.childNodes[0].childNodes;
			this.formatIndices.length=0;
			this.parseHTMLText(/*__JS__ */data);
			if (Laya.CONCHVER)
				this._text=TextField.decodeFromEntities(this._text);
			this._originFormats.unshift({begin:0,end:this._text.length,format:this._df});
			this.createFormats();
			this._isNextLineNewParagraph=true;
		});

		__getset(0,__proto,'length',function(){
			return this._text ? this._text.length :0;
		});

		__getset(0,__proto,'maxChars',function(){
			return this._maxChars;
			},function(value){
			this._maxChars=value;
		});

		__getset(0,__proto,'maxScrollH',function(){
			if (!this._textWidth)
				return 0;
			this.renderThis();
			return Math.max(0,this._textWidth-(this._width-1-2-2));
		});

		__getset(0,__proto,'maxScrollV',function(){
			this.renderThis();
			return this._maxScrollV ? this._maxScrollV :1;
		});

		__getset(0,__proto,'multiline',function(){
			return this._multiline;
			},function(value){
			this._multiline=value;
		});

		__getset(0,__proto,'numLines',function(){
			this.renderThis();
			if (!this._lines || this._lines.length==0)
				return 1;
			return this._lines.length;
		});

		__getset(0,__proto,'restrict',function(){
			if (Laya.CONCHVER)
				return this._restrict;
			else
			return !this._restrict ? "" :this._restrict.source;
			},function(value){
			if (Laya.CONCHVER)
				this._restrict=value;
			else{
				if (!value){
					this._restrict=null;
					return;
				}
				if (!(/^\[.+\]$/.test(value)))
					value="[^"+value+"]";
				this._restrict=new RegExp(value,"g");
			}
		});

		__getset(0,__proto,'scrollV',function(){
			return this._scrollV ? this._scrollV :1;
			},function(value){
			this.scrollVWithoutRender(value);
			this.engine_layout();
		});

		__getset(0,__proto,'useRichTextClipboard',function(){
			return false;
			},function(value){
		});

		__getset(0,__proto,'_filters',null,function(value){
			var a=value[0];
			this.strokeColor=StringMethod.getColorString(a.color);
			this.strokeThickness=a.blurX;
		});

		__getset(0,__proto,'selectable',function(){
			return this._selectable;
			},function(value){
			this._selectable=value;
			if (!value && this._scroller){
				this._scroller.running && this._scroller.stop();
				this._scroller.removeEventListener(/*iflash.events.TimerEvent.TIMER*/"timer",__bind(this,this.onTextScroll));
				this._scroller=null;
			}
		});

		__getset(0,__proto,'selectionBeginIndex',function(){
			return this._selectionBeginIndex;
		});

		__getset(0,__proto,'y',function(){
			return _super.prototype._$get_y.call(this)-(this.tempBound ? this.tempBound.y :0);
			},function(value){
			_super.prototype._$set_y.call(this,value+(this.tempBound ? this.tempBound.y :0));
			if(this._type=="input" && Laya.CONCHVER && (Stage.stage.focus==this)){
				var concatedMatrix=this._getConcatenatedMatrix();
				var tempY=concatedMatrix.ty *Laya.window.scale.y+Laya.document.body.y;
				if(tempY !=Browser.input.top){
					Browser.input.setPos(concatedMatrix.tx *Laya.window.scale.x+Laya.document.body.x,tempY);
				}
			}
		});

		__getset(0,__proto,'selectionEndIndex',function(){
			return this._selectionEndIndex;
		});

		__getset(0,__proto,'sharpness',function(){
			return 0;
			},function(value){
		});

		__getset(0,__proto,'textColor',function(){
			return this._textColor;
			},function(value){
			if (value > 0xFFFFFF)
				value=Number("0x"+value.toString(16).substr(2));
			if (this._df==TextField.DF)
				this._df=new TextFormat();
			if (this._originFormats[0])
				this._originFormats[0].format=this._df;
			this._textColor=value;
			this._df.color=this._textColor;
			if (this._text && this._text.length > 0){
				this.createFormats();
				this.addToRender();
			}
		});

		__getset(0,__proto,'textHeight',function(){
			this.renderThis();
			return this._textHeight;
		});

		__getset(0,__proto,'thickness',function(){
			return 0;
			},function(value){
		});

		__getset(0,__proto,'textWidth',function(){
			this.renderThis();
			return this._textWidth;
		});

		__getset(0,__proto,'type',function(){
			return this._type;
			},function(value){
			this._type=value;
			if (this._type=="input"){
				this._caretIndex=0;
				if(!Laya.document.canvas['onmouseup'] && TextField.onMobile){
					Laya.document.canvas['onmouseup']=function (e){
						if(iflash.text.TextField.isInputting){
							if(Browser.input.parentNode)
								Browser.input.target.checkTextFocusout(null);
							else
							Browser.addToBody(Browser.input);
							Browser.input.focus();
						}
					}
				}
			}
		});

		__getset(0,__proto,'wordWrap',function(){
			return this._wordWrap || false;
			},function(value){
			if (this._wordWrap !=value)
				this.addToRender();
			this._wordWrap=value;
		});

		__getset(0,__proto,'width',function(){
			this.renderThis();
			if (this._wordWrap)
				return this._width;
			return (this._autoSize && this._autoSize !="none")? this._textWidth+(2+2):this._width;
			},function(value){
			if (value < 0)
				return;
			if(this._autoSize && this._autoSize !="none"){
				this.renderThis();
				if(this._autoSize=="center"){
					this._autoSizeX=this.x+value / 2;
				}
				else if(this._autoSize=="right"){
					this._autoSizeX=this.x+value;
				}
				this._autoSizeWidth=this._textWidth;
			}
			else
			this._autoSizeWidth=value;
			this._width=value;
			this.addToRender();
		});

		__getset(0,__proto,'height',function(){
			this.renderThis();
			return (this._autoSize && this._autoSize !="none")? this._textHeight+2+2 :this._height;
			},function(value){
			if (value==this._height || value <=0)
				return;
			this._height=value;
			this.addToRender();
		});

		__getset(0,__proto,'x',function(){
			this.renderThis();
			return _super.prototype._$get_x.call(this)-(this.tempBound ? this.tempBound.x :0);
			},function(value){
			this._originalX=value;
			if(this._autoSize=='center')
				this._autoSizeX=value+this.width / 2;
			else if(this._autoSize=='right')
			this._autoSizeX=value+this.width;
			else
			this._autoSizeX=value;
			if(this._autoSize && this._autoSize !="none")
				this._autoSizeWidth=this._textWidth;
			else
			this._autoSizeWidth=this._width;
			_super.prototype._$set_x.call(this,value+(this.tempBound ? this.tempBound.x :0));
			if(this._type=="input" && (Stage.stage.focus==this)){
				var concatedMatrix=this._getConcatenatedMatrix();
				var tempX=concatedMatrix.tx *Laya.window.scale.x+Laya.document.body.x;
				if(tempX !=Browser.input.left){
					Browser.input.setPos(tempX,concatedMatrix.ty *Laya.window.scale.y+Laya.document.body.y);
				}
			}
		});

		__getset(0,__proto,'filters',_super.prototype._$get_filters,function(filters){
			if (!filters){
				_super.prototype._$set_filters.call(this,filters);
				return;
			};
			var strokeFilter;
			for (var i=filters.length-1;i >=0;i--){
				if (((filters[i])instanceof iflash.filters.GlowFilter )){
					strokeFilter=filters[i];
					filters.splice(i,1);
					break ;
				}
			}
			if (strokeFilter){
				this.strokeColor=StringMethod.getColorString(strokeFilter.color);
				this.strokeThickness=(strokeFilter.blurX / 5)*3+1;
				if (this._text && this._text.length){
					for (i=this._formats.length-1;i >=0;i--)
					this._formats[i].format._strokeColor=this.strokeColor;
				}
			}
			else{
				this.strokeColor=null;
				this.strokeThickness=null;
			}
			_super.prototype._$set_filters.call(this,filters);
		});

		__getset(0,__proto,'gridFitType',function(){
			return '';
			},function(value){
		});

		__getset(0,__proto,'textInteractionMode',function(){
			return null
		});

		__getset(0,__proto,'alwaysShowSelection',function(){
			return false;
			},function(value){
		});

		__getset(0,__proto,'mouseWheelEnabled',function(){
			return false
			},function(value){
		});

		__getset(0,__proto,'styleSheet',function(){
			return null;
			},function(value){
		});

		TextField.renderTexts=function(){
			var len=TextField.TextsToRender.length;
			if (len==0)
				return;
			for (var i=len-1;i >=0;i--){
				var t=TextField.TextsToRender.pop();
				t.engine_updateStyle();
			}
		}

		TextField.isFontCompatible=function(fontName,fontStyle){
			return true;
		}

		TextField.decodeFromEntities=function(str){
			return str.replace(/\&#?\w{2,6};/g,function(__args){
				var args=arguments;
				return TextField.Entities[args[0]];
			});
		}

		TextField.LINE_WIDTH=1;
		TextField.LEFT_PADDING=2;
		TextField.RIGHT_PADDING=2;
		TextField.TOP_PADDING=2;
		TextField.BOTTOM_PADDING=2;
		TextField.borderStyle="3px solid orange";
		TextField.TextsToRender=[];
		TextField.isInputting=false;
		__static(TextField,
		['LINE_LEADING',function(){return this.LINE_LEADING=Laya.CONCHVER ?-2 :0;},'myAgent',function(){return this.myAgent=/*__JS__ */navigator.userAgent;},'onIPhone',function(){return this.onIPhone=TextField.myAgent.indexOf("iPhone")>-1;},'onIPad',function(){return this.onIPad=TextField.myAgent.indexOf("iPad")>-1;},'onAndriod',function(){return this.onAndriod=TextField.myAgent.indexOf("Android")>-1;},'onWP',function(){return this.onWP=TextField.myAgent.indexOf("Windows Phone")>-1;},'onQQ',function(){return this.onQQ=TextField.myAgent.indexOf("QQBrowser")>-1;},'onMobile',function(){return this.onMobile=TextField.onIPhone || TextField.onAndriod || TextField.onWP || TextField.onIPad;},'initialWindowWidth',function(){return this.initialWindowWidth=/*__JS__ */window.innerWidth;},'initialWindowHeight',function(){return this.initialWindowHeight=/*__JS__ */window.innerHeight;},'deviceAvailWidth',function(){return this.deviceAvailWidth=/*__JS__ */window.screen.availWidth;},'deviceAvailHeight',function(){return this.deviceAvailHeight=/*__JS__ */window.screen.availHeight;},'pixelRatio',function(){return this.pixelRatio=TextField.deviceAvailHeight / TextField.initialWindowHeight;},'inputHeight',function(){return this.inputHeight=(50 / Math.min(1,TextField.pixelRatio)/ 2 | 0)*2;},'textAreaHeight',function(){return this.textAreaHeight=(80 / Math.min(1,TextField.pixelRatio)/ 2 | 0)*2;},'inputFontSize',function(){return this.inputFontSize=((25 / Math.min(1,TextField.pixelRatio)/ 2 | 0)+1)*2;},'DF',function(){return this.DF=new TextFormat("Times New Roman",12,0x000000,false,false,false,null,null,"left",null,null,null,null);},'Entities',function(){return this.Entities={"&nbsp;":" ","&#160;":" ","&lt;":"<","&#60;":"<","&gt;":">","&#62;":">","&amp;":"&","&amp;":"&","&quot;":"\"","&#34;":"\"","&apos;":"'",
				"&#39;":"'","&cent;":"￠","&#162;":"￠","&pound;":"￡","&#163;":"￡","&yen;":"￥","&#165;":"￥","&euro;":"€","&#8364;":"€","&sect;":"§","&#167;":"§","&copy;":"?","&#169;":"?",
				"&reg;":"?","&#174;":"?","&trade;":"?","&#8482;":"?","&times;":"×","&#215;":"×","&divide;":"÷","&#247;":"÷"};}
		]);
		return TextField;
	})(InteractiveObject)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/sprite.as
	//class iflash.display.Sprite extends iflash.display.DisplayObjectContainer
	var Sprite=(function(_super){
		function Sprite(){
			this._graphics=null;
			this._dragRect_=null;
			this._prelocationX_=0;
			this._prelocationY_=0;
			this._sc9Y_=1;
			this._sc9X_=1;
			this._hitArea=null;
			Sprite.__super.call(this);
		}

		__class(Sprite,'iflash.display.Sprite',false,_super);
		var __proto=Sprite.prototype;
		__proto._paintGraphics_=function(context,x,y,w,h){
			if (this._graphics){
				var grapics=this._graphics;
				if(grapics.isReady()){
					grapics._canvas_.paint(context,x,y,w,h);
				}
				this._paintChild_(context,x,y,w,h);
			}
			else
			this._paintChild_(context,x,y,w,h);
		}

		__proto.startDrag=function(lockCenter,bounds){
			(lockCenter===void 0)&& (lockCenter=false);
			this._dragRect_=bounds;
			this.stage.addEventListener(/*iflash.events.Event.ENTER_FRAME*/"enterFrame",__bind(this,this.__drag__));
			if(lockCenter){
				this._prelocationX_=0;
				this._prelocationY_=0;
				}else{
				if(Sprite._startedDrag_)return;
				this._prelocationX_=EventManager._stageX-this.x;
				this._prelocationY_=EventManager._stageY-this.y;
			}
			Sprite._startedDrag_=true;
			this.__drag__();
		}

		__proto.stopDrag=function(){
			this.stage&&this.stage.removeEventListener(/*iflash.events.Event.ENTER_FRAME*/"enterFrame",__bind(this,this.__drag__));
			this._dragRect_=null;
			Sprite._startedDrag_=false;
		}

		__proto.__drag__=function(e){
			if(!Sprite._startedDrag_)return;
			this.x=EventManager._stageX-this._prelocationX_;
			this.y=EventManager._stageY-this._prelocationY_;
			if(this._dragRect_){
				if(this.x>this._dragRect_.width+this._dragRect_.x)
					this.x=this._dragRect_.width+this._dragRect_.x;
				if(this.y>this._dragRect_.height+this._dragRect_.y)
					this.y=this._dragRect_.height+this._dragRect_.y;
				if(this.x<this._dragRect_.x)
					this.x=this._dragRect_.x;
				if(this.y<this._dragRect_.y)
					this.y=this._dragRect_.y;
			}
		}

		__proto._lyToBody_=function(){
			this.updateScaleData();
			_super.prototype._lyToBody_.call(this);
		}

		__proto._hitTest_=function(x,y){
			if(!this.visible)return null;
			var target=_super.prototype._hitTest_.call(this,x,y);
			if(target)return target;
			return this.graphicsHited(x,y);
		}

		__proto.graphicsHited=function(x,y){
			if(this._graphics){
				if (!this._checkHitMask(x,y)){return null;}
					if (!this._checkHitScrollRect(x,y)){return null;}
				if (this._private_._scrollRect_){x+=this._private_._scrollRect_.x;y+=this._private_._scrollRect_.y;}
					DisplayObject.HELPER_RECTANGLET.setTo(this._graphics.x,this._graphics.y,this._graphics.width*this.scaleX,this._graphics.height*this.scaleY);
				if(DisplayObject.HELPER_RECTANGLET.contains(x,y)){
					return this;
				}
			}
			return null;
		}

		__proto.hitAreaMouseHandler=function(event){
			this.dispatchEvent(new MouseEvent(event.type));
		}

		__proto._getBounds_=function(targetSpace,resultRect){
			if(!resultRect)
				resultRect=new Rectangle();
			_super.prototype._getBounds_.call(this,targetSpace,resultRect);
			if(this._graphics){
				DisplayObject.HELPER_RECTANGLET_ALT.setTo(this._graphics.x,this._graphics.y,this._graphics.width,this._graphics.height);
				if(DisplayObject.HELPER_RECTANGLET_ALT.width&&DisplayObject.HELPER_RECTANGLET_ALT.height){
					if(this.numChildren)
						resultRect._union_(DisplayObject.HELPER_RECTANGLET_ALT);
					else
					resultRect.setTo(DisplayObject.HELPER_RECTANGLET_ALT.x,DisplayObject.HELPER_RECTANGLET_ALT.y,DisplayObject.HELPER_RECTANGLET_ALT.width,DisplayObject.HELPER_RECTANGLET_ALT.height);
				}
			}
			return resultRect;
		}

		__getset(0,__proto,'graphics',function(){if(!this._graphics)this._graphics=new Graphics(this);
			return this._graphics;
		});

		__getset(0,__proto,'buttonMode',function(){
			return false;
		},LAYAFNVOID/*function(value){}*/);

		__getset(0,__proto,'width',_super.prototype._$get_width,function(w){
			if(w<0)return;
			if(this.scale9Data){
				var c=this._childs_[0];
				c&&c.scale9Data&&(c.width=w);
				this._width_=w
			}
			else _super.prototype._$set_width.call(this,w);
		});

		__getset(0,__proto,'useHandCursor',function(){
			return (this._type_&0x80)!=0;
			},function(value){
			if(value)
				this._type_|=0x80;
			else
			this._type_&=~0x80;
		});

		__getset(0,__proto,'dropTarget',LAYAFNNULL/*function(){return null}*/);
		__getset(0,__proto,'height',_super.prototype._$get_height,function(h){
			if(h<0)return;
			if(this.scale9Data){
				var c=this._childs_[0];
				c&&c.scale9Data&&(c.height=h);
				this._height_=h;
			}
			else _super.prototype._$set_height.call(this,h);
		});

		__getset(0,__proto,'hitArea',function(){
			return this._hitArea;
			},function(value){
			if (this._hitArea){
				this._hitArea.removeEventListener(/*iflash.events.MouseEvent.CLICK*/"click",__bind(this,this.hitAreaMouseHandler));
				this._hitArea.removeEventListener(/*iflash.events.MouseEvent.DOUBLE_CLICK*/"doubleClick",__bind(this,this.hitAreaMouseHandler));
				this._hitArea.removeEventListener(/*iflash.events.MouseEvent.MOUSE_DOWN*/"mouseDown",__bind(this,this.hitAreaMouseHandler));
				this._hitArea.removeEventListener(/*iflash.events.MouseEvent.MOUSE_MOVE*/"mouseMove",__bind(this,this.hitAreaMouseHandler));
				this._hitArea.removeEventListener(/*iflash.events.MouseEvent.MOUSE_OUT*/"mouseOut",__bind(this,this.hitAreaMouseHandler));
				this._hitArea.removeEventListener(/*iflash.events.MouseEvent.MOUSE_OVER*/"mouseOver",__bind(this,this.hitAreaMouseHandler));
				this._hitArea.removeEventListener(/*iflash.events.MouseEvent.MOUSE_UP*/"mouseUp",__bind(this,this.hitAreaMouseHandler));
			}
			this._hitArea=value;
			this.mouseEnabled=this._hitArea !=null ? false :true;
			if (this._hitArea){
				this._hitArea.addEventListener(/*iflash.events.MouseEvent.CLICK*/"click",__bind(this,this.hitAreaMouseHandler));
				this._hitArea.addEventListener(/*iflash.events.MouseEvent.DOUBLE_CLICK*/"doubleClick",__bind(this,this.hitAreaMouseHandler));
				this._hitArea.addEventListener(/*iflash.events.MouseEvent.MOUSE_DOWN*/"mouseDown",__bind(this,this.hitAreaMouseHandler));
				this._hitArea.addEventListener(/*iflash.events.MouseEvent.MOUSE_MOVE*/"mouseMove",__bind(this,this.hitAreaMouseHandler));
				this._hitArea.addEventListener(/*iflash.events.MouseEvent.MOUSE_OUT*/"mouseOut",__bind(this,this.hitAreaMouseHandler));
				this._hitArea.addEventListener(/*iflash.events.MouseEvent.MOUSE_OVER*/"mouseOver",__bind(this,this.hitAreaMouseHandler));
				this._hitArea.addEventListener(/*iflash.events.MouseEvent.MOUSE_UP*/"mouseUp",__bind(this,this.hitAreaMouseHandler));
			}
		});

		__getset(0,__proto,'scaleY',function(){
			return this.scale9Data?this._sc9Y_:_super.prototype._$get_scaleY.call(this);
			},function(value){
			if(this.scale9Data){
				var c=this._childs_[0];
				c&&c.scale9Data&&(c.scaleY=value);
				this._sc9Y_=value;
				this._height_ *=value;
			}
			else _super.prototype._$set_scaleY.call(this,value);
		});

		__getset(0,__proto,'scaleX',function(){
			return this.scale9Data?this._sc9X_:_super.prototype._$get_scaleX.call(this);
			},function(value){
			if(this.scale9Data){
				var c=this._childs_[0];
				c&&c.scale9Data&&(c.scaleX=value);
				this._sc9X_=value;
				this._width_ *=value;
			}
			else _super.prototype._$set_scaleX.call(this,value);
		});

		Sprite._startedDrag_=false;
		return Sprite;
	})(DisplayObjectContainer)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/loader.as
	//class iflash.display.Loader extends iflash.display.DisplayObjectContainer
	var Loader=(function(_super){
		function Loader(){
			this._contentLoaderInfo=null;
			this.__content__=null;
			this.__element__=null;
			this._bitmapData=null;
			this._resUrl="";
			this.shapeRes=null;
			this.preIndex=0;
			this.preLoader=[];
			this.isFlag=false;
			Loader.__super.call(this);
			this._contentLoaderInfo=LoaderInfo.create(this._getID_);
			this._contentLoaderInfo.loader=this;
		}

		__class(Loader,'iflash.display.Loader',false,_super);
		var __proto=Loader.prototype;
		__proto.onSetResUrlHandler=function(evt){
			this._resUrl=evt.lyData.url;
		}

		__proto.disposeLoader=function(){
			if(!this._contentLoaderInfo)
				return
			this.unload();
			this.isFlag=false;
			var resMapDic=this._contentLoaderInfo._resourceDic_;
			var reDomain=this._contentLoaderInfo._reDomain_;
			for(var key in resMapDic){
				var clas=resMapDic[key];
				if(reDomain){
					if(reDomain._resMapDic_[key])
						delete reDomain._resMapDic_[key];
				}
				if((clas instanceof iflash.display.MovieClip )){
					clas.layaDestory();
					Runnner.template.splice(Runnner.template.indexOf(clas.runner),1);
					}else{
					if((clas instanceof iflash.text.StaticText ))
						return;
					if((clas instanceof iflash.text.TextField ))
						return;
					if(clas)clas.layaDestory();
				}
			}
			this._contentLoaderInfo._applicationDomain._resMapDic_=null;
			this._contentLoaderInfo._applicationDomain=null;
			this._contentLoaderInfo._resourceDic_ && (this._contentLoaderInfo.deleteResourceDic());
			this._contentLoaderInfo._reDomain_=null;
			this._contentLoaderInfo && (delete LoaderInfo._loaderInfos_[this._contentLoaderInfo.__id__]);
			this._contentLoaderInfo=null;
			this._eventListener_ && (this._eventListener_=null);
		}

		__proto.load=function(request,context){
			var _$this=this;
			this._checkloaderInfo();
			var index=(request.url).lastIndexOf("?");
			this._contentLoaderInfo.lyurl=request.url;
			this._contentLoaderInfo.__fileurl=request.url;
			var urlStr=Method.formatUrlType(request.url);
			request.url=Method.formatUrl(request.url);
			if(!context){
				context=new LoaderContext(false,new ApplicationDomain());
			}
			this._contentLoaderInfo._reDomain_=context.applicationDomain;
			this.contains(this.__content__)&&this.removeChild(this.__content__);
			switch (urlStr){
				case "swf":
				case "swp":
				case "cvt":
					Stage.USE_SMALL ? this.loadSwf_Small(request.url,urlStr):this.loadSwf(request.url);
					break ;
				default :
					this._bitmapData=new BitmapData();
					var fileLoadType=false;
					var data=Browser.document.createElement("image");
					data.onload=function (__args){
						var args=arguments;
						if (Laya.HTMLVER&&!Laya.CONCHVER&&urlStr=="jng"){
							data=Method._JpgToPng(data);
							_$this._bitmapData.setType(/*iflash.display.BitmapData.CANVAS*/1);
							_$this._bitmapData.setCanvas(data);
						}else _$this._bitmapData.setImage(data);
						_$this.__content__=new Bitmap(_$this._bitmapData);
						_$this._contentLoaderInfo.__content__=_$this.__content__;
						_$this._contentLoaderInfo.height=_$this.__content__.height;
						_$this._contentLoaderInfo.width=_$this.__content__.width;
						_$this.addChild(_$this.__content__);
						_$this.__element__=data;
						_$this.contentLoaderInfo.dispatchEvent(new Event(/*iflash.events.Event.INIT*/"init",false,false,_$this.__content__));
						_$this.contentLoaderInfo.dispatchEvent(new Event(/*iflash.events.Event.COMPLETE*/"complete",false,false,_$this.__content__));
						_$this.dispatchEvent(new Event(/*iflash.events.Event.COMPLETE*/"complete"));
						data.onerror=data.onload=null;
						fileLoadType=true;
					};
					data.onerror=function (__args){
						var args=arguments;
						var io=new IOErrorEvent(/*iflash.events.IOErrorEvent.IO_ERROR*/"ioError");
						io.text="找不到"+data.src;
						_$this.contentLoaderInfo.dispatchEvent(io);
						data.onerror=data.onload=null;
						fileLoadType=true;
					};
					data.src=request.url;
					break ;
				}
		}

		__proto.close=LAYAFNVOID/*function(){}*/
		__proto.unload=function(){
			if(this.__content__){
				this.removeChild(this.__content__);
				this.__content__._removeEvents_();
				this.__content__=null;
				this._bitmapData=null;
			}
			if(this.parent){
				this.parent._type_|=0x4000;
				this.parent.lyRemoveChildAt(this.childIndexOf(this));
			}
		}

		__proto._checkloaderInfo=function(){
			if(this.isFlag){
				var t=this._contentLoaderInfo;
				this._contentLoaderInfo=LoaderInfo.create(this._getID_);
				this._contentLoaderInfo.loader=this;
				this._contentLoaderInfo._getEvents_(t);
				t=null;
				}else{
				this.isFlag=true;
			}
		}

		__proto.loadBytes=function(data,context){
			this._checkloaderInfo();
			var _this=this;
			this.contains(this.__content__)&&this.removeChild(this.__content__);
			if((data instanceof Array)){
			}
			else if((data instanceof iflash.utils.ByteArray )){
				data.position=0;
				var fileHeadType=data.readUTF();
				var tmpBytes=new ByteArray();
				if(fileHeadType !="swf"){
					throw "un support img binary!";
				}
				else{
					context&&(this._contentLoaderInfo._reDomain_=context.applicationDomain);
					var fileUrl=data.readUTF();
					var filetype=fileHeadType;
					data.readBytes(tmpBytes,0,tmpBytes.bytesAvailable);
					Stage.USE_SMALL ? this.loadSwf_Small(fileUrl,filetype,tmpBytes):this.loadSwf(fileUrl.substring(0,fileUrl.lastIndexOf("."+filetype)),tmpBytes);
				}
			}
			else{
				this._bitmapData=new BitmapData();
				this._bitmapData.setImage(data);
				this.__content__=this.contentLoaderInfo.__content__=new Bitmap(this._bitmapData);
				this.addChild(this.__content__);
				this.addEventListener(/*iflash.events.Event.ENTER_FRAME*/"enterFrame",__bind(this,this.onEnterFrame));
			}
		}

		__proto.getFileType=function(fileData){
			var b0=fileData.readUnsignedByte();
			var b1=fileData.readUnsignedByte();
			var fileType="unknown";
			if(b0==66 && b1==77){
				fileType="BMP";
			}
			else if(b0==255 && b1==216){
				fileType="JPG";
				}else if(b0==137 && b1==80){
				fileType="PNG";
				}else if(b0==71 && b1==73){
				fileType="GIF";
			}
			return fileType;
		}

		__proto._buildLoaderContext=function(context){
			if(context==null){
				context=new LoaderContext();
			}
			if(context.applicationDomain==null){
				context.applicationDomain=new ApplicationDomain(ApplicationDomain.currentDomain);
			}
			return context;
		}

		__proto.onEnterFrame=function(evt){
			this.removeEventListener(/*iflash.events.Event.ENTER_FRAME*/"enterFrame",__bind(this,this.onEnterFrame));
			this.contentLoaderInfo.dispatchEvent(new iflash.events.Event(/*iflash.events.Event.COMPLETE*/"complete",false,false));
		}

		__proto.unloadAndStop=function(gc){
			(gc===void 0)&& (gc=true);
			this.unload();
		}

		__proto.deleteKey=function(arr){
			for(var i in arr){
				delete arr[i];
			}
			arr.length=0;
		}

		__proto.loadSwf=function(url,tmpBytes){
			this._contentLoaderInfo.onload=iflash.method.bind(this,this.onLoadeComplete);
			if(tmpBytes){
				this._contentLoaderInfo.setUrl(url);
				this._contentLoaderInfo.setByteArray(tmpBytes);
			}else
			this._contentLoaderInfo.src=url;
		}

		__proto.loadSwf_Small=function(url,urltype,tmpBytes){
			var _$this=this;
			var $this=this;
			if(!Loader.imgLoader){
				Loader.imgLoader=Browser.document.createElement("image");
			}
			else{
				this._contentLoaderInfo.onload=iflash.method.bind($this,this.onLoadeComplete);
				LoaderInfo.minibitmapData=new BitmapData();
				LoaderInfo.minibitmapData.setImage(Loader.imgLoader);
				if(tmpBytes){
					this._contentLoaderInfo.setUrl(url.substring(0,url.lastIndexOf("."+urltype)));
					this._contentLoaderInfo.setByteArray(tmpBytes);
				}else
				this._contentLoaderInfo.src=url;
				return;
			}
			Loader.imgLoader.onload=function (){
				_$this._contentLoaderInfo.onload=iflash.method.bind($this,_$this.onLoadeComplete);
				LoaderInfo.minibitmapData=new BitmapData();
				LoaderInfo.minibitmapData.setImage(Loader.imgLoader);
				if(tmpBytes){
					_$this._contentLoaderInfo.setUrl(url.substring(0,url.lastIndexOf("."+urltype)));
					_$this._contentLoaderInfo.setByteArray(tmpBytes);
				}else
				{_$this._contentLoaderInfo.src=url;}
				Loader.imgLoader=null;
				LoaderInfo.minibitmapData=null;
			};
			Loader.imgLoader.onerror=function (){
				_$this.contentLoaderInfo.dispatchEvent(new IOErrorEvent(/*iflash.events.IOErrorEvent.IO_ERROR*/"ioError"));
				Loader.imgLoader=null;
			};
			var charIndex=url.lastIndexOf("."+urltype);
			Loader.imgLoader.src=url.substring(0,charIndex)+"/small.png";
		}

		__proto.onLoadeComplete=function(__args){
			var args=arguments;
			this.addChild(this._contentLoaderInfo.__content__);
			this.__content__=this.contentLoaderInfo.__content__;
			if(this.preLoader.length>0){
				this.onPreLoader();
				}else {
				this.contentLoaderInfo.dispatchEvent(new Event(/*iflash.events.Event.INIT*/"init"));
				this.contentLoaderInfo.dispatchEvent(new Event(/*iflash.events.Event.COMPLETE*/"complete"));
			}
		}

		__proto.onPreLoader=function(){
			Runnner.preResCollection=[];
			for (var i=0;i < this.preLoader.length;i++){
				var obj=this.contentLoaderInfo.applicationDomain.newInstance(this.preLoader[i]);
				if((obj instanceof iflash.display.MovieClip )){
					obj.runner.getPreRes(this.contentLoaderInfo);
				}
				if((obj instanceof iflash.display.Shape )){
					Runnner.preResCollection.push(res);
				}
				if((obj instanceof iflash.display.LyImageElement )){
					Runnner.preResCollection.push(res);
				}
			};
			var arr=Runnner.preResCollection;
			this.preIndex=0;
			while(Runnner.preResCollection.length>0){
				var res=Runnner.preResCollection.pop();
				if((res instanceof iflash.display.Shape )){
					this.preIndex++;
					res._image_._image_.onload=iflash.method.bind(this,this.onPreComplete);
					res._image_._image_.src=res._image_.src;
				}
				if((res instanceof iflash.display.LyImageElement )){
					this.preIndex++;
					res._image_.onload=iflash.method.bind(this,this.onPreComplete);
					res._image_.src=res._image_.src;
				}
			}
		}

		__proto.onPreComplete=function(obj){
			this.preIndex--;
			if(this.preIndex <=0){
				this.contentLoaderInfo.dispatchEvent(new Event(/*iflash.events.Event.COMPLETE*/"complete"));
			}
		}

		__getset(0,__proto,'contentLoaderInfo',function(){
			return this._contentLoaderInfo;
		});

		__getset(0,__proto,'_getID_',function(){
			return++Loader.__ID__;
		});

		__getset(0,__proto,'content',function(){
			return this.__content__;
		});

		__getset(0,__proto,'element',function(){
			return this.__element__;
		});

		Loader.removeNameChar=function(fileName){
			var urls=fileName.split("/");
			var str,i=1,size=urls.length;
			while (i < size){
				str=urls[i];
				if (str==null)break ;
				if (str==''){
					urls.splice(i,1);
					continue ;
				}
				i+=1;
			}
			fileName=urls.join("/");
			return fileName;
		}

		Loader.preswfAsset=function(arr){
			Loader.preSwf=Loader.preSwf.concat(arr);
		}

		Loader.__isPNG=function(bytes){
			bytes.position=0;
			return (bytes.readByte ()==0x89 && bytes.readByte ()==0x50 && bytes.readByte ()==0x4E && bytes.readByte ()==0x47 && bytes.readByte ()==0x0D && bytes.readByte ()==0x0A && bytes.readByte ()==0x1A && bytes.readByte ()==0x0A);
		}

		Loader.__ID__=0;
		Loader.preSwf=[];
		Loader.imgLoader=null
		return Loader;
	})(DisplayObjectContainer)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/stage.as
	//class iflash.display.Stage extends iflash.display.DisplayObjectContainer
	var Stage=(function(_super){
		function Stage(){
			this.contentsScaleFactor=1;
			this._useActivateEventCount_=0;
			this._infoFlag=true;
			this._algin="";
			this.currentFocus=null;
			this._isInvalidate=false;
			this._tmctr_=null;
			this._bgc_=0xffffff;
			this._bgc2_="#ffffff";
			this.autoOrients=false;
			this.visibilityChange="hidden";
			this.visibilityState="visibilityState";
			this.stage3Ds=([new Stage3D(),new Stage3D(),new Stage3D(),new Stage3D()]);
			this._scaleMode_=/*iflash.display.StageScaleMode.SHOW_ALL*/"showAll";
			Stage.__super.call(this);
			this._width_=EventDispatcher.window.innerWidth;
			this._height_=EventDispatcher.window.innerHeight;
			this._tmctr_=TimerCtrl.__DEFAULT__;
		}

		__class(Stage,'iflash.display.Stage',false,_super);
		var __proto=Stage.prototype;
		__proto.setOrientationEx=function(type){
			Laya.document.setOrientationEx(type);
		}

		__proto.setSize=function(w,h){
			Laya.document.size(w,h);
		}

		__proto.invalidate=function(){
			this._isInvalidate=true;
		}

		__proto.size=function(width,height){
			Laya.document.size(width,height);
		}

		__proto._hitTest_=function(x,y){
			var target=_super.prototype._hitTest_.call(this,x,y);
			if (!target)
				target=this;
			return target;
		}

		__proto.sendRender=function(){
			if(this._isInvalidate){
				this._isInvalidate=false;
				this.lyDispatchEvent(/*iflash.events.Event.RENDER*/"render");
			}
		}

		__proto.addEventListener=function(type,listener,useCapture,priority,useWeakReference){
			(useCapture===void 0)&& (useCapture=false);
			(priority===void 0)&& (priority=0);
			(useWeakReference===void 0)&& (useWeakReference=false);
			if(type==/*iflash.events.Event.ACTIVATE*/"activate" || type==/*iflash.events.Event.DEACTIVATE*/"deactivate"){
				if(this.hasEventListener(type))return;
				if(this._useActivateEventCount_==0){
					this.addVisibilityChangeEvent();
				}
				this._useActivateEventCount_++;
			}
			iflash.events.EventDispatcher.prototype.addEventListener.call(this,type,listener,useCapture,priority,useWeakReference);
		}

		__proto.removeEventListener=function(type,listener,useCapture){
			(useCapture===void 0)&& (useCapture=false);
			if(type==/*iflash.events.Event.ACTIVATE*/"activate" || type==/*iflash.events.Event.DEACTIVATE*/"deactivate"){
				if(!this.hasEventListener(type))return;
				this._useActivateEventCount_--;
				if(this._useActivateEventCount_==0){
					this.removeVisibilityChangeEvent();
				}
			}
			iflash.events.EventDispatcher.prototype.removeEventListener.call(this,type,listener,useCapture);
		}

		__proto.visibilitySysEvtHandler=function(e){
			var evt=new Event(Browser.document[this.visibilityState]=="hidden"? /*iflash.events.Event.DEACTIVATE*/"deactivate":/*iflash.events.Event.ACTIVATE*/"activate",e.bubbles,e.cancelable);
			this.dispatchEvent(evt);
		}

		__proto.addVisibilityChangeEvent=function(){
			var document=Browser.document;
			if ("hidden" in document){
				this.visibilityChange="visibilitychange";
				this.visibilityState="visibilityState";
				}else if ("mozHidden" in document){
				this.visibilityChange="mozvisibilitychange";
				this.visibilityState="mozVisibilityState";
				}else if ("msHidden" in document){
				this.visibilityChange="msvisibilitychange";
				this.visibilityState="msVisibilityState";
				}else if ("webkitHidden" in document){
				this.visibilityChange="webkitvisibilitychange";
				this.visibilityState="webkitVisibilityState";
			}
			Browser.document.addEventListener(this.visibilityChange,__bind(this,this.visibilitySysEvtHandler));
		}

		__proto.removeVisibilityChangeEvent=function(){
			Browser.document.removeEventListener(this.visibilityChange,__bind(this,this.visibilitySysEvtHandler));
		}

		__proto.setAspectRatio=function(newAspectRatio){
			switch(newAspectRatio){
				case /*iflash.display.StageAspectRatio.PORTRAIT*/"portrait":
					IFlash.setAutoOrients(false);
					EventDispatcher.document.setOrientationEx(0);
					this.dispatchEvent(new StageOrientationEvent(/*iflash.events.StageOrientationEvent.ORIENTATION_CHANGE*/"orientationChange"));
					break ;
				case /*iflash.display.StageAspectRatio.LANDSCAPE*/"landscape":
					IFlash.setAutoOrients(false);
					EventDispatcher.document.setOrientationEx(1);
					this.dispatchEvent(new StageOrientationEvent(/*iflash.events.StageOrientationEvent.ORIENTATION_CHANGE*/"orientationChange"));
					break ;
				case /*iflash.display.StageAspectRatio.ANY*/"any":
					IFlash.setAutoOrients(true);
					break ;
				}
		}

		__getset(0,__proto,'displayState',function(){
			return "";
			},function(val){
		});

		__getset(0,__proto,'focus',function(){
			return this.currentFocus
			},function(val){
			if ((val instanceof iflash.text.TextField ))
				val["onTextFocus"](null);
			this.currentFocus=val;
		});

		__getset(0,__proto,'showDefaultContextMenu',function(){
			return false
			},function(val){
		});

		__getset(0,__proto,'stageWidth',function(){
			return this._scaleMode_==/*iflash.display.StageScaleMode.NO_SCALE*/"noScale"?EventDispatcher.window.innerWidth:this.width;
		});

		__getset(0,__proto,'allowsFullScreen',function(){
			return false;
		});

		__getset(0,__proto,'allowsFullScreenInteractive',function(){
			return false;
		});

		__getset(0,__proto,'showInfo',null,function(value){
			if (value !=this._infoFlag){
				Laya.config.showInfo=value;
				Laya.SHOW_FPS=value;
				Laya.conch && Laya.conch.ShowFPS(value,Laya.conch.m_pFps);
			}
		});

		__getset(0,__proto,'width',function(){
			return this._width_;
			},function(w){
			this._width_=w;
			this._modle_.size(this._width_,this._height_);
		});

		__getset(0,__proto,'stageHeight',function(){
			return this._scaleMode_==/*iflash.display.StageScaleMode.NO_SCALE*/"noScale"?EventDispatcher.window.innerHeight:this.height;
		});

		__getset(0,__proto,'scaleMode',function(){
			return this._scaleMode_;
			},function(value){
			var isChange=value !=this._scaleMode_;
			this._scaleMode_=value;
			if(isChange && Laya.window){
				Laya.window.lyDispatchEvent(/*iflash.events.Event.RESIZE*/"resize");
			}
		});

		__getset(0,__proto,'height',function(){
			return this._height_;
			},function(h){
			this._height_=h;
			this._modle_.size(this._width_,this._height_);
		});

		__getset(0,__proto,'color',function(){return this._bgc_},function(value){
			this.bgcolor=value;
		});

		__getset(0,__proto,'bgcolor',null,function(value){
			if((typeof value=='string')){
				var v=value.replace("#","");
				/*__JS__ */v=parseInt(v,16);;
				this._bgc_=v;
				if (isNaN(this._bgc_))this._bgc_=0xffffff;
				this._bgc2_=value;
			}
			else{
				this._bgc_=value;
				if (isNaN(this._bgc_))this._bgc_=0xffffff;
				this._bgc2_=StringMethod.getColorString(this._bgc_);
			}
			if(Laya.CONCHVER)/*__JS__ */conch.setBgColor(this._bgc2_)
				else /*__JS__ */window.document.body.style.backgroundColor=this._bgc2_;
		});

		__getset(0,__proto,'autoScaleDifference',null,function(value){
			Laya.document.adapter.autoScaleDifference=value;
		});

		__getset(0,__proto,'frameRate',function(){
			return Browser.frameRate;
			},function(value){
			Browser.frameRate=value;
		});

		__getset(0,__proto,'align',function(){
			return this._algin;
			},function(value){
			var isChange=value !=this._algin;
			this._algin=value;
			if(isChange && Laya.window){
				Laya.window.lyDispatchEvent(/*iflash.events.Event.RESIZE*/"resize");
			}
		});

		__getset(0,__proto,'stageFocusRect',function(){
			return false;
		},LAYAFNVOID/*function(param1){}*/);

		__getset(0,__proto,'quality',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'fullScreenWidth',function(){
			return EventDispatcher.window.fullScreenWidth;
		});

		__getset(0,__proto,'fullScreenHeight',function(){
			return EventDispatcher.window.fullScreenHeight;
		});

		__getset(1,Stage,'stage',function(){
			return Stage._stage ? Stage._stage :(Stage._stage=new Stage());
		},iflash.display.DisplayObjectContainer._$SET_stage);

		__getset(1,Stage,'supportsOrientationChange',function(){
			return true;
		},iflash.display.DisplayObjectContainer._$SET_supportsOrientationChange);

		Stage.USE_SMALL=true;
		Stage.__frameRate__=16;
		Stage._stage=null;
		return Stage;
	})(DisplayObjectContainer)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/text/engine/textline.as
	//class iflash.text.engine.TextLine extends iflash.display.DisplayObjectContainer
	var TextLine=(function(_super){
		function TextLine(){
			this.userData=null;
			TextLine.__super.call(this);
			this.getMirrorRegion=/*__JS__ */$null;
		}

		__class(TextLine,'iflash.text.engine.TextLine',false,_super);
		var __proto=TextLine.prototype;
		__proto.dump=LAYAFNSTR/*function(){return ""}*/
		__proto.flushAtomData=LAYAFNVOID/*function(){}*/
		__proto.getAtomBidiLevel=LAYAFN0/*function(atomIndex){return 0}*/
		__proto.getAtomBounds=LAYAFNNULL/*function(atomIndex){return null}*/
		__proto.getAtomCenter=LAYAFN0/*function(atomIndex){return 0}*/
		__proto.getAtomGraphic=LAYAFNNULL/*function(atomIndex){return null}*/
		__proto.getAtomIndexAtCharIndex=LAYAFN0/*function(charIndex){return 0}*/
		__proto.getAtomIndexAtPoint=LAYAFN0/*function(stageX,stageY){return 0}*/
		__proto.getAtomTextBlockBeginIndex=LAYAFN0/*function(atomIndex){return 0}*/
		__proto.getAtomTextBlockEndIndex=LAYAFN0/*function(atomIndex){return 0}*/
		__proto.getAtomTextRotation=LAYAFNSTR/*function(atomIndex){return ""}*/
		__proto.getAtomWordBoundaryOnLeft=LAYAFNFALSE/*function(atomIndex){return false}*/
		__proto.getBaselinePosition=LAYAFN0/*function(baseline){return 0}*/
		__getset(0,__proto,'ascent',LAYAFN0/*function(){return 0}*/);
		__getset(0,__proto,'atomCount',LAYAFN0/*function(){return 0}*/);
		__getset(0,__proto,'focusRect',null,LAYAFNVOID/*function(focusRect){}*/);
		__getset(0,__proto,'contextMenu',_super.prototype._$get_contextMenu,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'textBlockBeginIndex',LAYAFN0/*function(){return 0}*/);
		__getset(0,__proto,'hasTabs',LAYAFNFALSE/*function(){return false}*/);
		__getset(0,__proto,'descent',LAYAFN0/*function(){return 0}*/);
		__getset(0,__proto,'mirrorRegions',LAYAFNNULL/*function(){return null}*/);
		__getset(0,__proto,'totalAscent',LAYAFN0/*function(){return 0}*/);
		__getset(0,__proto,'hasGraphicElement',LAYAFNFALSE/*function(){return false}*/);
		__getset(0,__proto,'nextLine',LAYAFNNULL/*function(){return null}*/);
		__getset(0,__proto,'previousLine',LAYAFNNULL/*function(){return null}*/);
		__getset(0,__proto,'rawTextLength',LAYAFN0/*function(){return 0}*/);
		__getset(0,__proto,'specifiedWidth',LAYAFN0/*function(){return 0}*/);
		__getset(0,__proto,'tabChildren',_super.prototype._$get_tabChildren,LAYAFNVOID/*function(enable){}*/);
		__getset(0,__proto,'tabEnabled',_super.prototype._$get_tabEnabled,LAYAFNVOID/*function(enabled){}*/);
		__getset(0,__proto,'tabIndex',_super.prototype._$get_tabIndex,LAYAFNVOID/*function(index){}*/);
		__getset(0,__proto,'textBlock',LAYAFNNULL/*function(){return null}*/);
		__getset(0,__proto,'textHeight',LAYAFN0/*function(){return 0}*/);
		__getset(0,__proto,'textWidth',LAYAFN0/*function(){return 0}*/);
		__getset(0,__proto,'totalDescent',LAYAFN0/*function(){return 0}*/);
		__getset(0,__proto,'totalHeight',LAYAFN0/*function(){return 0}*/);
		__getset(0,__proto,'unjustifiedTextWidth',LAYAFN0/*function(){return 0}*/);
		__getset(0,__proto,'validity',LAYAFNSTR/*function(){return ""}*/,LAYAFNVOID/*function(value){}*/);
		TextLine.MAX_LINE_WIDTH=1000000;
		return TextLine;
	})(DisplayObjectContainer)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/text/statictext.as
	//class iflash.text.StaticText extends iflash.text.TextField
	var StaticText=(function(_super){
		function StaticText(){
			StaticText.__super.call(this);
		}

		__class(StaticText,'iflash.text.StaticText',false,_super);
		var __proto=StaticText.prototype;
		__proto.lyclone=function(){
			var result=new StaticText();
			result.type="static";
			this.getTextResult(result);
			return result;
		}

		return StaticText;
	})(TextField)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/embedsymbol.as
	//class iflash.display.EmbedSymbol extends iflash.display.Sprite
	var EmbedSymbol=(function(_super){
		function EmbedSymbol(){
			this._loader=null;
			this._swfUrl=null;
			this._symbol=null;
			EmbedSymbol.__super.call(this);
		}

		__class(EmbedSymbol,'iflash.display.EmbedSymbol',false,_super);
		var __proto=EmbedSymbol.prototype;
		__proto.load=function(swfUrl,symbol){
			this._swfUrl=swfUrl;
			this._symbol=symbol;
			if(symbol && this.hasClass(symbol)){
				this.createAsset();
				}else {
				this._loader=new Loader();
				this._loader.contentLoaderInfo.addEventListener(/*iflash.events.Event.COMPLETE*/"complete",__bind(this,this.onComplete));
				this._loader.contentLoaderInfo.addEventListener(/*iflash.events.IOErrorEvent.IO_ERROR*/"ioError",__bind(this,this.onError));
				this._loader.load(new URLRequest(swfUrl),EmbedSymbol._loaderContent);
			}
		}

		__proto.onComplete=function(e){
			if (Boolean(this._symbol)){
				if (this.hasClass(this._symbol)){
					this.createAsset();
				}
				if (this._loader){
					this.clearLoader();
				}
				}else {
				this.addChild(this._loader);
			}
		}

		__proto.clearLoader=function(){
			this._loader.unloadAndStop();
			this._loader.contentLoaderInfo.removeEventListener(/*iflash.events.Event.COMPLETE*/"complete",__bind(this,this.onComplete));
			this._loader.contentLoaderInfo.removeEventListener(/*iflash.events.IOErrorEvent.IO_ERROR*/"ioError",__bind(this,this.onError));
			this._loader=null;
		}

		__proto.onError=function(e){
			console.log("IO Error:"+this._swfUrl);
		}

		__proto.createAsset=function(){
			var res=this.getAsset(this._symbol);
			if ((res instanceof iflash.display.BitmapData )){
				var display=new Bitmap(res);
				}else {
				display=res;
			}
			this.addChild(display);
		}

		__proto.hasClass=function(name){
			return EmbedSymbol._domain.hasDefinition(name);
		}

		__proto.getClass=function(name){
			if (this.hasClass(name)){
				return EmbedSymbol._domain.getDefinition2(name);
			}
			return null;
		}

		__proto.getAsset=function(name){
			var assetClass=this.getClass(name);
			if (assetClass !=null){
				return new assetClass();
			}
			return null;
		}

		__static(EmbedSymbol,
		['_domain',function(){return this._domain=ApplicationDomain.currentDomain;},'_loaderContent',function(){return this._loaderContent=new LoaderContext(false,ApplicationDomain.currentDomain);}
		]);
		return EmbedSymbol;
	})(Sprite)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/movieclip.as
	//class iflash.display.MovieClip extends iflash.display.Sprite
	var MovieClip=(function(_super){
		function MovieClip(){
			this._interval_=60;
			this._preFrame_=0;
			this._preTime_=0;
			this.runner=null;
			this._scriptList_=[];
			this._animData_=new AnimationData();
			MovieClip.__super.call(this);}
		__class(MovieClip,'iflash.display.MovieClip',false,_super);
		var __proto=MovieClip.prototype;
		__proto._lyMCDispose=function(mc){
			var num=mc.numChildren;
			var child;
			var ly;
			while(num){
				child=mc.getChildAt(num-1);
				if((child instanceof iflash.display.MovieClip )){
					child.stop();
					if(child._private_.onupdate){child._private_.onupdate.deleted=true;};
					child.runner=null;
					this._lyMCDispose(child);
					}else if((child instanceof iflash.display.Shape )){
					ly=child._image_;
					ly=null;
				}
				num--;
			}
			mc.runner=null;
			mc._private_.onupdate && (mc._private_.onupdate.deleted=true);
			mc._private_.onupdate=null;
		}

		__proto._onupdate_=function(tm,tmgo,o){
			if(this.isPlaying){
				if ((tm-this._preTime_)>=this.interval){
					this._scriptList_[this.currentFrame] && this._scriptList_[this.currentFrame].call(this);
					this._preTime_=tm;
					this.runner._updata_(this);
				}
			}
			return true;
		}

		__proto.addFrameScript=function(__rest){
			var rest=arguments;
			for (var i=0,sz=rest.length;i < sz;i+=2){
				this._addFrameScript_(rest[i],rest[i+1]);
			}
		}

		__proto._addFrameScript_=function(index,fn){
			this._scriptList_[index+1]=fn;
			if(index+1==this.currentFrame){
				this._scriptList_[this.currentFrame] && this._scriptList_[this.currentFrame].call(this);
			}
		}

		__proto.gotoAndPlay=function(frame,scene){
			this._gotoAndPlay_(frame,scene);
			this._animData_.isStop=false;
		}

		__proto._gotoAndPlay_=function(frame,scene){
			if((typeof frame=='string')){
				frame=int(this._animData_.labs[frame]);
				this.runner.gotoAndPlay(frame,this);
				}else{
				this.runner.gotoAndPlay(frame-1,this);
			}
			this._scriptList_[this.currentFrame] && this._scriptList_[this.currentFrame].call(this);
		}

		__proto.gotoAndStop=function(frame,scene){
			if(this.runner==null)return;
			if((typeof frame=='string')){
				frame=int(this._animData_.labs[frame]);
				this.runner.gotoAndStop(frame,this);
				}else{
				if(frame>this.totalFrames){
					frame=this.totalFrames;
				}
				this.runner.gotoAndStop(frame-1,this);
			}
			this._scriptList_[this.currentFrame] && this._scriptList_[this.currentFrame].call(this);
		}

		__proto.nextFrame=function(){
			this.runner.gotoAndStop(this._animData_.currentFrame+1,this);
		}

		__proto.prevFrame=function(){
			this.runner.gotoAndStop(this._animData_.currentFrame-1,this);
		}

		__proto.play=function(){
			this.gotoAndPlay(this.currentFrame+1);
		}

		__proto.stop=function(){
			if(this.runner)
				this.runner.stop(this);
		}

		__proto.prevScene=LAYAFNVOID/*function(){}*/
		__proto.nextScene=LAYAFNVOID/*function(){}*/
		__proto.addFrameTimer=function(fn){
			return Stage.stage._tmctr_.addFrameTimer(fn,this);
		}

		__proto.addChild=function(child){
			if(this._type_&0x10&&this.numChildren){
				this.sortChildsByZIndex();
				var disp=this.getChildAt(this.numChildren-1);
				child.zIndex=disp.zIndex+1;
			}
			return iflash.display.DisplayObjectContainer.prototype.addChild.call(this,child);
		}

		__proto.addChildAt=function(child,index){
			if(this._type_&0x10&&this.numChildren){
				this.sortChildsByZIndex();
				var disp=this.getChildAt(index);
				child.zIndex=disp.zIndex-1;
				if(index>0){
					if(child.zIndex<this.getChildAt(index-1).zIndex){
						var i=0;
						while(i<index-1)
						{this.getChildAt(i).zIndex--;i++;}
					}
				}
			}
			return iflash.display.DisplayObjectContainer.prototype.addChildAt.call(this,child,index);
		}

		__proto._lyToBody_=function(){
			_super.prototype._lyToBody_.call(this);
			this._preTime_=0;
			if(this.runner){
				this.onupdate=this._onupdate_;
				this._private_.onupdate.deleted=false;
			}
		}

		__proto._lyUnToBody_=function(){
			iflash.display.DisplayObjectContainer.prototype._lyUnToBody_.call(this);
			if(this._private_.onupdate){this._private_.onupdate.deleted=true;};
		}

		__proto.stopAll=function(mc){
			var i=mc.numChildren;
			while(i){
				var m=mc.getChildAt(i-1);
				m&&(m.stop(),this.stopAll(m));
				i--;
			}
		}

		__proto.lyclone=function(){
			var movie=new MovieClip();
			if(this.scale9Data)movie.scale9Data={x1:this.scale9Data.x1,y1:this.scale9Data.y1,x2:this.scale9Data.x2,y2:this.scale9Data.y2};
			movie._animData_=this._animData_.lyclone();
			movie.runner=this.runner;
			movie._interval_=this._interval_;
			movie.__id__=this.__id__;
			movie.charId=this.charId;
			movie.characterId=this.characterId;
			movie._type_|=(this._type_& /*iflash.display.DisplayObject.TYPE_CREATE_FROM_TAG*/0x10);
			movie.gotoAndPlay(1);
			movie.width=movie.width;
			movie.height=movie.height;
			movie.sortChildsByZIndex();
			return movie;
		}

		__getset(0,__proto,'onupdate',null,function(fn){
			if(this._private_.onupdate)(this._private_.onupdate.deleted=true);
			this._private_.onupdate=this.addFrameTimer(fn);
		});

		__getset(0,__proto,'interval',function(){
			return Stage.__frameRate__;
			},function(value){
			this._interval_=value;
		});

		__getset(0,__proto,'currentFrame',function(){
			var value=this._animData_.currentFrame+1;
			if(value>this.totalFrames)value=this.totalFrames;
			return value<1?1:value;
		});

		__getset(0,__proto,'enabled',LAYAFNTRUE/*function(){return true;}*/,LAYAFNVOID/*function(value){}*/);
		__getset(0,__proto,'totalFrames',function(){
			return this._animData_.totalFrame;
		});

		__getset(0,__proto,'currentLabel',function(){
			var index=this.currentFrame-1;
			var label;
			var frame=0;
			var arr={};
			for (var key in this._animData_.labs){
				label=key;
				frame=int(this._animData_.labs[key]);
				if(index==frame){
					return label;
				}
				arr[frame]=label;
			}
			label=null;
			while(label==null){
				label=arr[index];
				index--;
				if(index==-1)break ;
			}
			return label;
		});

		__getset(0,__proto,'isPlaying',function(){
			return !this._animData_.isStop;
		});

		__getset(0,__proto,'framesLoaded',LAYAFN0/*function(){return 0}*/);
		__getset(0,__proto,'currentFrameLabel',function(){
			var index=this.currentFrame-1;
			var label;
			var frame=0;
			for (var key in this._animData_.labs){
				label=key;
				frame=int(this._animData_.labs[key]);
				if(index==frame){
					return label;
				}
			}
			return null;
		});

		__getset(0,__proto,'currentScene',LAYAFNNULL/*function(){return null}*/);
		__getset(0,__proto,'currentLabels',function(){
			var labs=this._animData_.labs,arr=[];
			for (var key in labs){
				var fl=new FrameLabel();
				fl.name=key;
				fl.frame=int(labs[key])+1;
				arr.push(fl);
			}
			return arr;
		});

		__getset(0,__proto,'scenes',LAYAFNNULL/*function(){return null}*/);
		__getset(0,__proto,'trackAsMenu',LAYAFNFALSE/*function(){return false}*/,LAYAFNVOID/*function(value){}*/);
		MovieClip.USE_LINK_CLASS=true;
		return MovieClip;
	})(Sprite)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/shaderjob.as
	//class iflash.display.ShaderJob extends iflash.display.Sprite
	var ShaderJob=(function(_super){
		function ShaderJob(__a){
			ShaderJob.__super.call(this);
		}

		__class(ShaderJob,'iflash.display.ShaderJob',false,_super);
		var __proto=ShaderJob.prototype;
		__proto.start=function(waitForCompletion){
			(waitForCompletion===void 0)&& (waitForCompletion=false);
		}

		return ShaderJob;
	})(Sprite)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/simplebutton.as
	//class iflash.display.SimpleButton extends iflash.display.MovieClip
	var SimpleButton=(function(_super){
		function SimpleButton(upState,overState,downState,hitTestState){
			this._enabled=true;
			SimpleButton.__super.call(this);
			this.addEventListener(/*iflash.events.MouseEvent.MOUSE_OUT*/"mouseOut",__bind(this,this._onmouseOut_));
			this.addEventListener(/*iflash.events.MouseEvent.MOUSE_OVER*/"mouseOver",__bind(this,this._onmouseOver_));
			this.addEventListener(/*iflash.events.MouseEvent.MOUSE_DOWN*/"mouseDown",__bind(this,this._onmouseDown_));
			this.addEventListener(/*iflash.events.MouseEvent.MOUSE_UP*/"mouseUp",__bind(this,this._onmouseUp_));
			this.mouseChildren=false;
		}

		__class(SimpleButton,'iflash.display.SimpleButton',false,_super);
		var __proto=SimpleButton.prototype;
		__proto._onmouseOut_=function(e){this.gotoAndStop(1);}
		__proto.switchState=function(state){this.gotoAndStop(state);}
		__proto._onmouseUp_=function(e){this.gotoAndStop(1);}
		__proto._onmouseDown_=function(e){this.gotoAndStop(3);}
		__proto._onmouseOver_=function(e){this.gotoAndStop(2);}
		__proto.lyclone=function(){
			var movie=new SimpleButton();
			movie._animData_=this._animData_.lyclone();
			movie.runner=this.runner;
			movie.__id__=this.__id__;
			movie._interval_=this._interval_;
			movie.width=this.width;
			movie.height=this.height;
			movie._type_|=0x10;
			movie.gotoAndStop(1);
			return movie;
		}

		__getset(0,__proto,'trackAsMenu',LAYAFNFALSE/*function(){return false}*/,LAYAFNVOID/*function(param1){}*/);
		__getset(0,__proto,'useHandCursor',LAYAFNFALSE/*function(){return false}*/,LAYAFNVOID/*function(param1){}*/);
		__getset(0,__proto,'downState',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(param1){}*/);
		__getset(0,__proto,'enabled',function(){return this._enabled;},function(param1){
			this._enabled=param1;
		});

		__getset(0,__proto,'upState',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(param1){}*/);
		__getset(0,__proto,'overState',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(param1){}*/);
		__getset(0,__proto,'hitTestState',LAYAFNNULL/*function(){return null}*/,LAYAFNVOID/*function(param1){}*/);
		return SimpleButton;
	})(MovieClip)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/swf/classs/mc.as
	//class iflash.display.swf.classs.MC extends iflash.display.MovieClip
	var MC2=(function(_super){
		function MC(){
			MC.__super.call(this);
			var movieClip=this["__data__"];
			this._animData_=movieClip._animData_.lyclone();
			this.runner=movieClip.runner;
			this._interval_=movieClip._interval_;
			this._type_|=0x10;
			this.__id__=movieClip.__id__;
			this.gotoAndPlay(1);
		}

		__class(MC,'iflash.display.swf.classs.MC',false,_super,'MC2');
		return MC;
	})(MovieClip)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash/display/swf/classs/sb.as
	//class iflash.display.swf.classs.SB extends iflash.display.SimpleButton
	var SB=(function(_super){
		function SB(upState,overState,downState,hitTestState){
			SB.__super.call(this);
			var movieClip=this["__data__"];
			this._animData_=movieClip._animData_.lyclone();
			this.runner=movieClip.runner;
			this.runner=movieClip.runner;
			this._interval_=movieClip._interval_;
			this._type_|=0x10;
			this.__id__=movieClip.__id__;
			this.gotoAndStop(1);
		}

		__class(SB,'iflash.display.swf.classs.SB',false,_super);
		return SB;
	})(SimpleButton)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/jsonparse.jas
	//class JSONParse
	var JSONParse=(function(){
		function JSONParse(){
			/*__JS__ */if(LAYABOX.__JSON__)return;
			/*__JS__ */LAYABOX.__JSON__=window.JSON;
			/*__JS__ */window.JSON=JSONParse;
		}

		__class(JSONParse,'JSONParse',true);
		JSONParse.parse=function(val){
			var ret=null;
			try {
				return /*__JS__ */LAYABOX.__JSON__.parse(val);
			}
			catch(ex){
				try {
					/*__JS__ */eval('ret='+val);
					return ret;
				}
				catch(e){
					throw new Error("Could not parse JSON: "+e.message);
					return null;
				}
			}
			return null;
		}

		JSONParse.stringify=function(obj){
			return /*__JS__ */LAYABOX.__JSON__.stringify(obj);
		}

		return JSONParse;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/qname.jas
	//class QName
	var QName=(function(){
		function QName(uri,localName){
			this._uri=null;
			this._localName=null;
			this._uri=uri;
			this._localName=localName
		}

		__class(QName,'QName',false);
		var __proto=QName.prototype;
		__proto.toString=function(){
			return (this.uri==null ? "*" :this.uri)+"::"+this.localName;
		}

		__getset(0,__proto,'uri',function(){
			if(this._uri==null)
				return null;
			else if(this._uri=="")
			return "";
			else if((typeof this._uri=='string'))
			return this._uri;
			return this._uri+"";
		});

		__getset(0,__proto,'localName',function(){
			if(this._localName==null)
				return null;
			else if(this._localName=="")
			return "";
			else if((typeof this._localName=='string'))
			return this._localName;
			return this._localName+"";
		});

		return QName;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/uint.jas
	//class uint
	var uint=(function(){
		function uint(value,offset){
			(value===void 0)&& (value=0);
			(offset===void 0)&& (offset=0);
			if(!value)return 0;
			if(Laya.__typeof(value,iflash.utils.BigInteger)){
				if (value.compareTo(uint._CIRCLE)>=0 && value.compareTo(uint.ZERO)< 0)
					return value.add(uint.CIRCLE);
				else if (value.compareTo(uint._CIRCLE)< 0){
					return uint(value.mod(uint.CIRCLE));
				}
				else if (value.compareTo(4294967295)> 0){
					value=value.mod(uint.CIRCLE);
				}
				return value;
			}
			else{
				value=Laya.__parseInt(value);
				if(value>=-4294967295-1&&value<0)
					return value+4294967295+1+offset;
				else if(value<-4294967295-1)
				return uint(value%(4294967295+1))+offset
				else if(value>4294967295)
				value=value%(4294967295+1)+offset;
				return value;
			}
		}

		__class(uint,'uint',false);
		var __proto=uint.prototype;
		__proto.toString=function(radix){
			(radix===void 0)&& (radix=10);
			return Number(this).toString(radix);
		}

		__proto.valueOf=function(){
			return this;
		}

		__proto.toExponential=function(p){
			(p===void 0)&& (p=0);
			return Number(this).toExponential(p);
		}

		__proto.toPrecision=function(p){
			(p===void 0)&& (p=0);
			return Number(this).toPrecision(p);
		}

		__proto.toFixed=function(p){
			(p===void 0)&& (p=0);
			return Number(this).toFixed(p);
		}

		uint.MAX_VALUE=4294967295;
		uint.MAX_UINT=4294967295;
		uint.length=1;
		__static(uint,
		['_MAX_UINT',function(){return this._MAX_UINT=new iflash.utils.BigInteger("-4294967295");},'ZERO',function(){return this.ZERO=new iflash.utils.BigInteger("0");},'CIRCLE',function(){return this.CIRCLE=new iflash.utils.BigInteger("4294967296");},'_CIRCLE',function(){return this._CIRCLE=new iflash.utils.BigInteger("-4294967296");}
		]);
		return uint;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/mx/utils/stringutil.as
	//class mx.utils.StringUtil
	var StringUtil=(function(){
		function StringUtil(){};
		__class(StringUtil,'mx.utils.StringUtil',true);
		StringUtil.trim=function(str){
			if (str==null){
				return '';
			};
			var startIndex=0;
			while (StringUtil.isWhitespace(str.charAt(startIndex))){
				++startIndex;
			};
			var endIndex=str.length-1;
			while (StringUtil.isWhitespace(str.charAt(endIndex))){
				--endIndex;
			}
			if (endIndex >=startIndex){
				return str.slice(startIndex,endIndex+1);
			}
			else{
				return "";
			}
		}

		StringUtil.trimArrayElements=function(value,delimiter){
			if (value !="" && value !=null){
				var items=value.split(delimiter);
				var len=items.length;
				for (var i=0;i < len;i++){
					items[i]=mx.utils.StringUtil.trim(items[i]);
				}
				if (len > 0){
					value=items.join(delimiter);
				}
			}
			return value;
		}

		StringUtil.isWhitespace=function(character){
			switch (character){
				case " " :
				case "\t" :
				case "\r" :
				case "\n" :
				case "\f" :
					return true;
				default :
					return false;
				}
		}

		StringUtil.substitute=function(str,__rest){
			var rest=[];for(var i=1,sz=arguments.length;i<sz;i++)rest.push(arguments[i]);
			if (str==null){
				return '';
			};
			var len=rest.length;
			var args;
			if (len==1 && ((rest[0])instanceof Array)){
				args=rest [0];
				len=args.length;
			}
			else{
				args=rest;
			}
			for (var i=0;i < len;i++){
				str=str.replace(new RegExp("\\{"+i+"\\}","g"),args[i]);
			}
			return str;
		}

		return StringUtil;
	})()


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/left/panelleft/panelmodel.as
	//class mvc.left.panelleft.PanelModel
	var PanelModel=(function(){
		function PanelModel(){
			this._item=null;
			this._item=new mx.collections.ArrayCollection;
		}

		__class(PanelModel,'mvc.left.panelleft.PanelModel',true);
		var __proto=PanelModel.prototype;
		__proto.panelNodeVoAddInfoNode=function($PanelNodeVo,$pos,$type){
			var $PanelRectInfoNode=new PanelRectInfoNode;
			if($type==/*mvc.left.panelleft.vo.PanelRectInfoType.PICTURE*/0){
				$PanelRectInfoNode.type=/*mvc.left.panelleft.vo.PanelRectInfoType.PICTURE*/0;
				$PanelRectInfoNode.dataItem=[""];
			}
			if($type==/*mvc.left.panelleft.vo.PanelRectInfoType.BUTTON*/1){
				$PanelRectInfoNode.type=/*mvc.left.panelleft.vo.PanelRectInfoType.BUTTON*/1;
				$PanelRectInfoNode.dataItem=["",""];
			}
			$PanelRectInfoNode.name="newName"
			$PanelRectInfoNode.level=$PanelNodeVo.item.length
			$PanelRectInfoNode.rect=new Rectangle($pos.x,$pos.y,100,100)
			$PanelRectInfoNode.sprite=new PanelRectInfoSprite()
			$PanelRectInfoNode.sprite.panelRectInfoNode=$PanelRectInfoNode
			$PanelNodeVo.item.addItem($PanelRectInfoNode)
		}

		__proto.addNewPanelVo=function(){
			var $PanelNodeVo=new PanelNodeVo
			$PanelNodeVo.name="新面板"
			$PanelNodeVo.item=new mx.collections.ArrayCollection
			$PanelNodeVo.canverRect=new Rectangle(0,0,256,256)
			this._item.addItem($PanelNodeVo)
		}

		__proto.getPanelNodeItemToSave=function(){
			var arr=new Array;
			for(var i=0;i<this._item.length;i++){
				var $PanelNodeVo=this._item [i]
				arr.push($PanelNodeVo.readObject())
			}
			return arr;
		}

		__proto.setPanelNodeItemByObj=function($arr){
			this._item=new mx.collections.ArrayCollection;
			for(var i=0;$arr&&i<$arr.length;i++){
				var $PanelNodeVo=new PanelNodeVo();
				$PanelNodeVo.setObject($arr[i])
				this._item.addItem($PanelNodeVo)
			}
		}

		__proto.geth5XML=function(){
			var arr=new Array;
			for(var i=0;i<this._item.length;i++){
				var $PanelNodeVo=this._item [i]
				arr.push($PanelNodeVo.readObjectToH5())
			}
			return arr;
		}

		__proto.makeNewScene=function(){
			this._item=new mx.collections.ArrayCollection;
		}

		__getset(0,__proto,'item',function(){
			return this._item;
			},function(value){
			this._item=value;
		});

		PanelModel.getInstance=function(){
			if(!PanelModel.instance){
				PanelModel.instance=new PanelModel();
			}
			return PanelModel.instance;
		}

		PanelModel.instance=null
		return PanelModel;
	})()


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/left/panelleft/vo/panelrectinfotype.as
	//class mvc.left.panelleft.vo.PanelRectInfoType
	var PanelRectInfoType=(function(){
		function PanelRectInfoType(){}
		__class(PanelRectInfoType,'mvc.left.panelleft.vo.PanelRectInfoType',true);
		PanelRectInfoType.PICTURE=0;
		PanelRectInfoType.BUTTON=1;
		return PanelRectInfoType;
	})()


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/top/clearh5spacemodel.as
	//class mvc.top.ClearH5spaceModel
	var ClearH5spaceModel=(function(){
		function ClearH5spaceModel(){
			this.allFileItem=null;
			this.selectFile
			this.rootFileUrl
			this.useFileDic
			this.LINE_FEED=String.fromCharCode(10);
		}

		__class(ClearH5spaceModel,'mvc.top.ClearH5spaceModel',true);
		var __proto=ClearH5spaceModel.prototype;
		__proto.run=function(){
			var _$this=this;
			this.selectFile=new File;
			var txtFilter=new FileFilter("Text",".gfile;*.gfile;");
			this.selectFile.browseForOpen("打开工程文件 ",[txtFilter]);
			this.selectFile.addEventListener(/*iflash.events.Event.SELECT*/"select",onSelect);
			function onSelect (e){
				_$this.clearSpaceByFile(_$this.selectFile.parent.parent)
			}
		}

		__proto.clearSpaceByFile=function($file){
			this.rootFileUrl=$file.url
			this.useFileDic=new Dictionary
			this.allFileItem=this.getInFolderFile($file)
			this.makeUseFileKey();
			this.clearNoUseFile(this.selectFile);
			while(this.clearEmptyDirectory($file)){}
		}

		__proto.clearEmptyDirectory=function($file){
			var isHave=false
			this.allFileItem=this.getEmpFolderFile($file)
			var $tempFile;
			/*for each*/for(var $each_$tempFile in this.allFileItem){
				$tempFile=this.allFileItem[$each_$tempFile];
				if($tempFile.isDirectory){
					if($tempFile.exists){
						console.log("删除空文件夹",$tempFile.url);
						$tempFile.deleteDirectory()
						isHave=true
					}
				}
			}
			return isHave
		}

		__proto.getEmpFolderFile=function($sonFile){
			var $fileItem=new Array
			if($sonFile.exists && $sonFile.isDirectory){
				var arr=$sonFile.getDirectoryListing();
				var $tempFile;
				/*for each*/for(var $each_$tempFile in arr){
					$tempFile=arr[$each_$tempFile];
					if($tempFile.isDirectory){
						var barr=$tempFile.getDirectoryListing();
						if(barr.length>0){
							$fileItem=$fileItem.concat(this.getEmpFolderFile($tempFile))
							}else{
							$fileItem.push($tempFile)
						}
					}
				}
			}
			return $fileItem
		}

		__proto.clearNoUseFile=function($file){
			var $fsScene=new FileStream;
			$fsScene.open($file,/*iflash.filesystem.FileMode.READ*/"read");
			var $str=$fsScene.readUTFBytes($fsScene.bytesAvailable)
			$fsScene.close()
			var lines=$str.split(this.LINE_FEED);
			for(var i=0;i < lines.length;i++){
				var tempUrl=this.trim(lines[i]);
				if(tempUrl.length>0){
					console.log(this.rootFileUrl+"/"+tempUrl)
					if(!this.useFileDic[tempUrl]){
						var $delFile=new File(this.rootFileUrl+"/"+tempUrl)
						if($delFile.exists){
							$delFile.deleteFile()
						}
					}
				}
			}
		}

		__proto.makeUseFileKey=function(){
			var $tempFile;
			/*for each*/for(var $each_$tempFile in this.allFileItem){
				$tempFile=this.allFileItem[$each_$tempFile];
				if($tempFile.extension=="gfile"){
					if($tempFile.url!=this.selectFile.url){
						this.meshFileData($tempFile);
					}
				}
			}
		}

		__proto.meshFileData=function($file){
			var $fsScene=new FileStream;
			$fsScene.open($file,/*iflash.filesystem.FileMode.READ*/"read");
			var $str=$fsScene.readUTFBytes($fsScene.bytesAvailable)
			var lines=$str.split(this.LINE_FEED);
			for(var i=0;i < lines.length;i++){
				var tempUrl=this.trim(lines[i]);
				if(tempUrl.length){
					if(!this.useFileDic[tempUrl]){
						this.useFileDic[tempUrl]=tempUrl
					}
				}
			}
		}

		__proto.trim=function(str){
			return str.replace(/([ 　]{1})/g,"");
		}

		__proto.getInFolderFile=function($sonFile){
			var $fileItem=new Array
			if($sonFile.exists && $sonFile.isDirectory){
				var arr=$sonFile.getDirectoryListing();
				var $tempFile;
				/*for each*/for(var $each_$tempFile in arr){
					$tempFile=arr[$each_$tempFile];
					if($tempFile.isDirectory){
						$fileItem=$fileItem.concat(this.getInFolderFile($tempFile))
						}else{
						$fileItem.push($tempFile)
					}
				}
				}else{
				$fileItem.push($sonFile)
			}
			return $fileItem
		}

		ClearH5spaceModel.getInstance=function(){
			if(!ClearH5spaceModel.instance){
				ClearH5spaceModel.instance=new ClearH5spaceModel();
			}
			return ClearH5spaceModel.instance;
		}

		ClearH5spaceModel.instance=null
		return ClearH5spaceModel;
	})()


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/top/topmenudata.as
	//class mvc.top.TopMenuData
	var TopMenuData=(function(){
		function TopMenuData(){}
		__class(TopMenuData,'mvc.top.TopMenuData',true);
		var __proto=TopMenuData.prototype;
		__getset(1,TopMenuData,'menuXml',function(){return this._bind$_menuXml;},function(value){var pre=this._bind$_menuXml;if(pre===value)return;this._bind$_menuXml=value;mx.events.PropertyChangeEvent.event(this,'menuXml',pre,value);});
		__static(TopMenuData,
		['menuXml',function(){return this.menuXml=new XML("<root><menuitem label=\"文件\"><menuitem label=\"打开文件\" id=\"0\"/><menuitem label=\"新建立空项目\" id=\"1\"/><menuitem label=\"保存文件\" id=\"2\"/><menuitem label=\"文件另存为\" id=\"3\"/><menuitem label=\"刷新图片\" id=\"4\"/></menuitem><menuitem label=\"创建\"><menuitem label=\"创建新单元\" id=\"20\"/><menuitem label=\"创建9宫格\" id=\"21\"/></menuitem><menuitem label=\"编辑\"><menuitem label=\"复制\" id=\"30\"/><menuitem label=\"粘贴\" id=\"31\"/><menuitem label=\"删除\" id=\"32\"/><menuitem label=\"撤销一次\" id=\"33\"/><menuitem label=\"重作一次\" id=\"34\"/></menuitem><menuitem label=\"导出\"><menuitem label=\"导出h5uiXML\" id=\"40\"/></menuitem><menuitem label=\"窗口\"><menuitem label=\"清理H5工作目录\" id=\"50\"/></menuitem></root>");}
		]);
		return TopMenuData;
	})()


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/uimodulelist.as
	//class mvc.UiModuleList
	var UiModuleList=(function(){
		function UiModuleList(){
			throw new Error("Modulist Class can not be created by new!");
		}

		__class(UiModuleList,'mvc.UiModuleList',true);
		UiModuleList.getModuleList=function(){
			return [
			UiSceneModule,
			DisCentenModule,
			PanelLeftModule,
			DisLeftModule,
			PanelCentenModule,
			TopModule,
			ProjectModule,];
		}

		UiModuleList.startup=function(){
			var allModules=UiModuleList.getModuleList();
			for(var i=0;i<allModules.length;i++){
				var mClass=allModules[i];
				UiModuleList.statrupOneModule(mClass);
			}
		}

		UiModuleList.statrupOneModule=function($class){
			if(com.zcp.frame.Module.hasModule($class))
				return;
			var module=(new $class());
			com.zcp.frame.Module.registerModule(module);
		}

		return UiModuleList;
	})()


	//file:///c:/users/pan/desktop/workspace/uieditor/src/uidata.as
	//class UiData
	var UiData=(function(){
		function UiData(){}
		__class(UiData,'UiData',true);
		__getset(1,UiData,'selectArr',function(){
			return UiData._selectArr;
			},function(value){
			UiData._selectArr=value;
		});

		UiData.getSharedObject=function(){
			return SharedObject.getLocal("a4","/");
		}

		UiData.makeNewUiFile=function(){
			UiData.nodeItem=new mx.collections.ArrayCollection;
			UiData.selectArr=new Array;
			UiData.bmpitem=new Array
			UiData.sceneBmpRec=new Rectangle(0,0,512,512)
			UiData.isNewH5UI=true;
			PanelModel.getInstance().makeNewScene()
			com.zcp.frame.event.ModuleEventManager.dispatchEvent(new UiSceneEvent(/*mvc.scene.UiSceneEvent.REFRESH_SCENE_DATA*/"REFRESH_SCENE_DATA"));
		}

		UiData.getUiNodeByName=function($name){
			for(var i=0;UiData.nodeItem&&i<UiData.nodeItem.length;i++){
				if((UiData.nodeItem[i]).name==$name){
					return (UiData.nodeItem[i])
				}
			}
			return null
		}

		UiData.getUIBitmapDataByName=function($name){
			var $H5UIFileNode=UiData.getUiNodeByName($name)
			if($H5UIFileNode){
				var bmp=new BitmapData($H5UIFileNode.rect.width,$H5UIFileNode.rect.height,true,0x00000000);
				var m=new Matrix;
				m.tx=-$H5UIFileNode.rect.x
				m.ty=-$H5UIFileNode.rect.y
				bmp.draw(UiData.bitMapData,m)
				return bmp;
				}else{
				return null
			}
		}

		UiData.getFileBmpItem=function(){
			var arr=new Array
			for(var i=0;i<UiData.bmpitem.length;i++){
				if(!UiData.bmpitem[i].dele){
					var $obj=new Object
					$obj.rect=UiData.bmpitem[i].rect
					$obj.url=UiData.bmpitem[i].url;
					var rect=new Rectangle(0,0,UiData.bmpitem[i].rect.width,UiData.bmpitem[i].rect.height);
					$obj.bmpByte=UiData.bmpitem[i].bmp.getPixels(rect)
					arr.push($obj)
				}
			}
			return arr;
		}

		UiData.meshInfo=function($InfoRectItem){
			UiData.nodeItem=new mx.collections.ArrayCollection
			for(var i=0;i<$InfoRectItem.length;i++){
				var $H5UIFileNode=new H5UIFileNode
				$H5UIFileNode.name=$InfoRectItem[i].name
				$H5UIFileNode.type=$InfoRectItem[i].type
				$H5UIFileNode.rect=new Rectangle;
				$H5UIFileNode.rect.x=int($InfoRectItem[i].rect.x)
				$H5UIFileNode.rect.y=int($InfoRectItem[i].rect.y)
				$H5UIFileNode.rect.width=int($InfoRectItem[i].rect.width)
				$H5UIFileNode.rect.height=int($InfoRectItem[i].rect.height)
				if($H5UIFileNode.type==/*vo.FileInfoType.ui9*/1){
					$H5UIFileNode.rect9=new Rectangle;
					if($InfoRectItem[i].rect9){
						$H5UIFileNode.rect9.x=int($InfoRectItem[i].rect9.x)
						$H5UIFileNode.rect9.y=int($InfoRectItem[i].rect9.y)
						$H5UIFileNode.rect9.width=int($InfoRectItem[i].rect9.width)
						$H5UIFileNode.rect9.height=int($InfoRectItem[i].rect9.height)
					}
				}
				UiData.nodeItem.addItem($H5UIFileNode)
			}
		}

		UiData.meshBmp=function($FileBmpItem){
			UiData.bmpitem=new Array
			for(var i=0;i<$FileBmpItem.length;i++){
				var $FileDataVo=new FileDataVo;
				$FileDataVo.url=$FileBmpItem[i].url;
				$FileDataVo.rect=new Rectangle;
				$FileDataVo.rect.x=int($FileBmpItem[i].rect.x)
				$FileDataVo.rect.y=int($FileBmpItem[i].rect.y)
				$FileDataVo.rect.width=$FileBmpItem[i].rect.width
				$FileDataVo.rect.height=$FileBmpItem[i].rect.height
				$FileDataVo.bmp=new BitmapData($FileDataVo.rect.width,$FileDataVo.rect.height)
				var $bmpByte=($FileBmpItem[i].bmpByte);
				$FileDataVo.bmp.setPixels(new Rectangle(0,0,$FileDataVo.rect.width,$FileDataVo.rect.height),$bmpByte)
				UiData.bmpitem.push($FileDataVo);
			}
		}

		UiData.getInfoRectItem=function(){
			var arr=new Array
			for(var i=0;i<UiData.nodeItem.length;i++){
				var $obj=new Object
				$obj.rect=UiData.nodeItem[i].rect;
				$obj.rect9=UiData.nodeItem[i].rect9;
				$obj.name=UiData.nodeItem[i].name;
				$obj.type=UiData.nodeItem[i].type;
				arr.push($obj)
			}
			return arr;
		}

		UiData.makeCopy=function(){
			UiData._copyItem=new Array
			if(UiData.selectArr&&UiData.selectArr.length){
				for(var i=0;i<UiData.selectArr.length;i++){
					UiData._copyItem.push(UiData.selectArr[i])
				}
			}
		}

		UiData.paste=function(){
			if(UiData._copyItem&&UiData._copyItem.length){
				UiData.selectArr=new Array
				for(var i=0;i<UiData._copyItem.length;i++){
					UiData._copyItem[i].select=false;
					var $H5UIFileNode=UiData._copyItem[i].clone();
					$H5UIFileNode.name=UiData._copyItem[i].name+"_copy";
					$H5UIFileNode.select=true
					UiData.nodeItem.addItem($H5UIFileNode)
					UiData.selectArr.push($H5UIFileNode)
				}
				com.zcp.frame.event.ModuleEventManager.dispatchEvent(new UiSceneEvent(/*mvc.scene.UiSceneEvent.REFRESH_SCENE_DATA*/"REFRESH_SCENE_DATA"));
				return true
			}
			return false
		}

		UiData.saveToH5xml=function($url,$filename){
			var w=UiData.sceneBmpRec.width;
			var h=UiData.sceneBmpRec.height;
			var bmp=new BitmapData(w,h);
			UiData.isHaveRepeatName()
			if(UiData.nodeItem){
				var $infoArr=new Array
				for(var j=0;j<UiData.nodeItem.length;j++){
					var $H5UIFileNode=UiData.nodeItem [j];
					var $infoObj=new Object;
					$infoObj.name=$H5UIFileNode.name
					$infoObj.type=$H5UIFileNode.type
					$infoObj.x=$H5UIFileNode.rect.x/w
					$infoObj.y=$H5UIFileNode.rect.y/h
					$infoObj.width=$H5UIFileNode.rect.width/w
					$infoObj.height=$H5UIFileNode.rect.height/h
					$infoObj.ox=$H5UIFileNode.rect.x
					$infoObj.oy=$H5UIFileNode.rect.y
					$infoObj.ow=$H5UIFileNode.rect.width
					$infoObj.oh=$H5UIFileNode.rect.height
					if($H5UIFileNode.type==/*vo.FileInfoType.ui9*/1){
						$infoObj.ux=$H5UIFileNode.rect9.x/w
						$infoObj.uy=$H5UIFileNode.rect9.y/h
						$infoObj.uwidth=$H5UIFileNode.rect9.width/w
						$infoObj.uheight=$H5UIFileNode.rect9.height/h
						$infoObj.uox=$H5UIFileNode.rect9.x
						$infoObj.uoy=$H5UIFileNode.rect9.y
						$infoObj.uow=$H5UIFileNode.rect9.width
						$infoObj.uoh=$H5UIFileNode.rect9.height
					}
					$infoArr.push($infoObj)
				};
				var fileObj=new Object;
				fileObj.uiArr=$infoArr
				fileObj.panelArr=PanelModel.getInstance().geth5XML()
				var str=JSON.stringify(fileObj);
				var fs=new FileStream();
				fs.open(new File($url+"/"+$filename+".xml"),/*iflash.filesystem.FileMode.WRITE*/"write");
				for(var k=0;k < str.length;k++){
					fs.writeMultiByte(str.substr(k,1),"utf-8");
				}
				fs.close();
			}
		}

		UiData.isHaveRepeatName=function(){
			if(UiData.nodeItem){
				var $infoArr=new Array
				for(var i=0;i<UiData.nodeItem.length;i++){
					var $H5UIFileNodeA=UiData.nodeItem [i];
					for(var j=(i+1);j<UiData.nodeItem.length;j++){
						var $H5UIFileNodeB=UiData.nodeItem [j];
						if($H5UIFileNodeA.name==$H5UIFileNodeB.name){
							mx.controls.Alert.show($H5UIFileNodeA.name+" 名字重复！","提示")
							return true
						}
					}
				}
			}
			return false
		}

		UiData.editMode=0;
		UiData.nodeItem=null
		UiData._selectArr=null
		UiData.bmpitem=null
		UiData.bigBitmapUrl=null
		UiData.sceneColor=0;
		UiData.sceneBmpRec=null
		UiData.url=null
		UiData.isNewH5UI=false;
		UiData.bitMapData=null
		UiData._copyItem=null
		return UiData;
	})()


	//file:///c:/users/pan/desktop/workspace/uieditor/src/vo/filedatavo.as
	//class vo.FileDataVo
	var FileDataVo=(function(){
		function FileDataVo(){
			this.bmp=null;
			this.rect=null;
			this.url=null;
			this.sprite=null;
			this.dele=false;
		}

		__class(FileDataVo,'vo.FileDataVo',true);
		return FileDataVo;
	})()


	//file:///c:/users/pan/desktop/workspace/uieditor/src/vo/fileinfotype.as
	//class vo.FileInfoType
	var FileInfoType=(function(){
		function FileInfoType(){}
		__class(FileInfoType,'vo.FileInfoType',true);
		FileInfoType.baseUi=0;
		FileInfoType.ui9=1;
		return FileInfoType;
	})()


	//file:///c:/users/pan/desktop/workspace/uieditor/src/vo/h5uivo.as
	//class vo.H5UIVo
	var H5UIVo=(function(){
		function H5UIVo(){
			this.rect=null;
			this.name=null;
		}

		__class(H5UIVo,'vo.H5UIVo',true);
		return H5UIVo;
	})()


	//file:///c:/users/pan/desktop/workspace/uieditor/src/vo/historymodel.as
	//class vo.HistoryModel
	var HistoryModel=(function(){
		var HistoryVo;
		function HistoryModel(){
			this._item=null;
			this._readId=0;
			this.clearHistoryAll()
		}

		__class(HistoryModel,'vo.HistoryModel',true);
		var __proto=HistoryModel.prototype;
		__proto.saveSeep=function(){
			if(!UiData.nodeItem){
				return;
			}
			if(this._item.length){
				if(this._item[0].infoNodeItem.length==UiData.nodeItem.length){
					}else{
					this._item=new Array;
				}
			}
			if(this._item.length){
				if(this._readId<this._item.length){
					this._item.splice(this._readId+1,this._item.length-this._readId-1)
				}
				if(this.isNeedSave){
					this._item.push(this.getNeedSaveVo())
				}else{}
				}else{
				this._item.push(this.getNeedSaveVo())
			}
			this._readId=this._item.length-1;
			console.log("_item",this._item.length)
		}

		__proto.clearHistoryAll=function(){
			this._readId=0
			this._item=new Array
		}

		__proto.cancelScene=function(){
			if(this._readId>0){
				this.resetData(this._readId-1);
			}
		}

		__proto.nextScene=function(){
			if(this._readId<(this._item.length-1)){
				this.resetData(this._readId+1);
			}
		}

		__proto.resetData=function($num){
			this._readId=$num;
			var $HistoryVo=this._item[this._readId]
			for(var j=0;j<UiData.nodeItem.length;j++){
				var $H5UIFileNode=UiData.nodeItem [j];
				var $rectInof=$HistoryVo.infoNodeItem[j];
				$H5UIFileNode.rect.x=$rectInof.x
				$H5UIFileNode.rect.y=$rectInof.y
				$H5UIFileNode.rect.width=$rectInof.width
				$H5UIFileNode.rect.height=$rectInof.height
				$H5UIFileNode.sprite.updata();
			}
		}

		__proto.getNeedSaveVo=function(){
			var $HistoryVo=new HistoryVo
			$HistoryVo.infoNodeItem=new Array
			for(var j=0;j<UiData.nodeItem.length;j++){
				var $H5UIFileNode=UiData.nodeItem [j];
				$HistoryVo.infoNodeItem.push($H5UIFileNode.rect.clone())
			}
			return $HistoryVo
		}

		__getset(0,__proto,'isNeedSave',function(){
			var $HistoryVo=this._item[this._item.length-1]
			for(var j=0;j<UiData.nodeItem.length;j++){
				var $H5UIFileNode=UiData.nodeItem [j];
				var $rectInfo=$HistoryVo.infoNodeItem [j]
				if($rectInfo.equals($H5UIFileNode.rect)){
					}else{
					console.log("需要修改----info")
					return true
				}
			}
			return false
		});

		HistoryModel.getInstance=function(){
			if(!HistoryModel.instance){
				HistoryModel.instance=new HistoryModel();
			}
			return HistoryModel.instance;
		}

		HistoryModel.instance=null
		HistoryModel.__init$=function(){
			//class HistoryVo
			HistoryVo=(function(){
				function HistoryVo(){
					this.infoNodeItem
				}
				__class(HistoryVo,'',true);
				return HistoryVo;
			})()
		}

		return HistoryModel;
	})()


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/argumenterror.jas
	//class ArgumentError extends Error
	var ArgumentError=(function(_super){
		function ArgumentError(message){
			ArgumentError.__super.call(this);
			(message===void 0)&& (message="");
		}

		__class(ArgumentError,'ArgumentError',true,Error);
		return ArgumentError;
	})(Error)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/rangeerror.jas
	//class RangeError extends Error
	var RangeError=(function(_super){
		function RangeError(message){
			RangeError.__super.call(this);
			(message===void 0)&& (message="");
		}

		__class(RangeError,'RangeError',true,Error);
		return RangeError;
	})(Error)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/h5uimetadataview.as
	//class mesh.H5UIMetaDataView extends common.utils.frame.MetaDataView
	var H5UIMetaDataView=(function(_super){
		function H5UIMetaDataView(){
			this._meshNodeLabel=null;
			H5UIMetaDataView.__super.call(this);
			this.iconLable.visible=false;
			this._meshNodeLabel=new NodeIconLabel;
			this.addChild(this._meshNodeLabel);
		}

		__class(H5UIMetaDataView,'mesh.H5UIMetaDataView',true);
		var __proto=H5UIMetaDataView.prototype;
		__proto.setTarget=function(target){
			this._meshNodeLabel.target=target
			this._meshNodeLabel.label=interfaces.ITile(target).getName();
			_super.prototype.setTarget(target)
		}

		__proto.creatComponteByMetadata=function(obj){
			var type=obj.type;
			var k=_super.prototype.creatComponteByMetadata(obj)
			if(type=="AlignRect"){
				k=this.getAlignRect(obj)
			}
			if(type=="PanelPictureUI"){
				k=this.getPanelPictureUI(obj)
			}
			return k;
		}

		__proto.getPanelPictureUI=function(obj){
			var $preFabModelPic=new PanelPictureUI()
			$preFabModelPic.FunKey=obj.key;
			$preFabModelPic.titleLabel=obj[common.utils.frame.ReflectionData.Key_Label];
			$preFabModelPic.category=obj[common.utils.frame.ReflectionData.Key_Category];
			$preFabModelPic.donotDubleClik=obj[common.utils.frame.ReflectionData.donotDubleClik];
			return $preFabModelPic;
		}

		__proto.getAlignRect=function(obj){
			var $CollisionUi=new AlignRect()
			$CollisionUi.FunKey=obj.key;
			$CollisionUi.category=obj[common.utils.frame.ReflectionData.Key_Category];
			return $CollisionUi;
		}

		return H5UIMetaDataView;
	})(common.utils.frame.MetaDataView)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/ui/alignrect.as
	//class mesh.ui.AlignRect extends common.utils.frame.BaseComponent
	var AlignRect=(function(_super){
		function AlignRect(){
			this._iconBmp=null;
			this._align_but_1=null;
			this._align_but_2=null;
			this._align_but_3=null;
			this._align_but_4=null;
			this._align_but_5=null;
			this._align_but_6=null;
			this._align_but_7=null;
			this._align_but_8=null;
			this._align_but_9=null;
			this._align_but_10=null;
			this._align_but_11=null;
			AlignRect.__super.call(this);
			this.addButAlign1();
			this.addButAlign2();
			this.addButAlign3()
			this.addButAlign4()
			this.addButAlign5()
			this.addButAlign6()
			this.addButAlign7()
			this.addButAlign8()
			this.addButAlign9()
			this.addButAlign10()
			this.addButAlign11()
			this.addEvents();
			this.height=200
			this.isDefault=false
		}

		__class(AlignRect,'mesh.ui.AlignRect',true);
		var __proto=AlignRect.prototype;
		__proto.addButAlign7=function(){
			this._align_but_7=new common.utils.ui.prefab.PicBut
			this.addChild(this._align_but_7)
			this._align_but_7.setBitmapdata(modules.brower.fileWin.BrowerManage.getIcon("h5uia7"),20,20)
			this._align_but_7.y=50-25
			this._align_but_7.x=20
		}

		__proto.addButAlign8=function(){
			this._align_but_8=new common.utils.ui.prefab.PicBut
			this.addChild(this._align_but_8)
			this._align_but_8.setBitmapdata(modules.brower.fileWin.BrowerManage.getIcon("h5uia8"),20,20)
			this._align_but_8.y=50-25
			this._align_but_8.x=50
		}

		__proto.addButAlign9=function(){
			this._align_but_9=new common.utils.ui.prefab.PicBut
			this.addChild(this._align_but_9)
			this._align_but_9.setBitmapdata(modules.brower.fileWin.BrowerManage.getIcon("h5uia9"),20,20)
			this._align_but_9.y=50-25
			this._align_but_9.x=80
		}

		__proto.addButAlign10=function(){
			this._align_but_10=new common.utils.ui.prefab.PicBut
			this.addChild(this._align_but_10)
			this._align_but_10.setBitmapdata(modules.brower.fileWin.BrowerManage.getIcon("h5uia10"),20,20)
			this._align_but_10.y=75-50
			this._align_but_10.x=20+90
		}

		__proto.addButAlign11=function(){
			this._align_but_11=new common.utils.ui.prefab.PicBut
			this.addChild(this._align_but_11)
			this._align_but_11.setBitmapdata(modules.brower.fileWin.BrowerManage.getIcon("h5uia11"),20,20)
			this._align_but_11.y=75-50
			this._align_but_11.x=50+90
		}

		__proto.addButAlign4=function(){
			this._align_but_4=new common.utils.ui.prefab.PicBut
			this.addChild(this._align_but_4)
			this._align_but_4.setBitmapdata(modules.brower.fileWin.BrowerManage.getIcon("h5uia4"),20,20)
			this._align_but_4.y=25-25
			this._align_but_4.x=20+90
		}

		__proto.addButAlign5=function(){
			this._align_but_5=new common.utils.ui.prefab.PicBut
			this.addChild(this._align_but_5)
			this._align_but_5.setBitmapdata(modules.brower.fileWin.BrowerManage.getIcon("h5uia5"),20,20)
			this._align_but_5.y=25-25
			this._align_but_5.x=50+90
		}

		__proto.addButAlign6=function(){
			this._align_but_6=new common.utils.ui.prefab.PicBut
			this.addChild(this._align_but_6)
			this._align_but_6.setBitmapdata(modules.brower.fileWin.BrowerManage.getIcon("h5uia6"),20,20)
			this._align_but_6.y=25-25
			this._align_but_6.x=80+90
		}

		__proto.addButAlign1=function(){
			this._align_but_1=new common.utils.ui.prefab.PicBut
			this.addChild(this._align_but_1)
			this._align_but_1.setBitmapdata(modules.brower.fileWin.BrowerManage.getIcon("h5uia1"),20,20)
			this._align_but_1.y=0
			this._align_but_1.x=20
		}

		__proto.addButAlign2=function(){
			this._align_but_2=new common.utils.ui.prefab.PicBut
			this.addChild(this._align_but_2)
			this._align_but_2.setBitmapdata(modules.brower.fileWin.BrowerManage.getIcon("h5uia2"),20,20)
			this._align_but_2.y=0
			this._align_but_2.x=50
		}

		__proto.addButAlign3=function(){
			this._align_but_3=new common.utils.ui.prefab.PicBut
			this.addChild(this._align_but_3)
			this._align_but_3.setBitmapdata(modules.brower.fileWin.BrowerManage.getIcon("h5uia3"),20,20)
			this._align_but_3.y=0
			this._align_but_3.x=80
		}

		__proto.addEvents=function(){
			this._align_but_1.addEventListener(/*iflash.events.MouseEvent.CLICK*/"click",__bind(this,this.onMouseAlign1))
			this._align_but_2.addEventListener(/*iflash.events.MouseEvent.CLICK*/"click",__bind(this,this.onMouseAlign2))
			this._align_but_3.addEventListener(/*iflash.events.MouseEvent.CLICK*/"click",__bind(this,this.onMouseAlign3))
			this._align_but_4.addEventListener(/*iflash.events.MouseEvent.CLICK*/"click",__bind(this,this.onMouseAlign4))
			this._align_but_5.addEventListener(/*iflash.events.MouseEvent.CLICK*/"click",__bind(this,this.onMouseAlign5))
			this._align_but_6.addEventListener(/*iflash.events.MouseEvent.CLICK*/"click",__bind(this,this.onMouseAlign6))
			this._align_but_7.addEventListener(/*iflash.events.MouseEvent.CLICK*/"click",__bind(this,this.onMouseAlign7))
			this._align_but_8.addEventListener(/*iflash.events.MouseEvent.CLICK*/"click",__bind(this,this.onMouseAlign8))
			this._align_but_9.addEventListener(/*iflash.events.MouseEvent.CLICK*/"click",__bind(this,this.onMouseAlign9))
			this._align_but_10.addEventListener(/*iflash.events.MouseEvent.CLICK*/"click",__bind(this,this.onMouseAlign10))
			this._align_but_11.addEventListener(/*iflash.events.MouseEvent.CLICK*/"click",__bind(this,this.onMouseAlign11))
		}

		__proto.onMouseAlign11=function(event){
			var $arr=(this.target).selectItem;
			var $sortArr=new Array;
			var $minX=NaN;
			var $maxX=NaN;
			var $tatolW=0
			for(var i=0;$arr&&i<$arr.length;i++){
				var $px=$arr[i].rect.x
				if($minX||$maxX){
					$minX=Math.min($minX,$px)
					$maxX=Math.max($maxX,$px+$arr[i].rect.width)
					}else{
					$minX=$px;
					$maxX=$px+$arr[i].rect.width;
				}
				$sortArr.push($arr[i])
				$tatolW+=$arr[i].rect.width;
			}
			$sortArr.sort(upperCaseFunc);
			function upperCaseFunc (a,b){
				var dis0=a.rect.x+a.rect.width/2-$minX;
				var dis1=b.rect.x+b.rect.width/2-$minX;
				return dis0-dis1;
			};
			var speedPos=($maxX-$minX)-$tatolW;
			var nextPos=$minX
			for(var j=0;j<$sortArr.length&&$sortArr.length>1;j++){
				$sortArr[j].rect.x=nextPos;
				nextPos=$sortArr[j].rect.x+$sortArr[j].rect.width+(speedPos/($sortArr.length-1))
			}
			this.changeData()
		}

		__proto.changeData=function(){
			/*no*/this.target[/*no*/this.FunKey]=true;
		}

		__proto.onMouseAlign10=function(event){
			var $arr=(this.target).selectItem;
			var $sortArr=new Array;
			var $minY=NaN;
			var $maxY=NaN;
			var $tatolW=0
			for(var i=0;$arr&&i<$arr.length;i++){
				var $py=$arr[i].rect.y
				if($minY||$maxY){
					$minY=Math.min($minY,$py)
					$maxY=Math.max($maxY,$py+$arr[i].rect.height)
					}else{
					$minY=$py;
					$maxY=$py+$arr[i].rect.height;
				}
				$sortArr.push($arr[i])
				$tatolW+=$arr[i].rect.height;
			}
			$sortArr.sort(upperCaseFunc);
			function upperCaseFunc (a,b){
				var dis0=a.rect.y+a.rect.height/2-$minY;
				var dis1=b.rect.y+b.rect.height/2-$minY;
				return dis0-dis1;
			};
			var speedPos=($maxY-$minY)-$tatolW;
			var nextPos=$minY
			for(var j=0;j<$sortArr.length&&$sortArr.length>1;j++){
				$sortArr[j].rect.y=nextPos;
				nextPos=$sortArr[j].rect.y+$sortArr[j].rect.height+(speedPos/($sortArr.length-1))
			}
			this.changeData()
		}

		__proto.onMouseAlign9=function(event){
			this.onMouseAlign8(new MouseEvent(/*iflash.events.MouseEvent.CLICK*/"click"))
			this.onMouseAlign7(new MouseEvent(/*iflash.events.MouseEvent.CLICK*/"click"))
		}

		__proto.onMouseAlign8=function(event){
			var arr=(this.target).selectItem
			if(arr){
				var sh=NaN
				for(var i=0;i<arr.length;i++){
					if(sh){
						sh+=arr[i].rect.height;
						}else{
						sh=arr[i].rect.height;
					}
				}
				for(var j=0;j<arr.length;j++){
					arr[j].rect.height=sh/arr.length
				}
			}
			this.changeData()
		}

		__proto.onMouseAlign7=function(event){
			var arr=(this.target).selectItem
			if(arr){
				var sw=NaN
				for(var i=0;i<arr.length;i++){
					if(sw){
						sw+=arr[i].rect.width;
						}else{
						sw=arr[i].rect.width;
					}
				}
				for(var j=0;j<arr.length;j++){
					arr[j].rect.width=sw/arr.length
				}
			}
			this.changeData()
		}

		__proto.onMouseAlign6=function(event){
			var arr=(this.target).selectItem
			if(arr){
				var maxY=NaN
				for(var i=0;i<arr.length;i++){
					if(maxY){
						maxY=Math.max(maxY,arr[i].rect.y+arr[i].rect.height);
						}else{
						maxY=arr[i].rect.y+arr[i].rect.height;
					}
				}
				for(var j=0;j<arr.length;j++){
					arr[j].rect.y=maxY-arr[j].rect.height;
				}
			}
			this.changeData()
		}

		__proto.onMouseAlign5=function(event){
			var arr=(this.target).selectItem
			if(arr){
				var centenY=NaN
				for(var i=0;i<arr.length;i++){
					if(centenY){
						centenY+=(arr[i].rect.y+arr[i].rect.height/2);
						}else{
						centenY=(arr[i].rect.y+arr[i].rect.height/2)
					}
				}
				for(var j=0;j<arr.length;j++){
					arr[j].rect.y=centenY/arr.length-arr[j].rect.height/2;
				}
			}
			this.changeData()
		}

		__proto.onMouseAlign4=function(event){
			var arr=(this.target).selectItem
			if(arr){
				var miny=NaN
				for(var i=0;i<arr.length;i++){
					if(miny){
						miny=Math.min(miny,arr[i].rect.y);
						}else{
						miny=arr[i].rect.y;
					}
				}
				for(var j=0;j<arr.length;j++){
					arr[j].rect.y=miny;
				}
			}
			this.changeData()
		}

		__proto.onMouseAlign3=function(event){
			var arr=(this.target).selectItem
			if(arr){
				var maxX=NaN
				for(var i=0;i<arr.length;i++){
					if(maxX){
						maxX=Math.max(maxX,arr[i].rect.x+arr[i].rect.width);
						}else{
						maxX=arr[i].rect.x+arr[i].rect.width;
					}
				}
				for(var j=0;j<arr.length;j++){
					arr[j].rect.x=maxX-arr[j].rect.width;
				}
			}
			this.changeData()
		}

		__proto.onMouseAlign2=function(event){
			var arr=(this.target).selectItem
			if(arr){
				var centenX=NaN
				for(var i=0;i<arr.length;i++){
					if(centenX){
						centenX+=(arr[i].rect.x+arr[i].rect.width/2);
						}else{
						centenX=(arr[i].rect.x+arr[i].rect.width/2)
					}
				}
				for(var j=0;j<arr.length;j++){
					arr[j].rect.x=centenX/arr.length-arr[j].rect.width/2;
				}
			}
			this.changeData()
		}

		__proto.onMouseAlign1=function(event){
			var arr=(this.target).selectItem
			if(arr){
				var minx=NaN
				for(var i=0;i<arr.length;i++){
					if(minx){
						minx=Math.min(minx,arr[i].rect.x);
						}else{
						minx=arr[i].rect.x;
					}
				}
				for(var j=0;j<arr.length;j++){
					arr[j].rect.x=minx;
				}
			}
			this.changeData()
		}

		__proto.refreshViewValue=function(){
			if(/*no*/this.target&&/*no*/this.FunKey){
				var dde=/*no*/this.target[/*no*/this.FunKey]
			}
		}

		return AlignRect;
	})(common.utils.frame.BaseComponent)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/ui/nodeiconlabel.as
	//class mesh.ui.NodeIconLabel extends mx.core.UIComponent
	var NodeIconLabel=(function(_super){
		function NodeIconLabel(){
			this._iconBitmap=null;
			this._txtLabel=null;
			this._target=null;
			this._nodeNameTxt=null;
			NodeIconLabel.__super.call(this);
			this._iconBitmap=new Bitmap;
			this._iconBitmap.smoothing=true;
			this._iconBitmap.x=10;
			this.addChild(this._iconBitmap);
			this._txtLabel=new spark.components.Label;
			this._txtLabel.setStyle("color",0x9f9f9f);
			this._txtLabel.setStyle("paddingTop",4);
			this._txtLabel.width=50;
			this._txtLabel.height=20;
			this._txtLabel.x=20;
			this._txtLabel.text="名字";
			this.addChild(this._txtLabel);
			this._nodeNameTxt=new spark.components.TextInput;
			this._nodeNameTxt.setStyle("contentBackgroundColor",0x404040);
			this._nodeNameTxt.setStyle("borderVisible",true);
			this._nodeNameTxt.setStyle("fontSize",11);
			this._nodeNameTxt.setStyle("fontFamily","Microsoft Yahei");
			this._nodeNameTxt.setStyle("color",0x9c9c9c);
			this._nodeNameTxt.x=50
			this._nodeNameTxt.width=130
			this._nodeNameTxt.height=22
			this.addChild(this._nodeNameTxt);
			this._nodeNameTxt.addEventListener(mx.events.FlexEvent.ENTER,__bind(this,this.onSureTxt));
		}

		__class(NodeIconLabel,'mesh.ui.NodeIconLabel',true);
		var __proto=NodeIconLabel.prototype;
		__proto.onSureTxt=function(event){
			var newStr=this._nodeNameTxt.text
			this.stage.focus=this;
			if(this._target|| this._target){
				(this._target).h5UIFileNode.name=newStr;
				com.zcp.frame.event.ModuleEventManager.dispatchEvent(new UiSceneEvent(/*mvc.scene.UiSceneEvent.REFRESH_SCENE_DATA*/"REFRESH_SCENE_DATA"));
				}else if(this._target){
				(this._target).panelRectInfoNode.name=newStr;
				com.zcp.frame.event.ModuleEventManager.dispatchEvent(new PanelLeftEvent(/*mvc.left.panelleft.PanelLeftEvent.REFRESH_PANEL_TREE*/"REFRESH_PANEL_TREE"));
				}else if(this._target){
				(this._target).panelRectInfoNode.name=newStr;
				com.zcp.frame.event.ModuleEventManager.dispatchEvent(new PanelLeftEvent(/*mvc.left.panelleft.PanelLeftEvent.REFRESH_PANEL_TREE*/"REFRESH_PANEL_TREE"));
				}else if(this._target){
				(this._target).panelNodeVo.name=newStr;
				com.zcp.frame.event.ModuleEventManager.dispatchEvent(new PanelLeftEvent(/*mvc.left.panelleft.PanelLeftEvent.REFRESH_PANEL_TREE*/"REFRESH_PANEL_TREE"));
			}
		}

		__getset(0,__proto,'label',null,function(value){
			this._nodeNameTxt.text=value;
		});

		__getset(0,__proto,'target',null,function(value){
			this._target=value
		});

		__getset(0,__proto,'icon',null,function(bmp){
			this._iconBitmap.bitmapData=bmp;
			this._iconBitmap.scaleX=36/bmp.width;
			this._iconBitmap.scaleY=36/bmp.height;
		});

		return NodeIconLabel;
	})(mx.core.UIComponent)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/ui/nodeuitreeitemrenderer.as
	//class mesh.ui.NodeUiTreeItemRenderer extends mx.controls.treeClasses.TreeItemRenderer
	var NodeUiTreeItemRenderer=(function(_super){
		function NodeUiTreeItemRenderer(){
			this._labelTxt=null;
			this._iconBmp=null;
			NodeUiTreeItemRenderer.__super.call(this);
			this.height=50
			this._iconBmp=new common.utils.ui.prefab.PicBut
			this._iconBmp.x=10
			this.addChild(this._iconBmp)
			this._labelTxt=new spark.components.Label
			this.addChild(this._labelTxt)
			this._labelTxt.x=70
			this._labelTxt.y=20
			this._labelTxt.width=150;
			this._labelTxt.height=20;
			this.addEvents();
		}

		__class(NodeUiTreeItemRenderer,'mesh.ui.NodeUiTreeItemRenderer',true);
		var __proto=NodeUiTreeItemRenderer.prototype;
		__proto.addEvents=function(){
			this.addEventListener(mx.events.FlexEvent.DATA_CHANGE,__bind(this,this.dataChange))
		}

		__proto.dataChange=function(event){
			var $selfNode=this.data;
			if($selfNode){
				var bmp=UiData.getUIBitmapDataByName($selfNode.name)
				if(bmp){
					this._iconBmp.setBitmapdata(bmp,48,48)
				}
				this._labelTxt.text=$selfNode.name
			}
		}

		return NodeUiTreeItemRenderer;
	})(mx.controls.treeClasses.TreeItemRenderer)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/ui/panelpictureui.as
	//class mesh.ui.PanelPictureUI extends common.utils.frame.BaseComponent
	var PanelPictureUI=(function(_super){
		function PanelPictureUI(){
			this._iconBmp=null;
			this._labelTxt=null;
			this._titleLabel=null;
			this._donotDubleClik
			this._win
			PanelPictureUI.__super.call(this);
			this.baseWidth=45;
			this._iconBmp=new common.utils.ui.prefab.PicBut
			this.addChild(this._iconBmp)
			this._iconBmp.setBitmapdata(modules.brower.fileWin.BrowerManage.getIcon("meinv"),64,64)
			this._iconBmp.y=0
			this._iconBmp.x=/*no*/this.baseWidth+5;
			this._iconBmp.buttonMode=true
			this._iconBmp.filters=[this.getBitmapFilter()]
			this._labelTxt=new mx.controls.Label
			this._labelTxt.setStyle("color",0x9f9f9f);
			this._labelTxt.setStyle("paddingTop",4);
			this._labelTxt.y=65
			this._labelTxt.x=/*no*/this.baseWidth+5;
			this.addChild(this._labelTxt)
			this._titleLabel=new mx.controls.Label
			this._titleLabel.setStyle("color",0x9f9f9f);
			this._titleLabel.setStyle("paddingTop",4);
			this._titleLabel.setStyle("textAlign","right");
			this._titleLabel.width=/*no*/this.baseWidth;
			this._titleLabel.x=0
			this._titleLabel.y=5
			this._titleLabel.text="预览 :"
			this.addChild(this._titleLabel)
			this.height=90
			this.isDefault=false
			this.addEvents();
		}

		__class(PanelPictureUI,'mesh.ui.PanelPictureUI',true);
		var __proto=PanelPictureUI.prototype;
		__proto.resetPos=function(){
			this._iconBmp.x=/*no*/this.baseWidth+5;
			this._labelTxt.x=/*no*/this.baseWidth+5;
		}

		__proto.getBitmapFilter=function(){
			var color=0x000000;
			var angle=45;
			var alpha=0.8;
			var blurX=8;
			var blurY=8;
			var distance=5;
			var strength=0.65;
			var inner=false;
			var knockout=false;
			var quality=/*iflash.filters.BitmapFilterQuality.HIGH*/3;
			return new DropShadowFilter(distance,
			angle,
			color,
			alpha,
			blurX,
			blurY,
			strength,
			quality,
			inner,
			knockout);
		}

		__proto.addEvents=function(){
			this._iconBmp.addEventListener(/*iflash.events.MouseEvent.CLICK*/"click",__bind(this,this.onDubleClik))
		}

		__proto.onDubleClik=function(event){
			if(this._donotDubleClik==1){
				return
			}
			this.openDisChooseFile();
		}

		__proto.openDisChooseFile=function(){
			this.addPreFabMovePanel("ccav")
		}

		__proto.addPreFabMovePanel=function($typeStr){
			if(this._win){
				this._win.close()
			};
			var $preFabMovePanel=new UiItemPanel;
			var $win=new spark.components.Window;
			$win.transparent=false;
			$win.type=iflash.display.NativeWindowType.UTILITY;
			$win.systemChrome=iflash.display.NativeWindowSystemChrome.STANDARD;
			$win.width=500;
			$win.height=400;
			$win.alwaysInFront=true
			$win.resizable=false
			$win.showStatusBar=false;
			$preFabMovePanel.setStyle("left",0);
			$preFabMovePanel.setStyle("right",0);
			$preFabMovePanel.setStyle("top",0);
			$preFabMovePanel.setStyle("bottom",0);
			$preFabMovePanel.bFun=this.winBackFun
			$win.addElement($preFabMovePanel);
			$win.addEventListener(mx.events.AIREvent.WINDOW_COMPLETE,__bind(this,this.showWinPanel))
			$win.open(true);
			this._win=$win
			this._win.visible=false
		}

		__proto.winBackFun=function($str){
			if(this._win){
				this._win.close()
			}
			/*no*/this.target[/*no*/this.FunKey]=$str
		}

		__proto.showWinPanel=function(event){
			spark.components.Window(event.target).nativeWindow.x=_me.Scene_data.stage.nativeWindow.x+_me.Scene_data.stage.stageWidth/2-spark.components.Window(event.target).nativeWindow.width/2;
			spark.components.Window(event.target).nativeWindow.y=_me.Scene_data.stage.nativeWindow.y+_me.Scene_data.stage.stageHeight/2-spark.components.Window(event.target).nativeWindow.height/2;
			this._win.visible=true
		}

		__proto.refreshViewValue=function(){
			if(/*no*/this.target&&/*no*/this.FunKey){
				var nodeName=/*no*/this.target[/*no*/this.FunKey];
				var bmp=UiData.getUIBitmapDataByName(nodeName)
				if(bmp){
					this._iconBmp.setBitmapdata(bmp,64,64)
					this._labelTxt.text=nodeName
					}else{
					this._labelTxt.text=""
					this._iconBmp.setBitmapdata(modules.brower.fileWin.BrowerManage.getIcon("meinv"),64,64)
				}
			}
		}

		__getset(0,__proto,'donotDubleClik',null,function(value){
			this._donotDubleClik=value;
			if(this._donotDubleClik!=1){
				this._iconBmp.doubleClickEnabled=true;
			}
		});

		__getset(0,__proto,'titleLabel',null,function(value){
			this._titleLabel.text=value;
			if(this._titleLabel.measureText(value).width > /*no*/this.baseWidth){
				this._titleLabel.width=this._labelTxt.measureText(value).width+5;
				/*no*/this.baseWidth=this._titleLabel.width;
				this.resetPos();
			}
		});

		return PanelPictureUI;
	})(common.utils.frame.BaseComponent)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/ui/uiitempanel.as
	//class mesh.ui.UiItemPanel extends common.utils.frame.BasePanel
	var UiItemPanel=(function(_super){
		function UiItemPanel(){
			this.bFun=null;
			this._bg=null;
			this._shape=null;
			this._tree=null;
			UiItemPanel.__super.call(this);
			this.setStyle("borderColor",0x151515);
			this.setStyle("borderStyle","solid");
			this.setStyle("borderVisible",true);
			this.horizontalScrollPolicy="off";
			this.addBack()
			this.addList();
			this.addDataGrid()
			this.addEvents()
			this.resetInfoArr()
		}

		__class(UiItemPanel,'mesh.ui.UiItemPanel',true);
		var __proto=UiItemPanel.prototype;
		__proto.addDataGrid=function(){}
		__proto.addList=function(){
			this._tree=new mx.controls.Tree;
			this._tree.setStyle("top",0);
			this._tree.setStyle("bottom",0);
			this._tree.setStyle("left",0);
			this._tree.setStyle("right",0);
			this._tree.setStyle("contentBackgroundColor",0x505050);
			this._tree.setStyle("color",0x9f9f9f);
			this._tree.labelField="name";
			this._tree.itemRenderer=new mx.core.ClassFactory(NodeUiTreeItemRenderer);
			this._tree.focusEnabled=false;
			this._tree.iconFunction=this.tree_iconFunc;
			this.addChild(this._tree);
			this._tree.addEventListener(mx.events.ListEvent.ITEM_CLICK,__bind(this,this.onItemClik));
		}

		__proto.tree_iconFunc=function(item){
			return null;
		}

		__proto.onItemClik=function(event){
			if(event.itemRenderer){
				var $H5UIFileNode=event.itemRenderer.data;
				this.bFun($H5UIFileNode.name)
			}
		}

		__proto.resetInfoArr=function(){
			this._tree.dataProvider=UiData.nodeItem;
			this._tree.invalidateList();
			this._tree.validateNow();
		}

		__proto.addEvents=function(){
			this.addEventListener(mx.events.FlexEvent.CREATION_COMPLETE,__bind(this,this.onStage));
			this.addEventListener(mx.events.ResizeEvent.RESIZE,__bind(this,this.onStage));
		}

		__proto.addBack=function(){
			this._bg=new mx.core.UIComponent;
			this.addChild(this._bg);
			this._shape=new mx.core.UIComponent;
			this.addChild(this._shape);
		}

		__proto.onStage=function(event){
			this.drawback();
		}

		__proto.drawback=function(){
			this._shape.graphics.clear();
			this._shape.graphics.beginFill(0x303030,1);
			this._shape.graphics.lineStyle(1,0x151515);
			this._shape.graphics.drawRect(0,0,this.width,20);
			this._shape.graphics.endFill();
			this._bg.graphics.clear();
			this._bg.graphics.beginFill(0x404040,1);
			this._bg.graphics.drawRect(0,0,this.width,this.height);
			this._bg.graphics.endFill();
		}

		return UiItemPanel;
	})(common.utils.frame.BasePanel)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/centen/discenten/bmplevel.as
	//class mvc.centen.discenten.BmpLevel extends mx.core.UIComponent
	var BmpLevel=(function(_super){
		function BmpLevel(){
			this._alphaMc=null;
			this._picBmp=null;
			this._sceneColorMc=null;
			this.num10=12
			BmpLevel.__super.call(this);
			this._alphaMc=new Sprite;
			this.addChild(this._alphaMc)
			this._sceneColorMc=new Sprite;
			this.addChild(this._sceneColorMc);
			this._picBmp=new Bitmap;
			this.addChild(this._picBmp)
		}

		__class(BmpLevel,'mvc.centen.discenten.BmpLevel',true);
		var __proto=BmpLevel.prototype;
		__proto.setBmpItem=function(arr){
			this.clearDele(arr)
			if(arr&&arr.length){
				var $FileDataVo=arr[0];
				this._picBmp.bitmapData=$FileDataVo.bmp;
				UiData.bitMapData=this._picBmp.bitmapData;
			}
			this.drawColorSprite()
		}

		__proto.drawColorSprite=function(){
			var rect=UiData.sceneBmpRec;
			var sw=Math.ceil(rect.width/this.num10);
			var sh=Math.ceil(rect.height/this.num10);
			this.width=rect.width
			this.height=rect.height
			this._alphaMc.graphics.clear()
			for(var i=0;i<sw;i++){
				for(var j=0;j<sh;j++){
					this._alphaMc.graphics.beginFill((j%2+i)%2==0?0xffffff:0xaaaaaa,1)
					var kkw=this.num10;
					var kkh=this.num10
					if((rect.width-i*this.num10)<this.num10){
						kkw=rect.width-i*this.num10
					}
					if((rect.height-j*this.num10)<this.num10){
						kkh=rect.height-j*this.num10
					}
					this._alphaMc.graphics.drawRect(i*this.num10,j*this.num10,kkw,kkh)
					this._alphaMc.graphics.endFill();
				}
			};
			var colorUint=_Pan3D.core.MathCore.hexToArgb(UiData.sceneColor);
			colorUint.scaleBy(1/255)
			var colorVec=_Pan3D.core.MathCore.vecToHex(colorUint,false);
			this._sceneColorMc.graphics.clear();
			this._sceneColorMc.graphics.beginFill(colorVec,colorUint.w/255)
			this._sceneColorMc.graphics.drawRect(0,0,this._alphaMc.width,this._alphaMc.height);
			this._sceneColorMc.graphics.endFill()
		}

		__proto.clearDele=function(arr){
			this._picBmp.bitmapData=null;
			this._alphaMc.graphics.clear();
		}

		return BmpLevel;
	})(mx.core.UIComponent)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/centen/discenten/discentenevent.as
	//class mvc.centen.discenten.DisCentenEvent extends com.zcp.frame.event.ModuleEvent
	var DisCentenEvent=(function(_super){
		function DisCentenEvent($action){
			this.h5UIFileNode=null;
			this.saveH5UIchangeFile
			DisCentenEvent.__super.call(this,$action);
		}

		__class(DisCentenEvent,'mvc.centen.discenten.DisCentenEvent',true);
		DisCentenEvent.SHOW_CENTEN="SHOWCENTEN";
		DisCentenEvent.READ_UIFILE_DATA="READUIFILEDATA";
		DisCentenEvent.REFRESH_SELECT_FILENODE="REFRESH_SELECT_FILENODE";
		DisCentenEvent.DELE_NODE_INFO_VO="DELE_NODE_INFO_VO";
		DisCentenEvent.DELE_SELECT_NODE="DELE_SELECT_NODE";
		DisCentenEvent.SAVE_H5UI_PROJECT_FILE="SAVE_H5UI_PROJECT_FILE";
		return DisCentenEvent;
	})(com.zcp.frame.event.ModuleEvent)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/centen/discenten/discentenmodule.as
	//class mvc.centen.discenten.DisCentenModule extends com.zcp.frame.Module
	var DisCentenModule=(function(_super){
		function DisCentenModule(){
			DisCentenModule.__super.call(this);
		}

		__class(DisCentenModule,'mvc.centen.discenten.DisCentenModule',true);
		var __proto=DisCentenModule.prototype;
		__proto.listProcessors=function(){
			return [
			new DisCentenProcessor(this),]
		}

		return DisCentenModule;
	})(com.zcp.frame.Module)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/centen/discenten/discentenpanel.as
	//class mvc.centen.discenten.DisCentenPanel extends common.utils.frame.BasePanel
	var DisCentenPanel=(function(_super){
		function DisCentenPanel(){
			this._bmpLevel=null;
			this._InfoLevel=null;
			this._sizeTxt=null;
			this._scaleNum=1;
			this.lastMousePos=null;
			this._middleDown=false
			this._selectLineSprite
			this._beginLinePoin
			this.lastDisPos
			DisCentenPanel.__super.call(this);
			this.horizontalScrollPolicy="off";
			this.addBmpLevel();
			this.addInfoLevel();
			this.addLabel();
			this.addLineSprite()
			this.addEventListener(/*iflash.events.Event.ADDED_TO_STAGE*/"addedToStage",__bind(this,this.onAddToStage))
		}

		__class(DisCentenPanel,'mvc.centen.discenten.DisCentenPanel',true);
		var __proto=DisCentenPanel.prototype;
		__proto.addLineSprite=function(){
			this._selectLineSprite=new mx.core.UIComponent;
			this.addChild(this._selectLineSprite)
		}

		__proto.beginDrawLine=function(){
			this._beginLinePoin=new Point(this.mouseX,this.mouseY)
		}

		__proto.endDrawLine=function(){
			this._selectLineSprite.graphics.clear();
			this._beginLinePoin=null;
		}

		__proto.drawSelectLine=function(){
			if(this._beginLinePoin){
				var a=this._beginLinePoin;
				var b=new Point(this.mouseX,this.mouseY)
				this._selectLineSprite.graphics.clear();
				this._selectLineSprite.graphics.lineStyle(1,0xff0000,1)
				this._selectLineSprite.graphics.moveTo(a.x,a.y)
				this._selectLineSprite.graphics.lineTo(a.x,b.y)
				this._selectLineSprite.graphics.lineTo(b.x,b.y)
				this._selectLineSprite.graphics.lineTo(b.x,a.y)
				this._selectLineSprite.graphics.lineTo(a.x,a.y)
			}
		}

		__proto.addLabel=function(){
			this._sizeTxt=new mx.controls.Label
			this._sizeTxt.width=80
			this._sizeTxt.height=20
			this.addChild(this._sizeTxt)
			this._sizeTxt.text="比例:100%"
		}

		__proto.onPanelClik=function(event){}
		__proto.onAddToStage=function(event){
			UiData.editMode=0
		}

		__proto.onSize=function(event){
			this._sizeTxt.x=this.width-81
		}

		__proto.addBmpLevel=function(){
			this._bmpLevel=new BmpLevel()
			this.addChild(this._bmpLevel)
		}

		__proto.addInfoLevel=function(){
			this._InfoLevel=new InfoLevel();
			this.addChild(this._InfoLevel)
		}

		__proto.resetInfoArr=function(){
			this._InfoLevel.clearLevel();
			this._InfoLevel.setInfoItem(UiData.nodeItem)
			this._bmpLevel.setBmpItem(UiData.bmpitem)
		}

		__proto.changeSceneColor=function(){
			this._bmpLevel.drawColorSprite()
		}

		__proto.mouseMove=function(){
			if(this._middleDown){
				var nowMouse=new Point(this.mouseX,this.mouseY)
				this._bmpLevel.x=this.lastDisPos.x+(nowMouse.x-this.lastMousePos.x);
				this._bmpLevel.y=this.lastDisPos.y+(nowMouse.y-this.lastMousePos.y);
				this._InfoLevel.x=this._bmpLevel.x;
				this._InfoLevel.y=this._bmpLevel.y;
			}
		}

		__proto.getBmpPostion=function(){
			return new Point(this._bmpLevel.x,this._bmpLevel.y)
		}

		__proto.KeyAdd=function(){
			this._scaleNum=this._scaleNum*1.1
			if(Math.abs(1-this._scaleNum)<0.05){
				this._scaleNum=1
			}
			this._bmpLevel.scaleX=this._scaleNum;
			this._bmpLevel.scaleY=this._scaleNum;
			this._InfoLevel.scaleX=this._scaleNum;
			this._InfoLevel.scaleY=this._scaleNum;
			this._sizeTxt.text="比例:"+String(int(this._scaleNum*100))+"%"
		}

		__proto.KeySub=function(){
			this._scaleNum=this._scaleNum*0.9
			if(Math.abs(1-this._scaleNum)<0.05){
				this._scaleNum=1
			}
			this._bmpLevel.scaleX=this._scaleNum;
			this._bmpLevel.scaleY=this._scaleNum;
			this._InfoLevel.scaleX=this._scaleNum;
			this._InfoLevel.scaleY=this._scaleNum;
			this._sizeTxt.text="比例:"+String(int(this._scaleNum*100))+"%"
		}

		__getset(0,__proto,'beginLinePoin',function(){
			return this._beginLinePoin;
		});

		__getset(0,__proto,'middleDown',null,function(value){
			this._middleDown=value;
			if(this._middleDown){
				this.lastMousePos=new Point(this.mouseX,this.mouseY)
				this.lastDisPos=new Point(this._bmpLevel.x,this._bmpLevel.y)
			}
		});

		__getset(0,__proto,'bmpLevel',function(){
			return this._bmpLevel;
		});

		__getset(0,__proto,'scaleNum',function(){
			return this._scaleNum;
		});

		return DisCentenPanel;
	})(common.utils.frame.BasePanel)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/centen/discenten/discentenprocessor.as
	//class mvc.centen.discenten.DisCentenProcessor extends com.zcp.frame.Processor
	var DisCentenProcessor=(function(_super){
		function DisCentenProcessor($module){
			this._centenPanel=null;
			this._startSelectNodeInfo=false;
			this._selcetNodeLastMouse=null;
			this._menuFile=null;
			this.willDeleItem
			this._so
			DisCentenProcessor.__super.call(this,$module);
			this.initData()
		}

		__class(DisCentenProcessor,'mvc.centen.discenten.DisCentenProcessor',true);
		var __proto=DisCentenProcessor.prototype;
		__proto.listenModuleEvents=function(){
			return [
			DisCentenEvent,
			common.msg.event.engineConfig.MEventStageResize,
			ProjectEvent,
			UiSceneEvent,]
		}

		__proto.receivedModuleEvent=function($me){
			switch($me.getClass()){
				case DisCentenEvent:
					if($me.action==/*mvc.centen.discenten.DisCentenEvent.SHOW_CENTEN*/"SHOWCENTEN"){
						this.showHide()
					}
					if($me.action==/*mvc.centen.discenten.DisCentenEvent.DELE_NODE_INFO_VO*/"DELE_NODE_INFO_VO"){
						this.deleNodeInof(($me))
					}
					if($me.action==/*mvc.centen.discenten.DisCentenEvent.DELE_SELECT_NODE*/"DELE_SELECT_NODE"){
						this.delSeLect()
					}
					if($me.action==/*mvc.centen.discenten.DisCentenEvent.SAVE_H5UI_PROJECT_FILE*/"SAVE_H5UI_PROJECT_FILE"){
						this.saveFile(($me).saveH5UIchangeFile)
					}
					break ;
				case UiSceneEvent:
					if($me.action==/*mvc.scene.UiSceneEvent.REFRESH_SCENE_DATA*/"REFRESH_SCENE_DATA"){
						this.refreshSceneData()
					}
					if($me.action==/*mvc.scene.UiSceneEvent.START_MOVE_NODE_INFO*/"START_MOVE_NODE_INFO"){
						this.startMoveNodeInfo()
					}
					if($me.action==/*mvc.scene.UiSceneEvent.CHANGE_SCENE_COLOR*/"CHANGE_SCENE_COLOR"){
						this.changeSceneColor()
					}
					if($me.action==/*mvc.scene.UiSceneEvent.SELECT_INFO_NODE*/"SELECT_INFO_NODE"){
						this.selectInfoNode(($me))
					}
					if($me.action==/*mvc.scene.UiSceneEvent.REFRESH_SCENE_BITMAPDATA*/"REFRESH_SCENE_BITMAPDATA"){
						this.refreshSceneBitmapData(($me))
					}
					break ;
				case common.msg.event.engineConfig.MEventStageResize:
					this.resize($me)
					break ;
				}
		}

		__proto.refreshSceneBitmapData=function($UiSceneEvent){
			if(UiData.bigBitmapUrl){
				this.pushBaseBmpurl(UiData.bigBitmapUrl)
				}else{
				mx.controls.Alert.show("先拖入编辑图片")
			}
		}

		__proto.selectInfoNode=function($UiSceneEvent){
			if(UiData.editMode!=0){
				this.showHide()
			}
		}

		__proto.deleNodeInof=function($centenEvent){
			this.deleH5UIFileNode($centenEvent.h5UIFileNode)
		}

		__proto.deleH5UIFileNode=function($delNode){
			for(var i=0;i<UiData.nodeItem.length;i++){
				if(UiData.nodeItem[i]==$delNode){
					UiData.nodeItem.removeItemAt(i)
				}
			}
			com.zcp.frame.event.ModuleEventManager.dispatchEvent(new UiSceneEvent(/*mvc.scene.UiSceneEvent.REFRESH_SCENE_DATA*/"REFRESH_SCENE_DATA"));
		}

		__proto.changeSceneColor=function(){
			this._centenPanel.changeSceneColor()
		}

		__proto.initData=function(){
			_me.Scene_data.stage.addEventListener(/*iflash.events.MouseEvent.MIDDLE_MOUSE_UP*/"middleMouseUp",__bind(this,this.onMiddleUp))
			_me.Scene_data.stage.addEventListener(/*iflash.events.MouseEvent.MOUSE_UP*/"mouseUp",__bind(this,this.onStageMouseUP))
			_me.Scene_data.stage.addEventListener(/*iflash.events.MouseEvent.MOUSE_MOVE*/"mouseMove",__bind(this,this.onMouseMove))
			_me.Scene_data.stage.addEventListener(/*iflash.events.MouseEvent.MOUSE_DOWN*/"mouseDown",__bind(this,this.onMouseDown))
			_me.Scene_data.stage.addEventListener(/*iflash.events.MouseEvent.MIDDLE_MOUSE_DOWN*/"middleMouseDown",__bind(this,this.onMiddleDown))
			_me.Scene_data.stage.addEventListener(/*iflash.events.MouseEvent.MOUSE_WHEEL*/"mouseWheel",__bind(this,this.onMouseWheel));
			_me.Scene_data.stage.addEventListener(/*iflash.events.MouseEvent.RIGHT_CLICK*/"rightClick",__bind(this,this.onRightClick));
			_me.Scene_data.stage.addEventListener(/*iflash.events.MouseEvent.CLICK*/"click",__bind(this,this.onStageClik));
			_me.Scene_data.stage.addEventListener(/*iflash.events.KeyboardEvent.KEY_DOWN*/"keyDown",__bind(this,this.onStageKeyDown));
			this.initMenuFile()
			this.readyReceiveThing()
		}

		__proto.onMouseDown=function(event){
			if(!this.isCanDo){
				return;
			}
			if(event.target){
				if((event.target).parent){
					return;
				}
			}
			if(this.testInCentenPanel){
				this._centenPanel.beginDrawLine()
			}
		}

		__proto.onStageClik=function(event){
			if(!this.isCanDo){
				return;
			}
			if(Boolean(event.target)){
				com.zcp.frame.event.ModuleEventManager.dispatchEvent(new UiSceneEvent(/*mvc.scene.UiSceneEvent.SHOW_UI_SCENE*/"SHOW_UI_SCENE"));
			}
		}

		__proto.readyReceiveThing=function(){
			_me.Scene_data.stage.addEventListener(iflash.events.NativeDragEvent.NATIVE_DRAG_ENTER,__bind(this,this.dragEnterHandler));
			_me.Scene_data.stage.addEventListener(iflash.events.NativeDragEvent.NATIVE_DRAG_DROP,__bind(this,this.dragDropHandler));
			_me.Scene_data.stage.addEventListener(iflash.events.NativeDragEvent.NATIVE_DRAG_EXIT,__bind(this,this.dragExitHandler));
		}

		__proto.dragExitHandler=function(e){}
		__proto.dragEnterHandler=function(e){
			var clipBoard=e.clipboard;
			if(clipBoard.hasFormat(iflash.desktop.ClipboardFormats.BITMAP_FORMAT)||
				clipBoard.hasFormat(iflash.desktop.ClipboardFormats.FILE_LIST_FORMAT)){
				iflash.desktop.NativeDragManager.acceptDragDrop(_me.Scene_data.stage);
			}
		}

		__proto.dragDropHandler=function(event){
			var _reBitmapdata=event.clipboard.getData(iflash.desktop.ClipboardFormats.BITMAP_FORMAT);
			var arr=event.clipboard.getData(iflash.desktop.ClipboardFormats.FILE_LIST_FORMAT)
			var $file;
			/*for each*/for(var $each_$file in arr){
				$file=arr[$each_$file];
				if($file.isDirectory){
					}else{
					this.sendFile($file)
				}
			}
		}

		__proto.sendFile=function($file){
			if($file.extension=="jpg"||$file.extension=="png"){
				this.pushBaseBmpurl($file.url)
			}
			if($file.extension=="h5ui"){
				var $CentenEvent=new ProjectEvent(/*mvc.project.ProjectEvent.OPEN_PROJECT_FILE*/"OPEN_PROJECT_FILE")
				$CentenEvent.url=$file.url
				com.zcp.frame.event.ModuleEventManager.dispatchEvent($CentenEvent);
			}
		}

		__proto.pushBaseBmpurl=function(url){
			var loaderinfo=new _Pan3D.load.LoadInfo(url,_Pan3D.load.LoadInfo.BITMAP,onImgLoad=function($bitmap){
				UiData.bigBitmapUrl=url;
				var $FileDataVo=new FileDataVo;
				$FileDataVo.url=url;
				$FileDataVo.bmp=$bitmap.bitmapData;
				UiData.bmpitem.length=0
				$FileDataVo.rect=new Rectangle(0,0,$FileDataVo.bmp.width,$FileDataVo.bmp.height);
				UiData.bmpitem.push($FileDataVo)
				UiData.sceneBmpRec=$FileDataVo.rect.clone();
				com.zcp.frame.event.ModuleEventManager.dispatchEvent(new UiSceneEvent(/*mvc.scene.UiSceneEvent.REFRESH_SCENE_DATA*/"REFRESH_SCENE_DATA"));
			},0);
			_Pan3D.load.LoadManager.getInstance().addSingleLoad(loaderinfo);
		}

		__proto.onStageKeyDown=function(event){
			var _$this=this;
			if(!this.isCanDo){
				return
			}
			if(!Boolean(Laya.__typeof(event.target,spark.components.RichEditableText))){
				if(event.ctrlKey&&event.keyCode==/*iflash.ui.Keyboard.S*/83){
					return;
					mx.controls.Alert.show("是否确定要保存","保存",3,this._centenPanel,function(event){
						if(event.detail==mx.controls.Alert.YES){
							_$this.saveFile(false)
						}
					});
				}
				if(event.keyCode==/*iflash.ui.Keyboard.DELETE*/46){
					this.delSeLect()
				}
				if(event.ctrlKey){
					if(event.keyCode==/*iflash.ui.Keyboard.C*/67){
						UiData.makeCopy();
					}
					if(event.keyCode==/*iflash.ui.Keyboard.V*/86){
						UiData.paste();
					}
					if(event.keyCode==/*iflash.ui.Keyboard.Z*/90){
						HistoryModel.getInstance().cancelScene()
					}
					if(event.keyCode==/*iflash.ui.Keyboard.Y*/89){
						HistoryModel.getInstance().nextScene()
					}
					}else{
					if(event.keyCode==/*iflash.ui.Keyboard.UP*/38){
						this.tureSelecMove(0,-1)
					}
					if(event.keyCode==/*iflash.ui.Keyboard.DOWN*/40){
						this.tureSelecMove(0,+1)
					}
					if(event.keyCode==/*iflash.ui.Keyboard.LEFT*/37){
						this.tureSelecMove(-1,0)
					}
					if(event.keyCode==/*iflash.ui.Keyboard.RIGHT*/39){
						this.tureSelecMove(+1,0)
					}
				}
			}
		}

		__proto.tureSelecMove=function($tx,$ty){
			for(var i=0;UiData.selectArr&&i<UiData.selectArr.length;i++){
				UiData.selectArr[i].rect.x+=$tx
				UiData.selectArr[i].rect.y+=$ty
				UiData.selectArr[i].sprite.updata()
			}
			com.zcp.frame.event.ModuleEventManager.dispatchEvent(new DisCentenEvent(/*mvc.centen.discenten.DisCentenEvent.REFRESH_SELECT_FILENODE*/"REFRESH_SELECT_FILENODE"));
		}

		__proto.delSeLect=function(){
			if(UiData.selectArr&&UiData.selectArr.length){
				this.willDeleItem=new Array
				for(var i=0;i<UiData.selectArr.length;i++){
					this.willDeleItem.push(UiData.selectArr[i])
				}
				mx.controls.Alert.show("是否确定删除？","删除",3,this._centenPanel,__bind(this,this.deleteCallBack));
			}
		}

		__proto.deleteCallBack=function(event){
			if(event.detail==mx.controls.Alert.YES){
				for(var i=0;i<this.willDeleItem.length;i++){
					this.deleH5UIFileNode(this.willDeleItem[i])
				}
				UiData.selectArr=new Array
			}
		}

		__proto.saveFile=function($changeUrl){
			var _$this=this;
			if(UiData.isNewH5UI){
				$changeUrl=true;
			}
			if($changeUrl){
				var file=new File;
				file.browseForSave("保存文件");
				file.addEventListener(/*iflash.events.Event.SELECT*/"select",onSelect);
				function onSelect (e){
					var saveFiled=e.target;
					var fileName=saveFiled.name.replace("."+saveFiled.extension,"")
					_$this.saveWorkScene(saveFiled.parent.nativePath,fileName)
				}
				}else{
				this._so=UiData.getSharedObject()
				if(this._so.data.url){
					var $fristFile=new File(this._so.data.url)
					var $fristNmae=$fristFile.name.replace("."+$fristFile.extension,"")
					this.saveWorkScene($fristFile.parent.nativePath,$fristNmae)
				}
			}
		}

		__proto.saveWorkScene=function(dicurl,filename){
			var $file=new File(dicurl+"/"+filename+".h5ui")
			this._so=UiData.getSharedObject()
			this._so.data.url=$file.url;
			var $fs=new FileStream;
			$fs.open($file,/*iflash.filesystem.FileMode.WRITE*/"write");
			var a=new Object;
			a.FileBmpItem=UiData.getFileBmpItem()
			a.InfoRectItem=UiData.getInfoRectItem()
			a.sceneBmpRec=UiData.sceneBmpRec;
			a.sceneColor=UiData.sceneColor;
			a.panelItem=PanelModel.getInstance().getPanelNodeItemToSave()
			$fs.writeObject(a);
			$fs.close();
			mx.controls.Alert.show("保存完毕")
			UiData.isNewH5UI=false
		}

		__proto.onRightClick=function(event){
			if(!this.isCanDo){
				return
			}
			if(this.testInCentenPanel){
				this._menuFile.display(_me.Scene_data.stage,_me.Scene_data.stage.mouseX,_me.Scene_data.stage.mouseY);
			}
		}

		__proto.initMenuFile=function(){
			this._menuFile=new NativeMenu;
			var newtypefile=new NativeMenu;
			var item;
			item=new NativeMenuItem("添加对象")
			this._menuFile.addItem(item);
			item.addEventListener(/*iflash.events.Event.SELECT*/"select",__bind(this,this.addNewInfoNode));
			item=new NativeMenuItem("添加9宫格")
			this._menuFile.addItem(item);
			item.addEventListener(/*iflash.events.Event.SELECT*/"select",__bind(this,this.add9InfoNode));
		}

		__proto.add9InfoNode=function(event){
			var $H5UIFileNode=new H5UIFileNode
			$H5UIFileNode.type=/*vo.FileInfoType.ui9*/1
			$H5UIFileNode.name="NewName";
			$H5UIFileNode.rect=new Rectangle((this._centenPanel.mouseX-this._centenPanel.bmpLevel.x)*(1/this._centenPanel.scaleNum)-10,(this._centenPanel.mouseY-this._centenPanel.bmpLevel.y)*(1/this._centenPanel.scaleNum)-10,100,80)
			$H5UIFileNode.rect9=new Rectangle(0,0,10,10)
			UiData.nodeItem.addItem($H5UIFileNode)
			com.zcp.frame.event.ModuleEventManager.dispatchEvent(new UiSceneEvent(/*mvc.scene.UiSceneEvent.REFRESH_SCENE_DATA*/"REFRESH_SCENE_DATA"));
		}

		__proto.addNewInfoNode=function(event){
			var $H5UIFileNode=new H5UIFileNode
			$H5UIFileNode.name="NewName";
			$H5UIFileNode.type=/*vo.FileInfoType.baseUi*/0
			$H5UIFileNode.rect=new Rectangle((this._centenPanel.mouseX-this._centenPanel.bmpLevel.x)*(1/this._centenPanel.scaleNum)-10,(this._centenPanel.mouseY-this._centenPanel.bmpLevel.y)*(1/this._centenPanel.scaleNum)-10,100,80)
			UiData.nodeItem.addItem($H5UIFileNode)
			com.zcp.frame.event.ModuleEventManager.dispatchEvent(new UiSceneEvent(/*mvc.scene.UiSceneEvent.REFRESH_SCENE_DATA*/"REFRESH_SCENE_DATA"));
		}

		__proto.startMoveNodeInfo=function(){
			this._selcetNodeLastMouse=new Point(_me.Scene_data.stage.mouseX,_me.Scene_data.stage.mouseY)
			this._startSelectNodeInfo=true
		}

		__proto.onStageMouseUP=function(event){
			if(!this.isCanDo){
				return
			}
			if(this._startSelectNodeInfo){
				for(var i=0;i<UiData.selectArr.length;i++){
					var $h5UIFileNode=UiData.selectArr[i];
					$h5UIFileNode.rect.x=$h5UIFileNode.sprite.x
					$h5UIFileNode.rect.y=$h5UIFileNode.sprite.y
				}
				this._startSelectNodeInfo=false;
				com.zcp.frame.event.ModuleEventManager.dispatchEvent(new DisCentenEvent(/*mvc.centen.discenten.DisCentenEvent.REFRESH_SELECT_FILENODE*/"REFRESH_SELECT_FILENODE"));
				HistoryModel.getInstance().saveSeep()
				}else{
				this.findSelectNode(event)
			}
			this._centenPanel.endDrawLine()
		}

		__proto.findSelectNode=function(event){
			if(this._centenPanel.beginLinePoin){
				var $selectNodeArr=new Array;
				var a=this._centenPanel.beginLinePoin;
				var b=new Point(this._centenPanel.mouseX,this._centenPanel.mouseY)
				var $selectRec=new Rectangle();
				var cavanPos=this._centenPanel.getBmpPostion()
				var anum=1/this._centenPanel.scaleNum
				$selectRec.x=(Math.min(a.x,b.x)-cavanPos.x)*anum
				$selectRec.y=(Math.min(a.y,b.y)-cavanPos.y)*anum
				$selectRec.width=Math.abs(a.x-b.x)*anum
				$selectRec.height=Math.abs(a.y-b.y)*anum
				for(var i=0;i<UiData.nodeItem.length;i++){
					var $h5UIFileNode=UiData.nodeItem[i];
					if($selectRec.intersects($h5UIFileNode.rect)||(event.shiftKey&&$h5UIFileNode.select)){
						$selectNodeArr.push($h5UIFileNode)
					}
				}
				UiData.selectArr=$selectNodeArr;
				com.zcp.frame.event.ModuleEventManager.dispatchEvent(new UiSceneEvent(/*mvc.scene.UiSceneEvent.SELECT_INFO_NODE*/"SELECT_INFO_NODE"));
			}
		}

		__proto.onMouseWheel=function(event){
			if(!this.isCanDo){
				return
			}
			if(this.testInCentenPanel){
				if(event.delta>0){
					this._centenPanel.KeyAdd()
					}else{
					this._centenPanel.KeySub()
				}
			}
		}

		__proto.onMiddleDown=function(event){
			if(this.testInCentenPanel){
				this._centenPanel.middleDown=true
			}
		}

		__proto.onMiddleUp=function(event){
			this._centenPanel.middleDown=false
		}

		__proto.onMouseMove=function(event){
			if(!this.isCanDo){
				return
			}
			this._centenPanel.mouseMove()
			if(this._startSelectNodeInfo){
				var addPos=new Point;
				addPos.x=_me.Scene_data.stage.mouseX-this._selcetNodeLastMouse.x
				addPos.y=_me.Scene_data.stage.mouseY-this._selcetNodeLastMouse.y
				for(var i=0;i<UiData.selectArr.length;i++){
					var $h5UIFileNode=UiData.selectArr[i];
					$h5UIFileNode.sprite.x=$h5UIFileNode.rect.x+addPos.x/this._centenPanel.scaleNum
					$h5UIFileNode.sprite.y=$h5UIFileNode.rect.y+addPos.y/this._centenPanel.scaleNum
				}
				}else{
				this._centenPanel.drawSelectLine()
			}
		}

		__proto.resize=function(evt){
			if(this._centenPanel){
				this._centenPanel.onSize()
			}
		}

		__proto.refreshSceneData=function(){
			this._centenPanel.resetInfoArr()
		}

		__proto.showHide=function(){
			if(!this._centenPanel){
				this._centenPanel=new DisCentenPanel;
			}
			this._centenPanel.init(this,"中",1);
			manager.LayerManager.getInstance().addPanel(this._centenPanel);
		}

		__getset(0,__proto,'isCanDo',function(){
			if(UiData.editMode==0){
				return true
				}else{
				return false
			}
		});

		__getset(0,__proto,'testInCentenPanel',function(){
			var pos=this._centenPanel.localToGlobal(new Point);
			var rect=new Rectangle();
			rect.x=pos.x
			rect.y=pos.y
			rect.width=this._centenPanel.width;
			rect.height=this._centenPanel.height;
			var mousePos=new Point(_me.Scene_data.stage.mouseX,_me.Scene_data.stage.mouseY)
			if(mousePos.x>rect.x&&mousePos.y>rect.y&&mousePos.x<(rect.x+rect.width)&&mousePos.y<(rect.y+rect.height)){
				return true
				}else{
				return false
			}
		});

		return DisCentenProcessor;
	})(com.zcp.frame.Processor)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/centen/discenten/infolevel.as
	//class mvc.centen.discenten.InfoLevel extends mx.core.UIComponent
	var InfoLevel=(function(_super){
		function InfoLevel(){
			InfoLevel.__super.call(this);
		}

		__class(InfoLevel,'mvc.centen.discenten.InfoLevel',true);
		var __proto=InfoLevel.prototype;
		__proto.setInfoItem=function(arr){
			console.log("修改了所有")
			for(var i=0;i<arr.length;i++){
				var $H5UIFileNode=arr[i];
				if(!$H5UIFileNode.sprite){
					$H5UIFileNode.sprite=new InfoDataSprite
					$H5UIFileNode.sprite.h5UIFileNode=$H5UIFileNode;
				}
				if(!$H5UIFileNode.sprite.parent){
					this.addChild($H5UIFileNode.sprite)
				}
				$H5UIFileNode.sprite.updata()
			}
		}

		__proto.clearLevel=function(){
			while(this.numChildren){
				this.removeChildAt(0)
			}
		}

		return InfoLevel;
	})(mx.core.UIComponent)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/centen/panelcenten/panelcentenbacksprite.as
	//class mvc.centen.panelcenten.PanelCentenBackSprite extends mx.core.UIComponent
	var PanelCentenBackSprite=(function(_super){
		function PanelCentenBackSprite(){
			this._alphaMc=null;
			this._sceneColorMc=null;
			this.num10=12
			PanelCentenBackSprite.__super.call(this);
			this._alphaMc=new Sprite;
			this.addChild(this._alphaMc)
			this._sceneColorMc=new Sprite;
			this.addChild(this._sceneColorMc);
			this.drawColorSprite()
		}

		__class(PanelCentenBackSprite,'mvc.centen.panelcenten.PanelCentenBackSprite',true);
		var __proto=PanelCentenBackSprite.prototype;
		__proto.drawColorSprite=function($panelNodeVo){
			var rect;
			var colorNum=0
			if(!$panelNodeVo){
				rect=new Rectangle(0,0,512,512)
				}else{
				rect=$panelNodeVo.canverRect.clone();
				colorNum=$panelNodeVo.color;
				console.log($panelNodeVo.color)
			};
			var sw=Math.ceil(rect.width/this.num10);
			var sh=Math.ceil(rect.height/this.num10);
			this.width=rect.width
			this.height=rect.height
			this._alphaMc.graphics.clear()
			for(var i=0;i<sw;i++){
				for(var j=0;j<sh;j++){
					this._alphaMc.graphics.beginFill((j%2+i)%2==0?0xffffff:0xaaaaaa,1)
					var kkw=this.num10;
					var kkh=this.num10
					if((rect.width-i*this.num10)<this.num10){
						kkw=rect.width-i*this.num10
					}
					if((rect.height-j*this.num10)<this.num10){
						kkh=rect.height-j*this.num10
					}
					this._alphaMc.graphics.drawRect(i*this.num10,j*this.num10,kkw,kkh)
					this._alphaMc.graphics.endFill();
				}
			};
			var colorUint=_Pan3D.core.MathCore.hexToArgb(colorNum);
			colorUint.scaleBy(1/255)
			var colorVec=_Pan3D.core.MathCore.vecToHex(colorUint,false);
			this._sceneColorMc.graphics.clear();
			this._sceneColorMc.graphics.beginFill(colorVec,colorUint.w/255)
			this._sceneColorMc.graphics.drawRect(0,0,this._alphaMc.width,this._alphaMc.height);
			this._sceneColorMc.graphics.endFill()
		}

		return PanelCentenBackSprite;
	})(mx.core.UIComponent)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/centen/panelcenten/panelcentenevent.as
	//class mvc.centen.panelcenten.PanelCentenEvent extends com.zcp.frame.event.ModuleEvent
	var PanelCentenEvent=(function(_super){
		function PanelCentenEvent($action){
			this.selectItem=null;
			this.panelRectInfoNode=null;
			this.shiftKey=false;
			this.ctrlKey=false;
			PanelCentenEvent.__super.call(this,$action);
		}

		__class(PanelCentenEvent,'mvc.centen.panelcenten.PanelCentenEvent',true);
		PanelCentenEvent.SHOW_UI_PANNEL="SHOW_UI_PANNEL";
		PanelCentenEvent.SELECT_PANEL_INFO_NODE="SELECT_PANEL_INFO_NODE";
		PanelCentenEvent.PANEL_RECT_INFO_START_MOVE="PANEL_RECT_INFO_START_MOVE";
		PanelCentenEvent.REFRESH_PANEL_RECT_INFO_SIZE_VIEW="REFRESH_PANEL_RECT_INFO_SIZE_VIEW";
		PanelCentenEvent.REFRESH_PANEL_RECT_INFO_SELECT_ITEM="REFRESH_PANEL_RECT_INFO_SELECT_ITEM";
		return PanelCentenEvent;
	})(com.zcp.frame.event.ModuleEvent)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/centen/panelcenten/panelcenteninfolevel.as
	//class mvc.centen.panelcenten.PanelCentenInfoLevel extends mx.core.UIComponent
	var PanelCentenInfoLevel=(function(_super){
		function PanelCentenInfoLevel(){
			this._setItem=null;
			PanelCentenInfoLevel.__super.call(this);
		}

		__class(PanelCentenInfoLevel,'mvc.centen.panelcenten.PanelCentenInfoLevel',true);
		var __proto=PanelCentenInfoLevel.prototype;
		__proto.addPanelRectInfoNode=function($PanelRectInfoNode){
			this.addChild($PanelRectInfoNode.sprite)
			$PanelRectInfoNode.sprite.updata();
		}

		__proto.clearLevel=function(){
			while(this.numChildren){
				this.removeChildAt(0)
			}
		}

		__getset(0,__proto,'setItem',function(){
			return this._setItem;
			},function(value){
			this._setItem=value;
			this.clearLevel();
			for(var i=0;i<this._setItem.length;i++){
				var $PanelRectInfoNode=this._setItem[i]
				$PanelRectInfoNode.select=false
				this.addChild($PanelRectInfoNode.sprite)
				$PanelRectInfoNode.sprite.updata();
			}
		});

		return PanelCentenInfoLevel;
	})(mx.core.UIComponent)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/centen/panelcenten/panelcentenmodule.as
	//class mvc.centen.panelcenten.PanelCentenModule extends com.zcp.frame.Module
	var PanelCentenModule=(function(_super){
		function PanelCentenModule(){
			PanelCentenModule.__super.call(this);
		}

		__class(PanelCentenModule,'mvc.centen.panelcenten.PanelCentenModule',true);
		var __proto=PanelCentenModule.prototype;
		__proto.listProcessors=function(){
			return [
			new PanelCentenProcessor(this),]
		}

		return PanelCentenModule;
	})(com.zcp.frame.Module)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/centen/panelcenten/panelcentenprocessor.as
	//class mvc.centen.panelcenten.PanelCentenProcessor extends com.zcp.frame.Processor
	var PanelCentenProcessor=(function(_super){
		function PanelCentenProcessor($module){
			this._panelCentenView=null;
			this._startSelectNodeInfo=false;
			this._selcetNodeLastMouse=null;
			this._panelRectInfoPicMeshView=null;
			this._panelSceneMeshView=null;
			this._menuFile=null;
			this._panelRectInfoGroupMeshView=null;
			this._panelRectInfoButtonMeshView=null;
			this.willDeleItem
			PanelCentenProcessor.__super.call(this,$module);
			this.initData()
		}

		__class(PanelCentenProcessor,'mvc.centen.panelcenten.PanelCentenProcessor',true);
		var __proto=PanelCentenProcessor.prototype;
		__proto.receivedModuleEvent=function($me){
			switch($me.getClass()){
				case UiSceneEvent:
					break ;
				case PanelLeftEvent:
					if($me.action==/*mvc.left.panelleft.PanelLeftEvent.SHOW_LEFT*/"SHOWLEFT"){}
						if($me.action==/*mvc.left.panelleft.PanelLeftEvent.SELECT_PANEL_NODEVO*/"SELECT_PANEL_NODEVO"){
						this.showUiPanel();
						this.setPanelNodeVo(($me).panelNodeVo)
					}
					if($me.action==/*mvc.left.panelleft.PanelLeftEvent.DELE_PANEL_RECT_NODE_INFO_VO*/"DELE_PANEL_RECT_NODE_INFO_VO"){
						this.delePanelRectInfoNode(($me).panelRectInfoNode)
					}
					break ;
				case PanelCentenEvent:
					if($me.action==/*mvc.centen.panelcenten.PanelCentenEvent.SELECT_PANEL_INFO_NODE*/"SELECT_PANEL_INFO_NODE"){
						this.selectInfoNode(($me))
					}
					if($me.action==/*mvc.centen.panelcenten.PanelCentenEvent.PANEL_RECT_INFO_START_MOVE*/"PANEL_RECT_INFO_START_MOVE"){
						this.startMoveNodeInfo()
					}
					if($me.action==/*mvc.centen.panelcenten.PanelCentenEvent.REFRESH_PANEL_RECT_INFO_SIZE_VIEW*/"REFRESH_PANEL_RECT_INFO_SIZE_VIEW"){
						this.refreshPanelInofView()
					}
					break ;
				}
		}

		__proto.initData=function(){
			_me.Scene_data.stage.addEventListener(/*iflash.events.MouseEvent.MIDDLE_MOUSE_UP*/"middleMouseUp",__bind(this,this.onMiddleUp))
			_me.Scene_data.stage.addEventListener(/*iflash.events.MouseEvent.MIDDLE_MOUSE_DOWN*/"middleMouseDown",__bind(this,this.onMiddleDown))
			_me.Scene_data.stage.addEventListener(/*iflash.events.MouseEvent.MOUSE_MOVE*/"mouseMove",__bind(this,this.onMouseMove))
			_me.Scene_data.stage.addEventListener(/*iflash.events.MouseEvent.MOUSE_DOWN*/"mouseDown",__bind(this,this.onMouseDown))
			_me.Scene_data.stage.addEventListener(/*iflash.events.MouseEvent.MOUSE_UP*/"mouseUp",__bind(this,this.onStageMouseUP))
			_me.Scene_data.stage.addEventListener(/*iflash.events.MouseEvent.MOUSE_WHEEL*/"mouseWheel",__bind(this,this.onMouseWheel));
			_me.Scene_data.stage.addEventListener(/*iflash.events.KeyboardEvent.KEY_DOWN*/"keyDown",__bind(this,this.onStageKeyDown));
			_me.Scene_data.stage.addEventListener(/*iflash.events.MouseEvent.RIGHT_CLICK*/"rightClick",__bind(this,this.onRightClick));
			_me.Scene_data.stage.addEventListener(/*iflash.events.MouseEvent.CLICK*/"click",__bind(this,this.onStageClik));
			this.initMenuFile()
		}

		__proto.onMouseDown=function(event){
			if(!this.isCanDo){
				return;
			}
			if(event.target){
				if((event.target).parent){
					return;
				}
			}
			if(this.testInCentenPanel){
				this._panelCentenView.beginDrawLine()
			}
		}

		__proto.onStageClik=function(event){
			if(!this.isCanDo){
				return;
			}
			if(Boolean(event.target)){
				var $PanelLeftEvent=new PanelLeftEvent(/*mvc.left.panelleft.PanelLeftEvent.SELECT_PANEL_NODEVO*/"SELECT_PANEL_NODEVO")
				$PanelLeftEvent.panelNodeVo=this._panelCentenView.panelNodeVo;
				com.zcp.frame.event.ModuleEventManager.dispatchEvent($PanelLeftEvent);
			}
		}

		__proto.onRightClick=function(event){
			if(!this.isCanDo){
				return
			}
			if(this.testInCentenPanel){
				this._menuFile.display(_me.Scene_data.stage,_me.Scene_data.stage.mouseX,_me.Scene_data.stage.mouseY);
			}
		}

		__proto.initMenuFile=function(){
			this._menuFile=new NativeMenu;
			var newtypefile=new NativeMenu;
			var item;
			item=new NativeMenuItem("添加图片")
			this._menuFile.addItem(item);
			item.addEventListener(/*iflash.events.Event.SELECT*/"select",__bind(this,this.addNewRectPic));
			item=new NativeMenuItem("添加按钮")
			this._menuFile.addItem(item);
			item.addEventListener(/*iflash.events.Event.SELECT*/"select",__bind(this,this.addNewRectBut));
		}

		__proto.addNewRectBut=function(event){
			var pos=new Point(this._panelCentenView.mouseX,this._panelCentenView.mouseY)
			pos.x=pos.x-this._panelCentenView.PexilX
			pos.y=pos.y-this._panelCentenView.PexilY
			pos.x=pos.x/this._panelCentenView.scaleNum
			pos.y=pos.y/this._panelCentenView.scaleNum
			PanelModel.getInstance().panelNodeVoAddInfoNode(this._panelCentenView.panelNodeVo,pos,/*mvc.left.panelleft.vo.PanelRectInfoType.BUTTON*/1)
			var $PanelLeftEvent=new PanelLeftEvent(/*mvc.left.panelleft.PanelLeftEvent.SELECT_PANEL_NODEVO*/"SELECT_PANEL_NODEVO")
			$PanelLeftEvent.panelNodeVo=this._panelCentenView.panelNodeVo;
			com.zcp.frame.event.ModuleEventManager.dispatchEvent($PanelLeftEvent);
		}

		__proto.addNewRectPic=function(event){
			var pos=new Point(this._panelCentenView.mouseX,this._panelCentenView.mouseY)
			pos.x=pos.x-this._panelCentenView.PexilX
			pos.y=pos.y-this._panelCentenView.PexilY
			pos.x=pos.x/this._panelCentenView.scaleNum
			pos.y=pos.y/this._panelCentenView.scaleNum
			PanelModel.getInstance().panelNodeVoAddInfoNode(this._panelCentenView.panelNodeVo,pos,/*mvc.left.panelleft.vo.PanelRectInfoType.PICTURE*/0)
			var $PanelLeftEvent=new PanelLeftEvent(/*mvc.left.panelleft.PanelLeftEvent.SELECT_PANEL_NODEVO*/"SELECT_PANEL_NODEVO")
			$PanelLeftEvent.panelNodeVo=this._panelCentenView.panelNodeVo;
			com.zcp.frame.event.ModuleEventManager.dispatchEvent($PanelLeftEvent);
		}

		__proto.onStageKeyDown=function(event){
			if(!this.isCanDo){
				return
			}
			if(!Boolean(Laya.__typeof(event.target,spark.components.RichEditableText))){
				if(event.ctrlKey){
					if(event.keyCode==/*iflash.ui.Keyboard.UP*/38){
						this.changeLevelUp();
					}
					if(event.keyCode==/*iflash.ui.Keyboard.DOWN*/40){
						this.changeLevelDown();
					}
					if(event.keyCode==/*iflash.ui.Keyboard.C*/67){
						this._panelCentenView.makeCopy();
					}
					if(event.keyCode==/*iflash.ui.Keyboard.V*/86){
						if(this._panelCentenView.paste()){
							var $CentenEvent=new PanelCentenEvent(/*mvc.centen.panelcenten.PanelCentenEvent.REFRESH_PANEL_RECT_INFO_SELECT_ITEM*/"REFRESH_PANEL_RECT_INFO_SELECT_ITEM")
							$CentenEvent.selectItem=this._panelCentenView.selectArr
							com.zcp.frame.event.ModuleEventManager.dispatchEvent($CentenEvent);
						}
					}
					}else{
					if(event.keyCode==/*iflash.ui.Keyboard.UP*/38){
						this.tureSelecMove(0,-1)
					}
					if(event.keyCode==/*iflash.ui.Keyboard.DOWN*/40){
						this.tureSelecMove(0,+1)
					}
					if(event.keyCode==/*iflash.ui.Keyboard.LEFT*/37){
						this.tureSelecMove(-1,0)
					}
					if(event.keyCode==/*iflash.ui.Keyboard.RIGHT*/39){
						this.tureSelecMove(+1,0)
					}
					if(event.keyCode==/*iflash.ui.Keyboard.DELETE*/46){
						this.deleSelectPanelInfoNode()
					}
				}
			}
		}

		__proto.deleSelectPanelInfoNode=function(){
			var _$this=this;
			if(this._panelCentenView.selectArr&&this._panelCentenView.selectArr.length){
				this.willDeleItem=new Array
				for(var i=0;i<this._panelCentenView.selectArr.length;i++){
					this.willDeleItem.push(this._panelCentenView.selectArr[i])
				}
				mx.controls.Alert.show("是否确定删除？","删除",3,this._panelCentenView,deleteCallBack=function(event){
					if(event.detail==mx.controls.Alert.YES){
						_$this.deleRectInfoNode(_$this.willDeleItem)
						_$this._panelCentenView.selectArr=new Array
					}
				});
			}
		}

		__proto.deleRectInfoNode=function(arr){
			for(var j=0;arr&&j<arr.length;j++){
				var panelRectInfoNode=arr[j]
				for(var i=0;i<this._panelCentenView.panelNodeVo.item.length;i++){
					if(this._panelCentenView.panelNodeVo.item[i]==panelRectInfoNode){
						this._panelCentenView.panelNodeVo.item.removeItemAt(i)
					}
				}
			};
			var $PanelLeftEvent=new PanelLeftEvent(/*mvc.left.panelleft.PanelLeftEvent.SELECT_PANEL_NODEVO*/"SELECT_PANEL_NODEVO")
			$PanelLeftEvent.panelNodeVo=this._panelCentenView.panelNodeVo;
			com.zcp.frame.event.ModuleEventManager.dispatchEvent($PanelLeftEvent);
			arr=new Array
		}

		__proto.tureSelecMove=function($tx,$ty){
			for(var i=0;this._panelCentenView.selectArr&&i<this._panelCentenView.selectArr.length;i++){
				this._panelCentenView.selectArr[i].rect.x+=$tx
				this._panelCentenView.selectArr[i].rect.y+=$ty
				this._panelCentenView.selectArr[i].sprite.changeSize();
			}
		}

		__proto.changeLevelDown=function(){
			for(var i=0;this._panelCentenView.selectArr&&i<this._panelCentenView.selectArr.length;i++){
				var $parent=this._panelCentenView.selectArr[i].sprite.parent;
				if($parent){
					var num=$parent.getChildIndex(this._panelCentenView.selectArr[i].sprite)
					if(num>0){
						$parent.setChildIndex(this._panelCentenView.selectArr[i].sprite,num-1)
					}
				}
			}
			this._panelCentenView.changePanelInfoLevel()
		}

		__proto.changeLevelUp=function(){
			for(var i=0;this._panelCentenView.selectArr&&i<this._panelCentenView.selectArr.length;i++){
				var $parent=this._panelCentenView.selectArr[i].sprite.parent;
				if($parent){
					var num=$parent.getChildIndex(this._panelCentenView.selectArr[i].sprite)
					if(num<($parent.numChildren-1)){
						$parent.setChildIndex(this._panelCentenView.selectArr[i].sprite,num+1)
					}
				}
			}
			this._panelCentenView.changePanelInfoLevel()
		}

		__proto.onMouseWheel=function(event){
			if(!this.isCanDo){
				return
			}
			if(this.testInCentenPanel){
				if(event.delta>0){
					this._panelCentenView.KeyAdd()
					}else{
					this._panelCentenView.KeySub()
				}
			}
		}

		__proto.onMiddleUp=function(event){
			if(!this.isCanDo){
				return
			}
			this._panelCentenView.middleDown=false
		}

		__proto.onMiddleDown=function(event){
			if(!this.isCanDo){
				return;
			}
			if(this.testInCentenPanel){
				this._panelCentenView.middleDown=true
			}
		}

		__proto.onStageMouseUP=function(event){
			if(!this.isCanDo){
				return
			}
			if(this._startSelectNodeInfo){
				for(var i=0;i<this._panelCentenView.selectArr.length;i++){
					var $h5UIFileNode=this._panelCentenView.selectArr[i];
					$h5UIFileNode.rect.x=$h5UIFileNode.sprite.x
					$h5UIFileNode.rect.y=$h5UIFileNode.sprite.y
				}
				this._startSelectNodeInfo=false;
				this.refreshPanelInofView()
				}else{
				this.findSelectNode(event)
			}
			this._panelCentenView.endDrawLine()
		}

		__proto.findSelectNode=function(event){
			if(this._panelCentenView.beginLinePoin){
				var $selectNodeArr=new Array;
				var a=this._panelCentenView.beginLinePoin;
				var b=new Point(this._panelCentenView.mouseX,this._panelCentenView.mouseY)
				var $selectRec=new Rectangle();
				var cavanPos=this._panelCentenView.getBmpPostion()
				var anum=1/this._panelCentenView.scaleNum
				$selectRec.x=(Math.min(a.x,b.x)-cavanPos.x)*anum
				$selectRec.y=(Math.min(a.y,b.y)-cavanPos.y)*anum
				$selectRec.width=Math.abs(a.x-b.x)*anum
				$selectRec.height=Math.abs(a.y-b.y)*anum
				for(var i=0;i<this._panelCentenView.nodeItem.length;i++){
					var $PanelRectInfoNode=this._panelCentenView.nodeItem[i];
					if($selectRec.intersects($PanelRectInfoNode.rect)||(event.shiftKey&&$PanelRectInfoNode.select)){
						$selectNodeArr.push($PanelRectInfoNode)
					}
				}
				this._panelCentenView.selectArr=$selectNodeArr
				com.zcp.frame.event.ModuleEventManager.dispatchEvent(new PanelCentenEvent(/*mvc.centen.panelcenten.PanelCentenEvent.SELECT_PANEL_INFO_NODE*/"SELECT_PANEL_INFO_NODE"));
			}
		}

		__proto.onMouseMove=function(event){
			if(!this.isCanDo){
				return
			}
			this._panelCentenView.mouseMove()
			if(this._startSelectNodeInfo){
				var addPos=new Point;
				addPos.x=_me.Scene_data.stage.mouseX-this._selcetNodeLastMouse.x
				addPos.y=_me.Scene_data.stage.mouseY-this._selcetNodeLastMouse.y
				for(var i=0;i<this._panelCentenView.selectArr.length;i++){
					var $h5UIFileNode=this._panelCentenView.selectArr[i];
					$h5UIFileNode.sprite.x=$h5UIFileNode.rect.x+addPos.x/this._panelCentenView.scaleNum
					$h5UIFileNode.sprite.y=$h5UIFileNode.rect.y+addPos.y/this._panelCentenView.scaleNum
				}
				}else{
				this._panelCentenView.drawSelectLine()
			}
		}

		__proto.listenModuleEvents=function(){
			return [
			PanelCentenEvent,
			DisCentenEvent,
			PanelLeftEvent,
			UiSceneEvent,]
		}

		__proto.delePanelRectInfoNode=function(panelRectInfoNode){
			var arr=new Array
			arr.push(panelRectInfoNode)
			this.deleRectInfoNode(arr)
		}

		__proto.showPanelSceneMesh=function(panelNodeVo){
			if(!this._panelSceneMeshView){
				this._panelSceneMeshView=new H5UIMetaDataView();
				this._panelSceneMeshView.init(this,"属性",2);
				this._panelSceneMeshView.creatByClass(PanelSceneMesh);
			};
			var $PanelSceneMesh=new PanelSceneMesh
			$PanelSceneMesh.panelNodeVo=panelNodeVo
			this._panelSceneMeshView.setTarget($PanelSceneMesh);
			manager.LayerManager.getInstance().addPanel(this._panelSceneMeshView);
			$PanelSceneMesh.addEventListener(/*iflash.events.Event.CHANGE*/"change",__bind(this,this.panelSceneMeshChange))
		}

		__proto.panelSceneMeshChange=function(event){
			this._panelCentenView.changeData()
		}

		__proto.refreshPanelInofView=function(){
			if(this._panelRectInfoPicMeshView){
				this._panelRectInfoPicMeshView.refreshView()
			}
			if(this._panelRectInfoButtonMeshView){
				this._panelRectInfoButtonMeshView.refreshView()
			}
		}

		__proto.startMoveNodeInfo=function(){
			this._selcetNodeLastMouse=new Point(_me.Scene_data.stage.mouseX,_me.Scene_data.stage.mouseY)
			this._startSelectNodeInfo=true
		}

		__proto.selectInfoNode=function($centenEvent){
			if(!this._panelCentenView.selectArr){
				this._panelCentenView.selectArr=new Array;
			}
			if($centenEvent.panelRectInfoNode){
				if($centenEvent.ctrlKey){
					this._panelCentenView.selectArr=new Array;
					this._panelCentenView.selectArr.push($centenEvent.panelRectInfoNode)
					}else if($centenEvent.shiftKey){
					this.clearSelectNode($centenEvent.panelRectInfoNode)
					if(!$centenEvent.panelRectInfoNode.select){
						this._panelCentenView.selectArr.push($centenEvent.panelRectInfoNode)
					}
					}else{
					this._panelCentenView.selectArr=new Array;
					this._panelCentenView.selectArr.push($centenEvent.panelRectInfoNode)
				}
			}
			for(var i=0;i<this._panelCentenView.nodeItem.length;i++){
				var has=false;
				for(var j=0;j<this._panelCentenView.selectArr.length;j++){
					if((this._panelCentenView.nodeItem[i])==this._panelCentenView.selectArr[j]){
						has=true;
					}
				}
				(this._panelCentenView.nodeItem[i]).select=has;
				(this._panelCentenView.nodeItem[i]).sprite.updata();
			}
			if(this._panelCentenView.selectArr&&this._panelCentenView.selectArr.length==1){
				if(this._panelCentenView.selectArr[0].type==/*mvc.left.panelleft.vo.PanelRectInfoType.PICTURE*/0){
					this.showPanelRectInfoNode(this._panelCentenView.selectArr[0])
				}
				if(this._panelCentenView.selectArr[0].type==/*mvc.left.panelleft.vo.PanelRectInfoType.BUTTON*/1){
					this.showPanelRectInfoNodeButton(this._panelCentenView.selectArr[0])
				}
			}
			if(this._panelCentenView.selectArr&&this._panelCentenView.selectArr.length>1){
				this.showPanelRectInfoNodeGroup(this._panelCentenView.selectArr)
			};
			var $CentenEvent=new PanelCentenEvent(/*mvc.centen.panelcenten.PanelCentenEvent.REFRESH_PANEL_RECT_INFO_SELECT_ITEM*/"REFRESH_PANEL_RECT_INFO_SELECT_ITEM")
			$CentenEvent.selectItem=this._panelCentenView.selectArr
			com.zcp.frame.event.ModuleEventManager.dispatchEvent($CentenEvent);
		}

		__proto.showPanelRectInfoNodeButton=function($PanelRectInfoNode){
			if($PanelRectInfoNode.type==/*mvc.left.panelleft.vo.PanelRectInfoType.BUTTON*/1){
				if(!this._panelRectInfoButtonMeshView){
					this._panelRectInfoButtonMeshView=new H5UIMetaDataView();
					this._panelRectInfoButtonMeshView.init(this,"属性",2);
					this._panelRectInfoButtonMeshView.creatByClass(PanelRectInfoButtonMesh);
				};
				var $PanelRectInfoButtonMesh=new PanelRectInfoButtonMesh
				$PanelRectInfoButtonMesh.panelRectInfoNode=$PanelRectInfoNode
				this._panelRectInfoButtonMeshView.setTarget($PanelRectInfoButtonMesh);
				manager.LayerManager.getInstance().addPanel(this._panelRectInfoButtonMeshView);
				$PanelRectInfoButtonMesh.addEventListener(/*iflash.events.Event.CHANGE*/"change",__bind(this,this.panelRectInfoButtonMeshChange))
			}
		}

		__proto.panelRectInfoButtonMeshChange=function(event){
			var $PanelRectInfoButtonMesh=(event.target);
			$PanelRectInfoButtonMesh.panelRectInfoNode.sprite.updata();
		}

		__proto.showPanelRectInfoNodeGroup=function(selectArr){
			if(!this._panelRectInfoGroupMeshView){
				this._panelRectInfoGroupMeshView=new H5UIMetaDataView();
				this._panelRectInfoGroupMeshView.init(this,"属性",2);
				this._panelRectInfoGroupMeshView.creatByClass(PanelRectGroupMesh);
			};
			var $PanelRectGroupMesh=new PanelRectGroupMesh
			$PanelRectGroupMesh.selectItem=selectArr
			this._panelRectInfoGroupMeshView.setTarget($PanelRectGroupMesh);
			manager.LayerManager.getInstance().addPanel(this._panelRectInfoGroupMeshView);
		}

		__proto.showPanelRectInfoNode=function($PanelRectInfoNode){
			if($PanelRectInfoNode.type==/*mvc.left.panelleft.vo.PanelRectInfoType.PICTURE*/0){
				if(!this._panelRectInfoPicMeshView){
					this._panelRectInfoPicMeshView=new H5UIMetaDataView();
					this._panelRectInfoPicMeshView.init(this,"属性",2);
					this._panelRectInfoPicMeshView.creatByClass(PanelRectInfoPictureMesh);
				};
				var $PanelRectInfoMesh=new PanelRectInfoPictureMesh
				$PanelRectInfoMesh.panelRectInfoNode=$PanelRectInfoNode
				this._panelRectInfoPicMeshView.setTarget($PanelRectInfoMesh);
				manager.LayerManager.getInstance().addPanel(this._panelRectInfoPicMeshView);
				$PanelRectInfoMesh.addEventListener(/*iflash.events.Event.CHANGE*/"change",__bind(this,this.panelRectInfoMeshChange))
			}
		}

		__proto.panelRectInfoMeshChange=function(event){
			var $PanelRectInfoMesh=(event.target);
			$PanelRectInfoMesh.panelRectInfoNode.sprite.updata();
		}

		__proto.clearSelectNode=function($node){
			for(var i=0;i<this._panelCentenView.selectArr.length;i++){
				if($node==this._panelCentenView.selectArr[i]){
					this._panelCentenView.selectArr.splice(i,1)
					break ;
				}
			}
		}

		__proto.setPanelNodeVo=function(panelNodeVo){
			this._panelCentenView.panelNodeVo=panelNodeVo;
			this.showPanelSceneMesh(panelNodeVo)
		}

		__proto.showUiPanel=function(){
			if(!this._panelCentenView){
				this._panelCentenView=new PanelCentenView;
			}
			this._panelCentenView.init(this,"中",1);
			manager.LayerManager.getInstance().addPanel(this._panelCentenView);
		}

		__getset(0,__proto,'testInCentenPanel',function(){
			var pos=this._panelCentenView.localToGlobal(new Point);
			var rect=new Rectangle();
			rect.x=pos.x
			rect.y=pos.y
			rect.width=this._panelCentenView.width;
			rect.height=this._panelCentenView.height;
			var mousePos=new Point(_me.Scene_data.stage.mouseX,_me.Scene_data.stage.mouseY)
			if(mousePos.x>rect.x&&mousePos.y>rect.y&&mousePos.x<(rect.x+rect.width)&&mousePos.y<(rect.y+rect.height)){
				return true
				}else{
				return false
			}
		});

		__getset(0,__proto,'isCanDo',function(){
			if(UiData.editMode==1){
				return true
				}else{
				return false
			}
		});

		return PanelCentenProcessor;
	})(com.zcp.frame.Processor)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/centen/panelcenten/panelcentenview.as
	//class mvc.centen.panelcenten.PanelCentenView extends common.utils.frame.BasePanel
	var PanelCentenView=(function(_super){
		function PanelCentenView(){
			this._panelCentenBack=null;
			this._panelCentenInfoLevel=null;
			this._panelNodeVo=null;
			this._selectArr=null;
			this.lastMousePos=null;
			this.lastDisPos=null;
			this._middleDown=false;
			this._scaleNum=1;
			this._copyItem=null;
			this._sizeTxt=null;
			this._selectLineSprite=null;
			this._beginLinePoin
			PanelCentenView.__super.call(this);
			this.initData()
			this.addEventListener(/*iflash.events.Event.ADDED_TO_STAGE*/"addedToStage",__bind(this,this.onAddToStage))
		}

		__class(PanelCentenView,'mvc.centen.panelcenten.PanelCentenView',true);
		var __proto=PanelCentenView.prototype;
		__proto.onAddToStage=function(event){
			UiData.editMode=1
		}

		__proto.changeData=function(){
			this._panelCentenBack.drawColorSprite(this._panelNodeVo)
		}

		__proto.initData=function(){
			this._selectArr=new Array
			this._panelCentenBack=new PanelCentenBackSprite()
			this.addChild(this._panelCentenBack)
			this._panelCentenInfoLevel=new PanelCentenInfoLevel()
			this.addChild(this._panelCentenInfoLevel)
			this.addLabel()
			this.addLineSprite()
		}

		__proto.addLineSprite=function(){
			this._selectLineSprite=new mx.core.UIComponent;
			this.addChild(this._selectLineSprite)
		}

		__proto.beginDrawLine=function(){
			this._beginLinePoin=new Point(this.mouseX,this.mouseY)
		}

		__proto.endDrawLine=function(){
			this._selectLineSprite.graphics.clear();
			this._beginLinePoin=null;
		}

		__proto.drawSelectLine=function(){
			if(this._beginLinePoin){
				var a=this._beginLinePoin;
				var b=new Point(this.mouseX,this.mouseY)
				this._selectLineSprite.graphics.clear();
				this._selectLineSprite.graphics.lineStyle(1,0xff0000,1)
				this._selectLineSprite.graphics.moveTo(a.x,a.y)
				this._selectLineSprite.graphics.lineTo(a.x,b.y)
				this._selectLineSprite.graphics.lineTo(b.x,b.y)
				this._selectLineSprite.graphics.lineTo(b.x,a.y)
				this._selectLineSprite.graphics.lineTo(a.x,a.y)
			}
		}

		__proto.addLabel=function(){
			this._sizeTxt=new mx.controls.Label
			this._sizeTxt.width=80
			this._sizeTxt.height=20
			this.addChild(this._sizeTxt)
			this._sizeTxt.text="比例:100%"
		}

		__proto.onSize=function(event){
			this._sizeTxt.x=this.width-81
		}

		__proto.changePanelInfoLevel=function(){
			for(var i=0;i<this._panelNodeVo.item.length;i++){
				var $PanelRectInfoNode=this._panelNodeVo.item [i];
				var $parent=$PanelRectInfoNode.sprite.parent
				if($parent){
					var num=$parent.getChildIndex($PanelRectInfoNode.sprite)
					$PanelRectInfoNode.level=num
				}
			}
		}

		__proto.mouseMove=function(){
			if(this._middleDown){
				var nowMouse=new Point(this.mouseX,this.mouseY)
				this._panelCentenBack.x=this.lastDisPos.x+(nowMouse.x-this.lastMousePos.x)
				this._panelCentenBack.y=this.lastDisPos.y+(nowMouse.y-this.lastMousePos.y)
				this._panelCentenInfoLevel.x=this._panelCentenBack.x;
				this._panelCentenInfoLevel.y=this._panelCentenBack.y;
			}
		}

		__proto.KeyAdd=function(){
			this._scaleNum=this._scaleNum*1.1
			if(Math.abs(1-this._scaleNum)<0.05){
				this._scaleNum=1
			}
			this._panelCentenBack.scaleX=this._scaleNum;
			this._panelCentenBack.scaleY=this._scaleNum;
			this._panelCentenInfoLevel.scaleX=this._scaleNum;
			this._panelCentenInfoLevel.scaleY=this._scaleNum;
			this._sizeTxt.text="比例:"+String(int(this._scaleNum*100))+"%"
		}

		__proto.KeySub=function(){
			this._scaleNum=this._scaleNum*0.9
			if(Math.abs(1-this._scaleNum)<0.05){
				this._scaleNum=1
			}
			this._panelCentenBack.scaleX=this._scaleNum;
			this._panelCentenBack.scaleY=this._scaleNum;
			this._panelCentenInfoLevel.scaleX=this._scaleNum;
			this._panelCentenInfoLevel.scaleY=this._scaleNum;
			this._sizeTxt.text="比例:"+String(int(this._scaleNum*100))+"%"
		}

		__proto.makeCopy=function(){
			this._copyItem=new Array
			if(this.selectArr&&this.selectArr.length){
				for(var i=0;i<this.selectArr.length;i++){
					this._copyItem.push(this.selectArr[i])
				}
			}
		}

		__proto.paste=function(){
			if(this._copyItem&&this._copyItem.length){
				this._selectArr=new Array
				for(var i=0;i<this._copyItem.length;i++){
					this._copyItem[i].select=false;
					this._copyItem[i].sprite.changeSize();
					var $PanelRectInfoNode=this._copyItem[i].clone();
					$PanelRectInfoNode.name=this._copyItem[i].name+"_copy";
					$PanelRectInfoNode.select=true
					this.nodeItem.addItem($PanelRectInfoNode)
					this._panelCentenInfoLevel.addPanelRectInfoNode($PanelRectInfoNode)
					this._selectArr.push($PanelRectInfoNode)
				}
				return true
			}
			return false
		}

		__proto.getBmpPostion=function(){
			return new Point(this._panelCentenInfoLevel.x,this._panelCentenInfoLevel.y);
		}

		__getset(0,__proto,'PexilY',function(){
			return this._panelCentenBack.y
		});

		__getset(0,__proto,'scaleNum',function(){
			return this._scaleNum;
		});

		__getset(0,__proto,'selectArr',function(){
			return this._selectArr;
			},function(value){
			this._selectArr=value;
		});

		__getset(0,__proto,'nodeItem',function(){
			return this._panelNodeVo.item;
			},function(value){
			this._panelNodeVo.item=value;
		});

		__getset(0,__proto,'panelNodeVo',function(){
			return this._panelNodeVo;
			},function(value){
			this._selectArr=new Array
			this._panelNodeVo=value;
			this._panelCentenInfoLevel.setItem=this._panelNodeVo.item
			this.changeData()
		});

		__getset(0,__proto,'beginLinePoin',function(){
			return this._beginLinePoin;
		});

		__getset(0,__proto,'middleDown',null,function(value){
			this._middleDown=value;
			if(this._middleDown){
				this.lastMousePos=new Point(this.mouseX,this.mouseY)
				this.lastDisPos=new Point(this._panelCentenBack.x,this._panelCentenBack.y)
			}
		});

		__getset(0,__proto,'PexilX',function(){
			return this._panelCentenBack.x
		});

		return PanelCentenView;
	})(common.utils.frame.BasePanel)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/left/disleft/disleftevent.as
	//class mvc.left.disleft.DisLeftEvent extends com.zcp.frame.event.ModuleEvent
	var DisLeftEvent=(function(_super){
		function DisLeftEvent($action){
			DisLeftEvent.__super.call(this,$action);
		}

		__class(DisLeftEvent,'mvc.left.disleft.DisLeftEvent',true);
		DisLeftEvent.SHOW_RIGHT="SHOWRIGHT";
		return DisLeftEvent;
	})(com.zcp.frame.event.ModuleEvent)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/left/disleft/disleftmodule.as
	//class mvc.left.disleft.DisLeftModule extends com.zcp.frame.Module
	var DisLeftModule=(function(_super){
		function DisLeftModule(){
			DisLeftModule.__super.call(this);
		}

		__class(DisLeftModule,'mvc.left.disleft.DisLeftModule',true);
		var __proto=DisLeftModule.prototype;
		__proto.listProcessors=function(){
			return [
			new DisLeftProcessor(this),]
		}

		return DisLeftModule;
	})(com.zcp.frame.Module)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/left/disleft/disleftpanel.as
	//class mvc.left.disleft.DisLeftPanel extends common.utils.frame.BasePanel
	var DisLeftPanel=(function(_super){
		function DisLeftPanel(){
			this._bg=null;
			this._tree=null;
			DisLeftPanel.__super.call(this);
			this.addList();
			this.addEvents();
		}

		__class(DisLeftPanel,'mvc.left.disleft.DisLeftPanel',true);
		var __proto=DisLeftPanel.prototype;
		__proto.addList=function(){
			this._tree=new mx.controls.Tree;
			this._tree.setStyle("top",0);
			this._tree.setStyle("bottom",0);
			this._tree.setStyle("left",0);
			this._tree.setStyle("right",0);
			this._tree.setStyle("contentBackgroundColor",0x505050);
			this._tree.setStyle("color",0x9f9f9f);
			this._tree.labelField="name";
			this._tree.itemRenderer=new mx.core.ClassFactory(ListTreeItemRenderer);
			this._tree.focusEnabled=false;
			this.addChild(this._tree);
		}

		__proto.onSize=function(event){}
		__proto.addEvents=function(){
			this._tree.addEventListener(mx.events.ListEvent.ITEM_CLICK,__bind(this,this.onItemClik));
			this.addEventListener(/*iflash.events.Event.ADDED_TO_STAGE*/"addedToStage",__bind(this,this.addToStage))
		}

		__proto.addToStage=function(event){
			com.zcp.frame.event.ModuleEventManager.dispatchEvent(new UiSceneEvent(/*mvc.scene.UiSceneEvent.SHOW_UI_SCENE*/"SHOW_UI_SCENE"));
			com.zcp.frame.event.ModuleEventManager.dispatchEvent(new DisCentenEvent(/*mvc.centen.discenten.DisCentenEvent.SHOW_CENTEN*/"SHOWCENTEN"));
			UiData.selectArr=new Array
			com.zcp.frame.event.ModuleEventManager.dispatchEvent(new DisCentenEvent(/*mvc.centen.discenten.DisCentenEvent.REFRESH_SELECT_FILENODE*/"REFRESH_SELECT_FILENODE"));
		}

		__proto.onItemClik=function(event){
			if(event.itemRenderer){
				var $H5UIFileNode=event.itemRenderer.data;
				var $CentenEvent=new UiSceneEvent(/*mvc.scene.UiSceneEvent.SELECT_INFO_NODE*/"SELECT_INFO_NODE")
				$CentenEvent.h5UIFileNode=$H5UIFileNode;
				$CentenEvent.ctrlKey=true
				com.zcp.frame.event.ModuleEventManager.dispatchEvent($CentenEvent);
			}
		}

		__proto.resetInfoArr=function(){
			this._tree.dataProvider=UiData.nodeItem;
			this._tree.invalidateList();
			this._tree.validateNow();
		}

		__proto.refreshSelect=function(){
			var tempItem=new Array
			for(var k=0;UiData.selectArr&&k<UiData.selectArr.length;k++){
				tempItem.push(UiData.selectArr[k])
			}
			this._tree.selectedItems=tempItem;
		}

		return DisLeftPanel;
	})(common.utils.frame.BasePanel)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/left/disleft/disleftprocessor.as
	//class mvc.left.disleft.DisLeftProcessor extends com.zcp.frame.Processor
	var DisLeftProcessor=(function(_super){
		function DisLeftProcessor($module){
			this._rightPanel=null;
			DisLeftProcessor.__super.call(this,$module);
		}

		__class(DisLeftProcessor,'mvc.left.disleft.DisLeftProcessor',true);
		var __proto=DisLeftProcessor.prototype;
		__proto.listenModuleEvents=function(){
			return [
			DisLeftEvent,
			UiSceneEvent,
			DisCentenEvent,
			common.msg.event.engineConfig.MEventStageResize,]
		}

		__proto.receivedModuleEvent=function($me){
			switch($me.getClass()){
				case DisLeftEvent:
					if($me.action==/*mvc.left.disleft.DisLeftEvent.SHOW_RIGHT*/"SHOWRIGHT"){
						this.showHide()
					}
					break ;
				case UiSceneEvent:
					if($me.action==/*mvc.scene.UiSceneEvent.REFRESH_SCENE_DATA*/"REFRESH_SCENE_DATA"){
						this.refreshSceneData()
					}
					break ;
				case DisCentenEvent:
					if($me.action==/*mvc.centen.discenten.DisCentenEvent.REFRESH_SELECT_FILENODE*/"REFRESH_SELECT_FILENODE"){
						this.refreshSelectFileNode()
					}
					break ;
				case common.msg.event.engineConfig.MEventStageResize:
					this.resize($me)
					break ;
				}
		}

		__proto.resize=function($mEventStageResize){
			if(this._rightPanel){
				this._rightPanel.onSize()
			}
		}

		__proto.refreshSelectFileNode=function(){
			this._rightPanel.refreshSelect();
		}

		__proto.refreshSceneData=function(){
			this._rightPanel.resetInfoArr();
		}

		__proto.showHide=function(){
			if(!this._rightPanel){
				this._rightPanel=new DisLeftPanel;
			}
			this._rightPanel.init(this,"分割",4);
			manager.LayerManager.getInstance().addPanel(this._rightPanel);
		}

		return DisLeftProcessor;
	})(com.zcp.frame.Processor)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/left/panelleft/panelinfoitemrender.as
	//class mvc.left.panelleft.PanelInfoItemRender extends mx.controls.treeClasses.TreeItemRenderer
	var PanelInfoItemRender=(function(_super){
		function PanelInfoItemRender(){
			this._txt=null;
			this._menuFile=null;
			PanelInfoItemRender.__super.call(this);
			this.addEvents();
			this.initMenuFile()
		}

		__class(PanelInfoItemRender,'mvc.left.panelleft.PanelInfoItemRender',true);
		var __proto=PanelInfoItemRender.prototype;
		__proto.addEvents=function(){
			this.addEventListener(/*iflash.events.MouseEvent.RIGHT_CLICK*/"rightClick",__bind(this,this.onRightClick));
			this.addEventListener(mx.events.FlexEvent.DATA_CHANGE,__bind(this,this.dataChange))
		}

		__proto.dataChange=function(event){}
		__proto.SetLab=function(value){
			if(!value){
				return;
			};
			var node=value.item;
			if(node.rename){
				if(!this._txt){
					this._txt=new spark.components.TextInput;
				}
				this._txt.width=this.label.width;
				this._txt.height=this.label.height;
				this._txt.x=this.label.x;
				this._txt.y=this.label.y;
				this.addChild(this._txt);
				this._txt.text=node.name.split(".")[0];
				this._txt.addEventListener(mx.events.FlexEvent.ENTER,__bind(this,this.onSureTxt));
				this._txt.addEventListener(/*iflash.events.FocusEvent.FOCUS_OUT*/"focusOut",__bind(this,this.onSureTxt));
				}else{
				if(this._txt && this._txt.parent){
					this._txt.parent.removeChild(this._txt);
				}
				if(this._txt){
					this._txt.removeEventListener(mx.events.FlexEvent.ENTER,__bind(this,this.onSureTxt));
					this._txt.removeEventListener(/*iflash.events.FocusEvent.FOCUS_OUT*/"focusOut",__bind(this,this.onSureTxt));
				}
			}
		}

		__proto.onSureTxt=function(event){
			this._txt.removeEventListener(mx.events.FlexEvent.ENTER,__bind(this,this.onSureTxt));
			this._txt.removeEventListener(/*iflash.events.FocusEvent.FOCUS_OUT*/"focusOut",__bind(this,this.onSureTxt));
			var $selfNode=this.data;
			if($selfNode&&this._txt.text.length>0){
				$selfNode.name=this._txt.text
				$selfNode.rename=false
				mx.binding.utils.BindingUtils.bindSetter(__bind(this,this.SetLab),this,"listData");
				this.label.text=$selfNode.name
			}
		}

		__proto.onRightClick=function(event){
			this._menuFile.display(this.stage,this.stage.mouseX,this.stage.mouseY);
		}

		__proto.initMenuFile=function(){
			this._menuFile=new NativeMenu;
			var newtypefile=new NativeMenu;
			var item;
			item=new NativeMenuItem("重命名")
			this._menuFile.addItem(item);
			item.addEventListener(/*iflash.events.Event.SELECT*/"select",__bind(this,this.onRename));
			item=new NativeMenuItem("删除")
			this._menuFile.addItem(item);
			item.addEventListener(/*iflash.events.Event.SELECT*/"select",__bind(this,this.onDele));
		}

		__proto.onDele=function(event){
			var $PanelRectInfoNode=this.data;
			if($PanelRectInfoNode){
				var $PanelLeftEvent=new PanelLeftEvent(/*mvc.left.panelleft.PanelLeftEvent.DELE_PANEL_RECT_NODE_INFO_VO*/"DELE_PANEL_RECT_NODE_INFO_VO")
				$PanelLeftEvent.panelRectInfoNode=$PanelRectInfoNode;
				com.zcp.frame.event.ModuleEventManager.dispatchEvent($PanelLeftEvent);
			}
		}

		__proto.onRename=function(event){
			var $selfNode=this.data;
			if($selfNode){
				$selfNode.rename=true
				mx.binding.utils.BindingUtils.bindSetter(__bind(this,this.SetLab),this,"listData");
			}
		}

		return PanelInfoItemRender;
	})(mx.controls.treeClasses.TreeItemRenderer)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/left/panelleft/panelleftevent.as
	//class mvc.left.panelleft.PanelLeftEvent extends com.zcp.frame.event.ModuleEvent
	var PanelLeftEvent=(function(_super){
		function PanelLeftEvent($action){
			this.panelNodeVo=null;
			this.panelRectInfoNode
			PanelLeftEvent.__super.call(this,$action);
		}

		__class(PanelLeftEvent,'mvc.left.panelleft.PanelLeftEvent',true);
		PanelLeftEvent.SHOW_LEFT="SHOWLEFT";
		PanelLeftEvent.SELECT_PANEL_NODEVO="SELECT_PANEL_NODEVO";
		PanelLeftEvent.DELE_PANEL_NODE_INFO_VO="DELE_PANEL_NODE_INFO_VO";
		PanelLeftEvent.DELE_PANEL_RECT_NODE_INFO_VO="DELE_PANEL_RECT_NODE_INFO_VO";
		PanelLeftEvent.REFRESH_PANEL_TREE="REFRESH_PANEL_TREE";
		return PanelLeftEvent;
	})(com.zcp.frame.event.ModuleEvent)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/left/panelleft/panelleftmodule.as
	//class mvc.left.panelleft.PanelLeftModule extends com.zcp.frame.Module
	var PanelLeftModule=(function(_super){
		function PanelLeftModule(){
			PanelLeftModule.__super.call(this);
		}

		__class(PanelLeftModule,'mvc.left.panelleft.PanelLeftModule',true);
		var __proto=PanelLeftModule.prototype;
		__proto.listProcessors=function(){
			return [
			new PanelLeftProcessor(this),]
		}

		return PanelLeftModule;
	})(com.zcp.frame.Module)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/left/panelleft/panelleftpanel.as
	//class mvc.left.panelleft.PanelLeftPanel extends common.utils.frame.BasePanel
	var PanelLeftPanel=(function(_super){
		function PanelLeftPanel(){
			this._bg=null;
			this._tree=null;
			this._panelInfoTree=null;
			this._menuFile=null;
			PanelLeftPanel.__super.call(this);
			this.addList();
			this.addInfoList()
			this.initMenuFile()
			this.addEvents();
		}

		__class(PanelLeftPanel,'mvc.left.panelleft.PanelLeftPanel',true);
		var __proto=PanelLeftPanel.prototype;
		__proto.onRightClick=function(event){
			if(event.target){
				this._menuFile.display(_me.Scene_data.stage,_me.Scene_data.stage.mouseX,_me.Scene_data.stage.mouseY);
			}
		}

		__proto.initMenuFile=function(){
			this._menuFile=new NativeMenu;
			var newtypefile=new NativeMenu;
			var item;
			item=new NativeMenuItem("添加面板")
			this._menuFile.addItem(item);
			item.addEventListener(/*iflash.events.Event.SELECT*/"select",__bind(this,this.addNewNode));
		}

		__proto.addNewNode=function(event){
			PanelModel.getInstance().addNewPanelVo()
			this.resetInfoArr()
		}

		__proto.addInfoList=function(){
			this._panelInfoTree=new mx.controls.Tree;
			this._panelInfoTree.setStyle("top",300);
			this._panelInfoTree.setStyle("bottom",0);
			this._panelInfoTree.setStyle("left",0);
			this._panelInfoTree.setStyle("right",0);
			this._panelInfoTree.setStyle("contentBackgroundColor",0x505050);
			this._panelInfoTree.setStyle("color",0x9f9f9f);
			this._panelInfoTree.labelField="name";
			this._panelInfoTree.itemRenderer=new mx.core.ClassFactory(PanelInfoItemRender);
			this._panelInfoTree.focusEnabled=false;
			this.addChild(this._panelInfoTree);
		}

		__proto.addList=function(){
			this._tree=new mx.controls.Tree;
			this._tree.setStyle("top",0);
			this._tree.setStyle("bottom",300);
			this._tree.setStyle("left",0);
			this._tree.setStyle("right",0);
			this._tree.setStyle("contentBackgroundColor",0x505050);
			this._tree.setStyle("color",0x9f9f9f);
			this._tree.labelField="name";
			this._tree.itemRenderer=new mx.core.ClassFactory(PanelListItemRenderer);
			this._tree.focusEnabled=false;
			this.addChild(this._tree);
		}

		__proto.onSize=function(event){
			if(this.height>30){
				this._tree.setStyle("bottom",this.height/2+5);
				this._panelInfoTree.setStyle("top",this.height/2);
			}
		}

		__proto.addEvents=function(){
			this._tree.addEventListener(mx.events.ListEvent.ITEM_CLICK,__bind(this,this.onItemClik));
			this._tree.addEventListener(/*iflash.events.MouseEvent.RIGHT_CLICK*/"rightClick",__bind(this,this.onRightClick));
			this._panelInfoTree.addEventListener(mx.events.ListEvent.ITEM_CLICK,__bind(this,this.panelInfoTreeClik));
			this.addEventListener(/*iflash.events.Event.ADDED_TO_STAGE*/"addedToStage",__bind(this,this.addToStage))
		}

		__proto.addToStage=function(event){
			var $PanelNodeVo=this._tree.selectedItem;
			if($PanelNodeVo){
				var $PanelLeftEvent=new PanelLeftEvent(/*mvc.left.panelleft.PanelLeftEvent.SELECT_PANEL_NODEVO*/"SELECT_PANEL_NODEVO")
				$PanelLeftEvent.panelNodeVo=$PanelNodeVo;
				com.zcp.frame.event.ModuleEventManager.dispatchEvent($PanelLeftEvent);
			}
		}

		__proto.panelInfoTreeClik=function(event){
			if(event.itemRenderer){
				var $PanelRectInfoNode=event.itemRenderer.data;
				var $CentenEvent=new PanelCentenEvent(/*mvc.centen.panelcenten.PanelCentenEvent.SELECT_PANEL_INFO_NODE*/"SELECT_PANEL_INFO_NODE")
				$CentenEvent.panelRectInfoNode=$PanelRectInfoNode;
				$CentenEvent.ctrlKey=true
				com.zcp.frame.event.ModuleEventManager.dispatchEvent($CentenEvent);
			}
		}

		__proto.resetInfoArr=function(){
			this._tree.dataProvider=PanelModel.getInstance().item;
			this._tree.invalidateList();
			this._tree.validateNow();
		}

		__proto.refreshView=function(){
			this._tree.invalidateList();
			this._tree.validateNow();
			this._panelInfoTree.invalidateList();
			this._panelInfoTree.validateNow();
		}

		__proto.onItemClik=function(event){
			if(event.itemRenderer){
				var $PanelLeftEvent=new PanelLeftEvent(/*mvc.left.panelleft.PanelLeftEvent.SELECT_PANEL_NODEVO*/"SELECT_PANEL_NODEVO")
				$PanelLeftEvent.panelNodeVo=event.itemRenderer.data;
				com.zcp.frame.event.ModuleEventManager.dispatchEvent($PanelLeftEvent);
				this._panelInfoTree.dataProvider=$PanelLeftEvent.panelNodeVo.item
				this._panelInfoTree.invalidateList();
				this._panelInfoTree.validateNow();
			}
		}

		__getset(0,__proto,'selectRectInfoItem',null,function(value){
			var tempItem=new Array
			for(var i=0;value&&i<value.length;i++){
				tempItem.push(value[i])
			}
			this._panelInfoTree.selectedItems=tempItem;
		});

		return PanelLeftPanel;
	})(common.utils.frame.BasePanel)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/left/panelleft/panelleftprocessor.as
	//class mvc.left.panelleft.PanelLeftProcessor extends com.zcp.frame.Processor
	var PanelLeftProcessor=(function(_super){
		function PanelLeftProcessor($module){
			this._panelLeftPanel=null;
			PanelLeftProcessor.__super.call(this,$module);
		}

		__class(PanelLeftProcessor,'mvc.left.panelleft.PanelLeftProcessor',true);
		var __proto=PanelLeftProcessor.prototype;
		__proto.listenModuleEvents=function(){
			return [
			PanelLeftEvent,
			UiSceneEvent,
			PanelCentenEvent,
			common.msg.event.engineConfig.MEventStageResize,]
		}

		__proto.receivedModuleEvent=function($me){
			switch($me.getClass()){
				case PanelLeftEvent:
					if($me.action==/*mvc.left.panelleft.PanelLeftEvent.SHOW_LEFT*/"SHOWLEFT"){
						this.showHide()
					}
					if($me.action==/*mvc.left.panelleft.PanelLeftEvent.DELE_PANEL_NODE_INFO_VO*/"DELE_PANEL_NODE_INFO_VO"){
						this.delePanelNodelVo(($me).panelNodeVo)
					}
					if($me.action==/*mvc.left.panelleft.PanelLeftEvent.REFRESH_PANEL_TREE*/"REFRESH_PANEL_TREE"){
						this._panelLeftPanel.refreshView()
					}
					break ;
				case UiSceneEvent:
					if($me.action==/*mvc.scene.UiSceneEvent.REFRESH_SCENE_DATA*/"REFRESH_SCENE_DATA"){
						this.refreshSceneData()
					}
					break ;
				case PanelCentenEvent:
					if($me.action==/*mvc.centen.panelcenten.PanelCentenEvent.REFRESH_PANEL_RECT_INFO_SELECT_ITEM*/"REFRESH_PANEL_RECT_INFO_SELECT_ITEM"){
						this.refreshPanelRectInofSelectItem(($me).selectItem)
					}
					break ;
				case common.msg.event.engineConfig.MEventStageResize:
					break ;
				}
		}

		__proto.delePanelNodelVo=function($delNode){
			for(var i=0;i<PanelModel.getInstance().item.length;i++){
				if(PanelModel.getInstance().item[i]==$delNode){
					PanelModel.getInstance().item.removeItemAt(i)
				}
			}
			this._panelLeftPanel.resetInfoArr();
		}

		__proto.refreshPanelRectInofSelectItem=function($arr){
			this._panelLeftPanel.selectRectInfoItem=$arr
		}

		__proto.willDele=function(){
			var $PanelLeftEvent=new PanelLeftEvent(/*mvc.left.panelleft.PanelLeftEvent.SELECT_PANEL_NODEVO*/"SELECT_PANEL_NODEVO")
			$PanelLeftEvent.panelNodeVo=PanelModel.getInstance().item[0];
			com.zcp.frame.event.ModuleEventManager.dispatchEvent($PanelLeftEvent);
		}

		__proto.refreshSceneData=function(){
			if(this._panelLeftPanel){
				this._panelLeftPanel.resetInfoArr();
			}
		}

		__proto.showHide=function(){
			if(!this._panelLeftPanel){
				this._panelLeftPanel=new PanelLeftPanel;
			}
			this._panelLeftPanel.init(this,"面板",4);
			manager.LayerManager.getInstance().addPanel(this._panelLeftPanel);
		}

		return PanelLeftProcessor;
	})(com.zcp.frame.Processor)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/left/panelleft/panellistitemrenderer.as
	//class mvc.left.panelleft.PanelListItemRenderer extends mx.controls.treeClasses.TreeItemRenderer
	var PanelListItemRenderer=(function(_super){
		function PanelListItemRenderer(){
			this._txt=null;
			this._menuFile=null;
			PanelListItemRenderer.__super.call(this);
			this.addEvents();
			this.initMenuFile()
		}

		__class(PanelListItemRenderer,'mvc.left.panelleft.PanelListItemRenderer',true);
		var __proto=PanelListItemRenderer.prototype;
		__proto.addEvents=function(){
			this.addEventListener(/*iflash.events.MouseEvent.RIGHT_CLICK*/"rightClick",__bind(this,this.onRightClick));
			this.addEventListener(mx.events.FlexEvent.DATA_CHANGE,__bind(this,this.dataChange))
		}

		__proto.dataChange=function(event){
			var $selfNode=this.data;
			if($selfNode){}
				}
		__proto.SetLab=function(value){
			if(!value){
				return;
			};
			var node=value.item;
			if(node.rename){
				if(!this._txt){
					this._txt=new spark.components.TextInput;
				}
				this._txt.width=this.label.width;
				this._txt.height=this.label.height;
				this._txt.x=this.label.x;
				this._txt.y=this.label.y;
				this.addChild(this._txt);
				this._txt.text=node.name.split(".")[0];
				this._txt.addEventListener(mx.events.FlexEvent.ENTER,__bind(this,this.onSureTxt));
				this._txt.addEventListener(/*iflash.events.FocusEvent.FOCUS_OUT*/"focusOut",__bind(this,this.onSureTxt));
				}else{
				if(this._txt && this._txt.parent){
					this._txt.parent.removeChild(this._txt);
				}
				if(this._txt){
					this._txt.removeEventListener(mx.events.FlexEvent.ENTER,__bind(this,this.onSureTxt));
					this._txt.removeEventListener(/*iflash.events.FocusEvent.FOCUS_OUT*/"focusOut",__bind(this,this.onSureTxt));
				}
			}
		}

		__proto.onSureTxt=function(event){
			this._txt.removeEventListener(mx.events.FlexEvent.ENTER,__bind(this,this.onSureTxt));
			this._txt.removeEventListener(/*iflash.events.FocusEvent.FOCUS_OUT*/"focusOut",__bind(this,this.onSureTxt));
			var $selfNode=this.data;
			if($selfNode&&this._txt.text.length>0){
				$selfNode.name=this._txt.text
				$selfNode.rename=false
				mx.binding.utils.BindingUtils.bindSetter(__bind(this,this.SetLab),this,"listData");
				this.label.text=$selfNode.name
			}
		}

		__proto.onRightClick=function(event){
			this._menuFile.display(this.stage,this.stage.mouseX,this.stage.mouseY);
		}

		__proto.initMenuFile=function(){
			this._menuFile=new NativeMenu;
			var newtypefile=new NativeMenu;
			var item;
			item=new NativeMenuItem("重命名")
			this._menuFile.addItem(item);
			item.addEventListener(/*iflash.events.Event.SELECT*/"select",__bind(this,this.onRename));
			item=new NativeMenuItem("删除")
			this._menuFile.addItem(item);
			item.addEventListener(/*iflash.events.Event.SELECT*/"select",__bind(this,this.onDele));
		}

		__proto.onDele=function(event){
			var $selfNode=this.data;
			if($selfNode){
				var $PanelLeftEvent=new PanelLeftEvent(/*mvc.left.panelleft.PanelLeftEvent.DELE_PANEL_NODE_INFO_VO*/"DELE_PANEL_NODE_INFO_VO")
				$PanelLeftEvent.panelNodeVo=$selfNode;
				com.zcp.frame.event.ModuleEventManager.dispatchEvent($PanelLeftEvent);
			}
		}

		__proto.onRename=function(event){
			var $selfNode=this.data;
			if($selfNode){
				$selfNode.rename=true
				mx.binding.utils.BindingUtils.bindSetter(__bind(this,this.SetLab),this,"listData");
			}
		}

		return PanelListItemRenderer;
	})(mx.controls.treeClasses.TreeItemRenderer)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/left/panelleft/vo/panelnodevo.as
	//class mvc.left.panelleft.vo.PanelNodeVo extends common.utils.ui.file.FileNode
	var PanelNodeVo=(function(_super){
		function PanelNodeVo(){
			this.item=null;
			this.canverRect=null;
			this.color=0;
			PanelNodeVo.__super.call(this);
		}

		__class(PanelNodeVo,'mvc.left.panelleft.vo.PanelNodeVo',true);
		var __proto=PanelNodeVo.prototype;
		__proto.readObject=function(){
			var obj=new Object;
			obj.name=this.name;
			obj.canverRect=this.canverRect;
			obj.color=this.color;
			obj.item=this.getItemArr()
			return obj;
		}

		__proto.getItemArr=function(){
			var arr=new Array;
			for(var i=0;i<this.item.length;i++){
				var $PanelRectInfoNode=this.item [i];
				arr.push($PanelRectInfoNode.readObject())
			}
			arr.sortOn("level",Array.NUMERIC);
			return arr;
		}

		__proto.readObjectToH5=function(){
			var obj=new Object;
			obj.name=this.name;
			obj.canverRect=this.canverRect;
			obj.color=this.color;
			obj.item=this.getItemArrToH5()
			return obj;
		}

		__proto.getItemArrToH5=function(){
			var arr=new Array;
			for(var i=0;i<this.item.length;i++){
				var $PanelRectInfoNode=this.item [i];
				arr.push($PanelRectInfoNode.readObjectToH5())
			}
			arr.sortOn("level",Array.NUMERIC);
			return arr;
		}

		__proto.setObject=function($obj){
			this.item=new mx.collections.ArrayCollection;
			for(var i=0;$obj.item&&i<$obj.item.length;i++){
				var $PanelRectInfoNode=new PanelRectInfoNode;
				$PanelRectInfoNode.setObject($obj.item[i])
				$PanelRectInfoNode.sprite=new PanelRectInfoSprite()
				$PanelRectInfoNode.sprite.panelRectInfoNode=$PanelRectInfoNode
				this.item.addItem($PanelRectInfoNode)
			}
			this.name=$obj.name;
			this.color=$obj.color;
			this.canverRect=new Rectangle;
			this.canverRect.x=$obj.canverRect.x
			this.canverRect.y=$obj.canverRect.y
			this.canverRect.width=$obj.canverRect.width
			this.canverRect.height=$obj.canverRect.height
		}

		return PanelNodeVo;
	})(common.utils.ui.file.FileNode)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/vo/alighnode.as
	//class vo.AlighNode extends common.utils.ui.file.FileNode
	var AlighNode=(function(_super){
		function AlighNode(){
			this.rect
			AlighNode.__super.call(this);
		}

		__class(AlighNode,'vo.AlighNode',true);
		return AlighNode;
	})(common.utils.ui.file.FileNode)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/project/projectevent.as
	//class mvc.project.ProjectEvent extends com.zcp.frame.event.ModuleEvent
	var ProjectEvent=(function(_super){
		function ProjectEvent($action){
			this.url
			ProjectEvent.__super.call(this,$action);
		}

		__class(ProjectEvent,'mvc.project.ProjectEvent',true);
		ProjectEvent.OPEN_PROJECT_FILE="OPEN_PROJECT_FILE";
		return ProjectEvent;
	})(com.zcp.frame.event.ModuleEvent)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/project/projectmodule.as
	//class mvc.project.ProjectModule extends com.zcp.frame.Module
	var ProjectModule=(function(_super){
		function ProjectModule(){
			ProjectModule.__super.call(this);
		}

		__class(ProjectModule,'mvc.project.ProjectModule',true);
		var __proto=ProjectModule.prototype;
		__proto.listProcessors=function(){
			return [
			new ProjectProcessor(this),]
		}

		return ProjectModule;
	})(com.zcp.frame.Module)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/project/projectprocessor.as
	//class mvc.project.ProjectProcessor extends com.zcp.frame.Processor
	var ProjectProcessor=(function(_super){
		function ProjectProcessor($module){
			ProjectProcessor.__super.call(this,$module);
		}

		__class(ProjectProcessor,'mvc.project.ProjectProcessor',true);
		var __proto=ProjectProcessor.prototype;
		__proto.listenModuleEvents=function(){
			return [
			ProjectEvent,]
		}

		__proto.receivedModuleEvent=function($me){
			switch($me.getClass()){
				case ProjectEvent:
					if($me.action==/*mvc.project.ProjectEvent.OPEN_PROJECT_FILE*/"OPEN_PROJECT_FILE"){
						this.readScene(new File(($me).url))
					}
					break ;
				}
		}

		__proto.readScene=function($file){
			var _so=UiData.getSharedObject()
			_so.data.url=$file.url;
			var $fs=new FileStream;
			$fs.open($file,/*iflash.filesystem.FileMode.READ*/"read");
			var $obj=$fs.readObject();
			$fs.close();
			UiData.meshBmp($obj.FileBmpItem)
			UiData.meshInfo($obj.InfoRectItem)
			PanelModel.getInstance().setPanelNodeItemByObj($obj.panelItem)
			if($obj.sceneBmpRec){
				UiData.sceneBmpRec=new Rectangle(0,0,$obj.sceneBmpRec.width,$obj.sceneBmpRec.height)
				}else{
				UiData.sceneBmpRec=new Rectangle(0,0,512,512)
			}
			if($obj.sceneColor){
				UiData.sceneColor=$obj.sceneColor
				}else{
				UiData.sceneColor=0x00ffffff
			}
			UiData.url=$file.url
			com.zcp.frame.event.ModuleEventManager.dispatchEvent(new UiSceneEvent(/*mvc.scene.UiSceneEvent.REFRESH_SCENE_DATA*/"REFRESH_SCENE_DATA"));
			com.zcp.frame.event.ModuleEventManager.dispatchEvent(new DisCentenEvent(/*mvc.centen.discenten.DisCentenEvent.SHOW_CENTEN*/"SHOWCENTEN"));
			com.zcp.frame.event.ModuleEventManager.dispatchEvent(new DisLeftEvent(/*mvc.left.disleft.DisLeftEvent.SHOW_RIGHT*/"SHOWRIGHT"));
		}

		return ProjectProcessor;
	})(com.zcp.frame.Processor)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/scene/uisceneevent.as
	//class mvc.scene.UiSceneEvent extends com.zcp.frame.event.ModuleEvent
	var UiSceneEvent=(function(_super){
		function UiSceneEvent($action){
			this.h5UIFileNode=null;
			this.shiftKey=false;
			this.ctrlKey=false;
			UiSceneEvent.__super.call(this,$action);
		}

		__class(UiSceneEvent,'mvc.scene.UiSceneEvent',true);
		UiSceneEvent.SHOW_UI_SCENE="SHOW_UI_SCENE";
		UiSceneEvent.REFRESH_SCENE_DATA="REFRESH_SCENE_DATA";
		UiSceneEvent.SELECT_INFO_NODE="SELECT_INFO_NODE";
		UiSceneEvent.START_MOVE_NODE_INFO="START_MOVE_NODE_INFO";
		UiSceneEvent.CHANGE_SCENE_COLOR="CHANGE_SCENE_COLOR";
		UiSceneEvent.REFRESH_SCENE_BITMAPDATA="REFRESH_SCENE_BITMAPDATA";
		return UiSceneEvent;
	})(com.zcp.frame.event.ModuleEvent)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/scene/uiscenemodule.as
	//class mvc.scene.UiSceneModule extends com.zcp.frame.Module
	var UiSceneModule=(function(_super){
		function UiSceneModule(){
			UiSceneModule.__super.call(this);
		}

		__class(UiSceneModule,'mvc.scene.UiSceneModule',true);
		var __proto=UiSceneModule.prototype;
		__proto.listProcessors=function(){
			return [
			new UiSceneProcessor(this),]
		}

		return UiSceneModule;
	})(com.zcp.frame.Module)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/scene/uiscenepanel.as
	//class mvc.scene.UiScenePanel extends common.utils.frame.BasePanel
	var UiScenePanel=(function(_super){
		function UiScenePanel(){
			this._colorPickers=null;
			this._xTxt=null;
			this._yTxt=null;
			this._sceneRectW=null;
			this._sceneRectH=null;
			UiScenePanel.__super.call(this);
			this.addColor();
			this.addTexts();
			this._sceneRectW=this.getComboxComponent("宽:","sizeW")
			this._sceneRectW.y=60
			this._sceneRectW.x=0
			this.addChild(this._sceneRectW)
			this._sceneRectH=this.getComboxComponent("宽:","sizeH")
			this._sceneRectH.y=60
			this._sceneRectH.x=80
			this.addChild(this._sceneRectH)
		}

		__class(UiScenePanel,'mvc.scene.UiScenePanel',true);
		var __proto=UiScenePanel.prototype;
		__proto.getComboxComponent=function($label,$funkeyStr){
			var cb=new common.utils.ui.cbox.ComLabelBox;
			cb.label=$label
			cb.width=100;
			cb.height=18;
			cb.labelData=[{name:"64",data:64},{name:"128",data:128},{name:"256",data:256},{name:"512",data:512},{name:"1024",data:1024},{name:"2048",data:2048}]
			cb.FunKey=$funkeyStr
			cb.target=this;
			return cb;
		}

		__proto.addTexts=function(){
			var bpos=new Point(0,10)
			this._xTxt=new common.utils.ui.txt.TextCtrlInput;
			this._xTxt.height=18;
			this._xTxt.width=100;
			this._xTxt.center=true;
			this._xTxt.label="x:"
			this._xTxt.y=20+bpos.y
			this._xTxt.x=0+bpos.x
			this._xTxt.FunKey="xData"
			this._xTxt.target=this;
			this.addChild(this._xTxt)
			this._yTxt=new common.utils.ui.txt.TextCtrlInput;
			this._yTxt.height=18;
			this._yTxt.width=100;
			this._yTxt.center=true;
			this._yTxt.label="y:"
			this._yTxt.y=20+bpos.y
			this._yTxt.x=80+bpos.x
			this._yTxt.FunKey="yData"
			this._yTxt.target=this;
			this.addChild(this._yTxt)
		}

		__proto.changeUiSceneData=function(){
			com.zcp.frame.event.ModuleEventManager.dispatchEvent(new UiSceneEvent(/*mvc.scene.UiSceneEvent.CHANGE_SCENE_COLOR*/"CHANGE_SCENE_COLOR"));
		}

		__proto.addColor=function(){
			this._colorPickers=new common.utils.ui.color.ColorPickers;
			this._colorPickers.label="颜色"
			this._colorPickers.width=200
			this._colorPickers.height=18;
			this._colorPickers.getFun=this.getColor;
			this._colorPickers.changFun=this.setColor;
			this.addChild(this._colorPickers)
		}

		__proto.setColor=function(value){
			UiData.sceneColor=value;
			this.changeUiSceneData()
		}

		__proto.getColor=function(){
			if(!UiData.sceneColor){
				UiData.sceneColor=0x00ffffff
			}
			return UiData.sceneColor;
		}

		__proto.refreshSceneData=function(){
			this.refreshViewValue()
		}

		__proto.refreshViewValue=function(){
			this._xTxt.refreshViewValue()
			this._yTxt.refreshViewValue()
			this._colorPickers.refreshViewValue();
			this._sceneRectW.refreshViewValue()
			this._sceneRectH.refreshViewValue()
		}

		__getset(0,__proto,'sizeW',function(){
			return UiData.sceneBmpRec.width;
			},function(value){
			UiData.sceneBmpRec.width=value;
			this.changeUiSceneData()
		});

		__getset(0,__proto,'sizeH',function(){
			return UiData.sceneBmpRec.height;
			},function(value){
			UiData.sceneBmpRec.height=value;
			this.changeUiSceneData()
		});

		__getset(0,__proto,'xData',function(){
			return "0"
			},function(value){
		});

		__getset(0,__proto,'yData',function(){
			return "0"
			},function(value){
		});

		return UiScenePanel;
	})(common.utils.frame.BasePanel)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/scene/uisceneprocessor.as
	//class mvc.scene.UiSceneProcessor extends com.zcp.frame.Processor
	var UiSceneProcessor=(function(_super){
		function UiSceneProcessor($module){
			this._uiScenePanel=null;
			this._h5UI9FileMesh=null;
			this._h5UIFileMesh=null;
			this._h5UIGroupMesh=null;
			UiSceneProcessor.__super.call(this,$module);
		}

		__class(UiSceneProcessor,'mvc.scene.UiSceneProcessor',true);
		var __proto=UiSceneProcessor.prototype;
		__proto.listenModuleEvents=function(){
			return [
			DisCentenEvent,
			UiSceneEvent,]
		}

		__proto.receivedModuleEvent=function($me){
			switch($me.getClass()){
				case UiSceneEvent:
					if($me.action==/*mvc.scene.UiSceneEvent.SHOW_UI_SCENE*/"SHOW_UI_SCENE"){
						this.showHide()
					}
					if($me.action==/*mvc.scene.UiSceneEvent.SELECT_INFO_NODE*/"SELECT_INFO_NODE"){
						this.selectInfoNode(($me))
					}
					if($me.action==/*mvc.scene.UiSceneEvent.REFRESH_SCENE_DATA*/"REFRESH_SCENE_DATA"){
						this.refreshSceneData()
					}
					break ;
				case DisCentenEvent:
					if($me.action==/*mvc.centen.discenten.DisCentenEvent.REFRESH_SELECT_FILENODE*/"REFRESH_SELECT_FILENODE"){
						this.refreshSelectFileNode()
					}
					break ;
				}
		}

		__proto.refreshSelectFileNode=function(){
			if(this._h5UI9FileMesh){
				this._h5UI9FileMesh.refreshView()
			}
			if(this._h5UIFileMesh){
				this._h5UIFileMesh.refreshView()
			}
		}

		__proto.refreshSceneData=function(){
			this._uiScenePanel.refreshSceneData()
		}

		__proto.showHide=function(){
			if(!this._uiScenePanel){
				this._uiScenePanel=new UiScenePanel;
			}
			this._uiScenePanel.init(this,"属性",2);
			manager.LayerManager.getInstance().addPanel(this._uiScenePanel);
		}

		__proto.selectInfoNode=function($centenEvent){
			if(!UiData.selectArr){
				UiData.selectArr=new Array;
			}
			if($centenEvent.h5UIFileNode){
				if($centenEvent.ctrlKey){
					UiData.selectArr=new Array;
					UiData.selectArr.push($centenEvent.h5UIFileNode)
					}else if($centenEvent.shiftKey){
					this.clearSelectNode($centenEvent.h5UIFileNode)
					if(!$centenEvent.h5UIFileNode.select){
						UiData.selectArr.push($centenEvent.h5UIFileNode)
					}
					}else{
					UiData.selectArr=new Array;
					UiData.selectArr.push($centenEvent.h5UIFileNode)
				}
			}
			for(var i=0;i<UiData.nodeItem.length;i++){
				var has=false;
				for(var j=0;j<UiData.selectArr.length;j++){
					if((UiData.nodeItem[i])==UiData.selectArr[j]){
						has=true;
					}
				}
				(UiData.nodeItem[i]).select=has;
				(UiData.nodeItem[i]).sprite.updata();
			}
			com.zcp.frame.event.ModuleEventManager.dispatchEvent(new DisCentenEvent(/*mvc.centen.discenten.DisCentenEvent.REFRESH_SELECT_FILENODE*/"REFRESH_SELECT_FILENODE"));
			if(UiData.selectArr&&UiData.selectArr.length==1){
				if(UiData.selectArr[0].type==/*vo.FileInfoType.baseUi*/0){
					this.showH5UIFile(UiData.selectArr[0])
				}
				if(UiData.selectArr[0].type==/*vo.FileInfoType.ui9*/1){
					this.showH5UI9File(UiData.selectArr[0])
				}
			}
			if(UiData.selectArr&&UiData.selectArr.length>1){
				this.showH5UIGroup()
			}
		}

		__proto.showH5UIGroup=function(){
			if(!this._h5UIGroupMesh){
				this._h5UIGroupMesh=new H5UIMetaDataView();
				this._h5UIGroupMesh.init(this,"属性",2);
				this._h5UIGroupMesh.creatByClass(H5UIGroupMesh);
			};
			var $H5UIGroupMesh=new H5UIGroupMesh
			$H5UIGroupMesh.selectItem=UiData.selectArr
			this._h5UIGroupMesh.setTarget($H5UIGroupMesh);
			manager.LayerManager.getInstance().addPanel(this._h5UIGroupMesh);
		}

		__proto.showH5UI9File=function($h5UIFileNode){
			if(!this._h5UI9FileMesh){
				this._h5UI9FileMesh=new H5UIMetaDataView();
				this._h5UI9FileMesh.init(this,"属性",2);
				this._h5UI9FileMesh.creatByClass(H5UIFile9Mesh);
			};
			var $H5UIFile9Mesh=new H5UIFile9Mesh
			$H5UIFile9Mesh.h5UIFileNode=$h5UIFileNode
			this._h5UI9FileMesh.setTarget($H5UIFile9Mesh);
			manager.LayerManager.getInstance().addPanel(this._h5UI9FileMesh);
			$H5UIFile9Mesh.addEventListener(/*iflash.events.Event.CHANGE*/"change",__bind(this,this.h5UIFileMeshChange));
		}

		__proto.showH5UIFile=function($h5UIFileNode){
			if(!this._h5UIFileMesh){
				this._h5UIFileMesh=new H5UIMetaDataView();
				this._h5UIFileMesh.init(this,"属性",2);
				this._h5UIFileMesh.creatByClass(H5UIFileMesh);
			};
			var $H5UIFileMesh=new H5UIFileMesh
			$H5UIFileMesh.h5UIFileNode=$h5UIFileNode
			this._h5UIFileMesh.setTarget($H5UIFileMesh);
			manager.LayerManager.getInstance().addPanel(this._h5UIFileMesh);
			$H5UIFileMesh.addEventListener(/*iflash.events.Event.CHANGE*/"change",__bind(this,this.h5UIFileMeshChange))
		}

		__proto.h5UIFileMeshChange=function(event){
			var $H5UIFileMesh=(event.target);
			$H5UIFileMesh.h5UIFileNode.sprite.updata();
		}

		__proto.clearSelectNode=function($node){
			for(var i=0;i<UiData.selectArr.length;i++){
				if($node==UiData.selectArr[i]){
					UiData.selectArr.splice(i,1)
					break ;
				}
			}
		}

		return UiSceneProcessor;
	})(com.zcp.frame.Processor)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/top/topevent.as
	//class mvc.top.TopEvent extends com.zcp.frame.event.ModuleEvent
	var TopEvent=(function(_super){
		function TopEvent($action){
			TopEvent.__super.call(this,$action);
		}

		__class(TopEvent,'mvc.top.TopEvent',true);
		TopEvent.SHOW_TOP="SHOW_TOP";
		return TopEvent;
	})(com.zcp.frame.event.ModuleEvent)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/top/topmodule.as
	//class mvc.top.TopModule extends com.zcp.frame.Module
	var TopModule=(function(_super){
		function TopModule(){
			TopModule.__super.call(this);
		}

		__class(TopModule,'mvc.top.TopModule',true);
		var __proto=TopModule.prototype;
		__proto.listProcessors=function(){
			return [
			new TopProcessor(this),]
		}

		return TopModule;
	})(com.zcp.frame.Module)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/top/toppanel.as
	//class mvc.top.TopPanel extends common.utils.frame.BasePanel
	var TopPanel=(function(_super){
		function TopPanel(){
			this._bg=null;
			TopPanel.__super.call(this);
			this.setStyle("borderColor",0x151515);
			this.setStyle("borderStyle","solid");
			this.setStyle("borderVisible",true);
			this.horizontalScrollPolicy="off";
			this.width=600;
			this.height=200;
			this.addBack()
		}

		__class(TopPanel,'mvc.top.TopPanel',true);
		var __proto=TopPanel.prototype;
		__proto.addBack=function(){
			this._bg=new mx.core.UIComponent;
			this.addChild(this._bg);
		}

		__proto.drawback=function(){
			this._bg.graphics.clear();
			this._bg.graphics.beginFill(0x404040,1);
			this._bg.graphics.drawRect(0,0,this.width,this.height);
			this._bg.graphics.endFill();
		}

		return TopPanel;
	})(common.utils.frame.BasePanel)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/top/topprocessor.as
	//class mvc.top.TopProcessor extends com.zcp.frame.Processor
	var TopProcessor=(function(_super){
		function TopProcessor($module){
			this._topPanel=null;
			this._menu=null;
			TopProcessor.__super.call(this,$module);
		}

		__class(TopProcessor,'mvc.top.TopProcessor',true);
		var __proto=TopProcessor.prototype;
		__proto.listenModuleEvents=function(){
			return [
			TopEvent,]
		}

		__proto.receivedModuleEvent=function($me){
			switch($me.getClass()){
				case TopEvent:
					if($me.action==/*mvc.top.TopEvent.SHOW_TOP*/"SHOW_TOP"){
						this.showHide()
					}
					break ;
				}
		}

		__proto.showHide=function(){
			if(!this._menu){
				this._menu=new /*no*/this.TopMenuView();
			}
			this._menu.showMenu();
		}

		return TopProcessor;
	})(com.zcp.frame.Processor)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/vo/listtreeitemrenderer.as
	//class vo.ListTreeItemRenderer extends mx.controls.treeClasses.TreeItemRenderer
	var ListTreeItemRenderer=(function(_super){
		function ListTreeItemRenderer(){
			this._txt=null;
			this._menuFile=null;
			ListTreeItemRenderer.__super.call(this);
			this.addEvents();
			this.initMenuFile()
		}

		__class(ListTreeItemRenderer,'vo.ListTreeItemRenderer',true);
		var __proto=ListTreeItemRenderer.prototype;
		__proto.addEvents=function(){
			this.addEventListener(/*iflash.events.MouseEvent.RIGHT_CLICK*/"rightClick",__bind(this,this.onRightClick));
			this.addEventListener(mx.events.FlexEvent.DATA_CHANGE,__bind(this,this.dataChange))
		}

		__proto.dataChange=function(event){
			var $selfNode=this.data;
			if($selfNode){}
				}
		__proto.SetLab=function(value){
			if(!value){
				return;
			};
			var node=value.item;
			if(node.rename){
				if(!this._txt){
					this._txt=new spark.components.TextInput;
				}
				this._txt.width=this.label.width;
				this._txt.height=this.label.height;
				this._txt.x=this.label.x;
				this._txt.y=this.label.y;
				this.addChild(this._txt);
				this._txt.text=node.name.split(".")[0];
				this._txt.addEventListener(mx.events.FlexEvent.ENTER,__bind(this,this.onSureTxt));
				this._txt.addEventListener(/*iflash.events.FocusEvent.FOCUS_OUT*/"focusOut",__bind(this,this.onSureTxt));
				}else{
				if(this._txt && this._txt.parent){
					this._txt.parent.removeChild(this._txt);
				}
				if(this._txt){
					this._txt.removeEventListener(mx.events.FlexEvent.ENTER,__bind(this,this.onSureTxt));
					this._txt.removeEventListener(/*iflash.events.FocusEvent.FOCUS_OUT*/"focusOut",__bind(this,this.onSureTxt));
				}
			}
		}

		__proto.onSureTxt=function(event){
			this._txt.removeEventListener(mx.events.FlexEvent.ENTER,__bind(this,this.onSureTxt));
			this._txt.removeEventListener(/*iflash.events.FocusEvent.FOCUS_OUT*/"focusOut",__bind(this,this.onSureTxt));
			var $selfNode=this.data;
			if($selfNode&&this._txt.text.length>0){
				$selfNode.name=this._txt.text
				$selfNode.rename=false
				mx.binding.utils.BindingUtils.bindSetter(__bind(this,this.SetLab),this,"listData");
				this.label.text=$selfNode.name
			}
		}

		__proto.onRightClick=function(event){
			this._menuFile.display(this.stage,this.stage.mouseX,this.stage.mouseY);
		}

		__proto.initMenuFile=function(){
			this._menuFile=new NativeMenu;
			var newtypefile=new NativeMenu;
			var item;
			item=new NativeMenuItem("重命名")
			this._menuFile.addItem(item);
			item.addEventListener(/*iflash.events.Event.SELECT*/"select",__bind(this,this.onRename));
			item=new NativeMenuItem("删除")
			this._menuFile.addItem(item);
			item.addEventListener(/*iflash.events.Event.SELECT*/"select",__bind(this,this.onDele));
		}

		__proto.onDele=function(event){
			var $selfNode=this.data;
			if($selfNode){
				var $CentenEvent=new DisCentenEvent(/*mvc.centen.discenten.DisCentenEvent.DELE_NODE_INFO_VO*/"DELE_NODE_INFO_VO")
				$CentenEvent.h5UIFileNode=$selfNode;
				com.zcp.frame.event.ModuleEventManager.dispatchEvent($CentenEvent);
			}
		}

		__proto.onRename=function(event){
			var $selfNode=this.data;
			if($selfNode){
				$selfNode.rename=true
				mx.binding.utils.BindingUtils.bindSetter(__bind(this,this.SetLab),this,"listData");
			}
		}

		return ListTreeItemRenderer;
	})(mx.controls.treeClasses.TreeItemRenderer)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/h5uifilemesh.as
	//class mesh.H5UIFileMesh extends iflash.events.EventDispatcher
	var H5UIFileMesh=(function(_super){
		function H5UIFileMesh(){
			this._url=null;
			this._h5UIFileNode=null;
			this._rectPos=null;
			H5UIFileMesh.__super.call(this);
			this._rectSize
		}

		__class(H5UIFileMesh,'mesh.H5UIFileMesh',false,_super);
		var __proto=H5UIFileMesh.prototype;
		Laya.imps(__proto,{"interfaces.ITile":true})
		__proto.change=function(){
			this.dispatchEvent(new Event(/*iflash.events.Event.CHANGE*/"change"));
		}

		__proto.acceptPath=function(){
			return null;
		}

		__proto.getBitmapData=function(){
			return null;
		}

		__proto.getName=function(){
			return this._h5UIFileNode.name;
		}

		__getset(0,__proto,'rectPos',function(){
			return new Point(this._h5UIFileNode.rect.x,this._h5UIFileNode.rect.y);
			},function(value){
			this._h5UIFileNode.rect.x=value.x;
			this._h5UIFileNode.rect.y=value.y;
			this.change()
		});

		__getset(0,__proto,'h5UIFileNode',function(){
			return this._h5UIFileNode;
			},function(value){
			this._h5UIFileNode=value;
		});

		__getset(0,__proto,'rectSize',function(){
			return new Point(this._h5UIFileNode.rect.width,this._h5UIFileNode.rect.height);
			},function(value){
			this._h5UIFileNode.rect.width=value.x;
			this._h5UIFileNode.rect.height=value.y;
			this.change()
		});

		H5UIFileMesh.__init$=function(){
			[/*no*/this.Editor(/*no*/this.type="Vec2",/*no*/this.Label="坐标",/*no*/this.sort="1",/*no*/this.Category="尺寸",/*no*/this.Tip="坐标")]
			[/*no*/this.Editor(/*no*/this.type="Vec2",/*no*/this.Label="尺寸",/*no*/this.sort="2",/*no*/this.Category="尺寸",/*no*/this.Tip="坐标")]
		}

		return H5UIFileMesh;
	})(EventDispatcher)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/h5uigroupmesh.as
	//class mesh.H5UIGroupMesh extends iflash.events.EventDispatcher
	var H5UIGroupMesh=(function(_super){
		function H5UIGroupMesh(target){
			this._selectItem
			H5UIGroupMesh.__super.call(this,target);
		}

		__class(H5UIGroupMesh,'mesh.H5UIGroupMesh',false,_super);
		var __proto=H5UIGroupMesh.prototype;
		Laya.imps(__proto,{"interfaces.ITile":true})
		__proto.getBitmapData=function(){
			return null;
		}

		__proto.getName=function(){
			return null;
		}

		__proto.acceptPath=function(){
			return null;
		}

		__getset(0,__proto,'rectSize',function(){
			var $rect=new Rectangle;
			for(var i=0;i<this._selectItem.length;i++){
				$rect.width+=this._selectItem[i].rect.width
				$rect.height+=this._selectItem[i].rect.height
			}
			$rect.width/=this._selectItem.length
			$rect.height/=this._selectItem.length
			return new Point($rect.width,$rect.height);
			},function(value){
			for(var i=0;i<this._selectItem.length;i++){
				this._selectItem[i].rect.width=value.x;
				this._selectItem[i].rect.height=value.y;
				this._selectItem[i].sprite.updata()
			}
		});

		__getset(0,__proto,'selectItem',function(){
			return this._selectItem;
			},function(value){
			this._selectItem=value;
		});

		__getset(0,__proto,'kkd',function(){
			return true;
			},function(value){
			for(var i=0;i<this._selectItem.length;i++){
				this._selectItem[i].sprite.updata()
			}
		});

		H5UIGroupMesh.__init$=function(){
			[/*no*/this.Editor(/*no*/this.type="AlignRect",/*no*/this.Label="对齐",/*no*/this.sort="4",/*no*/this.Category="模型")]
			[/*no*/this.Editor(/*no*/this.type="Vec2",/*no*/this.Label="尺寸",/*no*/this.sort="2",/*no*/this.Category="尺寸",/*no*/this.Tip="坐标")]
		}

		return H5UIGroupMesh;
	})(EventDispatcher)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectgroupmesh.as
	//class mesh.PanelRectGroupMesh extends iflash.events.EventDispatcher
	var PanelRectGroupMesh=(function(_super){
		function PanelRectGroupMesh(target){
			this._selectItem
			PanelRectGroupMesh.__super.call(this,target);
		}

		__class(PanelRectGroupMesh,'mesh.PanelRectGroupMesh',false,_super);
		var __proto=PanelRectGroupMesh.prototype;
		Laya.imps(__proto,{"interfaces.ITile":true})
		__proto.getBitmapData=function(){
			return null;
		}

		__proto.getName=function(){
			return null;
		}

		__proto.acceptPath=function(){
			return null;
		}

		__getset(0,__proto,'rectSize',function(){
			var $rect=new Rectangle;
			for(var i=0;i<this._selectItem.length;i++){
				$rect.width+=this._selectItem[i].rect.width
				$rect.height+=this._selectItem[i].rect.height
			}
			$rect.width/=this._selectItem.length
			$rect.height/=this._selectItem.length
			return new Point($rect.width,$rect.height);
			},function(value){
			for(var i=0;i<this._selectItem.length;i++){
				this._selectItem[i].rect.width=value.x;
				this._selectItem[i].rect.height=value.y;
				this._selectItem[i].sprite.changeSize()
			}
		});

		__getset(0,__proto,'selectItem',function(){
			return this._selectItem;
			},function(value){
			this._selectItem=value;
		});

		__getset(0,__proto,'kkd',function(){
			return true;
			},function(value){
			for(var i=0;i<this._selectItem.length;i++){
				this._selectItem[i].sprite.changeSize()
			}
		});

		PanelRectGroupMesh.__init$=function(){
			[/*no*/this.Editor(/*no*/this.type="Vec2",/*no*/this.Label="尺寸",/*no*/this.sort="2",/*no*/this.Category="尺寸",/*no*/this.Tip="坐标")]
			[/*no*/this.Editor(/*no*/this.type="AlignRect",/*no*/this.Label="对齐",/*no*/this.sort="3",/*no*/this.Category="模型")]
		}

		return PanelRectGroupMesh;
	})(EventDispatcher)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfobuttonmesh.as
	//class mesh.PanelRectInfoButtonMesh extends iflash.events.EventDispatcher
	var PanelRectInfoButtonMesh=(function(_super){
		function PanelRectInfoButtonMesh(){
			this._url=null;
			this._panelRectInfoNode=null;
			this._rectPos=null;
			this._rectSize=null;
			PanelRectInfoButtonMesh.__super.call(this);
			this._rectInfoPictureName
		}

		__class(PanelRectInfoButtonMesh,'mesh.PanelRectInfoButtonMesh',false,_super);
		var __proto=PanelRectInfoButtonMesh.prototype;
		Laya.imps(__proto,{"interfaces.ITile":true})
		__proto.change=function(){
			this.dispatchEvent(new Event(/*iflash.events.Event.CHANGE*/"change"));
		}

		__proto.acceptPath=function(){
			return null;
		}

		__proto.getBitmapData=function(){
			return null;
		}

		__proto.getName=function(){
			return this._panelRectInfoNode.name;
		}

		__getset(0,__proto,'selectTab',function(){
			return this._panelRectInfoNode.selectTab;
			},function(value){
			this._panelRectInfoNode.selectTab=value
			this.change()
		});

		__getset(0,__proto,'rectInfoPictureA',function(){
			return String(this._panelRectInfoNode.dataItem[0]);
			},function(value){
			this._panelRectInfoNode.dataItem[0]=value;
			this.change()
		});

		__getset(0,__proto,'rectInfoPictureB',function(){
			return String(this._panelRectInfoNode.dataItem[1]);
			},function(value){
			this._panelRectInfoNode.dataItem[1]=value;
			this.change()
		});

		__getset(0,__proto,'rectPos',function(){
			return new Point(this._panelRectInfoNode.rect.x,this._panelRectInfoNode.rect.y);
			},function(value){
			this._panelRectInfoNode.rect.x=value.x;
			this._panelRectInfoNode.rect.y=value.y;
			this.change()
		});

		__getset(0,__proto,'rectSize',function(){
			return new Point(this._panelRectInfoNode.rect.width,this._panelRectInfoNode.rect.height);
			},function(value){
			this._panelRectInfoNode.rect.width=value.x;
			this._panelRectInfoNode.rect.height=value.y;
			this.change()
		});

		__getset(0,__proto,'okbut',function(){
			return true;
			},function(value){
			var bmp=UiData.getUIBitmapDataByName(this._panelRectInfoNode.dataItem[0]);
			if(bmp){
				this._panelRectInfoNode.rect.width=bmp.width
				this._panelRectInfoNode.rect.height=bmp.height
				this.change()
			}
		});

		__getset(0,__proto,'panelRectInfoNode',function(){
			return this._panelRectInfoNode;
			},function(value){
			this._panelRectInfoNode=value;
		});

		PanelRectInfoButtonMesh.__init$=function(){
			[/*no*/this.Editor(/*no*/this.type="ComboBox",/*no*/this.Label="是否选中",/*no*/this.sort="4.5",/*no*/this.Category="属性",/*no*/this.Data="{name:false,data:false}{name:true,data:true}",/*no*/this.Tip="是否当地形用来扫描高度")]
			[/*no*/this.Editor(/*no*/this.type="PanelPictureUI",/*no*/this.Label="图片",/*no*/this.sort="5",/*no*/this.changePath="0",/*no*/this.Category="模型")]
			[/*no*/this.Editor(/*no*/this.type="PanelPictureUI",/*no*/this.Label="图片",/*no*/this.sort="6",/*no*/this.changePath="0",/*no*/this.Category="按下")]
			[/*no*/this.Editor(/*no*/this.type="Vec2",/*no*/this.Label="坐标",/*no*/this.sort="1",/*no*/this.Category="尺寸",/*no*/this.Tip="坐标")]
			[/*no*/this.Editor(/*no*/this.type="Vec2",/*no*/this.Label="尺寸",/*no*/this.sort="2",/*no*/this.Category="尺寸",/*no*/this.Tip="坐标")]
			[/*no*/this.Editor(/*no*/this.type="Btn",/*no*/this.Label="原始尺寸",/*no*/this.sort="3",/*no*/this.Category="尺寸")]
		}

		return PanelRectInfoButtonMesh;
	})(EventDispatcher)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfopicturemesh.as
	//class mesh.PanelRectInfoPictureMesh extends iflash.events.EventDispatcher
	var PanelRectInfoPictureMesh=(function(_super){
		function PanelRectInfoPictureMesh(){
			this._url=null;
			this._panelRectInfoNode=null;
			this._rectPos=null;
			this._rectSize=null;
			PanelRectInfoPictureMesh.__super.call(this);
			this._rectInfoPictureName
		}

		__class(PanelRectInfoPictureMesh,'mesh.PanelRectInfoPictureMesh',false,_super);
		var __proto=PanelRectInfoPictureMesh.prototype;
		Laya.imps(__proto,{"interfaces.ITile":true})
		__proto.change=function(){
			this.dispatchEvent(new Event(/*iflash.events.Event.CHANGE*/"change"));
		}

		__proto.acceptPath=function(){
			return null;
		}

		__proto.getBitmapData=function(){
			return null;
		}

		__proto.getName=function(){
			return this._panelRectInfoNode.name;
		}

		__getset(0,__proto,'rectInfoPictureName',function(){
			return String(this._panelRectInfoNode.dataItem[0]);
			},function(value){
			this._panelRectInfoNode.dataItem[0]=value;
			this.change()
		});

		__getset(0,__proto,'rectPos',function(){
			return new Point(this._panelRectInfoNode.rect.x,this._panelRectInfoNode.rect.y);
			},function(value){
			this._panelRectInfoNode.rect.x=value.x;
			this._panelRectInfoNode.rect.y=value.y;
			this.change()
		});

		__getset(0,__proto,'rectSize',function(){
			return new Point(this._panelRectInfoNode.rect.width,this._panelRectInfoNode.rect.height);
			},function(value){
			this._panelRectInfoNode.rect.width=value.x;
			this._panelRectInfoNode.rect.height=value.y;
			this.change()
		});

		__getset(0,__proto,'okbut',function(){
			return true;
			},function(value){
			var bmp=UiData.getUIBitmapDataByName(this._panelRectInfoNode.dataItem[0]);
			if(bmp){
				this._panelRectInfoNode.rect.width=bmp.width
				this._panelRectInfoNode.rect.height=bmp.height
				this.change()
			}
		});

		__getset(0,__proto,'panelRectInfoNode',function(){
			return this._panelRectInfoNode;
			},function(value){
			this._panelRectInfoNode=value;
		});

		PanelRectInfoPictureMesh.__init$=function(){
			[/*no*/this.Editor(/*no*/this.type="PanelPictureUI",/*no*/this.Label="图片",/*no*/this.sort="5",/*no*/this.changePath="0",/*no*/this.Category="模型")]
			[/*no*/this.Editor(/*no*/this.type="Vec2",/*no*/this.Label="坐标",/*no*/this.sort="1",/*no*/this.Category="尺寸",/*no*/this.Tip="坐标")]
			[/*no*/this.Editor(/*no*/this.type="Vec2",/*no*/this.Label="尺寸",/*no*/this.sort="2",/*no*/this.Category="尺寸",/*no*/this.Tip="坐标")]
			[/*no*/this.Editor(/*no*/this.type="Btn",/*no*/this.Label="原始尺寸",/*no*/this.sort="3",/*no*/this.Category="尺寸")]
		}

		return PanelRectInfoPictureMesh;
	})(EventDispatcher)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelscenemesh.as
	//class mesh.PanelSceneMesh extends iflash.events.EventDispatcher
	var PanelSceneMesh=(function(_super){
		function PanelSceneMesh(target){
			this._panelNodeVo=null;
			this._canverRectSize
			PanelSceneMesh.__super.call(this,target);
		}

		__class(PanelSceneMesh,'mesh.PanelSceneMesh',false,_super);
		var __proto=PanelSceneMesh.prototype;
		Laya.imps(__proto,{"interfaces.ITile":true})
		__proto.change=function(){
			this.dispatchEvent(new Event(/*iflash.events.Event.CHANGE*/"change"));
		}

		__proto.getBitmapData=function(){
			return null;
		}

		__proto.getName=function(){
			return this._panelNodeVo.name;
		}

		__proto.acceptPath=function(){
			return null;
		}

		__getset(0,__proto,'canverRectSize',function(){
			return new Point(this._panelNodeVo.canverRect.width,this._panelNodeVo.canverRect.height);
			},function(value){
			this._panelNodeVo.canverRect.width=value.x
			this._panelNodeVo.canverRect.height=value.y
			this.change()
		});

		__getset(0,__proto,'color',function(){
			return this._panelNodeVo.color;
			},function(value){
			this._panelNodeVo.color=value;
			this.change()
		});

		__getset(0,__proto,'panelNodeVo',function(){
			return this._panelNodeVo;
			},function(value){
			this._panelNodeVo=value;
		});

		PanelSceneMesh.__init$=function(){
			[/*no*/this.Editor(/*no*/this.type="Vec2",/*no*/this.Label="尺寸",/*no*/this.sort="2",/*no*/this.Category="尺寸",/*no*/this.Tip="坐标")]
			[/*no*/this.Editor(/*no*/this.type="ColorPick",/*no*/this.Label="背景",/*no*/this.sort="9",/*no*/this.Category="属性",/*no*/this.Tip="范围")]
		}

		return PanelSceneMesh;
	})(EventDispatcher)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/mx/events/propertychangeevent.as
	//class mx.events.PropertyChangeEvent extends iflash.events.Event
	var PropertyChangeEvent=(function(_super){
		function PropertyChangeEvent(type,bubbles,cancelable,kind,property,oldValue,newValue,source){
			this.kind=null;
			this.newValue=null;
			this.oldValue=null;
			this.property=null;
			this.source=null;
			(bubbles===void 0)&& (bubbles=false);
			(cancelable===void 0)&& (cancelable=false);
			PropertyChangeEvent.__super.call(this,type,bubbles,cancelable);
			this.kind=kind;
			this.property=property;
			this.oldValue=oldValue;
			this.newValue=newValue;
			this.source=source;
		}

		__class(PropertyChangeEvent,'mx.events.PropertyChangeEvent',false,_super);
		var __proto=PropertyChangeEvent.prototype;
		__proto.clone=function(){
			return new PropertyChangeEvent(this.type,this.bubbles,this.cancelable,this.kind,this.property,this.oldValue,this.newValue,this.source);
		}

		PropertyChangeEvent.createUpdateEvent=function(source,property,oldValue,newValue){
			var event=new PropertyChangeEvent("propertyChange");
			event.kind="update";
			event.oldValue=oldValue;
			event.newValue=newValue;
			event.source=source;
			event.property=property;
			return event;
		}

		PropertyChangeEvent.event=function(source,property,oldValue,newValue){
			source.dispatchEvent(PropertyChangeEvent.createUpdateEvent(source,property,oldValue,newValue));
		}

		PropertyChangeEvent.PROPERTY_CHANGE="propertyChange";
		return PropertyChangeEvent;
	})(Event)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflash.as
	//class IFlash extends iflash.laya.ILaya
	var IFlash=(function(_super){
		function IFlash(sprite){
			this.stage=null;
			IFlash._sprite_=sprite;
			IFlash.__super.call(this,sprite);
		}

		__class(IFlash,'IFlash',false,_super);
		var __proto=IFlash.prototype;
		__proto._onInit_=function(){
			EventManager.stage=this.stage=Stage.stage;
			Capabilities.initScreenResolutionXY();
			var fn=IFlash.__beforInit__;
			(fn!=null)&&fn();
			if (IFlash.__width__ > 0 && IFlash.__height__ > 0)Laya.document.size(IFlash.__width__,IFlash.__height__);
			EventManager.stage=this.stage=Stage.stage;
			Laya.window.addEventListener(/*iflash.events.Event.RESIZE*/"resize",__bind(this,this._resize_));
			this.stage.bgcolor=IFlash.__bgColor;
			this.stage.setOrientationEx(IFlash.__setOrientationEx);
			this.stage.showInfo=IFlash.__showInfo;
			this.stage.frameRate=IFlash.__frameRate;
			IFlash._sprite_=IFlash._sprite_ || (new IFlashMain());
			if (IFlash._sprite_ && !IFlash._sprite_.parent && IFlash.__loadResource__==null){
				this.stage.addChild(IFlash._sprite_);
			}
			IFlash.__loadResource__ && IFlash.__StartLoadResource__();
		}

		__proto._resize_=function(e){
			e._lysetTarget(this.stage);
			this.stage.dispatchEvent(e);
		}

		__getset(1,IFlash,'isRuningOnAccelerator',function(){
			return Laya.CONCHVER;
		},iflash.laya.ILaya._$SET_isRuningOnAccelerator);

		IFlash.preSwfAssets=function(assets){
			Loader.preswfAsset(assets);
		}

		IFlash.setAutoDetect=function(value){
			AudioElement.disableAutoDetect=value;
		}

		IFlash.SetTouch=function(bool){
			/*__JS__ */Laya.CONCHVER && (conch.disableMultiTouch=bool);
		}

		IFlash.setSize=function(width,height){
			IFlash.__width__=width;
			IFlash.__height__=height;
			Stage.stage.width=IFlash.__width__;
			Stage.stage.height=IFlash.__height__;
			if(Laya.document.body){
				Laya.document.body.width=IFlash.__width__;
				Laya.document.body.height=IFlash.__height__;
			}
		}

		IFlash.lockScreen=function(value){
			(value===void 0)&& (value=false);
			/*__JS__ */conch.setScreenWakeLock(value);
		}

		IFlash.regBeforInit=function(callback){
			IFlash.__beforInit__=callback;
		}

		IFlash.setBgcolor=function(value){
			IFlash.__bgColor=value;
			Stage.stage.bgcolor=value;
		}

		IFlash.setOrientationEx=function(value){
			IFlash.__setOrientationEx=value;
			Stage.stage.setOrientationEx(value);
		}

		IFlash.setAutoOrients=function(autoOrients){
			(autoOrients===void 0)&& (autoOrients=true);
			Stage.stage.autoOrients=autoOrients;
		}

		IFlash.showInfo=function(value){
			IFlash.__showInfo=value;
			Stage.stage.showInfo=value;
		}

		IFlash.frameRate=function(value){
			if(Laya.CONCHVER && value < 60){
				/*__JS__ */if(conch.setMaxFPS)conch.setMaxFPS(value)
			}
			if(value==IFlash.__frameRate)
				return;
			IFlash.__frameRate=value;
			Stage.stage.frameRate=value;
		}

		IFlash.Start=function(){
			/*__JS__ */LAYABOX.getInterfaceDefinitionByName=function (name){var words=name.split('.');var o=Laya;for (var i=0;i < words.length;i++){o=o[words[i]];if(!o){return null}}return o;};
			new JSONParse();
			Laya.document.body=new Body();
			var R=Register,A=AnimationCreate;
			R.regClass(/*iflash.laya.runner.DataType.LYIMAGELEMENT*/51,LyImageElement);
			R.regClass(/*iflash.laya.runner.DataType.SHAPE*/52,Shape);
			R.regClass(/*iflash.laya.runner.DataType.SHAPE*/52,Shape);
			R.regClass(/*iflash.laya.runner.DataType.BITMAPDATA*/53,BitmapData);
			R.regClass(/*iflash.laya.runner.DataType.BITMAP*/54,Bitmap);
			R.regClass(/*iflash.laya.runner.DataType.SPRITE*/55,Sprite);
			R.regClass(/*iflash.laya.runner.DataType.MOVIECLIP*/56,MovieClip);
			R.regClass(/*iflash.laya.runner.DataType.BUTTON*/58,SimpleButton);
			R.regClass(/*iflash.laya.runner.DataType.TEXTFIELD*/57,TextField);
			R.regClass(/*iflash.laya.runner.DataType.STATICTEXTFIELD*/59,StaticText);
			R.regFunction(/*iflash.laya.runner.DataType.REMOVE_ALL*/151,A.removeAll,2,false,/*iflash.laya.runner.DataType.NULL*/0,/*iflash.laya.runner.DataType.NULL*/0);
			R.regFunction(/*iflash.laya.runner.DataType.SET_INSTANCE_NAME*/152,A.setInstanceName,3,false,/*iflash.laya.runner.DataType.NULL*/0,/*iflash.laya.runner.DataType.SHORT*/4,/*iflash.laya.runner.DataType.STRING*/6);
			R.regFunction(/*iflash.laya.runner.DataType.REMOVE_INSTANCE_NAME*/153,A.removeInstanceName,3,false,/*iflash.laya.runner.DataType.NULL*/0,/*iflash.laya.runner.DataType.SHORT*/4,/*iflash.laya.runner.DataType.STRING*/6);
			R.regFunction(/*iflash.laya.runner.DataType.NEW_OBJECT*/154,A.newObject,4,false,/*iflash.laya.runner.DataType.NULL*/0,/*iflash.laya.runner.DataType.SHORT*/4,/*iflash.laya.runner.DataType.SHORT*/4,/*iflash.laya.runner.DataType.STRING*/6);
			R.regFunction(/*iflash.laya.runner.DataType.ADD_CHILD*/155,A.addChild,3,false,/*iflash.laya.runner.DataType.NULL*/0,/*iflash.laya.runner.DataType.SHORT*/4,/*iflash.laya.runner.DataType.SHORT*/4);
			R.regFunction(/*iflash.laya.runner.DataType.REMOVE_CHILD*/156,A.removeChild,2,false,/*iflash.laya.runner.DataType.NULL*/0,/*iflash.laya.runner.DataType.SHORT*/4);
			R.regFunction(/*iflash.laya.runner.DataType.SET_TRANSFORM*/157,A.setTransform,9,false,/*iflash.laya.runner.DataType.NULL*/0,/*iflash.laya.runner.DataType.SHORT*/4,/*iflash.laya.runner.DataType.FLOAT*/5,/*iflash.laya.runner.DataType.FLOAT*/5,/*iflash.laya.runner.DataType.FLOAT*/5,/*iflash.laya.runner.DataType.FLOAT*/5,/*iflash.laya.runner.DataType.FLOAT*/5,/*iflash.laya.runner.DataType.FLOAT*/5,/*iflash.laya.runner.DataType.FLOAT*/5);
			R.regFunction(/*iflash.laya.runner.DataType.POS*/158,A.pos,4,false,/*iflash.laya.runner.DataType.NULL*/0,/*iflash.laya.runner.DataType.SHORT*/4,/*iflash.laya.runner.DataType.FLOAT*/5,/*iflash.laya.runner.DataType.FLOAT*/5);
			R.regFunction(/*iflash.laya.runner.DataType.EMPTY*/159,A.empty,2,false,/*iflash.laya.runner.DataType.NULL*/0,/*iflash.laya.runner.DataType.NULL*/0);
			R.regFunction(/*iflash.laya.runner.DataType.SET_ALPHA*/160,A.setAlpha,3,false,/*iflash.laya.runner.DataType.CURRENT*/9,/*iflash.laya.runner.DataType.SHORT*/4,/*iflash.laya.runner.DataType.FLOAT*/5);
			R.regFunction(/*iflash.laya.runner.DataType.SET_VISIBLE*/161,A.setVisible,3,false,/*iflash.laya.runner.DataType.CURRENT*/9,/*iflash.laya.runner.DataType.SHORT*/4,/*iflash.laya.runner.DataType.BOOL*/14);
			R.regFunction(/*iflash.laya.runner.DataType.INIT_LYIMAGELEMENT_CMD*/162,A.initLyImage,4,false,/*iflash.laya.runner.DataType.CURRENT*/9,/*iflash.laya.runner.DataType.SHORT*/4,/*iflash.laya.runner.DataType.FLOAT*/5,/*iflash.laya.runner.DataType.FLOAT*/5);
			R.regFunction(/*iflash.laya.runner.DataType.INIT_SHAPE_CMD*/163,A.initShap,3,false,/*iflash.laya.runner.DataType.CURRENT*/9,/*iflash.laya.runner.DataType.ID*/1,/*iflash.laya.runner.DataType.MATRIX*/13);
			R.regFunction(/*iflash.laya.runner.DataType.INIT_SHAPE2ADDCMD*/167,A.initShape2Add,5,false,/*iflash.laya.runner.DataType.CURRENT*/9,/*iflash.laya.runner.DataType.SHORT*/4,/*iflash.laya.runner.DataType.FLOAT*/5,/*iflash.laya.runner.DataType.FLOAT*/5,/*iflash.laya.runner.DataType.MATRIX*/13);
			R.regFunction(/*iflash.laya.runner.DataType.INIT_MOVIECLIP_CMD*/164,A.initMovie,6,false,/*iflash.laya.runner.DataType.CURRENT*/9,/*iflash.laya.runner.DataType.TEMPLATE_ID*/11,/*iflash.laya.runner.DataType.BYTE*/8,/*iflash.laya.runner.DataType.BYTE*/8,/*iflash.laya.runner.DataType.SHORT*/4,/*iflash.laya.runner.DataType.ARRAY*/12);
			R.regFunction(/*iflash.laya.runner.DataType.INIT_BUTTON_CMD*/166,A.initButton,6,false,/*iflash.laya.runner.DataType.CURRENT*/9,/*iflash.laya.runner.DataType.TEMPLATE_ID*/11,/*iflash.laya.runner.DataType.BYTE*/8,/*iflash.laya.runner.DataType.BYTE*/8,/*iflash.laya.runner.DataType.SHORT*/4,/*iflash.laya.runner.DataType.ARRAY*/12);
			R.regFunction(/*iflash.laya.runner.DataType.INIT_TEXTFIELD_CMD*/165,A.initText,14,false,/*iflash.laya.runner.DataType.CURRENT*/9,
			/*iflash.laya.runner.DataType.FLOAT*/5,/*iflash.laya.runner.DataType.FLOAT*/5,/*iflash.laya.runner.DataType.FLOAT*/5,/*iflash.laya.runner.DataType.FLOAT*/5,/*iflash.laya.runner.DataType.FLOAT*/5,/*iflash.laya.runner.DataType.FLOAT*/5,
			/*iflash.laya.runner.DataType.BOOL*/14,/*iflash.laya.runner.DataType.BOOL*/14,/*iflash.laya.runner.DataType.BOOL*/14,
			/*iflash.laya.runner.DataType.BYTE*/8,/*iflash.laya.runner.DataType.STRING*/6,/*iflash.laya.runner.DataType.FLOAT*/5,/*iflash.laya.runner.DataType.STRING*/6);
			R.regFunction(/*iflash.laya.runner.DataType.INIT_STATICTEXTFIELDCMD*/168,A.initStaticText,14,false,/*iflash.laya.runner.DataType.CURRENT*/9,
			/*iflash.laya.runner.DataType.FLOAT*/5,/*iflash.laya.runner.DataType.FLOAT*/5,/*iflash.laya.runner.DataType.FLOAT*/5,/*iflash.laya.runner.DataType.FLOAT*/5,/*iflash.laya.runner.DataType.FLOAT*/5,/*iflash.laya.runner.DataType.FLOAT*/5,
			/*iflash.laya.runner.DataType.BOOL*/14,/*iflash.laya.runner.DataType.BOOL*/14,/*iflash.laya.runner.DataType.BOOL*/14,
			/*iflash.laya.runner.DataType.BYTE*/8,/*iflash.laya.runner.DataType.STRING*/6,/*iflash.laya.runner.DataType.FLOAT*/5,/*iflash.laya.runner.DataType.STRING*/6);
			Laya.window.resizeTo(Browser.window.innerWidth,Browser.window.innerHeight);
			Laya.CONCHVER && /*__JS__ */conchConfig.textBaseline(1);
		}

		IFlash.__StartLoadResource__=function(){
			var len=IFlash.__loadResource__.length;
			for(var i=0;i<len;i++){
				var loader=new Loader();
				loader.contentLoaderInfo.addEventListener(/*iflash.events.Event.COMPLETE*/"complete",IFlash.__onLoad__);
				loader.load(new URLRequest(IFlash.__loadResource__[i]),new LoaderContext(false,ApplicationDomain.currentDomain));
			}
		}

		IFlash.__onLoad__=function(e){
			IFlash.__resourceCount__++;
			if(IFlash.__loadResource__.length==IFlash.__resourceCount__){
				IFlash.__resourceCount__=0;
				IFlash.__loadResource__=null;
				Stage.stage.addChild(IFlash._sprite_);
			}
		}

		IFlash.LoadResource=function(files){
			IFlash.__loadResource__=files;
		}

		IFlash.Run=function(sprite,w,h){
			if(IFlash.__width__ <=0){
				IFlash.__width__=w;
			}
			if(IFlash.__height__ <=0){
				IFlash.__height__=h;
			}
			new IFlash(sprite);
			Laya.ilaya._onInit_();
		}

		IFlash._sprite_=null
		IFlash.__loadResource__=null;
		IFlash.__width__=-1;
		IFlash.__height__=-1;
		IFlash.__beforInit__=null
		IFlash.IS_3D=false;
		IFlash.__bgColor=0xffffff;
		IFlash.__setOrientationEx=1;
		IFlash.__showInfo=true;
		IFlash.__frameRate=60;
		IFlash.__resourceCount__=0;
		IFlash.LYData={};
		return IFlash;
	})(ILaya)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/left/panelleft/vo/panelrectinfonode.as
	//class mvc.left.panelleft.vo.PanelRectInfoNode extends vo.AlighNode
	var PanelRectInfoNode=(function(_super){
		function PanelRectInfoNode(){
			this.type=0;
			this.isui9=false;
			this.selectTab=false;
			this.level=0;
			this.dataItem=null;
			this.sprite=null;
			this.select=false;
			PanelRectInfoNode.__super.call(this);
		}

		__class(PanelRectInfoNode,'mvc.left.panelleft.vo.PanelRectInfoNode',false,_super);
		var __proto=PanelRectInfoNode.prototype;
		__proto.clone=function(){
			var temp=new PanelRectInfoNode();
			temp.name=this.name;
			temp.level=this.level;
			temp.type=this.type;
			temp.isui9=this.isui9;
			temp.dataItem=new Array
			for(var i=0;i<this.dataItem.length;i++){
				temp.dataItem.push(this.dataItem[i])
			}
			temp.rect=this.rect.clone()
			temp.sprite=new PanelRectInfoSprite()
			temp.sprite.panelRectInfoNode=temp
			return temp;
		}

		__proto.readObject=function(){
			var obj=new Object;
			obj.name=this.name;
			obj.level=this.level;
			obj.type=this.type;
			obj.isui9=this.isui9;
			obj.selectTab=this.selectTab;
			obj.dataItem=this.dataItem;
			obj.rect=this.rect;
			return obj;
		}

		__proto.readObjectToH5=function(){
			var obj=new Object;
			obj.name=this.name;
			obj.level=this.level;
			this.isui9=false
			if(this.dataItem[0]){
				var $H5UIFileNode=UiData.getUiNodeByName(this.dataItem[0])
				if($H5UIFileNode&&$H5UIFileNode.type==/*vo.FileInfoType.ui9*/1){
					this.isui9=true
				}
			}
			if(this.type==/*mvc.left.panelleft.vo.PanelRectInfoType.PICTURE*/0){
				if(this.isui9){
					obj.type=1
					}else{
					obj.type=0
				}
			}
			if(this.type==/*mvc.left.panelleft.vo.PanelRectInfoType.BUTTON*/1){
				if(this.isui9){
					obj.type=3
					}else{
					obj.type=2
				}
				obj.selected=this.selectTab;
			}
			obj.dataItem=this.dataItem;
			obj.rect=this.rect;
			return obj;
		}

		__proto.setObject=function($obj){
			this.name=$obj.name;
			this.level=$obj.level;
			this.type=$obj.type;
			this.isui9=$obj.isui9;
			this.selectTab=$obj.selectTab;
			this.dataItem=$obj.dataItem;
			this.rect=new Rectangle;
			this.rect.x=int($obj.rect.x)
			this.rect.y=int($obj.rect.y)
			this.rect.width=int($obj.rect.width)
			this.rect.height=int($obj.rect.height)
		}

		return PanelRectInfoNode;
	})(AlighNode)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/vo/h5uifilenode.as
	//class vo.H5UIFileNode extends vo.AlighNode
	var H5UIFileNode=(function(_super){
		function H5UIFileNode(){
			this.sprite=null;
			this.type=0;
			this.rect9=null;
			this._select=false;
			H5UIFileNode.__super.call(this);
		}

		__class(H5UIFileNode,'vo.H5UIFileNode',false,_super);
		var __proto=H5UIFileNode.prototype;
		__proto.clone=function(){
			var $temp=new H5UIFileNode;
			$temp.rect=this.rect.clone()
			$temp.type=this.type;
			if(this.rect9){
				$temp.rect9=this.rect9.clone()
			}
			return $temp;
		}

		__getset(0,__proto,'select',function(){
			return this._select;
			},function(value){
			this._select=value;
		});

		return H5UIFileNode;
	})(AlighNode)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/h5uifile9mesh.as
	//class mesh.H5UIFile9Mesh extends mesh.H5UIFileMesh
	var H5UIFile9Mesh=(function(_super){
		function H5UIFile9Mesh(){
			this._rect9Size
			H5UIFile9Mesh.__super.call(this);
		}

		__class(H5UIFile9Mesh,'mesh.H5UIFile9Mesh',false,_super);
		var __proto=H5UIFile9Mesh.prototype;
		__getset(0,__proto,'rect9Size',function(){
			return new Point(this._h5UIFileNode.rect9.width,this._h5UIFileNode.rect9.height);
			},function(value){
			this._h5UIFileNode.rect9.width=value.x;
			this._h5UIFileNode.rect9.height=value.y;
			this.change();
		});

		H5UIFile9Mesh.__init$=function(){
			[/*no*/this.Editor(/*no*/this.type="Vec2",/*no*/this.Label="尺寸",/*no*/this.sort="5",/*no*/this.Category="宫格",/*no*/this.Tip="坐标")]
		}

		return H5UIFile9Mesh;
	})(H5UIFileMesh)


	//file:///c:/users/pan/appdata/local/layaflash/tools/lib2.6/libs/iflash/src/iflashmain.as
	//class IFlashMain extends iflash.display.Sprite
	var IFlashMain=(function(_super){
		function IFlashMain(){
			IFlashMain.__super.call(this);
			if (this.stage)this.init();
			else this.addEventListener(/*iflash.events.Event.ADDED_TO_STAGE*/"addedToStage",__bind(this,this.init));
		}

		__class(IFlashMain,'IFlashMain',false,_super);
		var __proto=IFlashMain.prototype;
		__proto.init=function(e){
			this.removeEventListener(/*iflash.events.Event.ADDED_TO_STAGE*/"addedToStage",__bind(this,this.init));
		}

		return IFlashMain;
	})(Sprite)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/left/panelleft/vo/panelrectinfobmp.as
	//class mvc.left.panelleft.vo.PanelRectInfoBmp extends iflash.display.Sprite
	var PanelRectInfoBmp=(function(_super){
		function PanelRectInfoBmp(){
			this._bmp=null;
			this._mc=null;
			this._scale9Grid=null;
			PanelRectInfoBmp.__super.call(this);
			this._bmp=new Bitmap
			this.addChild(this._bmp)
			this._mc=new Sprite;
			this.addChild(this._mc)
		}

		__class(PanelRectInfoBmp,'mvc.left.panelleft.vo.PanelRectInfoBmp',false,_super);
		var __proto=PanelRectInfoBmp.prototype;
		__proto.updata=function(){
			var _panelRectInfoSprite=(this.parent)
			var _panelRectInfoNode=_panelRectInfoSprite.panelRectInfoNode;
			if(_panelRectInfoNode.type==/*mvc.left.panelleft.vo.PanelRectInfoType.PICTURE*/0||_panelRectInfoNode.type==/*mvc.left.panelleft.vo.PanelRectInfoType.BUTTON*/1){
				var $H5UIFileNode=UiData.getUiNodeByName(_panelRectInfoNode.dataItem[0])
				var bmp=UiData.getUIBitmapDataByName(_panelRectInfoNode.dataItem[0]);
				this.clearMc()
				this._bmp.bitmapData=null
				if($H5UIFileNode&&bmp){
					if($H5UIFileNode.type==/*vo.FileInfoType.baseUi*/0){
						this._bmp.bitmapData=bmp;
					}
					if($H5UIFileNode.type==/*vo.FileInfoType.ui9*/1){
						var $rect=new Rectangle();
						$rect.x=$H5UIFileNode.rect9.width
						$rect.y=$H5UIFileNode.rect9.height
						$rect.width=$H5UIFileNode.rect.width-$H5UIFileNode.rect9.width*2
						$rect.height=$H5UIFileNode.rect.height-$H5UIFileNode.rect9.height*2
						this._scale9Grid=new Scale9Grid(bmp,$rect)
						this._mc.addChild(this._scale9Grid)
					}
				}
			}
			this.changeSize()
		}

		__proto.changeSize=function(){
			var _panelRectInfoSprite=(this.parent)
			var _panelRectInfoNode=_panelRectInfoSprite.panelRectInfoNode;
			if(this._scale9Grid){
				this._scale9Grid.width=_panelRectInfoNode.rect.width
				this._scale9Grid.height=_panelRectInfoNode.rect.height
				this._scale9Grid.refresh()
			}
			if(this._bmp.bitmapData){
				this._bmp.width=_panelRectInfoNode.rect.width
				this._bmp.height=_panelRectInfoNode.rect.height
			}
		}

		__proto.clearMc=function(){
			while(this._mc.numChildren){
				this._mc.removeChildAt(0)
			}
		}

		return PanelRectInfoBmp;
	})(Sprite)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/left/panelleft/vo/panelrectinfosprite.as
	//class mvc.left.panelleft.vo.PanelRectInfoSprite extends iflash.display.Sprite
	var PanelRectInfoSprite=(function(_super){
		function PanelRectInfoSprite(){
			this._bg=null;
			this._line=null;
			this._moveBut=null;
			this._wText=null;
			this._hText=null;
			this._panelRectInfoBmp=null;
			this._mouseDown=false;
			this.panelRectInfoNode
			this._lastPoint
			PanelRectInfoSprite.__super.call(this);
			this._panelRectInfoBmp=new PanelRectInfoBmp;
			this.addChild(this._panelRectInfoBmp)
			this._bg=new Sprite;
			this.addChild(this._bg);
			this._line=new Sprite;
			this.addChild(this._line);
			this._moveBut=new Sprite();
			this.addChild(this._moveBut)
			this._moveBut.graphics.clear();
			this._moveBut.graphics.beginFill(0x000000,1)
			this._moveBut.graphics.moveTo(10,10)
			this._moveBut.graphics.lineTo(10,0)
			this._moveBut.graphics.lineTo(0,10)
			this._moveBut.graphics.lineTo(10,10)
			this._moveBut.graphics.endFill();
			this.addwText();
			this.addhText();
			this.addEventListener(/*iflash.events.Event.ADDED_TO_STAGE*/"addedToStage",__bind(this,this.addToStage))
		}

		__class(PanelRectInfoSprite,'mvc.left.panelleft.vo.PanelRectInfoSprite',false,_super);
		var __proto=PanelRectInfoSprite.prototype;
		__proto.addwText=function(){
			this._wText=new TextField;
			var _txtform=new TextFormat();
			_txtform.align=com.greensock.layout.AlignMode.CENTER
			_txtform.font="Microsoft Yahei"
			_txtform.color=0x9c9c9c
			_txtform.size=10
			_txtform.leading=0
			this._wText.defaultTextFormat=_txtform;
			this._wText.type=/*iflash.text.TextFieldType.DYNAMIC*/"dynamic";
			this._wText.wordWrap=true
			this._wText.multiline=true
			this._wText.height=17
			this._wText.width=30
			this.addChild(this._wText)
			this._wText.mouseEnabled=false;
		}

		__proto.addhText=function(){
			this._hText=new TextField;
			var _txtform=new TextFormat();
			_txtform.align=com.greensock.layout.AlignMode.CENTER
			_txtform.font="Microsoft Yahei"
			_txtform.color=0x9c9c9c
			_txtform.size=10
			_txtform.leading=0
			this._hText.defaultTextFormat=_txtform;
			this._hText.type=/*iflash.text.TextFieldType.DYNAMIC*/"dynamic";
			this._hText.wordWrap=true
			this._hText.multiline=true
			this._hText.height=17
			this._hText.width=30
			this.addChild(this._hText)
			this._hText.mouseEnabled=false;
		}

		__proto.addToStage=function(event){
			this.addEvents();
		}

		__proto.addEvents=function(){
			this._bg.addEventListener(/*iflash.events.MouseEvent.MOUSE_DOWN*/"mouseDown",__bind(this,this.onBgMouseDown))
			this._moveBut.addEventListener(/*iflash.events.MouseEvent.MOUSE_DOWN*/"mouseDown",__bind(this,this.onmoveButMouseDown))
			this.stage.addEventListener(/*iflash.events.MouseEvent.MOUSE_MOVE*/"mouseMove",__bind(this,this.onStageMouseMove))
			this.stage.addEventListener(/*iflash.events.MouseEvent.MOUSE_UP*/"mouseUp",__bind(this,this.onStageMouseUp))
			this.addEventListener(/*iflash.events.MouseEvent.CLICK*/"click",__bind(this,this.onInfoSpriteClik))
		}

		__proto.onBgMouseDown=function(event){
			if(this.panelRectInfoNode.select&&!event.ctrlKey&&!event.shiftKey){
				com.zcp.frame.event.ModuleEventManager.dispatchEvent(new PanelCentenEvent(/*mvc.centen.panelcenten.PanelCentenEvent.PANEL_RECT_INFO_START_MOVE*/"PANEL_RECT_INFO_START_MOVE"));
			}
		}

		__proto.onInfoSpriteClik=function(event){
			if(!this.panelRectInfoNode.select||event.ctrlKey||event.shiftKey){
				var $CentenEvent=new PanelCentenEvent(/*mvc.centen.panelcenten.PanelCentenEvent.SELECT_PANEL_INFO_NODE*/"SELECT_PANEL_INFO_NODE")
				$CentenEvent.panelRectInfoNode=this.panelRectInfoNode;
				$CentenEvent.ctrlKey=event.ctrlKey;
				$CentenEvent.shiftKey=event.shiftKey;
				com.zcp.frame.event.ModuleEventManager.dispatchEvent($CentenEvent);
			}
		}

		__proto.onStageMouseUp=function(event){
			if(this._mouseDown){
				this._mouseDown=false;
			}
		}

		__proto.onStageMouseMove=function(event){
			if(this._mouseDown){
				var w=Math.max(10,this.mouseX+this._lastPoint.x);
				var h=Math.max(5,this.mouseY+this._lastPoint.y);
				this.panelRectInfoNode.rect.width=w;
				this.panelRectInfoNode.rect.height=h;
				this.changeSize()
				com.zcp.frame.event.ModuleEventManager.dispatchEvent(new PanelCentenEvent(/*mvc.centen.panelcenten.PanelCentenEvent.REFRESH_PANEL_RECT_INFO_SIZE_VIEW*/"REFRESH_PANEL_RECT_INFO_SIZE_VIEW"));
			}
		}

		__proto.changeSize=function(){
			this.x=this.panelRectInfoNode.rect.x
			this.y=this.panelRectInfoNode.rect.y
			this.drawBack();
			this._panelRectInfoBmp.changeSize()
		}

		__proto.onmoveButMouseDown=function(event){
			this._mouseDown=true
			this._lastPoint=new Point(this.panelRectInfoNode.rect.width-this.mouseX,this.panelRectInfoNode.rect.height-this.mouseY);
		}

		__proto.drawBack=function(){
			this._bg.graphics.clear();
			if(this.panelRectInfoNode.select){
				this._bg.graphics.beginFill(0xff0000,0.20);
				}else{
				this._bg.graphics.beginFill(0x000000,0.01);
			}
			this._bg.graphics.drawRect(0,0,this.panelRectInfoNode.rect.width,this.panelRectInfoNode.rect.height);
			this._line.graphics.clear();
			this._line.graphics.lineStyle(1,0xff00ff,0.5);
			this._line.graphics.moveTo(0,0);
			this._line.graphics.lineTo(this.panelRectInfoNode.rect.width,0);
			this._line.graphics.lineTo(this.panelRectInfoNode.rect.width,this.panelRectInfoNode.rect.height);
			this._line.graphics.lineTo(0,this.panelRectInfoNode.rect.height);
			this._line.graphics.lineTo(0,0);
			this._moveBut.x=this.panelRectInfoNode.rect.width-10;
			this._moveBut.y=this.panelRectInfoNode.rect.height-10;
			this._wText.text=String(this.panelRectInfoNode.rect.width)
			this._wText.x=this.panelRectInfoNode.rect.width/2-15
			this._wText.y=0
			this._hText.text=String(this.panelRectInfoNode.rect.height)
			this._hText.x=0
			this._hText.y=this.panelRectInfoNode.rect.height/2-10;
			if(Math.min(this.panelRectInfoNode.rect.width,this.panelRectInfoNode.rect.height)>50){
				this._wText.visible=true
				this._hText.visible=true
				}else{
				this._wText.visible=false
				this._hText.visible=false
			}
		}

		__proto.updata=function(){
			this.x=this.panelRectInfoNode.rect.x
			this.y=this.panelRectInfoNode.rect.y
			this.drawBack()
			this._panelRectInfoBmp.updata();
		}

		return PanelRectInfoSprite;
	})(Sprite)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/left/panelleft/vo/scale9grid.as
	//class mvc.left.panelleft.vo.Scale9Grid extends iflash.display.Sprite
	var Scale9Grid=(function(_super){
		function Scale9Grid(bmd,s9d){
			this._invalidate=false;
			this._top_left_bmp=null;
			this._top_bmp=null;
			this._top_right_bmp=null;
			this._right_bmp=null;
			this._bottom_right_bmp=null;
			this._bottom_bmp=null;
			this._botton_left_bmp=null;
			this._left_bmp=null;
			this._center_bmp=null;
			this._s9d=null;
			this._bmd=null;
			this._w=NaN;
			this._minW=NaN;
			this._h=NaN;
			this._minH=NaN;
			this.despoint=new Point();
			Scale9Grid.__super.call(this);
			this._bmd=bmd;
			this._w=bmd.width;
			this._h=bmd.height;
			this.checkS9d(s9d);
			this._s9d=s9d;
			this._minW=(this._s9d.x+(this._bmd.width-this._s9d.right)+1);
			this._minH=(this._s9d.y+(this._bmd.height-this._s9d.bottom)+1);
			this.cutBmd();
			this.refresh();
		}

		__class(Scale9Grid,'mvc.left.panelleft.vo.Scale9Grid',false,_super);
		var __proto=Scale9Grid.prototype;
		__proto.invalidate=function(){
			this._invalidate=true;
			this.removeEventListener(/*iflash.events.Event.RENDER*/"render",__bind(this,this.onRender));
			this.addEventListener(/*iflash.events.Event.RENDER*/"render",__bind(this,this.onRender));
		}

		__proto.refresh=function(){
			this._invalidate=false;
			this.refreshSize();
			this.layoutBmps();
		}

		__proto.onRender=function(event){
			if(!this._invalidate)return;
			this.removeEventListener(/*iflash.events.Event.RENDER*/"render",__bind(this,this.onRender));
			this.refresh();
		}

		__proto.layoutBmps=function(){
			this._center_bmp.x=this._s9d.x;
			this._center_bmp.y=this._s9d.y;
			var centerRect=this._center_bmp.getRect(this);
			this._top_left_bmp.x=0;
			this._top_left_bmp.y=0;
			this._top_bmp.x=this._s9d.x;
			this._top_bmp.y=0;
			this._top_right_bmp.x=centerRect.right;
			this._top_right_bmp.y=0;
			this._right_bmp.x=centerRect.right;
			this._right_bmp.y=this._s9d.y;
			this._bottom_right_bmp.x=centerRect.right;
			this._bottom_right_bmp.y=centerRect.bottom;
			this._bottom_bmp.x=this._s9d.x;
			this._bottom_bmp.y=centerRect.bottom;
			this._botton_left_bmp.x=0;
			this._botton_left_bmp.y=centerRect.bottom;
			this._left_bmp.x=0;
			this._left_bmp.y=this._s9d.y;
		}

		__proto.refreshSize=function(){
			var tw=this._w-(this._left_bmp.width+this._right_bmp.width);
			var th=this._h-(this._top_bmp.height+this._bottom_bmp.height);
			this._top_bmp.width=tw;
			this._bottom_bmp.width=tw;
			this._left_bmp.height=th;
			this._right_bmp.height=th;
			this._center_bmp.width=tw;
			this._center_bmp.height=th;
		}

		__proto.cutBmd=function(){
			var rect;
			rect=new Rectangle(0,0,this._s9d.x,this._s9d.y);
			var top_left_bmd=new BitmapData(rect.width,rect.height,true,0);
			top_left_bmd.copyPixels(this._bmd,rect,this.despoint);
			this._top_left_bmp=new Bitmap(top_left_bmd);
			this.addChild(this._top_left_bmp);
			rect.x=this._s9d.x;
			rect.y=0;
			rect.width=this._s9d.width;
			rect.height=this._s9d.y;
			var top_bmd=new BitmapData(rect.width,rect.height,true,0);
			top_bmd.copyPixels(this._bmd,rect,this.despoint);
			this._top_bmp=new Bitmap(top_bmd);
			this.addChild(this._top_bmp);
			rect.x=this._s9d.right;
			rect.y=0;
			rect.width=this._bmd.width-this._s9d.right;
			rect.height=this._s9d.y;
			var top_right_bmd=new BitmapData(rect.width,rect.height,true,0);
			top_right_bmd.copyPixels(this._bmd,rect,this.despoint);
			this._top_right_bmp=new Bitmap(top_right_bmd);
			this.addChild(this._top_right_bmp);
			rect.x=this._s9d.right;
			rect.y=this._s9d.y;
			rect.width=this._bmd.width-this._s9d.right;
			rect.height=this._s9d.height;
			var right_bmd=new BitmapData(rect.width,rect.height,true,0);
			right_bmd.copyPixels(this._bmd,rect,this.despoint);
			this._right_bmp=new Bitmap(right_bmd);
			this.addChild(this._right_bmp);
			rect.x=this._s9d.right;
			rect.y=this._s9d.bottom;
			rect.width=this._bmd.width-this._s9d.right;
			rect.height=this._bmd.height-this._s9d.bottom;
			var bottom_right_bmd=new BitmapData(rect.width,rect.height,true,0);
			bottom_right_bmd.copyPixels(this._bmd,rect,this.despoint);
			this._bottom_right_bmp=new Bitmap(bottom_right_bmd);
			this.addChild(this._bottom_right_bmp);
			rect.x=this._s9d.x;
			rect.y=this._s9d.bottom;
			rect.width=this._s9d.width;
			rect.height=this._bmd.height-this._s9d.bottom;
			var botton_bmd=new BitmapData(rect.width,rect.height,true,0);
			botton_bmd.copyPixels(this._bmd,rect,this.despoint);
			this._bottom_bmp=new Bitmap(botton_bmd);
			this.addChild(this._bottom_bmp);
			rect.x=0;
			rect.y=this._s9d.bottom;
			rect.width=this._s9d.x;
			rect.height=this._bmd.height-this._s9d.bottom;
			var botton_left_bmd=new BitmapData(rect.width,rect.height,true,0);
			botton_left_bmd.copyPixels(this._bmd,rect,this.despoint);
			this._botton_left_bmp=new Bitmap(botton_left_bmd);
			this.addChild(this._botton_left_bmp);
			rect.x=0;
			rect.y=this._s9d.y;
			rect.width=this._s9d.x;
			rect.height=this._s9d.height;
			var left_bmd=new BitmapData(rect.width,rect.height,true,0);
			left_bmd.copyPixels(this._bmd,rect,this.despoint);
			this._left_bmp=new Bitmap(left_bmd);
			this.addChild(this._left_bmp);
			var center_bmd=new BitmapData(this._s9d.width,this._s9d.height,true,0);
			center_bmd.copyPixels(this._bmd,this._s9d,this.despoint);
			this._center_bmp=new Bitmap(center_bmd);
			this.addChild(this._center_bmp);
		}

		__proto.checkS9d=function(s9d){
			s9d.x=Math.floor(s9d.x);
			s9d.y=Math.floor(s9d.y);
			s9d.width=Math.ceil(s9d.width);
			s9d.height=Math.ceil(s9d.height);
			var error=false;
			var errorMsg='';
			if(s9d.x<1){
				error=true;
				errorMsg+='s9d.x<1';
			}
			if(s9d.y<1){
				error=true;
				errorMsg+='s9d.y<1';
			}
			if((s9d.x+s9d.width)>(this.bmd.width-1)){
				error=true;
				errorMsg+='(s9d.x+s9d.width)>(bmd.width-1)';
			}
			if((s9d.y+s9d.height)>(this.bmd.height-1)){
				error=true;
				errorMsg+='(s9d.y+s9d.height)>(bmd.height-1)';
			}
			if(error)
				throw new Error("s9d error!!!:\n"+errorMsg);
		}

		__getset(0,__proto,'bmd',function(){
			return this._bmd;
		});

		__getset(0,__proto,'width',function(){
			return this._w;
			},function(value){
			if(this._w!=value){
				this._w=value;
				if(this._w<this._minW)this._w=this._minW;
				this.invalidate();
			}
		});

		__getset(0,__proto,'height',function(){
			return this._h;
			},function(value){
			if(this._h!=value){
				this._h=value;
				if(this._h<this._minH)this._h=this._minH;
				this.invalidate();
			}
		});

		return Scale9Grid;
	})(Sprite)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/vo/filedatasprite.as
	//class vo.FileDataSprite extends iflash.display.Sprite
	var FileDataSprite=(function(_super){
		function FileDataSprite(){
			this._bitmap=null;
			this._menuFile=null;
			this._fileDataVo
			FileDataSprite.__super.call(this);
			this._bitmap=new Bitmap()
			this.addChild(this._bitmap);
			this.addEvents();
			this.initMenuFile()
		}

		__class(FileDataSprite,'vo.FileDataSprite',false,_super);
		var __proto=FileDataSprite.prototype;
		__proto.addEvents=function(){
			this.addEventListener(/*iflash.events.MouseEvent.MOUSE_DOWN*/"mouseDown",__bind(this,this.onMouseDown))
			this.addEventListener(/*iflash.events.MouseEvent.MOUSE_UP*/"mouseUp",__bind(this,this.onMouseUp))
			this.addEventListener(/*iflash.events.MouseEvent.RIGHT_CLICK*/"rightClick",__bind(this,this.onRightClick));
		}

		__proto.onMouseUp=function(event){
			this._fileDataVo.rect.x=this.x
			this._fileDataVo.rect.y=this.y
			this.stopDrag();
		}

		__proto.onRightClick=function(event){
			this._menuFile.display(this.stage,this.stage.mouseX,this.stage.mouseY);
		}

		__proto.initMenuFile=function(){
			this._menuFile=new NativeMenu;
			var newtypefile=new NativeMenu;
			var item;
			item=new NativeMenuItem("删除")
			this._menuFile.addItem(item);
			item.addEventListener(/*iflash.events.Event.SELECT*/"select",__bind(this,this.onDele));
		}

		__proto.onDele=function(event){
			this._fileDataVo.dele=true
			this.parent.removeChild(this)
		}

		__proto.onMouseDown=function(event){
			this.startDrag()
		}

		__getset(0,__proto,'fileDataVo',function(){
			return this._fileDataVo;
			},function(value){
			this._fileDataVo=value;
		});

		__getset(0,__proto,'bitmapData',null,function(value){
			this._bitmap.bitmapData=value;
		});

		return FileDataSprite;
	})(Sprite)


	//file:///c:/users/pan/desktop/workspace/uieditor/src/vo/infodatasprite.as
	//class vo.InfoDataSprite extends iflash.display.Sprite
	var InfoDataSprite=(function(_super){
		function InfoDataSprite(){
			this._bg=null;
			this._line=null;
			this._moveBut=null;
			this._wText=null;
			this._hText=null;
			this._mouseDown=false;
			this.h5UIFileNode
			this._lastPoint
			InfoDataSprite.__super.call(this);
			this._bg=new Sprite;
			this.addChild(this._bg);
			this._line=new Sprite;
			this.addChild(this._line);
			this._moveBut=new Sprite();
			this.addChild(this._moveBut)
			this._moveBut.graphics.clear();
			this._moveBut.graphics.beginFill(0x000000,1)
			this._moveBut.graphics.moveTo(10,10)
			this._moveBut.graphics.lineTo(10,0)
			this._moveBut.graphics.lineTo(0,10)
			this._moveBut.graphics.lineTo(10,10)
			this._moveBut.graphics.endFill();
			this.addwText();
			this.addhText();
			this.addEventListener(/*iflash.events.Event.ADDED_TO_STAGE*/"addedToStage",__bind(this,this.addToStage))
		}

		__class(InfoDataSprite,'vo.InfoDataSprite',false,_super);
		var __proto=InfoDataSprite.prototype;
		__proto.addwText=function(){
			this._wText=new TextField;
			var _txtform=new TextFormat();
			_txtform.align=com.greensock.layout.AlignMode.CENTER
			_txtform.font="Microsoft Yahei"
			_txtform.color=0x9c9c9c
			_txtform.size=10
			_txtform.leading=0
			this._wText.defaultTextFormat=_txtform;
			this._wText.type=/*iflash.text.TextFieldType.DYNAMIC*/"dynamic";
			this._wText.wordWrap=true
			this._wText.multiline=true
			this._wText.height=17
			this._wText.width=30
			this.addChild(this._wText)
			this._wText.mouseEnabled=false;
		}

		__proto.addhText=function(){
			this._hText=new TextField;
			var _txtform=new TextFormat();
			_txtform.align=com.greensock.layout.AlignMode.CENTER
			_txtform.font="Microsoft Yahei"
			_txtform.color=0x9c9c9c
			_txtform.size=10
			_txtform.leading=0
			this._hText.defaultTextFormat=_txtform;
			this._hText.type=/*iflash.text.TextFieldType.DYNAMIC*/"dynamic";
			this._hText.wordWrap=true
			this._hText.multiline=true
			this._hText.height=17
			this._hText.width=30
			this.addChild(this._hText)
			this._hText.mouseEnabled=false;
		}

		__proto.addToStage=function(event){
			this.addEvents();
		}

		__proto.addEvents=function(){
			this._bg.addEventListener(/*iflash.events.MouseEvent.MOUSE_DOWN*/"mouseDown",__bind(this,this.onBgMouseDown))
			this._moveBut.addEventListener(/*iflash.events.MouseEvent.MOUSE_DOWN*/"mouseDown",__bind(this,this.onmoveButMouseDown))
			this.stage.addEventListener(/*iflash.events.MouseEvent.MOUSE_MOVE*/"mouseMove",__bind(this,this.onStageMouseMove))
			this.stage.addEventListener(/*iflash.events.MouseEvent.MOUSE_UP*/"mouseUp",__bind(this,this.onStageMouseUp))
			this.addEventListener(/*iflash.events.MouseEvent.CLICK*/"click",__bind(this,this.onInfoSpriteClik))
		}

		__proto.onBgMouseDown=function(event){
			if(this.h5UIFileNode.select&&!event.ctrlKey&&!event.shiftKey){
				com.zcp.frame.event.ModuleEventManager.dispatchEvent(new UiSceneEvent(/*mvc.scene.UiSceneEvent.START_MOVE_NODE_INFO*/"START_MOVE_NODE_INFO"));
			}
		}

		__proto.onInfoSpriteClik=function(event){
			if(!this.h5UIFileNode.select||event.ctrlKey||event.shiftKey){
				var $CentenEvent=new UiSceneEvent(/*mvc.scene.UiSceneEvent.SELECT_INFO_NODE*/"SELECT_INFO_NODE")
				$CentenEvent.h5UIFileNode=this.h5UIFileNode;
				$CentenEvent.ctrlKey=event.ctrlKey;
				$CentenEvent.shiftKey=event.shiftKey;
				com.zcp.frame.event.ModuleEventManager.dispatchEvent($CentenEvent);
			}
		}

		__proto.onStageMouseUp=function(event){
			if(this._mouseDown){
				this._mouseDown=false;
				HistoryModel.getInstance().saveSeep()
			}
		}

		__proto.onStageMouseMove=function(event){
			if(this._mouseDown){
				var w=Math.max(10,this.mouseX+this._lastPoint.x);
				var h=Math.max(5,this.mouseY+this._lastPoint.y);
				this.h5UIFileNode.rect.width=w;
				this.h5UIFileNode.rect.height=h;
				this.drawBack();
				com.zcp.frame.event.ModuleEventManager.dispatchEvent(new DisCentenEvent(/*mvc.centen.discenten.DisCentenEvent.REFRESH_SELECT_FILENODE*/"REFRESH_SELECT_FILENODE"));
			}
		}

		__proto.onmoveButMouseDown=function(event){
			this._mouseDown=true
			this._lastPoint=new Point(this.h5UIFileNode.rect.width-this.mouseX,this.h5UIFileNode.rect.height-this.mouseY);
		}

		__proto.drawBack=function(){
			this._bg.graphics.clear();
			if(this.h5UIFileNode.select){
				this._bg.graphics.beginFill(0xff0000,0.20);
				}else{
				this._bg.graphics.beginFill(0x000000,0.01);
			}
			this._bg.graphics.drawRect(0,0,this.h5UIFileNode.rect.width,this.h5UIFileNode.rect.height);
			this._line.graphics.clear();
			this._line.graphics.lineStyle(1,0xff00ff,0.5);
			this._line.graphics.moveTo(0,0);
			this._line.graphics.lineTo(this.h5UIFileNode.rect.width,0);
			this._line.graphics.lineTo(this.h5UIFileNode.rect.width,this.h5UIFileNode.rect.height);
			this._line.graphics.lineTo(0,this.h5UIFileNode.rect.height);
			this._line.graphics.lineTo(0,0);
			if(this.h5UIFileNode.type==/*vo.FileInfoType.ui9*/1){
				this.draw9Line();
			}
			this.drawDiandian(new Point(0,5),new Point(this.h5UIFileNode.rect.width/2-20,5))
			this._moveBut.x=this.h5UIFileNode.rect.width-10;
			this._moveBut.y=this.h5UIFileNode.rect.height-10;
			this._wText.text=String(this.h5UIFileNode.rect.width)
			this._wText.x=this.h5UIFileNode.rect.width/2-15
			this._wText.y=0
			this._hText.text=String(this.h5UIFileNode.rect.height)
			this._hText.x=0
			this._hText.y=this.h5UIFileNode.rect.height/2-10;
			if(Math.min(this.h5UIFileNode.rect.width,this.h5UIFileNode.rect.height)>50){
				this._wText.visible=true
				this._hText.visible=true
				}else{
				this._wText.visible=false
				this._hText.visible=false
			}
		}

		__proto.draw9Line=function(){
			var w9=this.h5UIFileNode.rect9.width;
			var h9=this.h5UIFileNode.rect9.height
			this.drawTemp9Line(new Rectangle(0,0,w9,h9))
			this.drawTemp9Line(new Rectangle(this.h5UIFileNode.rect.width-w9,0,w9,h9))
			this.drawTemp9Line(new Rectangle(this.h5UIFileNode.rect.width-w9,this.h5UIFileNode.rect.height-h9,w9,h9))
			this.drawTemp9Line(new Rectangle(0,this.h5UIFileNode.rect.height-h9,w9,h9))
		}

		__proto.drawTemp9Line=function($rect){
			this._line.graphics.lineStyle(1,0xffff00,0.5);
			this._line.graphics.moveTo(0+$rect.x,0+$rect.y);
			this._line.graphics.lineTo($rect.width+$rect.x,0+$rect.y);
			this._line.graphics.lineTo($rect.width+$rect.x,$rect.height+$rect.y);
			this._line.graphics.lineTo(0+$rect.x,$rect.height+$rect.y);
			this._line.graphics.lineTo(0+$rect.x,0+$rect.y);
			this._line.graphics.lineTo($rect.width+$rect.x,$rect.height+$rect.y);
			this._line.graphics.lineTo(0+$rect.x,$rect.height+$rect.y);
			this._line.graphics.lineTo($rect.width+$rect.x,0+$rect.y);
		}

		__proto.drawDiandian=function(a,b){
			return;
			this._line.graphics.moveTo(a.x,a.y)
			this._line.graphics.lineTo(b.x,b.y)
		}

		__proto.updata=function(){
			this.x=this.h5UIFileNode.rect.x
			this.y=this.h5UIFileNode.rect.y
			this.drawBack()
		}

		return InfoDataSprite;
	})(Sprite)


	window.Fns = {};
	iflash.utils.flash_proxy=null;
	iflash.net.classDic={};
	Laya.__init([Browser,HistoryModel,H5UIFileMesh,H5UIFile9Mesh,PanelRectInfoPictureMesh,H5UIGroupMesh,PanelRectGroupMesh,PanelSceneMesh,PanelRectInfoButtonMesh]);
	Laya.Main(function(){});



/*
1 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/h5uimetadataview.as (12):warning:mesh.H5UIMetaDataView extends common.utils.frame.MetaDataView,This class  is not defined;
2 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/ui/alignrect.as (14):warning:mesh.ui.AlignRect extends common.utils.frame.BaseComponent,This class  is not defined;
3 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/ui/alignrect.as (233):warning:target This variable is not defined, the engine could be the cause。
4 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/ui/alignrect.as (233):warning:FunKey This variable is not defined, the engine could be the cause。
5 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/ui/alignrect.as (475):warning:target This variable is not defined, the engine could be the cause。
6 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/ui/alignrect.as (475):warning:FunKey This variable is not defined, the engine could be the cause。
7 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/ui/alignrect.as (476):warning:target This variable is not defined, the engine could be the cause。
8 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/ui/alignrect.as (476):warning:FunKey This variable is not defined, the engine could be the cause。
9 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/ui/nodeiconlabel.as (22):warning:mesh.ui.NodeIconLabel extends mx.core.UIComponent,This class  is not defined;
10 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/ui/nodeuitreeitemrenderer.as (14):warning:mesh.ui.NodeUiTreeItemRenderer extends mx.controls.treeClasses.TreeItemRenderer,This class  is not defined;
11 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/ui/panelpictureui.as (22):warning:mesh.ui.PanelPictureUI extends common.utils.frame.BaseComponent,This class  is not defined;
12 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/ui/panelpictureui.as (39):warning:baseWidth This variable is not defined, the engine could be the cause。
13 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/ui/panelpictureui.as (48):warning:baseWidth This variable is not defined, the engine could be the cause。
14 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/ui/panelpictureui.as (56):warning:baseWidth This variable is not defined, the engine could be the cause。
15 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/ui/panelpictureui.as (71):warning:baseWidth This variable is not defined, the engine could be the cause。
16 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/ui/panelpictureui.as (72):warning:baseWidth This variable is not defined, the engine could be the cause。
17 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/ui/panelpictureui.as (178):warning:target This variable is not defined, the engine could be the cause。
18 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/ui/panelpictureui.as (178):warning:FunKey This variable is not defined, the engine could be the cause。
19 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/ui/panelpictureui.as (192):warning:target This variable is not defined, the engine could be the cause。
20 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/ui/panelpictureui.as (192):warning:FunKey This variable is not defined, the engine could be the cause。
21 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/ui/panelpictureui.as (193):warning:target This variable is not defined, the engine could be the cause。
22 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/ui/panelpictureui.as (193):warning:FunKey This variable is not defined, the engine could be the cause。
23 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/ui/panelpictureui.as (88):warning:baseWidth This variable is not defined, the engine could be the cause。
24 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/ui/panelpictureui.as (90):warning:baseWidth This variable is not defined, the engine could be the cause。
25 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/ui/uiitempanel.as (18):warning:mesh.ui.UiItemPanel extends common.utils.frame.BasePanel,This class  is not defined;
26 file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/centen/discenten/bmplevel.as (13):warning:mvc.centen.discenten.BmpLevel extends mx.core.UIComponent,This class  is not defined;
27 file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/centen/discenten/discentenevent.as (6):warning:mvc.centen.discenten.DisCentenEvent extends com.zcp.frame.event.ModuleEvent,This class  is not defined;
28 file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/centen/discenten/discentenmodule.as (4):warning:mvc.centen.discenten.DisCentenModule extends com.zcp.frame.Module,This class  is not defined;
29 file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/centen/discenten/discentenpanel.as (11):warning:mvc.centen.discenten.DisCentenPanel extends common.utils.frame.BasePanel,This class  is not defined;
30 file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/centen/discenten/discentenprocessor.as (52):warning:mvc.centen.discenten.DisCentenProcessor extends com.zcp.frame.Processor,This class  is not defined;
31 file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/centen/discenten/infolevel.as (8):warning:mvc.centen.discenten.InfoLevel extends mx.core.UIComponent,This class  is not defined;
32 file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/centen/panelcenten/panelcentenbacksprite.as (12):warning:mvc.centen.panelcenten.PanelCentenBackSprite extends mx.core.UIComponent,This class  is not defined;
33 file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/centen/panelcenten/panelcentenevent.as (6):warning:mvc.centen.panelcenten.PanelCentenEvent extends com.zcp.frame.event.ModuleEvent,This class  is not defined;
34 file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/centen/panelcenten/panelcenteninfolevel.as (7):warning:mvc.centen.panelcenten.PanelCentenInfoLevel extends mx.core.UIComponent,This class  is not defined;
35 file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/centen/panelcenten/panelcentenmodule.as (4):warning:mvc.centen.panelcenten.PanelCentenModule extends com.zcp.frame.Module,This class  is not defined;
36 file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/centen/panelcenten/panelcentenprocessor.as (43):warning:mvc.centen.panelcenten.PanelCentenProcessor extends com.zcp.frame.Processor,This class  is not defined;
37 file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/centen/panelcenten/panelcentenview.as (15):warning:mvc.centen.panelcenten.PanelCentenView extends common.utils.frame.BasePanel,This class  is not defined;
38 file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/left/disleft/disleftevent.as (4):warning:mvc.left.disleft.DisLeftEvent extends com.zcp.frame.event.ModuleEvent,This class  is not defined;
39 file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/left/disleft/disleftmodule.as (4):warning:mvc.left.disleft.DisLeftModule extends com.zcp.frame.Module,This class  is not defined;
40 file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/left/disleft/disleftpanel.as (19):warning:mvc.left.disleft.DisLeftPanel extends common.utils.frame.BasePanel,This class  is not defined;
41 file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/left/disleft/disleftprocessor.as (13):warning:mvc.left.disleft.DisLeftProcessor extends com.zcp.frame.Processor,This class  is not defined;
42 file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/left/panelleft/panelinfoitemrender.as (21):warning:mvc.left.panelleft.PanelInfoItemRender extends mx.controls.treeClasses.TreeItemRenderer,This class  is not defined;
43 file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/left/panelleft/panelleftevent.as (7):warning:mvc.left.panelleft.PanelLeftEvent extends com.zcp.frame.event.ModuleEvent,This class  is not defined;
44 file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/left/panelleft/panelleftmodule.as (4):warning:mvc.left.panelleft.PanelLeftModule extends com.zcp.frame.Module,This class  is not defined;
45 file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/left/panelleft/panelleftpanel.as (28):warning:mvc.left.panelleft.PanelLeftPanel extends common.utils.frame.BasePanel,This class  is not defined;
46 file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/left/panelleft/panelleftprocessor.as (17):warning:mvc.left.panelleft.PanelLeftProcessor extends com.zcp.frame.Processor,This class  is not defined;
47 file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/left/panelleft/panellistitemrenderer.as (21):warning:mvc.left.panelleft.PanelListItemRenderer extends mx.controls.treeClasses.TreeItemRenderer,This class  is not defined;
48 file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/left/panelleft/vo/panelnodevo.as (8):warning:mvc.left.panelleft.vo.PanelNodeVo extends common.utils.ui.file.FileNode,This class  is not defined;
49 file:///c:/users/pan/desktop/workspace/uieditor/src/vo/alighnode.as (6):warning:vo.AlighNode extends common.utils.ui.file.FileNode,This class  is not defined;
50 file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/project/projectevent.as (4):warning:mvc.project.ProjectEvent extends com.zcp.frame.event.ModuleEvent,This class  is not defined;
51 file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/project/projectmodule.as (4):warning:mvc.project.ProjectModule extends com.zcp.frame.Module,This class  is not defined;
52 file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/project/projectprocessor.as (19):warning:mvc.project.ProjectProcessor extends com.zcp.frame.Processor,This class  is not defined;
53 file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/scene/uisceneevent.as (6):warning:mvc.scene.UiSceneEvent extends com.zcp.frame.event.ModuleEvent,This class  is not defined;
54 file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/scene/uiscenemodule.as (4):warning:mvc.scene.UiSceneModule extends com.zcp.frame.Module,This class  is not defined;
55 file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/scene/uiscenepanel.as (11):warning:mvc.scene.UiScenePanel extends common.utils.frame.BasePanel,This class  is not defined;
56 file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/scene/uisceneprocessor.as (21):warning:mvc.scene.UiSceneProcessor extends com.zcp.frame.Processor,This class  is not defined;
57 file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/top/topevent.as (4):warning:mvc.top.TopEvent extends com.zcp.frame.event.ModuleEvent,This class  is not defined;
58 file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/top/topmodule.as (4):warning:mvc.top.TopModule extends com.zcp.frame.Module,This class  is not defined;
59 file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/top/toppanel.as (6):warning:mvc.top.TopPanel extends common.utils.frame.BasePanel,This class  is not defined;
60 file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/top/topprocessor.as (6):warning:mvc.top.TopProcessor extends com.zcp.frame.Processor,This class  is not defined;
61 file:///c:/users/pan/desktop/workspace/uieditor/src/mvc/top/topprocessor.as (36):warning:TopMenuView This variable is not defined, the engine could be the cause。
62 file:///c:/users/pan/desktop/workspace/uieditor/src/vo/listtreeitemrenderer.as (24):warning:vo.ListTreeItemRenderer extends mx.controls.treeClasses.TreeItemRenderer,This class  is not defined;
63 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/h5uifilemesh.as (26):warning:Editor This variable is not defined, the engine could be the cause。
64 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/h5uifilemesh.as (26):warning:type This variable is not defined, the engine could be the cause。
65 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/h5uifilemesh.as (26):warning:Label This variable is not defined, the engine could be the cause。
66 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/h5uifilemesh.as (26):warning:sort This variable is not defined, the engine could be the cause。
67 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/h5uifilemesh.as (26):warning:Category This variable is not defined, the engine could be the cause。
68 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/h5uifilemesh.as (26):warning:Tip This variable is not defined, the engine could be the cause。
69 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/h5uifilemesh.as (43):warning:Editor This variable is not defined, the engine could be the cause。
70 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/h5uifilemesh.as (43):warning:type This variable is not defined, the engine could be the cause。
71 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/h5uifilemesh.as (43):warning:Label This variable is not defined, the engine could be the cause。
72 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/h5uifilemesh.as (43):warning:sort This variable is not defined, the engine could be the cause。
73 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/h5uifilemesh.as (43):warning:Category This variable is not defined, the engine could be the cause。
74 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/h5uifilemesh.as (43):warning:Tip This variable is not defined, the engine could be the cause。
75 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/h5uigroupmesh.as (37):warning:Editor This variable is not defined, the engine could be the cause。
76 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/h5uigroupmesh.as (37):warning:type This variable is not defined, the engine could be the cause。
77 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/h5uigroupmesh.as (37):warning:Label This variable is not defined, the engine could be the cause。
78 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/h5uigroupmesh.as (37):warning:sort This variable is not defined, the engine could be the cause。
79 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/h5uigroupmesh.as (37):warning:Category This variable is not defined, the engine could be the cause。
80 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/h5uigroupmesh.as (59):warning:Editor This variable is not defined, the engine could be the cause。
81 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/h5uigroupmesh.as (59):warning:type This variable is not defined, the engine could be the cause。
82 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/h5uigroupmesh.as (59):warning:Label This variable is not defined, the engine could be the cause。
83 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/h5uigroupmesh.as (59):warning:sort This variable is not defined, the engine could be the cause。
84 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/h5uigroupmesh.as (59):warning:Category This variable is not defined, the engine could be the cause。
85 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/h5uigroupmesh.as (59):warning:Tip This variable is not defined, the engine could be the cause。
86 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectgroupmesh.as (46):warning:Editor This variable is not defined, the engine could be the cause。
87 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectgroupmesh.as (46):warning:type This variable is not defined, the engine could be the cause。
88 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectgroupmesh.as (46):warning:Label This variable is not defined, the engine could be the cause。
89 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectgroupmesh.as (46):warning:sort This variable is not defined, the engine could be the cause。
90 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectgroupmesh.as (46):warning:Category This variable is not defined, the engine could be the cause。
91 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectgroupmesh.as (46):warning:Tip This variable is not defined, the engine could be the cause。
92 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectgroupmesh.as (62):warning:Editor This variable is not defined, the engine could be the cause。
93 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectgroupmesh.as (62):warning:type This variable is not defined, the engine could be the cause。
94 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectgroupmesh.as (62):warning:Label This variable is not defined, the engine could be the cause。
95 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectgroupmesh.as (62):warning:sort This variable is not defined, the engine could be the cause。
96 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectgroupmesh.as (62):warning:Category This variable is not defined, the engine could be the cause。
97 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfobuttonmesh.as (25):warning:Editor This variable is not defined, the engine could be the cause。
98 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfobuttonmesh.as (25):warning:type This variable is not defined, the engine could be the cause。
99 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfobuttonmesh.as (25):warning:Label This variable is not defined, the engine could be the cause。
100 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfobuttonmesh.as (25):warning:sort This variable is not defined, the engine could be the cause。
101 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfobuttonmesh.as (25):warning:Category This variable is not defined, the engine could be the cause。
102 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfobuttonmesh.as (25):warning:Data This variable is not defined, the engine could be the cause。
103 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfobuttonmesh.as (25):warning:Tip This variable is not defined, the engine could be the cause。
104 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfobuttonmesh.as (37):warning:Editor This variable is not defined, the engine could be the cause。
105 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfobuttonmesh.as (37):warning:type This variable is not defined, the engine could be the cause。
106 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfobuttonmesh.as (37):warning:Label This variable is not defined, the engine could be the cause。
107 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfobuttonmesh.as (37):warning:sort This variable is not defined, the engine could be the cause。
108 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfobuttonmesh.as (37):warning:changePath This variable is not defined, the engine could be the cause。
109 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfobuttonmesh.as (37):warning:Category This variable is not defined, the engine could be the cause。
110 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfobuttonmesh.as (51):warning:Editor This variable is not defined, the engine could be the cause。
111 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfobuttonmesh.as (51):warning:type This variable is not defined, the engine could be the cause。
112 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfobuttonmesh.as (51):warning:Label This variable is not defined, the engine could be the cause。
113 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfobuttonmesh.as (51):warning:sort This variable is not defined, the engine could be the cause。
114 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfobuttonmesh.as (51):warning:changePath This variable is not defined, the engine could be the cause。
115 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfobuttonmesh.as (51):warning:Category This variable is not defined, the engine could be the cause。
116 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfobuttonmesh.as (64):warning:Editor This variable is not defined, the engine could be the cause。
117 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfobuttonmesh.as (64):warning:type This variable is not defined, the engine could be the cause。
118 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfobuttonmesh.as (64):warning:Label This variable is not defined, the engine could be the cause。
119 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfobuttonmesh.as (64):warning:sort This variable is not defined, the engine could be the cause。
120 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfobuttonmesh.as (64):warning:Category This variable is not defined, the engine could be the cause。
121 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfobuttonmesh.as (64):warning:Tip This variable is not defined, the engine could be the cause。
122 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfobuttonmesh.as (78):warning:Editor This variable is not defined, the engine could be the cause。
123 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfobuttonmesh.as (78):warning:type This variable is not defined, the engine could be the cause。
124 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfobuttonmesh.as (78):warning:Label This variable is not defined, the engine could be the cause。
125 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfobuttonmesh.as (78):warning:sort This variable is not defined, the engine could be the cause。
126 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfobuttonmesh.as (78):warning:Category This variable is not defined, the engine could be the cause。
127 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfobuttonmesh.as (78):warning:Tip This variable is not defined, the engine could be the cause。
128 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfobuttonmesh.as (90):warning:Editor This variable is not defined, the engine could be the cause。
129 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfobuttonmesh.as (90):warning:type This variable is not defined, the engine could be the cause。
130 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfobuttonmesh.as (90):warning:Label This variable is not defined, the engine could be the cause。
131 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfobuttonmesh.as (90):warning:sort This variable is not defined, the engine could be the cause。
132 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfobuttonmesh.as (90):warning:Category This variable is not defined, the engine could be the cause。
133 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfopicturemesh.as (24):warning:Editor This variable is not defined, the engine could be the cause。
134 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfopicturemesh.as (24):warning:type This variable is not defined, the engine could be the cause。
135 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfopicturemesh.as (24):warning:Label This variable is not defined, the engine could be the cause。
136 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfopicturemesh.as (24):warning:sort This variable is not defined, the engine could be the cause。
137 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfopicturemesh.as (24):warning:changePath This variable is not defined, the engine could be the cause。
138 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfopicturemesh.as (24):warning:Category This variable is not defined, the engine could be the cause。
139 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfopicturemesh.as (37):warning:Editor This variable is not defined, the engine could be the cause。
140 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfopicturemesh.as (37):warning:type This variable is not defined, the engine could be the cause。
141 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfopicturemesh.as (37):warning:Label This variable is not defined, the engine could be the cause。
142 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfopicturemesh.as (37):warning:sort This variable is not defined, the engine could be the cause。
143 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfopicturemesh.as (37):warning:Category This variable is not defined, the engine could be the cause。
144 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfopicturemesh.as (37):warning:Tip This variable is not defined, the engine could be the cause。
145 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfopicturemesh.as (51):warning:Editor This variable is not defined, the engine could be the cause。
146 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfopicturemesh.as (51):warning:type This variable is not defined, the engine could be the cause。
147 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfopicturemesh.as (51):warning:Label This variable is not defined, the engine could be the cause。
148 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfopicturemesh.as (51):warning:sort This variable is not defined, the engine could be the cause。
149 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfopicturemesh.as (51):warning:Category This variable is not defined, the engine could be the cause。
150 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfopicturemesh.as (51):warning:Tip This variable is not defined, the engine could be the cause。
151 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfopicturemesh.as (63):warning:Editor This variable is not defined, the engine could be the cause。
152 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfopicturemesh.as (63):warning:type This variable is not defined, the engine could be the cause。
153 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfopicturemesh.as (63):warning:Label This variable is not defined, the engine could be the cause。
154 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfopicturemesh.as (63):warning:sort This variable is not defined, the engine could be the cause。
155 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelrectinfopicturemesh.as (63):warning:Category This variable is not defined, the engine could be the cause。
156 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelscenemesh.as (26):warning:Editor This variable is not defined, the engine could be the cause。
157 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelscenemesh.as (26):warning:type This variable is not defined, the engine could be the cause。
158 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelscenemesh.as (26):warning:Label This variable is not defined, the engine could be the cause。
159 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelscenemesh.as (26):warning:sort This variable is not defined, the engine could be the cause。
160 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelscenemesh.as (26):warning:Category This variable is not defined, the engine could be the cause。
161 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelscenemesh.as (26):warning:Tip This variable is not defined, the engine could be the cause。
162 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelscenemesh.as (38):warning:Editor This variable is not defined, the engine could be the cause。
163 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelscenemesh.as (38):warning:type This variable is not defined, the engine could be the cause。
164 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelscenemesh.as (38):warning:Label This variable is not defined, the engine could be the cause。
165 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelscenemesh.as (38):warning:sort This variable is not defined, the engine could be the cause。
166 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelscenemesh.as (38):warning:Category This variable is not defined, the engine could be the cause。
167 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/panelscenemesh.as (38):warning:Tip This variable is not defined, the engine could be the cause。
168 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/h5uifile9mesh.as (16):warning:Editor This variable is not defined, the engine could be the cause。
169 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/h5uifile9mesh.as (16):warning:type This variable is not defined, the engine could be the cause。
170 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/h5uifile9mesh.as (16):warning:Label This variable is not defined, the engine could be the cause。
171 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/h5uifile9mesh.as (16):warning:sort This variable is not defined, the engine could be the cause。
172 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/h5uifile9mesh.as (16):warning:Category This variable is not defined, the engine could be the cause。
173 file:///c:/users/pan/desktop/workspace/uieditor/src/mesh/h5uifile9mesh.as (16):warning:Tip This variable is not defined, the engine could be the cause。
*/