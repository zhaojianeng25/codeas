//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------
package tempest.common.mvc.base {
	import flash.system.ApplicationDomain;
	import org.swiftsuspenders.Injector;
	import tempest.common.mvc.api.IInjector;

	public class TPInjector extends Injector implements IInjector {
		public function set parent(parentInjector:IInjector):void {
			this.parentInjector = parentInjector as TPInjector;
		}

		public function get parent():IInjector {
			return this.parentInjector as TPInjector;
		}

		public function createChild(applicationDomain:ApplicationDomain = null):IInjector {
			const childInjector:IInjector = new TPInjector();
			childInjector.applicationDomain = applicationDomain;
			childInjector.parent = this;
			return childInjector;
		}
	}
}
