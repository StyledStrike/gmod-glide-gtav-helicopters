AddCSLuaFile()

if not Glide then return end

ENT.GlideCategory = "GTAV_Helicopters"

ENT.Type = "anim"
ENT.Base = "base_glide_heli"
ENT.PrintName = "Cargobob"

ENT.MainRotorOffset = Vector( 175, 0, 120 )
ENT.TailRotorOffset = Vector( -215, 0, 140 )

if CLIENT then
    ENT.CameraOffset = Vector( -900, 0, 200 )

    ENT.ExhaustPositions = {
        Vector( 50, 55, 63 ),
        Vector( 50, -55, 63 )
    }

    ENT.EngineFireOffsets = {
        { offset = Vector( 175, 0, 120 ), angle = Angle( 300, 0, 0 ) },
        { offset = Vector( -215, 0, 140 ), angle = Angle( 300, 0, 0 ) }
    }

    ENT.StartSoundPath = "glide/helicopters/start_2.wav"
    ENT.TailSoundPath = ""

    ENT.EngineSoundPath = "glide/helicopters/jet_1.wav"
    ENT.EngineSoundLevel = 75
    ENT.EngineSoundVolume = 0.7

    ENT.JetSoundPath = "glide/helicopters/jet_3.wav"
    ENT.JetSoundLevel = 60
    ENT.JetSoundVolume = 0.3

    ENT.DistantSoundPath = "glide/helicopters/distant_loop_1.wav"

    ENT.RotorBeatInterval = 0.089

    ENT.BassSoundSet = "Glide.HeavyRotor.Bass"
    ENT.MidSoundSet = "Glide.HeavyRotor.Mid"
    ENT.HighSoundSet = "Glide.HeavyRotor.High"

    ENT.BassSoundVol = 1.0
    ENT.MidSoundVol = 0.6
    ENT.HighSoundVol = 0.75

    function ENT:GetCameraType( seatIndex )
        return seatIndex > 2 and Glide.CAMERA_TYPE.TURRET or Glide.CAMERA_TYPE.AIRCRAFT
    end
end

if SERVER then
    ENT.ChassisMass = 30000
    ENT.ChassisModel = "models/gta5/vehicles/cargobob/cargobob_body.mdl"
    ENT.SpawnPositionOffset = Vector( 0, 0, 80 )

    ENT.MainRotorRadius = 190
    ENT.TailRotorRadius = ENT.MainRotorRadius

    ENT.MainRotorModel = "models/gta5/vehicles/cargobob/cargobob_rmain_slow.mdl"
    ENT.MainRotorFastModel = "models/gta5/vehicles/cargobob/cargobob_rmain_fast.mdl"

    ENT.TailRotorModel = ENT.MainRotorModel
    ENT.TailRotorFastModel = ENT.MainRotorFastModel

    ENT.ExplosionGibs = { "models/gta5/vehicles/gibs/cargobob_gib.mdl" }

    ENT.AngularDrag = Vector( -20, -18, -30 )

    ENT.HelicopterParams = {
        pushUpForce = 300,
        pitchForce = 900,
        yawForce = 2000,
        rollForce = 1500,
        maxPitch = 40
    }

    function ENT:CreateFeatures()
        self:CreateSeat( Vector( 228, 24, -2 ), nil, Vector( 240, 120, -20 ), true )
        self:CreateSeat( Vector( 228, -24, -2 ), nil, Vector( 240, -120, -20 ), true )

        -- Rear-left seats
        self:CreateSeat( Vector( 140, 35, -22 ), Angle( 0, 180, 0 ), Vector( 140, 220, -20 ), true )
        self:CreateSeat( Vector( 110, 35, -22 ), Angle( 0, 180, 0 ), Vector( 110, 220, -20 ), true )
        self:CreateSeat( Vector( 80, 35, -22 ), Angle( 0, 180, 0 ), Vector( 80, 220, -20 ), true )

        -- Rear-right seats
        self:CreateSeat( Vector( 140, -35, -22 ), Angle( 0, 0, 0 ), Vector( 140, -220, -20 ), true )
        self:CreateSeat( Vector( 110, -35, -22 ), Angle( 0, 0, 0 ), Vector( 110, -220, -20 ), true )
        self:CreateSeat( Vector( 80, -35, -22 ), Angle( 0, 0, 0 ), Vector( 80, -220, -20 ), true )
    end

    DEFINE_BASECLASS( "base_glide_heli" )

    function ENT:Repair()
        BaseClass.Repair( self )

        -- All rotors on this vehicle spin on the Up axis, and have Angle(0,0,0) as the base angle.
        for i, rotor in ipairs( self.rotors ) do
            if IsValid( rotor ) then
                rotor:SetSpinAxis( "Up" )
                rotor.maxSpinSpeed = i > 1 and -2000 or 2000
            end
        end
    end
end
