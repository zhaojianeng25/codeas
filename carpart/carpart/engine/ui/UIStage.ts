class UIStage extends EventDispatcher {

    public interactiveEvent(e:InteractiveEvent): void {
        var evtType: string = e.type;

        var eventMap: Object = this._eventsMap;
        if (!eventMap) {
            return;
        }

        var list: Array<any> = eventMap[evtType];
        if (!list) {
            return;
        }

        var length: number = list.length;
        if (length == 0) {
            return;
        }

        //for (var i: number = 0; i < length; i++) {
        //    var eventBin: any = list[i];
        //    eventBin.listener.call(eventBin.thisObject, e);
        //}

        for (var i: number = length - 1; i >= 0; i--) {
            var eventBin: any = list[i];
            eventBin.listener.call(eventBin.thisObject, e);
        }
    }

}