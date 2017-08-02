var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var InteractiveEvent = (function (_super) {
    __extends(InteractiveEvent, _super);
    function InteractiveEvent() {
        _super.apply(this, arguments);
    }
    InteractiveEvent.Down = "down";
    InteractiveEvent.Up = "Up";
    InteractiveEvent.Move = "Move";
    InteractiveEvent.PinchStart = "PinchStart";
    InteractiveEvent.Pinch = "Pinch";
    return InteractiveEvent;
})(BaseEvent);
//# sourceMappingURL=InteractiveEvent.js.map