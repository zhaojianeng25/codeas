module car {
    export class CarModule extends Module {
        public getModuleName(): string {
            return "CarModule";
        }
        protected listProcessors(): Array<Processor> {
            return [new CarProcessor()];
        }
    }
    export class CarEvent extends BaseEvent {
        public static INIT_CAR_SCENE: string = "INIT_CAR_SCENE";
        public static CAMMAND_INFO: string = "CAMMAND_INFO"
        public data: any;
    }
    export class CarProcessor extends BaseProcessor {

        public getName(): string {
            return "CarProcessor";
        }
        public constructor() {
            super();
            ProgrmaManager.getInstance().registe(LineDisplayShader.LineShader, new LineDisplayShader);
            TimeUtil.addFrameTick(() => { this.upData() });
            this.mechneItem = new Array
        }
        private mechneItem: Array<BaseMachine>;
        protected receivedModuleEvent($event: BaseEvent): void {
            if ($event instanceof CarEvent) {
                var evt: CarEvent = <CarEvent>$event;
                if (evt.type == CarEvent.INIT_CAR_SCENE) {
                    this.initCarScen(evt.data)
                }
                if (evt.type == CarEvent.CAMMAND_INFO) {
                    this.slectCammandInfo(String(evt.data))
                }
            }
        }
        private slectCammandInfo($str: string): void
        {
            switch ($str) {
                case "回到原点":
                    this.aotuCarMove.x = 0;
                    this.aotuCarMove.y = 10;
                    this.aotuCarMove.z = 0;

                    break
                case "走起":
                    this.aotuCarMove.tureOn()

                    break
                case "消除动":
                    this.aotuCarMove.tureOff()
                    this.mainCar.clearForce();

                    break
                case "点到点":
                    this.aotuCarMove.pointTopoint()

                    break
                case "停车":
                    this.aotuCarMove.playToParking()

                    break
                    
                default:
                    break
            }


        }
        private initCarScen($data: Array<any>): void {


            Physics.creatWorld();

            SceneConanManager.getInstance().makeGround(new Vector3D())
         //   SceneConanManager.getInstance().makeExpSceneCollisionItem($data);


        //    new Friction_html()

            this.mainCar=new CraneBaseSprite(-100,30,0)
            this.mechneItem.push(this.mainCar);

            Physics.ready = true;


           this.addAotuCars();
           // HeightFieldModel.getInstance().addField();
           Physics.world.defaultMaterial.friction=0.8
           console.log(Physics.world.defaultMaterial.friction);
            Scene_data.cam3D.distance=300
        }
        private mainCar: CraneBaseSprite;
        private aotuCarMove: AotuCar
        private addAotuCars(): void
        {

            
            var $vo: AotuCar = new AotuCar(0,10,0)
            this.mechneItem.push($vo);

            this.aotuCarMove = $vo;

            //for (var i: number = 0; i < 10;i++){
            //    var $vo: CarBodySprite = new CarBodySprite(random(300) - 150, random(80) +20, random(300) - 150)
            //    this.mechneItem.push($vo);
            //}

        }

        public upData(): void {
            Physics.update()
            for (var i: number = 0; i < this.mechneItem.length; i++) {
                this.mechneItem[i].upData()
            }
        }
        protected listenModuleEvents(): Array<BaseEvent> {
            return [
                new CarEvent(CarEvent.INIT_CAR_SCENE),
                new CarEvent(CarEvent.CAMMAND_INFO),

            ];
        }

    }


}