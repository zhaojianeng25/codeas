var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var car;
(function (car) {
    var CarModule = (function (_super) {
        __extends(CarModule, _super);
        function CarModule() {
            _super.apply(this, arguments);
        }
        CarModule.prototype.getModuleName = function () {
            return "CarModule";
        };
        CarModule.prototype.listProcessors = function () {
            return [new CarProcessor()];
        };
        return CarModule;
    })(Module);
    car.CarModule = CarModule;
    var CarEvent = (function (_super) {
        __extends(CarEvent, _super);
        function CarEvent() {
            _super.apply(this, arguments);
        }
        CarEvent.INIT_CAR_SCENE = "INIT_CAR_SCENE";
        CarEvent.CAMMAND_INFO = "CAMMAND_INFO";
        return CarEvent;
    })(BaseEvent);
    car.CarEvent = CarEvent;
    var CarProcessor = (function (_super) {
        __extends(CarProcessor, _super);
        function CarProcessor() {
            var _this = this;
            _super.call(this);
            ProgrmaManager.getInstance().registe(LineDisplayShader.LineShader, new LineDisplayShader);
            TimeUtil.addFrameTick(function () { _this.upData(); });
            this.mechneItem = new Array;
        }
        CarProcessor.prototype.getName = function () {
            return "CarProcessor";
        };
        CarProcessor.prototype.receivedModuleEvent = function ($event) {
            if ($event instanceof CarEvent) {
                var evt = $event;
                if (evt.type == CarEvent.INIT_CAR_SCENE) {
                    this.initCarScen(evt.data);
                }
                if (evt.type == CarEvent.CAMMAND_INFO) {
                    this.slectCammandInfo(String(evt.data));
                }
            }
        };
        CarProcessor.prototype.slectCammandInfo = function ($str) {
            switch ($str) {
                case "回到原点":
                    this.aotuCarMove.x = 0;
                    this.aotuCarMove.y = 10;
                    this.aotuCarMove.z = 0;
                    break;
                case "走起":
                    this.aotuCarMove.tureOn();
                    break;
                case "消除动":
                    this.aotuCarMove.tureOff();
                    this.mainCar.clearForce();
                    break;
                case "点到点":
                    this.aotuCarMove.pointTopoint();
                    break;
                case "停车":
                    this.aotuCarMove.playToParking();
                    break;
                default:
                    break;
            }
        };
        CarProcessor.prototype.initCarScen = function ($data) {
            Physics.creatWorld();
            SceneConanManager.getInstance().makeGround(new Vector3D());
            //   SceneConanManager.getInstance().makeExpSceneCollisionItem($data);
            //    new Friction_html()
            this.mainCar = new CraneBaseSprite(-100, 30, 0);
            this.mechneItem.push(this.mainCar);
            Physics.ready = true;
            this.addAotuCars();
            // HeightFieldModel.getInstance().addField();
            Physics.world.defaultMaterial.friction = 0.8;
            console.log(Physics.world.defaultMaterial.friction);
            Scene_data.cam3D.distance = 300;
        };
        CarProcessor.prototype.addAotuCars = function () {
            var $vo = new AotuCar(0, 10, 0);
            this.mechneItem.push($vo);
            this.aotuCarMove = $vo;
            //for (var i: number = 0; i < 10;i++){
            //    var $vo: CarBodySprite = new CarBodySprite(random(300) - 150, random(80) +20, random(300) - 150)
            //    this.mechneItem.push($vo);
            //}
        };
        CarProcessor.prototype.upData = function () {
            Physics.update();
            for (var i = 0; i < this.mechneItem.length; i++) {
                this.mechneItem[i].upData();
            }
        };
        CarProcessor.prototype.listenModuleEvents = function () {
            return [
                new CarEvent(CarEvent.INIT_CAR_SCENE),
                new CarEvent(CarEvent.CAMMAND_INFO),
            ];
        };
        return CarProcessor;
    })(BaseProcessor);
    car.CarProcessor = CarProcessor;
})(car || (car = {}));
//# sourceMappingURL=CarProcessor.js.map