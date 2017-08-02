var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var UIStage = (function (_super) {
    __extends(UIStage, _super);
    function UIStage() {
        _super.apply(this, arguments);
    }
    UIStage.prototype.interactiveEvent = function (e) {
        var evtType = e.type;
        var eventMap = this._eventsMap;
        if (!eventMap) {
            return;
        }
        var list = eventMap[evtType];
        if (!list) {
            return;
        }
        var length = list.length;
        if (length == 0) {
            return;
        }
        //for (var i: number = 0; i < length; i++) {
        //    var eventBin: any = list[i];
        //    eventBin.listener.call(eventBin.thisObject, e);
        //}
        for (var i = length - 1; i >= 0; i--) {
            var eventBin = list[i];
            eventBin.listener.call(eventBin.thisObject, e);
        }
    };
    return UIStage;
})(EventDispatcher);
//# sourceMappingURL=UIStage.js.map