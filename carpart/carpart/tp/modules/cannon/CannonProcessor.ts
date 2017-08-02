module cannon {
    export class CannonModule extends Module {
        public getModuleName(): string {
            return "CannonModule";
        }
        protected listProcessors(): Array<Processor> {
            return [new CannonProcessor()];
        }
    }
    export class CannonEvent extends BaseEvent {
        public static INIT_CANNON_SCENE: string = "INIT_CANNON_SCENE";
        public data: any;
    }
    export class CannonProcessor extends BaseProcessor {

        public getName(): string {
            return "CannonProcessor";
        }
        public constructor() {
            super();
            ProgrmaManager.getInstance().registe(LineDisplayShader.LineShader, new LineDisplayShader);
            TimeUtil.addFrameTick(() => { this.upData() });
        }
        protected receivedModuleEvent($event: BaseEvent): void {
            if ($event instanceof CannonEvent) {
                var evt: CannonEvent = <CannonEvent>$event;
                if (evt.type == CannonEvent.INIT_CANNON_SCENE) {
                    this.initCannonScen(evt.data)
                }
            }
        }
        private initCannonScen($data:Array<any>): void {
       
            alert("here")
            Physics.creatWorld();
            SceneConanManager.getInstance().makeGround(new Vector3D())
            SceneConanManager.getInstance().makeExpSceneCollisionItem($data);
            new CraneBaseSprite();
            this.test()
            Physics.ready = true;

        }

        private test(): void
        {
    
           
      
            // Add contact material to the world
         //   Physics.world.addContactMaterial(ground_ground_cm);


            var size = 1;
            var boxShape = new CANNON.Box(new CANNON.Vec3(size, size, size));
            var sphereShape = new CANNON.Sphere(size);

            var mass = 5, boxMass = 1;

            // Kinematic Box
            // Does only collide with dynamic bodies, but does not respond to any force.
            // Its movement can be controlled by setting its velocity.
            var b2 = new CANNON.Body({
                mass: boxMass,
                position: new CANNON.Vec3(5, 0, 15),

       
            });
            b2.addShape(boxShape);
            var $disLock: CanonPrefabSprite = new CanonPrefabSprite(b2)
            $disLock.addToWorld();

            b2.velocity.set(1, 0, +10);

            var b1 = new CANNON.Body({
                mass: boxMass,
                position: new CANNON.Vec3(8, 0, 15),

            });
            b1.addShape(boxShape);
            var $disLock: CanonPrefabSprite = new CanonPrefabSprite(b1)
            $disLock.addToWorld();


        }
        public upData(): void
        {
            Physics.update()

        }
        protected listenModuleEvents(): Array<BaseEvent> {
            return [
                new CannonEvent(CannonEvent.INIT_CANNON_SCENE),
 
            ];
        }

    }


}