AddCSLuaFile()

if not Glide then return end

ENT.GlideCategory = "GTAV_Helicopters"

ENT.Type = "anim"
ENT.Base = "base_glide_plane_vtol"
ENT.PrintName = "Avenger"

ENT.MaxChassisHealth = 1500
ENT.VTOLTransitionTime = 3.5

DEFINE_BASECLASS( "base_glide_plane_vtol" )


if CLIENT then
    ENT.CameraOffset = Vector( -900, 0, 200 )

    ENT.StartSound = "glide/helicopters/start_2.wav"

    ENT.PropSoundPath = "gtav/avenger/prop.wav"
    ENT.PropSoundLevel = 85
    ENT.PropSoundVolume = 0.5
    ENT.PropSoundMinPitch = 50
    ENT.PropSoundMaxPitch = 90

    ENT.EngineSoundPath = "gtav/avenger/engine.wav"
    ENT.EngineSoundLevel = 85
    ENT.EngineSoundVolume = 0.3
    ENT.EngineSoundMinPitch = 90
    ENT.EngineSoundMaxPitch = 120

    ENT.ExhaustSoundPath = ""
    ENT.DistantSoundPath = ""

    ENT.BassSoundSet = "Glide.HeavyRotor.Bass"
    ENT.MidSoundSet = "Glide.HeavyRotor.Mid"
    ENT.HighSoundSet = "Glide.HeavyRotor.High"

    ENT.RotorBeatInterval = 0.089
    ENT.BassSoundVol = 0.4
    ENT.MidSoundVol = 0.2
    ENT.HighSoundVol = 0.5

    ENT.StrobeLights = {
        { offset = Vector( 235, 0, -88 ), blinkTime = 0 },
        { offset = Vector( -380, 139, 178 ), blinkTime = 0.1 }
    }

    function ENT:OnActivateMisc()
        BaseClass.OnActivateMisc( self )

        self.elevatorBone = self:LookupBone( "elevator" )
        self.aileronRBone = self:LookupBone( "aileron_r" )
        self.aileronLBone = self:LookupBone( "aileron_l" )
        self.rudderRBone = self:LookupBone( "rudder_r" )
        self.rudderLBone = self:LookupBone( "rudder_l" )
        self.boneEngineL = self:LookupBone( "engine_l" )
        self.boneEngineR = self:LookupBone( "engine_r" )
    end

    ENT.ExhaustPositions = { Vector(), Vector() }
    ENT.EngineFireOffsets = { { offset = Vector() }, { offset = Vector() } }

    local ang = Angle()

    function ENT:OnUpdateAnimations()
        if not self.boneEngineL then return end

        -- Update control surfaces
        ang[1] = 0
        ang[2] = 0
        ang[3] = self:GetElevator() * -15

        self:ManipulateBoneAngles( self.elevatorBone, ang )

        ang[1] = self:GetRudder() * 15
        ang[2] = 0
        ang[3] = 0

        self:ManipulateBoneAngles( self.rudderLBone, ang )
        self:ManipulateBoneAngles( self.rudderRBone, ang )

        local aileron = self:GetAileron()

        ang[1] = aileron * 1.1
        ang[2] = aileron * -1
        ang[3] = aileron * 15

        self:ManipulateBoneAngles( self.aileronRBone, ang )

        ang[1] = aileron * -0.3
        ang[2] = aileron * -1
        ang[3] = aileron * -15

        self:ManipulateBoneAngles( self.aileronLBone, ang )

        ang[1] = 0
        ang[2] = 0
        ang[3] = ( 1 - self:GetVerticalFlight() ) * 90

        self:ManipulateBoneAngles( self.boneEngineL, ang )
        self:ManipulateBoneAngles( self.boneEngineR, ang )

        -- Update exhaust/engine fire offsets using the position of the "engine" bones
        local m = self:GetBoneMatrix( self.boneEngineL )
        if not m then return end

        ang = m:GetAngles()

        local exhaustPositions = self.ExhaustPositions
        local fireOffsets = self.EngineFireOffsets

        local up = ang:Up()
        local rt = ang:Right()
        local fw = ang:Forward()

        exhaustPositions[1] = self:WorldToLocal( m:GetTranslation() + up * 30 + rt * 115 + fw * 30 )
        fireOffsets[1] = { offset = exhaustPositions[1], angle = ang }

        m = self:GetBoneMatrix( self.boneEngineR )
        up = ang:Up()
        rt = ang:Right()
        fw = ang:Forward()

        exhaustPositions[2] = self:WorldToLocal( m:GetTranslation() + up * 30 + rt * 115 - fw * 30 )
        fireOffsets[2] = { offset = exhaustPositions[2], angle = ang }
    end
end

if SERVER then
    ENT.ChassisMass = 10000
    ENT.ChassisModel = "models/gta5/vehicles/avenger/chassis.mdl"
    ENT.SpawnPositionOffset = Vector( 0, 0, 80 )
    ENT.HasLandingGear = true

    ENT.ExplosionGibs = {
        "models/gta5/vehicles/gibs/avenger_gib1.mdl",
        "models/gta5/vehicles/gibs/avenger_gib2.mdl",
        "models/gta5/vehicles/gibs/avenger_gib3.mdl",
        "models/gta5/vehicles/gibs/avenger_gib4.mdl",
        "models/gta5/vehicles/gibs/avenger_gib5.mdl",
        "models/gta5/vehicles/gibs/avenger_gib6.mdl"
    }

    ENT.AngularDrag = Vector( -20, -18, -30 )

    ENT.ReverseTorque = 4000
    ENT.MaxReverseSpeed = -300

    ENT.HelicopterParams = {
        pushUpForce = 200,
        pitchForce = 1200,
        yawForce = 2000,
        rollForce = 1500,
        maxPitch = 30,
        maxRoll = 50,
        maxForwardDrag = 1000,
        pushForwardForce = 0,
        uprightForce = 1200
    }

    ENT.PlaneParams = {
        liftAngularDrag = Vector( -50, -55, -40 ), -- (Roll, pitch, yaw)
        liftForwardDrag = 0.1,
        liftSideDrag = 3,

        liftFactor = 0.15,
        maxSpeed = 2000,
        liftSpeed = 1600,
        controlSpeed = 1400,

        engineForce = 250,
        alignForce = 300,

        pitchForce = 4000,
        yawForce = 2500,
        rollForce = 6500
    }

    function ENT:CreateFeatures()
        self:CreateSeat( Vector( 307, 28, -31 ), nil, Vector( 307, 140, -20 ), true )
        self:CreateSeat( Vector( 307, -28, -31 ), nil, Vector( 307, -140, -20 ), true )

        local wheelParams = {
            suspensionLength = 15,
            springStrength = 6000,
            springDamper = 40000,
            brakePower = 7000,
            sideTractionMultiplier = 850
        }

        -- Front
        wheelParams.steerMultiplier = 1
        self:CreateWheel( Vector( 340, 0, -80 ), wheelParams )

        -- Rear
        wheelParams.steerMultiplier = 0
        self:CreateWheel( Vector( -45, 87, -80 ), wheelParams ) -- left
        self:CreateWheel( Vector( -45, -87, -80 ), wheelParams ) -- right

        self:ChangeWheelRadius( 20 )

        for _, w in ipairs( self.wheels ) do
            Glide.HideEntity( w, true )
        end
    end

    function ENT:UpdateRotorPositions( transition )
        if IsValid( self.propR ) then
            local angles = self.propR.baseAngles
            angles[1] = 90 * ( 1 - transition )
            self.propR.offset = Vector( 101, -356, 80 + transition * 10 ) + angles:Up() * 110
        end

        if IsValid( self.propL ) then
            local angles = self.propL.baseAngles
            angles[1] = 90 * ( 1 - transition )
            self.propL.offset = Vector( 101, 356, 80 + transition * 10 ) + angles:Up() * 110
        end
    end

    local rotorSlowModel = "models/gta5/vehicles/avenger/rotor_slow.mdl"
    local rotorFastModel = "models/gta5/vehicles/avenger/rotor_fast.mdl"

    --- Override this base class function.
    function ENT:Repair()
        BaseClass.Repair( self )

        if not IsValid( self.propR ) then
            self.propR = self:CreatePropeller( Vector( 101, -356, 200 ), 290, rotorSlowModel, rotorFastModel )
            self.propR:SetSpinAxis( "Up" )
            self.propR:SetSpinAngle( math.random( 0, 180 ) )
            self.propR.maxSpinSpeed = 2500
        end

        if not IsValid( self.propL ) then
            self.propL = self:CreatePropeller( Vector( 101, 356, 200 ), 290, rotorSlowModel, rotorFastModel )
            self.propL:SetSpinAxis( "Up" )
            self.propL:SetSpinAngle( math.random( 0, 180 ) )
            self.propL.maxSpinSpeed = 2500
        end

        self:UpdateRotorPositions( self:GetVerticalFlight() )
    end

    --- Override this base class function.
    function ENT:OnPostThink( dt, selfTbl )
        BaseClass.OnPostThink( self, dt, selfTbl )

        if self:IsEngineOn() and not IsValid( selfTbl.propR ) or not IsValid( selfTbl.propL ) then
            self:TurnOff()
        end
    end
end
