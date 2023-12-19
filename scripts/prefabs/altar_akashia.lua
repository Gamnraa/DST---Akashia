local assets = 
{
    Asset("ANIM", "anim/altar_akashia.zip")
}

local COOLDOWN = 20 --delay between uses by different players
local TIMEOUT = 10 --in case resurrection starts but never completes

local function ontimeout(inst)
    --In case haunt starts, but resurrection never activates
    --Could happen if player disconnects during resurrection
    inst._task = nil
    if inst.AnimState:IsCurrentAnimation("active") then
        inst.AnimState:PlayAnimation("active_pst")
        inst.AnimState:PushAnimation("inactive", true)
    end
end

local function onhaunt(inst, haunter)
    if not inst._task then
        inst.AnimState:PlayAnimation("active_pst")
        inst.AnimState:PushAnimation("inactive", true)
        inst._task = inst:DoTaskInTime(TIMEOUT, ontimeout)
        return true
    end
end

local function hasphysics(obj)
    return obj.Physics ~= nil
end

local function checkforghost(inst)
    if inst.components.rechargeablealtar:IsCharged() then
        local pos = inst:GetPosition()
        local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, TUNING.RESEARCH_MACHINE_DIST + 1, {"playerghost"})
        local isGhostNear = #ents > 0

        if inst.AnimState:IsCurrentAnimation("inactive") and isGhostNear then
            inst.AnimState:PlayAnimation("active_pre")
            inst.AnimState:PushAnimation("active", true)
        elseif inst.AnimState:IsCurrentAnimation("active") and not isGhostNear then
            inst.AnimState:PlayAnimation("active_pst")
            inst.AnimState:PushAnimation("inactive", true)
        end
    end
end

local function oncharged(inst)
    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_INSTANT_REZ)
    inst.components.hauntable:SetOnHauntFn(onhaunt)
end

local function onactivateresurrection(inst, target)
    if inst._task then
        inst._task:Cancel()
        inst._task = nil
    end
    TheWorld:PushEvent("ms_sendlightningstrike", inst:GetPosition())
    inst.components.rechargeablealtar:UseCharge()
    if not inst.components.rechargeablealtar:IsCharged() then
        inst:RemoveComponent("hauntable")
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()

    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1)
    inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.ITEMS)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)

    inst.AnimState:SetBank("altar_akashia")
    inst.AnimState:SetBuild("altar_akashia")
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("inactive", true)
    inst.AnimState:SetLayer(LAYER_WORLD)
    inst.AnimState:SetSortOrder(0)

    inst:AddTag("resurrector")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_INSTANT_REZ)
    inst.components.hauntable:SetOnHauntFn(onhaunt)

    inst:AddComponent("rechargeablealtar")
    inst.components.rechargeablealtar:SetAcceptedItems(TUNING.ALTAR_AKASHIA_ITEMS)
    inst.components.rechargeablealtar.onreceivechargefn = oncharged

    inst._task = nil

    inst:ListenForEvent("activateresurrection", onactivateresurrection)
    inst:DoPeriodicTask(.5, function(inst) checkforghost(inst) end)

    return inst
end
STRINGS.NAMES.ALTAR_AKASHIA = "Lunar Soul-Catcher"

return Prefab("altar_akashia", fn, assets)