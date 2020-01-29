class PSVis extends Mutator;

#exec TEXTURE IMPORT NAME=greyskin FILE="Textures\greyskin.bmp" MIPS=OFF

var PSVisDummy DummyList[64];

event PostBeginPlay() {
    local PlayerStart PS;
    local PSVisDummy D;
    local int i;

    super.PostBeginPlay();

    i = 0;
    foreach AllActors(class'PlayerStart', PS) {
        D = Spawn(class'PSVisDummy', none, '', PS.Location, PS.Rotation);
        D.SetCollision(false, false, false);
        D.SetCollisionSize(0,0);
        D.DrawType = DT_Mesh;
        D.Mesh = LodMesh'Botpack.Commando';
        D.Skin = texture'PSVis.greyskin';
        D.LoopAnim('Breath1');
        D.bAlwaysRelevant = true;

        DummyList[i] = D;
        i++;
        if (i >= 64) break;
    }

    SetTimer(1.0, true);
}

event Timer() {
    local int i;
    local DeathMatchPlus G;

    G = DeathMatchPlus(Level.Game);

    if ((G != none) && G.bNetReady == false && (G.bRequireReady == false || (G.CountDown <= 0))) {
        for (i = 0; i < 64; i++) {
            if (DummyList[i] == none)
                break;

            DummyList[i].DrawType = DT_None;
            DummyList[i].Destroy();
            DummyList[i] = none;
        }

        SetTimer(0.0, false);
    }
}
